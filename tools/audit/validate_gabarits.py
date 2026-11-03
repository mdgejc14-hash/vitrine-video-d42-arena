#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Validateur croisé des 30 gabarits V2.0 (audit D40, réutilisable en CI).
Contrats vérifiés par gabarit :
  C1  nombre_scenes == len(scenes) == len(courbe_rythme) == len(transitions)
      == len(effets) == len(decoupage_prises) == len(cartes_generees) == len(texte_animation_position)
  C2  somme(duree_secondes scenes) ≈ duree_totale_secondes (±0.05) ET courbe_rythme == durees scenes
  C3  chaque champ champs_saisie.scenes ⊆ numéros de scènes ; chaque section formulaire_ui
      référence des champs existants ; chaque champ apparaît dans exactement une section/options
  C4  sfx de scenes ⊆ {9 SFX maîtres} ; scenes avec sfx ont un sfx_libelle_simple
  C5  decoupage_prises : "prise_N" ⊆ prises[].id ; "carte:X" == cartes_generees[i] non vide
  C6  scenes source.type=="prise" → prise_id existe ; scenes voix.active → source_audio_prise_id existe
  C7  prises[].scenes_alimentees ∪ scenes carte/generee couvrent 1..N ; duree_cible_s dans 8..20
  C8  champs obligatoires : nom_commerce, prix (sauf T5), whatsapp, quartier_ville présents
"""
import json, sys, glob, os
SFX_OK = {"whoosh_soft","whoosh_fast","caisse_enregistreuse","clic_appareil","impact_drop",
          "pop_badge","amb_chantier","sizzle_grill","vapeur_plat"}
def validate(path):
    errs = []
    g = json.load(open(path, encoding="utf-8"))
    gid = g.get("id", path)
    scenes = g.get("scenes", [])
    N = g.get("nombre_scenes")
    sig = g.get("axes_signature", {})
    msig = g.get("montage_signature", {})
    # C1
    for key, arr in [("scenes", scenes), ("courbe_rythme", sig.get("courbe_rythme", [])),
                     ("transitions", sig.get("transitions", [])), ("effets", sig.get("effets", [])),
                     ("decoupage_prises", sig.get("decoupage_prises", [])),
                     ("cartes_generees", sig.get("cartes_generees", [])),
                     ("texte_animation_position", sig.get("texte_animation_position", []))]:
        if len(arr) != N: errs.append(f"C1 {key}: len={len(arr)} != nombre_scenes={N}")
    # C2
    durs = [s.get("duree_secondes", 0) for s in scenes]
    tot = g.get("duree_totale_secondes", 0)
    if abs(sum(durs) - tot) > 0.05: errs.append(f"C2 somme scènes {sum(durs):.3f} != duree_totale {tot}")
    cr = sig.get("courbe_rythme", [])
    if len(cr) == len(durs) and any(abs(a-b) > 0.001 for a, b in zip(cr, durs)):
        errs.append("C2 courbe_rythme != durées scènes")
    # C2b axes_signature ↔ scenes (affectation par scène) + vocabulaire montage_signature
    tr_scenes = [s.get("transition_sortie") for s in scenes]
    ef_scenes = [s.get("effet") for s in scenes]
    if sig.get("transitions") and sig["transitions"] != tr_scenes:
        errs.append("C2b axes.transitions != scenes[].transition_sortie")
    if sig.get("effets") and sig["effets"] != ef_scenes:
        errs.append("C2b axes.effets != scenes[].effet")
    vocab_tr = set(msig.get("transitions", []))
    vocab_ef = set(msig.get("effets", []))
    if vocab_tr:
        hors = {t for t in tr_scenes if t and t not in vocab_tr}
        if hors: errs.append(f"C2b transitions hors vocabulaire : {sorted(hors)}")
    if vocab_ef:
        hors = {e for e in ef_scenes if e and e not in vocab_ef}
        if hors: errs.append(f"C2b effets hors vocabulaire : {sorted(hors)}")
    if msig.get("courbe_rythme") and msig["courbe_rythme"] != sig.get("courbe_rythme"):
        errs.append("C2b montage_signature.courbe_rythme != axes_signature.courbe_rythme")
    # C3
    champ_ids = {c["id"] for c in g.get("champs_saisie", [])}
    nums = {s.get("numero") for s in scenes}
    for c in g.get("champs_saisie", []):
        for sc in c.get("scenes", []):
            if sc not in nums: errs.append(f"C3 champ {c['id']} référence scène inexistante {sc}")
    f = g.get("formulaire_ui", {})
    vus = set()
    for sec in f.get("sections_principales", []) + ([f["options_facultatives_repliees"]] if f.get("options_facultatives_repliees") else []):
        for cid in sec.get("champs", []):
            if cid not in champ_ids: errs.append(f"C3 section {sec.get('id')} → champ inconnu {cid}")
            if cid in vus: errs.append(f"C3 champ {cid} dans 2 sections")
            vus.add(cid)
    orph = champ_ids - vus
    if orph: errs.append(f"C3 champs jamais affichés : {sorted(orph)}")
    # C4
    for s in scenes:
        sfx = s.get("sfx")
        if sfx:
            if sfx not in SFX_OK: errs.append(f"C4 scène {s.get('numero')} sfx inconnu '{sfx}'")
            if not s.get("sfx_libelle_simple"): errs.append(f"C4 scène {s.get('numero')} sfx sans libellé")
    # C5
    prise_ids = {p["id"] for p in g.get("prises", [])}
    for i, d in enumerate(sig.get("decoupage_prises", [])):
        if d.startswith("prise_"):
            if d not in prise_ids: errs.append(f"C5 decoupage[{i}] prise inconnue {d}")
        elif d.startswith("carte:"):
            carte = d[6:]
            cg = sig.get("cartes_generees", [])
            if i < len(cg) and cg[i] != carte: errs.append(f"C5 decoupage[{i}] carte {carte} != cartes_generees[{i}]={cg[i]!r}")
        elif d != "": errs.append(f"C5 decoupage[{i}] entrée invalide {d!r}")
    # C6
    for s in scenes:
        src = s.get("source", {})
        if src.get("type") == "prise" and src.get("prise_id") not in prise_ids:
            errs.append(f"C6 scène {s.get('numero')} prise_id inconnu {src.get('prise_id')}")
        v = s.get("voix", {})
        if v.get("active") and v.get("source_audio_prise_id") and v["source_audio_prise_id"] not in prise_ids:
            errs.append(f"C6 scène {s.get('numero')} source_audio_prise_id inconnu")
    # C7
    couvertes = set()
    for p in g.get("prises", []):
        for sc in p.get("scenes_alimentees", []): couvertes.add(sc)
        d = p.get("duree_cible_s", 0)
        if not (8 <= d <= 20): errs.append(f"C7 prise {p['id']} duree_cible {d} hors 8..20")
    for s in scenes:
        if s.get("source", {}).get("type") in ("generee",): couvertes.add(s.get("numero"))
        if s.get("voix", {}).get("active"):
            pass  # voix adossée à une prise déjà comptée via segments
    for s in scenes:  # scènes parlées alimentées par la prise de leur segment
        if s.get("voix", {}).get("active") and s.get("source", {}).get("type") != "prise":
            pass
    manque = set(range(1, (N or 0) + 1)) - couvertes
    # les scènes voix non-prise sont alimentées par guide_parole d'une prise : on tolère si segment référencé
    if manque:
        vraies = []
        for sc in manque:
            s = next((x for x in scenes if x.get("numero") == sc), {})
            seg = any(sg.get("scene") == sc for p in g.get("prises", []) for sg in p.get("segments_guide_parole", []))
            if not (s.get("voix", {}).get("active") and seg): vraies.append(sc)
        if vraies: errs.append(f"C7 scènes sans prise ni carte ni voix guidée : {sorted(vraies)}")
    # C8
    T = g.get("format", "")
    oblig = {c["id"] for c in g.get("champs_saisie", []) if c.get("obligatoire")}
    for need in (["nom_commerce", "whatsapp", "quartier_ville"] + ([] if T.startswith("T5") else ["prix"])):
        if need not in champ_ids: errs.append(f"C8 champ manquant {need}")
        elif need not in oblig and not (need == "prix" and T.startswith("T5")):
            errs.append(f"C8 champ {need} présent mais non obligatoire")
    return gid, errs

def main():
    root = sys.argv[1] if len(sys.argv) > 1 else "."
    files = sorted(glob.glob(os.path.join(root, "**", "T*.json"), recursive=True))
    files = [f for f in files if "/gabarits/" in f or "gabarits" in os.path.basename(os.path.dirname(os.path.dirname(f)))]
    total_err = 0
    for f in files:
        gid, errs = validate(f)
        if errs:
            total_err += len(errs)
            print(f"✗ {gid}")
            for e in errs: print(f"    {e}")
    print(f"\n{len(files)} gabarits vérifiés, {total_err} anomalies")
    return 1 if total_err else 0

if __name__ == "__main__": sys.exit(main())
