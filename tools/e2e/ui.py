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
    for cand in list(n.iter("node")) + _ancetres(n):
        if cand is n:
            continue
        bc = parse_bounds(cand.get("bounds"))
        if bc and (bc[3] - bc[1]) >= 48 and (bc[2] - bc[0]) >= 48:
            return bc
    return b


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


def cmd_tap(args):
    if args.xy:
        x, y = map(int, args.xy.split(","))
        adb("shell", "input", "tap", str(x), str(y))
        print(f"E2E TAP_XY {x},{y}")
        return 0
    n = _wait(args)
    if n is None:
        return 1
    b = bounds_utiles(n)
    if not b or b == VIDE:
        # Compose expose parfois le TEXTE d'un bouton avec des bornes nulles
        # ([0,0][0,0]) : le rectangle réel est porté par un noeud frère. On prend
        # alors le dernier noeud cliquable PLEINE LARGEUR (le bouton d'action est
        # en bas d'un écran défilant). Constaté au run 42208901429.
        nodes, _ = dump_nodes()
        w, h = screen_size()
        candidats = []
        for m in nodes:
            if m.get("clickable") != "true":
                continue
            bb = parse_bounds(m.get("bounds"))
            if not bb or bb == VIDE:
                continue
            if (bb[2] - bb[0]) < w * 0.4:
                continue
            candidats.append(bb)
        if candidats:
            bb = max(candidats, key=lambda r: r[3])
            x, y = (bb[0] + bb[2]) // 2, (bb[1] + bb[3]) // 2
            adb("shell", "input", "tap", str(x), str(y))
            print(f"E2E TAP_FALLBACK_BAS {x},{y} (texte sans surface) bounds={bb}")
            return 0
        print(f"E2E FAIL element_sans_surface {n.get('text') or n.get('resource-id')}", file=sys.stderr)
        return 4
    x, y = (b[0] + b[2]) // 2, (b[1] + b[3]) // 2
    adb("shell", "input", "tap", str(x), str(y))
    print(f"E2E TAP {x},{y} -> {n.get('text') or n.get('resource-id')}")
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
