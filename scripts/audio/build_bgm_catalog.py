#!/usr/bin/env python3
"""Générateur du catalogue BGM — source unique : les 30 gabarits embarqués (APK)
croisés avec la matrice audio (content/gabarits_v2/matrice_audio/).

Sorties (déterministes) :
  1. STRUCTURE.json          contrat de téléversement publié sur le bucket B2
  2. dossiers B2             audio/bgm/<secteur>/<T1..T5>/  (marqueurs vides)
  3. db/migrations/0010_…    table audio_catalog + seed 30 lignes (--emit-sql)

Usage :
  python3 scripts/audio/build_bgm_catalog.py --emit-sql        # régénère la migration
  B2_KEY_ID=… B2_APPLICATION_KEY=… \
  python3 scripts/audio/build_bgm_catalog.py --apply-b2        # publie structure + marqueurs

Aucune dépendance externe (stdlib). Credentials jamais écrits sur le disque.
"""
import argparse
import csv
import datetime
import glob
import hashlib
import hmac
import json
import os
import sys
import urllib.error
import urllib.request

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GABARITS_GLOB = os.path.join(REPO, "data/src/main/assets/gabarits/*/*.json")
MATRICE_CSV = os.path.join(
    REPO, "content/gabarits_v2/matrice_audio/matrice_30_gabarits_bpm_styles_sfx.csv"
)
BUCKET = "vitrine-video-media"
REGION = "us-east-005"
HOST = f"s3.{REGION}.backblazeb2.com"
PREFIX = "audio/bgm"

EXIGENCES = {
    "conteneur_prefere": "AAC-LC dans .m4a (plus léger à données égales, décodage natif Android)",
    "conteneur_alternatif": "MP3 CBR accepté (chemin …mp3 du même dossier)",
    "debit_min_kbps": 128,
    "frequence_hz": [44100, 48000],
    "canaux": 2,
    "loudness_cible_lufs": -14.0,
    "loudness_tolerance": 0.5,
    "true_peak_max_dbtp": -1.0,
    "mesure_apres_encodage": True,
    "duree_min": ">= duree_gabarit_s du gabarit ; sortie propre (pas de coupure nette) ; bouclable",
    "licence_autorisee": ["CC0-1.0", "DOMAINE_PUBLIC_VERIFIE"],
    "sfx_rappel": "Les 280 événements SFX s'appuient sur la banque de 9 catégories EMBARQUÉE dans l'APK (data/src/main/assets/audio/sfx/) : aucun fichier SFX ne doit être téléversé sur le bucket.",
}


def build_catalog():
    with open(MATRICE_CSV, encoding="utf-8-sig") as fh:
        matrice = {r["gabarit"]: r for r in csv.DictReader(fh, delimiter=";")}

    rows = []
    for path in sorted(glob.glob(GABARITS_GLOB)):
        d = json.load(open(path, encoding="utf-8"))
        mus = d["audio"]["musique"]
        secteur, fmt_long = d["secteur"], d["format"]
        fmt = fmt_long.split("_")[0]  # T1..T5
        cle_courte = f"{secteur}_{fmt}"
        m = matrice[cle_courte]
        # Cohérence obligatoire JSON embarqué <-> matrice audio (source spec).
        assert int(m["bpm_min_gabarit"]) == int(mus["bpm_min"]), cle_courte
        assert int(m["bpm_max_gabarit"]) == int(mus["bpm_max"]), cle_courte
        assert m["genre_source"] == mus["genre"], cle_courte
        cat = mus["categorie_audio"]
        dossier = f"{PREFIX}/{secteur}/{fmt}"
        rows.append(
            {
                "categorie_audio": cat,
                "gabarit_id": d["id"],
                "secteur": secteur,
                "format": fmt,
                "format_libelle": fmt_long,
                "genre": mus["genre"],
                "style_recommande": m["style_recommande_a_ecriter"]
                if "style_recommande_a_ecriter" in m
                else m["style_recommande_a_ecouter"],
                "texture_et_intention": m["texture_et_intention"],
                "energie_1_a_5": m["energie_proposee_1_a_5"],
                "bpm_min": int(mus["bpm_min"]),
                "bpm_max": int(mus["bpm_max"]),
                "duree_gabarit_s": d["duree_totale_secondes"],
                "sfx_categories": m["sfx_categories_et_nombre"],
                "chemin_m4a": f"{dossier}/{cat}.m4a",
                "chemin_mp3": f"{dossier}/{cat}.mp3",
            }
        )
    assert len(rows) == 30, f"attendu 30 gabarits, trouvé {len(rows)}"
    cats = [r["categorie_audio"] for r in rows]
    assert len(set(cats)) == 30, "categorie_audio dupliquée"
    return rows


def structure_json(rows):
    sources = {}
    for f in (MATRICE_CSV,):
        sources[os.path.relpath(f, REPO)] = hashlib.sha256(open(f, "rb").read()).hexdigest()
    return {
        "schema": "vv_bgm_structure",
        "version": 1,
        "genere_le": "2026-10-31",
        "generateur": "scripts/audio/build_bgm_catalog.py",
        "sources_sha256": sources,
        "bucket": BUCKET,
        "prefixe": PREFIX,
        "exigences_encodage": EXIGENCES,
        "pistes": rows,
    }


def sql_migration(rows):
    def q(v):
        return "'" + str(v).replace("'", "''") + "'"

    inserts = "\n".join(
        "INSERT OR IGNORE INTO audio_catalog\n"
        "  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,\n"
        "   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)\n"
        f"VALUES ({q(r['categorie_audio'])}, {q(r['gabarit_id'])}, {q(r['secteur'])}, {q(r['format'])},\n"
        f"        {q(r['genre'])}, {q(r['style_recommande'])}, {q(r['texture_et_intention'])}, {q(r['energie_1_a_5'])},\n"
        f"        {r['bpm_min']}, {r['bpm_max']}, {r['duree_gabarit_s']}, {q(r['chemin_m4a'])}, {q(r['chemin_mp3'])});"
        for r in rows
    )
    return f"""-- 0010 : catalogue des musiques de fond (BGM) par gabarit.
-- Source unique : les 30 gabarits embarqués (data/src/main/assets/gabarits/) croisés
-- avec content/gabarits_v2/matrice_audio/matrice_30_gabarits_bpm_styles_sfx.csv.
-- Régénérée par scripts/audio/build_bgm_catalog.py --emit-sql (déterministe).
-- Les objets audio vivent sur B2 : audio/bgm/<secteur>/<T1..T5>/<categorie_audio>.m4a|mp3
-- (contrat publié : audio/bgm/STRUCTURE.json sur le bucket {BUCKET}).

CREATE TABLE IF NOT EXISTS audio_catalog (
  categorie_audio TEXT PRIMARY KEY,
  gabarit_id      TEXT NOT NULL,
  secteur         TEXT NOT NULL,
  format          TEXT NOT NULL,
  genre           TEXT NOT NULL,
  style           TEXT NOT NULL,
  texture         TEXT NOT NULL DEFAULT '',
  energie         TEXT NOT NULL DEFAULT '',
  bpm_min         INTEGER NOT NULL,
  bpm_max         INTEGER NOT NULL,
  duree_gabarit_s REAL NOT NULL,
  object_key      TEXT NOT NULL,
  object_key_mp3  TEXT NOT NULL,
  statut          TEXT NOT NULL DEFAULT 'NON_APPROVISIONNE',
  etag            TEXT,
  taille_octets   INTEGER,
  en_ligne_at     TEXT,
  updated_at      TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE INDEX IF NOT EXISTS idx_audio_catalog_secteur ON audio_catalog(secteur);
CREATE INDEX IF NOT EXISTS idx_audio_catalog_gabarit ON audio_catalog(gabarit_id);

{inserts}
"""


# ---------------------------------------------------------------- SigV4 (B2)
def _sign(key, msg):
    return hmac.new(key, msg.encode(), hashlib.sha256).digest()


def sigv4(method, key, body=b"", content_type=None):
    key_id = os.environ["B2_KEY_ID"]
    app_key = os.environ["B2_APPLICATION_KEY"]
    now = datetime.datetime.now(datetime.timezone.utc)
    amzdate, datestamp = now.strftime("%Y%m%dT%H%M%SZ"), now.strftime("%Y%m%d")
    path = "/" + BUCKET + "/" + urllib.parse.quote(key, safe="/")
    payload_hash = hashlib.sha256(body).hexdigest()
    headers = {"host": HOST, "x-amz-content-sha256": payload_hash, "x-amz-date": amzdate}
    if content_type:
        headers["content-type"] = content_type
    signed_names = ";".join(sorted(headers))
    canon_headers = "".join(f"{k}:{headers[k]}\n" for k in sorted(headers))
    canon = f"{method}\n{path}\n\n{canon_headers}\n{signed_names}\n{payload_hash}"
    scope = f"{datestamp}/{REGION}/s3/aws4_request"
    sts = f"AWS4-HMAC-SHA256\n{amzdate}\n{scope}\n{hashlib.sha256(canon.encode()).hexdigest()}"
    k = _sign(("AWS4" + app_key).encode(), datestamp)
    k = _sign(k, REGION)
    k = _sign(k, "s3")
    k = _sign(k, "aws4_request")
    signature = hmac.new(k, sts.encode(), hashlib.sha256).hexdigest()
    req_headers = {
        "x-amz-date": amzdate,
        "x-amz-content-sha256": payload_hash,
        "Authorization": (
            f"AWS4-HMAC-SHA256 Credential={key_id}/{scope}, "
            f"SignedHeaders={signed_names}, Signature={signature}"
        ),
    }
    if content_type:
        req_headers["Content-Type"] = content_type
    req = urllib.request.Request(f"https://{HOST}{path}", data=body or None,
                                 headers=req_headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=60) as r:
            return r.status, r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.read()


def apply_b2(rows):
    import urllib.parse  # noqa: F401 (utilisé par sigv4)

    body = json.dumps(structure_json(rows), ensure_ascii=False, indent=1).encode()
    st, resp = sigv4("PUT", f"{PREFIX}/STRUCTURE.json", body, "application/json")
    print(f"PUT {PREFIX}/STRUCTURE.json -> {st}")
    if st != 200:
        sys.exit(resp.decode(errors="replace")[:400])
    ok = 0
    for r in rows:
        folder = f"{PREFIX}/{r['secteur']}/{r['format']}/"
        st, resp = sigv4("PUT", folder, b"", "application/x-directory")
        if st == 200:
            ok += 1
        else:
            print(f"ECHEC {folder} -> {st} {resp[:120]}")
    print(f"marqueurs dossiers : {ok}/30")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--emit-sql", action="store_true")
    ap.add_argument("--apply-b2", action="store_true")
    ap.add_argument("--print", action="store_true", dest="show")
    args = ap.parse_args()
    rows = build_catalog()
    if args.emit_sql:
        out = os.path.join(REPO, "db/migrations/0010_audio_catalog.sql")
        open(out, "w", encoding="utf-8").write(sql_migration(rows))
        print("migration écrite :", out)
    if args.apply_b2:
        apply_b2(rows)
    if args.show:
        print(json.dumps(structure_json(rows), ensure_ascii=False, indent=1))


if __name__ == "__main__":
    import urllib.parse  # noqa: F401

    main()
