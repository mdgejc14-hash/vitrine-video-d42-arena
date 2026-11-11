#!/usr/bin/env bash
# =============================================================================
# D42 — exécution d'un lot de rendus de production sur émulateur.
#
# Appelé par android-emulator-runner, qui exécute chaque LIGNE du `script:`
# dans un shell distinct : d'où ce fichier, unique ligne de commande.
#
#   bash .github/scripts/d42-render.sh <mode> <langue> <gabarits> <sortie> \
#        [timeout] [badge] [profil] [limite] [shard] [shards_total] \
#        [audio_mode] [bgm_source] [offline]
#
#   mode      smoke | matrix
#   langue    fr | en | es | ja
#   gabarits  all | T1 | restaurants_maquis_T1,...
#   sortie    dossier local recevant MP4 + manifestes
#   badge     none | stock_limite | places_limitees | qualite_garantie
#   profil    production (1080x1920) | validation (540x960, meme chaine)
#   limite    plafond de rendus pour ce job (0 = aucun)
#   shard     indice du lot, 1-based (vide = pas de decoupage)
#   shards_tot nombre total de lots (vide = pas de decoupage)
#   audio_mode  mix (rushs audio + BGM) | musique (rushs MUETS + BGM gain
#               solo) | voix (rushs audio, cache BGM VIDE) — D42.29 P3
#   bgm_source  fixtures (assets, -39 dB, diagnostic) | titulaires (pistes de
#               PRODUCTION musique_t1_* poussees en cache, ~-16 dB) — D42.29 P2
#   offline     1 = couper le réseau (svc wifi+data) PENDANT le rendu, preuves
#               DB/journal/solde/sync au retour — D42.29 P4
#
# D42.3 — SEPARATION DES NOTIONS : le filtre de gabarit (3e argument) et le
# decoupage en lots (9e et 10e) sont independants. Le workflow passait
# « shard:1/8 » dans l'argument des gabarits : le filtre etait perdu, les 30
# gabarits restaient candidats et le premier venu etait rendu.
#
# Aucun moteur de test : l'APK PUBLIÉ est instrumenté tel quel, le rendu passe
# par ExportActivity → ExportWorker → Transformer (Media3).
#
# D42.29 (P2) — INSTRUMENTATION PAR ÉTAGES, pour distinguer une panne de rendu
# vidéo (GPU logiciel swiftshader) d'une absence de musique :
#   étage 1  décodeur  : logs D42-BGM (BgmDecoder — échantillons, RMS, durée) ;
#   étage 2  mixeur    : logs D42-MIX (BgmSfxAudioMixer — trames musique,
#                        RMS voix, cues SFX, dégradé) ;
#   étage 3  rendu     : symptômes vidéo (Forcing EOS, Surface unknown buffer)
#                        collectés du logcat ;
#   étage 4  MP4 final : ffprobe + décodage intégral + fenêtres RMS mesurées
#                        (audio_mesures.tsv) — la musique ne dépend PAS de la
#                        résolution vidéo : un rendu 540x960 complet avec
#                        musique audible prouve la chaîne audio entière.
# =============================================================================
set -euo pipefail

MODE="${1:?mode requis}"
LANGUE="${2:?langue requise}"
GABARITS="${3:-all}"
SORTIE="${4:-rendus}"
TIMEOUT_S="${5:-900}"
BADGE="${6:-none}"
PROFIL="${7:-production}"
LIMITE="${8:-0}"
SHARD="${9:-}"
SHARDS_TOTAL="${10:-}"
AUDIO_MODE="${11:-mix}"
BGM_SOURCE="${12:-fixtures}"
OFFLINE="${13:-0}"

case "$AUDIO_MODE" in mix|musique|voix) ;; *) echo "::error title=MODE AUDIO INCONNU::$AUDIO_MODE"; exit 2 ;; esac
case "$BGM_SOURCE" in fixtures|titulaires) ;; *) echo "::error title=SOURCE BGM INCONNUE::$BGM_SOURCE"; exit 2 ;; esac
case "$OFFLINE" in 0|1) ;; *) echo "::error title=OFFLINE INCONNU::$OFFLINE"; exit 2 ;; esac

echo "== D42 rendu : mode=$MODE langue=$LANGUE gabarits=$GABARITS badge=$BADGE profil=$PROFIL =="
echo "== D42 lot : indice=${SHARD:-aucun} total=${SHARDS_TOTAL:-aucun} limite=$LIMITE =="
echo "== D42.29 : audio_mode=$AUDIO_MODE bgm_source=$BGM_SOURCE offline=$OFFLINE =="
df -h . | tail -1

# --- ffmpeg/ffprobe : les preuves acoustiques (étage 4) en dépendent ----------
if ! command -v ffprobe >/dev/null 2>&1; then
  echo "ffprobe absent — installation"
  sudo apt-get update -qq >/dev/null 2>&1 || true
  sudo apt-get install -y -qq ffmpeg >/dev/null 2>&1 || {
    echo "::warning title=FFMPEG::installation impossible — preuves acoustiques limitées"
  }
fi
command -v ffprobe >/dev/null 2>&1 && echo "ffprobe=$(ffprobe -version 2>/dev/null | head -1 | cut -d' ' -f3)"

PKG_APP="video.vitrine.app"

# --- package de l'APK de test (jamais deviné quand aapt est disponible) ------
AAPT="$(ls /usr/local/lib/android/sdk/build-tools/*/aapt 2>/dev/null | tail -1 || true)"
TEST_PKG=""
if [ -n "${AAPT}" ] && [ -x "${AAPT}" ]; then
  TEST_PKG="$("${AAPT}" dump badging apk/app-debug-androidTest.apk 2>/dev/null \
    | awk '/^package:/{print $2}' | sed "s/name='//;s/'//" || true)"
fi
TEST_PKG="${TEST_PKG:-video.vitrine.app.test}"
echo "package_de_test=${TEST_PKG}"

# --- installation du VRAI APK + de son instrumentation ----------------------
adb install -r apk/app-debug.apk
adb install -r apk/app-debug-androidTest.apk
echo "sdk=$(adb shell getprop ro.build.version.sdk | tr -d '\r')"
# D42-P4 : le rendu est domine par le GL logiciel (SwiftShader) ; le nombre de
# coeurs vus par le systeme explique une partie du temps par image.
echo "coeurs_guest=$(adb shell nproc | tr -d '\r')"
echo "abi=$(adb shell getprop ro.product.cpu.abi | tr -d '\r')"
echo "modele=$(adb shell getprop ro.product.model | tr -d '\r')"

# --- D42.29 : BGM TITULAIRES de production en cache avant l'instrumentation --
# Le produit ne télécharge le BGM qu'avec un jeton Firebase (session démo sans
# jeton → localFile). Les fixtures d'assets sont à -39 dB RMS (diagnostic) ;
# la preuve d'audibilité n'a de sens que sur les VRAIES pistes (~-16 dB),
# téléchargées côté runner via le compte sonde (même méthode que le P3/banc A).
TITULAIRES_OK=0
if [ "$BGM_SOURCE" = "titulaires" ] && [ "$AUDIO_MODE" != "voix" ]; then
  if [ -z "${FIREBASE_WEB_API_KEY:-}" ]; then
    echo "::error title=TITULAIRES::bgm_source=titulaires exige FIREBASE_WEB_API_KEY (secret du workflow)"
    exit 2
  fi
  SECTEURS_T1="vetements_mode coiffure_beaute restaurants_maquis batiment_travaux immo_auto shops_small_business"
  mkdir -p titulaires
  for s in $SECTEURS_T1; do
    if FIREBASE_WEB_API_KEY="${FIREBASE_WEB_API_KEY}" bash tools/e2e/fetch_bgm_titulaire.sh "musique_t1_${s}" "titulaires/bgm_${s}"; then
      e=$(cat "titulaires/bgm_${s}.ext" | tr -d '\r\n')
      if adb push "titulaires/bgm_${s}.${e}" /data/local/tmp/bgm_t1."$e" >/dev/null 2>&1 \
         && { adb shell run-as "$PKG_APP" mkdir -p files/bgm >/dev/null 2>&1 || true; } \
         && adb shell run-as "$PKG_APP" cp /data/local/tmp/bgm_t1."$e" "files/bgm/musique_t1_${s}.${e}" >/dev/null 2>&1; then
        TITULAIRES_OK=$((TITULAIRES_OK+1))
      fi
    fi
  done
  echo "titulaires_en_cache=${TITULAIRES_OK}/6"
  mkdir -p "${SORTIE}" 2>/dev/null || true
  adb shell run-as "$PKG_APP" ls -la files/bgm 2>/dev/null | tr -d '\r' > "${SORTIE}/titulaires_cache.txt" || true
  if [ "$TITULAIRES_OK" -lt 6 ]; then
    echo "::error title=TITULAIRES::seulement ${TITULAIRES_OK}/6 pistes titulaires en cache — preuve amoindrie, job arrêté"
    exit 2
  fi
fi

# --- D42.29 : coupure réseau AVANT le rendu (preuve hors connexion, P4) -------
COUPURE_FICHIER="${SORTIE}/coupure_reseau.txt"
mkdir -p "${SORTIE}" 2>/dev/null || true
couper_reseau() {
  adb shell svc wifi disable >/dev/null 2>&1 || true
  adb shell svc data disable >/dev/null 2>&1 || true
}
retablir_reseau() {
  adb shell svc wifi enable >/dev/null 2>&1 || true
  adb shell svc data enable >/dev/null 2>&1 || true
}
if [ "$OFFLINE" = "1" ]; then
  {
    echo "=== COUPURE RÉSEAU AVANT RENDU ($(date -u +%Y-%m-%dT%H:%M:%SZ)) ==="
    echo "--- connectivité AVANT :"
    adb shell dumpsys connectivity 2>/dev/null | tr -d '\r' | grep -E "Active default network|no default network" | head -2
  } > "$COUPURE_FICHIER"
  couper_reseau
  sleep 5
  {
    echo "--- connectivité APRÈS svc disable (attendu : no default network) :"
    adb shell dumpsys connectivity 2>/dev/null | tr -d '\r' | grep -E "Active default network|no default network" | head -2
    echo "--- BGM en cache au moment de la coupure :"
    adb shell run-as "$PKG_APP" ls -la files/bgm 2>/dev/null | tr -d '\r'
  } >> "$COUPURE_FICHIER"
  cat "$COUPURE_FICHIER"
fi

# --- instrumentation --------------------------------------------------------
set +e
# D42.14 (06/11/2026, run 42245217052) : le smoke — seul appel SANS shard —
# échouait sur « Error: Invalid userId -2 » aussitôt après l'installation,
# alors que les lots de validation (shard non vide) passaient. Les arguments
# -e à valeur VIDE ne traversent pas intacts la commande adb shell de
# l'image runner actuelle : on ne les transmet que s'ils existent.
ARGS_SHARD=()
if [ -n "${SHARD}" ]; then ARGS_SHARD+=(-e d42_shard "${SHARD}"); fi
if [ -n "${SHARDS_TOTAL}" ]; then ARGS_SHARD+=(-e d42_shards "${SHARDS_TOTAL}"); fi
adb shell am instrument -w -r \
  -e class video.vitrine.d42.ProductionRenderInstrumentedTest \
  -e d42_mode "${MODE}" \
  -e d42_lang "${LANGUE}" \
  -e d42_templates "${GABARITS}" \
  -e d42_timeout_s "${TIMEOUT_S}" \
  -e d42_badge "${BADGE}" \
  -e d42_profile "${PROFIL}" \
  -e d42_limite "${LIMITE}" \
  -e d42_audio_mode "${AUDIO_MODE}" \
  -e d42_bgm_source "${BGM_SOURCE}" \
  "${ARGS_SHARD[@]}" \
  "${TEST_PKG}/androidx.test.runner.AndroidJUnitRunner" 2>&1 | tee instrumentation.txt
STATUT_INSTRUMENTATION=$?
set -e

# Un échec d'instrumentation ne doit jamais produire un job vert — et doit
# laisser des preuves exploitables (logcat complet + crash + worker).
if ! grep -q "^OK (" instrumentation.txt; then
  echo "::error title=INSTRUMENTATION EN ECHEC::voir instrumentation.txt (code ${STATUT_INSTRUMENTATION})"
  mkdir -p "${SORTIE}"
  [ "$OFFLINE" = "1" ] && retablir_reseau || true
  adb logcat -d > "${SORTIE}/logcat-complet.txt" 2>&1 || true
  adb logcat -d -b crash > "${SORTIE}/logcat-crash.txt" 2>&1 || true
  adb shell dumpsys activity processes > "${SORTIE}/dumpsys-processes.txt" 2>&1 || true
  adb exec-out run-as video.vitrine.app cat cache/export-1.mp4 > "${SORTIE}/cache-export-1.mp4" 2>/dev/null || true
  cp instrumentation.txt "${SORTIE}/" 2>/dev/null || true
  grep -iE "ExportWorker|D42|vitrine" "${SORTIE}/logcat-complet.txt" | tail -120 || true
  tail -40 instrumentation.txt
  exit 1
fi

# --- récupération des preuves ----------------------------------------------
mkdir -p "${SORTIE}"
# API 30+ restreint /sdcard/Android/data vu du shell : repli run-as (APK debug).
if ! adb pull /sdcard/Android/data/video.vitrine.app/files/d42 "${SORTIE}/" 2>/dev/null; then
  echo "pull direct refusé — repli run-as"
  adb exec-out run-as video.vitrine.app tar -cf - files/d42 \
    | tar -xf - -C "${SORTIE}" --strip-components=2
fi

# Sortie partielle du worker (cacheDir) : preuve du travail réellement accompli,
# indispensable quand le rendu ne rend pas la main.
adb exec-out run-as video.vitrine.app cat cache/export-1.mp4 > "${SORTIE}/cache-export-1.mp4" 2>/dev/null || true
echo "cache-export-1.mp4 : $(stat -c%s "${SORTIE}/cache-export-1.mp4" 2>/dev/null || echo 0) octets"
adb logcat -d | grep -E "D42-RENDER|D42-VERIF|D42-TRACE|D42-BGM|D42-MIX|ExportWorker|Transformer" > "${SORTIE}/logcat.txt" || true
mv instrumentation.txt "${SORTIE}/" 2>/dev/null || true

# D42.29 (P2, étage 3) : symptômes du rendu vidéo logiciel — comptés, pas juste
# affichés. Un calage GPU (Forcing EOS/Surface unknown buffer) avec compteurs
# audio sains = panne de rendu, PAS une absence de musique.
{
  echo "=== symptômes rendu vidéo (swiftshader) ==="
  echo "forcing_eos=$(adb logcat -d 2>/dev/null | grep -c 'Forcing EOS' || true)"
  echo "surface_unknown_buffer=$(adb logcat -d 2>/dev/null | grep -c 'Surface: unknown buffer' || true)"
  echo "=== étage 1 : décodeur BGM (D42-BGM) ==="
  adb logcat -d 2>/dev/null | grep "D42-BGM" || echo "(aucune ligne D42-BGM)"
  echo "=== étage 2 : mixeur (D42-MIX) ==="
  adb logcat -d 2>/dev/null | grep "D42-MIX" || echo "(aucune ligne D42-MIX)"
} > "${SORTIE}/compteurs_etages.txt" 2>&1 || true
cat "${SORTIE}/compteurs_etages.txt"

# --- D42.29 (P4) : preuves offline + retour réseau + sync --------------------
if [ "$OFFLINE" = "1" ]; then
  # base locale AVANT retour réseau (journal, solde, télémétrie outbox)
  adb exec-out run-as "$PKG_APP" tar -cf - databases 2>/dev/null | tar -xf - -C "${SORTIE}" 2>/dev/null || true
  [ -f "${SORTIE}/databases/vitrine-local.db" ] && cp "${SORTIE}/databases/vitrine-local.db" "${SORTIE}/db_avant_retour.sqlite" || true
  retablir_reseau
  # D42.29 : attendre une connectivite REELLE avant de declencher le flush (la
  # reassociation wifi de l'emulateur peut prendre 10-25 s ; une tentative de
  # POST trop tot echoue silencieusement et laisse la file durable en attente).
  echo "--- attente connectivite apres retablissement (max 60 s) ---"
  for _i in $(seq 1 30); do
    _actif="$(adb shell dumpsys connectivity 2>/dev/null | grep -m1 'Active default network' | tr -d '\r' || true)"
    echo "${_actif:-Active default network: ?}"
    case "$_actif" in ""|*none*|*"?"*) sleep 2 ;; *) break ;; esac
  done
  # le dashboard déclenche BackendSync.flushPending (télémétrie + quotas +
  # droits) au retour du réseau — comportement produit, aucun contournement.
  # NB bug 667 : DashboardActivity vit dans le module feature-dashboard —
  # le composant est $PKG_APP/video.vitrine.feature.dashboard.DashboardActivity
  # ($PKG_APP/.DashboardActivity n'existe pas : am start échouait en silence
  # et le repli MainActivity n'a JAMAIS déclenché de flush).
  adb root >/dev/null 2>&1 || true
  sleep 2
  adb shell am start -n "$PKG_APP/video.vitrine.feature.dashboard.DashboardActivity" >/dev/null 2>&1 || \
    adb shell am start -a video.vitrine.action.VIEW_DASHBOARD >/dev/null 2>&1 || \
    adb shell am start -n "$PKG_APP/.MainActivity" >/dev/null 2>&1 || true
  sleep 20
  # seconde tentative (cold start / course avec le repeuplement reseau)
  adb shell am start -n "$PKG_APP/video.vitrine.feature.dashboard.DashboardActivity" >/dev/null 2>&1 || true
  sleep 45
  # captures tolérantes (bug 667b : pidof exit 1 si process mort -> pipefail)
  adb logcat -d > "${SORTIE}/logcat_complet.txt" 2>/dev/null || true
  grep -iE "BackendSync|flush|telemetry|quota" "${SORTIE}/logcat_complet.txt" > "${SORTIE}/logcat_sync.txt" 2>/dev/null || true
  grep -E "D42-SYNC" "${SORTIE}/logcat_complet.txt" > "${SORTIE}/app_sync.txt" 2>/dev/null || true
  mkdir -p "${SORTIE}/db_apres"
  adb exec-out run-as "$PKG_APP" tar -cf - databases 2>/dev/null | tar -xf - -C "${SORTIE}/db_apres" 2>/dev/null || true
  # verdicts offline (journal CONFIRMED, débit UNIQUE, télémétrie synchronisée)
  python3 - "${SORTIE}" <<'PYOFF'
import os, sqlite3, sys
sortie = sys.argv[1]
verdicts = os.path.join(sortie, "results_offline.tsv")
lignes = []
def db(path):
    if not os.path.isfile(path):
        return None
    try:
        return sqlite3.connect(path)
    except Exception:
        return None
avant = db(os.path.join(sortie, "db_avant_retour.sqlite"))
apres = db(os.path.join(sortie, "db_apres", "databases", "vitrine-local.db"))
def lire(con, sql):
    if con is None:
        return None
    try:
        return list(con.execute(sql))
    except Exception:
        return None
journal_avant = lire(avant, "SELECT exportId, state, balanceAfter FROM export_journal ORDER BY rowid")
journal_apres = lire(apres, "SELECT exportId, state, balanceAfter FROM export_journal ORDER BY rowid")
credits_avant = lire(avant, "SELECT merchantId, welcomeCreditsLeft FROM entitlements_cache")
credits_apres = lire(apres, "SELECT merchantId, welcomeCreditsLeft FROM entitlements_cache")
tel_avant = lire(avant, "SELECT id, event, ok, uploaded FROM telemetry_outbox ORDER BY id")
tel_apres = lire(apres, "SELECT id, event, ok, uploaded FROM telemetry_outbox ORDER BY id")
with open(os.path.join(sortie, "offline_db.txt"), "w", encoding="utf-8") as f:
    f.write(f"journal_avant={journal_avant}\njournal_apres={journal_apres}\n")
    f.write(f"credits_avant={credits_avant}\ncredits_apres={credits_apres}\n")
    f.write(f"telemetry_avant={tel_avant}\ntelemetry_apres={tel_apres}\n")
etat = journal_apres[-1][1] if journal_apres else "vide"
lignes.append(("PASS" if journal_apres and etat == "CONFIRMED" else "FAIL",
               "OFFX_journal_confirme", f"dernier état journal = {etat}"))
if credits_apres:
    solde = credits_apres[-1][1]
    lignes.append(("PASS" if solde == 4 else "FAIL",
                   "OFFX_debit_unique",
                   f"welcomeCreditsLeft={solde} (attendu 4 = 5 - 1 débit, pas de double débit)"))
else:
    lignes.append(("FAIL", "OFFX_debit_unique", "entitlements illisibles"))
if tel_apres:
    exports = [r for r in tel_apres if r[1] and str(r[1]).startswith("export_confirmed")]
    sync = [r for r in exports if r[3] == 1]
    if exports and len(sync) == len(exports):
        lignes.append(("PASS", "OFFX_telemetry_sync", f"{len(sync)}/{len(exports)} ligne(s) export uploaded=1 après retour réseau"))
    elif exports:
        lignes.append(("PARTIAL", "OFFX_telemetry_sync", f"{len(sync)}/{len(exports)} uploadée(s) — flush partiel (voir logcat_sync.txt)"))
    else:
        lignes.append(("FAIL", "OFFX_telemetry_sync", "aucune ligne export_confirmed dans telemetry_outbox"))
else:
    lignes.append(("FAIL", "OFFX_telemetry_sync", "telemetry_outbox illisible"))
with open(verdicts, "w", encoding="utf-8") as f:
    for v in lignes:
        f.write("\t".join(str(x) for x in v) + "\n")
print("=== VERDICTS OFFLINE ===")
for v in lignes:
    print("\t".join(str(x) for x in v))
PYOFF
fi

# --- D42.29 (P2, étage 4) : mesures acoustiques du MP4 final ------------------
# Fenêtres mesurées (aucun verdict prématuré sur les seuils mal calibrés) :
#   rms_global   : toute la piste ;
#   rms_intro_0_2 / rms_fenetre_2_6 : début (la 2-6 s est post-fade-in 0,45 s) ;
#   rms_fin_3    : 3 dernières secondes (carte CTA — musique seule en mix) ;
#   rms_voix_5_8 / rms_voix_5_8_sans_440 : fenêtre rush (voix = sinus 440 Hz),
#     la seconde NOTCHÉE à 440 Hz isole le lit musical sous la voix.
# Verdicts STRICTS (échec = job rouge) : piste audio présente, décodage
# intégral sans erreur réelle, et mode musique : rms_fenetre_2_6 > -28 dB.
MESURES="${SORTIE}/audio_mesures.tsv"
echo -e "mp4\toctets\tduree\tpistes_audio\tdecode_err\trms_global\trms_intro_0_2\trms_2_6\trms_fin_3\trms_voix_5_8\trms_voix_sans_440" > "$MESURES"
ECHEC_AUDIO=0
while IFS= read -r mp4; do
  [ -s "$mp4" ] || continue
  nom=$(basename "$mp4")
  octets=$(stat -c%s "$mp4")
  duree=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$mp4" 2>/dev/null || echo "?")
  if [ "${duree:-?}" = "?" ]; then
    echo "  ($nom ignoré : conteneur illisible par ffprobe — ${octets} octets, pas un MP4 de rendu)"
    continue
  fi
  pistes=$(ffprobe -v error -select_streams a -show_entries stream=codec_type -of csv=p=0 "$mp4" 2>/dev/null | grep -c audio || true)
  ffmpeg -v error -i "$mp4" -f null - > "${mp4}.decode" 2>&1 || true
  decode_err=$(grep -cE "Invalid data found|Error while decoding|error:" "${mp4}.decode" 2>/dev/null || true)
  rm_silence=$(grep -cE "non monotonically increasing dts" "${mp4}.decode" 2>/dev/null || true)
  [ "$rm_silence" -gt 0 ] && echo "  ($nom : $rm_silence avertissements DTS du muxer null — connus, non bloquants)"
  mesure_rms() { # fenêtre [début, durée] + filtre optionnel
    local ss="$1" t="$2" filtre="${3:-}"
    if [ -n "$filtre" ]; then
      ffmpeg -hide_banner -ss "$ss" -t "$t" -i "$mp4" -map 0:a -af "$filtre,astats=measure_overall=RMS_level:measure_perchannel=none" -f null - 2>&1
    else
      ffmpeg -hide_banner -ss "$ss" -t "$t" -i "$mp4" -map 0:a -af "astats=measure_overall=RMS_level:measure_perchannel=none" -f null - 2>&1
    fi | grep "RMS level dB" | head -1 | sed -nE "s/.*RMS level dB:[[:space:]]*([-+]?[0-9]+\.?[0-9]*).*/\\1/p" || true
  }
  rms_global=$(mesure_rms 0 9999)
  rms_intro=$(mesure_rms 0 2)
  rms_2_6=$(mesure_rms 2 4)
  rms_fin=$(python3 -c "d=float('${duree:-0}' or 0); print(max(0, d-3))" 2>/dev/null || echo 0)
  rms_fin3=$(mesure_rms "$rms_fin" 3)
  rms_voix=$(mesure_rms 5 3)
  rms_voix_n=$(mesure_rms 5 3 "bandreject=f=440:width_type=h:w=240")
  echo -e "${nom}\t${octets}\t${duree}\t${pistes}\t${decode_err}\t${rms_global:-x}\t${rms_intro:-x}\t${rms_2_6:-x}\t${rms_fin3:-x}\t${rms_voix:-x}\t${rms_voix_n:-x}" >> "$MESURES"
  # verdicts stricts
  if [ "${pistes:-0}" -lt 1 ]; then
    echo "::error title=PISTE AUDIO ABSENTE::$nom — le MP4 n'a pas de piste audio"
    ECHEC_AUDIO=1
  fi
  if [ "${decode_err:-0}" -gt 0 ]; then
    echo "::error title=DÉCODAGE EN ÉCHEC::$nom — ${decode_err} erreur(s) réelle(s) (voir ${mp4}.decode)"
    ECHEC_AUDIO=1
  fi
  if [ "$AUDIO_MODE" = "musique" ]; then
    if [ -n "${rms_2_6:-}" ] && awk -v r="$rms_2_6" 'BEGIN{exit !(r > -28)}'; then
      echo "MUSIQUE AUDIBLE : $nom RMS(2-6 s) = ${rms_2_6} dB > -28 dB (gain solo, titulaire)"
    else
      echo "::error title=MUSIQUE NON AUDIBLE::$nom RMS(2-6 s) = ${rms_2_6:-?} dB (attendu > -28 dB en mode musique)"
      ECHEC_AUDIO=1
    fi
  fi
done < <(find "${SORTIE}" -name '*.mp4' -type f | sort)
echo "=== MESURES ACOUSTIQUES (étage 4) ==="
cat "$MESURES"

echo "== contenu récupéré =="
find "${SORTIE}" -maxdepth 3 -type f | sort | head -60
echo "mp4=$(find "${SORTIE}" -name '*.mp4' | wc -l)"

if [ "$ECHEC_AUDIO" -ne 0 ]; then
  echo "::error title=PREUVE AUDIO EN ÉCHEC::voir ${MESURES} + compteurs_etages.txt"
  exit 1
fi
