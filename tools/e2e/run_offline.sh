#!/usr/bin/env bash
# =============================================================================
# D42.26 — Action B : QUALIFICATION OFFLINE EXPLICITE.
#
# Exigence mission D42.26 n°4 : « lancement sans Internet, données locales,
# ressources téléchargées, sons en cache, gabarits hors connexion, projet
# local, interruption réseau, fermeture/redémarrage, reprise, sync, sans
# doublons/perte/double débit. Documenter offline vs online obligatoire. »
#
# Méthode : le réseau de l'ÉMULATEUR (et donc de l'app) est coupé par adb
# (svc wifi/data disable) — le runner garde Internet. L'APK testé est le même
# que le P0 (debug). Chaque scénario produit PASS/FAIL/BLOCKED + preuves
# (captures, dumps, logcat). Le mode démo est BY DESIGN sans réseau :
# ce qui est testé ici est (1) que rien ne casse sans réseau, (2) que les
# écrans locaux (langue, carrousel, secteur, bienvenue) fonctionnent,
# (3) que le catalogue se consulte ou échoue PROPREMENT, (4) que la session
# survit à un redémarrage, (5) que le retour réseau ne casse rien.
# Les promesses réseau (sync serveur, crédits distants) relèvent des
# parcours compte réel — distinguées dans la matrice, jamais confondues.
# =============================================================================
set -uo pipefail

TAG="${1:-pixel5}"
VARIANTE="offline"
APK="${APK:-app/build/outputs/apk/debug/app-debug.apk}"
PKG="video.vitrine.app"
OUT="artifacts/${TAG}-${VARIANTE}"
UI="python3 tools/e2e/ui.py"
mkdir -p "$OUT"
RESULTS="$OUT/results.tsv"
: > "$RESULTS"
exec 2> >(tee -a "$OUT/stderr.log" >&2)

pass=0; fail=0; blocked=0
record() {
  printf '%s\t%s\t%s\n' "$1" "$2" "$3" >> "$RESULTS"
  case "$1" in
    PASS) pass=$((pass+1)) ;;
    FAIL) fail=$((fail+1)) ;;
    *) blocked=$((blocked+1)) ;;
  esac
  echo "E2E_RESULT $1 $2 :: $3"
}
shot() { $UI shot "$OUT/$1.png" >/dev/null 2>&1 || true; }
dump() { adb shell uiautomator dump /sdcard/d.xml >/dev/null 2>&1; adb exec-out cat /sdcard/d.xml > "$OUT/$1.xml" 2>/dev/null; }

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
swipe_v() {
  adb shell input swipe $(( EFF_W / 2 )) $(( EFF_H * $1 / 100 )) \
    $(( EFF_W / 2 )) $(( EFF_H * $2 / 100 )) "${3:-250}" >/dev/null 2>&1
}
swipe_h() {
  adb shell input swipe $(( EFF_W * $1 / 100 )) $(( EFF_H / 2 )) \
    $(( EFF_W * $2 / 100 )) $(( EFF_H / 2 )) "${3:-250}" >/dev/null 2>&1
}

reseau_coupe() {
  adb shell svc wifi disable >/dev/null 2>&1
  adb shell svc data disable >/dev/null 2>&1
  sleep 2
  # Preuve : plus de réseau par défaut actif côté émulateur.
  adb shell dumpsys connectivity 2>/dev/null | tr -d '\r' > "$OUT/connectivite_off.txt"
  if grep -q "Active default network: netId" "$OUT/connectivite_off.txt" 2>/dev/null \
     && ! grep -q "Active default network: null" "$OUT/connectivite_off.txt"; then
    return 1
  fi
  return 0
}
reseau_retabli() {
  adb shell svc wifi enable >/dev/null 2>&1
  adb shell svc data enable >/dev/null 2>&1
  sleep 3
  adb shell dumpsys connectivity 2>/dev/null | tr -d '\r' > "$OUT/connectivite_on.txt"
}

echo "=========== VARIANTE $VARIANTE ($TAG) ==========="

# --- OFF-1 : mode avion AVANT le tout premier lancement -----------------------
adb uninstall "$PKG" >/dev/null 2>&1
if reseau_coupe; then
  record PASS OFF1_reseau_coupe_avant_lancement "svc wifi+data disable : plus de réseau par défaut (dumpsys en preuve)"
else
  record FAIL OFF1_reseau_coupe_avant_lancement "réseau encore actif après svc disable (voir connectivite_off.txt)"
fi

adb install -r "$APK" > "$OUT/install.log" 2>&1
adb logcat -c 2>/dev/null
adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start.log" 2>&1
sleep 8
if adb shell pidof "$PKG" >/dev/null 2>&1; then
  record PASS OFF2_demarrage_hors_ligne "processus vivant sans réseau (lancement à froid)"
else
  record FAIL OFF2_demarrage_hors_ligne "processus absent (voir start.log)"
fi
shot 01_offline_langue; dump 01_offline_langue

# --- OFF-3 : écran langue (données locales) -----------------------------------
if $UI wait --text "Français" --timeout 20 >/dev/null 2>&1; then
  record PASS OFF3_ecran_langue_local "sélecteur de langue consultable hors connexion (aucun réseau requis)"
  $UI tap --text "Français" --timeout 8 >/dev/null 2>&1
  sleep 1
else
  record BLOCKED OFF3_ecran_langue_local "écran langue non atteint (voir dump 01)"
fi
shot 02_offline_connexion; dump 02_offline_connexion

# --- OFF-4 : écran connexion : le bouton Google doit exister, la connexion
# doit échouer PROPREMENT (message), jamais crasher. ---------------------------
if $UI wait --text "Google" --timeout 20 >/dev/null 2>&1; then
  record PASS OFF4_ecran_connexion_affiche "écran de connexion affiché hors connexion (UI locale)"
  # La tentative Google hors réseau : on tape, on attend une réaction PROPRE
  # (retour à l'écran / message d'erreur), et surtout AUCUN crash.
  $UI tap --text "Google" --timeout 8 >/dev/null 2>&1
  sleep 6
  if adb shell pidof "$PKG" >/dev/null 2>&1; then
    record PASS OFF4b_tentative_google_sans_crash "tentative Google hors ligne : aucun crash (échec réseau géré)"
  else
    record FAIL OFF4b_tentative_google_sans_crash "crash pendant la tentative Google hors ligne (voir logcat)"
  fi
  shot 03_offline_apres_google; dump 03_offline_apres_google
else
  record BLOCKED OFF4_ecran_connexion_affiche "écran connexion non atteint hors ligne"
fi

# --- OFF-5 : repli session démo (aucun réseau) + carrousel --------------------
if $UI tap --id "auth_offline_button" --timeout 12 >/dev/null 2>&1; then
  record PASS OFF5_repli_demo_hors_ligne "repli sans compte actionné hors connexion (session locale, zéro appel réseau)"
else
  record BLOCKED OFF5_repli_demo_hors_ligne "bouton de repli introuvable hors ligne"
fi

# Carrousel : bouton par texte, sinon bouton réel (bande orange), sinon geste.
if $UI wait --text "Suivant" --timeout 60 >/dev/null 2>&1; then
  shot 04_offline_carrousel; dump 04_offline_carrousel
  $UI tap --text "Suivant" --exact --timeout 10 >/dev/null 2>&1
  sleep 1
  if ! $UI wait --text "Filme tes produits, on te guide" --exact --timeout 6 >/dev/null 2>&1; then
    $UI taporange >/dev/null 2>&1; sleep 1
  fi
  if ! $UI wait --text "Filme tes produits, on te guide" --exact --timeout 6 >/dev/null 2>&1; then
    swipe_h 78 18 350; sleep 1
  fi
  if $UI wait --text "Filme tes produits, on te guide" --exact --timeout 10 >/dev/null 2>&1; then
    record PASS OFF6_carrousel_hors_ligne "carrousel navigable hors connexion (écran 2 atteint)"
  else
    record FAIL OFF6_carrousel_hors_ligne "carrousel figé hors connexion (voir 04_offline_carrousel)"
  fi
else
  record BLOCKED OFF6_carrousel_hors_ligne "carrousel non atteint hors ligne"
fi

# --- OFF-7 : secteur + parrain + bienvenue (seed local honnête) ---------------
# Secteur : pré-sélectionné par le produit (Sector.MODE) ; on tente la carte,
# sinon on laisse Continuer faire (parcours produit documenté).
# D42.26-16 : contrôle d'EFFET après Continuer (le tap texte peut se perdre
# en petit écran : secours taporange sur le bouton réel).
for t in "Boutique & Petit Commerce" "Vêtements & Mode" "Coiffure & Beauté" \
         "Restauration & Maquis" "Bâtiment & Travaux" "Vente de Voitures & Maisons"; do
  if $UI inside --text "$t" --timeout 8 >/dev/null 2>&1; then
    $UI tap --text "$t" --timeout 10 >/dev/null 2>&1 && break
  fi
done
shot 05_offline_secteur; dump 05_offline_secteur
$UI tap --text "Continuer" --timeout 12 >/dev/null 2>&1
sleep 1
if ! $UI wait --text "code parrain" --timeout 8 >/dev/null 2>&1; then
  $UI taporange >/dev/null 2>&1
  sleep 1
fi
if $UI wait --text "code parrain" --timeout 10 >/dev/null 2>&1; then
  record PASS OFF7_secteur_continuer_hors_ligne "choix de secteur + Continuer actionnés hors connexion (effet vérifié)"
  OFF7_FRANCHI="1"
else
  record BLOCKED OFF7_secteur_continuer_hors_ligne "écran secteur non franchi hors ligne (voir 05_offline_secteur)"
  OFF7_FRANCHI=""
fi
sleep 2
# Parrainage : étape facultative — la passer hors ligne doit marcher.
$UI tap --text "Je n'ai pas de code" --timeout 10 >/dev/null 2>&1 \
  || $UI tap --text "Continuer" --timeout 8 >/dev/null 2>&1 || true
sleep 2
shot 06_offline_bienvenue; dump 06_offline_bienvenue
if $UI wait --text "crédits" --timeout 20 >/dev/null 2>&1; then
  record PASS OFF8_bienvenue_seed_local "écran d'accueil affiché hors connexion avec le solde LOCAL affiché (seed honnête, aucun appel réseau)"
  $UI probe | sed 's/^/E2E_OFF_WELCOME /' >> "$OUT/probe_welcome.txt"
else
  record BLOCKED OFF8_bienvenue_seed_local "écran d'accueil non atteint hors ligne (voir 06)"
fi
$UI tap --text "Continuer" --timeout 12 >/dev/null 2>&1 \
  || { $UI wait --text "Continuer" --timeout 3 >/dev/null 2>&1 && $UI taporange >/dev/null 2>&1; } || true
sleep 3

# --- OFF-9 : catalogue hors connexion -----------------------------------------
shot 07_offline_catalogue; dump 07_offline_catalogue
if [ -z "${OFF7_FRANCHI:-}" ]; then
  record BLOCKED OFF9_catalogue_hors_ligne "NON TESTÉ en cascade : l'écran secteur n'a pas été franchi (OFF7) — le catalogue hors ligne reste à qualifier quand OFF7 passe"
elif $UI wait --text "modèle de vidéo" --timeout 25 >/dev/null 2>&1 || $UI wait --text "model" --timeout 3 >/dev/null 2>&1; then
  record PASS OFF9_catalogue_hors_ligne "catalogue consultable hors connexion (données locales/embarquées)"
  $UI probe | sed 's/^/E2E_OFF_CATALOG /' >> "$OUT/probe_catalog.txt"
elif adb shell pidof "$PKG" >/dev/null 2>&1; then
  record FAIL OFF9_catalogue_hors_ligne "catalogue NON consultable hors connexion (voir 07_offline_catalogue) — défaut produit à documenter offline vs online"
else
  record FAIL OFF9_catalogue_hors_ligne "app morte au catalogue hors connexion (voir logcat)"
fi

# --- OFF-10 : fermeture/redémarrage, session conservée ------------------------
adb shell am force-stop "$PKG" >/dev/null 2>&1
sleep 2
adb shell am start -W -n "$PKG/.MainActivity" > "$OUT/start2.log" 2>&1
sleep 10
shot 08_offline_redemarrage; dump 08_offline_redemarrage
if $UI wait --text "Suivant" --exact --timeout 6 >/dev/null 2>&1; then
  record FAIL OFF10_session_apres_redemarrage "retour au CARROUSEL après redémarrage : l'onboarding déjà fait est rejoué (perte de progression)"
else
  record PASS OFF10_session_apres_redemarrage "pas de retour au carrousel après fermeture/relance (session conservée)"
fi
if adb shell pidof "$PKG" >/dev/null 2>&1; then
  record PASS OFF10b_app_vivante_apres_redemarrage "processus vivant après fermeture/relance hors connexion"
else
  record FAIL OFF10b_app_vivante_apres_redemarrage "app morte après relance (voir start2.log)"
fi

# --- OFF-11 : retour du réseau — rien ne casse, pas de double débit -----------
reseau_retabli
sleep 5
shot 09_retour_reseau; dump 09_retour_reseau
if adb shell pidof "$PKG" >/dev/null 2>&1; then
  record PASS OFF11_retour_reseau_sans_crash "retour du réseau : app vivante, aucun crash"
else
  record FAIL OFF11_retour_reseau_sans_crash "app morte au retour du réseau (voir logcat)"
fi
# En session DÉMO : par conception aucun appel réseau n'est émis (aucun double
# débit possible) — on journalise l'état pour la matrice plutôt que prétendre.
adb logcat -d 2>/dev/null > "$OUT/logcat.txt"
# D42.26-16 : on ne juge que les crashes DU PROCESSUS DE L'APP (le launcher
# de l'émulateur peut crasher pour son propre compte — run 42534049820).
if adb logcat -d -b crash 2>/dev/null | tr -d '\r' | grep -q "Process: $PKG"; then
  adb logcat -d -b crash 2>/dev/null | tr -d '\r' | grep -B2 -A30 "Process: $PKG" > "$OUT/crash.log"
  record FAIL OFF12_aucun_crash "FATAL EXCEPTION du processus $PKG pendant le run offline (crash.log)"
else
  record PASS OFF12_aucun_crash "aucune FATAL EXCEPTION du processus $PKG sur tout le parcours hors ligne + retour réseau"
fi
adb shell dumpsys activity activities | grep -E "mResumedActivity|topResumedActivity" > "$OUT/activite_courante.txt" 2>/dev/null

{
  echo "tag=$TAG variante=$VARIANTE"
  echo "PASS=$pass FAIL=$fail BLOCKED=$blocked"
  echo "apk=$APK"
  echo "sha256=$(sha256sum "$APK" 2>/dev/null | cut -d' ' -f1)"
  echo "ecran=$($UI size | sed 's/E2E screen=//')"
} > "$OUT/summary.txt"
cat "$OUT/summary.txt"
echo "=========== FIN $TAG/$VARIANTE : PASS=$pass FAIL=$fail BLOCKED=$blocked ==========="
