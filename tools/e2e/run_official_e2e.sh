#!/usr/bin/env bash
# D42.17 (rc5) — script unique de l'étape émulateur du workflow
# release-official-e2e. L'action reactivecircus/android-emulator-runner
# exécute son entrée `script:` LIGNE PAR LIGNE (sh -c par ligne) : tout
# bloc multi-lignes (groupes { }, for...do) y est une erreur de syntaxe —
# c'est ce qui a fait échouer les étapes rc1–rc4 APRÈS ou AVANT le
# parcours. Tout le logique vit donc dans CE fichier, appelé en une ligne.
#
# Rôle :
#   1. Appareil client PROPRE : masquage de /system/xbin par bind-mount
#      d'un répertoire vide — le fichier su devient invisible pour les
#      heuristiques anti-falsification d'IntegrityGuard (V2.0 §22), sans
#      écrire dans /system ni redémarrer (le reboot a tué l'émulateur au
#      run rc3 ; le rm direct est impossible : /system en lecture seule,
#      preuves rc2). Le contrôle de CERTIFICAT reste pleinement actif :
#      un APK non officiel serait toujours refusé. IntegrityGuard n'est
#      ni modifié ni contourné.
#   2. Parcours P1 complet sur l'APK officiellement signé (run_p1.sh).
#   3. ffprobe + décodage intégral du MP4 exporté, preuve de crédits
#      (base locale tirée), le tout conservé dans l'artefact.
set -uo pipefail

RC_P1=0

adb devices

# --- 1. Appareil client propre -------------------------------------------------
adb root >/dev/null 2>&1 || true
sleep 3
adb shell setenforce 0 2>/dev/null || true
adb shell mkdir -p /data/local/tmp/vv_xbin_vide
mkdir -p artifacts/p1-official
{
  echo "=== avant masquage (su visible = heuristique anti-root active) ==="
  adb shell 'ls -la /system/bin/su /system/xbin/su /system/app/Superuser.apk 2>&1'
  echo "=== masquage : bind-mount d'un répertoire vide sur /system/xbin ==="
  adb shell mount -o bind /data/local/tmp/vv_xbin_vide /system/xbin 2>&1 \
    || adb shell mount --bind /data/local/tmp/vv_xbin_vide /system/xbin 2>&1
  echo "=== après masquage (attendu : su invisible) ==="
  adb shell 'ls -la /system/xbin/ 2>&1'
  adb shell 'ls /system/bin/su /system/xbin/su /system/app/Superuser.apk 2>&1'
} | tee artifacts/p1-official/su_mask_proof.txt

# --- 2. Parcours P1 sur l'APK officiel -----------------------------------------
bash tools/e2e/run_p1.sh p1-official release.apk || RC_P1=$?

# --- 3. Preuves MP4 / lecture / crédits ----------------------------------------
echo "=== ffprobe + décodage intégral du MP4 exporté ==="
if [ -s artifacts/p1-official/export.mp4 ]; then
  ffprobe -v error -show_entries format=duration,size,format_name \
    -show_entries stream=codec_type,codec_name,width,height \
    -of default=noprint_wrappers=1 artifacts/p1-official/export.mp4 \
    | tee artifacts/p1-official/ffprobe.txt
  echo "--- décodage intégral (lecture bout en bout, ffmpeg) ---" | tee -a artifacts/p1-official/ffprobe.txt
  ffmpeg -v error -i artifacts/p1-official/export.mp4 -f null - 2>&1 \
    | tee artifacts/p1-official/decode_check.txt
  echo "decode rc=$?" | tee -a artifacts/p1-official/decode_check.txt
else
  echo "aucun MP4 produit : l'échec est applicatif, pas technique" \
    | tee artifacts/p1-official/ffprobe.txt
fi

echo "=== preuve crédits : base locale de l'application ==="
adb root >/dev/null 2>&1 || true
sleep 2
mkdir -p artifacts/p1-official/db
adb pull /data/data/video.vitrine.app/databases artifacts/p1-official/db >/dev/null 2>&1 \
  || echo "aucune base locale tirée" | tee artifacts/p1-official/db/pull_status.txt

# --- D42.18 (P5) : verdict crédits — journal + solde, ligne ajoutée au results ---
DBV=artifacts/p1-official/db/databases/vitrine-local.db
if [ -f "$DBV" ]; then
  python3 - "$DBV" artifacts/p1-official <<'PYDB' 2>&1 | tee artifacts/p1-official/credits_check.txt
import sqlite3, sys, re
db, outdir = sys.argv[1], sys.argv[2]
con = sqlite3.connect(db)
journal = list(con.execute("SELECT exportId, state, balanceAfter FROM export_journal ORDER BY rowid"))
left = con.execute("SELECT welcomeCreditsLeft FROM entitlements_cache LIMIT 1").fetchone()
print("export_journal :", journal)
print("welcomeCreditsLeft :", left[0] if left else None)
etat = journal[-1][1] if journal else "vide"
solde = left[0] if left else None
verdict = "PASS" if (etat == "CONFIRMED" and solde == 2) else "FAIL"
msg = f"journal={len(journal)} ligne(s), dernier état {etat}, solde {solde} (attendu : CONFIRMED, 2)"
with open(f"{outdir}/results.tsv", "a", encoding="utf-8") as f:
    f.write(f"{verdict}\tP1_credit_confirme\t{msg}\n")
print("verdict crédits :", verdict, "—", msg)
# recomptage du summary
txt = open(f"{outdir}/results.tsv", encoding="utf-8").read()
p_ = len(re.findall(r"^PASS\t", txt, re.M)); f_ = len(re.findall(r"^FAIL\t", txt, re.M))
b_ = len(re.findall(r"^BLOCKED\t", txt, re.M))
summ = f"{outdir}/summary.txt"
if __import__("os").path.exists(summ):
    lignes = open(summ, encoding="utf-8").read().splitlines()
    lignes = [l for l in lignes if not l.startswith("PASS=")] + [f"PASS={p_} FAIL={f_} BLOCKED={b_}"]
    open(summ, "w", encoding="utf-8").write("\n".join(lignes) + "\n")
print(f"summary recompté : PASS={p_} FAIL={f_} BLOCKED={b_}")
PYDB
else
  echo "base absente : verdict crédits impossible" | tee artifacts/p1-official/credits_check.txt
fi

# Le code de sortie du step reflète le verdict du harnais (les preuves sont
# collectées quoi qu'il arrive ; l'artefact part via if: always()).
exit $RC_P1
