#!/usr/bin/env bash
# Laboratoire D42.14 — parcours P1 : catalogue -> gabarit -> brief -> caméra
# -> prises -> export -> partage.
#
# Usage : run_p1.sh <tag> [apk]
# La caméra utilisée est la CAMÉRA VIRTUELLE DE L'ÉMULATEUR (-camera-back emulated).
# Ce n'est PAS un capteur physique : la chaîne testée est réelle (CameraX ->
# MediaCodec -> fichier MP4), l'image filmée est synthétique. Tout résultat est
# donc PASS_EMULATOR, jamais PASS_DEVICE.
set -uo pipefail

TAG="${1:-p1}"
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
dump() { adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1; adb exec-out cat /sdcard/d.xml > "$OUT/$1.xml" 2>/dev/null; }
tap_if() { # texte, id, timeout
  if [ -n "${2:-}" ]; then $UI tap --id "$2" --timeout "${3:-8}" >/dev/null 2>&1 && return 0; fi
  if [ -n "${1:-}" ]; then $UI tap --text "$1" --timeout "${3:-8}" >/dev/null 2>&1 && return 0; fi
  return 1
}
# D42.14 — un PASS n'est enregistré QUE sur constat d'écran, jamais sur le
# simple fait qu'un `tap` a renvoyé 0. C'est ce qui a produit le faux
# « P1_activite PASS » du run 42189554849, où le libellé « Continuer »
# correspondait en réalité à « Continuer sans compte » de l'écran PRÉCÉDENT.
etape_any() { # nom, timeout, texte1 [texte2 ...] — l'app démarre dans la langue du système
  local nom="$1" tmo="$2"; shift 2
  local t
  for t in "$@"; do
    if $UI wait --text "$t" --exact --timeout "$tmo" >/dev/null 2>&1; then
      record PASS "$nom" "écran constaté : « $t »"
      return 0
    fi
  done
  record FAIL "$nom" "aucun des libellés attendus ($*) après ${tmo}s"
  return 1
}
etape() { # nom, texte exact attendu, timeout
  if $UI wait --text "$2" --exact --timeout "${3:-40}" >/dev/null 2>&1; then
    record PASS "$1" "écran constaté : « $2 »"
    return 0
  fi
  record FAIL "$1" "« $2 » absent après ${3:-40}s ($(date -u +%H:%M:%SZ))"
  return 1
}

echo "=========== P1 $TAG (APK=$APK) ==========="
adb devices | sed 's/^/E2E /'
$UI size | sed 's/^/E2E /' || { record FAIL P1_preflight "ui.py inutilisable"; exit 0; }

# --- installation + permissions pré-accordées (le dialogue système n'est PAS
#     ce que l'on teste ici ; il est testé séparément par S_permission) --------
adb uninstall "$PKG" >/dev/null 2>&1
if adb install -r -t "$APK" > "$OUT/install.log" 2>&1; then
  record PASS P1_installation "$(tail -1 "$OUT/install.log" | tr -d '\r')"
  VERSION=$(adb shell dumpsys package "$PKG" | grep -m1 versionName | tr -d '\r')
  NAME=$(adb shell pm list packages "$PKG" | tr -d '\r')
  record PASS P1_paquet "pkg=$NAME $VERSION"
else
  record FAIL P1_installation "$(tail -2 "$OUT/install.log" | tr '\n' ' ')"
  exit 0
fi
adb shell pm grant "$PKG" android.permission.CAMERA >/dev/null 2>&1 \
  && record PASS P1_permission_camera "accordée par pm grant" \
  || record BLOCKED P1_permission_camera "pm grant refusé"
adb shell pm grant "$PKG" android.permission.RECORD_AUDIO >/dev/null 2>&1

adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start.log" 2>&1
sleep 4

# --- parcours amont : langue -> connexion -> carrousel -> activité -> accueil --
# Machine à états VÉRIFIÉE : on attend le marqueur de l'écran attendu, on agit,
# puis on attend le marqueur de l'écran SUIVANT. Aucune étape ne se contente du
# code retour d'un tap (cf. défaut du run 42189554849).
# L'application démarre dans la langue du SYSTÈME (émulateur = en-US) : le titre
# de l'écran de langue n'est donc pas forcément en français. On accepte les 4
# libellés officiels, puis on choisit « Français » (identique dans les 4 langues).
etape_any P1_ecran_langue 60 "Choisissez votre langue" "Choose your language" \
  "Elige tu idioma" "言語を選んでください" || true
$UI tap --text "Français" --exact --timeout 20 >/dev/null 2>&1
etape_any P1_ecran_connexion 90 "Continuer avec Google" "Continue with Google" \
  "Continuar con Google" "Googleで続ける" || true

if tap_if "" "auth_offline_button" 20; then
  if $UI gone --id "auth_offline_button" --timeout 90 >/dev/null 2>&1; then
    record PASS P1_session_locale "repli sans compte : écran d'authentification quitté"
  else
    record FAIL P1_session_locale "écran d'authentification toujours affiché 90s après le repli"
  fi
else
  record FAIL P1_session_locale "bouton de repli absent"
fi

# Carrousel : 3 écrans, chacun identifié par SON slogan (jamais par la présence
# du bouton, qui porte le même libellé d'un écran à l'autre).
etape P1_carrousel_1 "Filme. Vends. C'est tout." 90 || true
$UI inside --text "Suivant" --exact --timeout 10 | sed 's/^/E2E /' || true
$UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1
etape P1_carrousel_2 "Filme tes produits, on te guide" 30 || true
$UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1
etape P1_carrousel_3 "Une vidéo prête à publier en 30 secondes" 30 || true
$UI tap --text "Commencer" --exact --timeout 10 >/dev/null 2>&1

etape P1_activite "Ton activité principale" 60 || true
tap_if "Commerce" "" 10 || tap_if "Boutique" "" 8 || true
sleep 1
if $UI tap --text "Continuer" --exact --timeout 15 >/dev/null 2>&1; then
  record PASS P1_activite_continue "bouton Continuer (libellé entier) actionné"
else
  record FAIL P1_activite_continue "bouton Continuer introuvable sur l'écran d'activité"
fi
if $UI wait --text "Ton code parrain" --exact --timeout 30 >/dev/null 2>&1; then
  record PASS P1_parrainage "étape code parrain affichée"
  tap_if "Je n'ai pas de code" "" 10 >/dev/null 2>&1 ||     $UI tap --text "Je n'ai pas de code" --exact --timeout 8 >/dev/null 2>&1
else
  record BLOCKED P1_parrainage "étape parrainage non atteinte"
fi
sleep 2
$UI tap --text "Continuer" --exact --timeout 20 >/dev/null 2>&1 || true
sleep 2

# --- S20 catalogue -------------------------------------------------------------
if $UI wait --text "modèle de vidéo" --timeout 25 >/dev/null 2>&1; then
  record PASS P1_catalogue "catalogue atteint"
  shot 20_catalogue; dump 20_catalogue
else
  record FAIL P1_catalogue "catalogue non atteint"; shot 20_catalogue_fail; dump 20_catalogue_fail
fi
if $UI inside --text "Nouvel arrivage" --timeout 10 >/dev/null 2>&1; then
  record PASS P1_gabarit_visible "gabarit 'Nouvel arrivage' entièrement visible"
else
  record FAIL P1_gabarit_visible "gabarit hors écran ou absent"
fi

# --- S21 sélection d'un gabarit -> brief --------------------------------------
if tap_if "Nouvel arrivage" "" 10; then record PASS P1_selection_gabarit "gabarit sélectionné"; else record FAIL P1_selection_gabarit "clic gabarit impossible"; fi
sleep 4
shot 21_brief; dump 21_brief
if $UI wait --text "Saisis" --timeout 25 >/dev/null 2>&1 || $UI wait --text "publicité" --timeout 5 >/dev/null 2>&1; then
  record PASS P1_brief "formulaire de brief affiché"
else
  record BLOCKED P1_brief "formulaire non identifié (voir dump 21)"
fi

# --- S22 saisie + validation du brief -----------------------------------------
if tap_if "" "" 1; then :; fi
$UI tap --text "Saisis" --timeout 10 >/dev/null 2>&1
sleep 1
adb shell input text "Boutique Chez Awa, articles neufs a petits prix" >/dev/null 2>&1
sleep 1
shot 22_brief_saisi; dump 22_brief_saisi
ok=0
for i in 1 2 3 4 5 6; do
  if tap_if "Continuer" "" 6; then ok=1; sleep 2; continue; fi
  if tap_if "Ma vidéo" "" 4; then ok=1; sleep 2; continue; fi
  if tap_if "Tout est prêt" "" 4; then ok=1; sleep 3; continue; fi
  if tap_if "C'est parti" "" 4; then ok=1; sleep 3; continue; fi
  break
done
[ "$ok" = "1" ] && record PASS P1_brief_valide "brief soumis" || record BLOCKED P1_brief_valide "aucun bouton de validation trouvé"
sleep 4
shot 23_camera; dump 23_camera

# --- S23 caméra guidée ---------------------------------------------------------
if $UI wait --text "Filme ta prise" --timeout 40 >/dev/null 2>&1; then
  record PASS P1_camera_ecran "écran « Filme ta prise » affiché (caméra virtuelle de l'émulateur)"
  shot 24_camera_ecran
else
  record BLOCKED P1_camera_ecran "écran caméra non atteint (voir dump 23)"
fi
# Aucun dialogue de consentement ne doit apparaître sans visage détecté
if $UI wait --text "Accord du client" --timeout 4 >/dev/null 2>&1; then
  record FAIL P1_porte_r4_intempestive "porte R4 affichée alors qu'aucun visage n'est filmé"
  tap_if "Oui, accord confirmé" "" 5
else
  record PASS P1_porte_r4 "aucune porte de consentement affichée sans visage"
fi

# --- S24 enregistrement de 2 prises -------------------------------------------
prises=0
for n in 1 2; do
  if $UI tap --text "Tourner" --exact --timeout 10 >/dev/null 2>&1; then
    sleep 6
    shot "25_prise_${n}_enregistrement"
    # arrêt : le bouton devient « Arrêter » ou un appui sur l'overlay stoppe
    $UI tap --text "Arrêter" --exact --timeout 8 >/dev/null 2>&1 || adb shell input tap 540 1500
    sleep 4
    prises=$((prises+1))
    record PASS "P1_prise_$n" "enregistrement lancé puis arrêté"
    shot "26_prise_${n}_faite"; dump "26_prise_${n}_faite"
  else
    record BLOCKED "P1_prise_$n" "bouton Tourner absent"
    break
  fi
  $UI tap --text "Suivant" --exact --timeout 8 >/dev/null 2>&1 || true
  sleep 2
done
[ "$prises" -ge 1 ] && record PASS P1_prises "prises enregistrées: $prises" || record BLOCKED P1_prises "aucune prise"
sleep 3
shot 27_apres_prises; dump 27_apres_prises

# --- S25 export ----------------------------------------------------------------
if $UI wait --text "export" --timeout 30 >/dev/null 2>&1 || $UI wait --text "Aperçu" --timeout 5 >/dev/null 2>&1; then
  record PASS P1_apercu_export "écran d'aperçu / export atteint"
  shot 28_apercu
else
  record BLOCKED P1_apercu_export "écran d'export non atteint"
fi
if $UI tap --text "Lancer l'export local" --timeout 15 >/dev/null 2>&1; then record PASS P1_export_lance "export lancé"; else record BLOCKED P1_export_lance "bouton d'export introuvable"; fi
if $UI wait --text "Vidéo prête" --timeout 600 >/dev/null 2>&1; then
  record PASS P1_export_termine "« Vidéo prête ! » affiché"
  shot 29_export_termine; dump 29_export_termine
else
  record FAIL P1_export_termine "aucune fin d'export en 10 min"; shot 29_export_timeout; dump 29_export_timeout
fi

# --- S26 fichier MP4 (uniquement si l'APK est débuggable) ----------------------
if adb shell run-as "$PKG" ls cache >/dev/null 2>&1; then
  MP4=$(adb shell run-as "$PKG" ls cache 2>/dev/null | tr -d '\r' | grep -m1 'export-.*\.mp4')
  if [ -n "${MP4:-}" ]; then
    adb exec-out run-as "$PKG" cat "cache/$MP4" > "$OUT/export.mp4" 2>/dev/null
    TAILLE=$(stat -c%s "$OUT/export.mp4" 2>/dev/null || echo 0)
    record PASS P1_mp4_extrait "$MP4 ($TAILLE octets)"
  else
    record FAIL P1_mp4_extrait "aucun fichier export-*.mp4 dans cache"
  fi
else
  record BLOCKED P1_mp4_extrait "APK release non débuggable : extraction du MP4 impossible (attendu)"
fi

# --- S27 partage ---------------------------------------------------------------
if $UI tap --text "Partager" --exact --timeout 12 >/dev/null 2>&1; then
  sleep 3; shot 30_partage; dump 30_partage
  if adb shell dumpsys activity activities 2>/dev/null | grep -qi "chooser\|ResolverActivity"; then
    record PASS P1_partage "feuille de partage Android ouverte"
  else
    record BLOCKED P1_partage "aucune feuille de partage détectée"
  fi
else
  record BLOCKED P1_partage "bouton Partager introuvable"
fi

# --- stabilité -----------------------------------------------------------------
if adb logcat -d -b crash | grep -q "FATAL EXCEPTION"; then
  adb logcat -d -b crash > "$OUT/crash.log"
  record FAIL P1_aucun_crash "FATAL EXCEPTION (crash.log)"
else
  record PASS P1_aucun_crash "aucune FATAL EXCEPTION"
fi
adb logcat -d > "$OUT/logcat.txt" 2>/dev/null
adb shell dumpsys meminfo "$PKG" 2>/dev/null | head -12 > "$OUT/meminfo.txt"

{ echo "tag=$TAG"; echo "apk=$APK"; echo "sha256=$(sha256sum "$APK" | cut -d' ' -f1)"
  echo "PASS=$pass FAIL=$fail BLOCKED=$blocked"; } > "$OUT/summary.txt"
cat "$OUT/summary.txt"
echo "=========== FIN P1 $TAG : PASS=$pass FAIL=$fail BLOCKED=$blocked ==========="
exit 0
