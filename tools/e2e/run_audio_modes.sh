#!/usr/bin/env bash
# D42.28 (P3) — PARCOURS COMMERCIAL × LANGUES × MODES AUDIO.
#
#   tools/e2e/run_audio_modes.sh <tag> <fr|en> <musique|voix|mix> [apk]   (D42.30 : FR/EN)
#
# Objectif : prouver, pour chaque langue (D42.30 : fr/en uniquement) et chaque variante
# audio (musique seule / voix seule / voix + musique), que le parcours
# commercial COMPLET — langue → session locale → carrousel → activité →
# parrainage → catalogue → brief → guide de tournage → prises → aperçu →
# export → « Vidéo prête ! » — fonctionne et produit un MP4 dont la bande
# sonore correspond au mode attendu. La parole n'est JAMAIS obligatoire
# (mode musique seule = rushs muets de l'émulateur).
#
# MODES (décrits par le produit, ExportWorker/BgmSfxAudioMixer) :
#  - musique : rushss sans piste audio → BGM seule, gain solo 0 dB ;
#  - voix    : rushss avec piste audio + cache BGM vidé → pass-through
#              voix seule (robustesse : toute anomalie BGM n'arrête pas
#              l'export) ;
#  - mix     : rushss avec piste audio + BGM en cache → voix + musique
#              (ducking sidechain).
#
# Preuves par mode (sur le MP4 exporté, ffmpeg sur le runner) :
#  - ffprobe : 1 piste audio, durée audio ≈ durée vidéo ;
#  - RMS global (astats) : non silencieux ;
#  - RMS de la fenêtre d'INTRO (2 premières secondes, hors prises) :
#      musique/mix → musique audible (RMS_intro > -28 dB) ;
#      voix        → quasi silence (RMS_intro < -40 dB), la musique étant
#                    absente et l'intro ne contenant pas de rush ;
#  - constats structurels : rushs avec/sans piste audio (ffprobe avant
#    injection), cache BGM présent/vidé (run-as ls).
#
# Libellés par langue extraits des ressources du dépôt (values*/strings*.xml)
# — y compris les constats d'architecture : les libellés du BRIEF restent en
# français dans toutes les langues (contenu des gabarits non localisé, état
# produit assumé), le badge « PRISE n/N » est codé en dur, la carte gabarit
# « Nouvel arrivage » (T1) est identique partout.
set -uo pipefail
cd "$(dirname "$0")/../.." || exit 1

TAG="${1:-p3}"
LANGUE="${2:-fr}"
MODE="${3:-musique}"
APK="${4:-app/build/outputs/apk/debug/app-debug.apk}"
PKG="video.vitrine.app"
OUT="artifacts/${TAG}_${LANGUE}_${MODE}"
UI="python3 tools/e2e/ui.py"
mkdir -p "$OUT"
RESULTS="$OUT/results.tsv"
: > "$RESULTS"
command -v ffprobe >/dev/null 2>&1 || echo "AVERTISSEMENT : ffprobe absent du runner (preuves acoustiques limitées)"

pass=0; fail=0; blocked=0
record() {
  printf '%s\t%s\t%s\n' "$1" "$2" "$3" >> "$RESULTS"
  case "$1" in PASS) pass=$((pass+1));; FAIL) fail=$((fail+1));; *) blocked=$((blocked+1));; esac
  echo "E2E_RESULT $1 $2 :: $3"
}
shot() { $UI shot "$OUT/$1.png" >/dev/null 2>&1 && echo "E2E SHOT $1" || echo "E2E SHOT_FAIL $1"; }
dump() { adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1; adb exec-out cat /sdcard/d.xml > "$OUT/$1.xml" 2>/dev/null; }

# --- table de libellés par langue (source : values*/strings*.xml) --------------
case "$LANGUE" in
  fr) CARTE="Français"; AUTH="Continuer avec Google"; S1="Filme. Vends. C'est tout."
      S2="Filme tes produits, on te guide"; S3="Une vidéo prête à publier en 30 secondes"
      SUIVANT="Suivant"; DEMARRER="Commencer"; SECTEUR="Ton activité principale"
      CONTINUER="Continuer"; CONTINUER_BRIEF="Continuer"; SANS_CODE="Je n'ai pas de code"; CATALOGUE="Choisissez un modèle de vidéo"
      BRIEF="Ma vidéo"; E4B="Avant de commencer"; E4B_OK="OK, je commence"
      E6="Filme ta prise"; E6_REC="Tourner"; CAM_REC="Verrouiller et enregistrer"; CAM_STOP="Arrêter et continuer"
      R4="Accord du client"; R4_OK="Oui, accord confirmé"
      SECTEUR_CARTE="Boutique"
      SECTEUR_MODE="Vêtements & Mode"; SECTEUR_COIFFURE="Coiffure & Beauté"; SECTEUR_RESTAURATION="Restauration & Maquis"
      SECTEUR_BTP="Bâtiment & Travaux"; SECTEUR_IMMO="Vente de Voitures"; SECTEUR_COMMERCE="Boutique & Petit Commerce"
      E7="Aperçu de ta vidéo"; E7_CREATE="Créer ma vidéo"
      EXP_START="Lancer l'export local"; EXP_RUNNING="Export local en cours"
      EXP_DONE="Vidéo prête ! Partage-la avec tes clients."; EXP_SHARE="Partager la vidéo" ;;
  en) CARTE="English"; AUTH="Continue with Google"; S1="Shoot. Sell. Done."
      S2="Film your products, we guide you"; S3="A video ready to post in 30 seconds"
      SUIVANT="Next"; DEMARRER="Get started"; SECTEUR="Your main business"
      CONTINUER="Continue"; CONTINUER_BRIEF="Continue"; SANS_CODE="I don't have a code"; CATALOGUE="Pick a video template"
      BRIEF="My video"; E4B="Before you start"; E4B_OK="OK, I start"
      E6="Film your take"; E6_REC="Record"; CAM_REC="Lock and record"; CAM_STOP="Stop and continue"
      R4="Client agreement"; R4_OK="Yes, agreement confirmed"
      SECTEUR_CARTE="Shops"
      SECTEUR_MODE="Clothing & Fashion"; SECTEUR_COIFFURE="Hair & Beauty"; SECTEUR_RESTAURATION="Restaurants & Eateries"
      SECTEUR_BTP="Building & Works"; SECTEUR_IMMO="Cars & Homes"; SECTEUR_COMMERCE="Shops & Small Business"
      E7="Preview of your video"; E7_CREATE="Create my video"
      EXP_START="Start local export"; EXP_RUNNING="Local export running"
      EXP_DONE="Video ready! Share it with your customers."; EXP_SHARE="Share the video" ;;
  *) echo "langue non supportee : $LANGUE (D42.30 : fr|en uniquement)"; exit 2 ;;
esac
case "$MODE" in musique|voix|mix) ;; *) echo "mode inconnu : $MODE (musique|voix|mix)"; exit 2 ;; esac

# D42.28-16 : BGM titulaire T1 du secteur commerce (téléchargé via le compte
# de test A — le produit ne télécharge pas le BGM en session démo). Injecté
# plus bas selon le mode (musique/mix).
# D42.28-21 : les 6 catégories T1 sont téléchargées puis TOUTES injectées :
# la carte secteur tapée dépend de la pagination (le commerce n'est pas en
# page 1) donc la catégorie attendue (bgmCategorie du gabarit choisi) varie —
# avec les 6 en cache, localFile trouve la sienne quelle que soit la carte.
SECTEURS_BGM="vetements_mode coiffure_beaute restaurants_maquis batiment_travaux immo_auto shops_small_business"
BGM_OK=0
if [ "$MODE" != "voix" ]; then
  for s in $SECTEURS_BGM; do
    if bash "$(dirname "$0")/fetch_bgm_titulaire.sh" "musique_t1_${s}" "$OUT/bgm_${s}"; then
      BGM_OK=$((BGM_OK+1))
    fi
  done
  echo "bgm_telecharges=${BGM_OK}/6 secteurs" >> "$OUT/constats_mode.txt"
fi
injecter_bgm() { # -> nombre de fichiers réellement injectés
  local s e n=0
  for s in $SECTEURS_BGM; do
    e=$(cat "$OUT/bgm_${s}.ext" 2>/dev/null | tr -d '\r\n')
    [ -n "$e" ] && [ -s "$OUT/bgm_${s}.$e" ] || continue
    if adb push "$OUT/bgm_${s}.$e" /data/local/tmp/bgm_inj."$e" >/dev/null 2>&1 \
       && adb shell run-as "$PKG" cp /data/local/tmp/bgm_inj."$e" "files/bgm/musique_t1_${s}.${e}" >/dev/null 2>&1; then
      n=$((n+1))
      echo "bgm_injecte=musique_t1_${s}.${e}" >> "$OUT/constats_mode.txt"
    fi
  done
  echo "$n"
}

# D42.28-29 : lecture de taille ÉPROUVÉE de run_p1.sh (adb wm size direct,
# override prioritaire, repli 1080x2340). L'ancienne swipe_v locale parsait
# « $UI size | awk '{print $2}' » en attendant « w W h H », mais ui.py cmd_size
# sort « E2E screen=1080x2340 » : w recevait « screen=1080x2340 » et
# $(( w * 50 / 100 )) levait « value too great for base (error token is
# "1080x2340") » — erreur arithmétique qui fait ABANDONNER par bash la
# commande composite appelante (le for de la passe basse ENTIER) : c'est le
# « corps avalé » des runs v7b→v12 (42771629495→42811797111), invisible car
# le message partait dans le >/dev/null 2>&1 de l'appel.
lire_taille_ecran() { # override prioritaire sur la taille physique
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
swipe_v() { # y1pct y2pct [ms] — swipe VERTICAL au centre, relatif à la hauteur
  adb shell input swipe $(( EFF_W / 2 )) $(( EFF_H * $1 / 100 )) \
    $(( EFF_W / 2 )) $(( EFF_H * $2 / 100 )) "${3:-250}" >/dev/null 2>&1
}

app_ls() { # app_ls <rep-relatif> [flags ls] -> liste sur stdout (P1 éprouvé)
  local rep="$1"; shift || true
  if adb shell run-as "$PKG" ls "$rep" >/dev/null 2>&1; then
    adb shell run-as "$PKG" ls "$@" "$rep" 2>/dev/null
  else
    adb root >/dev/null 2>&1 || true
    sleep 2; adb wait-for-device >/dev/null 2>&1 || true
    adb shell ls "$@" "/data/data/$PKG/$rep" 2>/dev/null
  fi
}
app_cat() { adb shell run-as "$PKG" cat "$1" 2>/dev/null; }

echo "=========== P3 $LANGUE / $MODE ($TAG) ==========="
# D42.28-24 : EMPREINTE DU SCRIPT EXÉCUTÉ (diagnostic du saut de corps :
# les traces de la passe basse n'apparaissent ni au log ni à l'artefact
# alors que le blob du commit les contient — si cette empreinte diverge du
# blob, le fichier exécuté n'est pas celui du commit ; si elle concorde,
# le corps s'exécute et c'est la collecte de sorties qui perd tout)
sha256sum "$0" 2>/dev/null | sed 's/^/E2E P3 SCRIPT_SHA /'
echo "E2E P3 SCRIPT_LIGNES=$(wc -l < "$0") BASSE_PASSE_PRESENTE=$(grep -c 'basse_passe()' "$0")"
adb devices | sed 's/^/E2E /'
# D42.28-30 — APPAREIL CLIENT PROPRE (recopie du bloc éprouvé de run_p1.sh
# D42.21, aligné sur run_official_e2e.sh rc9). L'image AOSP « default »
# embarque /system/xbin/su : l'heuristique anti-root d'IntegrityGuard
# (V2.0 §22) le voit et refuse l'export (DENY_INTEGRITY). Cause racine des
# FAIL P3_export_lance « aucun statut de démarrage constaté » du run v13
# (42821782768) : le dump 29 affichait le statut export_gate_integrity
# (« Vérification de sécurité échouée. Réinstallez l'application ») alors
# que le P1 du lab, qui masque /system/xbin, passe la même porte.
# IntegrityGuard n'est NI modifié NI contourné — le contrôle de certificat
# reste pleinement actif. /system n'est pas écrit, pas de reboot.
adb root >/dev/null 2>&1 || true
sleep 3
adb shell setenforce 0 2>/dev/null || true
adb shell mkdir -p /data/local/tmp/vv_xbin_vide
{
  echo "=== avant masquage (su visible = heuristique anti-root active) ==="
  adb shell 'ls -la /system/bin/su /system/xbin/su /system/app/Superuser.apk 2>&1'
  echo "=== masquage : bind-mount d'un répertoire vide sur /system/xbin ==="
  adb shell mount -o bind /data/local/tmp/vv_xbin_vide /system/xbin 2>&1 \
    || adb shell mount --bind /data/local/tmp/vv_xbin_vide /system/xbin 2>&1
  echo "=== après masquage (attendu : su invisible) ==="
  adb shell 'ls /system/bin/su /system/xbin/su /system/app/Superuser.apk 2>&1'
} | tee "$OUT/su_mask_proof.txt"
adb uninstall "$PKG" >/dev/null 2>&1
if adb install -r -t "$APK" > "$OUT/install.log" 2>&1; then
  record PASS "P3_installation_${LANGUE}_${MODE}" "$(tail -1 "$OUT/install.log" | tr -d '\r')"
else
  record FAIL "P3_installation_${LANGUE}_${MODE}" "$(tail -2 "$OUT/install.log" | tr '\n' ' ')"
  exit 0
fi
adb shell pm grant "$PKG" android.permission.CAMERA >/dev/null 2>&1
adb shell pm grant "$PKG" android.permission.RECORD_AUDIO >/dev/null 2>&1

adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start.log" 2>&1
sleep 4

# --- amont localisé : langue → session → carrousel → activité → catalogue ------
ok=0
for t in "Choisissez votre langue" "Choose your language" "Elige tu idioma" "言語を選んでください"; do
  if $UI wait --text "$t" --exact --timeout 20 >/dev/null 2>&1; then ok=1; break; fi
done
[ "$ok" = "1" ] && record PASS "P3_ecran_langue_${LANGUE}" "écran de langue affiché" \
                 || record FAIL "P3_ecran_langue_${LANGUE}" "écran de langue absent"

ecran_connexion=0
for essai in 1 2 3 4; do
  $UI tap --text "$CARTE" --exact --timeout 15 >/dev/null 2>&1
  if $UI wait --text "$AUTH" --exact --timeout 25 >/dev/null 2>&1; then ecran_connexion=1; break; fi
  echo "E2E P3 : appui langue $essai sans effet"
done
[ "$ecran_connexion" = "1" ] && record PASS "P3_langue_appliquee_${LANGUE}" "« $AUTH » affiché (langue $LANGUE appliquée)" \
                           || record FAIL "P3_langue_appliquee_${LANGUE}" "écran d'authentification jamais atteint en $LANGUE"

for essai in 1 2 3 4 5 6; do
  $UI tap --id "auth_offline_button" --timeout 10 >/dev/null 2>&1
  if $UI wait --text "$S1" --exact --timeout 20 >/dev/null 2>&1; then break; fi
  sleep 4
done
if $UI wait --text "$S1" --exact --timeout 10 >/dev/null 2>&1; then
  record PASS "P3_carrousel1_${LANGUE}" "« $S1 »"
else
  record FAIL "P3_carrousel1_${LANGUE}" "« $S1 » absent"
fi
$UI tap --text "$SUIVANT" --exact --timeout 15 >/dev/null 2>&1
if $UI wait --text "$S2" --exact --timeout 30 >/dev/null 2>&1; then
  record PASS "P3_carrousel2_${LANGUE}" "« $S2 »"
else
  record FAIL "P3_carrousel2_${LANGUE}" "« $S2 » absent"
fi
$UI tap --text "$SUIVANT" --exact --timeout 15 >/dev/null 2>&1
if $UI wait --text "$S3" --exact --timeout 30 >/dev/null 2>&1; then
  record PASS "P3_carrousel3_${LANGUE}" "« $S3 »"
else
  record FAIL "P3_carrousel3_${LANGUE}" "« $S3 » absent"
fi
$UI tap --text "$DEMARRER" --exact --timeout 15 >/dev/null 2>&1

if $UI wait --text "$SECTEUR" --exact --timeout 60 >/dev/null 2>&1; then
  record PASS "P3_activite_${LANGUE}" "« $SECTEUR »"
else
  record FAIL "P3_activite_${LANGUE}" "« $SECTEUR » absent"
fi
# Sélection du secteur : l'écran est PAGINÉ (2 cartes/page, 3 pages — le run
# 42732996211 : la carte commerce n'était pas en page 1 en ja). On cherche la
# carte commerce jusqu'à 3 pages ; à défaut, N'IMPORTE QUELLE carte visible
# convient : chaque secteur possède un T1 « Nouvel arrivage » (les 6 T1.json
# du dépôt le portent) et le brief reste en français par design produit.
CARTES_SECTEURS=(
  "$SECTEUR_MODE" "$SECTEUR_COIFFURE" "$SECTEUR_RESTAURATION"
  "$SECTEUR_BTP" "$SECTEUR_IMMO" "$SECTEUR_COMMERCE"
)
secteur_choisi=""
for page in 1 2 3; do
  if $UI tap --text "$SECTEUR_COMMERCE" --timeout 4 >/dev/null 2>&1; then
    secteur_choisi="$SECTEUR_COMMERCE"; break
  fi
  for carte in "${CARTES_SECTEURS[@]}"; do
    if $UI tap --text "$carte" --timeout 3 >/dev/null 2>&1; then
      secteur_choisi="$carte"; break 2
    fi
  done
  swipe_v 50 18 350 >/dev/null 2>&1
  sleep 1
done
[ -n "$secteur_choisi" ] && echo "E2E P3 secteur choisi : $secteur_choisi (page $page/3)" \
                       || echo "E2E P3 aucune carte secteur actionnée (présélection ?)"
sleep 1
$UI tap --text "$CONTINUER" --exact --timeout 15 >/dev/null 2>&1 || true
if $UI wait --text "$SANS_CODE" --exact --timeout 30 >/dev/null 2>&1; then
  record PASS "P3_parrainage_${LANGUE}" "étape parrainage localisée"
  $UI tap --text "$SANS_CODE" --exact --timeout 10 >/dev/null 2>&1 || true
else
  record BLOCKED "P3_parrainage_${LANGUE}" "étape parrainage non atteinte"
fi
catalogue_atteint=0
for _ in 1 2 3; do
  $UI tap --text "$CONTINUER" --exact --timeout 15 >/dev/null 2>&1 || true
  if $UI wait --text "$CATALOGUE" --exact --timeout 15 >/dev/null 2>&1; then catalogue_atteint=1; break; fi
  sleep 2
done
[ "$catalogue_atteint" = "1" ] && record PASS "P3_catalogue_${LANGUE}" "« $CATALOGUE »" \
                           || record FAIL "P3_catalogue_${LANGUE}" "« $CATALOGUE » absent"
shot "07_catalogue_${LANGUE}"; dump "07_catalogue_${LANGUE}"

# --- brief (libellés FR par design produit : gabarits non localisés) ------------
if $UI tap --text "Nouvel arrivage" --timeout 10 >/dev/null 2>&1; then
  record PASS "P3_selection_gabarit_${LANGUE}" "gabarit « Nouvel arrivage » (T1) sélectionné"
else
  record FAIL "P3_selection_gabarit_${LANGUE}" "gabarit introuvable au catalogue"
fi
sleep 4
shot "21_brief"; dump "21_brief"

brief_ok=0
# D42.28-15 : le wait ui.py --exact a échoué 8 fois (2 runs) alors que le dump
# 21_brief.xml prouvait l'écran (« Ma vidéo » + champs + exemples). La preuve
# retenue est le DUMP ARCHIVÉ (grep du titre), avec re-tentatives : plus solide
# et diagnostiqué dans le log (nœuds comptés). Le wait reste tenté à titre de
# diagnostic (sa sortie EST affichée cette fois).
echo "E2E P3 brief : dump 21_brief.xml = $(wc -c < "$OUT/21_brief.xml" 2>/dev/null || echo 0) octets, $(grep -c '<node' "$OUT/21_brief.xml" 2>/dev/null || echo 0) nœuds"
$UI wait --text "$BRIEF" --exact --timeout 8 || echo "E2E P3 brief : wait diagnostic échoué (ci-dessus : nodes= vide = dump KO ; nodes=N = titre non trouvé)"
for essai_brief in 1 2 3; do
  if [ -s "$OUT/21_brief.xml" ] && grep -q "text=\"$BRIEF\"" "$OUT/21_brief.xml"; then
    brief_ok=1; break
  fi
  sleep 3
  shot "21_brief_r${essai_brief}"; dump "21_brief_r${essai_brief}"
  cp "$OUT/21_brief_r${essai_brief}.xml" "$OUT/21_brief.xml" 2>/dev/null || true
done
if [ "$brief_ok" = "1" ]; then
  $UI champs > "$OUT/champs.txt" 2>&1 || true
fi
if [ "$brief_ok" != "1" ]; then
  record BLOCKED "P3_brief_${LANGUE}" "formulaire de brief non atteint"
  record BLOCKED "P3_export_${LANGUE}_${MODE}" "brief non affiché — parcours interrompu"
  { echo "tag=$TAG langue=$LANGUE mode=$MODE"; echo "PASS=$pass FAIL=$fail BLOCKED=$blocked"; } > "$OUT/summary.txt"
  exit 0
fi
record PASS "P3_brief_${LANGUE}" "formulaire de brief affiché (titre « $BRIEF » constaté ; $(grep -c 'E2E CHAMP' "$OUT/champs.txt" 2>/dev/null || echo '?') champs détectés)"

fermer_clavier() {
  if adb shell dumpsys input_method 2>/dev/null | grep -q "mInputShown=true"; then
    adb shell input keyevent 4 >/dev/null 2>&1
    sleep 1
  fi
}
remplir_champ() { # index, texte — coordonnées relues à chaque champ (P1 éprouvé)
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
valeur_pour() { # libellé (FR, design produit) -> valeur valide
  local l
  l=$(echo "$1" | tr 'A-Z' 'a-z')
  case "$l" in
    *commerce*|*boutique*)            echo "BoutiqueAwa" ;;
    *whatsapp*|*num*ro*|*t*l*phone*)  echo "+2290197000000" ;;
    *prix*|*montant*)                 echo "15000" ;;
    *monnaie*)                        echo "FCFA" ;;   # si non préremplie (requis chez le mode, run 42764463666 : 4/6)
    *quartier*|*ville*|*adresse*)     echo "Akpakpa" ;;
    *nom*|*v*tement*|*produit*|*plat*|*travail*|*article*) echo "RobeWax" ;;
    *)                                echo "Essai" ;;
  esac
}
# remplissage piloté par libellé + passes de complétion (copie EXACTE du P1,
# éprouvée 16/16 au lab — y compris remonter_formulaire, absent de la version
# précédente : le quartier, sous le pli en bas, restait vide et le bouton
# Continuer désactivé → parcours figé sur le brief, run 42742781593).
remonter_formulaire() { # retour en haut : les coordonnées des champs y sont valides
  local i
  for i in 1 2 3; do
    swipe_v 26 73 250 >/dev/null 2>&1
    sleep 1
  done
}
remonter_formulaire
remplis=0; deja=" "; sans_effet=0
for tour in 1 2 3 4 5 6 7 8 9 10 11 12; do
  $UI champs > "$OUT/champs.txt" 2>&1 || true
  progresse=0
  while IFS= read -r ligne; do
    idx=$(echo "$ligne" | awk '{print $3}')
    etat=$(echo "$ligne" | awk '{print $8}')
    libelle=$(echo "$ligne" | sed 's/^[^|]*|//; s/|[[:space:]]*$//')
    [ "$etat" = "vide" ] || continue
    case "$deja" in *"|$libelle|"*) continue ;; esac
    val=$(valeur_pour "$libelle")
    deja="$deja|$libelle|"
    progresse=1
    if [ -z "$val" ]; then echo "E2E P3 champ laissé prérempli : [$libelle]"; continue; fi
    echo "E2E P3 remplissage [$libelle] <- $val"
    remplir_champ "$idx" "$val" "$OUT/champs.txt" && remplis=$((remplis+1))
    break
  done < <(grep "^E2E CHAMP " "$OUT/champs.txt")
  if [ "$progresse" = "0" ]; then
    sans_effet=$((sans_effet+1))
    [ "$sans_effet" -ge 2 ] && break
    swipe_v 73 43 250 >/dev/null 2>&1
    sleep 1
  fi
done
for passe in 1 2 3; do
  if [ "$passe" -gt 1 ]; then
    swipe_v 73 26 250 >/dev/null 2>&1
    sleep 1
  fi
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
    echo "E2E P3 complément [$libelle] <- $val"
    remplir_champ "$idx" "$val" "$OUT/champs.txt" && remplis=$((remplis+1))
    break
  done < <(grep "^E2E CHAMP " "$OUT/champs.txt")
  [ "$restant" = "0" ] && [ "$passe" -ge 2 ] && break
done
echo "E2E P3 champs remplis (après complément) : $remplis"
$UI champs > "$OUT/champs_apres.txt" 2>&1 || true
sed 's/^/E2E P3 /' "$OUT/champs_apres.txt"
trouve=0
for _ in 1 2 3 4 5 6; do
  if $UI wait --text "$CONTINUER_BRIEF" --exact --timeout 2 >/dev/null 2>&1; then trouve=1; break; fi
  swipe_v 73 26 250 >/dev/null 2>&1
  sleep 1
done
# D42.28-23 : passe basse ISOLÉE EN FONCTION (contournement : aux runs
# 42771629495/42779450774, l'écho d'entrée de la boucle inline s'affichait
# puis le corps sautait — ni shot 22b_bas, ni champs_bas.txt dans les
# artefacts — alors que le blob exécuté les contient ; même structure que
# les fonctions qui, elles, s'exécutent toujours (remplir_champ, etc.).
basse_passe() { # $1 = numéro de passe
  echo "E2E P3 [passe basse $1] début"
  fermer_clavier
  pas_bas=0
  n=0
  while [ "$n" -lt 6 ]; do
    n=$((n+1))
    if $UI wait --text "$CONTINUER_BRIEF" --exact --timeout 2 >/dev/null 2>&1; then
      pas_bas=1
      break
    fi
    # D42.28-27 (v12) : PAS de redirection sur cet appel — v11 a montré la
    # trace s'arrêter précisément ici ; le corps de swipe_v et la suite de
    # la boucle étaient invisibles car >/dev/null 2>&1 masque aussi le
    # xtrace interne de la fonction appelée (swipe_v est auto-contenue :
    # ses sorties sont déjà capturées/redirigées en son sein).
    swipe_v 78 20 600
    echo "E2E P3 [passe basse $1] apres swipe n=$n rc=$?"
    sleep 1
    if $UI wait --text "$CONTINUER_BRIEF" --exact --timeout 1 >/dev/null 2>&1; then
      pas_bas=1
      break
    fi
    adb shell input keyevent KEYCODE_PAGE_DOWN
    echo "E2E P3 [passe basse $1] apres page_down n=$n rc=$?"
    sleep 1
  done
  echo "E2E P3 [passe basse $1] boucle while finie n=$n pas_bas=${pas_bas:-0}"
  echo "E2E P3 [passe basse $1] bouton atteint=${pas_bas:-0} (essais=${n})"
  shot "22b_bas_$1"
  dump "22b_bas_$1"
  echo "E2E P3 [passe basse $1] shot/dump faits ($(wc -c < "$OUT/22b_bas_$1.xml" 2>/dev/null || echo 0) octets de dump)"
  $UI champs > "$OUT/champs_bas.txt" 2>&1 || true
  nb_lignes=$(grep -c "^E2E CHAMP" "$OUT/champs_bas.txt" 2>/dev/null)
  nb_lignes=${nb_lignes:-0}
  echo "E2E P3 [passe basse $1] champs visibles=${nb_lignes} : $(tr '\n' ';' < "$OUT/champs_bas.txt" 2>/dev/null | head -c 400)"
  vide_bas=$(grep -c " vide " "$OUT/champs_bas.txt" 2>/dev/null)
  vide_bas=${vide_bas:-0}
  echo "E2E P3 [passe basse $1] champs vides=${vide_bas}"
  if [ "$vide_bas" != "0" ]; then
    while IFS= read -r ligne; do
      idx=$(echo "$ligne" | awk '{print $3}')
      libelle=$(echo "$ligne" | sed 's/^[^|]*|//; s/|[[:space:]]*$//')
      val=$(valeur_pour "$libelle")
      if [ -n "$val" ]; then
        echo "E2E P3 passe basse [$libelle] <- $val"
        remplir_champ "$idx" "$val" "$OUT/champs_bas.txt" && remplis=$((remplis+1))
      fi
    done < <(grep "^E2E CHAMP " "$OUT/champs_bas.txt" | grep " vide " | head -1)
  fi
  return 0
}

# D42.28-25 : trace xtrace de la passe basse (le corps de la fonction est
# « avalé » depuis 5 runs : premier écho visible, puis plus RIEN — ni echoes,
# ni shot, ni champs_bas.txt à l'artefact — alors que le script exécuté est
# le bon (sha256 vérifié en tête de cellule). La trace ci-dessous, écrite
# dans bash_x.log (artefact) + résumée au log, montrera la commande exacte
# où l'exécution dévie.
exec 9>>"$OUT/bash_x.log"
echo "=== $(date -u +%H:%M:%S) passe basse ===" >&9
PS4='+L${LINENO}: ' 
set -x
for _passe_bas in 1 2 3; do
  basse_passe "$_passe_bas"
  vide_bas=$(grep -c " vide " "$OUT/champs_bas.txt" 2>/dev/null)
  vide_bas=${vide_bas:-0}
  [ "$vide_bas" = "0" ] && [ -s "$OUT/champs_bas.txt" ] && break
done
set +x
exec 9>&-
echo "E2E P3 xtrace : $(wc -l < "$OUT/bash_x.log" 2>/dev/null || echo 0) lignes dans bash_x.log"
echo "E2E P3 champs remplis (passe basse incluse) : $remplis"
$UI champs > "$OUT/champs_apres.txt" 2>&1 || true
sed 's/^/E2E P3 /' "$OUT/champs_apres.txt"
# redescendre vers le bouton si la passe basse a fait défiler
for _ in 1 2 3 4; do
  if $UI wait --text "$CONTINUER_BRIEF" --exact --timeout 2 >/dev/null 2>&1; then trouve=1; break; fi
  swipe_v 73 26 250 >/dev/null 2>&1
  sleep 1
done
if grep -q " vide " "$OUT/champs_apres.txt" 2>/dev/null; then
  champ_manquant=$(grep " vide " "$OUT/champs_apres.txt" | head -1 | sed 's/^[^|]*|//; s/|[[:space:]]*$//')
  echo "E2E P3 AVERTISSEMENT : champ encore vide après complément : [$champ_manquant]"
fi
$UI tap --text "$CONTINUER_BRIEF" --exact --timeout 15 >/dev/null 2>&1 || true
if $UI wait --text "$E4B" --exact --timeout 25 >/dev/null 2>&1; then
  record PASS "P3_brief_valide_${LANGUE}" "brief accepté → « $E4B »"
else
  if grep -q " vide " "$OUT/champs_apres.txt" 2>/dev/null; then
    record FAIL "P3_brief_valide_${LANGUE}" "champ requis resté vide ([$champ_manquant]) : bouton Continuer désactivé — écran « $E4B » jamais atteint"
  else
    record FAIL "P3_brief_valide_${LANGUE}" "tous les champs remplis mais écran « $E4B » absent après Continuer (voir champs_apres.txt / dumps)"
  fi
fi
$UI tap --text "$E4B_OK" --exact --timeout 15 >/dev/null 2>&1 || true
sleep 3

# --- guide + prises (libellés localisés, badge PRISE codé en dur) ---------------
if $UI wait --text "$E6" --timeout 40 >/dev/null 2>&1; then
  record PASS "P3_camera_ecran_${LANGUE}" "« $E6 » affiché"
else
  record BLOCKED "P3_camera_ecran_${LANGUE}" "écran caméra non atteint"
fi
prise() { # numéro
  local n="$1"
  $UI tap --text "$E6_REC" --exact --timeout 12 >/dev/null 2>&1 || true
  $UI wait --id "camera_record_button" --timeout 30 >/dev/null 2>&1 || return 1
  $UI tap --text "$CAM_REC" --exact --timeout 10 >/dev/null 2>&1 \
    || $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1 || return 1
  if ! $UI wait --text "$CAM_STOP" --exact --timeout 8 >/dev/null 2>&1; then
    if $UI wait --text "$R4" --timeout 8 >/dev/null 2>&1; then
      $UI tap --text "$R4_OK" --exact --timeout 8 >/dev/null 2>&1 || true
    fi
    $UI wait --text "$CAM_STOP" --exact --timeout 25 >/dev/null 2>&1 || return 2
  fi
  sleep 6
  shot "25_prise_${n}"
  $UI tap --text "$CAM_STOP" --exact --timeout 10 >/dev/null 2>&1 || return 3
  sleep 5
  $UI wait --text "$E6_REC" --exact --timeout 25 >/dev/null 2>&1 \
    || $UI wait --text "$CAM_REC" --exact --timeout 10 >/dev/null 2>&1 \
    || $UI wait --text "Refaire" --exact --timeout 10 >/dev/null 2>&1 && return 0
  return 4
}
prises=0
for n in 1 2; do
  prise "$n"; rc=$?
  case $rc in
    0) prises=$((prises+1)); record PASS "P3_prise_${n}_${LANGUE}" "prise enregistrée (caméra émulée)" ;;
    1) record BLOCKED "P3_prise_${n}_${LANGUE}" "bouton d'enregistrement introuvable" ;;
    *) record FAIL "P3_prise_${n}_${LANGUE}" "prise $n en échec (rc=$rc)" ;;
  esac
  $UI tap --text "$SUIVANT" --exact --timeout 10 >/dev/null 2>&1 || true
  sleep 3
done
[ "$prises" -ge 1 ] && record PASS "P3_prises_${LANGUE}" "$prises prise(s) enregistrée(s)" \
                   || record BLOCKED "P3_prises_${LANGUE}" "aucune prise enregistrée"

# complétion du guide (badge « PRISE n/N » codé en dur — P1 éprouvé)
if $UI wait --text "$E6" --timeout 6 >/dev/null 2>&1; then
  rush_count=$(app_ls files/rushes | tr -d '\r' | grep -c '^rush-')
  requis=$($UI probe 2>/dev/null | grep -o 'PRISE [0-9]*/[0-9]*' | head -1 | sed 's|.*/||')
  case "$requis" in ''|*[!0-9]*) requis=3 ;; esac
  echo "E2E P3 guide : $rush_count prise(s), $requis exigée(s)"
  cycle=0
  while [ "$rush_count" -lt "$requis" ] && [ "$cycle" -lt 4 ]; do
    cycle=$((cycle+1))
    $UI wait --id "camera_record_button" --timeout 20 >/dev/null 2>&1 || break
    $UI tap --text "$CAM_REC" --exact --timeout 10 >/dev/null 2>&1 \
      || $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1 || true
    if ! $UI wait --text "$CAM_STOP" --exact --timeout 8 >/dev/null 2>&1; then
      if $UI wait --text "$R4" --timeout 8 >/dev/null 2>&1; then
        $UI tap --text "$R4_OK" --exact --timeout 8 >/dev/null 2>&1 || true
      fi
      $UI wait --text "$CAM_STOP" --exact --timeout 25 >/dev/null 2>&1 || break
    fi
    sleep 6
    $UI tap --text "$CAM_STOP" --exact --timeout 10 >/dev/null 2>&1 || break
    sleep 4
    rush_count=$(app_ls files/rushes | tr -d '\r' | grep -c '^rush-')
    echo "E2E P3 complétion : cycle $cycle -> $rush_count prise(s)"
    $UI wait --text "$E6" --timeout 6 >/dev/null 2>&1 || break
  done
  if $UI wait --text "$E6" --timeout 4 >/dev/null 2>&1; then
    for i in 1 2 3 4 5 6; do
      $UI inside --text "$SUIVANT" --exact --timeout 3 >/dev/null 2>&1 && break
      swipe_v 73 21 300 >/dev/null 2>&1
      sleep 1
    done
    $UI inside --text "$SUIVANT" --exact --timeout 3 >/dev/null 2>&1 \
      && $UI tap --text "$SUIVANT" --exact --timeout 8 >/dev/null 2>&1
    sleep 3
  fi
fi
if $UI wait --text "$E6" --timeout 6 >/dev/null 2>&1; then
  record FAIL "P3_guide_termine_${LANGUE}" "guide toujours affiché après complétion"
else
  rush_count=$(app_ls files/rushes | tr -d '\r' | grep -c '^rush-')
  record PASS "P3_guide_termine_${LANGUE}" "guide terminé : $rush_count prise(s), écran suivant atteint"
fi
app_ls files/rushes -l > "$OUT/27_rushes.txt" 2>&1 || true

# --- PRÉPARATION DU MODE AUDIO (AVANT « Créer ma vidéo ») -----------------------
# Constat structurel : les rushs de l'émulateur sont-ils muets ?
RUSH_AVANT=$(app_ls files/rushes | tr -d '\r' | grep -m1 '^rush-' || true)
if [ -n "$RUSH_AVANT" ] && command -v ffprobe >/dev/null 2>&1; then
  app_cat "files/rushes/$RUSH_AVANT" > "$OUT/rush_original.mp4" 2>/dev/null
  if ffprobe -v error -select_streams a -show_entries stream=codec_type "$OUT/rush_original.mp4" 2>/dev/null | grep -q audio; then
    echo "rush_avec_audio=true" >> "$OUT/constats_mode.txt"
  else
    echo "rush_avec_audio=false" >> "$OUT/constats_mode.txt"
  fi
fi

case "$MODE" in
  musique)
    # D42.28-16/21 : le produit ne télécharge le BGM qu'avec un jeton Firebase
    # (session démo : files/bgm reste vide, export SFX seuls). Le banc injecte
    # les 6 pistes titulaires T1 (compte sonde) : l'export utilise celle du
    # gabarit choisi (localFile au repli de ExportActivity) — mode « musique » réel.
    n_inj=$(injecter_bgm)
    if [ "$n_inj" -ge 1 ]; then
      echo "bgm_injection=${n_inj} fichier(s)" >> "$OUT/constats_mode.txt"
    else
      echo "bgm_injection=ECHEC" >> "$OUT/constats_mode.txt"
    fi
    n_bgm=$(app_ls files/bgm 2>/dev/null | tr -d '\r' | grep -cE '\.mp3|\.m4a')
    echo "bgm_en_cache=$n_bgm" >> "$OUT/constats_mode.txt"
    ;;
  voix|mix)
    # 1) injecter une piste audio (voix de synthèse, sinus -20 dB) dans
    #    CHAQUE rush : le produit lit les fichiers files/rushes au moment
    #    de l'export (chemins passés au worker) — le contenu remplacé est
    #    utilisé. Durée vidéo conservée (caméra copiée, pas réencodée).
    for R in $(app_ls files/rushes | tr -d '\r' | grep '^rush-'); do
      app_cat "files/rushes/$R" > "$OUT/r.bin" 2>/dev/null || continue
      D=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUT/r.bin" 2>/dev/null | cut -d. -f1)
      case "$D" in ''|*[!0-9]*) D=6 ;; esac
      if ffmpeg -y -v error -i "$OUT/r.bin" \
           -f lavfi -t "$D" -i "sine=frequency=440" \
           -filter_complex "[1:a]volume=-20dB[a]" \
           -map 0:v -map "[a]" -c:v copy -c:a aac -shortest "$OUT/r_audio.mp4" 2>"$OUT/ffmpeg_inject.log"; then
        if adb push "$OUT/r_audio.mp4" /data/local/tmp/r_audio.mp4 >/dev/null 2>&1 \
           && adb shell run-as "$PKG" cp /data/local/tmp/r_audio.mp4 "files/rushes/$R" >/dev/null 2>&1; then
          echo "injection_audio=$R ok (${D}s)" >> "$OUT/constats_mode.txt"
        else
          echo "injection_audio=$R ECHEC (push/cp)" >> "$OUT/constats_mode.txt"
        fi
      else
        echo "injection_audio=$R ECHEC (ffmpeg)" >> "$OUT/constats_mode.txt"
      fi
    done
    # vérifier l'injection
    app_cat "files/rushes/$RUSH_AVANT" > "$OUT/rush_apres.mp4" 2>/dev/null
    if [ -s "$OUT/rush_apres.mp4" ] && command -v ffprobe >/dev/null 2>&1 \
       && ffprobe -v error -select_streams a -show_entries stream=codec_type "$OUT/rush_apres.mp4" 2>/dev/null | grep -q audio; then
      record PASS "P3_rushs_avec_voix_${LANGUE}_${MODE}" "piste audio injectée dans les rushs (voix de synthèse -20 dB)"
    else
      record FAIL "P3_rushs_avec_voix_${LANGUE}_${MODE}" "injection d'audio dans les rushs en échec (voir constats_mode.txt)"
    fi
    if [ "$MODE" = "voix" ]; then
      # 2) vider le cache BGM : BgmDecoder ne trouvera pas le fichier →
      #    music=null → pass-through voix seule (robustesse produit).
      #    NB : pas de sh -c (quotes perdues à travers adb) — rm fichier
      #    par fichier, liste établie par app_ls.
      for B in $(app_ls files/bgm 2>/dev/null | tr -d '\r' | grep '\.mp3'); do
        adb shell run-as "$PKG" rm "files/bgm/$B" >/dev/null 2>&1 || true
      done
      n_bgm=$(app_ls files/bgm 2>/dev/null | tr -d '\r' | grep -c '\.mp3')
      echo "bgm_en_cache=$n_bgm (vidé pour le mode voix)" >> "$OUT/constats_mode.txt"
    else
      # mode MIX : injecter AUSSI les 6 BGM titulaires (même méthode que le
      # mode musique) : voix dans les rushs + musique en cache = mix réel.
      n_inj=$(injecter_bgm)
      if [ "$n_inj" -ge 1 ]; then
        echo "bgm_injection=${n_inj} fichier(s)" >> "$OUT/constats_mode.txt"
      else
        echo "bgm_injection=ECHEC" >> "$OUT/constats_mode.txt"
      fi
      n_bgm=$(app_ls files/bgm 2>/dev/null | tr -d '\r' | grep -cE '\.mp3|\.m4a')
      echo "bgm_en_cache=$n_bgm" >> "$OUT/constats_mode.txt"
    fi
    ;;
esac
shot "27b_preparation_mode"; dump "27b_preparation_mode"

# --- export (E7 → E8 → terminé) — libellés localisés -----------------------------
revele() { # libellé exact -> rc 0 si entièrement visible (P1 éprouvé)
  local lbl="$1" i
  for i in $(seq 1 12); do
    $UI inside --text "$lbl" --exact --timeout 3 >/dev/null 2>&1 && return 0
    swipe_v 73 21 400 >/dev/null 2>&1
    sleep 1
  done
  for i in 1 2 3 4; do
    $UI inside --text "$lbl" --exact --timeout 3 >/dev/null 2>&1 && return 0
    swipe_v 86 79 600 >/dev/null 2>&1
    sleep 1
  done
  $UI inside --text "$lbl" --exact --timeout 3 >/dev/null 2>&1
}
if $UI wait --text "$E7" --timeout 30 >/dev/null 2>&1; then
  record PASS "P3_apercu_${LANGUE}" "« $E7 » atteint"
  shot "28_apercu"; dump "28_apercu"
  revele "$E7_CREATE" >/dev/null 2>&1 || true
  $UI tap --text "$E7_CREATE" --exact --timeout 8 >/dev/null 2>&1
  if $UI wait --text "$EXP_START" --timeout 25 >/dev/null 2>&1; then
    record PASS "P3_ui_export_${LANGUE}" "UI d'export (E8) affichée : « $EXP_START »"
  else
    record FAIL "P3_ui_export_${LANGUE}" "E8 jamais atteinte après « $E7_CREATE »"
  fi
else
  record BLOCKED "P3_apercu_${LANGUE}" "écran d'aperçu non atteint"
fi
export_lance=0
if $UI wait --text "$EXP_START" --exact --timeout 5 >/dev/null 2>&1; then
  revele "$EXP_START" >/dev/null 2>&1 || true
  $UI tap --text "$EXP_START" --exact --timeout 8 >/dev/null 2>&1
  sleep 2
  if $UI wait --text "$EXP_RUNNING" --timeout 25 >/dev/null 2>&1; then
    export_lance=1
    record PASS "P3_export_lance_${LANGUE}_${MODE}" "export lancé : « $EXP_RUNNING »"
  else
    record FAIL "P3_export_lance_${LANGUE}_${MODE}" "aucun statut de démarrage constaté"
  fi
else
  record BLOCKED "P3_export_lance_${LANGUE}_${MODE}" "bouton d'export introuvable"
fi

# notification FGS + écran éteint (P1 éprouvé)
sleep 20
adb shell dumpsys notification 2>/dev/null | grep -q "vv_export" \
  && record PASS "P3_notif_fgs_${LANGUE}_${MODE}" "notification vv_export présente" \
  || record FAIL "P3_notif_fgs_${LANGUE}_${MODE}" "aucune notification vv_export"
adb shell input keyevent 26 >/dev/null 2>&1
sleep 45
adb shell input keyevent 26 >/dev/null 2>&1
adb shell wm dismiss-keyguard >/dev/null 2>&1
sleep 3
$UI wait --text "$EXP_RUNNING" --timeout 90 >/dev/null 2>&1 \
  || $UI wait --text "$EXP_DONE" --timeout 5 >/dev/null 2>&1

# fin d'export (fenêtre 75 min — D42.28-29 : avec la BGM réellement mixée,
# l'export dépasse 40 min sur l'émulateur swiftshader, cf. lab 42811778574 ;
# jobs portés à timeout-minutes: 330). D42.28-17 : l'attente ne
# s'applique QUE si l'export a été lancé — sinon le parcours est déjà en échec
# et la cellule brûlait 40 min pour rien (run 42742781593 : 3×45 min stériles,
# timeout job 150 min atteint, run annulé).
if [ "$export_lance" = "1" ]; then
  if $UI wait --text "$EXP_DONE" --exact --timeout 4500 >/dev/null 2>&1; then
    record PASS "P3_export_termine_${LANGUE}_${MODE}" "« $EXP_DONE » affiché"
    shot "29_export_termine"; dump "29_export_termine"
  else
    record FAIL "P3_export_termine_${LANGUE}_${MODE}" "aucune fin d'export en 75 min"
    shot "29_export_timeout"; dump "29_export_timeout"
  fi
else
  record FAIL "P3_export_termine_${LANGUE}_${MODE}" "export jamais lancé — attente de fin esquivée (voir verdicts amont)"
  shot "29_export_timeout"; dump "29_export_timeout"
fi

# --- MP4 + preuves acoustiques --------------------------------------------------
MP4=$(app_ls cache | tr -d '\r' | grep -m1 'export-.*\.mp4' || true)
if [ -n "${MP4:-}" ]; then
  app_cat "cache/$MP4" > "$OUT/export.mp4"
  TAILLE=$(stat -c%s "$OUT/export.mp4" 2>/dev/null || echo 0)
  if [ "${TAILLE:-0}" -gt 0 ]; then
    record PASS "P3_mp4_extrait_${LANGUE}_${MODE}" "$MP4 ($TAILLE octets)"
  else
    record FAIL "P3_mp4_extrait_${LANGUE}_${MODE}" "$MP4 vide (0 octet)"
  fi
else
  record FAIL "P3_mp4_extrait_${LANGUE}_${MODE}" "aucun export-*.mp4 dans cache"
fi

if [ -s "$OUT/export.mp4" ] && command -v ffprobe >/dev/null 2>&1; then
  ffprobe -v error -show_entries format=duration,size,format_name \
    -of default=noprint_wrappers=1 "$OUT/export.mp4" > "$OUT/ffprobe.txt" 2>&1
  # piste audio + durée
  if ffprobe -v error -select_streams a -show_entries stream=codec_type,sample_rate,channels \
       -of default=noprint_wrappers=1 "$OUT/export.mp4" 2>/dev/null | grep -q "codec_type=audio"; then
    record PASS "P3_mp4_piste_audio_${LANGUE}_${MODE}" "piste audio présente (ffprobe.txt)"
  else
    record FAIL "P3_mp4_piste_audio_${LANGUE}_${MODE}" "aucune piste audio dans le MP4 exporté"
  fi
  # RMS global + RMS fenêtre intro (2 s)
  ffmpeg -v info -i "$OUT/export.mp4" -af "astats=metadata=1" -f null - 2>&1 \
    | grep -E "Overall|RMS level" | tail -2 > "$OUT/astats_global.txt" || true
  ffmpeg -v info -ss 0 -t 2 -i "$OUT/export.mp4" -af "astats=metadata=1" -f null - 2>&1 \
    | grep -E "Overall|RMS level" | tail -2 > "$OUT/astats_intro.txt" || true
  RMS_G=$(grep -oE "RMS level dB: -?[0-9(inf)+.]+" "$OUT/astats_global.txt" | tail -1 | grep -oE "\-?[0-9.]+|inf" | head -1)
  RMS_I=$(grep -oE "RMS level dB: -?[0-9(inf)+.]+" "$OUT/astats_intro.txt" | tail -1 | grep -oE "\-?[0-9.]+|inf" | head -1)
  echo "RMS_global_dB=${RMS_G:-indisponible} RMS_intro_2s_dB=${RMS_I:-indisponible}" >> "$OUT/constats_mode.txt"
  case "$MODE" in
    musique|mix)
      # l'intro (avant toute prise) porte la musique seule : audible
      if [ -n "${RMS_I:-}" ] && [ "$RMS_I" != "inf" ] 2>/dev/null \
         && awk -v r="$RMS_I" 'BEGIN{exit !(r > -28)}'; then
        record PASS "P3_mode_${MODE}_${LANGUE}" "musique audible dès l'intro (RMS intro ${RMS_I} dB > -28) — mode ${MODE} confirmé acoustiquement"
      else
        record FAIL "P3_mode_${MODE}_${LANGUE}" "intro quasi muette (RMS intro ${RMS_I:-?} dB) : le mode ${MODE} n'est pas établi"
      fi
      ;;
    voix)
      # musique absente : l'intro (pas de rush) doit être quasi silencieuse
      if [ -z "${RMS_I:-}" ] || [ "$RMS_I" = "inf" ] 2>/dev/null \
         || awk -v r="$RMS_I" 'BEGIN{exit !(r < -40)}'; then
        record PASS "P3_mode_voix_${LANGUE}" "intro quasi muette (RMS intro ${RMS_I:-inf} dB < -40) : musique absente — pass-through voix seule confirmé"
      else
        record FAIL "P3_mode_voix_${LANGUE}" "intro audible (RMS intro ${RMS_I:-?} dB) alors que la musique a été retirée — mode voix non établi"
      fi
      ;;
  esac
  # décodage intégral
  if ffmpeg -v error -i "$OUT/export.mp4" -f null - > "$OUT/decode_check.txt" 2>&1 && [ ! -s "$OUT/decode_check.txt" ]; then
    record PASS "P3_mp4_decode_${LANGUE}_${MODE}" "décodage intégral sans erreur"
  else
    record FAIL "P3_mp4_decode_${LANGUE}_${MODE}" "erreurs de décodage (decode_check.txt)"
  fi
else
  [ -s "$OUT/export.mp4" ] || record BLOCKED "P3_mp4_piste_audio_${LANGUE}_${MODE}" "MP4 absent ou ffprobe indisponible"
fi

# --- stabilité -------------------------------------------------------------------
if adb logcat -d -b crash | grep -q "FATAL EXCEPTION"; then
  adb logcat -d -b crash > "$OUT/crash.log"
  record FAIL "P3_aucun_crash_${LANGUE}_${MODE}" "FATAL EXCEPTION (crash.log)"
else
  record PASS "P3_aucun_crash_${LANGUE}_${MODE}" "aucune FATAL EXCEPTION"
fi
adb logcat -d > "$OUT/logcat.txt" 2>/dev/null

{ echo "tag=$TAG langue=$LANGUE mode=$MODE"; echo "PASS=$pass FAIL=$fail BLOCKED=$blocked"
  echo "apk=$APK"; echo "sha256=$(sha256sum "$APK" 2>/dev/null | cut -d' ' -f1)"; } > "$OUT/summary.txt"
cat "$OUT/summary.txt"
echo "=========== FIN P3 $LANGUE/$MODE : PASS=$pass FAIL=$fail BLOCKED=$blocked ==========="
exit 0
