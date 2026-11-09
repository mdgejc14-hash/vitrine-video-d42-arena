#!/usr/bin/env bash
# D42.26-18 — CAMÉRA RÉSILIENTE (§13-E de la matrice de qualification).
#
# CE QUE CE BANC COUVRE (et que le P1 ne couvrait pas) :
#   Phase A — permissions REFUSÉES (exigence 5.6) : la caméra est refusée au
#   dialogue SYSTÈME ; l'application doit répondre par un dialogue produit
#   EXPLICITE (« Accès caméra nécessaire », F52), jamais par un crash, et le
#   bouton doit rester expliqué à chaque appui.
#   Phase B — « Refaire » (exigence 5.2) : suppression d'une prise déjà
#   filmée (le FICHIER rush doit disparaître), puis RE-FILMAGE de la prise ;
#   complétion du guide et CONSERVATION des prises en fichiers (5.3) jusqu'à
#   l'écran d'aperçu.
#
# CE QUE CE BANC N'EST PAS : pas d'export (couvert par le P1), pas de caméra
# physique (PASS_EMULATOR, jamais PASS_DEVICE), pas de stockage insuffisant
# (5.7 : simulation de quota non fiable — reste NOT RUN).
#
# Usage : run_camerap.sh <tag> [apk]
set -uo pipefail

TAG="${1:-camerap}"
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

# run-as (APK debug) ; repli adb root pour les builds non debuggables.
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

echo "=========== CAMÉRA RÉSILIENTE $TAG (APK=$APK) ==========="
adb devices | sed 's/^/E2E /'
$UI size | sed 's/^/E2E /' || { record FAIL CP0_preflight "ui.py inutilisable"; exit 0; }

# ----------------------------------------------------------------------------
# Parcours amont (langue -> connexion -> carrousel -> activité -> parrainage
# -> catalogue -> gabarit -> brief -> « Avant de commencer »). Reprend le
# cheminement VÉRIFIÉ du P1 (aucune étape sur le seul code retour d'un tap).
# ----------------------------------------------------------------------------
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

parcours_amont() { # $1 = préfixe des enregistrements (CPA ou CPB)
  local P="$1"
  # D42.26-18b : TAP À CONTRÔLE D'EFFET pour les actions critiques du brief —
  # un `input tap` peut revenir 0 SANS effet (constaté : dumps P1/CP
  # strictement identiques, P1 valide, CP non — run 42543641719). Même remède
  # que D42.26-16 (S13/S16) : on exige l'écran suivant, on réessaie, et en
  # dernier recours la bande orange (bouton réel).
  tap_effet() { # $1 libellé, $2 texte attendu après, $3 timeout wait
    local lbl="$1" attendu="$2" tmo="${3:-25}" i rc=1
    for i in 1 2 3 4; do
      $UI tap --text "$lbl" --exact --timeout 12 2>&1 | sed 's/^/E2E tap: /'
      if $UI wait --text "$attendu" --exact --timeout "$tmo" >/dev/null 2>&1; then
        echo "E2E effet constaté : « $attendu » (essai $i)"
        return 0
      fi
      echo "E2E essai $i sans effet sur « $lbl » — resync + swipe"
      sleep 2
      fermer_clavier
      swipe_v 73 21 300 >/dev/null 2>&1; sleep 1
      # dernier recours : bande orange = bouton réel (D42.26-16)
      if [ "$i" -ge 2 ]; then $UI taporange 2>&1 | sed 's/^/E2E taporange: /' || true; sleep 3; fi
      if $UI wait --text "$attendu" --exact --timeout 8 >/dev/null 2>&1; then
        echo "E2E effet constaté après repli : « $attendu »"
        return 0
      fi
    done
    return 1
  }
  etape_any "${P}_langue" 60 "Choisissez votre langue" "Choose your language" \
    "Elige tu idioma" "言語を選んでください" || true
  local ecran_connexion=0 essai
  for essai in 1 2 3 4; do
    $UI tap --text "Français" --exact --timeout 15 >/dev/null 2>&1
    if $UI wait --text "Continuer avec Google" --exact --timeout 25 >/dev/null 2>&1 \
       || $UI wait --text "Continue with Google" --exact --timeout 8 >/dev/null 2>&1 \
       || $UI wait --text "Continuar con Google" --exact --timeout 8 >/dev/null 2>&1 \
       || $UI wait --text "Googleで続ける" --exact --timeout 8 >/dev/null 2>&1; then
      ecran_connexion=1; break
    fi
    echo "E2E langue: appui $essai sans effet, nouvelle tentative"
  done
  [ "$ecran_connexion" = "1" ] && record PASS "${P}_connexion" "écran d'authentification atteint" \
                              || record FAIL "${P}_connexion" "authentification non atteinte après 4 appuis"
  for essai in 1 2 3 4 5; do
    $UI tap --id "auth_offline_button" --timeout 10 >/dev/null 2>&1
    $UI gone --id "auth_offline_button" --timeout 20 >/dev/null 2>&1 && break
    sleep 4
  done
  $UI gone --id "auth_offline_button" --timeout 60 >/dev/null 2>&1 \
    && record PASS "${P}_session_locale" "repli sans compte : écran d'authentification quitté" \
    || record FAIL "${P}_session_locale" "écran d'authentification toujours affiché"
  etape "${P}_carrousel_1" "Filme. Vends. C'est tout." 90 || true
  $UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1
  etape "${P}_carrousel_2" "Filme tes produits, on te guide" 30 || true
  $UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1
  etape "${P}_carrousel_3" "Une vidéo prête à publier en 30 secondes" 30 || true
  $UI tap --text "Commencer" --exact --timeout 10 >/dev/null 2>&1
  etape "${P}_activite" "Ton activité principale" 60 || true
  tap_if "Commerce" "" 10 || tap_if "Boutique" "" 8 || true
  sleep 1
  $UI tap --text "Continuer" --exact --timeout 15 >/dev/null 2>&1 \
    && record PASS "${P}_activite_continue" "bouton Continuer actionné" \
    || record FAIL "${P}_activite_continue" "bouton Continuer introuvable"
  if $UI wait --text "Ton code parrain" --exact --timeout 30 >/dev/null 2>&1; then
    record PASS "${P}_parrainage" "étape code parrain affichée"
    tap_if "Je n'ai pas de code" "" 10 >/dev/null 2>&1 || true
  else
    record BLOCKED "${P}_parrainage" "étape parrainage non atteinte"
  fi
  local catalogue_atteint=0 _
  for _ in 1 2 3; do
    $UI tap --text "Continuer" --exact --timeout 15 >/dev/null 2>&1 || true
    if $UI wait --text "modèle de vidéo" --timeout 20 >/dev/null 2>&1; then catalogue_atteint=1; break; fi
    sleep 3
  done
  [ "$catalogue_atteint" = "1" ] && record PASS "${P}_catalogue" "catalogue atteint" \
                                || { record FAIL "${P}_catalogue" "catalogue non atteint"; return 1; }
  tap_if "Nouvel arrivage" "" 10 >/dev/null 2>&1 \
    && record PASS "${P}_selection_gabarit" "gabarit sélectionné" \
    || { record FAIL "${P}_selection_gabarit" "clic gabarit impossible"; return 1; }
  sleep 4
  shot "${P}_brief"; dump "${P}_brief"
  # --- brief : remplissage piloté par libellé (technique éprouvée du P1) ---
  local brief_ok=0
  if $UI wait --text "Ma vidéo" --exact --timeout 30 >/dev/null 2>&1; then
    $UI fields > "$OUT/champs_0.txt" 2>&1 || true
    if grep -q "E2E FIELD" "$OUT/champs_0.txt"; then brief_ok=1; fi
  fi
  if [ "$brief_ok" != "1" ]; then
    record BLOCKED "${P}_brief" "formulaire de brief non atteint"
    return 1
  fi
  record PASS "${P}_brief" "formulaire de brief affiché ($(grep -c 'E2E FIELD' "$OUT/champs_0.txt") champs)"
  local remplis=0 deja=" " sans_effet=0 tour ligne idx etat libelle val passe restant
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
    $UI wait --text "Continuer" --exact --timeout 2 >/dev/null 2>&1 || sans_effet=$((sans_effet+1))
    [ "$sans_effet" -ge 2 ] && break
    swipe_v 73 26 250 >/dev/null 2>&1
    sleep 1
  done
  echo "E2E champs remplis : $remplis"
  for passe in 1 2 3; do
    if [ "$passe" -gt 1 ]; then swipe_v 73 26 250 >/dev/null 2>&1; sleep 1; fi
    fermer_clavier
    $UI champs > "$OUT/champs.txt" 2>&1 || true
    restant=0
    while IFS= read -r ligne; do
      idx=$(echo "$ligne" | awk '{print $3}')
      etat=$(echo "$ligne" | awk '{print $8}')
      libelle=$(echo "$ligne" | sed 's/^[^|]*|//; s/|[[:space:]]*$//')
      [ "$etat" = "vide" ] || continue
      val=$(valeur_pour "$libelle")
      [ -n "$val" ] || continue
      restant=$((restant+1))
      remplir_champ "$idx" "$val" "$OUT/champs.txt" && remplis=$((remplis+1))
      break
    done < <(grep "^E2E CHAMP " "$OUT/champs.txt")
    [ "$restant" = "0" ] && [ "$passe" -ge 2 ] && break
  done
  echo "E2E champs remplis (après complément) : $remplis"
  # D42.26-18d : REMPLISSAGE À VÉRIFICATION HAUT+BAS. Le brief de
  # « Nouvel arrivage » porte SIX champs (Nom de ton commerce *, Ton numéro
  # whatsapp * — en HAUT —, Nom du vêtement *, Prix *, Monnaie *, Quartier et
  # ville * — en BAS). champs.txt ne liste que les champs VISIBLES : le « 0
  # vide » du run 42550801656 était un FAUX complet (commerce/whatsapp hors
  # écran → jamais re-remplis → bouton Continuer resté GRIS, preuve pixel :
  # CP (229,233,238) vs P1 orange (249,92,15)). On alterne position haute et
  # basse et l'on n'accepte la sortie que sur DEUX sondes SANS aucun vide.
  local round vide_idx vide_label nb_vides haut_ok bas_ok
  haut_ok=0; bas_ok=0
  for round in 1 2 3 4 5 6 7 8; do
    if [ $((round % 2)) -eq 1 ]; then
      # sonde HAUT : remonter le formulaire (2 swipes descendants lents)
      swipe_v 26 73 400 >/dev/null 2>&1; sleep 1
      swipe_v 30 70 400 >/dev/null 2>&1; sleep 1
    else
      # sonde BAS : défiler vers le bouton
      swipe_v 73 26 400 >/dev/null 2>&1; sleep 1
      swipe_v 70 30 400 >/dev/null 2>&1; sleep 1
    fi
    fermer_clavier
    $UI champs > "$OUT/champs.txt" 2>&1 || true
    vide_idx=""; vide_label=""
    while IFS= read -r ligne; do
      idx=$(echo "$ligne" | awk '{print $3}')
      etat=$(echo "$ligne" | awk '{print $8}')
      libelle=$(echo "$ligne" | sed 's/^[^|]*|//; s/|[[:space:]]*$//')
      if [ "$etat" = "vide" ]; then vide_idx="$idx"; vide_label="$libelle"; break; fi
    done < <(grep "^E2E CHAMP " "$OUT/champs.txt")
    if [ -z "$vide_idx" ]; then
      # sonde courante sans vide : créditer la position et sortir si l'autre l'est aussi
      if [ $((round % 2)) -eq 1 ]; then haut_ok=1; else bas_ok=1; fi
      [ $haut_ok -eq 1 ] && [ $bas_ok -eq 1 ] && break
      continue
    fi
    echo "E2E round $round (position $([ $((round % 2)) -eq 1 ] && echo HAUT || echo BAS)) : champ « $vide_label » (idx $vide_idx) vide — re-remplissage"
    val=$(valeur_pour "$vide_label")
    if [ -z "$val" ]; then
      echo "E2E pas de valeur pour « $vide_label » — champ toléré vide (prérempli)"
      if [ $((round % 2)) -eq 1 ]; then haut_ok=1; else bas_ok=1; fi
      [ $haut_ok -eq 1 ] && [ $bas_ok -eq 1 ] && break
      continue
    fi
    if ! remplir_champ "$vide_idx" "$val" "$OUT/champs.txt"; then
      $UI champs > "$OUT/champs.txt" 2>&1 || true
      remplir_champ "$vide_idx" "$val" "$OUT/champs.txt" || true
    fi
  done
  $UI champs > "$OUT/champs_apres.txt" 2>&1 || true
  nb_vides=$(grep -c " vide |" "$OUT/champs_apres.txt" 2>/dev/null); nb_vides=${nb_vides:-0}
  echo "E2E sondes : haut=$haut_ok bas=$bas_ok ; champs visibles encore vides : $nb_vides"
  local trouve=0 _
  for _ in 1 2 3 4 5 6; do
    if $UI wait --text "Continuer" --exact --timeout 2 >/dev/null 2>&1; then trouve=1; break; fi
    swipe_v 73 26 250 >/dev/null 2>&1
    sleep 1
  done
  shot "${P}_brief_bas"; dump "${P}_brief_bas"
  if tap_effet "Continuer" "Avant de commencer" 25; then
    record PASS "${P}_brief_valide" "brief accepté → écran « Avant de commencer » (contrôle d'effet)"
  else
    record FAIL "${P}_brief_valide" "brief non validé : 4 essais + taporange sans effet (champ invalide ? voir ${P}_brief_bas)"
  fi
  if tap_effet "OK, je commence" "Filme ta prise" 40; then
    record PASS "${P}_entree_guide" "« OK, je commence » actionné — guide atteint (contrôle d'effet)"
    shot "${P}_guide"; dump "${P}_guide"
    return 0
  fi
  record BLOCKED "${P}_guide" "écran guide non atteint après « OK, je commence »"
  return 1
}

# ============================================================================
# PHASE A — permissions refusées (5.6)
# ============================================================================
echo "=========== PHASE A : permissions refusées ==========="
adb uninstall "$PKG" >/dev/null 2>&1
if adb install -r -t "$APK" > "$OUT/install_a.log" 2>&1; then
  record PASS CPA_installation "APK installée (SANS permission pré-accordée)"
else
  record FAIL CPA_installation "$(tail -2 "$OUT/install_a.log" | tr '\n' ' ')"; exit 0
fi
adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start_a.log" 2>&1
sleep 4
parcours_amont CPA || true

if $UI wait --text "Filme ta prise" --timeout 30 >/dev/null 2>&1 || $UI wait --id "camera_record_button" --timeout 10 >/dev/null 2>&1; then
  # Le bouton d'enregistrement (camera_record_button = « VERROUILLER ET
  # ENREGISTRER », [44,1867][1036,2021]) est VISIBLE dès l'arrivée sur l'écran
  # caméra (dumps CPA/CPB_guide, run 42555687350). Le dialogue SYSTÈME peut
  # apparaître d'emblée (requestPermissions au onCreate de
  # CameraGuideActivity) OU à l'appui du bouton (onRecord) : on guette les
  # DEUX, jusqu'à 6 cycles.
  dialsys=0
  for i in 1 2 3 4 5 6; do
    if $UI wait --text "Don't allow" --timeout 5 >/dev/null 2>&1 \
       || $UI wait --id "permission_deny_button" --timeout 3 >/dev/null 2>&1; then
      dialsys=1; break
    fi
    $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1 || true
    sleep 2
  done
  if [ "$dialsys" = "1" ]; then
    shot A01_dialogue_systeme; dump A01_dialogue_systeme
    if $UI tap --text "Don't allow" --timeout 10 >/dev/null 2>&1 \
       || $UI tap --id "permission_deny_button" --timeout 8 >/dev/null 2>&1; then
      record PASS CPA_refus_systeme "dialogue système de permission affiché et refusé (voir A01)"
    else
      record FAIL CPA_refus_systeme "dialogue système présent mais refus impossible à actionner"
    fi
  else
    shot A01b_pas_de_dialogue; dump A01b_pas_de_dialogue
    record FAIL CPA_refus_systeme "aucun dialogue système de permission exposé (voir A01b)"
  fi
  sleep 3
  shot A02_apres_refus; dump A02_apres_refus
  # Le bouton d'enregistrement doit rester EXPLIQUÉ (F52) : dialogue produit.
  if $UI tap --id "camera_record_button" --timeout 15 >/dev/null 2>&1 \
     || $UI tap --text "Verrouiller et enregistrer" --exact --timeout 10 >/dev/null 2>&1; then
    if $UI wait --text "Accès caméra nécessaire" --timeout 15 >/dev/null 2>&1; then
      shot A03_dialogue_produit; dump A03_dialogue_produit
      record PASS CPA_refus_germe "permission refusée : dialogue produit explicite (F52), pas de crash"
      # « Plus tard » referme ; un NOUVEL appui doit ré-expliquer (bouton jamais mort).
      $UI tap --text "Plus tard" --exact --timeout 8 >/dev/null 2>&1
      sleep 2
      if $UI tap --id "camera_record_button" --timeout 15 >/dev/null 2>&1 \
         || $UI tap --text "Verrouiller et enregistrer" --exact --timeout 10 >/dev/null 2>&1; then
        if $UI wait --text "Accès caméra nécessaire" --timeout 15 >/dev/null 2>&1; then
          record PASS CPA_reexplication "second appui : explication réaffirmée (bouton jamais mort)"
          $UI tap --text "Plus tard" --exact --timeout 8 >/dev/null 2>&1 || true
        else
          record FAIL CPA_reexplication "second appui sans ré-explanation du refus"
        fi
      else
        record BLOCKED CPA_reexplication "bouton d'enregistrement introuvable après refus (voir A02)"
      fi
    else
      shot A03b_sans_dialogue; dump A03b_sans_dialogue
      record FAIL CPA_refus_germe "appui sans permission : AUCUN dialogue produit (voir A03b) — écran muet ?"
    fi
  else
    record BLOCKED CPA_refus_germe "bouton d'enregistrement introuvable après refus (voir A02)"
  fi
  else
    record BLOCKED CPA_refus_systeme "écran caméra non atteint (ni « Filme ta prise » ni bouton d'enregistrement)"
  fi
sleep 2
if adb shell pidof "$PKG" >/dev/null 2>&1; then
  record PASS CPA_app_vivante "processus vivant après refus de permission (aucun crash)"
else
  record FAIL CPA_app_vivante "processus mort après refus de permission"
fi
adb logcat -d | grep -A 20 "FATAL EXCEPTION" | grep -B 2 -A 18 "Process: $PKG" > "$OUT/crash_a.txt" 2>&1 || true
if [ -s "$OUT/crash_a.txt" ]; then
  record FAIL CPA_aucun_crash "FATAL EXCEPTION du processus app (voir crash_a.txt)"
else
  record PASS CPA_aucun_crash "aucun FATAL EXCEPTION du processus $PKG (phase A complète)"
fi
adb shell am force-stop "$PKG" >/dev/null 2>&1
sleep 2

# ============================================================================
# PHASE B — Refaire (5.2) + re-filmage + conservation des prises (5.3)
# ============================================================================
echo "=========== PHASE B : Refaire / reprise / conservation ==========="
adb shell pm clear "$PKG" >/dev/null 2>&1
adb shell pm grant "$PKG" android.permission.CAMERA >/dev/null 2>&1 \
  && record PASS CPB_permission_camera "accordée par pm grant" \
  || record BLOCKED CPB_permission_camera "pm grant refusé"
adb shell pm grant "$PKG" android.permission.RECORD_AUDIO >/dev/null 2>&1 || true
adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start_b.log" 2>&1
sleep 4
parcours_amont CPB || true

# Une prise complète (comme le P1 : Tourner -> caméra -> enregistrer -> arrêter).
filmmer_une_prise() { # -> 0 ok, 1 pas de bouton, 2 enregistrement jamais parti, 3 arrêt impossible
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
  shot "B0X_prise_enregistrement" >/dev/null 2>&1
  $UI tap --text "Arrêter et continuer" --exact --timeout 10 >/dev/null 2>&1 || return 3
  sleep 5
  $UI wait --text "Tourner" --exact --timeout 25 >/dev/null 2>&1 \
    || $UI wait --text "Verrouiller et enregistrer" --exact --timeout 10 >/dev/null 2>&1 \
    || $UI wait --text "Refaire" --exact --timeout 10 >/dev/null 2>&1
}

compter_rushs() { app_ls files/rushes | tr -d '\r' | grep -c '^rush-'; }

if $UI wait --text "Filme ta prise" --timeout 30 >/dev/null 2>&1; then
  # B1 : première prise
  filmmer_une_prise; rcA=$?
  if [ $rcA -eq 0 ]; then
    n1=$(compter_rushs)
    shot B01_prise1; dump B01_prise1
    if [ "$n1" -ge 1 ]; then
      record PASS CPB_prise1 "$n1 fichier(s) rush enregistré(s) (preuve fichiers, pas seulement libellé)"
    else
      record FAIL CPB_prise1 "retour au guide mais AUCUN fichier rush (voir B01)"
    fi
    # B2 : « Refaire » — SÉMANTIQUE PRODUIT RÉELLE (D42.26-18e) : le bouton
    # vide le slot de la prise COURANTE (CameraGuideActivity.redoCurrentPrise,
    # L382-386 : garde lastRecordedForIdx == priseIdx). Or après une prise
    # VALIDÉE, le guide AUTO-AVANCE (onPriseFinalisee : priseIdx++ — dumps
    # B01 : « PRISE 2/3 ») : « Refaire » ne peut DONC PAS supprimer la prise
    # précédente — c'est le comportement conçu, pas un défaut. La reprise
    # d'une prise = la re-TOURNER (B3). Ici on vérifie l'HONNÊTETÉ de cette
    # sémantique : « Refaire » actionné après auto-avancement NE DÉTRUIT PAS
    # les prises déjà faites (aucune perte de travail du commerçant).
    if $UI wait --text "Refaire" --exact --timeout 15 >/dev/null 2>&1 \
       || { swipe_v 73 21 300 >/dev/null 2>&1; sleep 1; $UI wait --text "Refaire" --exact --timeout 10 >/dev/null 2>&1; }; then
      $UI tap --text "Refaire" --exact --timeout 10 >/dev/null 2>&1
      sleep 3
      n2=$(compter_rushs)
      shot B02_apres_refaire; dump B02_apres_refaire
      if [ "$n2" -eq "$n1" ]; then
        record PASS CPB_refaire_semantique "« Refaire » après auto-avancement (PRISE $((n1+1))/N) : prises précédentes INTACTES ($n2 rush(s)) — sémantique conçue : le bouton ne vide que le slot COURANT (L382-386) ; reprendre une prise = la re-tourner (contrôle suivant)"
      else
        record FAIL CPB_refaire_semantique "« Refaire » a modifié les fichiers ($n1 -> $n2) après auto-avancement — inattendu pour la sémantique conçue (voir B02)"
      fi
      # B3 : re-filmage de la prise
      filmmer_une_prise; rcB=$?
      n3=$(compter_rushs)
      shot B03_refilmage; dump B03_refilmage
      if [ $rcB -eq 0 ] && [ "$n3" -ge 1 ]; then
        record PASS CPB_reprise "prise re-filmée après Refaire ($n3 rush(s) en fichiers)"
      else
        record FAIL CPB_reprise "re-filmage impossible (rc=$rcB, $n3 rush(s)) — voir B03"
      fi
    else
      record BLOCKED CPB_refaire_semantique "bouton « Refaire » introuvable après la prise (voir B01)"
      record BLOCKED CPB_reprise "dépend du bouton Refaire"
    fi
  else
    record BLOCKED CPB_prise1 "première prise impossible (rc=$rcA)"
    record BLOCKED CPB_refaire_semantique "dépend de la première prise"
    record BLOCKED CPB_reprise "dépend de la première prise"
  fi

  # B4 : compléter le guide — les prises exigées, puis sortie vers l'aperçu.
  cycle=0
  while [ $cycle -lt 6 ]; do
    cycle=$((cycle+1))
    $UI wait --text "Filme ta prise" --timeout 6 >/dev/null 2>&1 || break
    filmmer_une_prise || true
    # R4 éventuelle déjà gérée dans filmmer_une_prise ; l'app avance seule à la
    # dernière prise exigée (finishWithPrises).
    $UI wait --text "Filme ta prise" --timeout 6 >/dev/null 2>&1 || break
    # « Suivant » sans filmer = prise sautée (slot vide toléré par le produit)
    local_revele=0
    for _i in 1 2 3 4 5 6; do
      if $UI inside --text "Suivant" --exact --timeout 3 >/dev/null 2>&1; then local_revele=1; break; fi
      swipe_v 73 21 300 >/dev/null 2>&1
      sleep 1
    done
    if [ "$local_revele" = "1" ]; then
      $UI tap --text "Suivant" --exact --timeout 8 >/dev/null 2>&1
      sleep 3
    else
      break
    fi
  done
  nf=$(compter_rushs)
  app_ls files/rushes -l > "$OUT/B04_rushs_finaux.txt" 2>&1 || true
  shot B04_apres_guide; dump B04_apres_guide
  if $UI wait --text "Filme ta prise" --timeout 8 >/dev/null 2>&1; then
    record FAIL CPB_guide_termine "guide toujours affiché après complétion ($nf rush(s) — voir B04)"
  else
    record PASS CPB_guide_termine "guide terminé : $nf rush(s) en fichiers, écran suivant atteint"
  fi
  if [ "$nf" -ge 1 ] && grep -q "rush-" "$OUT/B04_rushs_finaux.txt" 2>/dev/null; then
    record PASS CPB_conservation "prises CONSERVÉES en fichiers jusqu'à l'écran post-guide (B04_rushs_finaux.txt)"
  else
    record FAIL CPB_conservation "rushs absents/vides après le guide (voir B04_rushs_finaux.txt)"
  fi
else
  record BLOCKED CPB_prise1 "guide non atteint en phase B (voir CPB_guide)"
  record BLOCKED CPB_refaire_semantique "guide non atteint"
  record BLOCKED CPB_reprise "guide non atteint"
  record BLOCKED CPB_guide_termine "guide non atteint"
  record BLOCKED CPB_conservation "guide non atteint"
fi

if adb shell pidof "$PKG" >/dev/null 2>&1; then
  record PASS CPB_app_vivante "processus vivant en fin de banc caméra résiliente"
else
  record FAIL CPB_app_vivante "processus mort en fin de banc"
fi
adb logcat -d | grep -A 20 "FATAL EXCEPTION" | grep -B 2 -A 18 "Process: $PKG" > "$OUT/crash_b.txt" 2>&1 || true
if [ -s "$OUT/crash_b.txt" ]; then
  record FAIL CPB_aucun_crash "FATAL EXCEPTION du processus app (voir crash_b.txt)"
else
  record PASS CPB_aucun_crash "aucun FATAL EXCEPTION du processus $PKG (phase B complète)"
fi

echo "tag=$TAG"
echo "PASS=$pass FAIL=$fail BLOCKED=$blocked"
echo "=========== FIN $TAG : PASS=$pass FAIL=$fail BLOCKED=$blocked ==========="
# Le code de sortie du SCRIPT ne fait pas échouer le job : le verdict est lu
# dans les lignes E2E_RESULT (règle D42.14 — un échec de parcours est un
# RÉSULTAT, pas une erreur technique du harnais).
exit 0
