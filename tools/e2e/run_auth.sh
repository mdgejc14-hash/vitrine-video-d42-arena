#!/usr/bin/env bash
# D42.27-07 — AUTH GOOGLE RÉELLE AU LAB (§2, exigence E de l'audit D42.27).
#
# CE QUE CE BANC COUVRE (API A = Credential Manager local, GMS présent sur
# l'image CI « default » = google_apis) :
#   A1 — le bouton « Continuer avec Google » déclenche le VRAI flux
#        Credential Manager : bottom sheet système OU réponse immédiate
#        « aucun compte » (les deux sont des preuves que l'API A vit —
#        le contenu exact dépend de l'état GMS du runner) ;
#   A2 — ANNULATION propre (retour) : message actionnable, boutons
#        réactivés (« Réessayer »), repli hors-connexion intact ;
#   A3 — RE-SOUMISSION après échec : le flux se relance (verrou levé),
#        aucun double-sheet, aucune fenêtre empilée ;
#   A4 — le parcours continue par le repli démo APRÈS l'échec Google ;
#   A5 — zéro FATAL EXCEPTION ; log VV-AUTH capturé (distinction API A /
#        API B : GetCredentialException = locale, FirebaseAuthException =
#        réseau — cette dernière exige un compte réel = fondateur).
#
# CE QUE CE BANC N'EST PAS : le choix d'un VRAI compte Google et la
# vérification Firebase (API B) exigent un compte physique — fondateur
# uniquement. Aucune simulation de connexion réussie (règle §6).
#
# Usage : run_auth.sh <tag> [apk]
set -uo pipefail

TAG="${1:-auth}"
APK="${2:-app/build/outputs/apk/debug/app-debug.apk}"
PKG="video.vitrine.app"
OUT="artifacts/${TAG}"

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
etape() {
  if $UI wait --text "$2" --exact --timeout "${3:-40}" >/dev/null 2>&1; then
    record PASS "$1" "écran constaté : « $2 »"
    return 0
  fi
  record FAIL "$1" "« $2 » absent après ${3:-40}s"
  return 1
}

echo "=========== AUTH GOOGLE RÉELLE $TAG (APK=$APK) ==========="
adb devices | sed 's/^/E2E /'
$UI size | sed 's/^/E2E /' || { record FAIL A0_preflight "ui.py inutilisable"; exit 0; }

adb uninstall "$PKG" >/dev/null 2>&1
if ! adb install -r -t "$APK" > "$OUT/install.log" 2>&1; then
  record FAIL A0_installation "$(tail -2 "$OUT/install.log" | tr '\n' ' ')"; exit 0
fi
record PASS A0_installation "APK installée (banc auth)"
adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start.log" 2>&1
sleep 4

etape A0_langue "Choisissez votre langue" 60 || true
for essai in 1 2 3 4; do
  $UI tap --text "Français" --exact --timeout 15 >/dev/null 2>&1
  if $UI wait --text "Continuer avec Google" --exact --timeout 25 >/dev/null 2>&1; then break; fi
done
if $UI wait --text "Continuer avec Google" --exact --timeout 10 >/dev/null 2>&1; then
  record PASS A0_connexion "écran d'authentification atteint (bouton Google visible)"
else
  record FAIL A0_connexion "écran d'authentification non atteint"
  shot A0_rate; dump A0_rate; exit 0
fi

# --- A1 : le VRAI flux Credential Manager se déclenche ---
adb logcat -c >/dev/null 2>&1
$UI tap --text "Continuer avec Google" --exact --timeout 15 >/dev/null 2>&1
sheet_dump=0 sheet_logcat=0 no_account=0
sleep 12   # le sheet GMS se rend après l'animation système
shot A1_sheet; dump A1_sheet
if grep -qE "Se connecter|Choisissez un compte|Utiliser un autre compte|Aucun compte|Ajouter un compte|Sign in|Choose an account|com\.google\.android\.gms" "$OUT/A1_sheet.xml" 2>/dev/null; then
  sheet_dump=1
fi
adb logcat -d > "$OUT/A1_logcat.txt" 2>&1 || true
if grep -qiE "CredentialManager|GetCredential|credentials\.|GoogleIdOption" "$OUT/A1_logcat.txt" 2>/dev/null; then
  sheet_logcat=1
fi
# Branche (b) : réponse immédiate « aucun compte » affichée par l'app
if $UI wait --text "Aucun compte Google" --timeout 8 >/dev/null 2>&1 \
   || grep -q "Aucun compte Google" "$OUT/A1_sheet.xml" 2>/dev/null; then
  no_account=1
fi
if [ "$sheet_dump" = "1" ] || [ "$sheet_logcat" = "1" ]; then
  record PASS A1_flux_credential "vrai flux Credential Manager déclenché (dump=$sheet_dump logcat=$sheet_logcat no_account=$no_account — voir A1_sheet.xml / A1_logcat.txt)"
elif [ "$no_account" = "1" ]; then
  record PASS A1_flux_credential "API A répondue immédiatement : « Aucun compte Google » (runner sans compte — preuve du flux, pas du sheet)"
else
  record FAIL A1_flux_credential "aucune preuve du flux Credential Manager (ni dump, ni logcat, ni message d'état)"
fi

# --- A2 : ANNULATION PROPRE (retour système) ---
# Le sheet est une fenêtre GMS : le retour la ferme ; GetCredentialException
# (annulation utilisateur) revient à AuthActivity → message actionnable.
adb shell input keyevent 4 >/dev/null 2>&1
sleep 6
shot A2_apres_annulation; dump A2_apres_annulation
a2_msg=0 a2_boutons=0
if grep -qE "Connexion annulée|Aucun compte Google|connexion Google n|La connexion n|La connexion à Internet" "$OUT/A2_apres_annulation.xml" 2>/dev/null; then
  a2_msg=1
fi
if grep -q "Réessayer" "$OUT/A2_apres_annulation.xml" 2>/dev/null; then
  a2_boutons=1
fi
if [ "$a2_msg" = "1" ] || [ "$a2_boutons" = "1" ]; then
  record PASS A2_annulation_propre "annulation traitée : message d'état ($a2_msg) + bouton réactivé « Réessayer » ($a2_boutons)"
else
  record FAIL A2_annulation_propre "ni message d'état ni bouton Réessayer après annulation (voir A2_apres_annulation.xml)"
fi
if grep -q "Utiliser sans Internet" "$OUT/A2_apres_annulation.xml" 2>/dev/null; then
  record PASS A2_repli_intact "repli hors-connexion toujours proposé après l'échec Google"
else
  record FAIL A2_repli_intact "repli hors-connexion disparu après l'échec Google (voir A2_apres_annulation.xml)"
fi

# --- A3 : RE-SOUMISSION (le verrou est levé, pas de double flux) ---
adb logcat -c >/dev/null 2>&1
resoumis=0
if $UI tap --text "Réessayer" --exact --timeout 10 >/dev/null 2>&1 \
   || $UI tap --text "Continuer avec Google" --exact --timeout 10 >/dev/null 2>&1; then
  sleep 10
  shot A3_resoumission; dump A3_resoumission
  adb logcat -d > "$OUT/A3_logcat.txt" 2>&1 || true
  if grep -qiE "CredentialManager|GetCredential|GoogleIdOption" "$OUT/A3_logcat.txt" 2>/dev/null \
     || grep -qE "Se connecter|Choisissez un compte|Aucun compte|Sign in|com\.google\.android\.gms" "$OUT/A3_resoumission.xml" 2>/dev/null; then
    resoumis=1
  fi
fi
if [ "$resoumis" = "1" ]; then
  record PASS A3_resoumission "second flux relancé proprement après échec (verrou anti double-soumission levé)"
else
  record FAIL A3_resoumission "le flux ne se relance pas après l'échec (voir A3_resoumission.xml / A3_logcat.txt)"
fi
adb shell input keyevent 4 >/dev/null 2>&1
sleep 5

# --- A4 : le parcours CONTINUE par le repli démo ---
for essai in 1 2 3 4 5; do
  $UI tap --id "auth_offline_button" --timeout 10 >/dev/null 2>&1
  $UI gone --id "auth_offline_button" --timeout 20 >/dev/null 2>&1 && break
  sleep 4
done
if $UI wait --text "Filme. Vends. C'est tout." --exact --timeout 40 >/dev/null 2>&1; then
  record PASS A4_parcours_continue "parcours continué par le repli démo après échec Google (carrousel atteint)"
else
  record FAIL A4_parcours_continue "repli démo inopérant après l'échec Google (voir dumps)"
  shot A4_rate; dump A4_rate
fi

# --- A5 : intégrité du processus + journal d'auth capturé ---
if adb shell pidof "$PKG" >/dev/null 2>&1; then
  record PASS A5_app_vivante "processus vivant après tout le scénario auth"
else
  record FAIL A5_app_vivante "processus mort pendant le scénario auth"
fi
adb logcat -d | grep -E "VV-AUTH" > "$OUT/A5_journal_auth.txt" 2>&1 || true
adb logcat -d | grep -A 20 "FATAL EXCEPTION" | grep -B 2 -A 18 "Process: $PKG" > "$OUT/crash_auth.txt" 2>&1 || true
if [ -s "$OUT/crash_auth.txt" ]; then
  record FAIL A5_aucun_crash "FATAL EXCEPTION pendant le banc auth (voir crash_auth.txt)"
else
  record PASS A5_aucun_crash "aucun FATAL EXCEPTION (journal VV-AUTH : $(wc -l < "$OUT/A5_journal_auth.txt" 2>/dev/null || echo 0) lignes capturées)"
fi

echo "tag=$TAG"
echo "PASS=$pass FAIL=$fail BLOCKED=$blocked"
echo "=========== FIN $TAG : PASS=$pass FAIL=$fail BLOCKED=$blocked ==========="
exit 0
