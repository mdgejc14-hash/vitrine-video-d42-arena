#!/usr/bin/env python3
"""Autotest du harnais E2E — sans appareil, sans émulateur.

Pourquoi : les runs 42208901429, 42219775013, 42223776656 et 42228009767 ont
tous échoué sur la MÊME zone (brief -> caméra) sans que l'on sache si c'est
l'application ou le harnais qui se trompe. Un harnais qui ne sait pas échouer
est aussi dangereux qu'un test qui ne tourne pas : il produit des verts faux.

Ce script remplace `adb` par un faux `adb` (dans un dossier temporaire, placé en
tête de PATH) qui sert des arbres UIAutomator préparés, et vérifie que `ui.py`
— le VRAI fichier utilisé par la CI — se comporte correctement dans quatre
situations connues :

  S1  bouton exposé en 1 px de haut          -> tap au centre de la SURFACE réelle
  S2  libellé absent                          -> `wait` échoue (aucun faux vert)
  S3  caméra : le libellé ne bascule jamais   -> `wait` échoue (échec détecté)
  S4  bouton absent                           -> `tap` échoue, AUCUN tap émis

Ce que ce script prouve : le harnais distingue le succès de l'échec.
Ce qu'il ne prouve PAS : que l'application fonctionne (cela demande un appareil).

Usage : python3 tools/e2e/selftest_harness.py [-v]
Sortie : liste PASS/FAIL + code retour = nombre d'échecs.
"""
import os
import shutil
import subprocess
import sys
import tempfile
import textwrap

RACINE = os.path.dirname(os.path.abspath(__file__))
UI = os.path.join(RACINE, "ui.py")
VERBEUX = "-v" in sys.argv

FAUX_ADB = textwrap.dedent('''\
    #!/usr/bin/env python3
    """Faux adb : sert un arbre UIAutomator préparé, journalise les tap/swipe."""
    import os, sys
    XML = os.environ["FAKE_XML"]
    LOG = os.environ["FAKE_LOG"]
    a = sys.argv[1:]
    def log(l):
        with open(LOG, "a") as f:
            f.write(l + "\\n")
    if a[:2] == ["shell", "wm"]:
        print("Physical size: 1080x2340")
        sys.exit(0)
    if a[:1] == ["shell"] and a[1:2] == ["rm"]:
        # D42.16 (H10) : le harnais supprime le dump distant AVANT de dumper —
        # un dump raté doit rendre du vide, jamais l'arbre périmé.
        with open(LOG + ".state", "w") as f:
            f.write("gone")
        sys.exit(0)
    if a[:2] == ["shell", "uiautomator"]:
        # FAKE_DUMP_CASSE simule un `uiautomator dump` qui ÉCHOUE en silence
        # (thread UI de l'app saturée, cas réel des runs 42278038365/42281822052) :
        # le fichier distant n'est PAS réécrit.
        if not os.environ.get("FAKE_DUMP_CASSE"):
            with open(LOG + ".state", "w") as f:
                f.write("ok")
        sys.exit(0)
    if a[:3] == ["exec-out", "cat", "/sdcard/window_dump.xml"] or (a[:1] == ["exec-out"] and a[1:2] == ["cat"]):
        etat = LOG + ".state"
        if os.path.exists(etat) and open(etat).read().strip() == "gone":
            sys.exit(0)   # fichier distant absent : cat rend VIDE
        sys.stdout.write(open(XML).read())
        sys.exit(0)
    if a[:1] == ["shell"] and a[1:3] == ["input", "tap"]:
        log("TAP %s %s" % (a[3], a[4]))
        sys.exit(0)
    if a[:1] == ["shell"] and a[1:3] == ["input", "swipe"]:
        log("SWIPE " + " ".join(a[3:]))
        sys.exit(0)
    if a[:2] == ["exec-out", "screencap"]:
        sys.stdout.buffer.write(b"\\x89PNG\\r\\n\\x1a\\n")
        sys.exit(0)
    sys.exit(0)
''')


def bouton_compose(texte, rid, surface="[44,1978][1036,2072]", texte_bounds="[455,2071][625,2072]"):
    """Structure réelle de Compose : le TEXTE (1 px) est enfant du bouton cliquable."""
    return (f'<node text="" resource-id="{rid}" class="android.widget.Button" '
            f'bounds="{surface}" clickable="true">'
            f'<node text="{texte}" resource-id="" class="android.widget.TextView" '
            f'bounds="{texte_bounds}" clickable="false"/></node>')


def arbre(*noeuds):
    corps = "".join(noeuds)
    return (f'<?xml version="1.0" encoding="UTF-8"?><hierarchy rotation="0">'
            f'<node text="" resource-id="" class="android.widget.FrameLayout" '
            f'bounds="[0,0][1080,2340]" clickable="false">{corps}</node></hierarchy>')


def bouton1px(texte):
    """Ce que Compose expose réellement : le texte fait 1 px de haut, la surface
    cliquable est le parent — c'est la cause du blocage du brief (run 42223776656)."""
    return (f'<node text="{texte}" resource-id="" class="android.widget.TextView" '
            f'bounds="[455,2071][625,2072]" clickable="false"/>')


PARENT_BOUTON = ('<node text="" resource-id="btn_continuer" class="android.widget.Button" '
                 'bounds="[44,1978][1036,2072]" clickable="true"/>')

SANS_CONTINUER = ('<node text="Nom du vêtement *" resource-id="" class="android.widget.EditText" '
                  'bounds="[44,600][1036,700]" clickable="true"/>')

ECRAN_CAMERA = (
    '<node text="Enregistrer" resource-id="camera_record_button" class="android.widget.Button" '
    'bounds="[440,1900][640,2100]" clickable="true"/>'
)

ECRAN_CAMERA_SANS_BASCULE = ECRAN_CAMERA  # le libellé ne devient jamais « Arrêter et continuer »

# Écran réel : la barre de navigation est PLEINE LARGEUR et plus BASSE que le
# bouton d'action. C'est le piège du mode « bas_large ».
BARRE_NAV = ('<node text="" resource-id="nav_bar" class="android.widget.LinearLayout" '
             'bounds="[0,2230][1080,2340]" clickable="true"/>')


class Bac:
    def __init__(self, dossier):
        self.dossier = dossier
        self.xml = os.path.join(dossier, "dump.xml")
        self.log = os.path.join(dossier, "taps.log")
        self.bin = os.path.join(dossier, "bin")
        os.makedirs(self.bin, exist_ok=True)
        chemin = os.path.join(self.bin, "adb")
        with open(chemin, "w") as f:
            f.write(FAUX_ADB)
        os.chmod(chemin, 0o755)

    def planter(self, xml, log=""):
        with open(self.xml, "w") as f:
            f.write(xml)
        with open(self.log, "w") as f:
            f.write(log)

    def ui(self, *args, timeout=20, dump_casse=False):
        env = dict(os.environ)
        env["PATH"] = self.bin + os.pathsep + env.get("PATH", "")
        env["FAKE_XML"] = self.xml
        env["FAKE_LOG"] = self.log
        if dump_casse:
            env["FAKE_DUMP_CASSE"] = "1"
        # Les DEUX variables doivent être neutralisées : sur le runner GitHub,
        # ANDROID_SDK_ROOT pointe vers le vrai adb (mesuré, run 42239265944,
        # job harness-selftest) et le faux adb n'était alors jamais utilisé.
        env["ANDROID_HOME"] = "/inexistant"
        env["ANDROID_SDK_ROOT"] = "/inexistant"
        p = subprocess.run([sys.executable, UI, *args], capture_output=True,
                           text=True, env=env, timeout=timeout)
        avec = open(self.log).read() if os.path.exists(self.log) else ""
        return p.returncode, p.stdout + p.stderr, avec


def main():
    dossier = tempfile.mkdtemp(prefix="selftest-d42-")
    bac = Bac(dossier)
    resultats = []

    trace = []

    def verifier(nom, condition, detail):
        resultats.append((nom, condition, detail))
        print(f"{'PASS' if condition else 'FAIL'} {nom} :: {detail}")

    try:
        # --- S0 : le faux adb est bien celui que ui.py résout --------------------
        code, sortie, _ = bac.ui("probe", timeout=20)
        verifier("S0 le banc utilise bien le faux adb (pas celui du runner)",
                 code == 0 and f"{os.path.join(bac.bin, 'adb')}" in sortie,
                 (sortie.splitlines()[0] if sortie else "(aucune sortie)")[:80])

        # --- S1 : bornes dégénérées (1 px) -> tap sur la surface du parent -------
        bac.planter(arbre(bouton_compose("Continuer", "btn_continuer")))
        code, sortie, taps = bac.ui("tap", "--text", "Continuer", "--exact", "--timeout", "3")
        trace.append("S1 > " + sortie.strip().replace(chr(10), " | "))
        attendu = "TAP 540 2025"
        verifier("S1 bouton 1 px : tap au centre de la surface réelle",
                 code == 0 and attendu in taps and "[surface]" in sortie
                 and "540 1170" not in taps,
                 f"code={code} taps={taps.strip() or '-'}")

        # --- S2 : libellé absent -> wait DOIT échouer ----------------------------
        bac.planter(arbre(SANS_CONTINUER))
        code, sortie, taps = bac.ui("wait", "--text", "Continuer", "--exact", "--timeout", "2")
        verifier("S2 libellé absent : wait échoue (pas de faux vert)",
                 code != 0 and "TIMEOUT" in sortie, f"code={code}")

        # --- S3 : caméra sans bascule -> wait DOIT échouer ----------------------
        bac.planter(arbre(ECRAN_CAMERA_SANS_BASCULE))
        code, sortie, taps = bac.ui("wait", "--text", "Arrêter et continuer", "--exact", "--timeout", "2")
        verifier("S3 caméra muette : l'absence de bascule est DÉTECTÉE",
                 code != 0, f"code={code}")

        # --- S4 : bouton absent -> tap échoue ET n'émet aucun tap ---------------
        bac.planter(arbre(SANS_CONTINUER))
        code, sortie, taps = bac.ui("tap", "--text", "Partager", "--exact", "--timeout", "2")
        verifier("S4 bouton absent : tap échoue, aucun tap émis",
                 code != 0 and "TAP" not in taps, f"code={code} taps={taps.strip() or '(aucun)'}")

        # --- S5 : le contrôle positif, sinon tout ci-dessus serait trivial ------
        bac.planter(arbre(ECRAN_CAMERA))
        code, sortie, taps = bac.ui("tap", "--id", "camera_record_button", "--timeout", "3")
        verifier("S5 contre-épreuve : le bouton présent EST tapé",
                 code == 0 and "TAP 540 2000" in taps, f"code={code} taps={taps.strip() or '-'}")

        # --- S6 : barre de navigation basse -> ne pas la confondre -------------
        bac.planter(arbre(bouton_compose("Continuer", "btn_continuer"), BARRE_NAV))
        code, sortie, taps = bac.ui("tap", "--text", "Continuer", "--exact", "--timeout", "3")
        verifier("S6 barre de navigation : le bouton d'action reste la cible",
                 code == 0 and "TAP 540 2025" in taps, f"code={code} taps={taps.strip() or '-'}")

        # --- S7 (D42.16, H10) : dump inaccessible -> JAMAIS l'arbre périmé -----
        # Régression des runs 42278038365/42281822052 : `uiautomator dump` qui
        # échouait en silence + fichier distant jamais supprimé => le harnais
        # relisait l'écran d'avant (6 dumps au md5 identique) et « voyait » un
        # bouton qui n'était plus là. Ici le dump échoue : le wait DOIT échouer.
        bac.planter(arbre(bouton_compose("Continuer", "btn_continuer")))
        code, sortie, taps = bac.ui("wait", "--text", "Continuer", "--exact", "--timeout", "2", dump_casse=True)
        verifier("S7 dump raté : wait échoue au lieu de lire l'écran périmé",
                 code != 0 and "TAP" not in taps and "DUMP_FAIL" in sortie,
                 f"code={code} taps={taps.strip() or '(aucun)'}")

        # --- S7b (D42.16, H10) : contrôle positif — dump sain, bouton trouvé ---
        bac.planter(arbre(bouton_compose("Continuer", "btn_continuer")))
        code, sortie, taps = bac.ui("wait", "--text", "Continuer", "--exact", "--timeout", "3")
        verifier("S7b contre-épreuve : dump sain, le libellé EST trouvé",
                 code == 0, f"code={code}")

        if VERBEUX:
            for t in trace:
                print(t)
    finally:
        shutil.rmtree(dossier, ignore_errors=True)

    ok = sum(1 for _, c, _ in resultats if c)
    total = len(resultats)
    print(f"\nAUTOTEST HARNAIS : {ok}/{total} PASS")
    return 0 if ok == total else 1


if __name__ == "__main__":
    sys.exit(main())
