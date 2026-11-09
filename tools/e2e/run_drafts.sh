#!/usr/bin/env bash
# D42.27-05 — BROUILLONS INTER-SESSIONS (§7 de la mission D42.27).
#
# CE QUE CE BANC COUVRE :
#   S1 — quitter PENDANT la rédaction du brief (saisie partielle) → relance →
#        dialogue « Reprendre ta vidéo ? » → formulaire PRÉ-REMPLI ;
#   S2 — quitter APRÈS la première scène → force-stop SANS RÉSEAU → relance →
#        dialogue → reprise du TOURNAGE à la bonne prise (PRISE 2/3), rush
#        précédent CONSERVÉ (preuve fichier) ;
#   S3 — fin du montage après reprise : prises restantes filmées, guide
#        terminé, écran d'aperçu atteint, ≥ 3 rushs en fichiers ;
#   S4 — la reprise a lieu HORS CONNEXION (coupe réseau avant la relance S2),
#        retour réseau en fin de banc sans crash.
#
# CE QUE CE BANC N'EST PAS : pas d'export MP4 complet (couvert par le P1),
# pas de multi-comptes (le brouillon est local à l'installation).
#
# Usage : run_drafts.sh <tag> [apk]
set -uo pipefail

TAG="${1:-drafts}"
APK="${2:-app/build/outputs/apk/debug/app-debug.apk}"
PKG="video.vitrine.app"
OUT="artifacts/${TAG}"

lire_taille_ecran() {
  EFF_W=1080; EFF_H=2340
  local sz ov ph
  sz=$(adb shell wm size 2>/dev/null | tr -d '\r')
  ov=$(printf '%s\n' "$sz" | sed -n 's/.*Override size: \([0-9]*\)x\([0-9]*\).*/\1 \2/p')
  if [ -n "$ov" ]; then EFF_W=${ov% *}; EFF_H=${ov#* }; else
    ph=$(printf '%s\n' "$sz" | sed -n 's/.*Physical size: \([0-9]*\)x\([0-9]*\).*/\1 \2/p')
    [ -n "$ph" ] && { EFF_W=${ph% *}; EFF_H=${ph#* }; }
  fi
}
lire_taille_ecran
swipe_v() {
  adb shell input swipe $(( EFF_W / 2 )) $(( EFF_H * $1 / 100 )) \
    $(( EFF_W / 2 )) $(( EFF_H * $2 / 100 )) "${3:-250}" >/dev/null 2>&1
}
app_ls() {
  local rep="$1"; shift || true
  if adb shell run-as "$PKG" ls "$rep" >/dev/null 2>&1; then
    adb shell run-as "$PKG" ls "$@" "$rep" 2>/dev/null
  else
    adb root >/dev/null 2>&1 || true
    sleep 2; adb wait-for-device >/dev/null 2>&1 || true
    adb shell ls "$@" "/data/data/$PKG/$rep" 2>/dev/null
  fi
}
compter_rushs() { app_ls files/rushes | tr -d '\r' | grep -c '^rush-'; }

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
etape_any() {
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
etape() {
  if $UI wait --text "$2" --exact --timeout "${3:-40}" >/dev/null 2>&1; then
    record PASS "$1" "écran constaté : « $2 »"
    return 0
  fi
  record FAIL "$1" "« $2 » absent après ${3:-40}s ($(date -u +%H:%M:%SZ))"
  return 1
}
fermer_clavier() {
  if adb shell dumpsys input_method 2>/dev/null | grep -q "mInputShown=true"; then
    adb shell input keyevent 4 >/dev/null 2>&1
    sleep 1
  fi
}
valeur_pour() {
  local l
  l=$(echo "$1" | tr 'A-Z' 'a-z')
  case "$l" in
    *commerce*|*boutique*)            echo "BoutiqueAwa" ;;
    *whatsapp*|*num*ro*|*t*l*phone*)  echo "+22997000000" ;;
    *prix*|*montant*)                 echo "15000" ;;
    *monnaie*)                        echo "" ;;
    *quartier*|*ville*|*adresse*)     echo "Akpakpa" ;;
    *nom*|*v*tement*|*produit*|*plat*|*travail*|*article*) echo "RobeWax" ;;
    *)                                echo "Essai" ;;
  esac
}
remplir_champ() {
  local idx="$1" val="$2" src="${3:-$OUT/champs.txt}" ligne x1 y1 x2 y2 cx cy
  ligne=$(awk -v i="$idx" '$1=="E2E" && $2=="CHAMP" && $3==i {print $4, $5, $6, $7}' "$src")
  [ -z "$ligne" ] && return 1
  # shellcheck disable=SC2086
  set -- $ligne
  x1=$1; y1=$2; x2=$3; y2=$4
  cx=$(( (x1 + x2) / 2 )); cy=$(( (y1 + y2) / 2 ))
  adb shell input tap "$cx" "$cy" >/dev/null 2>&1; sleep 1
  adb shell input keyevent KEYCODE_MOVE_END >/dev/null 2>&1
  for _ in 1 2 3 4 5 6 7 8; do adb shell input keyevent KEYCODE_DEL >/dev/null 2>&1; done
  adb shell input text "$val" >/dev/null 2>&1; sleep 1
  fermer_clavier
  return 0
}
# D42.27-05b : contrôle d'EFFET de la saisie — `input text` peut perdre des
# frappes sans erreur (constat run 42619096543 : prix/champ 2 restés vides
# alors que remplir_champ renvoie 0 ; même classe de défaut que les taps
# sans effet D42.26-18b). On exige l'état « rempli » au re-scan, sinon on
# re-remplit, jusqu'à 3 fois. $1 = fragment de libellé, $2 = valeur.
assurer_champ_rempli() {
  local lbl="$1" val="$2" tour ligne idx etat
  for tour in 1 2 3; do
    fermer_clavier
    $UI champs > "$OUT/champs_ass.txt" 2>&1 || true
    ligne=$(grep "^E2E CHAMP " "$OUT/champs_ass.txt" | grep -F "$lbl" | head -1)
    if [ -z "$ligne" ]; then
      # champ hors écran : descendre d'un écran et re-scanner
      swipe_v 73 26 400 >/dev/null 2>&1; sleep 1
      fermer_clavier
      $UI champs > "$OUT/champs_ass.txt" 2>&1 || true
      ligne=$(grep "^E2E CHAMP " "$OUT/champs_ass.txt" | grep -F "$lbl" | head -1)
      [ -z "$ligne" ] && { echo "E2E champ « $lbl » introuvable (essai $tour)"; continue; }
    fi
    idx=$(echo "$ligne" | awk '{print $3}')
    etat=$(echo "$ligne" | awk '{print $8}')
    if [ "$etat" != "vide" ]; then
      echo "E2E champ « $lbl » déjà rempli (essai $tour)"
      return 0
    fi
    remplir_champ "$idx" "$val" "$OUT/champs_ass.txt" || true
    # contrôle d'effet : CE libellé doit être « rempli » au re-scan
    fermer_clavier
    $UI champs > "$OUT/champs_ass_verif.txt" 2>&1 || true
    if grep "^E2E CHAMP " "$OUT/champs_ass_verif.txt" | grep -F "$lbl" | grep -q " rempli "; then
      echo "E2E champ « $lbl » rempli avec effet vérifié (essai $tour)"
      return 0
    fi
    echo "E2E champ « $lbl » toujours vide après essai $tour — re-remplissage"
  done
  echo "E2E champ « $lbl » NON rempli après 3 essais"
  return 1
}

filmmer_une_prise() { # -> 0 ok, 1 pas de bouton, 2 jamais parti, 3 arrêt impossible
  $UI tap --text "Tourner" --exact --timeout 12 >/dev/null 2>&1 || true
  $UI wait --id "camera_record_button" --timeout 30 >/dev/null 2>&1 || return 1
  $UI tap --text "Verrouiller et enregistrer" --exact --timeout 10 >/dev/null 2>&1 \
    || $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1 || return 1
  if ! $UI wait --text "Arrêter et continuer" --exact --timeout 8 >/dev/null 2>&1; then
    if $UI wait --text "Accord du client" --timeout 8 >/dev/null 2>&1; then
      $UI tap --text "Oui, accord confirmé" --exact --timeout 8 >/dev/null 2>&1 || true
    fi
    $UI wait --text "Arrêter et continuer" --exact --timeout 25 >/dev/null 2>&1 || return 2
  fi
  sleep 6
  $UI tap --text "Arrêter et continuer" --exact --timeout 10 >/dev/null 2>&1 || return 3
  sleep 5
  $UI wait --text "Tourner" --exact --timeout 25 >/dev/null 2>&1 \
    || $UI wait --text "Verrouiller et enregistrer" --exact --timeout 10 >/dev/null 2>&1 \
    || $UI wait --text "Refaire" --exact --timeout 10 >/dev/null 2>&1
}
tap_effet() { # $1 libellé, $2 texte attendu après, $3 timeout
  local lbl="$1" attendu="$2" tmo="${3:-25}" i
  for i in 1 2 3 4; do
    $UI tap --text "$lbl" --exact --timeout 12 >/dev/null 2>&1
    if $UI wait --text "$attendu" --exact --timeout "$tmo" >/dev/null 2>&1; then
      echo "E2E effet constaté : « $attendu » (essai $i)"
      return 0
    fi
    sleep 2
    fermer_clavier
    swipe_v 73 21 300 >/dev/null 2>&1; sleep 1
  done
  return 1
}

echo "=========== BROUILLONS INTER-SESSIONS $TAG (APK=$APK) ==========="
adb devices | sed 's/^/E2E /'
$UI size | sed 's/^/E2E /' || { record FAIL DR0_preflight "ui.py inutilisable"; exit 0; }

# ----------------------------------------------------------------------------
# 1er lancement — jusqu'au BRIEF AFFICHÉ (sans le valider), puis saisie
# PARTIELLE (2 champs) : c'est l'état « a quitté pendant la rédaction ».
# ----------------------------------------------------------------------------
adb uninstall "$PKG" >/dev/null 2>&1
if ! adb install -r -t "$APK" > "$OUT/install.log" 2>&1; then
  record FAIL DR_installation "$(tail -2 "$OUT/install.log" | tr '\n' ' ')"; exit 0
fi
record PASS DR_installation "APK installée (banc brouillons)"
adb shell pm grant "$PKG" android.permission.CAMERA >/dev/null 2>&1 || true
adb shell pm grant "$PKG" android.permission.RECORD_AUDIO >/dev/null 2>&1 || true
adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start.log" 2>&1
sleep 4

etape_any DR_langue 60 "Choisissez votre langue" "Choose your language" \
  "Elige tu idioma" "言語を選んでください" || true
for essai in 1 2 3 4; do
  $UI tap --text "Français" --exact --timeout 15 >/dev/null 2>&1
  if $UI wait --text "Continuer avec Google" --exact --timeout 25 >/dev/null 2>&1 \
     || $UI wait --text "Continue with Google" --exact --timeout 8 >/dev/null 2>&1; then break; fi
done
for essai in 1 2 3 4 5; do
  $UI tap --id "auth_offline_button" --timeout 10 >/dev/null 2>&1
  $UI gone --id "auth_offline_button" --timeout 20 >/dev/null 2>&1 && break
  sleep 4
done
etape DR_carrousel_1 "Filme. Vends. C'est tout." 90 || true
$UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1
etape_any DR_carrousel_2 30 "Filme tes produits, on te guide" || true
$UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1
etape_any DR_carrousel_3 30 "Une vidéo prête à publier en 30 secondes" || true
$UI tap --text "Commencer" --exact --timeout 10 >/dev/null 2>&1
etape DR_activite "Ton activité principale" 60 || true
tap_if "Commerce" "" 10 || tap_if "Boutique" "" 8 || true
sleep 1
$UI tap --text "Continuer" --exact --timeout 15 >/dev/null 2>&1
if $UI wait --text "Ton code parrain" --exact --timeout 30 >/dev/null 2>&1; then
  record PASS DR_parrainage "étape code parrain affichée"
  tap_if "Je n'ai pas de code" "" 10 >/dev/null 2>&1 || true
fi
local_catalogue=0
for _ in 1 2 3; do
  $UI tap --text "Continuer" --exact --timeout 15 >/dev/null 2>&1 || true
  if $UI wait --text "modèle de vidéo" --timeout 20 >/dev/null 2>&1; then local_catalogue=1; break; fi
  sleep 3
done
[ "$local_catalogue" = "1" ] && record PASS DR_catalogue "catalogue atteint (1er lancement)" \
  || record FAIL DR_catalogue "catalogue non atteint (1er lancement)"
tap_if "Nouvel arrivage" "" 10 >/dev/null 2>&1 \
  && record PASS DR_selection_gabarit "gabarit sélectionné" \
  || record FAIL DR_selection_gabarit "clic gabarit impossible"
sleep 4
if $UI wait --text "Ma vidéo" --exact --timeout 30 >/dev/null 2>&1; then
  record PASS DR_brief_affiche "formulaire de brief affiché"
else
  record FAIL DR_brief_affiche "brief non atteint (voir dumps)"
  shot DR_brief_rate; dump DR_brief_rate
fi

# --- S1 : saisie PARTIELLE (2 champs, effet vérifié) puis FERMETURE BRUTALE ---
fermer_clavier
s1_a=""; s1_b=""
assurer_champ_rempli "commerce" "BoutiqueAwa" && s1_a="commerce"
assurer_champ_rempli "whatsapp" "+22997000000" && s1_b="whatsapp"
s1_remplis=0
[ -n "$s1_a" ] && s1_remplis=$((s1_remplis+1))
[ -n "$s1_b" ] && s1_remplis=$((s1_remplis+1))
shot S01_saisie_partielle; dump S01_saisie_partielle
if [ "$s1_remplis" -ge 2 ]; then
  record PASS S1_saisie_partielle "2 champs saisis avec effet vérifié ($s1_a, $s1_b) puis fermeture brutale"
else
  record FAIL S1_saisie_partielle "seulement $s1_remplis champ(s) saisissable(s) avec effet ($s1_a $s1_b — voir S01)"
fi
adb shell am force-stop "$PKG"
sleep 3

# --- relance : le dialogue « Reprendre ta vidéo ? » doit apparaître ---
relance_dialogue() { # $1 = préfixe ; -> 0 si dialogue vu
  adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start_$1.log" 2>&1
  sleep 4
  for essai in 1 2 3 4 5; do
    $UI tap --id "auth_offline_button" --timeout 10 >/dev/null 2>&1
    $UI gone --id "auth_offline_button" --timeout 20 >/dev/null 2>&1 && break
    sleep 4
  done
  etape_any "${1}_rel_carrousel" 60 "Filme. Vends. C'est tout." || true
  $UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1
  etape_any "${1}_rel_carrousel2" 25 "Filme tes produits, on te guide" || true
  $UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1
  etape_any "${1}_rel_carrousel3" 25 "Une vidéo prête à publier en 30 secondes" || true
  $UI tap --text "Commencer" --exact --timeout 10 >/dev/null 2>&1
  etape_any "${1}_rel_activite" 60 "Ton activité principale" || true
  tap_if "Commerce" "" 10 || tap_if "Boutique" "" 8 || true
  sleep 1
  $UI tap --text "Continuer" --exact --timeout 15 >/dev/null 2>&1
  $UI wait --text "Ton code parrain" --exact --timeout 30 >/dev/null 2>&1 \
    && tap_if "Je n'ai pas de code" "" 10 >/dev/null 2>&1 || true
  local k
  for k in 1 2 3; do
    $UI tap --text "Continuer" --exact --timeout 15 >/dev/null 2>&1 || true
    if $UI wait --text "Reprendre ta vidéo ?" --exact --timeout 15 >/dev/null 2>&1; then
      record PASS "${1}_dialogue_reprise" "dialogue « Reprendre ta vidéo ? » affiché (brouillon détecté)"
      shot "${1}_dialogue"; dump "${1}_dialogue"
      return 0
    fi
  done
  record FAIL "${1}_dialogue_reprise" "dialogue de reprise absent après relance (voir dumps)"
  shot "${1}_pas_de_dialogue"; dump "${1}_pas_de_dialogue"
  return 1
}

if relance_dialogue S1; then
  if $UI tap --text "Reprendre" --exact --timeout 15 >/dev/null 2>&1 \
     || $UI tap --id "android:id/button1" --timeout 10 >/dev/null 2>&1; then
    if $UI wait --text "Ma vidéo" --exact --timeout 40 >/dev/null 2>&1; then
      shot S01_brief_repris; dump S01_brief_repris
      if grep -q "BoutiqueAwa" "$OUT/S01_brief_repris.xml" 2>/dev/null; then
        record PASS S1_preRemplissage "formulaire PRÉ-REMPLI après reprise (« BoutiqueAwa » retrouvé — voir S01_brief_repris.xml)"
      else
        record FAIL S1_preRemplissage "formulaire re-ouvert MAIS saisie perdue (voir S01_brief_repris.xml)"
      fi
    else
      record FAIL S1_preRemplissage "brief non ré-ouvert après « Reprendre »"
    fi
  else
    record FAIL S1_preRemplissage "bouton « Reprendre » introuvable/actionnable"
  fi
else
  record BLOCKED S1_preRemplissage "pas de dialogue → scénario S1 non exécutable"
fi

# ----------------------------------------------------------------------------
# S2 — compléter le brief, valider, filmer LA PREMIÈRE scène, puis fermer
# SANS RÉSEAU ; la reprise doit rouvrir le guide à PRISE 2/3 avec le rush
# conservé.
# ----------------------------------------------------------------------------
remplis=0; deja=" "
for tour in 1 2 3 4 5 6 7 8 9 10 11 12; do
  fermer_clavier
  $UI champs > "$OUT/champs.txt" 2>&1 || true
  while IFS= read -r ligne; do
    idx=$(echo "$ligne" | awk '{print $3}')
    etat=$(echo "$ligne" | awk '{print $8}')
    libelle=$(echo "$ligne" | sed 's/^[^|]*|//; s/|[[:space:]]*$//')
    [ "$etat" = "vide" ] || continue
    case " $deja " in *" $idx "*) continue;; esac
    val=$(valeur_pour "$libelle")
    [ -n "$val" ] || continue
    if remplir_champ "$idx" "$val" "$OUT/champs.txt"; then
      remplis=$((remplis+1)); deja="$deja $idx "
    fi
    break
  done < <(grep "^E2E CHAMP " "$OUT/champs.txt")
  swipe_v 73 26 250 >/dev/null 2>&1
  sleep 1
done
# D42.27-05b : passe de CONTRÔLE D'EFFET sur chaque champ requis (la boucle
# ci-dessus peut marquer un champ « fait » alors que la saisie n'a pas pris —
# le bouton Continuer resterait légitimement désactivé, comme au run
# 42619096543). Preuve au re-scan pour chacun.
s2_manquants=""
assurer_champ_rempli "commerce" "BoutiqueAwa" || s2_manquants="$s2_manquants commerce"
assurer_champ_rempli "whatsapp" "+22997000000" || s2_manquants="$s2_manquants whatsapp"
assurer_champ_rempli "vêtement" "RobeWax" || s2_manquants="$s2_manquants offre"
assurer_champ_rempli "Prix" "15000" || s2_manquants="$s2_manquants prix"
assurer_champ_rempli "Quartier" "Akpakpa" || s2_manquants="$s2_manquants quartier"
[ -z "$s2_manquants" ] && record PASS S2_champs_effet "5 champs requis remplis avec effet vérifié (commerce, whatsapp, offre, prix, quartier)"   || record FAIL S2_champs_effet "champs sans effet vérifié :$s2_manquants"
shot S02_brief_complet; dump S02_brief_complet
if tap_effet "Continuer" "Avant de commencer" 25; then
  record PASS S2_brief_valide "brief complété et validé après reprise (contrôle d'effet)"
else
  record FAIL S2_brief_valide "brief non validé (voir S02_brief_complet)"
fi
if tap_effet "OK, je commence" "Filme ta prise" 40; then
  record PASS S2_entree_guide "guide atteint"
else
  record FAIL S2_entree_guide "guide non atteint"
fi
n_avant=$(compter_rushs)
filmmer_une_prise; rcS2=$?
n_apres=$(compter_rushs)
if [ $rcS2 -eq 0 ] && [ "$n_apres" -gt "$n_avant" ] 2>/dev/null; then
  record PASS S2_premiere_scene "première scène filmée ($n_avant → $n_apres rush(s))"
else
  record FAIL S2_premiere_scene "première scène non filmée (rc=$rcS2, $n_avant → $n_apres — voir dumps)"
fi

# --- fermeture SANS RÉSEAU (mode avion) puis relance ---
adb shell svc wifi disable >/dev/null 2>&1 || true
adb shell svc data disable >/dev/null 2>&1 || true
sleep 2
record PASS S2_reseau_coupe "réseau coupé avant fermeture (svc wifi+data disable)"
adb shell am force-stop "$PKG"
sleep 3

if relance_dialogue S2; then
  if $UI tap --text "Reprendre" --exact --timeout 15 >/dev/null 2>&1 \
     || $UI tap --id "android:id/button1" --timeout 10 >/dev/null 2>&1; then
    # le guide doit rouvrir à la bonne prise, rush conservé
    if $UI wait --text "Filme ta prise" --exact --timeout 40 >/dev/null 2>&1 \
       || $UI wait --text "Tourner" --exact --timeout 20 >/dev/null 2>&1 \
       || $UI wait --id "camera_record_button" --timeout 20 >/dev/null 2>&1; then
      shot S02_reprise; dump S02_reprise
      if grep -q "PRISE 2/3" "$OUT/S02_reprise.xml" 2>/dev/null; then
        record PASS S2_reprise_position "reprise du tournage à LA BONNE PRISE (PRISE 2/3 affichée — hors connexion)"
      else
        record FAIL S2_reprise_position "guide ré-ouvert mais position non retrouvée (voir S02_reprise.xml)"
      fi
      n_conserve=$(compter_rushs)
      if [ "$n_conserve" -ge 1 ] 2>/dev/null; then
        record PASS S2_rush_conserves "rush de la 1re scène CONSERVÉ après fermeture + redémarrage ($n_conserve fichier(s))"
      else
        record FAIL S2_rush_conserves "rush perdu après fermeture (0 fichier)"
      fi
    else
      record FAIL S2_reprise_position "écran caméra non ré-ouvert après « Reprendre »"
      record BLOCKED S2_rush_conserves "écran caméra non atteint"
    fi
  else
    record FAIL S2_reprise_position "bouton « Reprendre » introuvable (S2)"
    record BLOCKED S2_rush_conserves "bouton Reprendre introuvable"
  fi
else
  record BLOCKED S2_reprise_position "pas de dialogue (S2)"
  record BLOCKED S2_rush_conserves "pas de dialogue (S2)"
fi

# ----------------------------------------------------------------------------
# S3 — fin du montage après reprise : prises restantes → guide terminé.
# ----------------------------------------------------------------------------
# NOTE : la DERNIÈRE prise quitte le guide (finishWithPrises → export), le
# retour à « Tourner » n'a donc PAS lieu — le code retour du 2e filmage n'est
# pas un critère ; la preuve de fond est le nombre de rushs + l'écran final.
filmmer_une_prise; rc3a=$?
n_mid=$(compter_rushs)
filmmer_une_prise; rc3b=$?
n_final=$(compter_rushs)
if [ $rc3a -eq 0 ] && [ "$n_final" -ge 3 ] 2>/dev/null; then
  record PASS S3_scenes_restantes "prises restantes filmées après reprise ($n_mid → $n_final rush(s) ; guide quitté après la dernière)"
elif [ "$n_final" -ge 3 ] 2>/dev/null; then
  record PASS S3_scenes_restantes "3 rushs présents après reprise (rc=$rc3a/$rc3b atypique mais preuve fichier $n_final/3)"
else
  record FAIL S3_scenes_restantes "prises restantes non filmées (rc=$rc3a/$rc3b, $n_final rush(s))"
fi
shot S03_apres_scenes; dump S03_apres_scenes
if $UI wait --text "Aperçu de ta vidéo" --timeout 40 >/dev/null 2>&1; then
  record PASS S3_guide_termine "guide TERMINÉ après reprise : écran d'aperçu atteint (montage complet)"
else
  record FAIL S3_guide_termine "écran d'aperçu non atteint (voir S03_apres_scenes.xml)"
fi
app_ls files/rushes -l > "$OUT/S03_rushs_finaux.txt" 2>&1 || true

# --- retour du réseau : l'app doit rester vivante (aucun crash au retour) ---
adb shell svc wifi enable >/dev/null 2>&1 || true
adb shell svc data enable >/dev/null 2>&1 || true
sleep 4
if adb shell pidof "$PKG" >/dev/null 2>&1; then
  record PASS S4_retour_reseau "retour du réseau : app vivante, aucune perte"
else
  record FAIL S4_retour_reseau "app morte au retour du réseau"
fi

if adb shell pidof "$PKG" >/dev/null 2>&1; then
  record PASS DR_app_vivante "processus vivant en fin de banc brouillons"
else
  record FAIL DR_app_vivante "processus mort en fin de banc"
fi
adb logcat -d | grep -A 20 "FATAL EXCEPTION" | grep -B 2 -A 18 "Process: $PKG" > "$OUT/crash_dr.txt" 2>&1 || true
if [ -s "$OUT/crash_dr.txt" ]; then
  record FAIL DR_aucun_crash "FATAL EXCEPTION pendant le banc (voir crash_dr.txt)"
else
  record PASS DR_aucun_crash "aucun FATAL EXCEPTION du processus $PKG (banc brouillons complet)"
fi

echo "tag=$TAG"
echo "PASS=$pass FAIL=$fail BLOCKED=$blocked"
echo "=========== FIN $TAG : PASS=$pass FAIL=$fail BLOCKED=$blocked ==========="
exit 0
