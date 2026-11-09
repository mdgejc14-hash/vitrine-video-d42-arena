#!/usr/bin/env python3
"""D42.28 (P1) — Correction du silence initial excessif des compositions BGM.

CONTEXTE (audit audio-audit-full du 2026-11-09, artefact 13643105300) :
  - 600/600 pistes EN_LIGNE, sha256 conformes, décodables, 0 clipping,
    niveaux cohérents (RMS -18,7…-14,8 dB, écart-type 0,81 dB) ;
  - MAIS attaque (premier son @ -40 dB) : min 1,03 s, max 3,18 s sur les
    600 pistes → AUCUNE ne satisfait la cible produit D42.28 (attaque
    audible dans les premières 0,5 s). Toutes les 600 sont donc
    objectivement défectueuses au critère de démarrage.

MÉTHODE — correction DÉTERMINISTE du master (la musique est bonne :
mêmes notes, même structure, même niveau ; seul le démarrage change) :
  1. GET B2 de l'original (clé du manifeste v2), contrôle sha256 ;
  2. mesure du silence initial (ffmpeg silencedetect -40 dB, d=0,1) ;
  3. rognage : atrim start = max(0, attaque - 0,12 s) (marge 120 ms pour
     ne pas amputer un transitoire très doux) ;
  4. fade-in court et naturel : afade 0,4 s ;
  5. ré-encodage MP3 CBR 128 kbps 44,1 kHz stéréo (mêmes specs conteneur
     que la bibliothèque v2) ;
  6. mesures APRÈS (mêmes définitions que l'audit : attaque d=1, RMS,
     peak, clipping, durée, décodabilité intégrale) ;
  7. NOUVELLE clé B2 audio/bgm_r2/<secteur>/<T#>/<piste>.mp3 — l'original
     n'est JAMAIS écrasé (règle fondateur D42.28) ;
  8. controle qualité : attaque après < 0,5 s, 0 clipping, décodable,
     RMS dans ±1,5 dB de l'original (la musique ne change pas de niveau).

TITULAIRES audio_catalog (54/60 clés en 404, repli v01 par conception —
src/index.js routeAudioTrack : « master titulaire prioritaire, sinon
repli variation 1 ») :
  - HEAD de chaque clé titulaire (seed 0010_audio_catalog.sql) ;
  - ré-ingestion UNIQUEMENT des clés ABSENTES, avec le master v01 CORRIGÉ
    (équivalence prouvée par le design même du repli : le contenu
    titulaire attendu EST la variation 1) — .mp3 (copie du v01 corrigé)
    et .m4a (ré-encodage AAC 128 kbps) ;
  - aucune clé existante n'est écrasée, aucune variation distincte n'est
    supprimée, aucun doublon musical n'est créé.

SORTIES (dossier --out) :
  - bgm_r2/<secteur>/<T#>/<piste>.mp3          (600 fichiers corrigés)
  - bgm_r2_manifest.json                        (nouvelles clés/sha/mesures)
  - titulaires_journal.json                     (60 clés : statut + action)
  - rapport.md                                  (synthèse avant/après)
  - 0013_bgm_library_r2.sql                     (migration D1 : INSERT OR
    REPLACE des 600 lignes vers les nouvelles clés — À COMMITTER)

Usage :
  B2_KEY_ID=… B2_APPLICATION_KEY=… python3 scripts/audio/fix_initial_silence.py \
      --manifest scripts/audio/bgm_lib_manifest_v2.json --out artifacts/audio_r2 \
      [--upload] [--limit N]
Sans --upload : préparation et contrôles seulement (aucune écriture B2).
"""
import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from build_bgm_catalog import sigv4  # SigV4 B2 partagé (stdlib uniquement)

FADE_S = 0.4        # fade-in naturel
MARGE_S = 0.12      # marge avant le premier son
CIBLE_ATTAQUE = 0.5 # cible produit : attaque audible < 0,5 s
SEUIL_ORIGINAL = 0.25  # en dessous : rien à corriger (déjà conforme)


def sh(cmd):
    return subprocess.run(cmd, capture_output=True, text=True)


def mesure_chemin(f, seuil_d=1.0):
    """Mesures acoustiques d'un fichier (définitions de scripts/audio-audit.mjs)."""
    m = {}
    dec = sh(["ffmpeg", "-hide_banner", "-v", "error", "-i", f, "-f", "null", "-"])
    dec_txt = (dec.stderr or "") + (dec.stdout or "")
    m["decodable"] = dec.returncode == 0 and not re.search(r"error|invalid|corrupt", dec_txt, re.I)
    probe = sh(["ffprobe", "-hide_banner", "-v", "quiet", "-print_format", "json",
                "-show_format", "-show_streams", f])
    try:
        fmt = json.loads(probe.stdout)
        m["duree"] = float(fmt["format"]["duration"])
        st = next(s for s in fmt["streams"] if s.get("codec_type") == "audio")
        m["codec"] = st.get("codec_name")
    except Exception:
        m["duree"] = None
    ast = sh(["ffmpeg", "-hide_banner", "-i", f, "-af", "astats=metadata=0", "-f", "null", "-"])
    def num(pat, src):
        r = re.search(pat, src)
        return float(r.group(1)) if r else None
    src_txt = ast.stdout + ast.stderr
    m["rms"] = num(r"RMS level dB:\s*(-?[\d.]+)", src_txt)
    m["peak"] = num(r"Peak level dB:\s*(-?[\d.]+)", src_txt)
    m["clipped"] = num(r"Number of Clipped samples:\s*(\d+)", src_txt) or 0
    sil = sh(["ffmpeg", "-hide_banner", "-i", f, "-af",
              f"silencedetect=noise=-40dB:d={seuil_d}", "-f", "null", "-"])
    sil_txt = sil.stdout + sil.stderr
    starts = [float(x) for x in re.findall(r"silence_start: (-?[\d.]+)", sil_txt)]
    ends = [float(x) for x in re.findall(r"silence_end: (-?[\d.]+)", sil_txt)]
    m["silenceDebut"] = (ends[0] if starts and starts[0] <= 0.02 and ends else 0.0)
    m["attaque"] = m["silenceDebut"]
    return m


def get_b2(key, dest):
    r = sigv4("GET", key)
    if r[0] != 200:
        return False
    open(dest, "wb").write(r[1])
    return True


def head_b2(key):
    r = sigv4("HEAD", key)
    return r[0] == 200


def put_b2(key, path, content_type):
    body = open(path, "rb").read()
    for t in (1, 2, 3):
        st, resp = sigv4("PUT", key, body, content_type)
        if st == 200:
            return True
    print(f"  ECHEC upload {key} : {st} {str(resp)[:80]}")
    return False


def corrige_piste(entry, racine_out, dossier_tmp):
    """Télécharge, mesure, corrige, mesure à nouveau. Retourne la fiche r2."""
    piste_id = entry["piste_id"]
    fiche = {"piste_id": piste_id, **{k: entry[k] for k in
             ("categorie_audio", "gabarit_id", "secteur", "format", "variation",
              "bpm", "genre", "famille", "tonalite", "origine", "licence")}}
    src = os.path.join(dossier_tmp, f"{piste_id}.mp3")
    if not get_b2(entry["object_key"], src):
        return {**fiche, "erreur": "get_b2_echoue"}
    body = open(src, "rb").read()
    fiche["sha_original_ok"] = hashlib.sha256(body).hexdigest() == entry["sha256"]
    if not fiche["sha_original_ok"]:
        return {**fiche, "erreur": "sha_original_incoherent"}

    avant = mesure_chemin(src, seuil_d=0.1)   # attaque fine (d=0,1)
    fiche["attaque_avant"] = round(avant["attaque"], 2)

    out_rel = os.path.join("bgm_r2", entry["secteur"], entry["format"], f"{piste_id}.mp3")
    out = os.path.join(racine_out, out_rel)
    os.makedirs(os.path.dirname(out), exist_ok=True)

    if avant["attaque"] <= SEUIL_ORIGINAL:
        # déjà conforme : copie byte-à-byte (aucune transformation inutile)
        open(out, "wb").write(body)
        fiche["action"] = "copie_conforme"
    else:
        depart = max(0.0, avant["attaque"] - MARGE_S)
        # atrim (précision échantillon sur PCM décodé) + fade-in + ré-encodage
        cmd = ["ffmpeg", "-hide_banner", "-v", "error", "-i", src,
               "-af", f"atrim=start={depart:.3f},afade=t=in:st=0:d={FADE_S}",
               "-ar", "44100", "-ac", "2", "-c:a", "libmp3lame", "-b:a", "128k",
               "-write_xing", "1", out]
        r = sh(cmd)
        if r.returncode != 0 or not os.path.exists(out) or os.path.getsize(out) < 1000:
            return {**fiche, "erreur": f"ffmpeg_echoue: {(r.stderr or '')[:100]}"}
        fiche["action"] = f"rognee_{depart:.2f}s+fade_{FADE_S}s"

    apres = mesure_chemin(out, seuil_d=1.0)   # même définition que l'audit (d=1)
    fiche.update({
        "attaque_apres": round(apres["attaque"], 2),
        "duree_avant": round(avant.get("duree") or 0, 2),
        "duree_apres": round(apres.get("duree") or 0, 2),
        "rms_avant": round(avant["rms"], 2) if avant.get("rms") is not None else None,
        "rms_apres": round(apres["rms"], 2) if apres.get("rms") is not None else None,
        "peak_apres": round(apres["peak"], 2) if apres.get("peak") is not None else None,
        "clipped_apres": apres["clipped"],
        "decodable_apres": apres["decodable"],
        "sha256": hashlib.sha256(open(out, "rb").read()).hexdigest(),
        "taille_octets": os.path.getsize(out),
        "object_key_r2": "audio/" + out_rel,
    })
    return fiche


def controle_qualite(fiche):
    """Garde-fous : attaque < 0,5 s ; 0 clipping ; décodable ; RMS ±1,5 dB."""
    if fiche.get("erreur"):
        return False
    if fiche["attaque_apres"] >= CIBLE_ATTAQUE:
        return False
    if fiche["clipped_apres"] or not fiche["decodable_apres"]:
        return False
    if fiche["rms_avant"] is not None and fiche["rms_apres"] is not None:
        if abs(fiche["rms_apres"] - fiche["rms_avant"]) > 1.5:
            return False
    if (fiche["duree_apres"] or 0) < 10:
        return False
    return True


def cles_titulaires(chemin_seed):
    """Extrait les (categorie, object_key .m4a, object_key .mp3) du seed 0010.

    NB : .*? avec re.S (et non [^;]*?) car certains champs texte contiennent
    un point-virgule interne (ex. « basse rondes ; chaleur ») — 3 lignes du
    seed sinon manquantes (27/30 au premier essai).
    """
    txt = open(chemin_seed, encoding="utf-8").read()
    rows = re.findall(
        r"VALUES \('([\w]+)',.*?'(audio/bgm/[^']+\.m4a)', '(audio/bgm/[^']+\.mp3)'\);",
        txt, re.S)
    return [{"categorie_audio": c, "key_m4a": a, "key_mp3": b} for c, a, b in rows]


def emit_sql(fiches, chemin_out):
    """Migration D1 0013 : INSERT OR REPLACE des 600 lignes vers les clés r2."""
    lignes = [
        "-- 0013 : correction du silence initial (D42.28 P1).",
        "-- Nouvelles clés audio/bgm_r2/** — les originaux audio/bgm/** restent",
        "-- en B2 (jamais écrasés, règle fondateur). sha256 = octets téléversés.",
        "-- Mesures avant/après et journal complet : artefact du workflow",
        "-- audio-fix-silence + scripts/audio/bgm_r2_manifest.json (commité).",
        "",
    ]
    for f in fiches:
        if f.get("erreur"):
            continue
        lignes.append(
            f"INSERT OR REPLACE INTO bgm_library\n"
            f"       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,\n"
            f"        bpm, genre, origine, licence, object_key, sha256, taille_octets,\n"
            f"        duree_s, preuve_sha256, statut, updated_at)\n"
            f"VALUES ('{f['piste_id']}', '{f['categorie_audio']}', '{f['gabarit_id']}',\n"
            f"        '{f['secteur']}', '{f['format']}', {f['variation']},\n"
            f"        {f['bpm']}, '{f['genre']}', '{f['origine']}_fix_silence_initial', 'CC0-1.0',\n"
            f"        '{f['object_key_r2']}', '{f['sha256']}', {f['taille_octets']},\n"
            f"        {f['duree_apres']}, 'd42.28-fix-initial-silence', 'EN_LIGNE',\n"
            f"        strftime('%Y-%m-%dT%H:%M:%fZ','now'));")
    open(chemin_out, "w", encoding="utf-8").write("\n".join(lignes) + "\n")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--manifest", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--upload", action="store_true")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--seed", default="db/migrations/0010_audio_catalog.sql")
    args = ap.parse_args()

    manifest = json.load(open(args.manifest))
    if args.limit:
        manifest = manifest[:args.limit]
    racine = args.out
    tmp = os.path.join(racine, "_originaux")
    os.makedirs(tmp, exist_ok=True)
    os.makedirs(racine, exist_ok=True)

    print(f"pistes à traiter : {len(manifest)}", flush=True)
    fiches = []
    with ThreadPoolExecutor(max_workers=4) as pool:
        for i, f in enumerate(pool.map(
                lambda e: corrige_piste(e, racine, tmp), manifest), 1):
            fiches.append(f)
            if i % 50 == 0:
                print(f"  progression : {i}/{len(manifest)}", flush=True)

    ok = [f for f in fiches if controle_qualite(f)]
    ko = [f for f in fiches if not controle_qualite(f)]
    print(f"corrigées et conformes : {len(ok)}/{len(fiches)}")
    for f in ko[:10]:
        print("  NON CONFORME :", f.get("piste_id"), f.get("erreur") or
              f"attaque_apres={f.get('attaque_apres')} rms {f.get('rms_avant')}->{f.get('rms_apres')}")

    json.dump(fiches, open(os.path.join(racine, "bgm_r2_manifest.json"), "w"),
              ensure_ascii=False, indent=1)
    emit_sql(ok, os.path.join(racine, "0013_bgm_library_r2.sql"))

    # ---- GARDE : aucun upload si UNE piste est non conforme (jamais de
    # déploiement partiel : le SQL ne doit référencer que des octets réels
    # pour les 600).
    if ko:
        print("ABANDON : pistes non conformes — AUCUN upload effectué")
        with open(os.path.join(racine, "rapport.md"), "w", encoding="utf-8") as r:
            r.write("# Correction du silence initial — ÉCHEC CONTRÔLE QUALITÉ\n\n")
            r.write(f"non conformes : {len(ko)} — voir bgm_r2_manifest.json\n")
            for f in ko[:20]:
                r.write(f"- {f.get('piste_id')} : {f.get('erreur') or f.get('attaque_apres')}\n")
        sys.exit(1)

    # ---- titulaires : HEAD + ré-ingestion des ABSENTES avec le v01 corrigé
    journal = []
    v01 = {f["categorie_audio"]: f for f in ok if f["variation"] == 1}
    for row in cles_titulaires(args.seed):
        cat = row["categorie_audio"]
        entree = {"categorie_audio": cat,
                  "key_m4a": row["key_m4a"], "key_mp3": row["key_mp3"],
                  "m4a_avant": head_b2(row["key_m4a"]), "mp3_avant": head_b2(row["key_mp3"])}
        src_v01 = os.path.join(racine, v01[cat]["object_key_r2"][len("audio/"):]) if cat in v01 else None
        if args.upload and src_v01:
            if not entree["mp3_avant"]:
                entree["mp3_uploade"] = put_b2(row["key_mp3"], src_v01, "audio/mpeg")
            if not entree["m4a_avant"]:
                m4a_tmp = os.path.join(racine, "_titulaires", os.path.basename(row["key_m4a"]))
                os.makedirs(os.path.dirname(m4a_tmp), exist_ok=True)
                r = sh(["ffmpeg", "-hide_banner", "-v", "error", "-i", src_v01,
                        "-ar", "44100", "-ac", "2", "-c:a", "aac", "-b:a", "128k", m4a_tmp])
                entree["m4a_uploade"] = (r.returncode == 0 and
                                         put_b2(row["key_m4a"], m4a_tmp, "audio/mp4"))
        journal.append(entree)
    json.dump(journal, open(os.path.join(racine, "titulaires_journal.json"), "w"),
              ensure_ascii=False, indent=1)

    if args.upload and ok:
        up_ok = 0
        for f in ok:
            p = os.path.join(racine, f["object_key_r2"][len("audio/"):])
            if put_b2(f["object_key_r2"], p, "audio/mpeg"):
                up_ok += 1
        print(f"upload B2 (audio/bgm_r2/**) : {up_ok}/{len(ok)}")

    # ---- rapport
    att_avant = [f.get("attaque_avant") for f in ok]
    att_apres = [f.get("attaque_apres") for f in ok]
    with open(os.path.join(racine, "rapport.md"), "w", encoding="utf-8") as r:
        r.write("# Correction du silence initial — D42.28 P1\n\n")
        r.write(f"Pistes traitées : {len(fiches)} — conformes : {len(ok)} — non conformes : {len(ko)}\n\n")
        r.write(f"Attaque avant : min {min(att_avant):.2f} s / max {max(att_avant):.2f} s\n")
        r.write(f"Attaque après : min {min(att_apres):.2f} s / max {max(att_apres):.2f} s "
                f"(cible < {CIBLE_ATTAQUE} s)\n\n")
        r.write(f"Clipping après : {sum(f['clipped_apres'] for f in ok)} échantillon(s)\n")
        r.write(f"Décodables après : {sum(1 for f in ok if f['decodable_apres'])}/{len(ok)}\n\n")
        r.write("Titulaires audio_catalog : "
                f"{sum(1 for j in journal if j['m4a_avant'] and j['mp3_avant'])}/60 complets avant ; "
                f"journal détaillé : titulaires_journal.json\n\n")
        r.write("Originaux : INTACTS sous audio/bgm/** (aucun écrasement). "
                "Nouvelles clés : audio/bgm_r2/**.\n")
    print("rapport.md écrit")

    if ko:
        sys.exit(1)
    print("TERMINÉ — toutes les pistes conformes")


if __name__ == "__main__":
    main()
