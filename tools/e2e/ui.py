#!/usr/bin/env python3
"""Pilotage de l'UI Android par ADB + uiautomator — laboratoire D42.13.

Aucune dépendance externe : uniquement `adb` et la bibliothèque standard.
Chaque commande écrit une ligne `E2E ...` sur stdout — ces lignes servent de
journal de preuve dans les artefacts GitHub Actions.

Commandes :
  probe                      affiche tous les noeuds (text / resource-id / bounds)
  wait   --text T | --id I   attend l'apparition (timeout)
  tap    --text T | --id I | --xy x,y
  inside --text T | --id I   vérifie que l'élément est ENTIÈREMENT dans l'écran
  shot   chemin.png          capture d'écran
  swipe  x1,y1,x2,y2 [ms]
  size                       taille d'écran déclarée par le système
"""
import argparse
import os
import re
import shutil
import subprocess
import sys
import time
import xml.etree.ElementTree as ET

DUMP_REMOTE = "/sdcard/window_dump.xml"


def resolve_adb():
    """adb n'est pas toujours sur le PATH du runner : on le cherche explicitement."""
    for base in ("ANDROID_SDK_ROOT", "ANDROID_HOME", "ANDROID_SDK"):
        root = os.environ.get(base)
        if root:
            cand = os.path.join(root, "platform-tools", "adb")
            if os.path.exists(cand):
                return cand
    found = shutil.which("adb")
    if found:
        return found
    for cand in ("/usr/local/lib/android/sdk/platform-tools/adb",
                 os.path.expanduser("~/Android/Sdk/platform-tools/adb")):
        if os.path.exists(cand):
            return cand
    raise SystemExit("E2E FATAL adb introuvable (PATH=" + os.environ.get("PATH", "") + ")")


_ADB_CACHE = []


def adb_bin():
    if not _ADB_CACHE:
        _ADB_CACHE.append(resolve_adb())
    return _ADB_CACHE[0]


def adb(*args, timeout=180):
    return subprocess.run([adb_bin(), *args], capture_output=True, text=True,
                          timeout=timeout, errors="replace")


def adb_bytes(*args, timeout=180):
    """Sortie BINAIRE d'adb (screencap raw) — text=True corromprait les octets."""
    return subprocess.run([adb_bin(), *args], capture_output=True,
                          timeout=timeout).stdout


# OrangeStore du design system (vérifié sur captures : 249, 92, 15)
_ORANGE = (249, 92, 15)


def bande_orange_basse():
    """Détecte la bande orange pleine largeur la plus basse de l'écran.

    D42.26-13 : uiautomator expose parfois les boutons Compose avec des bounds
    VIDES ([0,0][0,0], variante small) alors que le bouton EST rendu à sa place
    (prouvé par analyse pixel des captures : bande orange y 786-845 sur
    540x960, y 2043-2152 sur 1080x2340). Le dump étant inexploitable, on lit
    directement le screencap RAW (aucune dépendance : header u32 w/h[/cs]/fmt
    + pixels RGBA). Renvoie (w, h, y_haut, y_bas) ou None.
    """
    import struct
    raw = adb_bytes("exec-out", "screencap")
    if not raw or len(raw) < 64:
        return None
    w0, h0 = struct.unpack_from("<II", raw, 0)
    if not (0 < w0 <= 4096 and 0 < h0 <= 4096):
        return None
    n = w0 * h0 * 4
    base = None
    for off in (12, 16, 20):
        if len(raw) == off + n:
            base = off
            break
    if base is None:  # format inattendu : tenter quand même 16
        base = 16
    w, h = w0, h0
    xs = list(range(0, w, 6))
    seuil = len(xs) * 0.6

    def scan(ordre_rgb):
        rows = []
        for y in range(h - 1, -1, -1):
            o = base + y * w * 4
            cnt = 0
            for x in xs:
                i = o + x * 4
                px = raw[i:i + 3]
                if ordre_rgb:
                    r, g, b = px[0], px[1], px[2]
                else:
                    b, g, r = px[0], px[1], px[2]
                if abs(r - _ORANGE[0]) < 45 and abs(g - _ORANGE[1]) < 55 \
                        and abs(b - _ORANGE[2]) < 55:
                    cnt += 1
            if cnt >= seuil:
                rows.append(y)
            elif rows:
                break  # la bande est dépassée (scan depuis le bas)
        return rows

    for ordre in (True, False):  # RGBA puis BGRA selon pilote
        rows = scan(ordre)
        if rows:
            return w, h, min(rows), max(rows)
    return None


def cmd_taporange(args):
    """Tape le bouton d'action principal (bande orange la plus basse).

    Secours du `tap --text` quand uiautomator ne localise pas le bouton
    Compose (bounds vides) : le tap texte n'a alors AUCUN point où frapper.
    """
    b = bande_orange_basse()
    if not b:
        print("E2E FAIL bande_orange_absente (aucune bande pleine largeur OrangeStore)",
              file=sys.stderr)
        return 4
    w, h, y0, y1 = b
    if y1 - y0 < 20:
        print(f"E2E FAIL bande_orange_trop_fine y={y0}..{y1}", file=sys.stderr)
        return 4
    x, y = w // 2, (y0 + y1) // 2
    adb("shell", "input", "tap", str(x), str(y))
    print(f"E2E TAPORANGE {x},{y} (bande y {y0}..{y1})")
    return 0


def screen_size():
    out = adb("shell", "wm", "size").stdout
    m = re.search(r"Override size:\s*(\d+)x(\d+)", out) or re.search(r"Physical size:\s*(\d+)x(\d+)", out)
    return (int(m.group(1)), int(m.group(2))) if m else (0, 0)


_PARENT = {}


_FENETRE = [0, 0]


def fenetre():
    """Rectangle réel de la fenêtre applicative (tient compte de la rotation)."""
    return tuple(_FENETRE) if _FENETRE[0] else screen_size()


def dump_nodes(retries=3):
    for _ in range(retries):
        # D42.16 (défaut H10, runs 42278038365 et 42281822052) : quand la thread
        # UI de l'app est saturée, `uiautomator dump` échoue EN SILENCE et le
        # fichier distant garde l'ANCIEN arbre — le `cat` rendait alors un écran
        # périmé et le harnais est resté aveugle du bind caméra à la fin du run
        # (6 dumps consécutifs au md5 identique, verdicts fantômes). On SUPPRIME
        # le fichier AVANT de dumper : un dump raté rend du vide, jamais l'écran
        # d'avant.
        adb("shell", "rm", "-f", DUMP_REMOTE)
        adb("shell", "uiautomator", "dump", DUMP_REMOTE)
        xml = adb("exec-out", "cat", DUMP_REMOTE).stdout
        if xml and "<hierarchy" in xml:
            try:
                # ET refuse une *str* portant une déclaration d'encodage
                # (« Unicode strings with encoding declaration are not supported »).
                # On retire la déclaration avant de parser.
                propre = re.sub(r"^<\?xml[^>]*\?>", "", xml).strip()
                root = ET.fromstring(propre)
                premier = root.find(".//node")
                b0 = parse_bounds((premier.get("bounds") if premier is not None else None) or "")
                if b0 and b0[2] > 0:
                    _FENETRE[0], _FENETRE[1] = b0[2], b0[3]
                _PARENT.clear()
                for parent in root.iter("node"):
                    for child in parent:
                        _PARENT[child] = parent
                return list(root.iter("node")), xml
            except (ET.ParseError, ValueError) as e:
                print(f"E2E dump_parse_error {e}", file=sys.stderr)
        time.sleep(1)
    # D42.16 (H10) : échec ASSUMÉ et journalisé — jamais d'arbre périmé.
    print("E2E DUMP_FAIL aucun dump frais obtenu", file=sys.stderr)
    return [], ""


def parse_bounds(b):
    m = re.match(r"\[(-?\d+),(-?\d+)\]\[(-?\d+),(-?\d+)\]", b or "")
    if not m:
        return None
    x1, y1, x2, y2 = map(int, m.groups())
    return x1, y1, x2, y2


VIDE = (0, 0, 0, 0)


def bounds_utiles(n):
    """Compose expose des noeuds de regroupement à [0,0][0,0] qui portent le texte
    mais AUCUNE surface. Le vrai rectangle est sur le PARENT cliquable.
    Sans cette fusion, `inside` concluait « hors écran » sur un bouton pourtant
    visible — constaté au run 42179104681 (S10/S11)."""
    b = parse_bounds(n.get("bounds"))
    if b and b != VIDE:
        return b
    for c in n.iter("node"):
        if c is n:
            continue
        bc = parse_bounds(c.get("bounds"))
        if bc and bc != VIDE:
            return bc
    cur = _PARENT.get(n)
    while cur is not None:
        bc = parse_bounds(cur.get("bounds"))
        if bc and bc != VIDE:
            return bc
        cur = _PARENT.get(cur)
    return b


def surface_reelle(n):
    """Rectangle exploitable pour juger la VISIBILITÉ.

    uiautomator rapporte parfois le texte d'un bouton Compose tronqué à 1 px de
    haut ([455,2071][625,2072]) alors que le bouton est peint en entier. On prend
    donc, si la boîte du texte est dégénérée (< 24 px de haut), la boîte du
    premier ancêtre/descendant cliquable nettement plus grande."""
    b = bounds_utiles(n)
    if not b:
        return None
    if (b[3] - b[1]) >= 24 and (b[2] - b[0]) >= 24:
        return b
    fw, fh = fenetre()

    def utilisable(bc):
        """Ni la racine, ni un conteneur plein écran : un vrai bouton."""
        if not bc or (bc[3] - bc[1]) < 48 or (bc[2] - bc[0]) < 48:
            return False
        if fw and fh and (bc[2] - bc[0]) >= fw * 0.95 and (bc[3] - bc[1]) >= fh * 0.9:
            return False   # la fenêtre entière : son centre est le MILIEU DE L'ÉCRAN
        return True

    candidats = [c for c in (list(n.iter("node")) + _ancetres(n)) if c is not n]
    # 1) un ancêtre/descendant explicitement cliquable (cas Compose réel) ;
    for cand in candidats:
        if cand.get("clickable") == "true":
            bc = parse_bounds(cand.get("bounds"))
            if utilisable(bc):
                return bc
    # 2) à défaut, le plus petit conteneur exploitable (jamais la racine).
    tailles = []
    for cand in candidats:
        bc = parse_bounds(cand.get("bounds"))
        if utilisable(bc):
            tailles.append(((bc[2] - bc[0]) * (bc[3] - bc[1]), bc))
    if tailles:
        return min(tailles)[1]
    return None


def _ancetres(n):
    out, cur = [], _PARENT.get(n)
    while cur is not None:
        out.append(cur)
        cur = _PARENT.get(cur)
    return out


def find(nodes, text=None, rid=None, exact=False):
    """Recherche un noeud.

    PIEGE CORRIGE EN D42.14 : la comparaison était une SOUS-CHAINE.
    « Continuer » correspondait donc à « Continuer sans compte » — le harnais
    a tapé le bouton de repli de l'écran d'authentification puis a déclaré
    PASS alors que l'écran suivant n'était jamais arrivé (run 42189554849).
    `exact=True` compare le libellé entier, après normalisation des espaces.
    """
    def norm(v):
        return " ".join((v or "").split()).lower()
    cible = norm(text) if text is not None else None
    for n in nodes:
        t = n.get("text") or ""
        r = n.get("resource-id") or ""
        if cible is not None:
            if exact:
                if norm(t) == cible:
                    return n
            elif cible in norm(t):
                return n
        if rid is not None and rid in r:
            return n
    return None


def describe(n):
    b = bounds_utiles(n)
    return f'text="{n.get("text")}" id="{n.get("resource-id")}" bounds={b} clickable={n.get("clickable")}'


def cmd_probe(args):
    print(f"E2E adb={adb_bin()}")
    nodes, _ = dump_nodes()
    w, h = screen_size()
    print(f"E2E screen={w}x{h} nodes={len(nodes)}")
    for n in nodes:
        if (n.get("text") or "").strip() or (n.get("resource-id") or "").strip():
            print("E2E node " + describe(n))
    return 0


def cmd_size(args):
    w, h = screen_size()
    print(f"E2E screen={w}x{h}")
    return 0 if w and h else 1


def _wait(args, must=True, keep=None):
    deadline = time.time() + args.timeout
    last = None
    while time.time() < deadline:
        nodes, _ = dump_nodes()
        if keep is not None:
            keep[0] = nodes
        n = find(nodes, args.text, args.id, exact=getattr(args, "exact", False))
        if n is not None:
            print("E2E FOUND " + describe(n))
            return n
        last = len(nodes)
        time.sleep(1.5)
    msg = (f"E2E TIMEOUT text={args.text} id={args.id} exact={getattr(args,'exact',False)} "
           f"after {args.timeout}s (nodes={last})")
    print(msg, file=sys.stderr if must else sys.stdout)
    return None


def cmd_wait(args):
    # PIEGE ElementTree : un Element SANS ENFANT est *faux* en Python.
    # `if _wait(args)` renvoyait donc 1 (échec) même quand le noeud était trouvé.
    # C'est la cause racine des S03/S09/S14/S17 en échec au run 42177202362.
    return 0 if _wait(args) is not None else 1



def point_de_clic(nodes, n, w, h):
    """Point (x, y) où taper pour activer `n`, et la façon dont il a été choisi.

    Trois cas, dans cet ordre (on regarde d'ABORD les bornes propres du nœud,
    jamais celles d'un ancêtre : sinon un texte à [0,0][0,0] hérite du rectangle
    de la racine et l'on tape au milieu de l'écran) :

      1. "direct"    — bornes propres franches (>= 24 px) ;
      2. "surface"   — bornes propres DÉGÉNÉRÉES (1 px de haut) : Compose expose
                       parfois le texte d'un bouton dans [455,2071][625,2072]
                       (run 42223776656). Taper ce centre tombait sur le bord de
                       la fenêtre : aucun effet, sans erreur. On reprend la
                       surface réelle du parent cliquable ;
      3. "bas_large" — bornes propres nulles ([0,0][0,0], run 42208901429) :
                       dernier nœud cliquable pleine largeur = bouton d'action.
    Renvoie (x, y, mode) ou (None, None, "aucun").
    """
    propre = parse_bounds(n.get("bounds"))
    if propre and propre != VIDE:
        largeur, hauteur = propre[2] - propre[0], propre[3] - propre[1]
        if hauteur >= 24 and largeur >= 24:
            # D42.26-15 (small, run 42528862955) : uiautomator expose parfois
            # un texte de bouton avec les BOUNDS DU CONTENT ENTIER
            # (« Continuer » bounds=(0,145,540,752)) : le mode direct tapait
            # le centre de l'écran — au milieu de la grille des cartes, pas
            # sur le bouton. Même garde que surface_reelle/utilisable() :
            # un rectangle couvrant ~toute la fenêtre n'est pas un bouton.
            fw, fh = fenetre()
            if fw and fh and largeur >= fw * 0.95 and hauteur >= fh * 0.9:
                surf = surface_reelle(n)
                if surf and surf != VIDE and (surf[3] - surf[1]) >= 24 and (surf[2] - surf[0]) >= 24:
                    return (surf[0] + surf[2]) // 2, (surf[1] + surf[3]) // 2, "surface"
                # sinon : tomber sur bas_large ci-dessous (ne pas taper le
                # centre de l'écran).
            else:
                return (propre[0] + propre[2]) // 2, (propre[1] + propre[3]) // 2, "direct"
        surf = surface_reelle(n)
        if surf and surf != VIDE and (surf[3] - surf[1]) >= 24 and (surf[2] - surf[0]) >= 24:
            return (surf[0] + surf[2]) // 2, (surf[1] + surf[3]) // 2, "surface"
    candidats = []
    for m in nodes or []:
        if m.get("clickable") != "true":
            continue
        bb = parse_bounds(m.get("bounds"))
        if not bb or bb == VIDE:
            continue
        if w and (bb[2] - bb[0]) < w * 0.4:
            continue
        if h and (bb[2] - bb[0]) >= w * 0.95 and (bb[3] - bb[1]) > h * 0.9:
            continue  # la racine n'est pas un bouton
        candidats.append(bb)
    if candidats:
        bb = max(candidats, key=lambda r: r[3])
        return (bb[0] + bb[2]) // 2, (bb[1] + bb[3]) // 2, "bas_large"
    return None, None, "aucun"


def cmd_tap(args):
    if args.xy:
        x, y = map(int, args.xy.split(","))
        adb("shell", "input", "tap", str(x), str(y))
        print(f"E2E TAP_XY {x},{y}")
        return 0
    n = _wait(args)
    if n is None:
        return 1
    nodes, _ = dump_nodes()
    w, h = screen_size()
    # PIEGE CORRIGE EN D42.14 : `n` vient du dump fait par _wait(), `nodes` d'un
    # dump PLUS RÉCENT. ElementTree compare les éléments par identité : le noeud
    # et sa table de parents ne se correspondaient pas, donc `surface_reelle()`
    # ne trouvait aucun ancêtre et le mode « surface » était MORT — on retombait
    # toujours sur « bas_large », qui choisit le dernier élément cliquable pleine
    # largeur… c'est-à-dire la barre de navigation en bas de l'écran, pas le
    # bouton d'action. On ré-ancre la cible dans le dump courant.
    if nodes:
        n_courant = find(nodes, args.text, args.id, exact=getattr(args, "exact", False))
        if n_courant is not None:
            n = n_courant
    x, y, mode = point_de_clic(nodes, n, w, h)
    if x is None:
        print(f"E2E FAIL element_sans_surface {n.get('text') or n.get('resource-id')}", file=sys.stderr)
        return 4
    adb("shell", "input", "tap", str(x), str(y))
    print(f"E2E TAP {x},{y} [{mode}] -> {n.get('text') or n.get('resource-id')}")
    return 0


def _clickable_parent(nodes, target):
    """Compose expose le texte et le clic sur deux noeuds : on remonte au parent."""
    parent = {}
    for n in nodes:
        for c in n:
            parent[c] = n
    cur = target
    while cur in parent:
        cur = parent[cur]
        if cur.get("clickable") == "true":
            return "true (parent)"
    return "false"


def cmd_inside(args):
    """Vérifie qu'un élément est entièrement visible (aucune partie hors écran)."""
    nodes_ref = [None]
    n = _wait(args, keep=nodes_ref)
    if n is None:
        print("E2E FAIL element_absent", file=sys.stderr)
        return 2
    w, h = screen_size()
    b = surface_reelle(n)
    label = n.get("text") or n.get("resource-id")
    if not b or b == VIDE:
        print(f"E2E INSIDE {label!r} bounds=VIDE => FAIL_SANS_SURFACE", file=sys.stderr)
        return 4
    x1, y1, x2, y2 = b
    # marge de 2 px : un pixel d'arrondi ne doit pas faire échouer un bouton visible
    inside = x1 >= -2 and y1 >= -2 and x2 <= w + 2 and y2 <= h + 2 and (y2 - y1) > 8
    print(f"E2E INSIDE {label!r} bounds=({x1},{y1},{x2},{y2}) fenetre=({w},{h}) => "
          f"{'PASS' if inside else 'FAIL_HORS_ECRAN'}")
    # Vérifie aussi que l'élément est cliquable (le bouton épinglé doit l'être)
    clickable = "true" if n.get("clickable") == "true" else _clickable_parent(nodes_ref[0], n)
    print(f"E2E CLICKABLE {label!r} => {clickable}")
    return 0 if inside else 3


def cmd_gone(args):
    """Attend la DISPARITION d'un libellé.

    Nécessaire pour distinguer « l'écran a changé » de « le libellé existe encore
    ailleurs ». Sans ce contrôle, un `tap` peut réussir sur un noeud de l'écran
    PRÉCÉDENT et l'on croit être passé à l'étape suivante (run 42189554849).
    """
    deadline = time.time() + args.timeout
    while time.time() < deadline:
        nodes, _ = dump_nodes()
        if find(nodes, args.text, args.id, exact=getattr(args, "exact", False)) is None:
            print(f"E2E GONE text={args.text} id={args.id}")
            return 0
        time.sleep(1.5)
    print(f"E2E STILL_PRESENT text={args.text} id={args.id} after {args.timeout}s")
    return 1


def cmd_fields(args):
    """Liste les champs de saisie visibles avec leurs coordonnées.

    Indispensable au brief : `adb shell input text` doit viser un champ
    réellement focusé, sinon la saisie part dans le vide (constaté au run
    42202009301, où un seul champ avait reçu un mot).
    """
    nodes, _ = dump_nodes()
    i = 0
    for n in nodes:
        if (n.get("class") or "").endswith("EditText"):
            b = parse_bounds(n.get("bounds"))
            if b and b != VIDE:
                etat = "rempli" if (n.get("text") or "").strip() else "vide"
                print(f"E2E FIELD {i} {b[0]} {b[1]} {b[2]} {b[3]} {etat}")
                i += 1
    print(f"E2E FIELDS {i}")
    return 0 if i else 1


def cmd_champs(args):
    """Liste les champs de saisie AVEC LEUR LIBELLÉ (le texte juste au-dessus).

    L'index seul ne suffit pas : quand l'écran défile pendant la saisie, l'ordre
    des champs visibles change et les valeurs atterrissent dans le mauvais champ
    (constaté au run 42223776656 — « AkpakpaCotonou » est allé dans « Prix »).
    En connaissant le libellé, le harnais peut choisir une valeur VALIDE.
    """
    nodes, _ = dump_nodes()
    textes = []
    champs = []
    for n in nodes:
        b = parse_bounds(n.get("bounds"))
        t = (n.get("text") or "").strip()
        cls = n.get("class") or ""
        if not b or b == VIDE:
            continue
        if cls.endswith("EditText"):
            champs.append((b, t))
        elif t:
            textes.append((b, t))
    i = 0
    for b, t in champs:
        candidats = [(b[1] - tb[3], tb, tt) for tb, tt in textes
                     if tb[3] <= b[1] + 4 and len(tt) < 60 and tb[1] < b[1]]
        label = ""
        if candidats:
            candidats.sort(key=lambda c: c[0])
            label = candidats[0][2]
        etat = "rempli" if t.strip() else "vide"
        print(f'E2E CHAMP {i} {b[0]} {b[1]} {b[2]} {b[3]} {etat} |{label}|')
        i += 1
    print(f"E2E CHAMPS {i}")
    return 0 if i else 1


def cmd_shot(args):
    with open(args.path, "wb") as f:
        p = subprocess.run([adb_bin(), "exec-out", "screencap", "-p"], stdout=f, timeout=180)
    ok = p.returncode == 0
    print(f"E2E SHOT {args.path} {'OK' if ok else 'ECHEC'}")
    return 0 if ok else 1


def cmd_swipe(args):
    x1, y1 = map(int, args.start.split(","))
    x2, y2 = map(int, args.end.split(","))
    adb("shell", "input", "swipe", str(x1), str(y1), str(x2), str(y2), str(args.ms))
    print(f"E2E SWIPE {x1},{y1}->{x2},{y2} {args.ms}ms")
    return 0


def build_parser():
    p = argparse.ArgumentParser(description="Pilotage UI Android (D42.13)")
    sub = p.add_subparsers(dest="cmd", required=True)

    def cible(sp):
        sp.add_argument("--text")
        sp.add_argument("--id")
        sp.add_argument("--timeout", type=int, default=25)
        sp.add_argument("--exact", action="store_true",
                        help="libellé entier (évite « Continuer » ⊂ « Continuer sans compte »)")
        return sp

    sub.add_parser("probe").set_defaults(func=cmd_probe)
    sub.add_parser("fields").set_defaults(func=cmd_fields)
    sub.add_parser("champs").set_defaults(func=cmd_champs)
    sub.add_parser("size").set_defaults(func=cmd_size)

    cible(sub.add_parser("wait")).set_defaults(func=cmd_wait)

    t = cible(sub.add_parser("tap"))
    t.add_argument("--xy")
    t.set_defaults(func=cmd_tap)

    sub.add_parser("taporange").set_defaults(func=cmd_taporange)

    cible(sub.add_parser("inside")).set_defaults(func=cmd_inside)
    cible(sub.add_parser("gone")).set_defaults(func=cmd_gone)

    sh = sub.add_parser("shot")
    sh.add_argument("path")
    sh.set_defaults(func=cmd_shot)

    sw = sub.add_parser("swipe")
    sw.add_argument("start")
    sw.add_argument("end")
    sw.add_argument("--ms", type=int, default=300)
    sw.set_defaults(func=cmd_swipe)
    return p


if __name__ == "__main__":
    a = build_parser().parse_args()
    sys.exit(a.func(a))
