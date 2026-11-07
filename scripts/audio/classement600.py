#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
D42.21 — Grille de qualité /100 et classement KEEP / IMPROVE / REGENERATE.

Règles d'honnêteté :
- Le BPM MESURÉ par autocorrélation a ÉCHOUÉ la validation (0/8 à ±1 BPM sur
  click synthétique, biais −4 à −13) → NON Fiable. Le BPM de GÉNÉRATION
  (déterministe, vérifié 600/600 contre le plan D42.19) reste la donnée de
  référence. Critère 6 = force de PULSATION au BPM étiqueté (ACF du flux au
  lag correspondant, 0..1) : mesure réelle du groove, indépendante du biais.
- La grille mesure ce qui est MESURABLE ; les critères dont le proxy objectif
  est faible (place de la voix, congruence fine) sont plafonnés et marqués
  « à confirmer à l'écoute » — l'écoute humaine reste au fondateur.
- Chaque note est explicable : sous-scores consignés dans classement600.jsonl.

Seuils mission D42.20 : ≥90 KEEP ; 80–89 KEEP mineur ; 65–79 IMPROVE ; <65 REGENERATE.
"""
import csv
import json
import os
import sys

import numpy as np
import soundfile as sf

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import generateur_audio_v2 as G

MESURES = "/home/user/audio_v2_mesures/mesures600.jsonl"
SRC = "/home/user/.cache/audio600"
MATRICE = "/home/user/lab20/content/gabarits_v2/matrice_audio/matrice_30_gabarits_bpm_styles_sfx.csv"
OUT = "/home/user/audio_v2_mesures/classement600.jsonl"
OUT_MD = "/home/user/lab20/docs/checkpoints/D42_21/03_CLASSEMENT_600.md"


def pulsation_acf(path, bpm, sr_attendu=44100):
    """ACF du flux au lag du BPM étiqueté (0..1). Reprise mp3 nécessaire."""
    try:
        x2, sr = sf.read(path, dtype="float64", always_2d=True)
    except Exception:
        return None
    x = x2.mean(axis=1)
    hop = int(0.05 * sr)
    nf = len(x) // hop
    if nf < 60:
        return None
    env = np.array([np.sqrt(np.mean(x[i * hop:(i + 1) * hop] ** 2)) for i in range(nf)])
    flux = np.maximum(np.diff(env, prepend=env[0]), 0.0)
    f = flux - flux.mean()
    if f.std() < 1e-9:
        return None
    ac = np.correlate(f, f, mode="full")[len(f) - 1:]
    ac /= (ac[0] + 1e-12)
    li = int(round(60.0 / bpm / 0.05))
    if li < 2 or li >= len(ac) - 1:
        return None
    return float(max(ac[li - 1], ac[li], ac[li + 1]))


def note_hook(r):
    a = r.get("premiere_attaque_s")
    if a is None:
        return 0, "aucune attaque détectée"
    if a <= 0.3: return 10, f"attaque {a:.2f}s (≤0,3)"
    if a <= 0.5: return 8, f"attaque {a:.2f}s (≤0,5)"
    if a <= 1.0: return 5, f"attaque {a:.2f}s (≤1)"
    if a <= 2.0: return 2, f"attaque {a:.2f}s (≤2)"
    return 0, f"attaque {a:.2f}s (>2 — défaut v2)"


def note_remplissage_intro(r):
    f = r.get("fenetres_rms_db") or {}
    corps = f.get("w3_5")
    if corps is None or corps < -60:
        return 0, "corps illisible"
    creux = [v for v in (f.get("w0_05"), f.get("w05_1"), f.get("w1_2"), f.get("w2_3")) if v is not None]
    if not creux:
        return 0, "fenêtres absentes"
    pire = min(creux)
    ecart = corps - pire
    if ecart <= 6: return 10, f"intro au niveau du corps (Δ{ecart:.0f} dB)"
    if ecart <= 12: return 6, f"intro en retrait (Δ{ecart:.0f} dB)"
    if ecart <= 20: return 3, f"intro creuse (Δ{ecart:.0f} dB)"
    return 0, f"intro quasi muette (Δ{ecart:.0f} dB)"


def note_progression(r):
    p = r.get("progression_lufs") or {}
    debut, fin = p.get("0.25"), p.get("0.75")
    if debut is None or fin is None:
        return 5, "progression illisible — neutre"
    d = fin - debut
    if d >= 1.0: return 10, f"montée +{d:.1f} LU (25→75 %)"
    if d >= 0.0: return 7, f"plateau {d:+.1f} LU"
    if d >= -2.0: return 4, f"affaissement {d:+.1f} LU"
    return 1, f"effondrement {d:+.1f} LU"


def note_dynamique(r):
    lra, crete = r.get("lra"), r.get("crete_db")
    if lra is None or crete is None:
        return 5, "dynamique illisible"
    n = 10
    if lra < 2.0: n -= 5
    elif lra > 12.0: n -= 3
    if crete < 6.0: n -= 3
    elif crete > 25.0: n -= 2
    return max(0, n), f"LRA {lra:.1f} LU, crête {crete:.0f} dB"


def note_mix_technique(r):
    motifs = []
    n = 10
    lufs, tp = r.get("lufs_integre"), r.get("true_peak_dbtp")
    if lufs is None:
        return 0, "LUFS illisible"
    if abs(lufs + 16.0) <= 0.15: motifs.append(f"LUFS {lufs} (±0,15)")
    elif abs(lufs + 16.0) <= 0.5: motifs.append(f"LUFS {lufs} (±0,5)"); n -= 2
    else: motifs.append(f"LUFS {lufs} (hors tolérance)"); n -= 5
    if tp is not None:
        if tp <= -1.0: motifs.append(f"TP {tp}")
        elif tp <= -0.5: motifs.append(f"TP {tp} (limite)"); n -= 3
        else: motifs.append(f"TP {tp} (dépassement)"); n -= 6
    if r.get("echantillons_plafond", 0) > 0:
        motifs.append(f"{r['echantillons_plafond']} éch. au plafond"); n -= 4
    return max(0, n), "; ".join(motifs)


def note_pulsation(p_acf):
    if p_acf is None:
        return 5, "pulsation non mesurable — neutre"
    if p_acf >= 0.55: return 10, f"groove marqué (ACF {p_acf:.2f})"
    if p_acf >= 0.35: return 8, f"groove net (ACF {p_acf:.2f})"
    if p_acf >= 0.20: return 5, f"groove moyen (ACF {p_acf:.2f})"
    return 2, f"groove faible (ACF {p_acf:.2f}) — l'étiquette BPM n'est pas audible"


def note_conclusion(r):
    c = r.get("conclusion") or {}
    if not c:
        return 5, "conclusion illisible"
    if c.get("fondu_detecte"):
        return 9, "fondu de sortie détecté"
    if c.get("coupe_fr_detectee"):
        e = c.get("ecart_queue_corps_db", 0)
        return 2, f"coupe franche en plein niveau (queue {e:+.0f} dB vs corps)"
    return 6, f"fin intermédiaire (Δ queue/corps {c.get('ecart_queue_corps_db', 0):+.0f} dB)"


def note_spectre(r):
    b = r.get("bandes_db") or {}
    cen = r.get("spectre_centroide_hz")
    if not b or cen is None:
        return 5, "spectre illisible"
    n = 10
    if cen < 400: n -= 3; motifs = f"centroïde {cen:.0f} Hz (sourd)"
    elif cen > 4000: n -= 3; motifs = f"centroïde {cen:.0f} Hz (agressif)"
    else: motifs = f"centroïde {cen:.0f} Hz"
    if b.get("air_gt8k", 0) < -30: n -= 2; motifs += " ; air absent"
    if b.get("mid_500_2k", -99) > -3: n -= 2; motifs += " ; médium saturé"
    return max(0, n), motifs


def note_place_voix(r):
    """Proxy plafonné : le médium doit laisser la place à une voix éventuelle.
    À CONFIRMER À L'ÉCOUTE (proxy faible)."""
    b = r.get("bandes_db") or {}
    d = r.get("densite_evt_s")
    if not b or d is None:
        return 5, "proxy voix illisible"
    n = 7  # plafond : critère à confirmer à l'écoute
    motifs = []
    if b.get("mid_500_2k", -99) > -6: n -= 2; motifs.append("médium chargé")
    if d > 3.0: n -= 2; motifs.append(f"densité {d:.1f} év/s")
    if b.get("mid_500_2k", -99) < -14: motifs.append("médium dégagé")
    return max(0, n), ("; ".join(motifs) or "place laissée (proxy)") + " — à confirmer à l'écoute"


def note_integrite(r):
    n = 10
    motifs = []
    if r.get("sha_identique_prod"): motifs.append("sha = production")
    else: motifs.append("sha ≠ production (1re vague pré-patch, documenté)"); n -= 3
    anos = r.get("anomalies") or []
    n -= 2 * len(anos)
    if anos: motifs.append(f"anomalies : {anos}")
    return max(0, n), "; ".join(motifs)


def main():
    mat = {r["gabarit"]: r for r in csv.DictReader(open(MATRICE, encoding="utf-8-sig"), delimiter=";")}
    pistes_plan = {p["piste_id"]: p for p in G.build_plan(json.load(open("/home/user/plan_gabarits_reconstruit.json")))}

    recs = [json.loads(l) for l in open(MESURES)]
    faits = set()
    if os.path.exists(OUT):
        for l in open(OUT):
            try: faits.add(json.loads(l)["piste_id"])
            except Exception: pass

    jl = open(OUT, "a", encoding="utf-8")
    for r in recs:
        pid = r["piste_id"]
        if pid in faits:
            continue
        p = pistes_plan[pid]
        path = os.path.join(SRC, "PROD_" + pid + ".mp3")
        if not os.path.exists(path):
            path = os.path.join(SRC, pid + ".mp3")
        p_acf = pulsation_acf(path, p["bpm"]) if os.path.exists(path) else None
        detail = {}
        total = 0
        for nom, (note, explication) in {
            "1_hook": note_hook(r),
            "2_remplissage_intro": note_remplissage_intro(r),
            "3_progression": note_progression(r),
            "4_dynamique": note_dynamique(r),
            "5_mix_technique": note_mix_technique(r),
            "6_pulsation_bpm_etiquette": note_pulsation(p_acf),
            "7_conclusion": note_conclusion(r),
            "8_spectre": note_spectre(r),
            "9_place_voix": note_place_voix(r),
            "10_integrite": note_integrite(r),
        }.items():
            detail[nom] = {"note": note, "explication": explication}
            total += note
        decision = "KEEP" if total >= 90 else "KEEP_MINEUR" if total >= 80 else "IMPROVE" if total >= 65 else "REGENERATE"
        jl.write(json.dumps({
            "piste_id": pid, "gabarit_id": r["gabarit_id"], "secteur": r["secteur"],
            "format": r["format"], "variation": r["variation"],
            "score_100": total, "decision": decision, "detail": detail,
            "pulsation_acf": round(p_acf, 3) if p_acf is not None else None,
        }, ensure_ascii=False) + "\n")
    jl.close()

    # synthèse markdown
    tous = [json.loads(l) for l in open(OUT)]
    from collections import Counter, defaultdict
    par_gab = defaultdict(list)
    for t in tous:
        par_gab[t["gabarit_id"]].append(t)
    lignes = ["# D42.21 — 03. CLASSEMENT DES 600 PISTES (grille /100)", "",
              f"**Pistes classées : {len(tous)}/600** (mise à jour au fil des mesures — la version",
              "finale couvre les 600). Grille : 10 critères × 10 points, chaque note explicable",
              "(`audio_v2_mesures/classement600.jsonl`). Seuils : ≥90 KEEP ; 80–89 KEEP mineur ;",
              "65–79 IMPROVE ; <65 REGENERATE. **Écoute humaine = fondateur** : la présente grille",
              "est la couche MESURÉE ; les critères à proxy faible (place voix) sont plafonnés et",
              "marqués à confirmer. BPM mesuré : estimateur NON FIABLE (0/8 validation click),",
              "BPM de génération = référence ; critère 6 = pulsation au BPM étiqueté (ACF).", ""]
    for gid in sorted(par_gab):
        ts = par_gab[gid]
        scores = [t["score_100"] for t in ts]
        dec = Counter(t["decision"] for t in ts)
        lignes.append(
            f"- **{gid}** ({len(ts)}/20 mesurées) : médiane {sorted(scores)[len(scores)//2]}/100, "
            f"min {min(scores)}, max {max(scores)} — "
            + ", ".join(f"{v} {k}" for k, v in sorted(dec.items())))
    lignes.append("")
    tot_dec = Counter(t["decision"] for t in tous)
    lignes.append(f"**Total provisoire ({len(tous)} pistes) : "
                  + ", ".join(f"{v} {k}" for k, v in sorted(tot_dec.items())) + "**")
    open(OUT_MD, "w").write("\n".join(lignes))
    print(f"classement : {len(tous)} pistes notées → {OUT_MD}")


if __name__ == "__main__":
    main()
