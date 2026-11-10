#!/usr/bin/env bash
# D42.28 (P3) — exécuter la matrice 4 langues × 1 mode sur UN émulateur.
#
#   tools/e2e/run_p3_matrix.sh <musique|voix|mix> [apk]
#
# Le paramètre `script:` de reactivecircus/android-emulator-runner joint les
# lignes avec « && » : une boucle shell multi-lignes y devient invalide
# (« Syntax error: expecting done », run 42728217504). Toute la logique vit
# donc dans CE script du dépôt, appelé en une seule ligne par le workflow.
set -uo pipefail
cd "$(dirname "$0")/../.." || exit 1

MODE="${1:?mode requis : musique|voix|mix}"
APK="${2:-app/build/outputs/apk/debug/app-debug.apk}"

case "$MODE" in musique|voix|mix) ;; *) echo "mode inconnu : $MODE"; exit 2 ;; esac

ECHEC=0
for L in fr en es ja; do
  echo "===== P3 $MODE / $L ====="
  if ! bash tools/e2e/run_audio_modes.sh p3 "$L" "$MODE" "$APK"; then
    echo "===== P3 $MODE / $L : le banc s'est terminé en échec (voir artefacts) ====="
    ECHEC=$((ECHEC+1))
  fi
done
echo "===== FIN P3 $MODE : $ECHEC langue(s) en échec sur 4 ====="
# Le workflow collecte les artefacts ; on ne fait pas échouer le job pour
# laisser les résultats par langue être jugés cellule par cellule.
exit 0
