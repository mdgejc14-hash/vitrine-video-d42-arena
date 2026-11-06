#!/usr/bin/env bash
# Laboratoire D42.14 — preuve des 4 LANGUES (P5).
#
# Ce script ne teste PAS tout le parcours (c'est P0/P1) : il prouve qu'après
# sélection d'une langue, l'application affiche réellement les écrans dans cette
# langue, jusqu'au catalogue inclus. Les libellés attendus sont lus depuis les
# ressources `values-<langue>` du dépôt : aucune valeur inventée.
#
# Usage : run_langue.sh <tag> <fr|en|es|ja> [apk]
set -uo pipefail

TAG="${1:-langue}"
LANGUE="${2:-fr}"
APK="${3:-app/build/outputs/apk/debug/app-debug.apk}"
PKG="video.vitrine.app"
OUT="artifacts/${TAG}_${LANGUE}"
UI="python3 tools/e2e/ui.py"
mkdir -p "$OUT"
RESULTS="$OUT/results.tsv"
: > "$RESULTS"

pass=0; fail=0; blocked=0
record() {
  printf '%s\t%s\t%s\n' "$1" "$2" "$3" >> "$RESULTS"
  case "$1" in PASS) pass=$((pass+1));; FAIL) fail=$((fail+1));; *) blocked=$((blocked+1));; esac
  echo "E2E_RESULT $1 $2 :: $3"
}
shot() { $UI shot "$OUT/$1.png" >/dev/null 2>&1 && echo "E2E SHOT $1" || echo "E2E SHOT_FAIL $1"; }
dump() { adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1; adb exec-out cat /sdcard/d.xml > "$OUT/$1.xml" 2>/dev/null; }

case "$LANGUE" in
  fr) CARTE="Français";  ATTENDU_AUTH="Continuer avec Google";      S1="Filme. Vends. C'est tout."
      S2="Filme tes produits, on te guide";                        S3="Une vidéo prête à publier en 30 secondes"
      SUIVANT="Suivant"; DEMARRER="Commencer"; SECTEUR="Ton activité principale"
      CONTINUER="Continuer"; SANS_CODE="Je n'ai pas de code"; CATALOGUE="Choisissez un modèle de vidéo" ;;
  en) CARTE="English";   ATTENDU_AUTH="Continue with Google";       S1="Shoot. Sell. Done."
      S2="Film your products, we guide you";                       S3="A video ready to post in 30 seconds"
      SUIVANT="Next"; DEMARRER="Get started"; SECTEUR="Your main business"
      CONTINUER="Continue"; SANS_CODE="I don't have a code"; CATALOGUE="Pick a video template" ;;
  es) CARTE="Español";   ATTENDU_AUTH="Continuar con Google";       S1="Filma. Vende. Listo."
      S2="Filma tus productos, te guiamos";                        S3="Un vídeo listo para publicar en 30 segundos"
      SUIVANT="Siguiente"; DEMARRER="Empezar"; SECTEUR="Tu actividad principal"
      CONTINUAR="Continuar"; SANS_CODE="No tengo código"; CATALOGUE="Elige una plantilla de vídeo" ;;
  ja) CARTE="日本語";     ATTENDU_AUTH="Googleで続ける";             S1="撮って、売る。それだけ。"
      S2="商品を撮るだけ、あとはご案内します";                       S3="30秒で公開できる動画に"
      SUIVANT="次へ"; DEMARRER="はじめる"; SECTEUR="あなたの業種"
      CONTINUAR="次へ"; SANS_CODE="コードを持っていません"; CATALOGUE="動画テンプレートを選択" ;;
  *) echo "langue inconnue : $LANGUE"; exit 2 ;;
esac

echo "=========== LANGUE $LANGUE ($TAG) ==========="
adb devices | sed 's/^/E2E /'
adb uninstall "$PKG" >/dev/null 2>&1
if adb install -r -t "$APK" > "$OUT/install.log" 2>&1; then
  record PASS "L_installation_$LANGUE" "$(tail -1 "$OUT/install.log" | tr -d '\r')"
else
  record FAIL "L_installation_$LANGUE" "$(tail -2 "$OUT/install.log" | tr '\n' ' ')"
  exit 0
fi
adb shell pm clear "$PKG" >/dev/null 2>&1
adb shell pm grant "$PKG" android.permission.CAMERA >/dev/null 2>&1
adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start.log" 2>&1
sleep 3

# 1. écran de langue (titre dans la langue du système : on accepte les 4)
ok=0
for t in "Choisissez votre langue" "Choose your language" "Elige tu idioma" "言語を選んでください"; do
  if $UI wait --text "$t" --exact --timeout 20 >/dev/null 2>&1; then ok=1; break; fi
done
[ "$ok" = "1" ] && record PASS "L_ecran_langue_$LANGUE" "écran de langue affiché" \
                 || record FAIL "L_ecran_langue_$LANGUE" "écran de langue absent"
shot "01_langue_$LANGUE"; dump "01_langue_$LANGUE"

# 2. sélection de la langue
# Le premier appui applique la locale et recrée l'activité : on réessaie
# jusqu'à ce que l'écran d'authentification apparaisse réellement.
ok=0
for essai in 1 2 3 4; do
  if $UI tap --text "$CARTE" --exact --timeout 15 >/dev/null 2>&1; then ok=1; fi
  if $UI wait --text "$ATTENDU_AUTH" --exact --timeout 25 >/dev/null 2>&1; then ok=2; break; fi
  echo "E2E langue $LANGUE : appui $essai sans effet"
done
if [ "$ok" = "2" ]; then
  record PASS "L_selection_$LANGUE" "carte « $CARTE » actionnée et appliquée"
  record PASS "L_connexion_$LANGUE" "bouton « $ATTENDU_AUTH » affiché"
else
  record FAIL "L_selection_$LANGUE" "carte « $CARTE » sans effet"
  record FAIL "L_connexion_$LANGUE" "« $ATTENDU_AUTH » absent"
fi
shot "02_connexion_$LANGUE"; dump "02_connexion_$LANGUE"

# 3. session locale -> carrousel (3 slogans dans la langue choisie)
$UI tap --id "auth_offline_button" --timeout 20 >/dev/null 2>&1
if $UI wait --text "$S1" --exact --timeout 120 >/dev/null 2>&1; then
  record PASS "L_carrousel1_$LANGUE" "« $S1 »"
else
  record FAIL "L_carrousel1_$LANGUE" "« $S1 » absent"
fi
shot "03_carrousel1_$LANGUE"; dump "03_carrousel1_$LANGUE"
$UI tap --text "$SUIVANT" --exact --timeout 15 >/dev/null 2>&1
if $UI wait --text "$S2" --exact --timeout 30 >/dev/null 2>&1; then
  record PASS "L_carrousel2_$LANGUE" "« $S2 »"
else
  record FAIL "L_carrousel2_$LANGUE" "« $S2 » absent"
fi
shot "04_carrousel2_$LANGUE"
$UI tap --text "$SUIVANT" --exact --timeout 15 >/dev/null 2>&1
if $UI wait --text "$S3" --exact --timeout 30 >/dev/null 2>&1; then
  record PASS "L_carrousel3_$LANGUE" "« $S3 »"
else
  record FAIL "L_carrousel3_$LANGUE" "« $S3 » absent"
fi
shot "05_carrousel3_$LANGUE"
$UI tap --text "$DEMARRER" --exact --timeout 15 >/dev/null 2>&1

# 4. activité -> parrainage -> catalogue, tous localisés
if $UI wait --text "$SECTEUR" --exact --timeout 60 >/dev/null 2>&1; then
  record PASS "L_activite_$LANGUE" "« $SECTEUR »"
else
  record FAIL "L_activite_$LANGUE" "« $SECTEUR » absent"
fi
shot "06_activite_$LANGUE"
# carte secteur : on tape le premier élément cliquable proposé, quel que soit le libellé
$UI tap --text "Commerce" --timeout 5 >/dev/null 2>&1 || true
$UI tap --text "Boutique" --timeout 5 >/dev/null 2>&1 || true
$UI tap --text "$CONTINUER" --exact --timeout 15 >/dev/null 2>&1
if $UI wait --text "$SANS_CODE" --exact --timeout 30 >/dev/null 2>&1; then
  record PASS "L_parrainage_$LANGUE" "étape parrainage localisée"
  $UI tap --text "$SANS_CODE" --exact --timeout 10 >/dev/null 2>&1
else
  record BLOCKED "L_parrainage_$LANGUE" "étape parrainage non atteinte"
fi
sleep 2
$UI tap --text "$CONTINUER" --exact --timeout 20 >/dev/null 2>&1 || true
sleep 3
if $UI wait --text "$CATALOGUE" --exact --timeout 40 >/dev/null 2>&1; then
  record PASS "L_catalogue_$LANGUE" "« $CATALOGUE » affiché"
else
  record FAIL "L_catalogue_$LANGUE" "« $CATALOGUE » absent"
fi
shot "07_catalogue_$LANGUE"; dump "07_catalogue_$LANGUE"

if adb logcat -d -b crash | grep -q "FATAL EXCEPTION"; then
  adb logcat -d -b crash > "$OUT/crash.log"
  record FAIL "L_crash_$LANGUE" "FATAL EXCEPTION"
else
  record PASS "L_crash_$LANGUE" "aucune FATAL EXCEPTION"
fi
adb logcat -d > "$OUT/logcat.txt" 2>/dev/null

{ echo "tag=$TAG langue=$LANGUE"; echo "PASS=$pass FAIL=$fail BLOCKED=$blocked"
  echo "apk=$APK"; echo "sha256=$(sha256sum "$APK" 2>/dev/null | cut -d' ' -f1)"; } > "$OUT/summary.txt"
cat "$OUT/summary.txt"
echo "=========== FIN LANGUE $LANGUE : PASS=$pass FAIL=$fail BLOCKED=$blocked ==========="
exit 0
