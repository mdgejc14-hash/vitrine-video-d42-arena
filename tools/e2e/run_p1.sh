#!/usr/bin/env bash
# Laboratoire D42.14 — parcours P1 : catalogue -> gabarit -> brief -> caméra
# -> prises -> export -> partage.
#
# Usage : run_p1.sh <tag> [apk]
# La caméra utilisée est la CAMÉRA VIRTUELLE DE L'ÉMULATEUR (-camera-back emulated).
# Ce n'est PAS un capteur physique : la chaîne testée est réelle (CameraX ->
# MediaCodec -> fichier MP4), l'image filmée est synthétique. Tout résultat est
# donc PASS_EMULATOR, jamais PASS_DEVICE.

# D42.26 — swipes ADAPTATIFS à la taille d'écran : les coordonnées absolues
# (1080x2340) tombaient hors écran en 540x960 (FAIL S07/S08 small du run
# 42509265951 : y=1200 > 960). Sur écran standard 1080x2340, les pourcentages
# recalculent EXACTEMENT les anciennes coordonnées (aucun changement).
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
set -uo pipefail

TAG="${1:-p1}"
APK="${2:-app/build/outputs/apk/debug/app-debug.apk}"
PKG="video.vitrine.app"
OUT="artifacts/${TAG}"

# D42.17 — APK release (non debuggable) : run-as est indisponible. L'émulateur
# AOSP « default » du lab autorise adb root : même mesure, même preuve, seule la
# voie d'accès ADB change. Aucun contournement produit (IntegrityGuard intact).
app_ls() {  # app_ls <rep-relatif> [flags ls] -> liste sur stdout
  local rep="$1"; shift || true
  if adb shell run-as "$PKG" ls "$rep" >/dev/null 2>&1; then
    adb shell run-as "$PKG" ls "$@" "$rep" 2>/dev/null
  else
    adb root >/dev/null 2>&1 || true
    sleep 2; adb wait-for-device >/dev/null 2>&1 || true
    adb shell ls "$@" "/data/data/$PKG/$rep" 2>/dev/null
  fi
}
app_cat() {  # app_cat <chemin-relatif> -> contenu binaire sur stdout (exec-out)
  if adb shell run-as "$PKG" ls "$(dirname "$1")" >/dev/null 2>&1; then
    adb exec-out run-as "$PKG" cat "$1" 2>/dev/null
  else
    adb root >/dev/null 2>&1 || true
    adb exec-out cat "/data/data/$PKG/$1" 2>/dev/null
  fi
}
UI="python3 tools/e2e/ui.py"
mkdir -p "$OUT"

# D42.21 (08/11) — APPAREIL CLIENT PROPRE, aligné sur la voie officielle
# (run_official_e2e.sh, même technique éprouvée rc9 + d42.21-rc-audio-v1).
# L'image AOSP « default » embarque /system/xbin/su : l'heuristique anti-root
# d'IntegrityGuard (V2.0 §22) le voit et refuse l'export (DENY_INTEGRITY —
# cause racine de TOUS les échecs P1-debug au lancement de l'export depuis la
# création de la voie ; cf. docs/checkpoints/D42_21/02_EXPORT_ROOT_CAUSE.md,
# §CORRECTION : le statut du dump 29 = export_gate_integrity). La voie
# officiale masque /system/xbin par bind-mount d'un répertoire vide : même
# traitement ici. IntegrityGuard n'est NI modifié NI contourné — le contrôle
# de certificat reste pleinement actif (un APK signé d'une autre clé serait
# toujours refusé en release). /system n'est pas écrit, pas de reboot (le
# reboot a tué l'émulateur au run rc3, le rm direct est impossible : /system
# en lecture seule, preuves rc2).
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
# D42.16 (H10) : rm AVANT le dump — un dump raté rend un fichier VIDE, jamais
# l'arbre périmé de l'écran précédent (cause de l'aveuglement du harnais sur
# les runs 42278038365 et 42281822052).
dump() {
  adb shell rm -f /sdcard/d.xml >/dev/null 2>&1
  adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1
  adb exec-out cat /sdcard/d.xml > "$OUT/$1.xml" 2>/dev/null
  if [ -s "$OUT/$1.xml" ]; then echo "E2E DUMP $1 ($(wc -c < "$OUT/$1.xml") octets)"; else echo "E2E DUMP_VIDE $1"; fi
}
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
# Le PREMIER appui sur la carte de langue applique la locale et RECRÉE
# l'activité : il ne fait pas toujours avancer vers l'authentification
# (constaté au run 42196966694 : LanguageActivity redessinée, jamais AuthActivity).
# On réessaie donc, en vérifiant à chaque fois si l'écran suivant est arrivé.
ecran_connexion=0
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
if [ "$ecran_connexion" = "1" ]; then
  record PASS P1_ecran_connexion "écran d'authentification atteint (langue appliquée)"
else
  record FAIL P1_ecran_connexion "authentification non atteinte après 4 appuis sur la langue"
fi

# Le bouton de repli est désactivé le temps de la vérification de session :
# on réessaie tant que l'écran d'authentification est encore là.
for essai in 1 2 3 4 5; do
  $UI tap --id "auth_offline_button" --timeout 10 >/dev/null 2>&1
  $UI gone --id "auth_offline_button" --timeout 20 >/dev/null 2>&1 && break
  echo "E2E repli: appui $essai sans effet"
  sleep 4
done
if $UI gone --id "auth_offline_button" --timeout 60 >/dev/null 2>&1; then
  record PASS P1_session_locale "repli sans compte : écran d'authentification quitté"
else
  record FAIL P1_session_locale "écran d'authentification toujours affiché après 5 appuis"
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
# Écran de bienvenue intermédiaire : un seul appui ne suffit pas toujours
# (run 42212817413 : catalogue non atteint). On réessaie jusqu'à voir le catalogue.
catalogue_atteint=0
for _ in 1 2 3; do
  $UI tap --text "Continuer" --exact --timeout 15 >/dev/null 2>&1 || true
  if $UI wait --text "modèle de vidéo" --timeout 20 >/dev/null 2>&1; then catalogue_atteint=1; break; fi
  sleep 3
done

# --- S20 catalogue -------------------------------------------------------------
if [ "$catalogue_atteint" = "1" ]; then
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

# --- S22 brief : remplir les champs REQUIS, défiler, valider --------------------
# `GabaritBriefScreen` : un seul écran défilant, bouton « Continuer » tout en bas,
# DÉSACTIVÉ tant que `filled != requiredIds.size` ou qu'un champ est invalide.
fermer_clavier() {
  # PIÈGE CORRIGÉ : `input keyevent 4` (RETOUR) ferme le clavier **s'il est ouvert**,
  # mais sinon il NAVIGUE EN ARRIÈRE. Au run 42219775013, quatre appuis « pour
  # fermer le clavier » ont ramené l'application du formulaire de brief au
  # catalogue — le test croyait ensuite être « bloqué en bas du formulaire ».
  if adb shell dumpsys input_method 2>/dev/null | grep -q "mInputShown=true"; then
    adb shell input keyevent 4 >/dev/null 2>&1
    sleep 1
  fi
}

remplir_champ() { # index, texte, [fichier de coordonnées]
  # On relit les coordonnées à chaque champ : le clavier modifie la géométrie de
  # l'écran, donc les positions mémorisées mentent.
  local idx="$1" val="$2" src="${3:-$OUT/champs.txt}" ligne x1 y1 x2 y2 cx cy
  # D42.14 (run 42252465240) : le fichier alimenté par `$UI champs` contient des
  # lignes « E2E CHAMP … » — l'awk cherchait « FIELD » : aucune coordonnée
  # n'était jamais trouvée, AUCUNE saisie n'avait lieu (les valeurs visibles
  # dans les dumps étaient les exemples/placeholder). Un mot, depuis l'origine
  # du remplissage par libellé.
  ligne=$(awk -v i="$idx" '$1=="E2E" && $2=="CHAMP" && $3==i {print $4, $5, $6, $7}' "$src")
  [ -z "$ligne" ] && return 1
  # shellcheck disable=SC2086
  set -- $ligne
  x1=$1; y1=$2; x2=$3; y2=$4
  cx=$(( (x1 + x2) / 2 )); cy=$(( (y1 + y2) / 2 ))
  adb shell input tap "$cx" "$cy" >/dev/null 2>&1; sleep 1
  adb shell input keyevent KEYCODE_MOVE_END >/dev/null 2>&1
  # D42.30-09 : 8 DEL insuffisants pour 14 caractères → concaténations
  # invalides aux re-remplissages (run 8c9f514). 24 DEL couvre + marge.
  for _ in $(seq 1 24); do adb shell input keyevent KEYCODE_DEL >/dev/null 2>&1; done
  adb shell input text "$val" >/dev/null 2>&1; sleep 1
  # ferme le clavier : sinon il masque le bas du formulaire et absorbe les appuis
  fermer_clavier
  return 0
}

brief_ok=0
if $UI wait --text "Ma vidéo" --exact --timeout 30 >/dev/null 2>&1; then
  $UI fields > "$OUT/champs_0.txt" 2>&1 || true
  if grep -q "E2E FIELD" "$OUT/champs_0.txt"; then brief_ok=1; fi
fi
if [ "$brief_ok" = "1" ]; then
  record PASS P1_brief "formulaire de brief affiché ($(grep -c 'E2E FIELD' "$OUT/champs_0.txt") champs de saisie détectés)"

  # --- S22n contrôles négatifs (D42.14 : ordre du fondateur) --------------------
  # Objectif : prouver que le formulaire REFUSE la validation vide/invalide et
  # survit au retour arrière — avant de dérouler le chemin valide.
  $UI champs > "$OUT/champs.txt" 2>&1 || true

  atteindre_continuer() { # fait défiler jusqu'au bouton Continuer (6 essais)
    local i
    for i in 1 2 3 4 5 6; do
      if $UI wait --text "Continuer" --exact --timeout 2 >/dev/null 2>&1; then return 0; fi
      swipe_v 73 26 250 >/dev/null 2>&1
      sleep 1
    done
    return 1
  }
  remonter_formulaire() { # retour en haut pour que les coordonnées des champs soient valides
    local i
    for i in 1 2 3; do
      swipe_v 26 73 250 >/dev/null 2>&1
      sleep 1
    done
  }

  # a) Continuer avec tous les champs VIDES : rien ne doit se passer
  if atteindre_continuer; then
    fermer_clavier
    if $UI tap --text "Continuer" --exact --timeout 10 >/dev/null 2>&1; then
      sleep 4
      if $UI wait --text "Avant de commencer" --exact --timeout 4 >/dev/null 2>&1; then
        record FAIL P1_brief_vide_refuse "validation acceptée alors que tous les champs sont vides"
      else
        record PASS P1_brief_vide_refuse "Continuer sans données : formulaire conservé (bouton désactivé ou refus)"
      fi
    else
      record BLOCKED P1_brief_vide_refuse "bouton Continuer introuvable (formulaire vide)"
    fi
  else
    record BLOCKED P1_brief_vide_refuse "bouton Continuer non atteint (champs vides)"
  fi
  remonter_formulaire

  # b) Retour arrière : le formulaire rend la main sans crash, puis re-entrée
  fermer_clavier
  adb shell input keyevent 4 >/dev/null 2>&1
  sleep 3
  shot 22n_retour_arriere; dump 22n_retour_arriere
  if adb shell pidof "$PKG" >/dev/null 2>&1; then
    if $UI wait --text "Ma vidéo" --exact --timeout 8 >/dev/null 2>&1; then
      record PASS P1_brief_retour "retour arrière : application vivante, formulaire toujours affiché"
    else
      # l'écran précédent est affiché : on RE-OUVRE le brief pour poursuivre
      if tap_if "Nouvel arrivage" "" 10 && $UI wait --text "Ma vidéo" --exact --timeout 25 >/dev/null 2>&1; then
        record PASS P1_brief_retour "retour arrière : écran précédent atteint, brief ré-ouvert sans crash"
      else
        record BLOCKED P1_brief_retour "retour arrière effectué mais brief non ré-ouvrable"
      fi
    fi
  else
    record FAIL P1_brief_retour "application fermée/crashée après retour arrière"
  fi
  $UI champs > "$OUT/champs.txt" 2>&1 || true

  # c) Données INVALIDES : prix alphabétique — la validation doit refuser
  idx_prix=$(grep "^E2E CHAMP " "$OUT/champs.txt" | grep -i "prix" | awk '{print $3}' | head -1)
  # D42.30 : le brief est plus haut (slot d'erreur réservé par champ + champ
  # pays du numéro international) — le Prix peut être sous le pli au listage
  # (retour arrière → écran en haut). Faire défiler puis RELISTER.
  if [ -z "$idx_prix" ]; then
    for essai_scroll in 1 2 3; do
      swipe_v 73 43 300 >/dev/null 2>&1; sleep 1
      # D42.30-11 : $UI fields produit des lignes « E2E FIELD » (sans libellé)
      # que le grep « ^E2E CHAMP » ne matche JAMAIS — d'où le BLOCKED
      # « champ Prix introuvable » (runs 09d3e74/05ca482). Le scanner à
      # utiliser est $UI champs (lignes « E2E CHAMP … |libellé| »).
      $UI champs > "$OUT/champs.txt" 2>&1 || true
      idx_prix=$(grep "^E2E CHAMP " "$OUT/champs.txt" | grep -i "prix" | awk '{print $3}' | head -1)
      [ -n "$idx_prix" ] && break
    done
  fi
  if [ -n "$idx_prix" ]; then
    remplir_champ "$idx_prix" "abc"
    if atteindre_continuer; then
      fermer_clavier
      if $UI tap --text "Continuer" --exact --timeout 10 >/dev/null 2>&1; then
        sleep 4
        if $UI wait --text "Avant de commencer" --exact --timeout 4 >/dev/null 2>&1; then
          record FAIL P1_brief_invalide_refuse "validation acceptée avec un prix alphabétique"
        else
          record PASS P1_brief_invalide_refuse "prix « abc » : validation refusée"
        fi
      else
        record PASS P1_brief_invalide_refuse "prix « abc » : bouton Continuer inutilisable"
      fi
    else
      record BLOCKED P1_brief_invalide_refuse "bouton Continuer non atteint (prix invalide)"
    fi
    # le prix invalide sera écrasé par le remplissage valide (remplir_champ efface avant de saisir)
  else
    record BLOCKED P1_brief_invalide_refuse "champ Prix introuvable"
  fi
  # D42.14 (run 42246994818) : le contrôle invalide laisse « abc » dans le prix
  # et le remplissage valide ne traite que les champs VIDES — la validation
  # finale échouait pour un champ que NOUS avions sali. On vide le champ.
  if [ -n "${idx_prix:-}" ]; then
    remplir_champ "$idx_prix" "" || true
  fi
  remonter_formulaire
  $UI champs > "$OUT/champs.txt" 2>&1 || true

  # Remplissage PILOTÉ PAR LE LIBELLÉ de chaque champ (pas par l'index : l'écran
  # défile pendant la saisie et les valeurs se décalaient — run 42223776656).
  valeur_pour() { # libellé -> valeur valide pour ce champ
    local l
    l=$(echo "$1" | tr 'A-Z' 'a-z')
    case "$l" in
      *commerce*|*boutique*)            echo "BoutiqueAwa" ;;
      *whatsapp*|*num*ro*|*t*l*phone*)  echo "0197000000" ;;
      *prix*|*montant*)                 echo "15000" ;;
      *monnaie*)                        echo "" ;;   # déjà préremplie (FCFA)
      *quartier*|*ville*|*adresse*)     echo "Akpakpa" ;;
      *nom*|*v*tement*|*produit*|*plat*|*travail*|*article*) echo "RobeWax" ;;
      *)                                echo "Essai" ;;
    esac
  }
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
      if [ -z "$val" ]; then echo "E2E champ laissé prérempli : [$libelle]"; continue; fi
      echo "E2E remplissage [$libelle] <- $val"
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
  echo "E2E champs remplis : $remplis"
  # D42.14 (run 42264313164) : le quartier — sous le clavier pendant la saisie
  # du prix — n'etait pas dans les dumps et restait vide : la validation
  # echouait UNE FOIS SUR DEUX. Passe de completion : tout champ requis encore
  # vide est rempli directement, avec defilement si necessaire.
  for passe in 1 2 3; do
    # révéler le BAS du formulaire (quartier) : à la position de saisie du
    # prix, il est sous le pli et absent des dumps (cause du 4/5 récurrent).
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
      echo "E2E complément [$libelle] <- $val"
      remplir_champ "$idx" "$val" "$OUT/champs.txt" && remplis=$((remplis+1))
      break
    done < <(grep "^E2E CHAMP " "$OUT/champs.txt")
    # On ne s'arrête jamais avant la passe 2 : à la passe 1 (haut du
    # formulaire), le quartier est SOUS LE PLI et « restant=0 » est un faux
    # « tout est rempli » (mesuré : 4/5 trois runs de suite).
    [ "$restant" = "0" ] && [ "$passe" -ge 2 ] && break
  done
  echo "E2E champs remplis (après complément) : $remplis"
  $UI champs > "$OUT/champs_apres.txt" 2>&1 || true
  cat "$OUT/champs_apres.txt" | sed 's/^/E2E /'
  # Le bouton est en bas d'un écran défilant. On descend PAR PAS en vérifiant
  # après chaque geste qu'il est réellement apparu (un nombre fixe de glissements
  # ne garantit rien : le run 42205571080 est resté bloqué en haut du formulaire).
  trouve=0
  for _ in 1 2 3 4 5 6; do
    if $UI wait --text "Continuer" --exact --timeout 2 >/dev/null 2>&1; then trouve=1; break; fi
    swipe_v 73 26 250 >/dev/null 2>&1
    sleep 1
  done
  shot 22b_brief_bas; dump 22b_brief_bas
  [ "$trouve" = "1" ] || echo "E2E bouton Continuer non atteint après 6 glissements"
  if $UI tap --text "Continuer" --exact --timeout 15 >/dev/null 2>&1; then
    if $UI wait --text "Avant de commencer" --exact --timeout 25 >/dev/null 2>&1; then
      record PASS P1_brief_valide "brief accepté → écran « Avant de commencer »"
      shot 22c_ready; dump 22c_ready
    else
      record FAIL P1_brief_valide "bouton Continuer actionné mais écran de vérification absent (champ invalide ?)"
    fi
  else
    record FAIL P1_brief_valide "bouton Continuer introuvable en bas du formulaire"
  fi
else
  record BLOCKED P1_brief "formulaire de brief non atteint (voir dump 21)"
  record BLOCKED P1_brief_valide "brief non affiché"
fi

# écran « Avant de commencer » -> caméra
$UI tap --text "OK, je commence" --exact --timeout 15 >/dev/null 2>&1 || true
sleep 3
shot 23_camera; dump 23_camera

# --- S23 caméra guidée ---------------------------------------------------------
# Deux écrans se succèdent : le GUIDE (« Filme ta prise » + bouton « Tourner »)
# puis la CAPTURE (CameraGuideActivity : `camera_preview` + `camera_record_button`
# dont le libellé devient « Arrêter et continuer » pendant l'enregistrement).
if $UI wait --text "Filme ta prise" --timeout 40 >/dev/null 2>&1; then
  record PASS P1_camera_ecran "écran « Filme ta prise » affiché (caméra virtuelle de l'émulateur)"
  shot 24_camera_ecran; dump 24_camera_ecran
else
  record BLOCKED P1_camera_ecran "écran caméra non atteint (voir dump 23)"
fi

# Aucun dialogue de consentement ne doit apparaître sans visage détecté
if $UI wait --text "Accord du client" --timeout 4 >/dev/null 2>&1; then
  record FAIL P1_porte_r4_intempestive "porte R4 affichée alors qu'aucun visage n'est filmé"
  $UI tap --text "Oui, accord confirmé" --exact --timeout 5 >/dev/null 2>&1 || true
else
  record PASS P1_porte_r4 "aucune porte de consentement affichée sans visage"
fi

prise() { # numéro
  local n="$1"
  # 1) depuis le guide, lancer la capture
  $UI tap --text "Tourner" --exact --timeout 12 >/dev/null 2>&1 || true
  # 2) attendre la vraie caméra
  if ! $UI wait --id "camera_record_button" --timeout 30 >/dev/null 2>&1; then
    return 1
  fi
  if ! $UI tap --text "Verrouiller et enregistrer" --exact --timeout 10 >/dev/null 2>&1; then
    $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1 || return 1
  fi
  # 3) l'enregistrement est prouvé par le CHANGEMENT de libellé du bouton.
  #    D42.16 : la scène virtuelle de l'émulateur contient des « visages »
  #    (affiches murales) — la porte R4 produit alors le dialogue de
  #    consentement AVANT d'enregistrer. C'est le comportement produit réel
  #    (un commerçant qui filme un client confirme l'accord) : le parcours
  #    l'assume au lieu de tapoter à l'aveugle à côté du dialogue (les runs
  #    42278038365/42281822052 : le 2e appui tombait par hasard sur
  #    « Oui, accord confirmé » sans que le harnais le sache).
  if ! $UI wait --text "Arrêter et continuer" --exact --timeout 8 >/dev/null 2>&1; then
    if $UI wait --text "Accord du client" --timeout 8 >/dev/null 2>&1; then
      record PASS "P1_r4_consentement_${n}" "porte R4 affichée (visage détecté dans la scène émulée) — accord confirmé comme le ferait un commerçant réel"
      $UI tap --text "Oui, accord confirmé" --exact --timeout 8 >/dev/null 2>&1 || true
    fi
    if ! $UI wait --text "Arrêter et continuer" --exact --timeout 25 >/dev/null 2>&1; then
      return 2
    fi
  fi
  sleep 6
  shot "25_prise_${n}_enregistrement"
  $UI tap --text "Arrêter et continuer" --exact --timeout 10 >/dev/null 2>&1 || return 3
  # 4) la reprise en main est prouvée par le retour de « Tourner »/« Verrouiller ».
  #    D42.30-11 (RCA 05ca482) : après la DERNIÈRE prise d'un gabarit (T4/T5
  #    mode = 2 prises — marqueurs VV_E2E : Finalize hasError=false puis
  #    onActivityResult req=14 result=-1 135 ms plus tard), l'app va
  #    LÉGITIMEMENT à l'aperçu : c'est une issue VALIDE, pas un échec.
  sleep 5
  if $UI wait --text "Tourner" --exact --timeout 25 >/dev/null 2>&1 \
     || $UI wait --text "Verrouiller et enregistrer" --exact --timeout 10 >/dev/null 2>&1 \
     || $UI wait --text "Refaire" --exact --timeout 10 >/dev/null 2>&1; then
    return 0
  fi
  if $UI wait --text "Aperçu de ta vidéo" --timeout 10 >/dev/null 2>&1 \
     || $UI wait --text "Créer ma vidéo" --timeout 10 >/dev/null 2>&1; then
    echo "E2E prise $n : DERNIÈRE prise du gabarit — guide terminé, aperçu atteint (comportement app correct)"
    return 0
  fi
  return 4
}

prises=0
for n in 1 2; do
  prise "$n"; rc=$?
  case $rc in
    0) prises=$((prises+1)); record PASS "P1_prise_$n" "caméra émulée : enregistrement démarré, arrêté, application reprise" ;;
    1) record BLOCKED "P1_prise_$n" "bouton d'enregistrement introuvable (dump 24)" ;;
    2) record FAIL "P1_prise_$n" "appui sur le bouton sans passage en enregistrement" ;;
    3) record FAIL "P1_prise_$n" "arrêt de l'enregistrement impossible" ;;
    *) record FAIL "P1_prise_$n" "application non revenue à l'écran de guidage après la prise" ;;
  esac
  shot "26_prise_${n}_faite"; dump "26_prise_${n}_faite"
  $UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1 || true
  sleep 3
done
[ "$prises" -ge 1 ] && record PASS P1_prises "$prises prise(s) enregistrée(s) sur caméra émulée" \
                    || record BLOCKED P1_prises "aucune prise enregistrée"
sleep 3
shot 27_apres_prises; dump 27_apres_prises

# --- S24b completer_guide (D42.16, défauts A5/H13) ------------------------------
# Le gabarit exige N prises (badge « PRISE n/N ») ; la boucle ci-dessus en filme
# 2 par le bouton classique. Si l'écran « Filme ta prise » est ENCORE affiché,
# le parcours n'est pas terminé (runs 42278038365/42281822052/42292290440 :
# l'application restait sur PRISE 3/3 et l'export n'était jamais atteint).
# On termine le guide COMME UN COMMERÇANT : filmer les prises manquantes, puis
# faire défiler la colonne pour amener « Suivant » DANS l'écran (cmd_tap tape
# le centre des bornes même hors écran : un code retour 0 ne prouve pas un clic
# utile), cliquer le libellé exact, et vérifier l'écran SUIVANT.
completer_guide() {
  # 1) encore sur le guide ?
  if ! $UI wait --text "Filme ta prise" --timeout 6 >/dev/null 2>&1; then
    echo "E2E guide déjà quitté : rien à compléter"
    return 0
  fi
  # 2) prises exigées (badge « PRISE n/N ») et prises déjà en fichiers
  local badge requis rush_count cycle i
  rush_count=$(app_ls files/rushes | tr -d '\r' | grep -c '^rush-')
  requis=$($UI probe 2>/dev/null | grep -o 'PRISE [0-9]*/[0-9]*' | head -1 | sed 's|.*/||')
  case "$requis" in ''|*[!0-9]*) requis=3 ;; esac
  echo "E2E guide : $rush_count prise(s) en fichiers, $requis exigée(s) par le gabarit"
  # 3) filmer les prises manquantes (max 4 cycles), par le bouton classique
  cycle=0
  while [ "$rush_count" -lt "$requis" ] && [ "$cycle" -lt 4 ]; do
    cycle=$((cycle+1))
    if ! $UI wait --id "camera_record_button" --timeout 20 >/dev/null 2>&1; then
      echo "E2E completer : bouton d'enregistrement introuvable (cycle $cycle)"
      break
    fi
    $UI tap --text "Verrouiller et enregistrer" --exact --timeout 10 >/dev/null 2>&1 \
      || $UI tap --id "camera_record_button" --timeout 8 >/dev/null 2>&1 || true
    # porte R4 éventuelle (scène émulée = visages sur les affiches)
    if ! $UI wait --text "Arrêter et continuer" --exact --timeout 8 >/dev/null 2>&1; then
      if $UI wait --text "Accord du client" --timeout 8 >/dev/null 2>&1; then
        record PASS "P1_r4_consentement_c${cycle}" "porte R4 (complétion cycle $cycle) — accord confirmé"
        $UI tap --text "Oui, accord confirmé" --exact --timeout 8 >/dev/null 2>&1 || true
      fi
      $UI wait --text "Arrêter et continuer" --exact --timeout 25 >/dev/null 2>&1 || break
    fi
    sleep 6
    $UI tap --text "Arrêter et continuer" --exact --timeout 10 >/dev/null 2>&1 || break
    sleep 4
    rush_count=$(app_ls files/rushes | tr -d '\r' | grep -c '^rush-')
    echo "E2E completer : cycle $cycle -> $rush_count prise(s) en fichiers"
    # après la DERNIÈRE prise exigée, l'application avance seule (finishWithPrises)
    $UI wait --text "Filme ta prise" --timeout 6 >/dev/null 2>&1 || break
  done
  # 4-6) guide toujours affiché : défiler pour révéler « Suivant », vérifier sa
  #      visibilité RÉELLE (inside), puis cliquer le libellé exact
  if $UI wait --text "Filme ta prise" --timeout 4 >/dev/null 2>&1; then
    for i in 1 2 3 4 5 6; do
      $UI inside --text "Suivant" --exact --timeout 3 >/dev/null 2>&1 && break
      swipe_v 73 21 300 >/dev/null 2>&1
      sleep 1
    done
    if $UI inside --text "Suivant" --exact --timeout 3 >/dev/null 2>&1; then
      $UI tap --text "Suivant" --exact --timeout 8 >/dev/null 2>&1
      sleep 3
    else
      echo "E2E completer : « Suivant » jamais révélé par le défilement"
    fi
  fi
  # 7-9) l'écran SUIVANT fait foi : le guide doit avoir disparu, captures à l'appui
  if $UI wait --text "Filme ta prise" --timeout 6 >/dev/null 2>&1; then
    record FAIL P1_guide_termine "guide toujours affiché après complétion (prise manquante ou « Suivant » inopérant — dump 26z)"
    shot 26z_guide_bloque; dump 26z_guide_bloque
    return 1
  fi
  rush_count=$(app_ls files/rushes | tr -d '\r' | grep -c '^rush-')
  record PASS P1_guide_termine "guide terminé : $rush_count prise(s) en fichiers, écran suivant atteint"
  shot 26z_guide_termine; dump 26z_guide_termine
  return 0
}
completer_guide

# D42.16 : preuve FICHIER — un libellé qui bascule ne prouve pas un rush
# exploitable. Debug : run-as (F50) ; release : adb root (émulateur AOSP).
app_ls files/rushes -l > "$OUT/27_rushes.txt" 2>&1 || true
if grep -q "rush-" "$OUT/27_rushes.txt" 2>/dev/null; then
  record PASS P1_rushs_fichiers "fichiers rush-*.mp4 présents et non vides dans files/rushes (voir 27_rushes.txt)"
else
  record FAIL P1_rushs_fichiers "aucun fichier rush dans files/rushes (voir 27_rushes.txt)"
fi
# Chronologie observable laissée par l'app (tag VV_E2E, défaut D5).
adb logcat -d -s VV_E2E > "$OUT/27_vv_e2e_markers.log" 2>&1 || true

# --- S25 export ----------------------------------------------------------------
# E7 (« Aperçu de ta vidéo ») porte « Créer ma vidéo » (e7_create), en bas d'une
# colonne défilante (vignette 9:16). Ce bouton bascule vers l'UI d'export (E8)
# qui porte « Lancer l'export local », elle aussi en bas d'un ScrollView. Règle
# D42.16 : cmd_tap renvoie 0 même hors écran — défiler jusqu'à visibilité
# RÉELLE (inside) puis taper le libellé exact, et prouver l'écran suivant.
# Run 42350538945 : 6 défilements laissaient « Créer ma vidéo » à 2 px du bas
# ([410,2070][670,2072]) — inside exige >8 px, à juste titre. Budget 12 cycles.
# Run 42352327163 : 12 cycles ne changent RIEN — la colonne s'arrête ~172 px
# avant sa fin car les grands swipes traversent la vignette vidéo (zone de
# geste du lecteur ▶) qui interrompt le défilement. Remèdes : petits drags
# lents SOUS la vignette, puis tap sur le nœud matérialisé — LA PREUVE RESTE
# L'ÉCRAN SUIVANT, jamais le rc du tap.
revele() {  # $1 = libellé exact -> rc 0 si entièrement visible
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
if $UI wait --text "Aperçu de ta vidéo" --timeout 30 >/dev/null 2>&1 || $UI wait --text "export" --timeout 10 >/dev/null 2>&1; then
  record PASS P1_apercu_export "écran d'aperçu E7 atteint"
  shot 28_apercu; dump 28_apercu
  if revele "Créer ma vidéo"; then etat_btn="révélé"; else etat_btn="partiellement visible"; fi
  $UI tap --text "Créer ma vidéo" --exact --timeout 8 >/dev/null 2>&1
  if $UI wait --text "Lancer l'export local" --timeout 25 >/dev/null 2>&1; then
    record PASS P1_apercu_valide "« Créer ma vidéo » ($etat_btn) actionné : UI d'export (E8) affichée"
  else
    record FAIL P1_apercu_valide "« Créer ma vidéo » $etat_btn, tap émis, E8 jamais atteinte"
  fi
  sleep 2
else
  record BLOCKED P1_apercu_export "écran d'aperçu non atteint"
fi
# « Lancer l'export local » est en bas du ScrollView E8 : le révéler, taper,
# puis prouver le démarrage par le statut « Export local en cours… ». Si la
# porte crédits refuse (session locale), le dire — jamais de message trompeur.
if $UI wait --text "Lancer l'export local" --exact --timeout 5 >/dev/null 2>&1; then
  if revele "Lancer l'export local"; then etat_btn2="révélé"; else etat_btn2="partiellement visible"; fi
  $UI tap --text "Lancer l'export local" --exact --timeout 8 >/dev/null 2>&1
  sleep 2
  if $UI wait --text "Export local en cours" --timeout 25 >/dev/null 2>&1; then
    record PASS P1_export_lance "export lancé (statut « Export local en cours… » constaté)"
  elif $UI wait --text "Plus de crédits export disponibles" --timeout 5 >/dev/null 2>&1; then
    record FAIL P1_export_lance "porte crédits : export refusé en session locale (export_gate_no_credit)"
  else
    record FAIL P1_export_lance "bouton $etat_btn2, tap émis, aucun statut de démarrage constaté"
  fi
else
  record BLOCKED P1_export_lance "bouton d'export introuvable (E8 absente ?)"
fi
# --- D42.18 : correctif FGS — notification + survie à l'écran éteint -----------
# Le correctif (ExportWorker en service de premier plan dataSync) doit :
#  (a) poser la notification « Export en cours… » (canal vv_export) ;
#  (b) poursuivre l'encodage écran éteint (promesse T1) — on éteint 45 s,
#      on rallume, et l'état d'export doit rester visible.
sleep 20
if adb shell dumpsys notification 2>/dev/null | grep -q "vv_export"; then
  record PASS P1_notif_fgs "notification du canal vv_export présente (dumpsys)"
else
  record FAIL P1_notif_fgs "aucune notification vv_export (FGS non démarré ?)"
fi
adb shell input keyevent 26 >/dev/null 2>&1
sleep 45
adb shell input keyevent 26 >/dev/null 2>&1
adb shell wm dismiss-keyguard >/dev/null 2>&1
sleep 3
if $UI wait --text "Export local en cours" --timeout 90 >/dev/null 2>&1 \
   || $UI wait --text "Vidéo prête !" --timeout 5 >/dev/null 2>&1; then
  record PASS P1_ecran_etaint "export poursuivi après 45 s d'écran éteint (réveil OK)"
else
  record FAIL P1_ecran_etaint "état d'export invisible après réveil de l'écran"
fi

# D42.17 rc8 : chronologie mesurée — l encodage swiftshader prend 8 à 12 min
# (rc6 : complété à ~8 min, juste après la fenêtre de 8 ; rc7 : tentative 1
# interrompue par le quota JobScheduler de 10 min puis relancée). Fenêtre
# portée à 40 min pour couvrir jusqu à 3-4 tentatives WorkManager.
# D42.28-26 : 75 min (4500 s) — avec la BGM réellement mixée (fix
# configure du BgmDecoder), l export dépasse 40 min sur l émulateur
# (lab 42811778574 : cutoff job à 12:58:19, verdict interne attendu
# 12:58:48) ; le job workflow est passé à timeout-minutes: 110.
if $UI wait --text "Vidéo prête ! Partage-la avec tes clients." --exact --timeout 4500 >/dev/null 2>&1; then
  record PASS P1_export_termine "« Vidéo prête ! » affiché"
  shot 29_export_termine; dump 29_export_termine
else
  record FAIL P1_export_termine "aucune fin d'export en 75 min"; shot 29_export_timeout; dump 29_export_timeout
fi

# --- S26 fichier MP4 (uniquement si l'APK est débuggable) ----------------------
# D42.17 : extraction identique en debug (run-as) et release (adb root sur
# l'émulateur AOSP du lab). Le fichier tiré est celui du moteur de production.
MP4=$(app_ls cache | tr -d '\r' | grep -m1 'export-.*\.mp4' || true)
if [ -n "${MP4:-}" ]; then
  app_cat "cache/$MP4" > "$OUT/export.mp4"
  TAILLE=$(stat -c%s "$OUT/export.mp4" 2>/dev/null || echo 0)
  if [ "${TAILLE:-0}" -gt 0 ]; then
    record PASS P1_mp4_extrait "$MP4 ($TAILLE octets)"
  else
    record FAIL P1_mp4_extrait "$MP4 extrait mais vide (0 octet)"
  fi
else
  record FAIL P1_mp4_extrait "aucun fichier export-*.mp4 dans cache (run-as et adb root consultés)"
fi

# --- S27 partage ---------------------------------------------------------------
# D42.16 (H12) : le libellé réel du bouton est « Partager la vidéo »
# (export_share) — « Partager » en exact ne matchait JAMAIS (BLOCKED systématique).
if $UI tap --text "Partager la vidéo" --exact --timeout 12 >/dev/null 2>&1; then
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
# D42.30-11 (RCA 05ca482) : les collisions « UiAutomationService already
# registered » font CRASHER le processus `uiautomator dump` lui-même
# (com.android.commands.uiautomator) — ces FATAL ne sont PAS des crashs de
# l'app. On ne compte que les FATAL du processus video.vitrine.app.
if adb logcat -d -b crash | grep -A 3 "FATAL EXCEPTION" | grep -q "Process: $PKG"; then
  adb logcat -d -b crash > "$OUT/crash.log"
  record FAIL P1_aucun_crash "FATAL EXCEPTION du processus $PKG (crash.log)"
else
  adb logcat -d -b crash > "$OUT/crash_app_vide_ou_etranger.log" 2>/dev/null || true
  record PASS P1_aucun_crash "aucune FATAL EXCEPTION du processus $PKG"
fi
adb logcat -d > "$OUT/logcat.txt" 2>/dev/null
adb shell dumpsys meminfo "$PKG" 2>/dev/null | head -12 > "$OUT/meminfo.txt"

{ echo "tag=$TAG"; echo "apk=$APK"; echo "sha256=$(sha256sum "$APK" | cut -d' ' -f1)"
  echo "PASS=$pass FAIL=$fail BLOCKED=$blocked"; } > "$OUT/summary.txt"
cat "$OUT/summary.txt"
echo "=========== FIN P1 $TAG : PASS=$pass FAIL=$fail BLOCKED=$blocked ==========="
exit 0
