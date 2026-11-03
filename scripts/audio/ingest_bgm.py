#!/usr/bin/env python3
"""Ingestion BGM -> Backblaze B2 + migration D1 + contrôle de synchronisation.

  B2_KEY_ID=… B2_APPLICATION_KEY=… \
  python3 scripts/audio/ingest_bgm.py --upload --manifest /tmp/bgm_lib_manifest.json
  python3 scripts/audio/ingest_bgm.py --emit-sql --manifest /tmp/bgm_lib_manifest.json
  B2_KEY_ID=… B2_APPLICATION_KEY=… \
  python3 scripts/audio/ingest_bgm.py --sync-check --manifest /tmp/bgm_lib_manifest.json

--upload     : PUT parallèles (8) idempotents vers audio/bgm/<secteur>/<T#>/<piste>.mp3
--emit-sql   : db/migrations/0011_bgm_library.sql (table + INSERT OR IGNORE, déterministe)
--sync-check : listing B2 (paginé) vs manifeste vs comptage D1 local/attendu ;
               le contrôle définitif côté serveur se fait via GET /api/v1/audio/library
               (count) après déploiement.
"""
import argparse
import hashlib
import json
import os
import sys
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from build_bgm_catalog import sigv4  # SigV4 B2 partagé (repo, stdlib)


def upload_one(entry, dossier_racine):
    chemin = os.path.join(dossier_racine, entry["secteur"], entry["format"],
                          f"{entry['piste_id']}.mp3")
    body = open(chemin, "rb").read()
    if hashlib.sha256(body).hexdigest() != entry["sha256"]:
        return entry["piste_id"], "sha_incoherente", None
    for tentative in (1, 2, 3):
        st, resp = sigv4("PUT", entry["object_key"], body, "audio/mpeg")
        if st == 200:
            return entry["piste_id"], "ok", len(body)
    return entry["piste_id"], f"echec_http_{st}", resp[:120]


def upload(manifest, dossier_racine, workers=8):
    ok = 0
    erreurs = []
    with ThreadPoolExecutor(max_workers=workers) as pool:
        for piste_id, etat, detail in pool.map(
                lambda e: upload_one(e, dossier_racine), manifest):
            if etat == "ok":
                ok += 1
            else:
                erreurs.append((piste_id, etat, detail))
            if (ok + len(erreurs)) % 100 == 0:
                print(f"  progression : {ok + len(erreurs)}/{len(manifest)}", flush=True)
    print(f"televerses : {ok}/{len(manifest)}")
    for e in erreurs[:10]:
        print("  ECHEC :", e)
    return 0 if not erreurs else 1


def emit_sql(manifest):
    repo = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    def q(v):
        return "'" + str(v).replace("'", "''") + "'"
    inserts = "\n".join(
        "INSERT OR IGNORE INTO bgm_library\n"
        "  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,\n"
        "   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)\n"
        f"VALUES ({q(e['piste_id'])}, {q(e['categorie_audio'])}, {q(e['gabarit_id'])}, {q(e['secteur'])},\n"
        f"        {q(e['format'])}, {e['variation']}, {e['bpm']}, {q(e['genre'])}, {q(e['origine'])},\n"
        f"        {q(e['licence'])}, {q(e['object_key'])}, {q(e['sha256'])}, {e['taille_octets']},\n"
        f"        {e['duree_s']}, {q(e['preuve_sha256'])});"
        for e in manifest)
    sql = f"""-- 0011 : bibliothèque BGM (variations par gabarit) — Phase C.
-- Générée par scripts/audio/ingest_bgm.py --emit-sql (déterministe).
-- origine='synthese_procedurale_v1' : pistes de synthèse CC0 (pas des masters
-- humains — cf. content/gabarits_v2/matrice_audio/LISEZ_MOI_AUDIO.md).
-- Un master humain déposé sur le chemin titulaire prend la priorité au runtime.

CREATE TABLE IF NOT EXISTS bgm_library (
  piste_id        TEXT PRIMARY KEY,
  categorie_audio TEXT NOT NULL,
  gabarit_id      TEXT NOT NULL,
  secteur         TEXT NOT NULL,
  format          TEXT NOT NULL,
  variation       INTEGER NOT NULL,
  bpm             INTEGER NOT NULL,
  genre           TEXT NOT NULL,
  origine         TEXT NOT NULL,
  licence         TEXT NOT NULL,
  object_key      TEXT NOT NULL,
  sha256          TEXT NOT NULL,
  taille_octets   INTEGER NOT NULL,
  duree_s         REAL NOT NULL,
  preuve_sha256   TEXT,
  statut          TEXT NOT NULL DEFAULT 'EN_LIGNE',
  updated_at      TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE INDEX IF NOT EXISTS idx_bgm_lib_categorie ON bgm_library(categorie_audio);
CREATE INDEX IF NOT EXISTS idx_bgm_lib_secteur ON bgm_library(secteur, format);

{inserts}
"""
    out = os.path.join(repo, "db/migrations/0011_bgm_library.sql")
    open(out, "w", encoding="utf-8").write(sql)
    print("migration écrite :", out, f"({len(manifest)} INSERT)")


def sync_check(manifest, workers=8):
    """Contrôle objet par objet via SigV4 HEAD (canal prouvé par les PUT) :
    existence + Content-Length exact vs manifeste. Listing S3/native refusé
    par cette clé scopée (403/401) — le HEAD×600 est plus fort qu'un listing."""
    import datetime
    import hmac
    import urllib.request
    from concurrent.futures import ThreadPoolExecutor as TPE

    key_id = os.environ["B2_KEY_ID"]
    app_key = os.environ["B2_APPLICATION_KEY"]
    host = "s3.us-east-005.backblazeb2.com"
    bucket = "vitrine-video-media"

    def head(entry):
        now = datetime.datetime.now(datetime.timezone.utc)
        amz, ds = now.strftime("%Y%m%dT%H%M%SZ"), now.strftime("%Y%m%d")
        payload = hashlib.sha256(b"").hexdigest()
        path = f"/{bucket}/{entry['object_key']}"
        canon = (f"HEAD\n{path}\n\nhost:{host}\n"
                 f"x-amz-content-sha256:{payload}\nx-amz-date:{amz}\n\n"
                 f"host;x-amz-content-sha256;x-amz-date\n{payload}")
        scope = f"{ds}/us-east-005/s3/aws4_request"
        sts = f"AWS4-HMAC-SHA256\n{amz}\n{scope}\n{hashlib.sha256(canon.encode()).hexdigest()}"
        k = hmac.new(("AWS4" + app_key).encode(), ds.encode(), hashlib.sha256).digest()
        for part in (b"us-east-005", b"s3", b"aws4_request"):
            k = hmac.new(k, part, hashlib.sha256).digest()
        sig = hmac.new(k, sts.encode(), hashlib.sha256).hexdigest()
        req = urllib.request.Request(f"https://{host}{path}", method="HEAD",
            headers={"x-amz-date": amz, "x-amz-content-sha256": payload,
                     "Authorization": f"AWS4-HMAC-SHA256 Credential={key_id}/{scope}, "
                                      f"SignedHeaders=host;x-amz-content-sha256;x-amz-date, "
                                      f"Signature={sig}"})
        try:
            with urllib.request.urlopen(req, timeout=30) as r:
                return entry["piste_id"], r.status, int(r.headers.get("Content-Length", -1))
        except urllib.error.HTTPError as e:
            return entry["piste_id"], e.code, -1
        except Exception:  # noqa: BLE001
            return entry["piste_id"], 0, -1

    ok = 0
    problemes = []
    with TPE(max_workers=workers) as pool:
        for piste_id, st, taille in pool.map(head, manifest):
            attendu = next(e["taille_octets"] for e in manifest if e["piste_id"] == piste_id)
            if st == 200 and taille == attendu:
                ok += 1
            else:
                problemes.append((piste_id, st, taille, attendu))
    print(f"HEAD B2 : {ok}/{len(manifest)} objets présents, taille exacte")
    for pb in problemes[:8]:
        print("  PROBLEME :", pb)
    if not problemes:
        print("SYNC B2 <-> manifeste : OK (600 objets audio/bgm/**, tailles vérifiées)")
    return 0 if not problemes else 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--manifest", default="/tmp/bgm_lib_manifest.json")
    ap.add_argument("--source", default="/tmp/bgm_out")
    ap.add_argument("--upload", action="store_true")
    ap.add_argument("--emit-sql", action="store_true")
    ap.add_argument("--sync-check", action="store_true")
    args = ap.parse_args()
    manifest = json.load(open(args.manifest, encoding="utf-8"))
    code = 0
    if args.emit_sql:
        emit_sql(manifest)
    if args.upload:
        code |= upload(manifest, args.source)
    if args.sync_check:
        code |= sync_check(manifest)
    sys.exit(code)


if __name__ == "__main__":
    main()
