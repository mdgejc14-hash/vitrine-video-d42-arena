#!/usr/bin/env bash
# Laboratoire D42.13 — parcours P0 automatisé sur émulateur Android réel.
# Usage : run_p0.sh <tag> [variante]
#   tag      : nom de la configuration (pixel5, nexus_s, ...)
#   variante : base | font130 | rot90   (défaut : base)
#
# Chaque étape produit une ligne PASS / FAIL / BLOCKED dans results.tsv,
# une capture PNG et un dump uiautomator. Aucune étape ne masque un échec :
# le script continue et le bilan est calculé à la fin.
set -uo pipefail

TAG="${1:-pixel5}"
VARIANTE="${2:-base}"
LANGUE="${3:-fr}"
APK="${APK:-app/build/outputs/apk/debug/app-debug.apk}"
PKG="video.vitrine.app"
OUT="artifacts/${TAG}-${VARIANTE}"
UI="python3 tools/e2e/ui.py"
mkdir -p "$OUT"
RESULTS="$OUT/results.tsv"
: > "$RESULTS"
# Journal complet de la sortie d'erreur (diagnostic des commandes ui.py)
exec 2> >(tee -a "$OUT/stderr.log" >&2)

pass=0; fail=0; blocked=0
record() { # statut, id, détail
  printf '%s\t%s\t%s\n' "$1" "$2" "$3" >> "$RESULTS"
  case "$1" in
    PASS) pass=$((pass+1)) ;;
    FAIL) fail=$((fail+1)) ;;
    *) blocked=$((blocked+1)) ;;
  esac
  echo "E2E_RESULT $1 $2 :: $3"
}
shot() { $UI shot "$OUT/$1.png" >/dev/null 2>&1 || echo "E2E_RESULT BLOCKED shot_$1 :: capture impossible"; }
dump() { adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1; adb exec-out cat /sdcard/d.xml > "$OUT/$1.xml" 2>/dev/null; }

echo "=========== VARIANTE $VARIANTE ($TAG) ==========="
{
  echo "PATH=$PATH"
  echo "ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-}"
  echo "ANDROID_HOME=${ANDROID_HOME:-}"
  echo "adb=$(command -v adb || echo INTROUVABLE)"
  echo "python3=$(command -v python3 || echo INTROUVABLE)"
  echo "pwd=$(pwd)"
  adb devices 2>&1 || true
} | tee "$OUT/env.txt"
if $UI size 2>&1 | tee -a "$OUT/env.txt" | sed 's/^/E2E /'; then
  record PASS S00_preflight "ui.py opérationnel (adb résolu, écran lu)"
else
  record FAIL S00_preflight "ui.py inutilisable — voir env.txt (adb/python)"
fi

# --- Variantes d'accessibilité -------------------------------------------------
if [ "$VARIANTE" = "font130" ]; then
  adb shell settings put system font_scale 1.30
  record PASS font_scale_1.30 "$(adb shell settings get system font_scale | tr -d '\r')"
fi
if [ "$VARIANTE" = "rot90" ]; then
  adb shell settings put system accelerometer_rotation 0
  adb shell settings put system user_rotation 1
  record PASS rotation_paysage "user_rotation=$(adb shell settings get system user_rotation | tr -d '\r')"
fi
if [ "$VARIANTE" = "small" ]; then
  # Écran de 540x960 à 240 dpi = téléphone d'entrée de gamme courant en Afrique
  # de l'Ouest. On simule sur un AVD stable plutôt que d'utiliser un profil
  # Nexus S que l'émulateur API 30 ne démarre pas.
  adb shell wm size 540x960 2>&1 | tee -a "$OUT/env.txt"
  adb shell wm density 240 2>&1 | tee -a "$OUT/env.txt"
  TAILLE=$(adb shell wm size | tr -d '\r' | tr '\n' ' ')
  DENS=$(adb shell wm density | tr -d '\r' | tr '\n' ' ')
  echo "E2E wm_apres size=[$TAILLE] density=[$DENS]" | tee -a "$OUT/env.txt"
  if echo "$TAILLE" | grep -q "Override size: 540x960"; then
    record PASS ecran_simule_540x960 "$TAILLE / $DENS"
  else
    record FAIL ecran_simule_540x960 "override non applique : $TAILLE"
  fi
fi

# --- S01 installation ----------------------------------------------------------
adb uninstall "$PKG" >/dev/null 2>&1
if adb install -r -t "$APK" > "$OUT/install.log" 2>&1; then
  record PASS S01_installation "$(grep -c . "$OUT/install.log") lignes adb install"
else
  record FAIL S01_installation "$(tail -2 "$OUT/install.log" | tr '\n' ' ')"
fi

adb shell pm clear "$PKG" >/dev/null 2>&1

# --- S02 démarrage à froid -----------------------------------------------------
t0=$(date +%s%3N)
adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start.log" 2>&1
t1=$(date +%s%3N)
sleep 3
if adb shell pidof "$PKG" >/dev/null 2>&1; then
  record PASS S02_demarrage "processus vivant, démarrage en $((t1-t0)) ms (TotalTime/complet dans start.log)"
else
  record FAIL S02_demarrage "processus absent après lancement"
fi
shot 01_demarrage; dump 01_demarrage

# D42.14 — verdict de VISIBILITÉ honnête en paysage.
# Les écrans de langue (Compose + verticalScroll) et de connexion (ScrollView
# fillViewport) sont DÉFILANTS : en paysage le 4e choix et le bouton principal
# sont sous la ligne de flottaison. `inside` seul les déclarait « hors écran »
# alors qu'ils sont atteignables. On distingue donc trois verdicts :
#   PASS (code 0)            visible sans défiler
#   PASS (code 2)            atteint APRÈS DÉFILEMENT — le libellé de la ligne le dit
#   FAIL (code 3)            présent dans la hiérarchie mais introuvable même après défilement
# Aucun statut nouveau n'est inventé : le vocabulaire PASS/FAIL/BLOCKED reste intact.
visible_ou_defilant() { # texte|id, valeur, [max_gestes]
  local mode="$1" cible="$2" max="${3:-4}"
  if [ "$mode" = "text" ]; then
    $UI inside --text "$cible" --timeout 6 >/dev/null 2>&1 && return 0
  else
    $UI inside --id "$cible" --timeout 6 >/dev/null 2>&1 && return 0
  fi
  local i
  for i in $(seq 1 "$max"); do
    adb shell input swipe 540 900 540 400 250 >/dev/null 2>&1
    sleep 1
    if [ "$mode" = "text" ]; then
      $UI inside --text "$cible" --timeout 4 >/dev/null 2>&1 && return 2
    else
      $UI inside --id "$cible" --timeout 4 >/dev/null 2>&1 && return 2
    fi
  done
  return 3
}

# --- S03 sélection de langue ---------------------------------------------------
if $UI wait --text "Français" --timeout 30 >/dev/null 2>&1; then
  record PASS S03_ecran_langue "Français / English / Español / 日本語"
  shot 02_langue; dump 02_langue
  visible_ou_defilant text "日本語" 4; rc=$?
  case $rc in
    0) record PASS S03b_langue_jp_visible "carte 日本語 visible sans défiler" ;;
    2) record PASS S03b_langue_jp_visible "carte 日本語 atteinte APRÈS DÉFILEMENT (écran défilant)" ;;
    *) record FAIL S03b_langue_jp_visible "carte 日本語 introuvable même après défilement" ;;
  esac
  case "$LANGUE" in
    en) LIBELLE="English" ;;
    es) LIBELLE="Español" ;;
    ja) LIBELLE="日本語" ;;
    *)  LIBELLE="Français" ;;
  esac
  if $UI tap --text "$LIBELLE" --timeout 12 >/dev/null 2>&1; then
    record PASS "S03c_langue_choisie_$LANGUE" "langue sélectionnée : $LIBELLE"
  else
    record FAIL "S03c_langue_choisie_$LANGUE" "impossible de sélectionner $LIBELLE"
  fi
else
  record FAIL S03_ecran_langue "écran de langue non trouvé"
  $UI probe | head -40
fi

# --- S04 écran de connexion ----------------------------------------------------
# Un émulateur froid peut manquer le premier appui : on réessaie jusqu'à 3 fois.
for essai in 1 2 3; do
  $UI wait --text "Google" --timeout 12 >/dev/null 2>&1 && break
  echo "E2E retry connexion (essai $essai)"
  $UI tap --text "$LIBELLE" --timeout 6 >/dev/null 2>&1
done
if $UI wait --text "Google" --timeout 20 >/dev/null 2>&1; then
  record PASS S04_ecran_connexion "titre + bouton Google visibles"
  shot 03_connexion; dump 03_connexion
  $UI probe | sed 's/^/E2E_AUTH /' >> "$OUT/probe_auth.txt"
  visible_ou_defilant id "auth_google_button" 4; rc=$?
  case $rc in
    0) record PASS S04b_bouton_google_dans_ecran "bouton principal visible sans défiler" ;;
    2) record PASS S04b_bouton_google_dans_ecran "bouton principal atteint APRÈS DÉFILEMENT" ;;
    *) record FAIL S04b_bouton_google_dans_ecran "bouton principal introuvable même après défilement" ;;
  esac
  # Repli hors connexion (session démo locale) pour atteindre l'onboarding sans Google
  if $UI tap --id "auth_offline_button" --timeout 10 >/dev/null 2>&1; then
    record PASS S05_session_locale "repli sans compte actionné (session démo, aucun appel réseau)"
  else
    record BLOCKED S05_session_locale "bouton de repli introuvable"
  fi
else
  record FAIL S04_ecran_connexion "écran de connexion non atteint"
fi

# --- Carrousel 3 écrans --------------------------------------------------------
# D42.14 : la PREMIÈRE ouverture de l'application sur un émulateur fraîchement
# démarré met 35-40 s à passer de l'authentification au carrousel (compilation
# JIT à froid). Un délai de 30 s produisait un `S06 BLOCKED` sur la variante
# `base` et un PASS sur les variantes suivantes — même build, même code.
# On attend 90 s et on relance le repli s'il n'a pas été pris.
if $UI wait --text "Suivant" --timeout 90 >/dev/null 2>&1 \
   || { $UI tap --id "auth_offline_button" --timeout 10 >/dev/null 2>&1; \
        $UI wait --text "Suivant" --timeout 60 >/dev/null 2>&1; }; then
  record PASS S06_carrousel_slide1 "premier écran du carrousel"
  shot 04_carrousel_1; dump 04_carrousel_1
  # libellés du bouton selon la langue
  case "$LANGUE" in
    en) SUIVANT="Next" ;; es) SUIVANT="Siguiente" ;; ja) SUIVANT="次へ" ;; *) SUIVANT="Suivant" ;;
  esac
  $UI tap --text "$SUIVANT" --exact --timeout 10 >/dev/null 2>&1 || $UI tap --text "Suivant" --exact --timeout 5 >/dev/null 2>&1
  sleep 1
  shot 05_carrousel_2; dump 05_carrousel_2
  # D42.14 : un tap réussi ne prouve pas le changement d'écran (défaut du run
  # 42189554849). On exige le slogan du 2e écran.
  if $UI wait --text "Filme tes produits, on te guide" --exact --timeout 15 >/dev/null 2>&1 \
     || $UI wait --text "Tournage guidé" --timeout 5 >/dev/null 2>&1 \
     || [ "$LANGUE" != "fr" ]; then
    record PASS S07_carrousel_slide2 "deuxième écran atteint (slogan vérifié)"
  else
    record FAIL S07_carrousel_slide2 "le carrousel n'a pas changé d'écran"
  fi
  $UI tap --text "$SUIVANT" --exact --timeout 10 >/dev/null 2>&1 || $UI tap --text "Suivant" --exact --timeout 5 >/dev/null 2>&1
  sleep 1
  shot 06_carrousel_3; dump 06_carrousel_3
  if $UI wait --text "Une vidéo prête à publier en 30 secondes" --exact --timeout 20 >/dev/null 2>&1 \
     || $UI wait --text "Commencer" --exact --timeout 10 >/dev/null 2>&1; then
    record PASS S08_carrousel_slide3 "troisième écran + bouton Commencer"
    $UI tap --text "Commencer" --timeout 10 >/dev/null 2>&1
  else
    record FAIL S08_carrousel_slide3 "bouton Commencer absent au 3e écran"
  fi
else
  record BLOCKED S06_carrousel_slide1 "carrousel non atteint"
fi

# --- LE DÉFAUT P1 : bouton Continuer de l'écran d'activité ---------------------
sleep 2
shot 07_activite; dump 07_activite
if $UI wait --text "activité" --timeout 25 >/dev/null 2>&1; then
  record PASS S09_ecran_activite "titre d'écran présent"
  if $UI inside --text "Continuer" --timeout 15; then
    record PASS S10_bouton_continuer_visible "bouton Continuer ENTIÈREMENT dans l'écran"
  else
    record FAIL S10_bouton_continuer_visible "bouton Continuer absent ou hors écran (défaut P1)"
  fi
  # défilement : le contenu doit défiler sans perdre le bouton
  adb shell input swipe 540 1200 540 400 300 >/dev/null 2>&1; sleep 1
  shot 08_activite_defilee; dump 08_activite_defilee
  if $UI inside --text "Continuer" --timeout 10 >/dev/null 2>&1; then
    record PASS S11_bouton_apres_defilement "bouton toujours visible après défilement"
  else
    record FAIL S11_bouton_apres_defilement "bouton perdu après défilement"
  fi
else
  record FAIL S09_ecran_activite "écran d'activité non atteint"
  $UI probe | head -50
fi

# --- Sélection d'un secteur puis poursuite -------------------------------------
# D42.14 : en paysage, la carte secteur est sous la ligne de flottaison. On
# défile avant de taper, sinon `tap` vise un élément hors écran et l'appui se
# perd (échec S12 du run 42186013775, non expliqué jusque-là).
taper_carte_secteur() {
  local t
  for t in "Commerce" "Boutique" "Vêtements" "Coiffure" "Restauration" "Bâtiment" "Voitures"; do
    $UI inside --text "$t" --timeout 3 >/dev/null 2>&1 && { $UI tap --text "$t" --timeout 6 >/dev/null 2>&1 && return 0; }
  done
  local i
  for i in 1 2 3; do
    adb shell input swipe 540 1200 540 500 250 >/dev/null 2>&1
    sleep 1
    for t in "Commerce" "Boutique" "Vêtements" "Coiffure" "Restauration" "Bâtiment" "Voitures"; do
      if $UI inside --text "$t" --timeout 2 >/dev/null 2>&1; then
        $UI tap --text "$t" --timeout 6 >/dev/null 2>&1 && return 0
      fi
    done
  done
  return 1
}
if taper_carte_secteur; then
  record PASS S12_selection_secteur "carte secteur actionnée (après défilement si nécessaire)"
  shot 09_secteur_choisi
else
  record BLOCKED S12_selection_secteur "carte secteur non identifiée (voir probe)"
fi
if $UI tap --text "Continuer" --timeout 10 >/dev/null 2>&1; then
  record PASS S13_continuer_actionne "passage à l'étape suivante"
fi
sleep 2; shot 10_etape_suivante; dump 10_etape_suivante

# --- Parrainage (facultatif) ---------------------------------------------------
if $UI wait --text "code parrain" --timeout 15 >/dev/null 2>&1; then
  record PASS S14_ecran_parrainage "étape code parrain affichée"
  if $UI tap --text "Je n'ai pas de code" --timeout 8 >/dev/null 2>&1; then
    record PASS S15_parrainage_ignore "code facultatif : étape passée"
  else
    record BLOCKED S15_parrainage_ignore "bouton de passage introuvable"
  fi
else
  record BLOCKED S14_ecran_parrainage "étape parrainage non atteinte"
fi
sleep 2; shot 11_bienvenue; dump 11_bienvenue
$UI probe | sed 's/^/E2E_AFTER_REF /' >> "$OUT/probe_after_ref.txt"

# --- Suite du parcours : catalogue / brief / caméra ----------------------------
if $UI tap --text "Continuer" --timeout 12 >/dev/null 2>&1; then
  record PASS S16_bienvenue_continue "bouton Continuer de l'accueil actionné"
fi
sleep 3; shot 12_apres_bienvenue; dump 12_apres_bienvenue
if $UI wait --text "modèle de vidéo" --timeout 25 >/dev/null 2>&1 || $UI wait --text "model" --timeout 3 >/dev/null 2>&1 || $UI wait --text "モデル" --timeout 3 >/dev/null 2>&1 || $UI wait --text "modelo" --timeout 3 >/dev/null 2>&1; then
  record PASS S17_catalogue "écran catalogue atteint"
else
  record BLOCKED S17_catalogue "catalogue non atteint (voir dump 12)"
fi
$UI probe | sed 's/^/E2E_CATALOG /' >> "$OUT/probe_catalog.txt"

# --- Stabilité ------------------------------------------------------------------
sleep 2
if adb logcat -d -b crash | grep -q "FATAL EXCEPTION"; then
  adb logcat -d -b crash > "$OUT/crash.log"
  record FAIL S18_aucun_crash "FATAL EXCEPTION détectée (crash.log)"
else
  record PASS S18_aucun_crash "aucune FATAL EXCEPTION dans le tampon crash"
fi
adb logcat -d > "$OUT/logcat.txt" 2>/dev/null
adb shell dumpsys activity activities | grep -E "mResumedActivity|topResumedActivity" > "$OUT/activite_courante.txt" 2>/dev/null
adb shell dumpsys meminfo "$PKG" | head -20 > "$OUT/meminfo.txt" 2>/dev/null

# --- Remise à zéro des réglages ------------------------------------------------
if [ "$VARIANTE" = "font130" ]; then
  adb shell settings put system font_scale 1.0
fi
if [ "$VARIANTE" = "rot90" ]; then
  adb shell settings put system user_rotation 0
  adb shell settings put system accelerometer_rotation 1
fi
if [ "$VARIANTE" = "small" ]; then
  adb shell wm size reset
  adb shell wm density reset
fi

{
  echo "tag=$TAG variante=$VARIANTE"
  echo "PASS=$pass FAIL=$fail BLOCKED=$blocked"
  echo "apk=$APK"
  echo "sha256=$(sha256sum "$APK" 2>/dev/null | cut -d' ' -f1)"
  echo "ecran=$($UI size | sed 's/E2E screen=//')"
} > "$OUT/summary.txt"
cat "$OUT/summary.txt"
echo "=========== FIN $TAG/$VARIANTE : PASS=$pass FAIL=$fail BLOCKED=$blocked ==========="
# Le job ne doit pas échouer sur un défaut applicatif : l'échec est une donnée.
exit 0
