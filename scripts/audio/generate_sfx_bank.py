#!/usr/bin/env python3
"""Banque SFX locale — 9 catégories du contrat (banque_9_categories_sfx_a_acquerir.csv).

Génération procédurale déterministe (seed fixe), stdlib uniquement :
  * WAV PCM 48 kHz, mono, 16 bits (format_cible banque v2.0)
  * durées exactes du contrat (duree_cible_s)
  * normalisation crête -1,7 dBFS (marge pour le mixage ducking -14 dB)
  * manifeste conforme sfx_local_v1_3.schema.json, licence CC0-1.0
    (sons synthétisés par ce script : aucune œuvre tierce)

Sortie : data/src/main/assets/audio/sfx/<categorie>.wav + manifest_sfx_v1_3.json

⚠ Gouvernance : revision_humaine_approuvee=false tant qu'une oreille humaine n'a
pas validé la banque (const true du schéma v1.3). Procédure d'approbation dans
docs/AUDIO_BGM_TELEVERSEMENT.md §SFX. Régénérer bit-à-bit :
  python3 scripts/audio/generate_sfx_bank.py
"""
import datetime
import hashlib
import json
import math
import os
import random
import struct
import wave

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT_DIR = os.path.join(REPO, "data/src/main/assets/audio/sfx")
FS = 48000
SEED = 20261031
PEAK_TARGET = 0.82  # ~ -1,7 dBFS

# duree_cible_s du contrat (banque_9_categories_sfx_a_acquerir.csv)
DUREES = {
    "whoosh_soft": 0.35,
    "whoosh_fast": 0.22,
    "caisse_enregistreuse": 0.55,
    "clic_appareil": 0.12,
    "impact_drop": 0.22,
    "pop_badge": 0.16,
    "amb_chantier": 2.50,
    "sizzle_grill": 1.00,
    "vapeur_plat": 1.00,
}


# ------------------------------------------------------------------ DSP utils
def sweep(t, f0, f1):
    """fréquence instantanée : interpolation exponentielle f0 -> f1 sur t∈[0,1]."""
    return f0 * (f1 / f0) ** t


def integrate_freq(n, f0, f1):
    """phase accumulée d'un sweep exponentiel (n samples)."""
    ph = []
    acc = 0.0
    for i in range(n):
        t = i / max(1, n - 1)
        acc += 2 * math.pi * sweep(t, f0, f1) / FS
        ph.append(acc)
    return ph


def svf_bandpass(xs, fc_fn, q=1.0):
    """State-variable filter, centre piloté par fc_fn(i/n)->Hz."""
    n = len(xs)
    low = band = 0.0
    out = []
    for i, x in enumerate(xs):
        f = 2.0 * math.sin(math.pi * min(max(fc_fn(i / n), 40.0), FS / 2.5) / FS)
        damp = 1.0 / q
        high = x - low - damp * band
        band = f * high + band
        low = low + f * band
        out.append(band)
    return out


def env_ad(n, attack_frac, decay_tau_frac=3.0):
    """attaque linéaire puis décroissance exponentielle."""
    a = int(n * attack_frac)
    out = []
    for i in range(n):
        if i < a:
            out.append(i / max(1, a))
        else:
            out.append(math.exp(-(i - a) / (n / decay_tau_frac)))
    return out


def bell(n, partials, t0=0):
    """cluster métallique : somme de partiels inharmoniques désaccordés."""
    out = [0.0] * n
    for fk, amp, tau in partials:
        det = 1.0 + ((hash((fk, tau)) % 7) - 3) * 0.0009
        for i in range(t0, n):
            t = (i - t0) / FS
            if t < 0:
                continue
            out[i] += amp * math.sin(2 * math.pi * fk * det * t) * math.exp(-t / tau)
    return out


def noise_burst(rng, n, level=1.0):
    return [rng.uniform(-level, level) for _ in range(n)]


def highpass1(xs, fc):
    """passe-haut un pôle."""
    r = math.exp(-2 * math.pi * fc / FS)
    y = prev_x = prev_y = 0.0
    out = []
    for x in xs:
        y = r * (prev_y + x - prev_x)
        out.append(y)
        prev_x, prev_y = x, y
    return out


def lowpass1(xs, fc):
    a = 1.0 - math.exp(-2 * math.pi * fc / FS)
    y = 0.0
    out = []
    for x in xs:
        y += a * (x - y)
        out.append(y)
    return out


def brown(rng, n):
    b = 0.0
    out = []
    for _ in range(n):
        b = (b + 0.02 * rng.uniform(-1, 1)) / 1.02
        out.append(b * 3.5)
    return out


def normalize(xs, peak=PEAK_TARGET):
    m = max((abs(x) for x in xs), default=0.0)
    if m == 0:
        return xs
    g = peak / m
    return [x * g for x in xs]


def mix(dst, src, t0, gain=1.0):
    for i, v in enumerate(src):
        j = t0 + i
        if 0 <= j < len(dst):
            dst[j] += v * gain


# ------------------------------------------------------------------ recettes
def gen_whoosh(rng, n, f_mid, f_out, q, attack):
    xs = noise_burst(rng, n)
    e = env_ad(n, attack)
    fc = lambda t: sweep(t, f_mid * 0.45, f_mid) if t < 0.5 else sweep((t - 0.5) * 2, f_mid, f_out)
    ys = svf_bandpass(xs, fc, q)
    return [y * e[i] for i, y in enumerate(ys)]


def gen_caisse(rng, n):
    out = [0.0] * n
    # « ka » : bruit sec passé en haut, 40 ms
    ka = highpass1(noise_burst(rng, int(0.04 * FS)), 2500)
    ka = [v * env_ad(len(ka), 0.05, 2.0)[i] for i, v in enumerate(ka)]
    mix(out, ka, 0, 0.85)
    # cliquetis métallique bref
    mix(out, bell(n, [(1750, 0.5, 0.02), (2630, 0.35, 0.015)], 0), 0, 1.0)
    # « ching » : cloche à t=0.18 s
    ching = bell(n, [(2637, 0.6, 0.16), (3951, 0.45, 0.12), (5274, 0.3, 0.09), (6400, 0.18, 0.06)],
                 int(0.18 * FS))
    mix(out, ching, 0, 1.0)
    # queue : petit rebond de pièces 0.34 s
    for k, t in enumerate([0.34, 0.40, 0.45]):
        mix(out, bell(n, [(3100 + 400 * k, 0.16, 0.03)], int(t * FS)), 0, 1.0 - 0.25 * k)
    return out


def gen_clic(rng, n):
    out = [0.0] * n
    tr = highpass1(noise_burst(rng, int(0.003 * FS)), 3000)
    mix(out, tr, 0, 1.0)
    tick = [math.sin(2 * math.pi * 3200 * i / FS) * math.exp(-i / (0.012 * FS))
            for i in range(int(0.05 * FS))]
    mix(out, tick, 0, 0.55)
    tail = lowpass1(noise_burst(rng, n), 900)
    mix(out, tail, 0, 0.05)
    return out


def gen_pop(rng, n):
    ph = integrate_freq(n, 880, 300)
    e = env_ad(n, 0.04, 2.6)
    out = [math.sin(p) * e[i] for i, p in enumerate(ph)]
    mix(out, highpass1(noise_burst(rng, int(0.004 * FS)), 2200), 0, 0.5)
    return out


def gen_impact(rng, n):
    ph = integrate_freq(n, 135, 46)
    e = env_ad(n, 0.01, 2.2)
    out = [math.sin(p) * e[i] for i, p in enumerate(ph)]
    body = [math.sin(2 * math.pi * 195 * i / FS) * math.exp(-i / (0.02 * FS)) for i in range(n)]
    mix(out, body, 0, 0.4)
    mix(out, highpass1(noise_burst(rng, int(0.005 * FS)), 1800), 0, 0.7)
    return out


def gen_sizzle(rng, n):
    xs = highpass1(noise_burst(rng, n), 3200)
    # crépitements : impulsions éparses
    for _ in range(int(n / FS * 90)):
        t = rng.randrange(0, n - int(0.006 * FS))
        amp = rng.uniform(0.25, 1.0)
        ln = int(0.004 * FS)
        burst = noise_burst(rng, ln, amp)
        mix(xs, [v * math.exp(-i / (ln / 3)) for i, v in enumerate(burst)], t, 1.0)
    # fluctuation lente d'amplitude (feu vivant)
    return [v * (0.75 + 0.25 * math.sin(2 * math.pi * 3.1 * i / FS + rng.random() * 6.28))
            for i, v in enumerate(xs)]


def gen_vapeur(rng, n):
    xs = noise_burst(rng, n)
    fc = lambda t: sweep(t, 650, 1900) if t < 0.6 else sweep((t - 0.6) / 0.4, 1900, 900)
    ys = svf_bandpass(xs, fc, 0.8)
    a, r = int(n * 0.35), int(n * 0.35)
    e = []
    for i in range(n):
        if i < a:
            e.append(i / a)
        elif i > n - r:
            e.append((n - i) / r)
        else:
            e.append(1.0)
    return [y * e[i] * (0.9 + 0.1 * math.sin(2 * math.pi * 5.5 * i / FS)) for i, y in enumerate(ys)]


def gen_chantier(rng, n):
    out = lowpass1(brown(rng, n), 240)          # rumble de fond
    vent = svf_bandpass(noise_burst(rng, n), lambda t: sweep(t, 300, 500), 0.7)
    mix(out, vent, 0, 0.10)
    # clinks métalliques épars (tôles, échafaudage)
    for t_s in [0.32, 0.78, 1.24, 1.71, 2.06]:
        f = rng.choice([880, 1150, 1480, 1900])
        amp = rng.uniform(0.30, 0.55)
        cl = bell(n, [(f, amp, 0.12), (f * 2.41, amp * 0.5, 0.08), (f * 3.7, amp * 0.25, 0.05)],
                  int(t_s * FS))
        mix(out, cl, 0, 1.0)
    # deux impacts sourds lointains
    for t_s in [0.55, 1.45]:
        th = integrate_freq(int(0.18 * FS), 90, 42)
        e = env_ad(len(th), 0.02, 2.0)
        imp = [math.sin(p) * e[i] * 0.5 for i, p in enumerate(th)]
        mix(out, imp, int(t_s * FS), 1.0)
    # fondu doux entrée/sortie
    fade = int(0.08 * FS)
    for i in range(fade):
        out[i] *= i / fade
        out[n - 1 - i] *= i / fade
    return out


RECETTES = {
    "whoosh_soft": lambda rng, n: gen_whoosh(rng, n, 700, 300, 1.15, 0.40),
    "whoosh_fast": lambda rng, n: gen_whoosh(rng, n, 1500, 700, 0.9, 0.15),
    "caisse_enregistreuse": gen_caisse,
    "clic_appareil": gen_clic,
    "impact_drop": gen_impact,
    "pop_badge": gen_pop,
    "sizzle_grill": gen_sizzle,
    "vapeur_plat": gen_vapeur,
    "amb_chantier": gen_chantier,
}


def write_wav(path, xs):
    xs = normalize(xs)
    frames = bytearray()
    for x in xs:
        v = int(max(-1.0, min(1.0, x)) * 32767)
        frames += struct.pack("<h", v)
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(FS)
        w.writeframes(bytes(frames))
    return xs


def approuver_humain():
    """Bascule la banque en APPROUVEE_HUMAINE (après écoute réelle des 9 fichiers).
    Ne régénère aucun échantillon : les sha256 restent ceux de la banque générée."""
    mpath = os.path.join(OUT_DIR, "manifest_sfx_v1_3.json")
    m = json.load(open(mpath, encoding="utf-8"))
    for e in m["entrees"]:
        e["revision_humaine_approuvee"] = True
    m["statut_global"] = "APPROUVEE_HUMAINE"
    m["approuve_le"] = datetime.date.today().isoformat()
    open(mpath, "w", encoding="utf-8").write(json.dumps(m, ensure_ascii=False, indent=1))
    print("banque approuvée humainement :", mpath)


def main():
    if "--approuver" in __import__("sys").argv:
        approuver_humain()
        return
    os.makedirs(OUT_DIR, exist_ok=True)
    gen_path = os.path.join(REPO, "scripts/audio/generate_sfx_bank.py")
    preuve_sha = hashlib.sha256(open(gen_path, "rb").read()).hexdigest()
    entrees = []
    for cat in sorted(DUREES):
        rng = random.Random(SEED + sum(ord(c) for c in cat))
        n = int(round(DUREES[cat] * FS))
        xs = write_wav(os.path.join(OUT_DIR, f"{cat}.wav"), RECETTES[cat](rng, n))
        raw = open(os.path.join(OUT_DIR, f"{cat}.wav"), "rb").read()
        impact = max(range(len(xs)), key=lambda i: abs(xs[i]))
        rms = math.sqrt(sum(x * x for x in xs) / len(xs))
        entrees.append({
            "schema_version": "1.3",
            "categorie_json": cat,
            "chemin_logique": f"assets/audio/sfx/{cat}.wav",
            "taille_octets": len(raw),
            "sha256": hashlib.sha256(raw).hexdigest(),
            "audio_hz": FS,
            "duree_samples": n,
            "sample_impact_fichier": impact,
            "licence_code": "CC0-1.0",
            "preuve_id": "gensfx-v1-20261031",
            "preuve_sha256": preuve_sha,
            "revision_humaine_approuvee": False,
        })
        print(f"  {cat:22s} {n/FS:5.2f}s  rms={20*math.log10(max(rms,1e-9)):6.1f} dBFS  impact@{impact}")
    manifest = {
        "schema": "manifest_sfx_v1_3",
        "genere_le": "2026-10-31",
        "generateur": "scripts/audio/generate_sfx_bank.py",
        "generateur_sha256": preuve_sha,
        "statut_global": "EN_ATTENTE_REVISION_HUMAINE",
        "entrees": entrees,
    }
    mpath = os.path.join(OUT_DIR, "manifest_sfx_v1_3.json")
    open(mpath, "w", encoding="utf-8").write(json.dumps(manifest, ensure_ascii=False, indent=1))
    print("manifeste :", os.path.relpath(mpath, REPO))
    total = sum(e["taille_octets"] for e in entrees)
    print(f"banque : 9 fichiers, {total/1024:.0f} Ko embarqués (APK)")


if __name__ == "__main__":
    main()
