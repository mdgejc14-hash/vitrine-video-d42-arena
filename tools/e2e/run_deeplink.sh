#!/usr/bin/env bash
# D42.27-08 — PARRAINAGE DEEP-LINK BOUT-EN-BOUT (audit F).
#
# CE QUE CE BANC COUVRE :
#   D1 — adb ACTION_VIEW https://vitrine.video/r/CODE résout vers l'app
#        (filtre manifest, sans autoVerify : résolution explicite par -p,
#        le sélecteur système est constaté à part) ;
#   D2 — le code du lien est AFFICHÉ à l'écran auth (« Code parrain
#        détecté : CODE ») ;
#   D3 — le code est TRANSMIS à l'étape parrainage de l'onboarding :
#        champ PRÉ-REMPULI avec le code du lien (D42.27-08 : plus besoin
#        de le retaper) ;
#   D4 — le parcours continue normalement après le lien (catalogue
#        atteint) — le lien ne casse rien ;
#   D5 — zéro crash.
#
# NOTE : l'attribution SERVEUR du parrainage (unicité, anti-doublon,
# historique) est déjà prouvée par les bancs API 8.3-8.7 ; ici on prouve
# le bout-en-bout UTILISATEUR : lien → auth → onboarding.
#
# Usage : run_deeplink.sh <tag> [apk]
set -uo pipefail

TAG="${1:-deeplink}"
APK="${2:-app/build/outputs/apk/debug/app-debug.apk}"
PKG="video.vitrine.app"
OUT="artifacts/${TAG}"
CODE_LIEN="E2E-123"

UI="python3 tools/e2e/ui.py"
mkdir -p "$OUT"
RESULTS="$OUT/results.tsv"
: > "$RESULTS"
exec 2> >(tee -a "$OUT/stderr.log" >&2)

pass=0; fail=0; blocked=0
record() {
  printf '%s\t%s\t%s\n' "$1" "$2" "$3" >> "$RESULTS"
  case "$1" in PASS) pass=$((pass+1));; FAIL) fail=$((fail+1));; *) blocked=$((blocked+1));; esac
  echo "E2E_RESULT $1 $2 :: $3"
}
shot() { $UI shot "$OUT/$1.png" >/dev/null 2>&1 && echo "E2E SHOT $1" || echo "E2E SHOT_FAIL $1"; }
dump() {
  adb shell rm -f /sdcard/d.xml >/dev/null 2>&1
  adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1
  adb exec-out cat /sdcard/d.xml > "$OUT/$1.xml" 2>/dev/null
  if [ -s "$OUT/$1.xml" ]; then echo "E2E DUMP $1 ($(wc -c < "$OUT/$1.xml") octets)"; else echo "E2E DUMP_VIDE $1"; fi
}
tap_if() {
  if [ -n "${2:-}" ]; then $UI tap --id "$2" --timeout "${3:-8}" >/dev/null 2>&1 && return 0; fi
  if [ -n "${1:-}" ]; then $UI tap --text "$1" --timeout "${3:-8}" >/dev/null 2>&1 && return 0; fi
  return 1
}

echo "=========== DEEP-LINK PARRAINAGE $TAG (APK=$APK) ==========="
adb devices | sed 's/^/E2E /'
$UI size | sed 's/^/E2E /' || { record FAIL D0_preflight "ui.py inutilisable"; exit 0; }

adb uninstall "$PKG" >/dev/null 2>&1
if ! adb install -r -t "$APK" > "$OUT/install.log" 2>&1; then
  record FAIL D0_installation "$(tail -2 "$OUT/install.log" | tr '\n' ' ')"; exit 0
fi
record PASS D0_installation "APK installée (banc deep-link)"

# --- D1 : ACTION_VIEW résout vers l'app (résolution explicite) ---
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://vitrine.video/r/$CODE_LIEN" -p "$PKG" > "$OUT/am_start_view.log" 2>&1
sleep 5
d1_vu=0
for t in "Choisissez votre langue" "Choose your language" "Elige tu idioma" "言語を選んでください"; do
  if $UI wait --text "$t" --exact --timeout 15 >/dev/null 2>&1; then d1_vu=1; break; fi
done
if [ "$d1_vu" = "1" ]; then
  record PASS D1_vue_resolution "ACTION_VIEW https://vitrine.video/r/$CODE_LIEN résolu vers l'app (écran langue atteint)"
else
  record FAIL D1_vue_resolution "lien non résolu vers l'app (voir am_start_view.log)"
  shot D1_rate; dump D1_rate
fi

# langue FR (première installation)
for essai in 1 2 3 4; do
  $UI tap --text "Français" --exact --timeout 15 >/dev/null 2>&1
  if $UI wait --text "Continuer avec Google" --exact --timeout 25 >/dev/null 2>&1; then break; fi
done
sleep 2
shot D2_auth; dump D2_auth

# --- D2 : le code est AFFICHÉ à l'auth ---
if grep -q "Code parrain détecté : $CODE_LIEN" "$OUT/D2_auth.xml" 2>/dev/null; then
  record PASS D2_code_affiche_auth "« Code parrain détecté : $CODE_LIEN » affiché à l'écran auth"
else
  record FAIL D2_code_affiche_auth "code du lien non affiché à l'auth (voir D2_auth.xml)"
fi

# --- repli démo (le lien ne doit pas perturber la connexion) ---
for essai in 1 2 3 4 5; do
  $UI tap --id "auth_offline_button" --timeout 10 >/dev/null 2>&1
  $UI gone --id "auth_offline_button" --timeout 20 >/dev/null 2>&1 && break
  sleep 4
done

# carrousel → activité → étape parrainage
$UI wait --text "Filme. Vends. C'est tout." --exact --timeout 60 >/dev/null 2>&1 || true
$UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1
$UI wait --text "Filme tes produits, on te guide" --exact --timeout 20 >/dev/null 2>&1 || true
$UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1
$UI wait --text "Une vidéo prête à publier en 30 secondes" --exact --timeout 20 >/dev/null 2>&1 || true
$UI tap --text "Commencer" --exact --timeout 10 >/dev/null 2>&1
$UI wait --text "Ton activité principale" --exact --timeout 40 >/dev/null 2>&1 || true
tap_if "Commerce" "" 10 || tap_if "Boutique" "" 8 || true
sleep 1
$UI tap --text "Continuer" --exact --timeout 15 >/dev/null 2>&1

# --- D3 : étape parrainage avec champ PRÉ-REMPULI ---
if $UI wait --text "Ton code parrain" --exact --timeout 40 >/dev/null 2>&1; then
  sleep 2
  shot D3_parrainage; dump D3_parrainage
  if grep -q "$CODE_LIEN" "$OUT/D3_parrainage.xml" 2>/dev/null; then
    record PASS D3_champ_pre_rempli "étape parrainage atteinte et champ PRÉ-REMPULI avec le code du lien ($CODE_LIEN)"
  else
    record FAIL D3_champ_pre_rempli "étape parrainage atteinte mais champ VIDE — le code du lien n'est pas restitué (voir D3_parrainage.xml)"
  fi
else
  record BLOCKED D3_champ_pre_rempli "étape parrainage non atteinte (voir dumps)"
  shot D3_rate; dump D3_rate
fi

# --- D4 : le parcours continue (Continuer avec le code pré-rempli) ---
if $UI tap --text "Continuer" --exact --timeout 12 >/dev/null 2>&1; then
  catalogue=0
  for essai in 1 2 3; do
    if $UI wait --text "modèle de vidéo" --timeout 20 >/dev/null 2>&1; then catalogue=1; break; fi
    $UI tap --text "Continuer" --exact --timeout 10 >/dev/null 2>&1 || true
    sleep 3
  done
  if [ "$catalogue" = "1" ]; then
    record PASS D4_parcours_continue "parcours complet après deep-link : catalogue atteint"
  else
    record FAIL D4_parcours_continue "catalogue non atteint après deep-link (voir dumps)"
    shot D4_rate; dump D4_rate
  fi
else
  record BLOCKED D4_parcours_continue "bouton Continuer de l'étape parrainage introuvable"
fi

# --- D5 : intégrité ---
if adb shell pidof "$PKG" >/dev/null 2>&1; then
  record PASS D5_app_vivante "processus vivant en fin de banc deep-link"
else
  record FAIL D5_app_vivante "processus mort en fin de banc"
fi
adb logcat -d | grep -A 20 "FATAL EXCEPTION" | grep -B 2 -A 18 "Process: $PKG" > "$OUT/crash_dl.txt" 2>&1 || true
if [ -s "$OUT/crash_dl.txt" ]; then
  record FAIL D5_aucun_crash "FATAL EXCEPTION pendant le banc deep-link (voir crash_dl.txt)"
else
  record PASS D5_aucun_crash "aucun FATAL EXCEPTION (deep-link bout-en-bout)"
fi

echo "tag=$TAG"
echo "PASS=$pass FAIL=$fail BLOCKED=$blocked"
echo "=========== FIN $TAG : PASS=$pass FAIL=$fail BLOCKED=$blocked ==========="
exit 0
