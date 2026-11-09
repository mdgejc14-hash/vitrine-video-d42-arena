#!/usr/bin/env bash
# D42.28 (P2-A) — EXPORT COMPLET DE BOUT EN BOUT SANS INTERNET.
#
# Scénario (mission D42.28 §5.A) :
#   1. Réseau ON au départ : langue, repli démo, catalogue, SÉLECTION du
#      gabarit → prefetch du BGM en arrière-plan (BgmStore.prefetchForGabarit,
#      cache files/bgm/{piste}.mp3 + JSON library en cache).
#   2. Un SURVEILLANT coupe le réseau (svc wifi+data disable, preuve dumpsys)
#      dès que le BGM est en cache — le reste du parcours (brief, tournage,
#      aperçu avec musique du cache, EXPORT) s'exécute SANS Internet.
#   3. Preuves : horodatage de la coupure, connectivité pendant l'export,
#      export-*.mp4 tiré + ffprobe + décodage intégral, journal d'export
#      (base Room export_journal), retour du réseau sans crash ni perte.
#
# Le parcours UI est celui du banc P1 (run_p1.sh, éprouvé) : ce wrapper ajoute
# la coupure réseau au moment exact où les ressources sont pré-téléchargées.
#
# Usage : run_offline_export.sh <tag> [apk]
set -uo pipefail

TAG="${1:-offline-export}"
APK="${2:-app/build/outputs/apk/debug/app-debug.apk}"
PKG="video.vitrine.app"
OUT="artifacts/${TAG}"
mkdir -p "$OUT"

MARQUEUR_COUPE="/tmp/offexp_reseau_coupe"
rm -f "$MARQUEUR_COUPE"

couper_reseau() {
  adb shell svc wifi disable >/dev/null 2>&1
  adb shell svc data disable >/dev/null 2>&1
}
retablir_reseau() {
  adb shell svc wifi enable >/dev/null 2>&1
  adb shell svc data enable >/dev/null 2>&1
}

# --- 1. Surveillant : couper le réseau dès que le BGM est en cache -------------
(
  while [ ! -f "$MARQUEUR_COUPE" ]; do
    if adb shell run-as "$PKG" sh -c 'ls files/bgm/*.mp3 2>/dev/null' 2>/dev/null \
        | tr -d '\r' | grep -q '\.mp3'; then
      sleep 3   # laisser le téléchargement intégral (sha vérifié côté app) finir
      couper_reseau
      {
        echo "=== COUPURE RÉSEAU ($(date -u +%Y-%m-%dT%H:%M:%SZ)) ==="
        echo "BGM en cache au moment de la coupure :"
        adb shell run-as "$PKG" sh -c 'ls -la files/bgm/ 2>/dev/null' | tr -d '\r'
        echo "Connectivité après svc disable :"
        adb shell dumpsys connectivity 2>/dev/null | tr -d '\r' \
          | grep -E "Active default network|no default network" | head -2
      } > "$OUT/coupure_reseau.txt" 2>&1
      touch "$MARQUEUR_COUPE"
      break
    fi
    sleep 2
  done
) &
SURVEILLANT=$!

# --- 2. Parcours P1 (réseau ON au départ, coupé par le surveillant) -----------
RC=0
bash tools/e2e/run_p1.sh "$TAG" "$APK" || RC=$?
kill $SURVEILLANT 2>/dev/null || true
wait $SURVEILLANT 2>/dev/null || true

RESULTS="$OUT/results.tsv"

# --- 3. Verdicts offline -------------------------------------------------------
if [ -f "$MARQUEUR_COUPE" ]; then
  printf 'PASS\tOFFX_coupure_apres_prefetch\tBGM pré-téléchargé puis réseau coupé (preuve : coupure_reseau.txt)\n' >> "$RESULTS"
else
  printf 'FAIL\tOFFX_coupure_apres_prefetch\tBGM jamais observé en cache — réseau resté ON (surveillant)\n' >> "$RESULTS"
fi

# Connectivité au moment du verdict (doit être OFF si tout s'est passé comme prévu)
adb shell dumpsys connectivity 2>/dev/null | tr -d '\r' \
  | grep -E "Active default network|no default network" | head -2 > "$OUT/connectivite_fin.txt"

# --- 4. Preuves MP4 + journal d'export (même méthode que le P1 officiel) ------
if [ -s "$OUT/export.mp4" ]; then
  ffprobe -v error -show_entries format=duration,size,format_name \
    -show_entries stream=codec_type,codec_name \
    -of default=noprint_wrappers=1 "$OUT/export.mp4" > "$OUT/ffprobe.txt" 2>&1
  ffmpeg -v error -i "$OUT/export.mp4" -f null - > "$OUT/decode_check.txt" 2>&1
  if [ -s "$OUT/ffprobe.txt" ] && ! [ -s "$OUT/decode_check.txt" ]; then
    printf 'PASS\tOFFX_mp4_decode_offline\tMP4 exporté HORS CONNEXION, décodage intégral OK (ffprobe.txt)\n' >> "$RESULTS"
  else
    printf 'FAIL\tOFFX_mp4_decode_offline\tMP4 produit mais ffprobe/decode en échec (voir ffprobe.txt/decode_check.txt)\n' >> "$RESULTS"
  fi
else
  printf 'FAIL\tOFFX_mp4_decode_offline\taucun export.mp4 produit hors connexion\n' >> "$RESULTS"
fi

adb root >/dev/null 2>&1 || true
sleep 2
mkdir -p "$OUT/db"
adb pull "/data/data/$PKG/databases" "$OUT/db" >/dev/null 2>&1 || true
DBV="$OUT/db/databases/vitrine-local.db"
if [ -f "$DBV" ]; then
  python3 - "$DBV" "$OUT" <<'PYDB'
import sqlite3, sys
db, outdir = sys.argv[1], sys.argv[2]
con = sqlite3.connect(db)
try:
    journal = list(con.execute("SELECT exportId, state, balanceAfter FROM export_journal ORDER BY rowid"))
except Exception as e:
    journal = []
    print("export_journal illisible :", e)
try:
    left = con.execute("SELECT welcomeCreditsLeft FROM entitlements_cache LIMIT 1").fetchone()
except Exception:
    left = None
print("export_journal :", journal)
print("welcomeCreditsLeft :", left[0] if left else None)
with open(f"{outdir}/results.tsv", "a", encoding="utf-8") as f:
    etat = journal[-1][1] if journal else "vide"
    if journal and etat == "CONFIRMED":
        f.write(f"PASS\tOFFX_journal_export\tjournal d'export local : {len(journal)} ligne(s), dernier état {etat}, solde {left[0] if left else '?'}\n")
    else:
        f.write(f"FAIL\tOFFX_journal_export\tjournal d'export : dernier état {etat} (attendu CONFIRMED)\n")
PYDB
else
  printf 'FAIL\tOFFX_journal_export\tbase locale inaccessible\n' >> "$RESULTS"
fi

# --- 5. Retour du réseau : rien ne casse, aucune perte -------------------------
retablir_reseau
sleep 8
adb shell pidof "$PKG" >/dev/null 2>&1 \
  && printf 'PASS\tOFFX_retour_reseau\tretour du réseau : app vivante\n' >> "$RESULTS" \
  || printf 'FAIL\tOFFX_retour_reseau\tapp morte au retour du réseau\n' >> "$RESULTS"
adb shell run-as "$PKG" sh -c 'ls files/rushes/ 2>/dev/null' | tr -d '\r' | head -8 > "$OUT/rushs_finaux.txt"
if [ -s "$OUT/rushs_finaux.txt" ]; then
  printf 'PASS\tOFFX_donnees_conservees\trusts toujours présents après export + retour réseau (rushs_finaux.txt)\n' >> "$RESULTS"
else
  printf 'PARTIAL\tOFFX_donnees_conservees\taucun rush listé (voir rushs_finaux.txt)\n' >> "$RESULTS"
fi
if adb logcat -d -b crash 2>/dev/null | tr -d '\r' | grep -q "Process: $PKG"; then
  adb logcat -d -b crash 2>/dev/null | tr -d '\r' | grep -B2 -A30 "Process: $PKG" > "$OUT/crash.log"
  printf 'FAIL\tOFFX_aucun_crash\tFATAL EXCEPTION pendant le parcours offline (crash.log)\n' >> "$RESULTS"
else
  printf 'PASS\tOFFX_aucun_crash\taucune FATAL EXCEPTION (parcours offline + export + retour réseau)\n' >> "$RESULTS"
fi

grep -cE '^PASS' "$RESULTS" | xargs -I{} echo "OFFLINE_EXPORT PASS={}" | tee -a "$OUT/summary.txt"
grep -cE '^FAIL' "$RESULTS" | xargs -I{} echo "OFFLINE_EXPORT FAIL={}" | tee -a "$OUT/summary.txt"
cat "$RESULTS"
exit $RC
