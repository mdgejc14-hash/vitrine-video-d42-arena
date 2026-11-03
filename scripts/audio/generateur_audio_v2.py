#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generateur audio Vitrine Video v2 — synthese_procedurale_v2
============================================================
600 BGM uniques (100/secteur : 5 formats x 20 variations) + 9 SFX uniques.
Cibles : LUFS integre -16.0 +/-0.1 (mesure APRES encodage, 2 passes),
true peak <= -1.0 dBTP, MP3 CBR 128 kbps 44.1 kHz stereo (BGM),
WAV PCM 48 kHz mono 16 bits (SFX, spec banque_9 v2.0).
Deterministe : seed = sha256(piste_id). Reproductible a l'identique.
Marqueurs musicaux : BPM dans la fenetre du gabarit (matrice Drive),
riser place sur riser_debut_nominal_s, impact sur drop_debut_nominal_s,
duree = duree_totale_source_s + queue 3..10 s.
Aucun fichier n'a la meme signature (gabarit, bpm, tonalite, seed).
"""
import argparse
import hashlib
import json
import os
import sys
import time

import numpy as np
from scipy.signal import butter, lfilter, resample_poly

SR = 44100
SR_SFX = 48000
TARGET_LUFS = -16.0
TOL_LUFS = 0.10
TP_MAX = -1.0

ROOT = os.path.dirname(os.path.abspath(__file__))
OUT_BGM = os.path.join(ROOT, "out", "bgm")
OUT_SFX = os.path.join(ROOT, "out", "sfx")

# ---------------------------------------------------------------- loudness --
_KW = {
    44100: (
        np.array([1.53512485958697, -2.69169618940638, 1.19839281085285]),
        np.array([1.0, -1.69065929318241, 0.73248077421585]),
        np.array([1.0, -2.0, 1.0]),
        np.array([1.0, -1.99004745483398, 0.99007225036621]),
    ),
    48000: (
        np.array([1.5309104078646905, -2.6509799301490517, 1.1690790860486545]),
        np.array([1.0, -1.6636551132560204, 0.7126950591790376]),
        np.array([1.0, -2.0, 1.0]),
        np.array([1.0, -1.9684856154539116, 0.9690790983264579]),
    ),
}


def k_weight(x, sr):
    b1, a1, b2, a2 = _KW[sr]
    y = lfilter(b1, a1, x.astype(np.float64), axis=0)
    return lfilter(b2, a2, y, axis=0)


def integrated_loudness(x, sr):
    """BS.1770-4, x : (n,) ou (n,ch)."""
    x = np.asarray(x, dtype=np.float64)
    if x.ndim == 1:
        x = x[:, None]
    if x.shape[0] < int(0.4 * sr):
        # fichier tres court : loudness momentanee non gatee (cas SFX courts)
        y = k_weight(x, sr)
        z = float(np.mean(y ** 2))
        return -0.691 + 10.0 * np.log10(max(z, 1e-12))
    y = k_weight(x, sr)
    B = int(0.4 * sr)
    step = B // 4
    c2 = np.cumsum(np.insert(y ** 2, 0, 0.0, axis=0), axis=0)
    starts = np.arange(0, x.shape[0] - B + 1, step)
    if len(starts) == 0:
        starts = np.array([0])
        B = x.shape[0]
    block_ms = (c2[starts + B] - c2[starts]) / B
    with np.errstate(divide="ignore"):
        block_l = -0.691 + 10.0 * np.log10(np.maximum(np.sum(block_ms, axis=1), 1e-12))
    g = block_l[block_l > -70.0]
    if len(g) == 0:
        return -np.inf
    z = np.mean(10.0 ** ((g + 0.691) / 10.0))
    gamma_r = -0.691 + 10.0 * np.log10(max(z, 1e-12)) - 10.0
    g2 = block_l[block_l > gamma_r]
    if len(g2) == 0:
        g2 = g
    z2 = np.mean(10.0 ** ((g2 + 0.691) / 10.0))
    return -0.691 + 10.0 * np.log10(max(z2, 1e-12))


def true_peak_dbtp(x, sr):
    up = resample_poly(np.asarray(x, dtype=np.float64), 4, 1, axis=0)
    return 20.0 * np.log10(max(float(np.max(np.abs(up))), 1e-12))


ASYM = 0.70  # asymptote du limiteur (-3.1 dBFS) : marge overshoot inter-échantillons + MP3


def soft_limit(x, knee=0.55, asym=ASYM):
    """Distorsion douce : |x| <= knee inchangé, au-delà compression tanh
    vers asym (jamais atteint). Garantit peak <= asym."""
    m = float(np.max(np.abs(x)))
    if m <= knee:
        return x
    a = np.abs(x)
    over = a > knee
    y = x.copy()
    head = asym - knee
    y[over] = np.sign(x[over]) * (knee + head * np.tanh((a[over] - knee) / head))
    return y


# ------------------------------------------------------------- primitives --
def midi2f(m):
    return 440.0 * 2.0 ** ((m - 69) / 12.0)


def _exp_decay(n, sr, tau):
    t = np.arange(n, dtype=np.float32) / sr
    return np.exp(-t / tau).astype(np.float32)


def _noise(rng, n):
    return rng.standard_normal(n).astype(np.float32)


def _lp(x, sr, fc, order=2):
    b, a = butter(order, min(fc, sr * 0.45) / (sr / 2), btype="low")
    return lfilter(b, a, x).astype(np.float32)


def _hp(x, sr, fc, order=2):
    b, a = butter(order, max(fc, 1.0) / (sr / 2), btype="high")
    return lfilter(b, a, x).astype(np.float32)


def _bp(x, sr, f0, q=1.0, order=2):
    lo, hi = sorted([f0 * q ** 0.5, f0 / q ** 0.5])
    lo = max(lo, 20.0)
    hi = min(hi, sr * 0.45)
    if hi <= lo * 1.01:
        return _lp(x, sr, lo * 1.5, order)
    b, a = butter(order, [lo / (sr / 2), hi / (sr / 2)], btype="band")
    return lfilter(b, a, x).astype(np.float32)


def kick(rng, sr, var=0, amp=1.0):
    f0, f1, tau, click = [(155, 46, 0.16, 0.5), (115, 37, 0.26, 0.3), (175, 56, 0.12, 0.7)][var % 3]
    n = int(sr * 0.42)
    t = np.arange(n, dtype=np.float32) / sr
    f = f1 + (f0 - f1) * np.exp(-t / 0.028)
    y = np.sin(2 * np.pi * np.cumsum(f) / sr).astype(np.float32)
    y *= _exp_decay(n, sr, tau)
    c = _hp(_noise(rng, int(sr * 0.004)), sr, 2500) * click
    y[: len(c)] += c
    return (y * amp).astype(np.float32)


def shaker_hit(rng, sr, amp=1.0, dur=0.05, bright=1.0):
    n = int(sr * dur)
    y = _hp(_noise(rng, n), sr, 5200 * bright)
    y *= _exp_decay(n, sr, dur / 4.5)
    return (y * amp * 0.6).astype(np.float32)


def clap_hit(rng, sr, amp=1.0):
    n = int(sr * 0.16)
    y = np.zeros(n, np.float32)
    for k, off in enumerate((0.0, 0.011, 0.023)):
        m = int(sr * 0.05)
        i0 = int(sr * off)
        b = _bp(_noise(rng, m), sr, 1750, q=1.4) * _exp_decay(m, sr, 0.014) * (0.7 ** k)
        y[i0 : i0 + m] += b
    tail = _bp(_noise(rng, n), sr, 1400, q=0.9) * _exp_decay(n, sr, 0.05)
    return ((y * 0.8 + tail * 0.5) * amp).astype(np.float32)


def snare_hit(rng, sr, amp=1.0, tone=210.0):
    n = int(sr * 0.2)
    t = np.arange(n, dtype=np.float32) / sr
    body = np.sin(2 * np.pi * tone * t) * _exp_decay(n, sr, 0.06)
    nz = _bp(_noise(rng, n), sr, 3200, q=0.8) * _exp_decay(n, sr, 0.05)
    return ((body * 0.55 + nz * 0.65) * amp).astype(np.float32)


def conga_hit(rng, sr, amp=1.0, f=240.0):
    n = int(sr * 0.28)
    t = np.arange(n, dtype=np.float32) / sr
    y = np.sin(2 * np.pi * f * t) + 0.4 * np.sin(2 * np.pi * f * 1.51 * t)
    y = y.astype(np.float32) * _exp_decay(n, sr, 0.09)
    sl = _bp(_noise(rng, int(sr * 0.006)), sr, 2600, q=1.0) * 0.3
    y[: len(sl)] += sl
    return (y * amp * 0.6).astype(np.float32)


def metal_hit(rng, sr, amp=1.0, base=520.0):
    n = int(sr * 0.5)
    t = np.arange(n, dtype=np.float32) / sr
    y = np.zeros(n, np.float32)
    for r, g in ((1.0, 1.0), (2.76, 0.55), (5.40, 0.3), (8.93, 0.18)):
        y += (g * np.sin(2 * np.pi * base * r * t + rng.uniform(0, 6.28))).astype(np.float32) * _exp_decay(n, sr, 0.11 / r**0.5)
    return (y * amp * 0.5).astype(np.float32)


def logdrum_note(rng, sr, f, dur=0.3, amp=1.0):
    n = int(sr * dur)
    t = np.arange(n, dtype=np.float32) / sr
    pitch = f * (1.0 + 2.2 * np.exp(-t / 0.045))
    y = np.sin(2 * np.pi * np.cumsum(pitch) / sr).astype(np.float32)
    y += 0.25 * np.sin(4 * np.pi * np.cumsum(pitch) / sr).astype(np.float32)
    y *= _exp_decay(n, sr, dur / 3.2)
    atk = _lp(_noise(rng, int(sr * 0.005)), sr, 1800) * 0.25
    y[: len(atk)] += atk
    return (y * amp * 0.85).astype(np.float32)


def sub_note(sr, f, dur, amp=1.0):
    n = int(sr * dur)
    t = np.arange(n, dtype=np.float32) / sr
    y = np.sin(2 * np.pi * f * t).astype(np.float32)
    e = np.minimum(t / 0.012, 1.0) * np.minimum((dur - t) / 0.05, 1.0).clip(0, 1)
    return (y * e * amp).astype(np.float32)


def ks_note(rng, sr, f, dur, amp=1.0, bright=0.5, fb=0.4965):
    """Karplus-Strong vectorise (lfilter comb) — guitare palm-wine/pluck."""
    N = max(int(round(sr / f)), 2)
    n = int(sr * dur)
    exc = np.zeros(N, np.float32)
    m = min(N, int(sr * 0.004))
    exc[:m] = _lp(_noise(rng, m), sr, 2600 + 5200 * bright) * np.linspace(1.0, 0.2, m)
    a = np.zeros(N + 2)
    a[0] = 1.0
    a[N] = -fb
    a[N + 1] = -fb * (0.4 + 0.5 * bright)
    y = lfilter(np.array([1.0]), a, np.concatenate([exc, np.zeros(n, np.float32)]))
    y = y[N : N + n]
    e = _exp_decay(n, sr, dur / 2.6)
    fade = min(int(sr * 0.01), n)
    e[:fade] *= np.linspace(0, 1, fade)
    return (y * e * amp * 2.2).astype(np.float32)


def rhodes_chord(sr, freqs, dur, amp=1.0, warm=1.0):
    n = int(sr * dur)
    t = np.arange(n, dtype=np.float32) / sr
    y = np.zeros(n, np.float32)
    for i, f in enumerate(freqs):
        mod = 2.0 * warm * np.exp(-t * 5.5)
        y += (np.sin(2 * np.pi * f * t + mod * np.sin(2 * np.pi * 2 * f * t)) * (0.8 ** i)).astype(np.float32)
    att = np.minimum(t / 0.010, 1.0)
    y *= att * np.minimum((dur - t) / 0.18, 1.0).clip(0, 1) * _exp_decay(n, sr, max(dur / 1.6, 0.35))
    return (y / max(len(freqs), 1) * amp * 1.6).astype(np.float32)


def pad_chord(rng, sr, freqs, dur, amp=1.0):
    n = int(sr * dur)
    t = np.arange(n, dtype=np.float32) / sr
    y = np.zeros(n, np.float32)
    for f in freqs:
        for det in (-0.003, 0.003):
            h = np.zeros(n, np.float32)
            for k, g in ((1, 1.0), (2, 0.42), (3, 0.22), (4, 0.12), (5, 0.07)):
                h += (g * np.sin(2 * np.pi * f * (1 + det) * k * t + rng.uniform(0, 6.28))).astype(np.float32)
            y += h
    att = np.minimum(t / 0.22, 1.0)
    rel = np.minimum((dur - t) / 0.35, 1.0).clip(0, 1)
    y *= att * rel
    y = _lp(y, sr, 5200)
    return (y / max(2 * len(freqs), 1) * amp * 2.4).astype(np.float32)


def melody_note(rng, sr, f, dur, amp=1.0, vib=4.5):
    n = int(sr * dur)
    t = np.arange(n, dtype=np.float32) / sr
    v = 1.0 + 0.004 * np.sin(2 * np.pi * vib * np.maximum(t - 0.08, 0))
    y = np.sin(2 * np.pi * f * np.cumsum(v) / sr).astype(np.float32)
    y += 0.28 * np.sin(4 * np.pi * f * np.cumsum(v) / sr).astype(np.float32)
    y += 0.10 * np.sin(6 * np.pi * f * np.cumsum(v) / sr).astype(np.float32)
    att = np.minimum(t / 0.014, 1.0)
    rel = np.minimum((dur - t) / 0.06, 1.0).clip(0, 1)
    y *= att * rel * _exp_decay(n, sr, max(dur / 1.4, 0.15))
    return (y * amp * 0.7).astype(np.float32)


def balafon_note(rng, sr, f, dur, amp=1.0):
    n = int(sr * dur)
    t = np.arange(n, dtype=np.float32) / sr
    y = np.sin(2 * np.pi * f * t) + 0.4 * np.sin(2 * np.pi * f * 2.02 * t) + 0.18 * np.sin(2 * np.pi * f * 3.9 * t)
    y = y.astype(np.float32) * _exp_decay(n, sr, dur / 3.0)
    return (y * amp * 0.5).astype(np.float32)


def riser_sfx(rng, sr, dur, amp=1.0, f0=320.0, f1=5600.0):
    n = int(sr * dur)
    t = np.arange(n, dtype=np.float32) / sr
    k = (t / dur).astype(np.float32)
    f = f0 * (f1 / f0) ** k
    chirp = np.sin(2 * np.pi * np.cumsum(f) / sr).astype(np.float32)
    nz = _hp(_noise(rng, n), sr, 500)
    bright = (0.35 + 0.65 * k).astype(np.float32)
    env = (k ** 1.7).astype(np.float32)
    y = (chirp * 0.5 + nz * bright * 0.5) * env
    return (y * amp * 0.75).astype(np.float32)


def impact_sfx(rng, sr, amp=1.0, dur=0.26):
    n = int(sr * dur)
    t = np.arange(n, dtype=np.float32) / sr
    f = 34 + (78 - 34) * np.exp(-t / 0.03)
    boom = np.sin(2 * np.pi * np.cumsum(f) / sr).astype(np.float32) * _exp_decay(n, sr, 0.09)
    crush = _lp(_noise(rng, int(sr * 0.026)), sr, 2400) * 0.5
    crush *= np.linspace(0.4, 1.0, len(crush)).astype(np.float32)
    y = boom
    y[: len(crush)] += crush
    return (y * amp).astype(np.float32)


# --------------------------------------------------------------- familles --
def family_of(genre):
    g = genre.lower()
    if "amapiano" in g:
        return "amapiano"
    if "afro-house" in g or "afro house" in g:
        return "afrohouse"
    if "highlife" in g:
        return "highlife"
    if "soul" in g:
        return "afrosoul"
    if "r&b" in g or "r-n-b" in g:
        return "afornb"
    if "coupe" in g or "coupé" in g:
        return "coupedecale"
    if "percussions afro industrielles" in g:
        return "percus_indus"
    if "percussions afro" in g:
        return "percus_feutrees"
    return "afrobeats"


FAM_GROOVE = {
    # kick sur les temps (pattern 16 pas), shaker, position clap/snare
    "afrohouse":   {"kick": [1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,1], "back": "clap",  "back_at": [4, 12], "bass": "logdrum"},
    "amapiano":    {"kick": [1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,1], "back": "clap",  "back_at": [4, 12], "bass": "logdrum"},
    "afrobeats":   {"kick": [1,0,0,0, 0,0,1,0, 0,0,1,0, 0,0,0,0], "back": "snare", "back_at": [4, 12], "bass": "pluck"},
    "highlife":    {"kick": [1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0], "back": "snare", "back_at": [12],    "bass": "sub"},
    "afrosoul":    {"kick": [1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0], "back": "snare", "back_at": [8],     "bass": "sub"},
    "afornb":      {"kick": [1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0], "back": "snare", "back_at": [8],     "bass": "sub"},
    "coupedecale": {"kick": [1,0,0,1, 0,0,1,0, 1,0,0,1, 0,0,1,0], "back": "clap",  "back_at": [4, 12], "bass": "pluck"},
    "percus_indus":   {"kick": [1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0], "back": "metal", "back_at": [6, 14], "bass": "drone"},
    "percus_feutrees":{"kick": [1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0], "back": "conga", "back_at": [3, 10], "bass": "drone"},
}

MINOR_PROG = [
    [0, 8, 3, 10], [0, 5, 8, 7], [0, 10, 8, 10], [0, 5, 7, 3], [0, 3, 10, 7], [0, 7, 5, 3],
]
MAJOR_PROG = [
    [0, 7, 9, 5], [0, 9, 5, 7], [0, 5, 9, 7], [0, 4, 5, 7], [0, 7, 4, 5],
]
MINOR_SET = [0, 2, 3, 5, 7, 8, 10]
MAJOR_SET = [0, 2, 4, 5, 7, 9, 11]
KEY_NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]


def parse_energie(s):
    s = s.replace("→", "-").replace("–", "-")
    parts = [p for p in s.split("-") if p.strip()]
    try:
        a = float(parts[0])
        b = float(parts[-1]) if len(parts) > 1 else a
    except ValueError:
        a, b = 3.0, 3.0
    return a, b


def add_at(master, sig, pos_s, sr, gain=1.0, pan=0.0):
    i0 = int(pos_s * sr)
    if i0 >= master.shape[0] or sig is None or len(sig) == 0:
        return
    m = min(len(sig), master.shape[0] - i0)
    l = gain * np.cos((pan + 1) * np.pi / 4)
    r = gain * np.sin((pan + 1) * np.pi / 4)
    master[i0 : i0 + m, 0] += sig[:m] * l
    master[i0 : i0 + m, 1] += sig[:m] * r


def build_bgm(p, rng):
    """p : dict du plan de piste. Retourne master stereo float32."""
    sr = SR
    fam = p["famille"]
    groove = FAM_GROOVE[fam]
    bpm = p["bpm"]
    beat = 60.0 / bpm
    step = beat / 4.0
    bar = 4.0 * beat
    duree = p["duree"]
    n = int(duree * sr) + sr // 2
    master = np.zeros((n, 2), np.float32)
    e0, e1 = p["energie_arc"]
    drop_s = p["drop_s"]
    riser_s = p["riser_s"]

    def energy_at(t):
        frac = min(max(t / max(duree * 0.72, 1.0), 0.0), 1.0)
        e = e0 + (e1 - e0) * frac
        return 0.55 + 0.15 * e  # 0.85..1.30

    root = p["root_midi"]
    scale = MINOR_SET if p["mode"] == "min" else MAJOR_SET
    prog_pool = MINOR_PROG if p["mode"] == "min" else MAJOR_PROG
    prog = prog_pool[int(rng.integers(0, len(prog_pool)))]
    chord_bars = 2 if fam in ("afrosoul", "afornb", "highlife") else int(rng.choice([1, 2, 2]))
    kick_var = int(rng.integers(0, 3))
    shaker16 = fam in ("afrohouse", "amapiano", "coupedecale")
    swing = 0.0 if fam in ("afrohouse", "amapiano") else float(rng.uniform(0.0, 0.10))

    # --- structure : intro 2 barres, corps, pont riser/drop, outro queue
    intro_end = min(2 * bar, duree * 0.25)
    # --- batterie + percussions (boucle 2 mesures avec variations)
    t = intro_end * 0.5
    step_i = 0
    while t < duree - 0.05:
        in_intro = t < intro_end
        post_drop = t >= (drop_s if drop_s else duree)
        s16 = step_i % 16
        dens = 0.55 if in_intro else (1.0 if post_drop else 0.85)
        g = energy_at(t) * dens
        sw = swing * step * (1 if s16 % 2 == 1 else 0)
        if groove["kick"][s16] and (not in_intro or s16 in (0, 8)):
            add_at(master, kick(rng, sr, kick_var, amp=1.0), t + sw, sr, gain=0.92 * g)
        if s16 in groove["back_at"] and not in_intro:
            b = groove["back"]
            sig = clap_hit(rng, sr) if b == "clap" else snare_hit(rng, sr, tone=170 + 90 * (seed_int(p["piste_id"]) % 3)) if b == "snare" else metal_hit(rng, sr, base=430 + 180 * rng.random()) if b == "metal" else conga_hit(rng, sr, f=210 + 80 * rng.random())
            add_at(master, sig, t + sw, sr, gain=0.5 * g, pan=float(rng.uniform(-0.2, 0.2)))
        if shaker16 or (not in_intro and rng.random() < 0.85):
            if shaker16 or s16 % 2 == 0:
                acc = 1.0 if s16 % 4 == 0 else 0.62
                add_at(master, shaker_hit(rng, sr, dur=0.045, bright=0.8 + 0.5 * rng.random()), t + sw, sr, gain=0.30 * g * acc, pan=float(rng.uniform(-0.35, 0.35)))
        if fam == "percus_indus" and s16 % 4 == 2 and rng.random() < 0.5:
            add_at(master, metal_hit(rng, sr, base=300 + 500 * rng.random(), amp=0.5), t + sw, sr, gain=0.30 * g, pan=float(rng.uniform(-0.5, 0.5)))
        if fam == "percus_feutrees" and rng.random() < 0.22:
            add_at(master, conga_hit(rng, sr, amp=0.6, f=180 + 140 * rng.random()), t + sw, sr, gain=0.26 * g, pan=float(rng.uniform(-0.45, 0.45)))
        # fill fin de chaque 4 mesures avant le drop ou en fin de section
        bar_i = step_i // 16
        if s16 >= 12 and bar_i % 4 == 3 and not in_intro:
            for k in range(4):
                add_at(master, snare_hit(rng, sr, amp=0.45 + 0.12 * k, tone=1900), t + k * (step / 4) + sw, sr, gain=0.20 * g, pan=float(rng.uniform(-0.3, 0.3)))
        t += step
        step_i += 1

    # --- basse
    bass_style = groove["bass"]
    deg = 0
    t = intro_end
    while t < duree - 0.1:
        deg_i = prog[(deg) % len(prog)]
        bf = midi2f(root - 12 + deg_i + (0 if p["mode"] == "maj" else 0))
        chord_dur = chord_bars * bar
        g = energy_at(t) * (0.7 if t < intro_end * 2 else 1.0)
        if bass_style == "logdrum":
            pat = [0, 0.75, 1.5, 2.5] if fam == "amapiano" else [0, 0.5, 1.5, 2.0, 3.0, 3.5]
            for off in pat:
                if rng.random() < 0.88:
                    nf = bf * (2 ** (rng.choice([0, 0, 0, 3, 5, 7]) / 12.0))
                    add_at(master, logdrum_note(rng, sr, nf, dur=0.26 + 0.1 * rng.random(), amp=1.0), t + off * beat, sr, gain=0.85 * g)
        elif bass_style == "pluck":
            for k in range(8):
                if rng.random() < 0.75:
                    nf = bf * (2 ** (rng.choice([0, 0, 7, 12]) / 12.0))
                    add_at(master, ks_note(rng, sr, nf, dur=0.3, amp=0.9, bright=0.25, fb=0.494), t + k * 0.5 * beat, sr, gain=0.62 * g, pan=0.0)
        elif bass_style == "sub":
            add_at(master, sub_note(sr, bf, dur=chord_dur * 0.92, amp=1.0), t, sr, gain=0.8 * g)
            if rng.random() < 0.5:
                add_at(master, sub_note(sr, bf * 1.5, dur=beat * 0.9), t + 3 * beat, sr, gain=0.4 * g)
        else:  # drone percus
            add_at(master, sub_note(sr, bf / 2, dur=chord_dur * 0.95, amp=0.6), t, sr, gain=0.5 * g)
        t += chord_dur
        deg += 1

    # --- accords / nappes
    deg = 0
    t = intro_end
    while t < duree - 0.2:
        deg_i = prog[deg % len(prog)]
        chord_dur = chord_bars * bar
        g = energy_at(t)
        base = root + 12 + deg_i
        voicing = sorted([base, base + (scale[(deg_i + 2) % 7] - deg_i if False else 3 + (deg_i % 2)), base + 7 + (deg_i % 3)])
        voicing = [base, base + 3 + (0 if p["mode"] == "min" else 1), base + 7, base + 10 + (0 if p["mode"] == "min" else 1)]
        voicing = sorted(set(m % 12 + 12 * (4 + (m // 12 - 4)) for m in voicing))
        if fam in ("afrosoul", "afornb"):
            add_at(master, rhodes_chord(sr, [midi2f(m) for m in voicing], dur=chord_dur * 1.05, amp=1.0, warm=1.2), t, sr, gain=0.34 * g, pan=float(rng.uniform(-0.12, 0.12)))
        elif fam == "highlife":
            for k in range(int(chord_dur / (beat * 0.5))):
                if rng.random() < 0.8:
                    m = voicing[k % len(voicing)] + (12 if rng.random() < 0.3 else 0)
                    add_at(master, ks_note(rng, sr, midi2f(m), dur=0.5, amp=0.8, bright=0.75, fb=0.4975), t + k * beat * 0.5, sr, gain=0.34 * g, pan=float(rng.uniform(-0.3, 0.3)))
        elif fam in ("percus_indus", "percus_feutrees"):
            if rng.random() < 0.5:
                add_at(master, balafon_note(rng, sr, midi2f(voicing[0] + 12), dur=0.9, amp=0.8), t, sr, gain=0.22 * g, pan=float(rng.uniform(-0.4, 0.4)))
        else:
            add_at(master, rhodes_chord(sr, [midi2f(m) for m in voicing], dur=chord_dur * 0.9, amp=1.0, warm=0.8), t, sr, gain=0.26 * g, pan=float(rng.uniform(-0.15, 0.15)))
            if fam == "amapiano" and rng.random() < 0.6:
                add_at(master, pad_chord(rng, sr, [midi2f(m) for m in voicing[:3]], dur=chord_dur * 1.1, amp=0.5), t, sr, gain=0.14 * g, pan=0.0)
        t += chord_dur
        deg += 1

    # --- melodie (motif genere, varie)
    if fam not in ("percus_indus",):
        motif_r = [rng.choice([0.5, 0.5, 1.0]) for _ in range(4)] + [rng.choice([1.0, 1.5, 2.0])]
        motif_p = [0]
        for _ in range(4):
            motif_p.append(motif_p[-1] + int(rng.choice([-2, -1, 0, 1, 2, 3])))
        motif_p = [x % 14 for x in motif_p]
        t = max(intro_end, (riser_s or 4.0))
        mi = 0
        while t < duree - 2.0:
            g = energy_at(t)
            if g > 0.95 and rng.random() < 0.72:
                deg_i = prog[int(t / (chord_bars * bar)) % len(prog)]
                mp = motif_p[mi % len(motif_p)]
                m = root + 24 + scale[mp % len(scale)] + 12 * (mp // len(scale)) + (deg_i if rng.random() < 0.25 else 0)
                d = motif_r[mi % len(motif_r)] * beat * 2
                add_at(master, melody_note(rng, sr, midi2f(m), dur=min(d * 0.92, 1.6), amp=1.0), t, sr, gain=0.30 * g, pan=float(rng.uniform(-0.18, 0.18)))
            t += motif_r[mi % len(motif_r)] * beat * 2 + (beat if rng.random() < 0.3 else 0)
            mi += 1

    # --- riser + impact sur les marqueurs de la matrice
    if riser_s and riser_s > 1.0:
        rl = min(2.2, max(0.9, (drop_s - riser_s) if (drop_s and drop_s > riser_s) else 1.6))
        add_at(master, riser_sfx(rng, sr, dur=rl, amp=1.0), max(riser_s - rl, 0.2), sr, gain=0.42 * energy_at(riser_s))
    if drop_s:
        add_at(master, impact_sfx(rng, sr, amp=1.0), drop_s, sr, gain=0.8 * energy_at(drop_s))

    # --- queues : fondu final 1.2 s
    fade_n = int(1.2 * sr)
    if master.shape[0] > fade_n:
        master[-fade_n:, 0] *= np.linspace(1, 0, fade_n, dtype=np.float32)
        master[-fade_n:, 1] *= np.linspace(1, 0, fade_n, dtype=np.float32)
    # coupe tout ce qui depasse duree + marge (silence final inutile)
    end_i = min(master.shape[0], int((duree + 0.35) * sr))
    return master[:end_i].copy()


# ------------------------------------------------------------------ plan ---
def seed_int(piste_id):
    return int(hashlib.sha256(piste_id.encode()).hexdigest()[:12], 16)


def build_plan(plan_gabarits):
    """600 pistes : 6 secteurs x 5 formats x 20 variations, signatures uniques."""
    pistes = []
    for gid, g in sorted(plan_gabarits.items()):
        secteur, fmt = g["secteur"], g["format"]
        rng = np.random.default_rng(seed_int("plan_" + gid))
        # BPM uniques dans la fenetre (pas de 0.25)
        pool_bpm = np.arange(g["bpm_min"], g["bpm_max"] + 0.25, 0.25)
        bpms = rng.choice(pool_bpm, size=20, replace=False)
        # tonalites uniques (24)
        keys = rng.permutation(24)[:20]
        fam = family_of(g["genre"])
        e0, e1 = parse_energie(g["energie"])
        for v in range(1, 21):
            piste_id = f"musique_{fmt.lower()}_{secteur}_v{v:02d}"
            r = np.random.default_rng(seed_int(piste_id))
            k = int(keys[v - 1])
            root_midi = 45 + (k % 12)  # A2..G#3
            mode = "min" if k < 12 else "maj"
            queue = float(r.uniform(3.0, 10.0))
            pistes.append({
                "piste_id": piste_id,
                "categorie_audio": f"musique_{fmt.lower()}_{secteur}",
                "gabarit_id": gid,
                "secteur": secteur,
                "format": fmt,
                "variation": v,
                "bpm": float(bpms[v - 1]),
                "root_midi": root_midi,
                "mode": mode,
                "tonalite": f"{KEY_NAMES[root_midi % 12]} {'mineur' if mode == 'min' else 'majeur'}",
                "genre": g["genre"],
                "famille": fam,
                "energie_arc": (e0, e1),
                "riser_s": float(g["riser_s"]) if g.get("riser_s") else None,
                "drop_s": float(g["drop_s"]) if g.get("drop_s") else None,
                "duree": g["duree_montage_s"] + queue,
                "object_key": f"audio/bgm/{secteur}/{fmt}/{piste_id}.mp3",
                "seed": seed_int(piste_id),
            })
    return pistes


# --------------------------------------------------------------- encodage --
def encode_mp3_2pass(master, path, target=TARGET_LUFS, tp_max=TP_MAX):
    """Boucle adaptative : gain lineaire pilote le LUFS, abaissement du
    plafond du limiteur pilote le true peak (evite l'oscillation)."""
    import lameenc
    import soundfile as sf
    hist = []
    # estimation initiale sur le PCM (une mesure, pas d'encodage)
    lu0 = integrated_loudness(master, SR)
    tp0 = true_peak_dbtp(master, SR)
    gain_db = target - lu0
    # pre-reglage du knee selon la crete anticipée apres gain
    knee = 0.55
    tp_prevu = tp0 + gain_db
    if tp_prevu > tp_max + 6.0:
        knee = 0.25
    elif tp_prevu > tp_max + 2.0:
        knee = 0.38
    asym = ASYM
    lu, tp = lu0, -np.inf
    for it in range(10):
        x = soft_limit((master * (10.0 ** (gain_db / 20.0))).astype(np.float32), knee=knee, asym=asym)
        pcm = np.clip(x * 32767.0, -32768, 32767).astype(np.int16)
        enc = lameenc.Encoder()
        enc.set_in_sample_rate(SR)
        enc.set_channels(2)
        enc.set_bit_rate(128)
        enc.set_quality(2)
        data = enc.encode(np.ascontiguousarray(pcm).tobytes())
        data += enc.flush()
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "wb") as f:
            f.write(data)
        dec, sr2 = sf.read(path, dtype="float64")
        lu = integrated_loudness(dec, sr2)
        tp = true_peak_dbtp(dec, sr2)
        hist.append((round(gain_db, 2), round(float(knee), 3), round(float(asym), 3), round(float(lu), 2), round(float(tp), 2)))
        ok_lu = abs(lu - target) <= TOL_LUFS
        ok_tp = tp <= tp_max
        if ok_lu and ok_tp:
            return float(lu), float(tp), it + 1, hist
        if not ok_lu:
            gain_db += -(lu - target) * (1.0 if it < 2 else 0.85)
        if not ok_tp:
            if knee > 0.19:
                knee = max(knee * 0.75, 0.18)
            else:
                asym = max(asym * 0.90, 0.45)
    return float(lu), float(tp), 10, hist


def write_wav_sfx(x, path, target=TARGET_LUFS, tp_max=TP_MAX):
    import soundfile as sf
    os.makedirs(os.path.dirname(path), exist_ok=True)
    lu0 = integrated_loudness(x, SR_SFX)
    gain_db = target - lu0
    knee = 0.55
    asym = 0.70
    lu, tp = lu0, -np.inf
    for _ in range(8):
        y = soft_limit((x * 10.0 ** (gain_db / 20.0)).astype(np.float32), knee=knee, asym=asym)
        d = (np.random.default_rng(7).random(len(y)).astype(np.float32) + np.random.default_rng(9).random(len(y)).astype(np.float32) - 1.0) / 32768.0
        sf.write(path, np.clip(y + d, -1.0, 1.0), SR_SFX, subtype="PCM_16")
        dec, sr2 = sf.read(path, dtype="float64")
        lu = integrated_loudness(dec, sr2)
        tp = true_peak_dbtp(dec, sr2)
        if abs(lu - target) <= 0.15 and tp <= tp_max:
            return float(lu), float(tp)
        if abs(lu - target) > TOL_LUFS:
            gain_db += -(lu - target) * 0.9
        if tp > tp_max:
            knee = max(knee * 0.85, 0.12)
            asym = max(asym * 0.93, 0.32)
    return float(lu), float(tp)


# -------------------------------------------------------------------- SFX --
def build_sfx_catalog():
    specs = [
        ("whoosh_soft", 0.35), ("whoosh_fast", 0.22), ("caisse_enregistreuse", 0.55),
        ("clic_appareil", 0.12), ("impact_drop", 0.22), ("pop_badge", 0.16),
        ("amb_chantier", 2.5), ("sizzle_grill", 1.0), ("vapeur_plat", 1.0),
    ]
    sr = SR_SFX
    out = []
    for name, dur in specs:
        rng = np.random.default_rng(seed_int("sfx_" + name))
        n = int(sr * dur) + int(sr * 0.06)
        t = np.arange(n, dtype=np.float32) / sr
        if name == "whoosh_soft":
            y = riser_sfx(rng, sr, dur, amp=1.0, f0=260, f1=2400)
            y = _bp(y, sr, 1500, q=0.7)
            env = np.sin(np.pi * np.minimum(t / dur, 1.0)) ** 1.2
            y = y * env[: len(y)]
        elif name == "whoosh_fast":
            y = riser_sfx(rng, sr, dur, amp=1.0, f0=500, f1=6200)
            env = np.sin(np.pi * np.minimum(t / dur, 1.0)) ** 0.9
            y = y * env[: len(y)]
        elif name == "caisse_enregistreuse":
            y = np.zeros(n, np.float32)
            bell = metal_hit(rng, sr, amp=1.0, base=1180)
            y[: len(bell)] += bell * 0.9
            bell2 = metal_hit(rng, sr, amp=0.7, base=1568)
            i2 = int(sr * 0.09)
            y[i2 : i2 + len(bell2)] += bell2 * 0.7
            for k in range(6):
                j = int(sr * (0.16 + 0.05 * k))
                c = _hp(_noise(rng, int(sr * 0.012)), sr, 4200) * (0.5 - 0.06 * k)
                y[j : j + len(c)] += c
            ding = melody_note(rng, sr, 2093, dur=0.35, amp=0.8)
            i3 = int(sr * 0.2)
            y[i3 : i3 + len(ding)] += ding * 0.5
        elif name == "clic_appareil":
            y = np.zeros(n, np.float32)
            tr = _hp(_noise(rng, int(sr * 0.007)), sr, 2600)
            tr *= np.linspace(0.3, 1.0, len(tr)).astype(np.float32)
            y[: len(tr)] += tr * 0.85
            body = np.sin(2 * np.pi * 1250 * t).astype(np.float32) * _exp_decay(n, sr, 0.028)
            y += body * 0.6
            mech = _bp(_noise(rng, int(sr * 0.02)), sr, 780, q=2.0) * 0.3
            i2 = int(sr * 0.006)
            y[i2 : i2 + len(mech)] += mech
        elif name == "impact_drop":
            y = impact_sfx(rng, sr, amp=1.0, dur=dur)
        elif name == "pop_badge":
            y = np.zeros(n, np.float32)
            f = 620 + 320 * np.exp(-t / 0.02)
            pop = np.sin(2 * np.pi * np.cumsum(f) / sr).astype(np.float32) * _exp_decay(n, sr, 0.028)
            y += pop * 0.9
            cl = _hp(_noise(rng, int(sr * 0.007)), sr, 2400)
            cl *= np.linspace(0.3, 1.0, len(cl)).astype(np.float32) * 0.45
            y[: len(cl)] += cl
        elif name == "amb_chantier":
            y = _lp(_noise(rng, n), sr, 240) * 0.30
            hum = (np.sin(2 * np.pi * 50 * t) + 0.4 * np.sin(2 * np.pi * 100 * t) + 0.2 * np.sin(2 * np.pi * 150 * t)).astype(np.float32)
            y += hum * 0.10 * (0.8 + 0.2 * np.sin(2 * np.pi * 0.7 * t))
            for k in range(int(rng.integers(3, 6))):
                pos = float(rng.uniform(0.1, dur - 0.4))
                h = metal_hit(rng, sr, amp=0.7, base=300 + 420 * rng.random())
                i0 = int(sr * pos)
                m = min(len(h), n - i0)
                y[i0 : i0 + m] += h[:m] * float(rng.uniform(0.35, 0.7))
            grav = _hp(_noise(rng, n), sr, 3800) * 0.05
            y += grav
        elif name == "sizzle_grill":
            y = _hp(_noise(rng, n), sr, 5200) * 0.5
            amp_mod = 0.7 + 0.3 * np.sin(2 * np.pi * 2.3 * t + rng.uniform(0, 6))
            y = (y * amp_mod).astype(np.float32)
            for k in range(int(rng.integers(6, 13))):
                pos = float(rng.uniform(0.02, dur - 0.05))
                i0 = int(sr * pos)
                pl = _hp(_noise(rng, int(sr * 0.008)), sr, 6500) * float(rng.uniform(0.4, 0.9))
                m = min(len(pl), n - i0)
                y[i0 : i0 + m] += pl[:m]
        elif name == "vapeur_plat":
            y = _bp(_noise(rng, n), sr, 2600, q=0.55) * 0.8
            atk = np.minimum(t / 0.03, 1.0)
            dec = np.minimum((dur + 0.05 - t) / 0.5, 1.0).clip(0, 1)
            y = (y * atk * dec).astype(np.float32)
            fw = 2400 + 900 * np.exp(-t / 0.35)
            whistle = np.sin(2 * np.pi * np.cumsum(fw) / sr).astype(np.float32) * _exp_decay(n, sr, 0.5)
            y += whistle * 0.12 * atk
        else:
            y = np.zeros(n, np.float32)
        y = y / max(float(np.max(np.abs(y))), 1e-9) * 0.8
        out.append((name, y.astype(np.float32), dur))
    return out


# ---------------------------------------------------------------------- B2 --
import base64
import random
import urllib.error
import urllib.parse
import urllib.request

B2_KEYS = os.path.join(ROOT, ".b2_keys.json")
B2_AUTH_CACHE = os.path.join(ROOT, ".b2_auth_cache.json")


def _b2_authorize():
    keys = json.load(open(B2_KEYS))
    cred = base64.b64encode((keys["key_id"] + ":" + keys["app_key"]).encode()).decode()
    req = urllib.request.Request(
        "https://api.backblazeb2.com/b2api/v2/b2_authorize_account",
        data=b"{}", headers={"Authorization": "Basic " + cred, "Content-Type": "application/json"})
    r = json.load(urllib.request.urlopen(req))
    sess = {"apiUrl": r["apiUrl"], "token": r["authorizationToken"],
            "bucketId": r["allowed"]["bucketId"], "downloadUrl": r["downloadUrl"]}
    json.dump(sess, open(B2_AUTH_CACHE, "w"))
    return sess


def b2_session(force=False):
    if not force and os.path.exists(B2_AUTH_CACHE):
        try:
            return json.load(open(B2_AUTH_CACHE))
        except Exception:
            pass
    return _b2_authorize()


THROTTLE_S = 0.5          # pause inter-requete (consigne client 01/11 : ne pas saturer B2)
BACKOFF_MAX_S = 3.0       # backoff exponentiel plafonne a 3 s (1 -> 2 -> 3 -> 3...)
RETRY_CODES = (408, 425, 429, 500, 502, 503, 504)


def b2_upload(data, name, mime, max_attempts=8):
    sha1 = hashlib.sha1(data).hexdigest()
    derniere_err = None
    for attempt in range(max_attempts):
        try:
            sess = b2_session(force=(attempt > 0 and derniere_err in (401, 403)))
            rq = urllib.request.Request(
                sess["apiUrl"] + "/b2api/v2/b2_get_upload_url",
                data=json.dumps({"bucketId": sess["bucketId"]}).encode(),
                headers={"Authorization": sess["token"], "Content-Type": "application/json"})
            up = json.load(urllib.request.urlopen(rq, timeout=60))
            req = urllib.request.Request(up["uploadUrl"], data=data, headers={
                "Authorization": up["authorizationToken"],
                "X-Bz-File-Name": urllib.parse.quote(name, safe="/"),
                "Content-Type": mime,
                "X-Bz-Content-Sha1": sha1,
            })
            res = json.load(urllib.request.urlopen(req, timeout=300))
            time.sleep(THROTTLE_S)
            return res["fileId"], sha1
        except urllib.error.HTTPError as e:
            derniere_err = e.code
            if e.code in (401, 403):
                try:
                    os.remove(B2_AUTH_CACHE)
                except OSError:
                    pass
                time.sleep(1.0 + attempt)
                continue
            if e.code in RETRY_CODES:
                pause = min(BACKOFF_MAX_S, 1.0 * (2 ** attempt)) + random.uniform(0, 0.4)
                print(f"[b2] {e.code} sur {name} - retry {attempt+1}/{max_attempts} dans {pause:.1f}s", flush=True)
                time.sleep(pause)
                continue
            raise
        except (urllib.error.URLError, TimeoutError, ConnectionError, OSError) as e:
            derniere_err = repr(e)
            pause = min(BACKOFF_MAX_S, 1.0 * (2 ** attempt)) + random.uniform(0, 0.4)
            print(f"[b2] reseau sur {name} - retry {attempt+1}/{max_attempts} dans {pause:.1f}s", flush=True)
            time.sleep(pause)
    raise RuntimeError(f"b2_upload echec apres {max_attempts} tentatives : {name} ({derniere_err})")


# --------------------------------------------------------------------- CLI --
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--plan", default=os.path.join(ROOT, "plan_gabarits.json"))
    ap.add_argument("--shard", default="0/1")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--sfx", action="store_true")
    ap.add_argument("--samples", type=int, default=0, help="N pistes de test (1/secteur)")
    ap.add_argument("--upload", action="store_true", help="televerse chaque piste sur B2 des encodage termine (preuve=jsonl)")
    args = ap.parse_args()
    plan_g = json.load(open(args.plan))
    if args.sfx:
        t0 = time.time()
        os.makedirs(os.path.join(ROOT, "manifests"), exist_ok=True)
        man = []
        for name, y, dur in build_sfx_catalog():
            path = os.path.join(OUT_SFX, f"{name}.wav")
            lu, tp = write_wav_sfx(y, path)
            sha = hashlib.sha256(open(path, "rb").read()).hexdigest()
            rec = {"piste_id": f"sfx_{name}", "categorie": name, "object_key": f"audio/sfx/{name}.wav",
                   "format_fichier": "WAV PCM 48 kHz mono 16 bits", "duree_cible_ms": int(dur * 1000),
                   "duree_reelle_s": round(len(y) / SR_SFX, 3), "loudness_lufs_mesuree": round(lu, 2),
                   "true_peak_dbtp": round(tp, 2), "taille_octets": os.path.getsize(path),
                   "sha256": sha, "origine": "synthese_procedurale_v2", "licence": "CC0-1.0"}
            if args.upload:
                fid, b2sha1 = b2_upload(open(path, "rb").read(), rec["object_key"], "audio/wav")
                rec["b2_file_id"] = fid
                rec["b2_sha1"] = b2sha1
                print(f"[sfx] UPLOADE {rec['object_key']}", flush=True)
            man.append(rec)
            print(f"[sfx] {name}: {rec['duree_reelle_s']}s LUFS={lu:.2f} TP={tp:.2f} sha={sha[:12]}", flush=True)
        json.dump(man, open(os.path.join(ROOT, "manifests", "sfx_manifest_v2.json"), "w"), ensure_ascii=False, indent=1)
        print(f"[sfx] 9/9 en {time.time()-t0:.1f}s", flush=True)
        return

    pistes = build_plan(plan_g)
    # controle d'unicite du plan AVANT generation
    sig = {(p["gabarit_id"], p["bpm"], p["tonalite"]) for p in pistes}
    ids = {p["piste_id"] for p in pistes}
    keys = {p["object_key"] for p in pistes}
    assert len(pistes) == 600 and len(ids) == 600 and len(keys) == 600, "plan invalide"
    print(f"[plan] 600 pistes | signatures (gabarit,bpm,tonalite) distinctes : {len(sig)}/600", flush=True)
    if args.samples:
        seen = set()
        sel = []
        for p in pistes:
            if p["secteur"] not in seen:
                seen.add(p["secteur"])
                sel.append(p)
        pistes = sel[: args.samples]
    i0, nsh = (int(x) for x in args.shard.split("/"))
    pistes = [p for j, p in enumerate(pistes) if j % nsh == i0]
    if args.limit:
        pistes = pistes[: args.limit]
    os.makedirs(os.path.join(ROOT, "manifests"), exist_ok=True)
    jl_path = os.path.join(ROOT, "manifests", f"bgm_shard{i0}.jsonl")
    deja_faits = set()
    if os.path.exists(jl_path):
        for ligne in open(jl_path, encoding="utf-8"):
            try:
                deja_faits.add(json.loads(ligne)["piste_id"])
            except Exception:
                pass
    if deja_faits:
        avant = len(pistes)
        pistes = [p for p in pistes if p["piste_id"] not in deja_faits]
        print(f"[reprise] {avant - len(pistes)} pistes déjà téléversées, reste {len(pistes)}", flush=True)
    jl = open(jl_path, "a", encoding="utf-8")
    t0 = time.time()
    for k, p in enumerate(pistes):
        path = os.path.join(ROOT, "out", p["object_key"].replace("audio/", "", 1))
        if os.path.exists(path) and os.path.getsize(path) > 50000:
            # orphelin d'un echec d'upload (les pistes televersees sont supprimees
            # du disque et tracees dans le jsonl) : regeneration propre
            os.remove(path)
        rng = np.random.default_rng(p["seed"])
        master = build_bgm(p, rng)
        lu, tp, its, hist = encode_mp3_2pass(master, path)
        raw = open(path, "rb").read()
        sha = hashlib.sha256(raw).hexdigest()
        import soundfile as sf
        dec, sr2 = sf.read(path, dtype="float64")
        rec = dict(p)
        rec.update({
            "duree_reelle_s": round(len(dec) / sr2, 2),
            "loudness_lufs_cible": TARGET_LUFS,
            "loudness_lufs_mesuree": round(lu, 2),
            "true_peak_dbtp": round(tp, 2),
            "passes_encodage": its,
            "taille_octets": len(raw),
            "sha256": sha,
            "debit_kbps": 128, "conteneur": "MP3 CBR", "sample_rate_hz": SR, "canaux": 2,
            "origine": "synthese_procedurale_v2", "licence": "CC0-1.0",
            "signature_uniq": hashlib.sha256(json.dumps([p["gabarit_id"], p["bpm"], p["tonalite"], p["seed"]]).encode()).hexdigest()[:32],
        })
        rec.pop("energie_arc", None)
        if args.upload:
            fid, b2sha1 = b2_upload(raw, p["object_key"], "audio/mpeg")
            rec["b2_file_id"] = fid
            rec["b2_sha1"] = b2sha1
            os.remove(path)
        jl.write(json.dumps(rec, ensure_ascii=False) + "\n")
        jl.flush()
        dt = time.time() - t0
        print(f"[bgm {k+1}/{len(pistes)}] {p['piste_id']} bpm={p['bpm']} {p['tonalite']} LUFS={lu:.2f} TP={tp:.2f} passes={its} {dt/max(k+1,1):.1f}s/piste", flush=True)
    jl.close()
    print(f"[bgm shard {i0}] TERMINE {time.time()-t0:.0f}s", flush=True)


if __name__ == "__main__":
    main()
