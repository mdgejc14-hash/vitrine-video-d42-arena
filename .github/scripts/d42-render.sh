#!/usr/bin/env bash
# =============================================================================
# D42 — exécution d'un lot de rendus de production sur émulateur.
#
# Appelé par android-emulator-runner, qui exécute chaque LIGNE du `script:`
# dans un shell distinct : d'où ce fichier, unique ligne de commande.
#
#   bash .github/scripts/d42-render.sh <mode> <langue> <gabarits> <sortie> \
#        [timeout] [badge] [profil] [limite] [shard] [shards_total]
#
#   mode      smoke | matrix
#   langue    fr | en | es | ja
#   gabarits  all | T1 | restaurants_maquis_T1,...
#   sortie    dossier local recevant MP4 + manifestes
#   badge     none | stock_limite | places_limitees | qualite_garantie
#   profil    production (1080x1920) | validation (540x960, meme chaine)
#   limite    plafond de rendus pour ce job (0 = aucun)
#   shard      indice du lot, 1-based (vide = pas de decoupage)
#   shards_tot nombre total de lots (vide = pas de decoupage)
#
# D42.3 — SEPARATION DES NOTIONS : le filtre de gabarit (3e argument) et le
# decoupage en lots (9e et 10e) sont independants. Le workflow passait
# « shard:1/8 » dans l'argument des gabarits : le filtre etait perdu, les 30
# gabarits restaient candidats et le premier venu etait rendu.
#
# Aucun moteur de test : l'APK PUBLIÉ est instrumenté tel quel, le rendu passe
# par ExportActivity → ExportWorker → Transformer (Media3).
# =============================================================================
set -euo pipefail

MODE="${1:?mode requis}"
LANGUE="${2:?langue requise}"
GABARITS="${3:-all}"
SORTIE="${4:-rendus}"
TIMEOUT_S="${5:-900}"
BADGE="${6:-none}"
PROFIL="${7:-production}"
LIMITE="${8:-0}"
SHARD="${9:-}"
SHARDS_TOTAL="${10:-}"

echo "== D42 rendu : mode=$MODE langue=$LANGUE gabarits=$GABARITS badge=$BADGE profil=$PROFIL =="
echo "== D42 lot : indice=${SHARD:-aucun} total=${SHARDS_TOTAL:-aucun} limite=$LIMITE =="
df -h . | tail -1

# --- package de l'APK de test (jamais deviné quand aapt est disponible) ------
AAPT="$(ls /usr/local/lib/android/sdk/build-tools/*/aapt 2>/dev/null | tail -1 || true)"
TEST_PKG=""
if [ -n "${AAPT}" ] && [ -x "${AAPT}" ]; then
  TEST_PKG="$("${AAPT}" dump badging apk/app-debug-androidTest.apk 2>/dev/null \
    | awk '/^package:/{print $2}' | sed "s/name='//;s/'//" || true)"
fi
TEST_PKG="${TEST_PKG:-video.vitrine.app.test}"
echo "package_de_test=${TEST_PKG}"

# --- installation du VRAI APK + de son instrumentation ----------------------
adb install -r apk/app-debug.apk
adb install -r apk/app-debug-androidTest.apk
echo "sdk=$(adb shell getprop ro.build.version.sdk | tr -d '\r')"
# D42-P4 : le rendu est domine par le GL logiciel (SwiftShader) ; le nombre de
# coeurs vus par le systeme explique une partie du temps par image.
echo "coeurs_guest=$(adb shell nproc | tr -d '\r')"
echo "abi=$(adb shell getprop ro.product.cpu.abi | tr -d '\r')"
echo "modele=$(adb shell getprop ro.product.model | tr -d '\r')"

# --- instrumentation --------------------------------------------------------
set +e
adb shell am instrument -w -r \
  -e class video.vitrine.d42.ProductionRenderInstrumentedTest \
  -e d42_mode "${MODE}" \
  -e d42_lang "${LANGUE}" \
  -e d42_templates "${GABARITS}" \
  -e d42_timeout_s "${TIMEOUT_S}" \
  -e d42_badge "${BADGE}" \
  -e d42_profile "${PROFIL}" \
  -e d42_limite "${LIMITE}" \
  -e d42_shard "${SHARD}" \
  -e d42_shards "${SHARDS_TOTAL}" \
  "${TEST_PKG}/androidx.test.runner.AndroidJUnitRunner" 2>&1 | tee instrumentation.txt
STATUT_INSTRUMENTATION=$?
set -e

# Un échec d'instrumentation ne doit jamais produire un job vert — et doit
# laisser des preuves exploitables (logcat complet + crash + worker).
if ! grep -q "^OK (" instrumentation.txt; then
  echo "::error title=INSTRUMENTATION EN ECHEC::voir instrumentation.txt (code ${STATUT_INSTRUMENTATION})"
  mkdir -p "${SORTIE}"
  adb logcat -d > "${SORTIE}/logcat-complet.txt" 2>&1 || true
  adb logcat -d -b crash > "${SORTIE}/logcat-crash.txt" 2>&1 || true
  adb shell dumpsys activity processes > "${SORTIE}/dumpsys-processes.txt" 2>&1 || true
  adb exec-out run-as video.vitrine.app cat cache/export-1.mp4 > "${SORTIE}/cache-export-1.mp4" 2>/dev/null || true
  cp instrumentation.txt "${SORTIE}/" 2>/dev/null || true
  grep -iE "ExportWorker|D42|vitrine" "${SORTIE}/logcat-complet.txt" | tail -120 || true
  tail -40 instrumentation.txt
  exit 1
fi

# --- récupération des preuves ----------------------------------------------
mkdir -p "${SORTIE}"
# API 30+ restreint /sdcard/Android/data vu du shell : repli run-as (APK debug).
if ! adb pull /sdcard/Android/data/video.vitrine.app/files/d42 "${SORTIE}/" 2>/dev/null; then
  echo "pull direct refusé — repli run-as"
  adb exec-out run-as video.vitrine.app tar -cf - files/d42 \
    | tar -xf - -C "${SORTIE}" --strip-components=2
fi

# Sortie partielle du worker (cacheDir) : preuve du travail réellement accompli,
# indispensable quand le rendu ne rend pas la main.
adb exec-out run-as video.vitrine.app cat cache/export-1.mp4 > "${SORTIE}/cache-export-1.mp4" 2>/dev/null || true
echo "cache-export-1.mp4 : $(stat -c%s "${SORTIE}/cache-export-1.mp4" 2>/dev/null || echo 0) octets" 
adb logcat -d | grep -E "D42-RENDER|D42-VERIF|D42-TRACE|ExportWorker|Transformer" > "${SORTIE}/logcat.txt" || true
mv instrumentation.txt "${SORTIE}/" 2>/dev/null || true

echo "== contenu récupéré =="
find "${SORTIE}" -maxdepth 2 -type f | sort | head -50
echo "mp4=$(find "${SORTIE}" -name '*.mp4' | wc -l)"
