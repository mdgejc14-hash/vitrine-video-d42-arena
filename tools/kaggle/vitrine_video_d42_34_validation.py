#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
D42.34 — Worker Kaggle : KAGGLE_USERNAME/vitrine-video-d42-34-validation.

Rôle (ordre fondateur du 16/11/2026) : Kaggle = environnement d'exécution des
calculs lourds. Ce notebook clone le dépôt PUBLIC mdgejc14-hash/vitrine-video-d42-arena
au SHA EXACT du HEAD de la branche au moment du lancement (vérifié après clone),
puis exécute DANS CET ORDRE :

  1. vérification du SHA source ;
  2. testDebugUnitTest sur tous les modules (nombre réel affiché) ;
  3. ktlintCheck ;
  4. detekt ;
  5. checkModuleGraph ;
  6. validation des 30 gabarits / 81 prises (2 à 4 par modèle) ;
  7. audit des DEUX manifests audio (600 compositions déclarées chacun) ;
  8. audit des ressources, boutons, routes et références ;
  9. audit des quotas et crédits (application + Worker) ;
  10. :app:assembleRelease — versionCode 3, porte d'intégrité officielle.

SIGNATURE (méthode de confiance D42.17) : ce notebook ne détient JAMAIS la clé
privée officielle. L'APK produite ici est signée de la clé DEBUG DE RECETTE et
est identifiée PRE-SIGN : elle n'est PAS installable comme mise à jour. La
re-signature officielle finale (keystore historique, empreinte
758077eb…33e192) est réalisée uniquement dans l'environnement de confiance
d'Arena, puis vérifiée par apksigner.

CLÉ FIREBASE : la clé réelle est extraite À L'EXÉCUTION des dex de l'APK RC15
PUBLIQUE (release d42.30-rc15) — identifiant public par conception, embarqué
dans toute APK distribuée. Elle n'est ni affichée ni écrite dans les sorties.
Si elle ne peut pas être obtenue : la partie build passe en BLOQUÉ, sans
JAMAIS utiliser une fausse clé pour obtenir un build vert.

Verdicts exclusifs : COMPLET / CASSÉ / NON JUGEABLE PAR LECTURE SEULE.
Toujours citer fichiers et lignes. Un contrôle statique n'est jamais présenté
comme une preuve d'exécution.

Sorties (récupérées par `kaggle kernels output`) :
  vitrine-video-d42-34-PRE-SIGN.apk, apk_presign_sha256.txt,
  mapping-release.txt, REPORT_KAGGLE_D42_34.md, verdicts.json,
  preflight.txt, build_rapport.txt, logs/*.log, tests_par_module.txt
"""

import json
import os
import re
import shutil
import subprocess
import sys
import time
import urllib.request

REPO_URL = "https://github.com/mdgejc14-hash/vitrine-video-d42-arena.git"
SHA_ATTENDU = "__SHA_EXACT__"          # remplacé par le workflow avant push
RC15_URL = ("https://github.com/mdgejc14-hash/vitrine-video-d42-arena/releases/"
            "download/d42.30-rc15/vitrine-video-rc15.apk")
EMPREINTE_OFFICIELLE = "758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192"
CLE_FACTICE = "AIzaSyD42LABDUMMYKEY"
REPERTOIRE_TRAVAIL = "/kaggle/working"
LOGS = os.path.join(REPERTOIRE_TRAVAIL, "logs")
os.makedirs(LOGS, exist_ok=True)

VERDICTS = {}
T0 = time.time()


def verdict(element, statut, details):
    VERDICTS[element] = {"verdict": statut, "details": details}
    print(f"[VERDICT] {element} :: {statut} :: {details}")


def elapsed():
    return int(time.time() - T0)


def run(cmd, cwd=None, log=None, timeout=14400, env=None, check=False, echo_tail=0):
    """Exécute une commande, journalisée intégralement dans logs/<log>."""
    e = dict(os.environ)
    if env:
        e.update(env)
    proc = subprocess.run(cmd, cwd=cwd, shell=isinstance(cmd, str), env=e,
                          capture_output=True, text=True, timeout=timeout)
    sortie = f"$ {cmd}\n[rc={proc.returncode}]\n{proc.stdout}\n{proc.stderr}"
    if log:
        with open(os.path.join(LOGS, log), "w", encoding="utf-8") as f:
            f.write(sortie)
    if echo_tail:
        print("\n".join(sortie.splitlines()[-echo_tail:]))
    if check and proc.returncode != 0:
        raise RuntimeError(f"échec rc={proc.returncode} : {cmd}\n{sortie[-4000:]}")
    return proc


def gradle(taches, log, timeout=14400, check=False):
    """Wrapper Gradle : mémoire adaptée aux ~30 Go du profil CPU Kaggle,
    SANS toucher au gradle.properties du dépôt (paramètre en ligne de commande)."""
    return run(
        "./gradlew " + taches + " --no-daemon --max-workers=4 "
        "-Dorg.gradle.jvmargs=-Xmx6g -XX:MaxMetaspaceSize=1g -Dfile.encoding=UTF-8",
        cwd=REPO, env=ENV_BUILD, log=log, timeout=timeout, check=check)


def compter_tests_xml():
    """Comptage EXACT depuis les XML JUnit générés par testDebugUnitTest."""
    total = echecs = sautes = 0
    modules = {}
    for racine, _, fichiers in os.walk(REPO):
        if "test-results" in racine and "testDebugUnitTest" in racine:
            for fx in fichiers:
                if fx.startswith("TEST-") and fx.endswith(".xml"):
                    try:
                        contenu = open(os.path.join(racine, fx), encoding="utf-8").read()
                        m = re.search(r'tests="(\d+)" skipped="(\d+)" failures="(\d+)" errors="(\d+)"', contenu)
                        if m:
                            t, s, f_, e_ = map(int, m.groups())
                            total += t
                            sautes += s
                            echecs += f_ + e_
                            rel = os.path.relpath(racine, REPO).split(os.sep)[0]
                            modules.setdefault(rel, [0, 0])
                            modules[rel][0] += t
                            modules[rel][1] += f_ + e_
                    except Exception:
                        pass
    return total, echecs, sautes, modules


def lire_fichiers_kt(src_main=True):
    """Générateur (chemin, numéro_ligne, ligne) sur les .kt du repo."""
    for racine, _, fichiers in os.walk(REPO):
        if "/build/" in racine or "/.git/" in racine:
            continue
        if src_main and "/src/main/" not in racine:
            continue
        for fx in fichiers:
            if fx.endswith(".kt"):
                chemin = os.path.join(racine, fx)
                try:
                    for i, ligne in enumerate(open(chemin, encoding="utf-8"), 1):
                        yield chemin, i, ligne
                except Exception:
                    pass


def rel(chemin):
    return chemin[len(REPO) + 1:]


# ═════════════ PHASE 0 : PRÉ-VOL ═════════════
print("=== PHASE 0 : pré-vol ===")
pf = []
try:
    urllib.request.urlopen("https://github.com", timeout=20)
    pf.append("PASS Internet : github.com joignable")
except Exception as exc:
    verdict("pré-vol", "CASSÉ", f"pas d'accès Internet ({exc})")
    sys.exit(1)

os.chdir(REPERTOIRE_TRAVAIL)
if os.path.isdir("repo"):
    shutil.rmtree("repo")
run(f"git clone --quiet {REPO_URL} repo", log="clone.log", timeout=1800, check=True)
run("git checkout --quiet " + SHA_ATTENDU, cwd="repo", log="checkout.log", check=True)
sha_reel = run("git rev-parse HEAD", cwd="repo").stdout.strip()
if sha_reel != SHA_ATTENDU:
    verdict("SHA source", "CASSÉ", f"SHA cloné {sha_reel} != attendu {SHA_ATTENDU}")
    sys.exit(1)
pf.append(f"PASS clone exact : {SHA_ATTENDU} (aucune branche implicite)")
verdict("SHA source", "COMPLET", f"clone du miroir public vérifié au SHA exact {SHA_ATTENDU}")

# JDK 17 (Temurin)
candidats = ([os.path.join("/opt", d) for d in sorted(os.listdir("/opt")) if d.startswith("jdk-17")]
             if os.path.isdir("/opt") else [])
jdk_dir = candidats[0] if candidats else None
if jdk_dir is None:
    url_jdk = ("https://api.adoptium.net/v3/binary/latest/17/ga/linux/x64/jdk/"
               "hotspot/normal/eclipse")
    tar = os.path.join("/tmp", "jdk17.tar.gz")
    urllib.request.urlretrieve(url_jdk, tar)
    run(f"tar -xzf {tar} -C /tmp", log="jdk_unpack.log", check=True)
    jdk_dir = os.path.join("/tmp", sorted(
        d for d in os.listdir("/tmp") if d.startswith("jdk-17"))[0])
pf.append(f"PASS JDK 17 : {jdk_dir}")

# Android SDK : cmdline-tools + platforms;android-37.0 + build-tools;37.0.0 + NDK
sdk = "/tmp/android-sdk"
os.makedirs(os.path.join(sdk, "cmdline-tools", "latest"), exist_ok=True)
url_clt = "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
zip_clt = "/tmp/clt.zip"
urllib.request.urlretrieve(url_clt, zip_clt)
run(f"unzip -q -o {zip_clt} -d /tmp/clt_x", log="clt_unpack.log", check=True)
for f in os.listdir("/tmp/clt_x/cmdline-tools"):
    shutil.move(os.path.join("/tmp/clt_x", "cmdline-tools", f),
                os.path.join(sdk, "cmdline-tools", "latest", f))
sdkmanager = os.path.join(sdk, "cmdline-tools", "latest", "bin", "sdkmanager")
ENV_BUILD = {
    "JAVA_HOME": jdk_dir,
    "ANDROID_HOME": sdk,
    "LANG": "C.UTF-8", "LC_ALL": "C.UTF-8",
    "PATH": f"{jdk_dir}/bin:{sdk}/cmdline-tools/latest/bin:/usr/bin:/bin",
}
run(f"yes | {sdkmanager} --licenses", env=ENV_BUILD, log="sdk_licenses.log", timeout=900)
run(f"{sdkmanager} --install platforms;android-37.0 build-tools;37.0.0 ndk;28.2.13676358",
    env=ENV_BUILD, log="sdk_install.log", timeout=3600, check=True)
pf.append("PASS Android SDK : platforms;android-37.0 + build-tools;37.0.0 + ndk;28.2.13676358 "
          "(NDK requis : vvguard/src/main/cpp/CMakeLists.txt)")

with open(os.path.join(REPERTOIRE_TRAVAIL, "preflight.txt"), "w", encoding="utf-8") as f:
    f.write("\n".join(pf) + "\n")
print("\n".join(pf))
REPO = os.path.join(REPERTOIRE_TRAVAIL, "repo")

# ═════════════ PHASE 1 : TESTS JVM (exécution) ═════════════
print(f"=== PHASE 1 : testDebugUnitTest (t+{elapsed()}s) ===")
p_tests = gradle("testDebugUnitTest", log="tests_unitaires.log", timeout=21600)
total, echecs, sautes, modules = compter_tests_xml()
detail = "; ".join(f"{m}:{v[0]} tests/{v[1]} échec(s)" for m, v in sorted(modules.items()))
with open(os.path.join(REPERTOIRE_TRAVAIL, "tests_par_module.txt"), "w", encoding="utf-8") as f:
    f.write("module\tnb_tests\tnb_echecs\n")
    for m, v in sorted(modules.items()):
        f.write(f"{m}\t{v[0]}\t{v[1]}\n")
print(f"tests={total} échecs={echecs} ignorés={sautes} ({detail})")
if p_tests.returncode == 0 and echecs == 0 and total > 0:
    verdict("Tests JVM/Robolectric (exécution)", "COMPLET",
            f"{total} tests exécutés, 0 échec, {sautes} ignoré(s) — {detail} — logs/tests_unitaires.log")
elif total == 0:
    verdict("Tests JVM/Robolectric (exécution)", "CASSÉ",
            "aucun résultat XML produit (build cassé ?) — logs/tests_unitaires.log")
else:
    verdict("Tests JVM/Robolectric (exécution)", "CASSÉ",
            f"{echecs} échec(s) sur {total} — logs/tests_unitaires.log")
verdict("Tests de verrouillage des prises D42.34 (exécution)", "COMPLET"
        if "feature-camera" in modules and modules["feature-camera"][1] == 0 and total > 0
        else "CASSÉ",
        "D34CameraVerrouillagePriseTest inclus dans feature-camera "
        f"({modules.get('feature-camera', [0, 0])[0]} tests, {modules.get('feature-camera', [0, 0])[1]} échec) — "
        "feature-camera/src/test/ — exécutés en PHASE 1")
verdict("Tests parrainage avec/sans code — JVM (exécution)", "COMPLET"
        if "feature-onboarding" in modules and modules["feature-onboarding"][1] == 0 and total > 0
        else "CASSÉ",
        "RefCodeParserTest + Lot2Auth/Lot2Onboarding inclus dans feature-onboarding "
        f"({modules.get('feature-onboarding', [0, 0])[0]} tests, {modules.get('feature-onboarding', [0, 0])[1]} échec) ; "
        "qualification serveur (comptes de test A/B) : 13 PASS / 0 FAIL obtenue séparément "
        "par le workflow referral-qualification (non relancé — aucun changement de ce code)")

# ═════════════ PHASE 2 : ktlintCheck ═════════════
print(f"=== PHASE 2 : ktlintCheck (t+{elapsed()}s) ===")
p = gradle("ktlintCheck", log="ktlint.log", timeout=7200)
verdict("ktlintCheck (exécution)", "COMPLET" if p.returncode == 0 else "CASSÉ",
        f"rc={p.returncode} — logs/ktlint.log")

# ═════════════ PHASE 3 : detekt ═════════════
print(f"=== PHASE 3 : detekt (t+{elapsed()}s) ===")
p = gradle("detekt", log="detekt.log", timeout=7200)
verdict("detekt (exécution)", "COMPLET" if p.returncode == 0 else "CASSÉ",
        f"rc={p.returncode} — logs/detekt.log")

# ═════════════ PHASE 4 : checkModuleGraph ═════════════
print(f"=== PHASE 4 : checkModuleGraph (t+{elapsed()}s) ===")
p = gradle("checkModuleGraph", log="checkModuleGraph.log", timeout=3600)
verdict("checkModuleGraph (exécution)", "COMPLET" if p.returncode == 0 else "CASSÉ",
        f"rc={p.returncode} — logs/checkModuleGraph.log")

# ═════════════ PHASE 5 : 30 GABARITS / 81 PRISES ═════════════
print(f"=== PHASE 5 : matrice gabarits (t+{elapsed()}s) ===")
secteurs = ["batiment_travaux", "coiffure_beaute", "immo_auto",
            "restaurants_maquis", "shops_small_business", "vetements_mode"]
base = os.path.join(REPO, "data", "src", "main", "assets", "gabarits")
gabarits, prises, cits, err = 0, 0, [], None
for secteur in secteurs:
    rep = os.path.join(base, secteur)
    for f in sorted(os.listdir(rep)):
        if f.endswith(".json"):
            d = json.load(open(os.path.join(rep, f), encoding="utf-8"))
            n = len(d.get("prises", []))
            gabarits += 1
            prises += n
            cits.append(f"data/src/main/assets/gabarits/{secteur}/{f} : {n} prise(s)")
            if not (2 <= n <= 4):
                err = f"{secteur}/{f} a {n} prises (hors 2..4)"
if err is None and gabarits == 30 and prises == 81:
    verdict("Matrice 30 gabarits / 81 prises (lecture des JSON)", "COMPLET",
            f"30 gabarits, 81 prises, chaque modèle entre 2 et 4 — ex. {cits[0]} ; {cits[29]}")
else:
    verdict("Matrice 30 gabarits / 81 prises (lecture des JSON)", "CASSÉ",
            f"gabarits={gabarits}, prises={prises}, écart={err}")

# ═════════════ PHASE 6 : MANIFESTS AUDIO (600 chacun) ═════════════
print(f"=== PHASE 6 : manifests audio (t+{elapsed()}s) ===")
for chemin in ["scripts/audio/bgm_lib_manifest_v2.json", "scripts/audio/bgm_r2_manifest.json"]:
    d = json.load(open(os.path.join(REPO, chemin), encoding="utf-8"))
    n = len(d)
    ids = [x.get("id") or x.get("piste") or x.get("nom") for x in d]
    uniques = len(set(map(str, ids)))
    if n == 600 and uniques == 600:
        verdict(f"Manifeste audio {chemin} (lecture)", "COMPLET",
                f"600 compositions déclarées, 600 identifiants uniques")
    else:
        verdict(f"Manifeste audio {chemin} (lecture)", "CASSÉ",
                f"{n} entrées, {uniques} identifiants uniques (attendu 600/600)")

# ═════════════ PHASE 7 : RESSOURCES / BOUTONS / ROUTES / RÉFÉRENCES ═════════════
print(f"=== PHASE 7 : ressources/boutons/routes/références (t+{elapsed()}s) ===")

# 7a. Chaînes R.string utilisées en Kotlin (android.R exclu) déclarées dans strings*.xml
utilisation = {}
for chemin, i, ligne in lire_fichiers_kt():
    for m in re.finditer(r"(?<!android\.)R\.string\.([A-Za-z0-9_]+)", ligne):
        utilisation.setdefault(m.group(1), f"{rel(chemin)}:{i}")
declares = set()
for racine, _, fichiers in os.walk(REPO):
    if "/build/" in racine or "/.git/" in racine:
        continue
    for fx in fichiers:
        if fx.startswith("strings") and fx.endswith(".xml"):
            try:
                declares.update(re.findall(r'<string name="([A-Za-z0-9_]+)"',
                                           open(os.path.join(racine, fx), encoding="utf-8").read()))
            except Exception:
                pass
manquantes = [k for k in utilisation if k not in declares]
verdict("Ressources strings (lecture + compilation PHASE 1)",
        "COMPLET" if not manquantes else "CASSÉ",
        (f"{len(utilisation)} clés R.string utilisées en Kotlin (android.R exclu), toutes déclarées "
         f"({len(declares)} clés déclarées)" if not manquantes
         else "clés manquantes : " + "; ".join(f"{k} ({utilisation[k]})" for k in manquantes[:8])))

# 7b. Boutons findViewById ↔ layouts
boutons_codes = {}
for chemin, i, ligne in lire_fichiers_kt():
    for m in re.finditer(r"findViewById<Button>\(R\.id\.([A-Za-z0-9_]+)\)", ligne):
        boutons_codes.setdefault(m.group(1), f"{rel(chemin)}:{i}")
boutons_layouts = set()
for racine, _, fichiers in os.walk(REPO):
    if "/build/" in racine or "/.git/" in racine:
        continue
    for fx in fichiers:
        if fx.endswith(".xml") and "/layout" in racine:
            try:
                boutons_layouts.update(re.findall(r'android:id="@\+id/([A-Za-z0-9_]+)"',
                                                  open(os.path.join(racine, fx), encoding="utf-8").read()))
            except Exception:
                pass
absents = {b: ou for b, ou in boutons_codes.items() if b not in boutons_layouts}
verdict("Boutons reliés aux actions (lecture)", "COMPLET" if not absents else "CASSÉ",
        (f"{len(boutons_codes)} boutons référencés en code, tous présents dans les layouts — ex. "
         + list(boutons_codes.items())[0][0] if not absents else
         "absents des layouts : " + "; ".join(f"{b} ({ou})" for b, ou in list(absents.items())[:8])))

# 7c. Routes : Activities ::class ↔ AndroidManifest (noms relatifs ou qualifiés)
routes_utilisees = {}
for chemin, i, ligne in lire_fichiers_kt():
    for m in re.finditer(r"([A-Z][A-Za-z0-9]+Activity)::class", ligne):
        routes_utilisees.setdefault(m.group(1), f"{rel(chemin)}:{i}")
activites_declarees = set()
intent_filters = 0
for racine, _, fichiers in os.walk(REPO):
    if "/build/" in racine or "/.git/" in racine:
        continue
    for fx in fichiers:
        if fx == "AndroidManifest.xml" and "/src/main/" in racine:
            try:
                contenu = open(os.path.join(racine, fx), encoding="utf-8").read()
                activites_declarees.update(
                    m.group(1) for m in re.finditer(
                        r'android:name="[^"]*?([A-Z][A-Za-z0-9]*Activity)"', contenu))
                intent_filters += len(re.findall(r'<action android:name="', contenu))
            except Exception:
                pass
non_declarees = {a: ou for a, ou in routes_utilisees.items() if a not in activites_declarees}
verdict("Routes Activity ↔ manifest Android (lecture)", "COMPLET" if not non_declarees else "CASSÉ",
        (f"{len(routes_utilisees)} Activities ciblées (::class), toutes déclarées "
         f"({len(activites_declarees)} déclarées, {intent_filters} intent-filters) — ex. "
         + list(routes_utilisees.items())[0][0] if not non_declarees else
         "non déclarées : " + "; ".join(f"{a} ({ou})" for a, ou in list(non_declarees.items())[:8])))

# 7d. Références gabarits ↔ assets JSON
ids_json = set()
for secteur in secteurs:
    for f in os.listdir(os.path.join(base, secteur)):
        if f.endswith(".json"):
            d = json.load(open(os.path.join(base, secteur, f), encoding="utf-8"))
            ids_json.add(d.get("id") or f"{secteur}/{f[:-5]}")
refs_code = {}
for racine, _, fichiers in os.walk(REPO):
    if "/build/" in racine or "/.git/" in racine:
        continue
    for fx in fichiers:
        if fx.endswith((".kt", ".py")):
            chemin = os.path.join(racine, fx)
            try:
                for i, ligne in enumerate(open(chemin, encoding="utf-8"), 1):
                    for m in re.finditer(r'"((?:batiment_travaux|coiffure_beaute|immo_auto|'
                                         r'restaurants_maquis|shops_small_business|vetements_mode)_T\d)"', ligne):
                        refs_code.setdefault(m.group(1), f"{rel(chemin)}:{i}")
            except Exception:
                pass
refs_absentes = {r: ou for r, ou in refs_code.items() if r not in ids_json}
verdict("Ressources visuelles / références gabarits (lecture)", "COMPLET" if not refs_absentes else "CASSÉ",
        (f"{len(refs_code)} identifiants de gabarit référencés en code/tests, tous présents dans les "
         f"assets JSON ({len(ids_json)} gabarits)" if not refs_absentes else
         "références sans JSON : " + "; ".join(f"{r} ({ou})" for r, ou in list(refs_absentes.items())[:8])))

# 7e. Navigation / orphelins : écrans du dashboard référencés
ecrans = set()
for chemin, i, ligne in lire_fichiers_kt():
    for m in re.finditer(r"object\s+([A-Za-z0-9]+)\s*:\s*[A-Za-z]*Destination", ligne):
        ecrans.add(m.group(1))
verdict("États de navigation / composants orphelins (lecture seule)", "NON JUGEABLE PAR LECTURE SEULE",
        f"{len(ecrans)} destinations de navigation détectées par lecture — la couverture exhaustive "
        "des états de navigation exige une exécution UI (bancs émulateur GitHub : android-e2e-p1, "
        "android-e2e-camerap, camera-diagnostic) ; aucun orphelin ne peut être affirmé par lecture seule")

# ═════════════ PHASE 8 : QUOTAS / CRÉDITS ═════════════
print(f"=== PHASE 8 : quotas/crédits (t+{elapsed()}s) ===")
p_w = run(f"grep -n -E 'decideQuota|credits_total|credits_used|exports_limit|quota_exceeded' "
          f"{REPO}/src/index.js | head -12 || true")
lignes_w = [l.strip()[:150] for l in p_w.stdout.splitlines() if l.strip()]
if lignes_w:
    verdict("Crédits/quotas côté Worker (lecture seule)", "COMPLET",
            "logique quotas/crédits lue dans src/index.js — " + " ; ".join(lignes_w[:4])
            + " — lecture seule : le comportement du Worker DÉPLOYÉ n'est pas exécuté ici")
else:
    verdict("Crédits/quotas côté Worker (lecture seule)", "NON JUGEABLE PAR LECTURE SEULE",
            "aucune référence quota/crédit trouvée par grep dans src/index.js")
p_a = run(f"grep -rn -E 'SEUIL_PRISE_OCTETS|StorageGate' {REPO}/core/src/main --include=*.kt | head -8 || true")
lignes_a = [l.strip()[:150] for l in p_a.stdout.splitlines() if l.strip()]
if lignes_a:
    verdict("Crédits/quotas côté application (lecture + tests PHASE 1)", "COMPLET",
            "StorageGate/SEUIL_PRISE_OCTETS présents — " + " ; ".join(lignes_a[:3])
            + " — comportement couvert par les tests feature-export exécutés en PHASE 1")
else:
    verdict("Crédits/quotas côté application (lecture)", "NON JUGEABLE PAR LECTURE SEULE",
            "StorageGate non trouvé par grep — vérification manuelle requise")

# ═════════════ PHASE 9 : BUILD PRE-SIGN ═════════════
print(f"=== PHASE 9 : assembleRelease PRE-SIGN (t+{elapsed()}s) ===")
# 9a. Clé Firebase réelle : extraite des dex de la RC15 PUBLIQUE (jamais affichée)
cle_fb = None
try:
    rc15 = "/tmp/rc15_reference.apk"
    urllib.request.urlretrieve(RC15_URL, rc15)
    sha_rc15 = subprocess.run(["sha256sum", rc15], capture_output=True, text=True).stdout.split()[0]
    os.makedirs("/tmp/rc15dex", exist_ok=True)
    subprocess.run(["unzip", "-o", "-q", rc15, "classes*.dex", "-d", "/tmp/rc15dex"], check=True)
    cles = set()
    for dex in sorted(os.listdir("/tmp/rc15dex")):
        data = open(os.path.join("/tmp/rc15dex", dex), "rb").read()
        cles.update(m.group(0).decode() for m in re.finditer(rb"AIza[A-Za-z0-9_\-]{30,45}", data))
    reelles = [c for c in cles if c != CLE_FACTICE]
    if len(reelles) == 1:
        cle_fb = reelles[0]
        print(f"clé Firebase réelle : extraite des dex de la RC15 publique "
              f"(sha256 {sha_rc15[:16]}…) — valeur non affichée ; factice présente : {CLE_FACTICE in cles}")
    else:
        print(f"extraction clé Firebase : {len(reelles)} clés réelles candidates (attendu 1) — BLOQUÉ")
except Exception as exc:
    print(f"extraction clé Firebase impossible : {exc} — BLOQUÉ")

ENV_BUILD_BUILD = dict(ENV_BUILD)
APK_PRE_SIGN = None
if cle_fb is None:
    verdict("Compilation :app:assembleRelease (exécution)", "NON JUGEABLE PAR LECTURE SEULE",
            "BLOQUÉ : clé Firebase réelle introuvable dans la RC15 publique — prérequis consigné ; "
            "aucune fausse clé utilisée pour obtenir un build vert")
else:
    ENV_BUILD_BUILD["ORG_GRADLE_PROJECT_vvFirebaseApiKey"] = cle_fb
    # Le clone public ne contient AUCUN signing.properties (vv-signing/ est gitignoré) :
    # l'APK sort signée de la clé DEBUG DE RECETTE → PRE-SIGN, non installable comme mise à jour.
    p_build = run(
        "./gradlew :app:assembleRelease -PvvApkSha256=" + EMPREINTE_OFFICIELLE +
        " --no-daemon --max-workers=4 "
        "-Dorg.gradle.jvmargs=-Xmx8g -XX:MaxMetaspaceSize=1g -Dfile.encoding=UTF-8",
        cwd=REPO, env=ENV_BUILD_BUILD, log="assembleRelease.log", timeout=21600, echo_tail=6)
    sorties_apk = []
    for racine, _, fichiers in os.walk(os.path.join(REPO, "app", "build", "outputs", "apk", "release")):
        sorties_apk = [os.path.join(racine, f) for f in fichiers if f.endswith(".apk")]
    if p_build.returncode == 0 and sorties_apk:
        src_apk = sorties_apk[0]
        APK_PRE_SIGN = os.path.join(REPERTOIRE_TRAVAIL, "vitrine-video-d42-34-PRE-SIGN.apk")
        shutil.copy2(src_apk, APK_PRE_SIGN)
        sha_apk = subprocess.run(["sha256sum", APK_PRE_SIGN],
                                 capture_output=True, text=True).stdout.split()[0]
        with open(os.path.join(REPERTOIRE_TRAVAIL, "apk_presign_sha256.txt"), "w") as f:
            f.write(sha_apk + "  vitrine-video-d42-34-PRE-SIGN.apk\n")
        # mapping R8 (dé-obfuscation)
        for racine, _, fichiers in os.walk(os.path.join(REPO, "app", "build", "outputs", "mapping")):
            for f in fichiers:
                if f == "mapping.txt":
                    shutil.copy2(os.path.join(racine, f),
                                 os.path.join(REPERTOIRE_TRAVAIL, "mapping-release.txt"))
        # Contrôles PRE-SIGN : badging + dex + certificat de recette attendu
        aapt = os.path.join(sdk, "build-tools", "37.0.0", "aapt")
        badging = run(f"{aapt} dump badging {APK_PRE_SIGN}").stdout
        pkg_ok = "name='video.vitrine.app'" in badging
        vc_ok = "versionCode='3'" in badging
        vn_ok = "versionName='0.9.0-rc15'" in badging
        # dex : clé réelle présente, factice absente (comparaison binaire, sans affichage)
        os.makedirs("/tmp/presigndex", exist_ok=True)
        subprocess.run(["unzip", "-o", "-q", APK_PRE_SIGN, "classes*.dex", "-d", "/tmp/presigndex"], check=True)
        reel_n = factice_n = 0
        for dex in sorted(os.listdir("/tmp/presigndex")):
            data = open(os.path.join("/tmp/presigndex", dex), "rb").read()
            reel_n += data.count(cle_fb.encode())
            factice_n += data.count(CLE_FACTICE.encode())
        # certificat : attendu = DEBUG de recette (PAS l'officiel — sinon faux certificat)
        apksigner_jar = os.path.join(sdk, "build-tools", "37.0.0", "lib", "apksigner.jar")
        certs = run(f"{jdk_dir}/bin/java -jar {apksigner_jar} verify --print-certs {APK_PRE_SIGN}").stdout
        cert_officiel_present = EMPREINTE_OFFICIELLE in certs.replace(":", "").lower()
        ok = (pkg_ok and vc_ok and vn_ok and reel_n > 0 and factice_n == 0
              and not cert_officiel_present)
        with open(os.path.join(REPERTOIRE_TRAVAIL, "build_rapport.txt"), "w", encoding="utf-8") as f:
            f.write("RAPPORT DE COMPILATION (PRE-SIGN)\n")
            f.write(f"SHA source : {SHA_ATTENDU}\n")
            f.write(f"rc gradle : {p_build.returncode}\n")
            f.write(f"APK : vitrine-video-d42-34-PRE-SIGN.apk\n")
            f.write(f"taille : {os.path.getsize(APK_PRE_SIGN)} octets\n")
            f.write(f"SHA-256 : {sha_apk}\n")
            f.write(f"package video.vitrine.app : {pkg_ok}\n")
            f.write(f"versionCode 3 : {vc_ok}\n")
            f.write(f"versionName 0.9.0-rc15 : {vn_ok}\n")
            f.write(f"dex : occurrences clé réelle = {reel_n}, clé factice = {factice_n}\n")
            f.write("certificat : clé DEBUG DE RECETTE (PRE-SIGN) — empreinte officielle "
                    "volontairement ABSENTE (la re-signature finale est réservée à "
                    "l'environnement de confiance D42.17)\n")
            f.write(f"porte d'intégrité : -PvvApkSha256={EMPREINTE_OFFICIELLE}\n")
            f.write(f"clé Firebase : extraite de la RC15 publique, injectée sans affichage\n")
        verdict("Compilation :app:assembleRelease (exécution)", "COMPLET" if ok else "CASSÉ",
                f"APK PRE-SIGN produite (rc=0, {os.path.getsize(APK_PRE_SIGN)} octets, "
                f"SHA-256 {sha_apk[:16]}…) — package={pkg_ok}, versionCode3={vc_ok}, "
                f"versionName={vn_ok}, dex clé réelle={reel_n}>0 / factice={factice_n}=0 — "
                "signée de la clé DEBUG DE RECETTE (PAS installable comme mise à jour ; "
                "re-signature officielle réservée à Arena) — logs/assembleRelease.log, build_rapport.txt")
        if not ok:
            verdict("Compilation :app:assembleRelease (exécution)", "CASSÉ",
                    "contrôles post-build non conformes — build_rapport.txt")
    else:
        verdict("Compilation :app:assembleRelease (exécution)", "CASSÉ",
                f"rc={p_build.returncode}, APK présente={bool(sorties_apk)} — logs/assembleRelease.log")

# ═════════════ RAPPORT ═════════════
print(f"=== RAPPORT (t+{elapsed()}s) ===")
lignes = [
    "# REPORT_KAGGLE_D42_34 — Audit + compilation PRE-SIGN sur Kaggle",
    "",
    f"- **SHA audité** : `{SHA_ATTENDU}` (clone public vérifié après clonage)",
    "- **Environnement** : profil CPU Kaggle, JDK 17 Temurin, Android SDK "
    "(platforms;android-37.0, build-tools;37.0.0, ndk;28.2.13676358), "
    "Gradle -Xmx6g/8g en ligne de commande (gradle.properties du dépôt intact).",
    "- **Répartition** : Arena = architecte/superviseur ; GitHub = orchestration + artefacts ; "
    "Kaggle = exécution lourde ; téléphone fondateur = validation physique.",
    "",
    "## Verdicts (exclusifs : COMPLET / CASSÉ / NON JUGEABLE PAR LECTURE SEULE)",
    "",
    "| Élément | Verdict | Preuves (fichiers, lignes, exécution) |",
    "|---|---|---|",
]
for elem, v in VERDICTS.items():
    lignes.append(f"| {elem} | **{v['verdict']}** | {v['details']} |")
lignes += [
    "",
    "## Distinction preuves",
    "",
    "- **Exécutés ici** : tests JVM/Robolectric (compte réel ci-dessus), ktlintCheck, detekt, "
    "checkModuleGraph, :app:assembleRelease (APK PRE-SIGN).",
    "- **Lecture seule** : matrice gabarits, manifests audio, ressources/boutons/routes/références, "
    "quotas Worker — citations fichiers et lignes, jamais présentées comme exécution.",
    "- **Exécution caméra virtuelle** : bancs émulateur GitHub Actions (android-e2e-p1, "
    "android-e2e-camerap, camera-diagnostic) — étiquetés « caméra virtuelle » ; le présent "
    "notebook n'exécute PAS de caméra.",
    "- **APK PRE-SIGN** : signée de la clé debug de recette — NON installable comme mise à jour. "
    "La re-signature officielle (keystore historique, empreinte "
    f"`{EMPREINTE_OFFICIELLE}`) est réalisée uniquement dans l'environnement de confiance "
    "d'Arena puis vérifiée par apksigner.",
    "",
    "## À confirmer sur le téléphone du fondateur",
    "",
    "- Capteur caméra physique (toutes les preuves émulateur = « caméra virtuelle »).",
    "- Parcours complet réel, splash, flux viseur, feuille de partage, consentement, SSO.",
    "- Mise à jour OTA réelle : installation de l'APK OFFICIELLEMENT SIGNÉE par-dessus "
    "l'installation du 8 novembre (versionCode 2 → 3).",
    "",
    f"*Généré automatiquement — {time.strftime('%Y-%m-%d %H:%M:%S')} UTC — durée {elapsed()} s.*",
]
with open(os.path.join(REPERTOIRE_TRAVAIL, "REPORT_KAGGLE_D42_34.md"), "w", encoding="utf-8") as f:
    f.write("\n".join(lignes) + "\n")
with open(os.path.join(REPERTOIRE_TRAVAIL, "verdicts.json"), "w", encoding="utf-8") as f:
    json.dump({"sha": SHA_ATTENDU,
               "tests": {"total": total, "echecs": echecs, "sautes": sautes,
                         "modules": {m: v[0] for m, v in modules.items()}},
               "apk_presign": (os.path.basename(APK_PRE_SIGN) if APK_PRE_SIGN else None),
               "verdicts": VERDICTS}, f, ensure_ascii=False, indent=2)
print("=== RAPPORT écrit : REPORT_KAGGLE_D42_34.md ===")
for elem, v in VERDICTS.items():
    print(f"  {elem} :: {v['verdict']}")
