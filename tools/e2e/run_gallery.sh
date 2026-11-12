#!/usr/bin/env bash
# ============================================================================
# D42.31 — PHASE A : GALERIE VISUELLE INTÉGRALE DE L'APK RC15 (IMMUTABLE)
# ============================================================================
# Usage : tools/e2e/run_gallery.sh <fr|en> <base|font130|petit|offline> <apk>
#
# Installe l'APK EXACTE de la release RC15 (sha256 vérifié en amont par le
# workflow), déroule le VRAI parcours utilisateur et capture chaque écran /
# état via `adb exec-out screencap` (barre d'état incluse, aucune retouche).
#
# PRINCIPES (mission D42.31) :
#   - AUCUNE modification de l'application : outil de capture uniquement ;
#   - données 100 % fictives : RobeWax, 0197000000, 15 000 FCFA, Akpakpa,
#     BoutiqueAwa — jamais de vraies données personnelles ;
#   - la caméra de l'émulateur est un flux ÉMULÉ (scène virtuelle) : les
#     captures caméra sont identifiées comme telles, jamais comme capteur
#     physique ;
#   - best-effort : un écran manquant est consigné dans gaps.txt, le parcours
#     continue (la galerie doit montrer l'état réel, pas un parcours ideal) ;
#   - manifest.tsv : ordre, id, titre, écran, état, langue, profil, fichier,
#     résolution — transformé en SCREEN_INVENTORY.csv côté dépôt.
# ============================================================================
set -u

LANGUE="${1:-fr}"
PROFIL="${2:-base}"
APK="${3:-app-debug.apk}"
PKG="video.vitrine.app"
UI="python3 tools/e2e/ui.py"
OUT="artifacts/gallery/${PROFIL}-${LANGUE}"
MANIFEST="$OUT/manifest.tsv"
GAPS="$OUT/gaps.txt"
ORDRE=0
mkdir -p "$OUT"
: > "$MANIFEST"; : > "$GAPS"

# ---------------------------------------------------------------- helpers ---
EFF_W=1080; EFF_H=2340
lire_taille_ecran() {
  local sz ov ph
  sz=$(adb shell wm size 2>/dev/null | tr -d '\r')
  ov=$(printf '%s\n' "$sz" | sed -n 's/.*Override size: \([0-9]*\)x\([0-9]*\).*/\1 \2/p')
  if [ -n "$ov" ]; then EFF_W=${ov% *}; EFF_H=${ov# *}; else
    ph=$(printf '%s\n' "$sz" | sed -n 's/.*Physical size: \([0-9]*\)x\([0-9]*\).*/\1 \2/p')
    [ -n "$ph" ] && { EFF_W=${ph% *}; EFF_H=${ph#* }; }
  fi
}
lire_taille_ecran
swipe_v() { # y1% y2% [durée_ms]
  adb shell input swipe $(( EFF_W / 2 )) $(( EFF_H * $1 / 100 )) \
    $(( EFF_W / 2 )) $(( EFF_H * $2 / 100 )) "${3:-250}" >/dev/null 2>&1
}
res_ecran() {
  adb shell wm size 2>/dev/null | tr -d '\r' | sed -n 's/.*Override size: //p' \
    | head -1 || true
}
galshot() { # id titre ecran etat
  ORDRE=$((ORDRE+1))
  local f
  f=$(printf '%03d_%s.png' "$ORDRE" "$1")
  adb exec-out screencap -p > "$OUT/$f" 2>/dev/null
  local res; res=$(res_ecran); [ -n "$res" ] || res="${EFF_W}x${EFF_H}"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$ORDRE" "$1" "$2" "$3" "$4" "$LANGUE" "$PROFIL" "$f" "$res" >> "$MANIFEST"
  echo "GALERIE [$ORDRE] $1 — $2 ($4)"
}
gap() { echo "$*" >> "$GAPS"; echo "GAP : $*"; }
WT=20
attendre() { # textes... (retour 0 si l'un apparaît)
  local t
  for t in "$@"; do
    $UI wait --text "$t" --timeout "$WT" >/dev/null 2>&1 && return 0
  done
  return 1
}
taper() { # texte [exact]
  local ex="${2:-}"
  if [ "$ex" = "exact" ]; then
    $UI tap --text "$1" --exact --timeout 12 >/dev/null 2>&1
  else
    $UI tap --text "$1" --timeout 12 >/dev/null 2>&1
  fi
}
focus_dans() { adb shell dumpsys window 2>/dev/null | tr -d '\r' \
  | grep -E "mCurrentFocus|mFocusedWindow" | head -2 | grep -qi "$1"; }
fermer_clavier() {
  if adb shell dumpsys input_method 2>/dev/null | grep -q "mInputShown=true"; then
    adb shell input keyevent 4 >/dev/null 2>&1; sleep 1
  fi
}
# remplissage simple (valeur fictive) : tap champ, MOVE_END, 24 DEL, texte
remplir() { # idx valeur [fichier champs]
  local idx="$1" val="$2" src="${3:-$OUT/champs.txt}" ligne x1 y1 x2 y2 cx cy
  ligne=$(awk -v i="$idx" '$1=="E2E" && $2=="CHAMP" && $3==i {print $4, $5, $6, $7}' "$src" 2>/dev/null)
  [ -z "$ligne" ] && return 1
  # shellcheck disable=SC2086
  set -- $ligne
  x1=$1; y1=$2; x2=$3; y2=$4
  cx=$(( (x1 + x2) / 2 )); cy=$(( (y1 + y2) / 2 ))
  adb shell input tap "$cx" "$cy" >/dev/null 2>&1; sleep 1
  adb shell input keyevent KEYCODE_MOVE_END >/dev/null 2>&1
  local d
  for d in $(seq 1 24); do adb shell input keyevent KEYCODE_DEL >/dev/null 2>&1; done
  adb shell input text "$val" >/dev/null 2>&1; sleep 1
}
lister_champs() { $UI champs > "$OUT/champs.txt" 2>&1 || true; }
idx_de() { grep "^E2E CHAMP " "$OUT/champs.txt" 2>/dev/null \
  | grep -i "$1" | awk '{print $3}' | head -1; }

# ----------------------------------------------------------------- labels ---
case "$LANGUE" in
  fr) CARTE="Français"; ATTENDU_AUTH="Continuer avec Google"; S1="Filme. Vends. C'est tout."
      S2="Filme tes produits, on te guide"; S3="Une vidéo prête à publier en 30 secondes"
      SUIVANT="Suivant"; DEMARRER="Commencer"; SECTEUR_TITRE="Ton activité principale"
      CONTINUER="Continuer"; SANS_CODE="Je n'ai pas de code"; CATALOGUE="Choisissez un modèle de vidéo"
      CHANGE_SECTEUR="Changer de secteur"; BRIEF_TITRE="Décrivez votre publicité"
      AVANT="Avant de commencer"; OK_COMMENCE="OK, je commence"
      FILME="Filme ta prise"; APERCU="Aperçu de ta vidéo"; CREER="Créer ma vidéo"
      EXPORT_START="Lancer l'export local"; EXPORT_RUNNING="Export local en cours"
      EXPORT_PREP="Ta vidéo se prépare"; DONE="Vidéo prête"
      PARTAGER="Partager la vidéo"; ESPACE="Voir mon espace"
      AUTORISER="AUTORISER"; ACCES="Accès caméra nécessaire"; PLUS_TARD="PLUS TARD"
      OFFLINE_BANDE="modèles en cache"
      SECT1="Vêtements"; SECT2="Coiffure"; SECT3="Restauration"; SECT4="Bâtiment"; SECT5="Voitures"; SECT6="Boutique" ;;
  en) CARTE="English"; ATTENDU_AUTH="Continue with Google"; S1="Shoot. Sell. Done."
      S2="Film your products, we guide you"; S3="A video ready to post in 30 seconds"
      SUIVANT="Next"; DEMARRER="Get started"; SECTEUR_TITRE="Your main business"
      CONTINUER="Continue"; SANS_CODE="I don't have a code"; CATALOGUE="Pick a video template"
      CHANGE_SECTEUR="Change sector"; BRIEF_TITRE="Describe your ad"
      AVANT="Before you start"; OK_COMMENCE="OK, I start"
      FILME="Film your take"; APERCU="Preview of your video"; CREER="Create my video"
      EXPORT_START="Start local export"; EXPORT_RUNNING="Local export running"
      EXPORT_PREP="Your video is being prepared"; DONE="Video ready"
      PARTAGER="Share the video"; ESPACE="View my space"
      AUTORISER="ALLOW"; ACCES="Camera access required"; PLUS_TARD="LATER"
      OFFLINE_BANDE="cached templates"
      SECT1="Clothing"; SECT2="Hair"; SECT3="Restaurants"; SECT4="Building"; SECT5="Cars"; SECT6="Shops" ;;
  *) echo "langue non supportée : $LANGUE (FR/EN uniquement)"; exit 2 ;;
esac

# ----------------------------------------------------------------- prélude --
echo "=========== GALERIE $LANGUE / $PROFIL — APK $APK ==========="
adb devices | sed 's/^/E2E /'
# reset d'état : le profil doit partir d'un état propre et reproductible
adb shell settings put system font_scale 1.0 >/dev/null 2>&1 || true
adb shell wm size reset >/dev/null 2>&1 || true
if [ "$PROFIL" = "offline" ]; then
  adb shell svc wifi disable >/dev/null 2>&1 || true
  adb shell svc data disable >/dev/null 2>&1 || true
  sleep 2
fi
adb uninstall "$PKG" >/dev/null 2>&1 || true
if ! adb install -r "$APK" > "$OUT/install.log" 2>&1; then
  echo "INSTALL ÉCHOUÉE :"; tail -3 "$OUT/install.log"; exit 1
fi
sha256sum "$APK" | tee "$OUT/apk_sha256.txt"
if [ "$PROFIL" = "font130" ]; then
  adb shell settings put system font_scale 1.3 >/dev/null 2>&1 || true; sleep 2
fi
if [ "$PROFIL" = "petit" ]; then
  adb shell wm size 720x1520 >/dev/null 2>&1 || true; sleep 2; lire_taille_ecran
fi
if [ "$PROFIL" != "base" ] && [ "$PROFIL" != "offline" ]; then
  # variantes : pas de déroulé permission (état déjà documenté en base)
  adb shell pm grant "$PKG" android.permission.CAMERA >/dev/null 2>&1 || true
fi
adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start.log" 2>&1

# =====================================================================
# 01_accueil — splash + carrousel
# =====================================================================
galshot "splash" "Splash (lancement)" "accueil" "lancement"
sleep 2
galshot "splash_tardif" "Splash (t) — premier plan" "accueil" "lancement"

# 02_langues
if attendre "Choisissez votre langue" "Choose your language"; then
  galshot "langue" "Écran de choix de langue" "langues" "initial"
else
  gap "écran langue non atteint (session déjà active ?)"
fi
ok=0
for essai in 1 2 3; do
  taper "$CARTE" exact
  if attendre "$ATTENDU_AUTH"; then ok=1; break; fi
done
[ "$ok" = "1" ] || gap "sélection langue sans effet sur l'écran auth"

# 03_authentification — écran Google + repli local
if attendre "$ATTENDU_AUTH"; then
  galshot "auth" "Connexion — bouton Google" "authentification" "non connecté"
  if [ "$LANGUE" = "fr" ] && [ "$PROFIL" = "base" ]; then
    # feuille Credential Manager (annulée aussitôt : aucune vraie donnée)
    taper "$ATTENDU_AUTH" exact && sleep 4
    galshot "auth_feuille_google" "Feuille système Google (aucun compte réel)" "authentification" "feuille ouverte"
    adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
  fi
else
  gap "écran auth non atteint"
fi
ok=0
for essai in 1 2 3 4 5; do
  $UI tap --id "auth_offline_button" --timeout 10 >/dev/null 2>&1
  if attendre "$S1"; then ok=1; break; fi
  sleep 4
done
if [ "$ok" = "1" ]; then
  galshot "carrousel_1" "Carrousel — $S1" "accueil" "repli sans compte"
else
  gap "repli sans compte sans effet (carrousel absent)"
fi
taper "$SUIVANT" exact
if attendre "$S2"; then galshot "carrousel_2" "Carrousel — $S2" "accueil" "slide 2"; fi
taper "$SUIVANT" exact
if attendre "$S3"; then galshot "carrousel_3" "Carrousel — $S3" "accueil" "slide 3"; fi
taper "$DEMARRER" exact

# 06_secteurs — écran d'activité
if attendre "$SECTEUR_TITRE"; then
  galshot "secteurs" "Choix du secteur (activité principale)" "secteurs" "initial"
  swipe_v 70 30 300; sleep 1
  galshot "secteurs_bas" "Choix du secteur — bas de liste" "secteurs" "défilé"
  swipe_v 30 70 300; sleep 1
else
  gap "écran secteurs non atteint"
fi
taper "$SECT6" ; sleep 1 ; taper "$CONTINUER" exact

# 04_parrainage — écran code (vide puis saisie fictive)
if attendre "$SANS_CODE"; then
  galshot "parrainage" "Étape parrainage — saisie du code" "parrainage" "vide"
  taper "$SANS_CODE" exact
else
  gap "étape parrainage non atteinte (continuation directe)"
fi

# 05_credits — écran de bienvenue / confirmation des crédits
sleep 2
if attendre "Bienvenue" "Welcome" "crédits" "credits"; then
  galshot "credits_bienvenue" "Bienvenue — confirmation des crédits" "credits" "connecté-local"
  taper "$CONTINUER" exact
  sleep 2
fi
# écran intermédiaire éventuel : boucler jusqu'au catalogue
okcat=0
for _ in 1 2 3; do
  if attendre "$CATALOGUE"; then okcat=1; break; fi
  taper "$CONTINUER" exact; sleep 2
done

# =====================================================================
# 07_catalogue + 08_gabarits — 30 gabarits, 6 secteurs
# =====================================================================
if [ "$okcat" = "1" ]; then
  galshot "catalogue_haut" "Catalogue — haut (secteur sélectionné)" "catalogue" "initial"
  # défilement complet : chaque gabarit doit être visible/identifiable
  n_scroll=0
  while [ "$n_scroll" -lt 8 ]; do
    swipe_v 72 28 350; sleep 1; n_scroll=$((n_scroll+1))
    galshot "catalogue_scroll${n_scroll}" "Catalogue — position ${n_scroll}" "catalogue" "défilé"
    # arrêt quand le défilement n'évolue plus (bas atteint)
    if ! adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1; then break; fi
    adb exec-out cat /sdcard/d.xml > "$OUT/_cat_${n_scroll}.xml" 2>/dev/null
    if [ -s "$OUT/_cat_$((n_scroll-1)).xml" ] && cmp -s "$OUT/_cat_${n_scroll}.xml" "$OUT/_cat_$((n_scroll-1)).xml" 2>/dev/null; then
      break
    fi
  done
  # 06_secteurs — changer de secteur : couvrir les 6 secteurs (base fr uniquement)
  if [ "$PROFIL" = "base" ] && [ "$LANGUE" = "fr" ]; then
    for s in 1 2 3 4 5 6; do
      case "$s" in
        1) S="$SECT1";; 2) S="$SECT2";; 3) S="$SECT3";; 4) S="$SECT4";; 5) S="$SECT5";; 6) S="$SECT6";;
      esac
      if ! taper "$CHANGE_SECTEUR"; then gap "bouton « $CHANGE_SECTEUR » introuvable (itération $s)"; break; fi
      sleep 2
      galshot "secteur_change_${s}" "Sélecteur de secteur (itération $s)" "secteurs" "changement"
      if taper "$S"; then
        sleep 2
        if attendre "$CATALOGUE"; then
          galshot "catalogue_secteur${s}" "Catalogue — secteur « $S » (haut)" "catalogue" "secteur $s"
          k=0
          while [ "$k" -lt 5 ]; do
            swipe_v 72 28 350; sleep 1; k=$((k+1))
            galshot "catalogue_secteur${s}_scroll${k}" "Catalogue — secteur « $S », position $k" "catalogue" "secteur $s, défilé"
            if ! adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1; then break; fi
            adb exec-out cat /sdcard/d.xml > "$OUT/_cs_${s}_${k}.xml" 2>/dev/null
            if [ -s "$OUT/_cs_${s}_$((k-1)).xml" ] && cmp -s "$OUT/_cs_${s}_${k}.xml" "$OUT/_cs_${s}_$((k-1)).xml" 2>/dev/null; then
              break
            fi
          done
        else
          gap "catalogue du secteur « $S » non atteint"
        fi
      else
        gap "secteur « $S » introuvable au sélecteur"
        adb shell input keyevent 4 >/dev/null 2>&1; sleep 1
        attendre "$CATALOGUE" || true
      fi
    done
    # revenir au secteur Boutique & Petit Commerce pour la suite du parcours
    taper "$CHANGE_SECTEUR"; sleep 2; taper "$SECT6"; sleep 2; attendre "$CATALOGUE" || true
  fi
else
  gap "catalogue non atteint"
fi

# 09_brief — sélection gabarit « Nouvel arrivage »
if taper "Nouvel arrivage" || taper "New Arrivals"; then
  sleep 2
else
  gap "gabarit « Nouvel arrivage » introuvable — tap premier gabarit"
  swipe_v 30 70 300 >/dev/null 2>&1; sleep 1
  adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1
  adb exec-out cat /sdcard/d.xml > "$OUT/_cata.xml" 2>/dev/null
  # repli : taper la première carte contenant un libellé de style connu
  taper "Arrivage" || taper "Nouveautés" || taper "Présentation" || taper "Promo" || true
  sleep 2
fi
WT=30
if attendre "Décrivez votre publicité" "Describe your ad" "WhatsApp number" "Numéro WhatsApp"; then
  galshot "brief_vide" "Formulaire de brief — vide (Continuer désactivé)" "brief" "vide"
else
  gap "écran brief non atteint"
fi
WT=20

# 10_formulaires — remplissage fictif + clavier + erreurs
lister_champs
I_WA=$(idx_de "whatsapp"); I_PX=$(idx_de "Prix")
I_VET=$(idx_de "vêtement"); I_QT=$(idx_de "Quartier"); I_CO=$(idx_de "commerce")
if [ -n "$I_WA" ]; then
  remplir "$I_WA" "0197000000"
  galshot "brief_whatsapp_clavier" "Champ WhatsApp — clavier ouvert" "formulaires" "clavier ouvert"
  fermer_clavier
fi
if [ -n "$I_PX" ]; then
  remplir "$I_PX" "15000"
  galshot "brief_prix_clavier" "Champ prix — clavier ouvert" "formulaires" "clavier ouvert"
  fermer_clavier
fi
for iv in "$I_VET" "$I_QT" "$I_CO"; do
  [ -n "$iv" ] || continue
  case "$iv" in
    "$I_VET") remplir "$iv" "RobeWax";;
    "$I_QT")  remplir "$iv" "Akpakpa";;
    "$I_CO")  remplir "$iv" "BoutiqueAwa";;
  esac
done
fermer_clavier
galshot "brief_rempli" "Formulaire de brief — rempli (valeurs fictives)" "brief" "rempli"

# états d'erreur (l'application refuse à juste titre — preuve visuelle)
if [ -n "$I_WA" ]; then
  remplir "$I_WA" "019700000"
  sleep 1
  galshot "brief_erreur_whatsapp" "Erreur de validation du numéro (9 chiffres)" "formulaires" "erreur"
  remplir "$I_WA" "0197000000"
fi
if [ -n "$I_PX" ]; then
  remplir "$I_PX" "abc"
  sleep 1
  galshot "brief_erreur_prix" "Erreur de validation du prix (alphabétique)" "formulaires" "erreur"
  remplir "$I_PX" "15000"
fi
fermer_clavier
# contrôle d'intégrité léger : si l'app affiche une erreur, re-saisir whatsapp
adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1
adb exec-out cat /sdcard/d.xml > "$OUT/_verif_brief.xml" 2>/dev/null
if grep -q "n.est pas valide" "$OUT/_verif_brief.xml" 2>/dev/null; then
  [ -n "$I_WA" ] && remplir "$I_WA" "0197000000"
  fermer_clavier
fi
galshot "brief_final" "Formulaire de brief — état final avant validation" "brief" "prêt"

# 11_verification — ReadyCheck
# bouton en bas d'écran défilant : descendre par pas jusqu'à Continuer
revele=0
for _ in 1 2 3 4 5 6 7 8; do
  if $UI wait --text "$CONTINUER" --exact --timeout 3 >/dev/null 2>&1; then revele=1; break; fi
  swipe_v 73 26 250; sleep 1
done
if [ "$revele" = "1" ]; then
  taper "$CONTINUER" exact
  WT=25
  if attendre "$AVANT"; then
    galshot "verification" "Écran de vérification (avant de commencer)" "verification" "récapitulatif"
    swipe_v 72 30 300; sleep 1
    galshot "verification_bas" "Vérification — bas de l'écran" "verification" "défilé"
    swipe_v 30 72 300; sleep 1
  else
    gap "écran de vérification non atteint après Continuer"
  fi
  WT=20
else
  gap "bouton Continuer du brief jamais révélé"
fi

# =====================================================================
# 12_camera + 13_prises — permission, preview, countdown, REC, flip, reprise
# =====================================================================
taper "$OK_COMMENCE" exact
WT=40
if attendre "$FILME"; then
  galshot "camera_guide" "Guide de tournage (consignes)" "camera" "guide"
fi
WT=20
sleep 2
# --- dialogue système de permission (base uniquement : pas de pm grant) ----
if [ "$PROFIL" = "base" ]; then
  if focus_dans "permissioncontroller"; then
    galshot "camera_permission_dialogue" "Dialogue système de permission caméra" "camera" "permission demandée"
    adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
    galshot "camera_permission_refusee" "Caméra — permission refusée" "camera" "permission refusée"
    if attendre "$ACCES"; then
      galshot "camera_dialogue_produit" "Dialogue produit « accès caméra nécessaire »" "camera" "rationale"
      taper "$AUTORISER" exact; sleep 3
      if focus_dans "permissioncontroller"; then
        galshot "camera_permission_dialogue_2" "Dialogue système (2e demande)" "camera" "permission redemandée"
      fi
    fi
    # octroi effectif par pm grant (le dialogue système n'est pas tapable via
    # uiautomator sur cette image) puis retour au guide via le brouillon
    adb shell pm grant "$PKG" android.permission.CAMERA >/dev/null 2>&1 || true
    adb shell input keyevent 4 >/dev/null 2>&1; sleep 1
    taper "$PLUS_TARD" || true
    sleep 1
    adb shell am start -n "$PKG/.MainActivity" >/dev/null 2>&1; sleep 4
    # le brouillon CAMÉRA est repris automatiquement
  fi
fi
WT=30
ok_cam=0
for _ in 1 2 3; do
  if $UI wait --id "camera_record_button" --timeout 25 >/dev/null 2>&1; then ok_cam=1; break; fi
  taper "$AUTORISER" exact || true; sleep 2
done
WT=20
if [ "$ok_cam" = "1" ]; then
  sleep 2
  galshot "camera_preview" "Viseur caméra — PreviewView (flux ÉMULÉ de l'émulateur)" "camera" "preview streaming"
  # countdown 3-2-1 : rafale juste après le tap
  $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1
  galshot "camera_countdown_a" "Compte à rebours (capture rapprochée a)" "prises" "countdown"
  sleep 1
  galshot "camera_countdown_b" "Compte à rebours (capture b)" "prises" "countdown"
  sleep 2
  galshot "camera_rec" "Enregistrement ACTIF — badge REC" "prises" "rec"
  sleep 2
  # arrêt
  $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1
  sleep 2
  galshot "camera_arret" "Arrêt de la prise — finalisation" "prises" "arrêt"
  # bascule caméra avant/arrière
  if $UI tap --id "camera_flip_button" --timeout 8 >/dev/null 2>&1; then
    sleep 2
    galshot "camera_avant" "Caméra AVANT (flux émulé) après bascule" "prises" "bascule avant"
    $UI tap --id "camera_flip_button" --timeout 8 >/dev/null 2>&1; sleep 2
    galshot "camera_arriere" "Retour caméra ARRIÈRE (flux émulé)" "prises" "bascule retour"
  else
    gap "bouton de bascule caméra introuvable"
  fi
  # reprise d'une prise (Refaire)
  if $UI tap --id "camera_redo_button" --timeout 8 >/dev/null 2>&1; then
    sleep 2
    galshot "camera_refaire" "Reprise d'une prise (Refaire)" "prises" "reprise"
    $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1
    sleep 5
    $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1
    sleep 2
  else
    gap "bouton Refaire introuvable (état avant enregistrement ?)"
  fi
  # scène suivante, puis 2e prise complète
  if $UI tap --id "camera_next_button" --timeout 8 >/dev/null 2>&1; then
    sleep 2
    galshot "camera_scene2" "Scène suivante du guide" "prises" "scène 2"
    $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1
    sleep 6
    $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1
    sleep 2
    galshot "camera_scene2_fin" "Fin de la 2e prise" "prises" "scène 2 terminée"
    $UI tap --id "camera_next_button" --timeout 8 >/dev/null 2>&1 || true
    sleep 3
  else
    gap "bouton Suivant (caméra) introuvable"
  fi
else
  gap "écran caméra non atteint (bouton enregistrement absent)"
fi

# =====================================================================
# 14/15 — audio (mode automatique) + aperçu E7 + montage
# =====================================================================
WT=60
if attendre "$APERCU"; then
  galshot "apercu" "Aperçu de la vidéo (E7) — mode audio automatique" "montage" "aperçu"
  swipe_v 72 30 300; sleep 1
  galshot "apercu_bas" "Aperçu — bas (typographie, voix)" "audio" "détail"
  swipe_v 30 72 300; sleep 1
fi
WT=20
# révéler « Créer ma vidéo » (bouton bas d'écran défilant)
for _ in 1 2 3 4 5 6; do
  if $UI wait --text "$CREER" --exact --timeout 3 >/dev/null 2>&1; then break; fi
  swipe_v 73 26 250; sleep 1
done
taper "$CREER" exact

# =====================================================================
# 16_export — E8 : lancement, notification FGS, écran éteint, terminé
# =====================================================================
WT=40
if attendre "$EXPORT_START" "$EXPORT_RUNNING" "$EXPORT_PREP"; then
  galshot "export_pret" "Écran d'export (E8) — avant lancement" "export" "prêt"
  taper "$EXPORT_START" exact
  sleep 3
  if attendre "$EXPORT_RUNNING" "$EXPORT_PREP"; then
    galshot "export_en_cours" "Export local en cours" "export" "en cours"
  fi
  # notification FGS (tiroir de notifications)
  adb shell cmd statusbar expand-notifications >/dev/null 2>&1; sleep 2
  galshot "export_notification" "Tiroir de notifications — export (FGS)" "export" "notification"
  adb shell cmd statusbar collapse >/dev/null 2>&1; sleep 1
  # écran éteint 8 s puis réveil (l'export continue)
  adb shell input keyevent 26 >/dev/null 2>&1; sleep 8
  adb shell input keyevent 26 >/dev/null 2>&1; sleep 2
  adb shell input keyevent 224 >/dev/null 2>&1; sleep 1
  adb shell input keyevent 82 >/dev/null 2>&1; sleep 2
  galshot "export_apres_ecran_etaint" "Export après écran éteint (réveil)" "export" "écran éteint survécu"
else
  gap "écran d'export non atteint"
fi
# attente de la fin (l'émulateur swiftshader encode lentement)
WT=5700
if attendre "$DONE"; then
  galshot "export_termine" "« $DONE » — export terminé" "export" "terminé"
  WT=20
  # 18_partage — feuille système
  if taper "$PARTAGER" exact; then
    sleep 3
    galshot "partage_feuille" "Feuille de partage Android (cible système)" "partage" "feuille ouverte"
    adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
  else
    gap "bouton « $PARTAGER » introuvable"
  fi
  # 17_historique + 19_profil — espace / dashboard
  if taper "$ESPACE" exact; then
    sleep 3
    galshot "dashboard" "Mon espace — tableau de bord" "historique" "connecté-local"
    galshot "profil_dashboard" "Tableau de bord — en-tête et cartes" "profil" "vue complète"
    # carte parrainage
    if taper "Parrainage" || taper "parrainage" || taper "Referral"; then
      sleep 3
      galshot "dashboard_parrainage" "Parrainage — jauge et code" "parrainage" "depuis dashboard"
      adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
    fi
    # réglages / profil
    if taper "Réglages" || taper "Paramètres" || taper "Settings"; then
      sleep 3
      galshot "profil_reglages" "Réglages / profil" "profil" "ouvert"
      adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
    fi
    # paywall (crédits) via la carte crédits si présente
    if taper "crédits" || taper "Crédits" || taper "Recharger" || taper "Buy"; then
      sleep 3
      galshot "paywall" "Crédits / recharge (paywall)" "credits" "offre"
      adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
    fi
  else
    gap "bouton « $ESPACE » introuvable — dashboard non capturé via ce chemin"
  fi
else
  gap "export non terminé dans le délai (capture manquante : écran terminé)"
fi
WT=20

# =====================================================================
# 20_hors_connexion (profil offline dédié) — états déconnectés
# =====================================================================
if [ "$PROFIL" = "offline" ]; then
  # au moment où l'on arrive ici, tout le parcours a été fait hors connexion :
  # les états online de référence ont été capturés par le profil base.
  galshot "offline_recap_dashboard" "État hors connexion — écran final" "hors_connexion" "hors connexion"
fi

# ---------------------------------------------------------------- épilogue --
if [ "$PROFIL" = "offline" ]; then
  adb shell svc wifi enable >/dev/null 2>&1 || true
  adb shell svc data enable >/dev/null 2>&1 || true
fi
adb shell wm size reset >/dev/null 2>&1 || true
adb shell settings put system font_scale 1.0 >/dev/null 2>&1 || true
cp /dev/null "$OUT/logcat_gallery.txt" 2>/dev/null || true
adb logcat -d > "$OUT/logcat_gallery.txt" 2>/dev/null || true
echo "=========== GALERIE $LANGUE / $PROFIL : $ORDRE captures, $(wc -l < "$GAPS") gaps ==========="
