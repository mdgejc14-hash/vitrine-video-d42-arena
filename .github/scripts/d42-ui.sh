#!/usr/bin/env bash
# =============================================================================
# D42 — robot UI : exploration automatisée des écrans réels de l'APK publié.
#
#   bash .github/scripts/d42-ui.sh <sortie>
#
# Aucune image préparée : chaque ligne de la matrice est le résultat d'un clic
# réel sur la hiérarchie d'accessibilité de l'appareil, suivi d'une capture
# prise APRÈS l'action.
#
# Échoue si l'instrumentation échoue (crash détecté ou écran sans issue).
# =============================================================================
set -euo pipefail

SORTIE="${1:-ui-out}"

AAPT="$(ls /usr/local/lib/android/sdk/build-tools/*/aapt 2>/dev/null | tail -1 || true)"
TEST_PKG=""
if [ -n "${AAPT}" ] && [ -x "${AAPT}" ]; then
  TEST_PKG="$("${AAPT}" dump badging apk/app-debug-androidTest.apk 2>/dev/null \
    | awk '/^package:/{print $2}' | sed "s/name='//;s/'//" || true)"
fi
TEST_PKG="${TEST_PKG:-video.vitrine.app.test}"
echo "package_de_test=${TEST_PKG}"

adb install -r apk/app-debug.apk
adb install -r apk/app-debug-androidTest.apk
echo "coeurs_guest=$(adb shell nproc | tr -d '\r')"

set +e
adb shell am instrument -w -r \
  -e class video.vitrine.d42.UiRobotTest \
  "${TEST_PKG}/androidx.test.runner.AndroidJUnitRunner" 2>&1 | tee instrumentation-ui.txt
STATUT=$?
set -e

mkdir -p "${SORTIE}"
# API 30+ : /sdcard/Android/data est inaccessible au shell → repli run-as.
if ! adb pull /sdcard/Android/data/video.vitrine.app/files/d42/ui "${SORTIE}/" 2>/dev/null; then
  echo "pull direct refusé — repli run-as"
  adb exec-out run-as video.vitrine.app tar -cf - files/d42/ui \
    | tar -xf - -C "${SORTIE}" --strip-components=2 || true
fi
cp instrumentation-ui.txt "${SORTIE}/" 2>/dev/null || true
adb logcat -d | grep -E "D42-UI" > "${SORTIE}/logcat-ui.txt" || true

echo "== matrice récupérée =="
ls -la "${SORTIE}" || true
cat "${SORTIE}/resume.txt" 2>/dev/null || echo "resume.txt absent"

if ! grep -q "^OK (" instrumentation-ui.txt; then
  echo "::error title=ROBOT UI EN ECHEC::voir instrumentation-ui.txt (crash ou écran sans issue)"
  exit 1
fi
echo "robot UI : OK"
