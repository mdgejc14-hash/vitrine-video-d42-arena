#!/usr/bin/env python3
"""Bibliothèque BGM procédurale — 600 pistes (6 secteurs × 5 formats × 20 variations).

Statut HONNÊTE (content/gabarits_v2/matrice_audio/LISEZ_MOI_AUDIO.md) :
  « Le plan reste de 600 masters HUMAINS distincts […] cible d'acquisition,
   pas un inventaire livré. » Ces pistes ne sont PAS des masters humains :
  origine = "synthese_procedurale_v1", licence CC0-1.0 (synthèse propre,
  aucune œuvre tierce). Elles rendent la chaîne de distribution réelle et
  testable de bout en bout (0 FCFA) en attendant l'acquisition humaine ;
  un master déposé sur le chemin titulaire <categorie_audio>.m4a/.mp3 prend
  automatiquement la priorité (route /api/v1/audio/track).

Caractéristiques par piste (déterministes, seed = crc32(piste_id)) :
  * BPM tiré dans la fenêtre du gabarit (JSON embarqué, source unique)
  * recette par famille de genre (afrobeats, afro-house, amapiano, highlife,
    coupé-décalé, afro-soul) : kick/hat/shaker/stab/basse/log-drum/pad
  * durée = barres couvrant duree_gabarit + marge, fondu de sortie propre
  * loudness RMS calibrée ≈ −16 dBFS (≈ −14 LUFS sur ce matériel, tolérance
    documentée), crête ≤ −1,5 dBTP avant encodage MP3 128 kbps stéréo

Sorties : <out>/<secteur>/<T#>/<categorie>_v<NN>.mp3 + manifeste JSON.
"""
import argparse
import hashlib
import json
import math
import os
import sys
import zlib

import numpy as np

FS = 44100
SECTEURS_FMT = None  # rempli depuis les gabarits


def midi_hz(m):
    return 440.0 * (2.0 ** ((m - 69) / 12.0))


def famille(genre):
    g = genre.lower()
    for cle, fam in [("afro-house", "afrohouse"), ("amapiano", "amapiano"),
                     ("highlife", "highlife"), ("coupé", "coupedecale"),
                     ("afro-soul", "afrosoul"), ("afrobeats", "afrobeats")]:
        if cle in g:
            return fam
    return "afrobeats"


RECETTES = {
    "afrobeats": dict(kick=[0, 7, 10], hat=[2, 6, 10, 14], shaker=list(range(16)),
                      stab=[4, 12], bass="groove8", log=[], pad=False, pluck=[]),
    "afrohouse": dict(kick=[0, 4, 8, 12], hat=[2, 6, 10, 14], shaker=list(range(0, 16, 2)),
                      stab=[8], bass="four8", log=[], pad=False, pluck=[]),
    "amapiano": dict(kick=[0, 8], hat=[4, 12], shaker=list(range(16)),
                     stab=[], bass="sparse", log=[3, 6, 11, 14], pad=True, pluck=[]),
    "highlife": dict(kick=[4, 12], hat=[2, 6, 10, 14], shaker=[1, 5, 9, 13],
                     stab=[], bass="walk", log=[], pad=False,
                     pluck=[0, 2, 4, 6, 8, 10, 12, 14]),
    "coupedecale": dict(kick=[0, 4, 8, 12, 14], hat=list(range(1, 16, 2)),
                        shaker=list(range(16)), stab=[2, 6, 10, 14],
                        bass="oct8", log=[], pad=False, pluck=[]),
    "afrosoul": dict(kick=[0, 8], hat=[6, 14], shaker=list(range(0, 16, 4)),
                     stab=[], bass="sparse", log=[], pad=True, pluck=[4, 12]),
}

PROGRESSIONS = [[0, 8, 3, 10], [0, 5, 8, 3], [0, 10, 8, 7]]


def note_buf(freq, duree, kind, rng, gain=1.0):
    n = max(8, int(duree * FS))
    t = np.arange(n) / FS
    if kind == "kick":
        f = 130 * np.exp(-t * 26) + 45
        ph = 2 * np.pi * np.cumsum(f) / FS
        sig = np.sin(ph) * np.exp(-t * 16)
        sig[: int(0.004 * FS)] += rng.standard_normal(int(0.004 * FS)) * 0.35
    elif kind in ("hat", "shaker"):
        bruit = rng.standard_normal(n)
        sig = np.diff(np.concatenate(([0.0], bruit)))  # passe-haut rudimentaire
        tau = 0.028 if kind == "hat" else 0.055
        sig = sig * np.exp(-t / tau) * 0.5
    elif kind == "bass":
        sig = (np.sin(2 * np.pi * freq * t) + 0.32 * np.sin(4 * np.pi * freq * t)
               + 0.12 * np.sin(6 * np.pi * freq * t))
        sig *= np.minimum(1.0, t * 300) * np.exp(-t / (duree * 0.9))
    elif kind == "stab":
        sig = np.zeros(n)
        for h, g in [(1, 1.0), (2, 0.45), (3, 0.3), (4.02, 0.18)]:
            sig += g * np.sin(2 * np.pi * freq * h * t + rng.random() * 0.4)
        sig *= np.minimum(1.0, t * 500) * np.exp(-t / (duree * 0.55)) * 0.4
    elif kind == "pluck":
        sig = np.zeros(n)
        for h, g in [(1, 1.0), (2.01, 0.5), (3.0, 0.25), (5.02, 0.12)]:
            sig += g * np.sin(2 * np.pi * freq * h * t)
        sig *= np.minimum(1.0, t * 800) * np.exp(-t / (duree * 0.4)) * 0.35
    elif kind == "log":
        f = freq * np.exp(-t * 5.5) * 0.5 + freq * 0.6
        ph = 2 * np.pi * np.cumsum(f) / FS
        sig = np.sin(ph) * np.exp(-t / (duree * 0.8)) * 0.8
        sig[: int(0.003 * FS)] += rng.standard_normal(int(0.003 * FS)) * 0.25
    elif kind == "pad":
        sig = np.zeros(n)
        for h, g in [(1, 0.6), (1.5, 0.35), (2, 0.3)]:
            sig += g * np.sin(2 * np.pi * freq * h * t + rng.random() * 1.5)
        att = np.minimum(1.0, t / 0.6)
        rel = np.minimum(1.0, (duree - t) / 0.8)
        sig *= np.clip(att * rel, 0, 1) * 0.16
    else:
        sig = np.zeros(n)
    return (sig * gain).astype(np.float32)


def ajoute(buf, sig, t0_s):
    i0 = int(t0_s * FS)
    i1 = min(len(buf), i0 + len(sig))
    if i0 < len(buf):
        buf[i0:i1] += sig[: i1 - i0]


def genere_piste(piste, rng):
    bpm = piste["bpm"]
    spb = 60.0 / bpm
    step = spb / 4.0
    cible_s = piste["duree_gabarit_s"] + 14.0
    barres = int(min(20, max(12, math.ceil(cible_s / (4 * spb)))))
    n = int(barres * 4 * spb * FS)
    buf = np.zeros(n, dtype=np.float32)
    rec = RECETTES[piste["famille"]]
    prog = PROGRESSIONS[rng.integers(0, len(PROGRESSIONS))]
    racine = int(rng.integers(43, 49))
    for barre in range(barres):
        deg = prog[barre % len(prog)]
        root = racine + deg
        t_bar = barre * 4 * spb
        for s in rec["kick"]:
            ajoute(buf, note_buf(0, 0.16, "kick", rng, 0.9), t_bar + s * step)
        for s in rec["hat"]:
            ajoute(buf, note_buf(0, 0.05, "hat", rng, 0.22), t_bar + s * step)
        for s in rec["shaker"]:
            ajoute(buf, note_buf(0, 0.07, "shaker", rng, 0.10), t_bar + s * step)
        for s in rec["stab"]:
            for iv in (0, 4 if rng.random() < 0.5 else 3, 7):
                ajoute(buf, note_buf(midi_hz(root + 12 + iv), 0.22, "stab", rng, 0.5),
                       t_bar + s * step)
        for s in rec["pluck"]:
            iv = [0, 7, 12, 10, 7, 3, 0, 5][s % 8]
            ajoute(buf, note_buf(midi_hz(root + 24 + iv), 0.16, "pluck", rng, 0.6),
                   t_bar + s * step)
        for s in rec["log"]:
            ajoute(buf, note_buf(midi_hz(root - 12), 0.3, "log", rng, 0.7),
                   t_bar + s * step)
        # basse
        if rec["bass"] == "groove8":
            seq = [(0, 0), (3, 0), (6, 12), (8, 0), (11, 7), (14, 12)]
        elif rec["bass"] == "four8":
            seq = [(s, 0) for s in range(0, 16, 2)]
        elif rec["bass"] == "oct8":
            seq = [(s, 12 if s % 4 == 2 else 0) for s in range(0, 16, 2)]
        elif rec["bass"] == "walk":
            seq = [(0, 0), (4, 7), (8, 12), (12, 7)]
        else:
            seq = [(0, 0), (8, 0)]
        for s, iv in seq:
            ajoute(buf, note_buf(midi_hz(root - 12 + iv), step * 1.7, "bass", rng, 0.55),
                   t_bar + s * step)
        if rec["pad"] and barre % 2 == 0:
            for iv in (0, 3, 7, 10):
                ajoute(buf, note_buf(midi_hz(root + 12 + iv), 8 * spb, "pad", rng, 0.5),
                       t_bar)
    # forme globale : fondu entrée/sortie, pas de clic
    fade_in = np.minimum(1.0, np.arange(n) / (0.25 * FS))
    fade_out = np.minimum(1.0, np.arange(n)[::-1] / (1.6 * FS))
    np.multiply(buf, fade_in.astype(np.float32), out=buf)
    np.multiply(buf, fade_out.astype(np.float32), out=buf)
    # calibration loudness : RMS ≈ −16 dBFS, crête ≤ −1,5 dBTP
    rms = float(np.sqrt(np.mean(buf ** 2))) or 1e-9
    buf *= (10 ** (-16 / 20)) / rms
    peak = float(np.max(np.abs(buf))) or 1e-9
    if peak > 0.84:
        buf *= 0.84 / peak
    # stéréo léger : copie retardée + différence de grave
    droit = np.roll(buf, 17) * 0.985
    return buf, droit


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="/tmp/bgm_out")
    ap.add_argument("--manifest", default="/tmp/bgm_lib_manifest.json")
    ap.add_argument("--variations", type=int, default=20)
    args = ap.parse_args()

    repo = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    import glob as _glob
    gabarits = []
    for f in sorted(_glob.glob(os.path.join(repo, "data/src/main/assets/gabarits/*/*.json"))):
        d = json.load(open(f, encoding="utf-8"))
        mus = d["audio"]["musique"]
        gabarits.append({
            "gabarit_id": d["id"], "secteur": d["secteur"],
            "format": d["format"].split("_")[0],
            "categorie_audio": mus["categorie_audio"], "genre": mus["genre"],
            "bpm_min": int(mus["bpm_min"]), "bpm_max": int(mus["bpm_max"]),
            "duree_gabarit_s": d["duree_totale_secondes"],
        })
    gen_path = os.path.join(repo, "scripts/audio/generate_bgm_library.py")
    preuve = hashlib.sha256(open(gen_path, "rb").read()).hexdigest()

    import lameenc
    entrees = []
    for g in gabarits:
        fam = famille(g["genre"])
        for v in range(1, args.variations + 1):
            piste_id = f"{g['categorie_audio']}_v{v:02d}"
            rng = np.random.default_rng(zlib.crc32(piste_id.encode()) & 0xFFFFFFFF)
            bpm = int(rng.integers(g["bpm_min"], g["bpm_max"] + 1))
            piste = dict(g, bpm=bpm, famille=fam, duree_gabarit_s=g["duree_gabarit_s"])
            gauche, droit = genere_piste(piste, rng)
            n = len(gauche)
            inter = np.empty(n * 2, dtype=np.int16)
            gl = np.clip(gauche, -1, 1) * 32767
            dr = np.clip(droit, -1, 1) * 32767
            inter[0::2] = gl.astype(np.int16)
            inter[1::2] = dr.astype(np.int16)
            enc = lameenc.Encoder()
            enc.set_bit_rate(128)
            enc.set_in_sample_rate(FS)
            enc.set_channels(2)
            enc.set_quality(5)
            mp3 = enc.encode(inter.tobytes()) + enc.flush()
            dossier = os.path.join(args.out, g["secteur"], g["format"])
            os.makedirs(dossier, exist_ok=True)
            chemin = os.path.join(dossier, f"{piste_id}.mp3")
            open(chemin, "wb").write(mp3)
            entrees.append({
                "piste_id": piste_id,
                "categorie_audio": g["categorie_audio"],
                "gabarit_id": g["gabarit_id"],
                "secteur": g["secteur"],
                "format": g["format"],
                "variation": v,
                "bpm": bpm,
                "genre": g["genre"],
                "famille": fam,
                "duree_s": round(n / FS, 3),
                "object_key": f"audio/bgm/{g['secteur']}/{g['format']}/{piste_id}.mp3",
                "sha256": hashlib.sha256(mp3).hexdigest(),
                "taille_octets": len(mp3),
                "origine": "synthese_procedurale_v1",
                "licence": "CC0-1.0",
                "preuve_sha256": preuve,
            })
        print(f"  {g['gabarit_id']:26s} {args.variations} variations OK", flush=True)
    json.dump(entrees, open(args.manifest, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    total = sum(e["taille_octets"] for e in entrees)
    print(f"manifeste : {len(entrees)} pistes, {total/1e6:.0f} Mo -> {args.manifest}", flush=True)


if __name__ == "__main__":
    sys.exit(main())
