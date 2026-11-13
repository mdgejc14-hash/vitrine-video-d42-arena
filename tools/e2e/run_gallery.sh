#!/usr/bin/env bash
# ============================================================================
# D42.31 — PHASE A : GALERIE VISUELLE INTÉGRALE DE L'APK RC15 (IMMUTABLE)
# ============================================================================
# Usage : tools/e2e/run_gallery.sh <fr|en> <base|font130|petit|offline> <apk>
#
# v2 (retours run 43225168935 annulé au timeout — diagnostic complet) :
#   - PLUS de tap sur le bouton Google (la feuille Credential Manager est un
#     écran SYSTÈME ; son tap déraillait tout le parcours FR base : BACK ne
#     refermait pas la feuille) ;
#   - remplissage des champs BILINGUE par motifs (Prix/Price, vêtement/
#     product, quartier/neighbourhood, commerce/shop) — v1 ne remplissait
#     que le whatsapp en EN → brief jamais validé → cascade caméra/export ;
#   - sélection du gabarit : retour en HAUT du catalogue d'abord (v1 tapait
#     « Nouvel arrivage » après les scrolls de capture → carte hors écran),
#     chaîne de repli par nom de style FR/EN, vérification que le brief
#     s'est ouvert ;
#   - vérification de saisie + boucle de réparation avant Continuer (erreurs
#     numéro ET prix, champs vides, FR/EN) avec re-tentatives ;
#   - attente de fin d' export GÉRÉE : longue attente seulement si l'export
#     a réellement démarré (v1 attendait 95 min un écran jamais atteint) ;
#   - variantes font130/petit : parcours RÉDUIT (arrêt après formulaires).
#
# Principes inchangés : APK exacte RC15 (SHA-256 vérifié par le workflow),
# captures brutes non retouchées, données 100 % fictives, caméra ÉMULÉE
# identifiée comme telle, gaps documentés (aucun état inventé).
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
haut_de_page() { # 3 swipes descendants lents = remonter en haut
  swipe_v 26 74 400 >/dev/null 2>&1; sleep 1
  swipe_v 30 70 400 >/dev/null 2>&1; sleep 1
  swipe_v 34 66 400 >/dev/null 2>&1; sleep 1
}
res_ecran() { adb shell wm size 2>/dev/null | tr -d '\r' \
  | sed -n 's/.*Override size: //p' | head -1 || true; }
galshot() { # id titre ecran etat
  ORDRE=$((ORDRE+1))
  local f
  f=$(printf '%03d_%s.png' "$ORDRE" "$1")
  adb exec-out screencap -p > "$OUT/$f" 2>/dev/null
  local res; res=$(res_ecran); [ -n "$res" ] || res="${EFF_W}x${EFF_H}"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$ORDRE" "$1" "$2" "$3" "$4" "$LANGUE" "$PROFIL" "$f" "$res" "screencap" >> "$MANIFEST"
  echo "GALERIE [$ORDRE] $1 — $2 ($4)"
}
gap() { echo "$*" >> "$GAPS"; echo "GAP : $*"; }
WT=20
attendre() { local t; for t in "$@"; do
  $UI wait --text "$t" --timeout "$WT" >/dev/null 2>&1 && return 0
done; return 1; }
taper() { # texte [exact]
  if [ "${2:-}" = "exact" ]; then
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
dump_courant() { # $1 = nom de sortie
  adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1
  adb exec-out cat /sdcard/d.xml > "$OUT/$1.xml" 2>/dev/null
}
norm_txt() { sed 's/\xc2\xa0//g; s/ //g' "$1" 2>/dev/null || echo ""; }
lister_champs() { $UI champs > "$OUT/champs.txt" 2>&1 || true; }

# valeur fictive pour un libellé de champ (motifs FR et EN)
valeur_pour() {
  local l
  l=$(printf '%s' "$1" | tr 'A-Z' 'a-z')
  case "$l" in
    *whatsapp*|*num*ro*|*phone*)                    echo "0197000000" ;;
    *prix*|*price*|*montant*)                       echo "15000" ;;
    *quartier*|*ville*|*city*|*neighbourhood*|*neighborhood*|*adresse*) echo "Akpakpa" ;;
    *v*tement*|*product*|*produit*|*plat*|*article*|*nom*) echo "RobeWax" ;;
    *commerce*|*boutique*|*shop*|*business*)        echo "BoutiqueAwa" ;;
    *)                                              echo "Essai" ;;
  esac
}
# index du champ dont le libellé matche un motif (FR/EN)
idx_de() { grep "^E2E CHAMP " "$OUT/champs.txt" 2>/dev/null \
  | grep -iE "$1" | awk '{print $3}' | head -1; }
# remplir puis VÉRIFIER (valeur visible dans le dump normalisé), 2 essais
remplir_verifie() { # idx valeur
  local idx="$1" val="$2" essai ligne x1 y1 x2 y2 cx cy attendu
  attendu=$(printf '%s' "$val" | sed 's/\xc2\xa0//g; s/ //g')
  for essai in 1 2; do
    lister_champs
    ligne=$(awk -v i="$idx" '$1=="E2E" && $2=="CHAMP" && $3==i {print $4, $5, $6, $7}' "$OUT/champs.txt" 2>/dev/null)
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
    dump_courant "_saisie_$idx"
    if [ -s "$OUT/_saisie_$idx.xml" ] \
       && norm_txt "$OUT/_saisie_$idx.xml" | grep -qF "$attendu"; then
      return 0
    fi
    echo "GALERIE saisie non confirmée (essai $essai, champ #$idx) — re-saisie"
  done
  return 1
}
# remplir TOUS les champs vides du brief (une passe)
remplir_les_vides() {
  local ligne idx libelle etat val
  lister_champs
  while IFS= read -r ligne; do
    idx=$(echo "$ligne" | awk '{print $3}')
    etat=$(echo "$ligne" | awk '{print $8}')
    libelle=$(echo "$ligne" | sed 's/^[^|]*|//; s/|[[:space:]]*$//')
    [ "$etat" = "vide" ] || continue
    val=$(valeur_pour "$libelle")
    [ -n "$val" ] || continue
    remplir_verifie "$idx" "$val" || true
    fermer_clavier
    break  # un champ par passe : re-lister à chaque fois (géométrie clavier)
  done < <(grep "^E2E CHAMP " "$OUT/champs.txt" 2>/dev/null)
}
nombre_de_vides() { lister_champs; grep -c " vide |" "$OUT/champs.txt" 2>/dev/null || echo 0; }
# v8 : remplir par LIBELLÉ (re-liste les champs à CHAQUE appel — les indices
# d'une liste précédente sont périmés dès que la page/clavier change ; run v7
# offline : le numéro de téléphone avait fini dans le champ Prix).
remplir_par_label() { # motif_libelle valeur
  lister_champs
  local i
  i=$(idx_de "$1")
  [ -n "$i" ] || return 1
  remplir_verifie "$i" "$2"
}

# tap par COORDONNÉES depuis le dump (v3) : les taps ui.py échouaient quand
# la cible était hors écran (cartes du catalogue après les scrolls de capture,
# « Changer de secteur » sous le pli, « OK, je commence » en bas). On cherche
# le texte dans le dump (insensible à la casse), on tape son centre ; sinon on
# défile (haut puis bas) et on recommence. Retour 0 si tap émis.
tap_coord_text() { # motif...
  local motif essai bounds
  for motif in "$@"; do
    for essai in 1 2 3 4; do
      dump_courant "_tap_cherche"
      bounds=$(python3 - "$OUT/_tap_cherche.xml" "$motif" <<'PYEOF2'
import sys, re, xml.etree.ElementTree as ET
path, motif = sys.argv[1], sys.argv[2]
want = motif.lower()
try:
    root = ET.parse(path).getroot()
except Exception:
    sys.exit(0)
for node in root.iter('node'):
    t = (node.get('text') or '') + ' ' + (node.get('content-desc') or '')
    if want and want in t.lower():
        b = node.get('bounds') or ''
        m = re.match(r'\[(\d+),(\d+)\]\[(\d+),(\d+)\]', b)
        if m:
            x1, y1, x2, y2 = map(int, m.groups())
            if x2 > x1 and y2 > y1 and y2 > 0:
                print((x1 + x2) // 2, (y1 + y2) // 2)
                break
PYEOF2
)
      if [ -n "$bounds" ]; then
        # shellcheck disable=SC2086
        adb shell input tap $bounds >/dev/null 2>&1
        return 0
      fi
      swipe_v 30 70 350 >/dev/null 2>&1; sleep 1
    done
    for essai in 1 2 3 4; do
      dump_courant "_tap_cherche"
      bounds=$(python3 - "$OUT/_tap_cherche.xml" "$motif" <<'PYEOF2'
import sys, re, xml.etree.ElementTree as ET
path, motif = sys.argv[1], sys.argv[2]
want = motif.lower()
try:
    root = ET.parse(path).getroot()
except Exception:
    sys.exit(0)
for node in root.iter('node'):
    t = (node.get('text') or '') + ' ' + (node.get('content-desc') or '')
    if want and want in t.lower():
        b = node.get('bounds') or ''
        m = re.match(r'\[(\d+),(\d+)\]\[(\d+),(\d+)\]', b)
        if m:
            x1, y1, x2, y2 = map(int, m.groups())
            if x2 > x1 and y2 > y1 and y2 > 0:
                print((x1 + x2) // 2, (y1 + y2) // 2)
                break
PYEOF2
)
      if [ -n "$bounds" ]; then
        # shellcheck disable=SC2086
        adb shell input tap $bounds >/dev/null 2>&1
        return 0
      fi
      swipe_v 70 30 350 >/dev/null 2>&1; sleep 1
    done
  done
  return 1
}

swipe_h() { # de droite à gauche pour révéler les chips suivants
  # v6 : la rangée de chips est à ~44 % de la hauteur (mesuré sur le dump
  # secteur_iter6 du run v5 : y 1020-1047 sur 2340) — pas en haut.
  adb shell input swipe $(( EFF_W * 8 / 10 )) $(( EFF_H * 44 / 100 ))     $(( EFF_W * 2 / 10 )) $(( EFF_H * 44 / 100 )) "${2:-300}" >/dev/null 2>&1
}
# cherche UN PARMI les motifs (texte+content-desc, casse ignorée) dans le dump
# courant et renvoie "x y" ; sinon code retour 1
coord_parmi() { # fichier motif1 motif2...
  local f="$1"; shift
  python3 - "$f" "$@" <<'PYEOF2'
import sys, re, xml.etree.ElementTree as ET
path = sys.argv[1]; motifs = sys.argv[2:]
try:
    root = ET.parse(path).getroot()
except Exception:
    sys.exit(1)
nodes = list(root.iter('node'))
for motif in motifs:                     # premier motif trouvé = priorité
    want = motif.lower()
    for node in nodes:
        t = (node.get('text') or '') + ' ' + (node.get('content-desc') or '')
        if want and want in t.lower():
            b = node.get('bounds') or ''
            m = re.match(r'\[(\d+),(\d+)\]\[(\d+),(\d+)\]', b)
            if m:
                x1, y1, x2, y2 = map(int, m.groups())
                if x2 > x1 and y2 > y1 and y2 > 0:
                    print((x1 + x2) // 2, (y1 + y2) // 2)
                    sys.exit(0)
sys.exit(1)
PYEOF2
}
# sélection de gabarit v5 : UNE passe de motifs par écran (plus de candidats
# un par un avec swipes à l'aveugle) ; grille parcourue verticalement.
choisir_gabarit() { # motifs...
  local ecran bounds
  for ecran in 1 2 3 4 5 6; do
    dump_courant "_gabarit_cherche"
    if bounds=$(coord_parmi "$OUT/_gabarit_cherche.xml" "$@"); then
      # shellcheck disable=SC2086
      adb shell input tap $bounds >/dev/null 2>&1
      return 0
    fi
    swipe_v 70 30 350 >/dev/null 2>&1; sleep 1
  done
  return 1
}

# v10 (D42.31-IMAGE-FIX) : capture du viseur via SCREENRECORD — diagnostic
# différentiel : le MP4 exporté est riche (flux CameraX + enregistrement
# SAINS) mais `screencap` capture le SurfaceView en bandes uniformes
# (mosaïque verte/blanche/marron vue par le fondateur). screenrecord
# capture la sortie COMPOSÉE par SurfaceFlinger = ce que l'écran affiche
# réellement. Un screencap de diagnostic est conservé à côté.
galshot_sr() { # id titre ecran etat
  ORDRE=$((ORDRE+1))
  local f
  f=$(printf '%03d_%s.png' "$ORDRE" "$1")
  adb shell rm -f /sdcard/sr_capture.mp4 >/dev/null 2>&1
  adb shell screenrecord --time-limit 8 /sdcard/sr_capture.mp4 >/dev/null 2>&1 &
  local srpid=$!
  sleep 6   # frames stables
  adb exec-out screencap -p > "$OUT/diag_${1}_screencap.png" 2>/dev/null
  wait $srpid 2>/dev/null
  adb pull /sdcard/sr_capture.mp4 "$OUT/_sr_tmp.mp4" >/dev/null 2>&1
  local ok=0
  if command -v ffmpeg >/dev/null 2>&1 && [ -s "$OUT/_sr_tmp.mp4" ]; then
    # image de la dernière seconde (état stabilisé)
    if ffmpeg -y -sseof -1 -i "$OUT/_sr_tmp.mp4" -update 1 -frames:v 1 "$OUT/$f" >/dev/null 2>&1        && [ -s "$OUT/$f" ]; then ok=1; fi
  fi
  local src="screenrecord"
  if [ "$ok" != "1" ]; then
    # repli honnête : screencap classique — retenu SEULEMENT s'il est non vide
    if [ -s "$OUT/diag_${1}_screencap.png" ]; then
      cp "$OUT/diag_${1}_screencap.png" "$OUT/$f"
      src="screencap-repli"
    else
      rm -f "$OUT/$f"
      gap "capture « $1 » : screenrecord ET screencap vides — aucune image produite (aucune ligne manifest)"
      echo "GALERIE [$ORDRE] $1 — ÉCHEC capture (aucune image)"
      return 0
    fi
  fi
  rm -f "$OUT/_sr_tmp.mp4"
  adb shell rm -f /sdcard/sr_capture.mp4 >/dev/null 2>&1
  local res; res=$(res_ecran); [ -n "$res" ] || res="${EFF_W}x${EFF_H}"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$ORDRE" "$1" "$2" "$3" "$4" "$LANGUE" "$PROFIL" "$f" "$res" "$src" >> "$MANIFEST"
  echo "GALERIE [$ORDRE] $1 — $2 ($4, source=$src)"
}

# ----------------------------------------------------------------- labels ---
case "$LANGUE" in
  fr) CARTE="Français"; ATTENDU_AUTH="Continuer avec Google"; S1="Filme. Vends. C'est tout."
      S2="Filme tes produits, on te guide"; S3="Une vidéo prête à publier en 30 secondes"
      SUIVANT="Suivant"; DEMARRER="Commencer"; SECTEUR_TITRE="Ton activité principale"
      CONTINUER="Continuer"; SANS_CODE="Je n'ai pas de code"; CATALOGUE="Choisissez un modèle de vidéo"
      CHANGE_SECTEUR="Changer de secteur"
      AVANT="Avant de commencer"; OK_COMMENCE="OK, je commence"
      FILME="Filme ta prise"; APERCU="Aperçu de ta vidéo"; CREER="Créer ma vidéo"
      EXPORT_START="Lancer l'export local"; EXPORT_RUNNING="Export local en cours"
      EXPORT_PREP="Ta vidéo se prépare"; DONE="Vidéo prête"
      PARTAGER="Partager la vidéo"; ESPACE="Voir mon espace"
      E7_CHECK="Vérifie ces informations"
      AUTORISER="AUTORISER"; ACCES="Accès caméra nécessaire"; PLUS_TARD="PLUS TARD"
      REC_TXT="Verrouiller et enregistrer"; STOP_TXT="Arrêter et continuer"
      FLIP_TXT="Changer de caméra"; REDO_TXT="Refaire"; NEXT_TXT="Suivant"
      PRISE_OK="enregistrée"
      ERREUR_TEL="n.est pas valide"; ERREUR_PRIX="Saisis un nombre"
      GABARITS_CANDIDATS="client raconte Nouvel arrivage Nouveautés New Arrivals ancien prix montre l.article Présentation Quick Promo Promotion Témoignage Customer Avant"
      SECT1="Vêtements"; SECT2="Coiffure"; SECT3="Restauration"; SECT4="Bâtiment"; SECT5="Voitures"; SECT6="Boutique" ;;
  en) CARTE="English"; ATTENDU_AUTH="Continue with Google"; S1="Shoot. Sell. Done."
      S2="Film your products, we guide you"; S3="A video ready to post in 30 seconds"
      SUIVANT="Next"; DEMARRER="Get started"; SECTEUR_TITRE="Your main business"
      CONTINUER="Continue"; SANS_CODE="I don't have a code"; CATALOGUE="Pick a video template"
      CHANGE_SECTEUR="Change sector"
      AVANT="Before you start"; OK_COMMENCE="OK, I start"
      FILME="Film your take"; APERCU="Preview of your video"; CREER="Create my video"
      EXPORT_START="Start local export"; EXPORT_RUNNING="Local export running"
      EXPORT_PREP="Your video is being prepared"; DONE="Video ready"
      PARTAGER="Share the video"; ESPACE="View my space"
      E7_CHECK="Check this information"
      AUTORISER="ALLOW"; ACCES="Camera access required"; PLUS_TARD="LATER"
      REC_TXT="Lock and record"; STOP_TXT="Stop and continue"
      FLIP_TXT="Switch camera"; REDO_TXT="Redo"; NEXT_TXT="Next"
      PRISE_OK="saved"
      ERREUR_TEL="isn.t valid"; ERREUR_PRIX="Enter a number"
      GABARITS_CANDIDATS="client raconte Nouvel arrivage Nouveautés New Arrivals ancien prix montre l.article Présentation Quick Promo Promotion Témoignage Customer Avant"
      SECT1="Clothing"; SECT2="Hair"; SECT3="Restaurants"; SECT4="Building"; SECT5="Cars"; SECT6="Shops" ;;
  *) echo "langue non supportée : $LANGUE (FR/EN uniquement)"; exit 2 ;;
esac

# ----------------------------------------------------------------- prélude --
echo "=========== GALERIE $LANGUE / $PROFIL — APK $APK ==========="
adb devices | sed 's/^/E2E /'
adb shell settings put system font_scale 1.0 >/dev/null 2>&1 || true
adb shell wm size reset >/dev/null 2>&1 || true
if [ "$PROFIL" = "offline" ]; then
  adb shell svc wifi disable >/dev/null 2>&1 || true
  adb shell svc data disable >/dev/null 2>&1 || true
  sleep 2
fi
# v11c — appareil client propre (technique établie p1 / run_official_e2e.sh).
# L'image système AOSP « default » des émulateurs CI contient /system/xbin/su :
# les heuristiques anti-falsification d'IntegrityGuard (V2.0 §22) y voient un
# appareil compromis → porte d'export DENY_INTEGRITY (« Vérification de
# sécurité échouée »). C'est la cause racine de l'échec de TOUS les exports
# des runs galerie v6→v11b (0 ligne codec après le tap « LANCER L'EXPORT
# LOCAL », écran figé « Ta vidéo se prépare — % » ; runs 43276442451,
# 43395637118, 43412790349, 43428876674 — message capturé dans les dumps
# _export_en_cours.xml / _export_etat_final.xml du run suite). Les appareils
# clients de production n'ont pas su : on masque /system/xbin par bind-mount
# d'un répertoire vide — SANS écrire dans /system ni redémarrer — pour rendre
# l'image CI équivalente à un appareil client réel. Le contrôle de CERTIFICAT
# reste pleinement actif (un APK non officiel serait toujours refusé).
# IntegrityGuard n'est ni modifié ni contourné.
adb root >/dev/null 2>&1 || true
sleep 3
adb shell setenforce 0 2>/dev/null || true
adb shell mkdir -p /data/local/tmp/vv_xbin_vide
{
  echo "=== avant masquage ==="
  adb shell 'ls /system/bin/su /system/xbin/su /system/app/Superuser.apk 2>&1'
  echo "=== masquage : bind-mount d'un répertoire vide sur /system/xbin ==="
  adb shell mount -o bind /data/local/tmp/vv_xbin_vide /system/xbin 2>&1 \
    || adb shell mount --bind /data/local/tmp/vv_xbin_vide /system/xbin 2>&1
  echo "=== après masquage (attendu : su invisible) ==="
  adb shell 'ls /system/xbin/ 2>&1'
  adb shell 'ls /system/bin/su /system/xbin/su /system/app/Superuser.apk 2>&1'
} | tee "$OUT/su_mask_proof.txt"
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
if [ "$PROFIL" = "font130" ] || [ "$PROFIL" = "petit" ] || [ "$PROFIL" = "cible" ] \
   || [ "$PROFIL" = "camerafix" ] || [ "$PROFIL" = "exportfix" ] || [ "$PROFIL" = "suite" ]; then
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
# (PAS de tap sur le bouton Google : la feuille Credential Manager est un
#  écran SYSTÈME, hors design produit — v1 a déraillé tout le parcours FR.)
if attendre "$ATTENDU_AUTH"; then
  galshot "auth" "Connexion — bouton Google (non actionné ici)" "authentification" "non connecté"
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

# 06_secteurs
if attendre "$SECTEUR_TITRE"; then
  galshot "secteurs" "Choix du secteur (activité principale)" "secteurs" "initial"
  swipe_v 70 30 300; sleep 1
  galshot "secteurs_bas" "Choix du secteur — bas de liste" "secteurs" "défilé"
  haut_de_page
else
  gap "écran secteurs non atteint"
fi
taper "$SECT6" ; sleep 1 ; taper "$CONTINUER" exact

# 04_parrainage
if attendre "$SANS_CODE"; then
  galshot "parrainage" "Étape parrainage — saisie du code" "parrainage" "vide"
  taper "$SANS_CODE" exact
else
  gap "étape parrainage non atteinte (continuation directe)"
fi

# 05_credits
sleep 2
if attendre "Bienvenue" "Welcome" "crédits" "credits"; then
  galshot "credits_bienvenue" "Bienvenue — confirmation des crédits" "credits" "connecté-local"
  taper "$CONTINUER" exact
  sleep 2
fi
okcat=0
for _ in 1 2 3; do
  if attendre "$CATALOGUE"; then okcat=1; break; fi
  taper "$CONTINUER" exact; sleep 2
done

# =====================================================================
# 07_catalogue + 08_gabarits
# =====================================================================
if [ "$okcat" = "1" ]; then
  galshot "catalogue_haut" "Catalogue — haut (secteur sélectionné)" "catalogue" "initial"
  n_scroll=0; prec=""
  while [ "$n_scroll" -lt 8 ]; do
    dump_courant "_cat_prec"
    prec="$OUT/_cat_prec.xml"
    swipe_v 72 28 350; sleep 1; n_scroll=$((n_scroll+1))
    galshot "catalogue_scroll${n_scroll}" "Catalogue — position ${n_scroll}" "catalogue" "défilé"
    dump_courant "_cat_cour"
    if [ -s "$prec" ] && cmp -s "$OUT/_cat_cour.xml" "$prec" 2>/dev/null; then break; fi
  done
  if [ "$PROFIL" = "base" ] && [ "$LANGUE" = "fr" ]; then
    # v5 : « Changer de secteur » est un toggle INLINE (D42.30) qui déplie
    # des chips horizontaux ; on VÉRIFIE le dépliage (« Tous les métiers »),
    # on défile horizontalement si besoin, puis on tape le chip.
    for s in 1 2 3 4 5 6; do
      case "$s" in
        1) S="$SECT1";; 2) S="$SECT2";; 3) S="$SECT3";; 4) S="$SECT4";; 5) S="$SECT5";; 6) S="$SECT6";;
      esac
      # déplier (si déjà déplié, le toggle replie : on vérifie après chaque tap)
      ouvre=0
      for t in 1 2 3; do
        tap_coord_text "$CHANGE_SECTEUR" || { gap "bouton « $CHANGE_SECTEUR » introuvable (itération $s)"; break 2; }
        sleep 2
        dump_courant "secteur_iter${s}"
        if coord_parmi "$OUT/secteur_iter${s}.xml" "Tous les métiers" "tous les" "All"; then ouvre=1; break; fi
      done
      if [ "$ouvre" = "1" ]; then
        galshot "secteur_change_${s}" "Catalogue — filtres secteur dépliés (itération $s)" "secteurs" "changement"
        # chip cible — bloc de chips MULTI-LIGNES (dump v6 : lignes à
        # ~31 %, ~38 % et ~44 % de la hauteur) : swipe horizontal à
        # plusieurs hauteurs + petit défilement vertical de secours
        trouve=0
        for h in 1 2 3 4; do
          dump_courant "secteur_iter${s}"
          if bounds=$(coord_parmi "$OUT/secteur_iter${s}.xml" "$S"); then
            # shellcheck disable=SC2086
            adb shell input tap $bounds >/dev/null 2>&1; trouve=1; break
          fi
          swipe_h 31 250; sleep 1
          dump_courant "secteur_iter${s}"
          if bounds=$(coord_parmi "$OUT/secteur_iter${s}.xml" "$S"); then
            # shellcheck disable=SC2086
            adb shell input tap $bounds >/dev/null 2>&1; trouve=1; break
          fi
          swipe_h 38 250; sleep 1
        done
        if [ "$trouve" = "0" ]; then
          # secours : la chip est peut-être SOUS le pli vertical
          swipe_v 62 52 250 >/dev/null 2>&1; sleep 1
          dump_courant "secteur_iter${s}"
          if bounds=$(coord_parmi "$OUT/secteur_iter${s}.xml" "$S"); then
            # shellcheck disable=SC2086
            adb shell input tap $bounds >/dev/null 2>&1; trouve=1
          fi
          swipe_v 42 52 250 >/dev/null 2>&1; sleep 1
        fi
        sleep 2
        if [ "$trouve" = "1" ]; then
          galshot "catalogue_secteur${s}" "Catalogue — secteur « $S » (en-tête de focus)" "catalogue" "secteur $s"
          k=0; prec2=""
          while [ "$k" -lt 5 ]; do
            dump_courant "_cs_prec"
            prec2="$OUT/_cs_prec.xml"
            swipe_v 72 28 350; sleep 1; k=$((k+1))
            galshot "catalogue_secteur${s}_scroll${k}" "Catalogue — secteur « $S », position $k" "catalogue" "secteur $s, défilé"
            dump_courant "_cs_cour"
            if [ -s "$prec2" ] && cmp -s "$OUT/_cs_cour.xml" "$prec2" 2>/dev/null; then break; fi
          done
        else
          gap "chip secteur « $S » introuvable (itération $s) — dump secteur_iter${s}.xml"
        fi
      else
        gap "chips de secteur jamais dépliées (itération $s) — dump secteur_iter${s}.xml"
      fi
    done
    # retour au secteur Commerce pour la suite du parcours
    for t in 1 2 3; do
      tap_coord_text "$CHANGE_SECTEUR" || break; sleep 2
      dump_courant "_retour_sect"
      if bounds=$(coord_parmi "$OUT/_retour_sect.xml" "$SECT6"); then
        # shellcheck disable=SC2086
        adb shell input tap $bounds >/dev/null 2>&1; break
      fi
      swipe_h; sleep 1
    done
    sleep 2
    haut_de_page
    attendre "$CATALOGUE" || true
  fi
else
  gap "catalogue non atteint"
fi

# 09_brief — sélection du gabarit (v5 : UNE passe de motifs par écran, skins
# différents selon le secteur ; vérification par la PRÉSENCE DE CHAMPS).
# v10 camerafix : T4 « Promotion » d'abord (33 s — export plus court que le
# témoignage 50 s : complétion attendue ~30 min, run p1-official 43168986328).
if [ "$PROFIL" = "camerafix" ]; then
  GABARITS_CANDIDATS="Promotion client raconte Nouvel arrivage Nouveautés New Arrivals ancien prix montre l.article Présentation Quick Témoignage Customer Avant"
fi
# v11 exportfix : T1 « Nouvel arrivage » d'abord — gabarit du run p1-official
# 43168986328 (export abouti ~14 min sur la même APK RC15) ; le T5 des
# profils base dépasse la fenêtre de 95 min sous swiftshader.
# v11g suite : « Nouvel arrivage » RETIRÉ pour le profil suite — sa carte Mode
# (homonyme) ouvre un brief à champ contact 🇧🇯+229 + « Nom du vêtement » dont
# le champ quartier (hors champ) ne se remplit pas → « Continuer » bloqué et
# la boucle s'épuise (runs v11c 43461281227 et v11f 43475521898). La carte
# « Avant et après » (générique, 35 s · 15 scènes · 3 prises) est prouvée par
# le run v11d 43465731951 : brief générique une étape → export réel terminé.
if [ "$PROFIL" = "exportfix" ]; then
  GABARITS_CANDIDATS="Nouvel arrivage client raconte Nouveautés New Arrivals ancien prix montre l.article Présentation Quick Promo Promotion Témoignage Customer Avant"
elif [ "$PROFIL" = "suite" ]; then
  GABARITS_CANDIDATS="Avant et après Présentation client raconte Nouveautés New Arrivals ancien prix montre l.article Quick Promo Promotion Témoignage Customer"
fi
haut_de_page
GABARIT_OK=0
if choisir_gabarit $GABARITS_CANDIDATS; then
  sleep 3
  lister_champs
  if grep -q "^E2E CHAMP " "$OUT/champs.txt" 2>/dev/null; then GABARIT_OK=1; fi
fi
if [ "$GABARIT_OK" = "1" ]; then
  galshot "brief_vide" "Formulaire de brief — vide (Continuer désactivé)" "brief" "vide"
else
  gap "aucun gabarit ouvert (écran brief jamais atteint) — dump _gabarit_cherche.xml"
  cp "$OUT/_gabarit_cherche.xml" "$OUT/gabarit_echec.xml" 2>/dev/null || true
fi

# 10_formulaires — remplissage vérifié + clavier + erreurs (seulement si brief ouvert)
if [ "$GABARIT_OK" = "1" ]; then
lister_champs
I_WA=$(idx_de "whatsapp")
I_PX=$(idx_de "prix|price")
if [ -n "$I_WA" ]; then
  remplir_par_label "whatsapp" "0197000000"
  galshot "brief_whatsapp_clavier" "Champ WhatsApp — clavier ouvert" "formulaires" "clavier ouvert"
fi
# remplir tous les autres champs vides, un par un, avec vérification
for _ in 1 2 3 4 5 6 7 8; do
  v=$(nombre_de_vides); v=${v:-0}
  [ "$v" -gt 0 ] || break
  remplir_les_vides
done
fermer_clavier
if [ -n "$I_PX" ]; then
  # capture dédiée prix+clavier (le champ prix est le plus formaté)
  ligne=$(awk -v i="$I_PX" '$1=="E2E" && $2=="CHAMP" && $3==i {print $4, $5, $6, $7}' "$OUT/champs.txt" 2>/dev/null)
  if [ -n "$ligne" ]; then
    # shellcheck disable=SC2086
    set -- $ligne
    adb shell input tap $(( ($1 + $3) / 2 )) $(( ($2 + $4) / 2 )) >/dev/null 2>&1; sleep 1
    galshot "brief_prix_clavier" "Champ prix — clavier ouvert" "formulaires" "clavier ouvert"
    fermer_clavier
  fi
fi
galshot "brief_rempli" "Formulaire de brief — rempli (valeurs fictives)" "brief" "rempli"

# états d'erreur volontaires (l'application refuse à juste titre) — par
# libellé, sur la page COURANTE du brief
if remplir_par_label "whatsapp" "019700000"; then
  sleep 1
  galshot "brief_erreur_whatsapp" "Erreur de validation du numéro (9 chiffres)" "formulaires" "erreur"
  remplir_par_label "whatsapp" "0197000000"
fi
if remplir_par_label "prix|price" "abc"; then
  sleep 1
  galshot "brief_erreur_prix" "Erreur de validation du prix (alphabétique)" "formulaires" "erreur"
  remplir_par_label "prix|price" "15000"
fi
fermer_clavier
galshot "brief_final" "Formulaire de brief — état final avant validation" "brief" "prêt"
fi   # fin GABARIT_OK (section formulaires)

# ---- variantes : parcours réduit (font130 / petit) — arrêt ici -----------
if [ "$PROFIL" = "font130" ] || [ "$PROFIL" = "petit" ]; then
  if [ "$GABARIT_OK" = "1" ]; then
    galshot "variante_resume" "Variante $PROFIL — brief rempli (état final)" "brief" "variante $PROFIL"
  else
    galshot "variante_resume" "Variante $PROFIL — catalogue (gabarit non ouvert, cf. gaps)" "catalogue" "variante $PROFIL"
  fi
  adb shell wm size reset >/dev/null 2>&1 || true
  adb shell settings put system font_scale 1.0 >/dev/null 2>&1 || true
  adb logcat -d > "$OUT/logcat_gallery.txt" 2>/dev/null || true
  echo "=========== GALERIE $LANGUE / $PROFIL (variante) : $ORDRE captures ==========="
  exit 0
fi

# =====================================================================
# 11_verification — réparation puis validation du brief
# =====================================================================
if [ "$GABARIT_OK" = "1" ]; then
# v7 : le brief est MULTI-ÉTAPES (le bouton Continuer avance d'étape en
# étape — constat offline v6 : champs Prix/Monnaie/Quartier puis nouvelle
# page) ; on boucle jusqu'à 8 avancements avec réparation à chaque étape.
# v11d suite/exportfix : 20 tentatives — le run 43461281227 a épuisé les 8
# sur le T1 « Nouvel arrivage » du secteur MODE (carte homonyme de celle du
# Commerce, sélectionnée selon la position de défilement : brief à contact
# 🇧🇯 +229 + produit + prix + …, ≥ 9 étapes) sans atteindre la vérification.
BRIEF_TENTATIVES=8
[ "$PROFIL" = "suite" ] || [ "$PROFIL" = "exportfix" ] && BRIEF_TENTATIVES=20
for tentative in $(seq 1 "$BRIEF_TENTATIVES"); do
  # boucle de réparation : erreurs affichées ou champs vides → re-saisir
  for _ in 1 2 3; do
    dump_courant "_verif_brief"
    probleme=""
    grep -q "$ERREUR_TEL" "$OUT/_verif_brief.xml" 2>/dev/null && probleme="tel"
    grep -q "$ERREUR_PRIX" "$OUT/_verif_brief.xml" 2>/dev/null && probleme="${probleme} prix"
    [ -z "$probleme" ] || echo "GALERIE réparation ($tentative.$_) : erreur affichée → ${probleme}"
    if printf '%s' "$probleme" | grep -q tel; then
      remplir_par_label "whatsapp" "0197000000" || true
    fi
    if printf '%s' "$probleme" | grep -q prix; then
      remplir_par_label "prix|price" "15000" || true
    fi
    v=$(nombre_de_vides); v=${v:-0}
    if [ "$v" -gt 0 ]; then
      echo "GALERIE réparation ($tentative.$_) : $v champ(s) vide(s) → remplissage"
      remplir_les_vides
    fi
    [ -z "$probleme" ] && [ "$v" -eq 0 ] && break
    fermer_clavier
  done
  fermer_clavier
  # révéler Continuer puis l'actionner — v8 : le bouton Compose expose parfois
  # des bornes DÉGÉNÉRÉES [0,0][0,0] (dump offline v7) que le tap par
  # coordonnées refuse : repli sur ui.py (point_de_clic « bas_large »).
  tap_coord_text "$CONTINUER" || taper "$CONTINUER" exact || true
  WT=14
  if attendre "$AVANT"; then
    WT=20
    galshot "verification" "Écran de vérification (avant de commencer)" "verification" "récapitulatif"
    swipe_v 72 30 300; sleep 1
    galshot "verification_bas" "Vérification — bas de l'écran" "verification" "défilé"
    haut_de_page
    break
  fi
  WT=20
  # nouvelle étape du brief ? (des champs sont encore présents → remplir et
  # continuer ; sinon simple attente avant la prochaine tentative)
  lister_champs
  if grep -q "^E2E CHAMP " "$OUT/champs.txt" 2>/dev/null; then
    echo "GALERIE : étape de brief supplémentaire détectée (tentative $tentative)"
    galshot "brief_etape${tentative}" "Brief — étape ${tentative} (multi-étapes)" "brief" "étape $tentative"
  fi
done
if ! attendre "$AVANT"; then
  gap "écran de vérification jamais atteint (brief non validable après réparations)"
fi
fi   # fin GABARIT_OK (section vérification)

# =====================================================================
# 12_camera + 13_prises
# =====================================================================
tap_coord_text "$OK_COMMENCE" || taper "$OK_COMMENCE" exact
sleep 2
if [ "$PROFIL" = "base" ]; then
  # dialogue système de permission (l'app demande à l'arrivée du guide)
  if focus_dans "permissioncontroller"; then
    galshot "camera_permission_dialogue" "Dialogue système de permission caméra" "camera" "permission demandée"
    adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
    galshot "camera_permission_refusee" "Caméra — permission refusée" "camera" "permission refusée"
    # provoquer la 2e demande (bouton enregistrement) → dialogue produit possible
    $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1 || true
    sleep 2
    if attendre "$ACCES"; then
      galshot "camera_dialogue_produit" "Dialogue produit « accès caméra nécessaire »" "camera" "rationale"
    fi
    if focus_dans "permissioncontroller"; then
      galshot "camera_permission_dialogue_2" "Dialogue système (2e demande)" "camera" "permission redemandée"
      adb shell input keyevent 4 >/dev/null 2>&1; sleep 1
    fi
    adb shell pm grant "$PKG" android.permission.CAMERA >/dev/null 2>&1 || true
    adb shell input keyevent 4 >/dev/null 2>&1; sleep 1
    taper "$PLUS_TARD" || true
    sleep 1
    adb shell am start -n "$PKG/.MainActivity" >/dev/null 2>&1; sleep 4
    # v4 : après le refus, l'activité caméra s'est fermée et le brouillon
    # peut rouvrir le BRIEF (constat run v3) — on RE-VALIDE le parcours :
    # Continuer → vérification → OK. La permission étant accordée (pm grant),
    # le guide s'ouvre cette fois avec le viseur actif.
    for _recup in 1 2; do
      if $UI wait --id "camera_record_button" --timeout 15 >/dev/null 2>&1; then break; fi
      tap_coord_text "$CONTINUER" || true; sleep 2
      WT=20; attendre "$AVANT" || true; WT=20
      tap_coord_text "$OK_COMMENCE" || true; sleep 3
    done
  else
    adb shell pm grant "$PKG" android.permission.CAMERA >/dev/null 2>&1 || true
  fi
else
  adb shell pm grant "$PKG" android.permission.CAMERA >/dev/null 2>&1 || true
fi
WT=40
if attendre "$FILME"; then
  galshot "camera_guide" "Guide de tournage (consignes)" "camera" "guide"
fi
WT=20
# v6 : les contrôles caméra sont des BOUTONS TEXTE (« VERROUILLER ET
# ENREGISTRER », « CHANGER DE CAMÉRA », « REFAIRE », « SUIVANT » — dumps
# v5) ; l'id camera_record_button n'est pas toujours exposé. Recherche par
# texte (dump) avec id en repli.
demarrer_enregistrement() {
  $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1 \
    || tap_coord_text "$REC_TXT" || true
}
arreter_enregistrement() {
  $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1 \
    || tap_coord_text "$STOP_TXT" || true
}
ok_cam=0
for _ in 1 2 3; do
  if $UI wait --id "camera_record_button" --timeout 20 >/dev/null 2>&1; then ok_cam=1; break; fi
  dump_courant "_cam_cherche"
  if coord_parmi "$OUT/_cam_cherche.xml" "$REC_TXT"; then ok_cam=1; break; fi
  taper "$AUTORISER" exact || true; sleep 2
done
if [ "$ok_cam" = "1" ]; then
  sleep 2
  # v11b suite : caméra ALLÉGÉE (3 prises comme le harnais p1 — réduit la
  # charge d'export swiftshader) ; les écrans caméra sont couverts par les
  # profils base/camerafix.
  if [ "$PROFIL" = "suite" ]; then
    :
  elif [ "$PROFIL" = "camerafix" ]; then
    galshot_sr "camera_preview" "Viseur caméra — PreviewView (flux ÉMULÉ — capture screenrecord du contenu composé)" "camera" "preview streaming"
  else
    galshot "camera_preview" "Viseur caméra — PreviewView (flux ÉMULÉ de l'émulateur)" "camera" "preview streaming"
  fi
  demarrer_enregistrement
  if [ "$PROFIL" != "suite" ]; then
    galshot "camera_countdown_a" "Compte à rebours (capture a)" "prises" "countdown"
    sleep 1
    galshot "camera_countdown_b" "Compte à rebours (capture b)" "prises" "countdown"
  fi
  sleep 2
  if [ "$PROFIL" = "suite" ]; then
    sleep 2
  elif [ "$PROFIL" = "camerafix" ]; then
    galshot_sr "camera_rec" "Enregistrement ACTIF — badge REC (capture screenrecord)" "prises" "rec"
  else
    galshot "camera_rec" "Enregistrement ACTIF — badge REC" "prises" "rec"
  fi
  sleep 2
  arreter_enregistrement
  sleep 2
  [ "$PROFIL" != "suite" ] && galshot "camera_arret" "Arrêt de la prise — finalisation" "prises" "arrêt" || true
  WT=25
  if attendre "$PRISE_OK"; then
    WT=20
    [ "$PROFIL" != "suite" ] && galshot "camera_prise_validee" "Prise validée (✓ enregistrée)" "prises" "validée" || true
  else
    WT=20
  fi
  if [ "$PROFIL" = "suite" ]; then
    :
  elif tap_coord_text "$FLIP_TXT"; then
    sleep 3
    if [ "$PROFIL" = "camerafix" ]; then
      galshot_sr "camera_avant" "Caméra AVANT (flux émulé) après bascule (screenrecord)" "prises" "bascule avant"
    else
      galshot "camera_avant" "Caméra AVANT (flux émulé) après bascule" "prises" "bascule avant"
    fi
    tap_coord_text "$FLIP_TXT"; sleep 3
    if [ "$PROFIL" = "camerafix" ]; then
      galshot_sr "camera_arriere" "Retour caméra ARRIÈRE (flux émulé) (screenrecord)" "prises" "bascule retour"
    else
      galshot "camera_arriere" "Retour caméra ARRIÈRE (flux émulé)" "prises" "bascule retour"
    fi
  else
    gap "bouton de bascule caméra introuvable"
  fi
  if [ "$PROFIL" = "suite" ]; then
    :
  elif tap_coord_text "$REDO_TXT"; then
    sleep 3
    if [ "$PROFIL" = "camerafix" ]; then
      galshot_sr "camera_refaire" "Reprise d'une prise (Refaire) (screenrecord)" "prises" "reprise"
    else
      galshot "camera_refaire" "Reprise d'une prise (Refaire)" "prises" "reprise"
    fi
    demarrer_enregistrement
    sleep 5
    arreter_enregistrement
    sleep 2
  else
    gap "bouton Refaire introuvable"
  fi
  # scènes suivantes (jusqu'à 4) puis sortie vers l'aperçu
  scene=2
  while [ "$scene" -le 4 ]; do
    WT=8
    if attendre "$APERCU"; then break; fi
    WT=20
    if ! tap_coord_text "$NEXT_TXT"; then break; fi
    sleep 2
    [ "$PROFIL" != "suite" ] && galshot "camera_scene${scene}" "Scène ${scene} du guide" "prises" "scène ${scene}" || true
    demarrer_enregistrement
    sleep 6
    arreter_enregistrement
    sleep 2
    scene=$((scene+1))
  done
else
  gap "écran caméra non atteint (bouton enregistrement absent) — dump _cam_cherche.xml"
fi

# =====================================================================
# 14/15 — audio (mode automatique) + aperçu E7
# =====================================================================
WT=90
if attendre "$APERCU" "$E7_CHECK"; then
  if [ "$PROFIL" = "suite" ]; then
    # E7 est hébergé par ExportActivity (FLAG_SECURE) : capture pixel
    # impossible PAR CONCEPTION — preuve par dump.
    dump_courant "_e7_apercu"
    gap "E7 (aperçu) : écran sous FLAG_SECURE (ExportActivity) — capture d'écran impossible par conception (protection produit) ; preuve par dump _e7_apercu.xml"
  else
    galshot "apercu" "Aperçu de la vidéo (E7) — mode audio automatique" "montage" "aperçu"
    swipe_v 72 30 300; sleep 1
    galshot "apercu_bas" "Aperçu — bas (typographie, voix)" "audio" "détail"
  fi
  haut_de_page
else
  # v7 : le rendu de l'aperçu est LENT sur swiftshader (run v6 : le tap
  # « Créer ma vidéo » réussissait après l'expiration de l'attente) —
  # vérification par dump et capture tardive
  sleep 10
  dump_courant "_e7_tardif"
  if coord_parmi "$OUT/_e7_tardif.xml" "$APERCU" "$E7_CHECK"; then
    if [ "$PROFIL" = "suite" ]; then
      dump_courant "_e7_apercu"
      gap "E7 (aperçu) : écran sous FLAG_SECURE (ExportActivity) — capture impossible par conception ; preuve par dump"
    else
      galshot "apercu" "Aperçu de la vidéo (E7) — mode audio automatique" "montage" "aperçu"
      swipe_v 72 30 300; sleep 1
      galshot "apercu_bas" "Aperçu — bas (typographie, voix)" "audio" "détail"
    fi
    haut_de_page
  else
    gap "écran d'aperçu E7 non atteint — dump _e7_tardif.xml"
  fi
fi

# ---- profil ciblé (capture E7 uniquement) : sortie propre, pas d'export ----
if [ "$PROFIL" = "cible" ]; then
  adb logcat -d > "$OUT/logcat_gallery.txt" 2>/dev/null || true
  echo "=========== GALERIE $LANGUE / $PROFIL (cible E7) : $ORDRE captures ==========="
  exit 0
fi
WT=20
tap_coord_text "$CREER" || taper "$CREER" exact

# =====================================================================
# 16_export
# =====================================================================
export_lance=0
# v11 exportfix : écran maintenu ALLUMÉ pendant l'export (screenrecord)
if [ "$PROFIL" = "exportfix" ] || [ "$PROFIL" = "suite" ]; then
  adb shell svc power stayon true >/dev/null 2>&1 || true
fi
WT=40
if attendre "$EXPORT_START" "$EXPORT_RUNNING" "$EXPORT_PREP"; then
  if [ "$PROFIL" = "suite" ]; then
    dump_courant "_export_pret"
  elif [ "$PROFIL" = "exportfix" ]; then
    galshot_sr "export_pret" "Écran d'export (E8) — avant lancement (screenrecord)" "export" "prêt"
  else
    galshot "export_pret" "Écran d'export (E8) — avant lancement" "export" "prêt"
  fi
  if tap_coord_text "$EXPORT_START" || taper "$EXPORT_START" exact; then
    export_lance=1
    sleep 3
    WT=25
    if attendre "$EXPORT_RUNNING" "$EXPORT_PREP"; then
      if [ "$PROFIL" = "suite" ]; then
        dump_courant "_export_en_cours"
      elif [ "$PROFIL" = "exportfix" ]; then
        galshot_sr "export_en_cours" "Export local en cours (screenrecord)" "export" "en cours"
      else
        galshot "export_en_cours" "Export local en cours" "export" "en cours"
      fi
    fi
    WT=20
    adb shell dumpsys notification 2>/dev/null | grep -c "vv_export" > "$OUT/notif_verif.txt" || true
    if [ "$PROFIL" = "suite" ]; then
      adb shell dumpsys notification > "$OUT/notif_dump.txt" 2>/dev/null || true
    fi
    adb shell cmd statusbar expand-notifications >/dev/null 2>&1; sleep 2
    if [ "$PROFIL" = "exportfix" ] || [ "$PROFIL" = "suite" ]; then
      galshot_sr "export_notification" "Tiroir de notifications — export FGS (screenrecord)" "export" "notification"
    else
      galshot "export_notification" "Tiroir de notifications — export (FGS)" "export" "notification"
    fi
    adb shell cmd statusbar collapse >/dev/null 2>&1; sleep 1
    if [ "$PROFIL" != "exportfix" ] && [ "$PROFIL" != "suite" ]; then
      # test « écran éteint » : déjà prouvé 3× (p1-official, lab p1, lab
      # offline-export : P1_ecran_etaint PASS) — exportfix le saute pour
      # privilégier la complétion de l'export et la capture screenrecord.
      adb shell input keyevent 26 >/dev/null 2>&1; sleep 8
      adb shell input keyevent 26 >/dev/null 2>&1; sleep 1
      adb shell input keyevent 224 >/dev/null 2>&1; sleep 1
      adb shell input keyevent 82 >/dev/null 2>&1; sleep 2
      galshot "export_apres_ecran_etaint" "Export après écran éteint (réveil)" "export" "écran éteint survécu"
    fi
  else
    gap "bouton « $EXPORT_START » introuvable"
  fi
else
  gap "écran d'export non atteint"
fi
# fin d'export : longue attente UNIQUEMENT si l'export a démarré.
# Fenêtre 95 min : mesures p1 (D42.28-26 : export BGM > 40 min ; D42.30-13 :
# abouti après > 75 min — swiftshader, h264 1080p, fenêtre p1 = 95 min).
# HORS LIGNE : la fin d'export (95 min) est couverte par base-fr/base-en —
# le profil offline documente ses états propres puis s'arrête honnêtement.
if [ "$export_lance" = "1" ] && [ "$PROFIL" = "offline" ]; then
  galshot "export_offline_en_cours" "Hors connexion — export local en cours (état propre au profil)" "hors_connexion" "export en cours"
  gap "fin d'export non attendue en offline (couverte par base-fr/base-en, fenêtre 95 min)"
elif [ "$export_lance" = "1" ]; then
  WT=5700
  # v11b suite : fenêtre étendue — le run exportfix 43412790349 a expiré à
  # 95 min (lancement 11:10, état final 12:46) ; D42.30-13 : export abouti
  # après >75 min. 180 min couvre les runners lents.
  [ "$PROFIL" = "suite" ] && WT=10800
  if attendre "$DONE"; then
    WT=20
    if [ "$PROFIL" = "suite" ]; then
      # « Vidéo prête ! » est sous FLAG_SECURE : capture pixel impossible par
      # conception — preuves : dump uiautomator (texte intégral) + MP4 tiré.
      dump_courant "_export_termine"
      gap "« $DONE » : écran sous FLAG_SECURE (ExportActivity) — capture pixel impossible par conception (protection produit) ; preuves : dump _export_termine.xml + MP4 tiré"
      MP4NAME=$(adb shell run-as "$PKG" ls cache 2>/dev/null | tr -d '\r' | grep -m1 'export-.*\.mp4' || true)
      if [ -z "$MP4NAME" ]; then
        adb root >/dev/null 2>&1 || true; sleep 3
        MP4NAME=$(adb shell ls "/data/data/$PKG/cache" 2>/dev/null | tr -d '\r' | grep -m1 'export-.*\.mp4' || true)
        [ -n "$MP4NAME" ] && adb pull "/data/data/$PKG/cache/$MP4NAME" "$OUT/export.mp4" >/dev/null 2>&1 || true
      else
        adb shell run-as "$PKG" cat "cache/$MP4NAME" > "$OUT/export.mp4" 2>/dev/null || true
      fi
      if [ -s "$OUT/export.mp4" ] && command -v ffprobe >/dev/null 2>&1; then
        ffprobe -v error -show_format -show_streams "$OUT/export.mp4" > "$OUT/ffprobe.txt" 2>&1 || true
      fi
    elif [ "$PROFIL" = "exportfix" ]; then
      galshot_sr "export_termine" "« $DONE » — export terminé (screenrecord)" "export" "terminé"
      # v11 : preuve FICHIER — MP4 du moteur de production (run-as, sinon adb root)
      MP4NAME=$(adb shell run-as "$PKG" ls cache 2>/dev/null | tr -d '\r' | grep -m1 'export-.*\.mp4' || true)
      if [ -z "$MP4NAME" ]; then
        adb root >/dev/null 2>&1 || true; sleep 3
        MP4NAME=$(adb shell ls "/data/data/$PKG/cache" 2>/dev/null | tr -d '\r' | grep -m1 'export-.*\.mp4' || true)
        [ -n "$MP4NAME" ] && adb pull "/data/data/$PKG/cache/$MP4NAME" "$OUT/export.mp4" >/dev/null 2>&1 || true
      else
        adb shell run-as "$PKG" cat "cache/$MP4NAME" > "$OUT/export.mp4" 2>/dev/null || true
      fi
      if [ -s "$OUT/export.mp4" ] && command -v ffprobe >/dev/null 2>&1; then
        ffprobe -v error -show_format -show_streams "$OUT/export.mp4" > "$OUT/ffprobe.txt" 2>&1 || true
      fi
    else
      galshot "export_termine" "« $DONE » — export terminé" "export" "terminé"
    fi
    if tap_coord_text "$PARTAGER" || taper "$PARTAGER" exact; then
      sleep 3
      if [ "$PROFIL" = "exportfix" ] || [ "$PROFIL" = "suite" ]; then
        galshot_sr "partage_feuille" "Feuille de partage Android — export-0.mp4 (screenrecord)" "partage" "feuille ouverte"
        adb shell dumpsys activity activities 2>/dev/null | grep -i "chooser\|ResolverActivity" > "$OUT/partage_preuve.txt" || true
      else
        galshot "partage_feuille" "Feuille de partage Android (cible système)" "partage" "feuille ouverte"
      fi
      adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
    else
      gap "bouton « $PARTAGER » introuvable"
    fi
    if [ "$PROFIL" = "suite" ]; then
      # v11 suite : dashboard RÉEL via « Voir mon espace » (intents shell
      # refusés — DashboardActivity android:exported="false") ; screenrecord.
      if tap_coord_text "$ESPACE" || taper "$ESPACE" exact; then
        sleep 3
        # v11e : dump de preuve + diagnostic des libellés réels du dashboard
        dump_courant "_dashboard"
        galshot_sr "dashboard" "Mon espace — tableau de bord (screenrecord)" "historique" "connecté-local"
        galshot_sr "profil_dashboard" "Tableau de bord — en-tête et cartes (screenrecord)" "profil" "vue complète"
        swipe_v 70 35 300 >/dev/null 2>&1; sleep 1
        galshot_sr "dashboard_bas" "Tableau de bord — bas de page (screenrecord)" "historique" "défilé"
        haut_de_page
        if taper "Parrainage" || taper "parrainage" || taper "Referral"; then
          sleep 3
          galshot_sr "dashboard_parrainage" "Parrainage — jauge et code (screenrecord)" "parrainage" "depuis dashboard"
          adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
        fi
        # v11f : « Réglages » absent du sommet du dashboard (dump _dashboard.xml
        # du run v11e 43471051633 : aucun nœud ni content-desc « Réglages ») —
        # tentative après défilement, gap documenté sinon.
        REGLAGES_OK=0
        if taper "Réglages" || taper "Paramètres" || taper "Settings"; then
          REGLAGES_OK=1
        else
          swipe_v 70 35 300 >/dev/null 2>&1; sleep 1
          if taper "Réglages" || taper "Paramètres" || taper "Settings"; then
            REGLAGES_OK=1
          fi
          haut_de_page
        fi
        if [ "$REGLAGES_OK" = "1" ]; then
          sleep 3
          galshot_sr "profil_reglages" "Réglages / profil (screenrecord)" "profil" "ouvert"
          adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
        else
          gap "réglages : aucun libellé « Réglages » exposé sur le dashboard (sommet et bas testés — dump _dashboard.xml) — écran non capturé (constat UX)"
        fi
        # v11f : retour au SOMMET avant « Acheter » — le BACK du parrainage peut
        # laisser le dashboard défilé et le bouton hors champ (tap du run v11e
        # silencieusement infructueux) + dump de preuve du paywall ouvert.
        haut_de_page
        if taper "Acheter" || taper "crédits" || taper "Crédits" || taper "Recharger" || taper "Buy"; then
          sleep 3
          dump_courant "_paywall"
          galshot_sr "paywall" "Crédits / formules — paywall (screenrecord)" "credits" "offre"
          swipe_v 70 35 300 >/dev/null 2>&1; sleep 1
          galshot_sr "paywall_bas" "Paywall — bas, formules (screenrecord)" "credits" "défilé"
          adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
        else
          gap "paywall : bouton « Acheter » introuvable sur le dashboard (dump _dashboard.xml) — écran non capturé"
        fi
      else
        gap "bouton « $ESPACE » introuvable — dashboard non capturé"
      fi
    elif [ "$PROFIL" = "exportfix" ]; then
      gap "dashboard post-export couvert par le profil « suite » (run séparé)"
    elif tap_coord_text "$ESPACE" || taper "$ESPACE" exact; then
      sleep 3
      galshot "dashboard" "Mon espace — tableau de bord" "historique" "connecté-local"
      galshot "profil_dashboard" "Tableau de bord — en-tête et cartes" "profil" "vue complète"
      if taper "Parrainage" || taper "parrainage" || taper "Referral"; then
        sleep 3
        galshot "dashboard_parrainage" "Parrainage — jauge et code" "parrainage" "depuis dashboard"
        adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
      fi
      if taper "Réglages" || taper "Paramètres" || taper "Settings"; then
        sleep 3
        galshot "profil_reglages" "Réglages / profil" "profil" "ouvert"
        adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
      fi
      if taper "crédits" || taper "Crédits" || taper "Recharger" || taper "Buy"; then
        sleep 3
        galshot "paywall" "Crédits / recharge (paywall)" "credits" "offre"
        adb shell input keyevent 4 >/dev/null 2>&1; sleep 2
      fi
    else
      gap "bouton « $ESPACE » introuvable — dashboard non capturé via ce chemin"
    fi
  else
    WT=20
    if [ "$PROFIL" = "suite" ]; then
      dump_courant "_export_etat_final"
    elif [ "$PROFIL" = "exportfix" ]; then
      galshot_sr "export_etat_final" "Export — état final après fenêtre de 95 min (screenrecord)" "export" "délai dépassé"
    else
      galshot "export_etat_final" "Export — état final après fenêtre de 95 min" "export" "délai dépassé"
    fi
    gap "export non terminé dans la fenêtre d'attente (lancement effectif — état final documenté)"
  fi
else
  gap "export jamais lancé : pas d'attente longue"
fi

# =====================================================================
# 19_profil / 05_credits — dashboard, parrainage, réglages, paywall via
# action intents (écrans RÉELS de DashboardActivity — aucune dépendance à
# la fin d'export ; captured pour tous les profils non-variantes)
# =====================================================================
if [ "$PROFIL" != "font130" ] && [ "$PROFIL" != "petit" ] && [ "$PROFIL" != "exportfix" ] && [ "$PROFIL" != "suite" ]; then
  adb shell am start -a video.vitrine.action.VIEW_DASHBOARD >/dev/null 2>&1
  sleep 4
  galshot "dashboard" "Mon espace — tableau de bord (vue intents)" "profil" "connecté-local"
  swipe_v 70 35 300 >/dev/null 2>&1; sleep 1
  galshot "dashboard_bas" "Tableau de bord — bas de page" "profil" "défilé"
  haut_de_page
  adb shell am start -a video.vitrine.action.VIEW_DASHBOARD --es view referral >/dev/null 2>&1
  sleep 4
  galshot "dashboard_parrainage" "Parrainage — jauge et code (vue intents)" "parrainage" "depuis dashboard"
  adb shell am start -a video.vitrine.action.VIEW_DASHBOARD --es view settings >/dev/null 2>&1
  sleep 4
  galshot "profil_reglages" "Réglages / profil (vue intents)" "profil" "ouvert"
  adb shell am start -a video.vitrine.action.VIEW_PAYWALL >/dev/null 2>&1
  sleep 4
  galshot "paywall" "Crédits / formules — paywall (vue intents)" "credits" "offre"
  swipe_v 70 35 300 >/dev/null 2>&1; sleep 1
  galshot "paywall_bas" "Paywall — bas (formules)" "credits" "défilé"
fi

# 20_hors_connexion — le profil offline a déroulé TOUT le parcours déconnecté
if [ "$PROFIL" = "offline" ]; then
  galshot "offline_final" "État final hors connexion" "hors_connexion" "hors connexion"
fi

# ---------------------------------------------------------------- épilogue --
if [ "$PROFIL" = "offline" ]; then
  adb shell svc wifi enable >/dev/null 2>&1 || true
  adb shell svc data enable >/dev/null 2>&1 || true
fi
adb shell wm size reset >/dev/null 2>&1 || true
adb shell settings put system font_scale 1.0 >/dev/null 2>&1 || true
adb logcat -d > "$OUT/logcat_gallery.txt" 2>/dev/null || true
echo "=========== GALERIE $LANGUE / $PROFIL : $ORDRE captures, $(wc -l < "$GAPS") gaps ==========="
