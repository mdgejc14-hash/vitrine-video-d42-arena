#!/usr/bin/env python3
"""
D42.26 — Action F : AUDIT DE CONTENU DES 30 GABARITS (6 secteurs × 5 formats).

Audit STATIQUE des fichiers de définition (content/gabarits_v2/gabarits/) :
catalogue, brief, séquences, ordre, textes, structure de montage, musique,
effets/transitions, durée, export, 3 modes audio (voix / musique seule /
voix+musique), aucune obligation de parler.

Cet audit ne modifie AUCUNE composition (règle D42.26 : ne pas modifier les
600 compositions / contenus sans autorisation). Il LIT et VERIFIE.

Sortie : rapport PASS/FAIL par contrôle + code sortie non nul si défaut.
"""

import hashlib
import json
import re
import sys
from pathlib import Path

RACINE = Path(__file__).resolve().parents[2] / "content" / "gabarits_v2"
SECTEURS = [
    "batiment_travaux", "coiffure_beaute", "immo_auto",
    "restaurants_maquis", "shops_small_business", "vetements_mode",
]
FORMATS = ["T1", "T2", "T3", "T4", "T5"]

passages, echecs, bloques = 0, 0, 0
lignes_rapport = []


def record(statut, cle, detail):
    global passages, echecs, bloques
    if statut == "PASS":
        passages += 1
    elif statut == "FAIL":
        echecs += 1
    else:
        bloques += 1
    lignes_rapport.append(f"{statut}\t{cle}\t{detail}")
    print(f"GABARIT_RESULT {statut} {cle} :: {detail}")


def audit_un_gabarit(chemin: Path, d: dict):
    gid = d.get("id", "?")
    secteur = d.get("secteur", "?")
    fmt = (d.get("format") or "?").split("_")[0]

    # --- structure générale -------------------------------------------------
    record("PASS" if chemin.stem == f"{fmt}" and gid == f"{secteur}_{fmt}"
           else "FAIL",
           f"{gid}/identite",
           f"id={gid} secteur={secteur} format={d.get('format')} fichier={chemin.parent.name}/{chemin.name}")

    for cle in ["secteur_libelle", "notes_adaptation", "copywriting",
                "montage_signature", "etalonnage", "style_visuel",
                "signature_montage", "axes_signature", "formulaire_ui",
                "nom_format_affiche", "interface_commercant"]:
        record("PASS" if d.get(cle) else "FAIL", f"{gid}/{cle}",
               "présent" if d.get(cle) else "MANQUANT/VIDE")

    # --- durée & scènes ------------------------------------------------------
    scenes = d.get("scenes") or []
    total_declare = d.get("duree_totale_secondes")
    total_calcule = round(sum(float(s.get("duree_secondes", 0)) for s in scenes), 2)
    record("PASS" if total_declare and abs(total_declare - total_calcule) <= 1.0 else "FAIL",
           f"{gid}/duree_coherente",
           f"déclarée {total_declare}s vs somme des scènes {total_calcule}s")
    record("PASS" if d.get("nombre_scenes") == len(scenes) and scenes else "FAIL",
           f"{gid}/nombre_scenes",
           f"déclaré {d.get('nombre_scenes')} vs réel {len(scenes)}")
    numeros = [s.get("numero") for s in scenes]
    record("PASS" if numeros == list(range(1, len(scenes) + 1)) else "FAIL",
           f"{gid}/ordre_sequences",
           f"numéros {numeros[:5]}…{numeros[-3:] if len(numeros) > 8 else ''} séquentiels 1..N"
           if numeros == list(range(1, len(scenes) + 1)) else f"numéros non séquentiels : {numeros}")

    # --- champs de saisie / variables ---------------------------------------
    champs = d.get("champs_saisie") or []
    ids_champs = [c.get("id") for c in champs]
    record("PASS" if len(ids_champs) == len(set(ids_champs)) and ids_champs else "FAIL",
           f"{gid}/champs_uniques", f"{len(champs)} champs, ids uniques"
           if len(ids_champs) == len(set(ids_champs)) else f"ids dupliqués : {ids_champs}")
    variables = set(ids_champs) | {v.get("id") for v in (d.get("variables_calculees") or []) if v.get("id")}
    utilisees, inconnues = set(), set()
    for s in scenes:
        contenu = ((s.get("texte_ecran") or {}).get("contenu")) or ""
        for m in re.findall(r"\{(\w+)\}", contenu):
            utilisees.add(m)
            if m not in variables:
                inconnues.add(m)
    for txt in json.dumps(d.get("copywriting") or {}, ensure_ascii=False)[:20000], "":
        for m in re.findall(r"\{(\w+)\}", txt):
            utilisees.add(m)
            if m not in variables:
                inconnues.add(m)
    record("PASS" if not inconnues else "FAIL",
           f"{gid}/variables_resolues",
           f"{len(utilisees)} variables utilisées, toutes définies"
           if not inconnues else f"variables utilisées mais NON définies : {sorted(inconnues)}")

    # --- prises ---------------------------------------------------------------
    prises = {p.get("id") for p in (d.get("prises") or [])}
    refs_prises = set()
    for s in scenes:
        src = s.get("source") or {}
        if src.get("type") == "prise" and src.get("prise_id"):
            refs_prises.add(src["prise_id"])
    record("PASS" if prises and refs_prises and refs_prises <= prises else "FAIL",
           f"{gid}/prises_coherentes",
           f"{len(prises)} prises définies, {len(refs_prises)} référencées, toutes résolues"
           if refs_prises <= prises else f"prises référencées introuvables : {sorted(refs_prises - prises)}")
    gt = d.get("guide_tournage") or {}
    record("PASS" if gt.get("nombre_prises_a_filmer") and gt.get("etapes_capture") else "FAIL",
           f"{gid}/guide_tournage",
           f"{gt.get('nombre_prises_a_filmer')} prises à filmer, {len(gt.get('etapes_capture') or [])} étapes")

    # --- audio : musique + SFX + 3 modes -------------------------------------
    audio = d.get("audio") or {}
    musique = audio.get("musique") or {}
    bpm_ok = musique.get("bpm_min") is not None and musique.get("bpm_max") is not None \
        and int(musique["bpm_min"]) <= int(musique["bpm_max"])
    record("PASS" if musique.get("genre") and musique.get("categorie_audio") and bpm_ok else "FAIL",
           f"{gid}/musique",
           f"genre={musique.get('genre')}, bpm {musique.get('bpm_min')}-{musique.get('bpm_max')}, "
           f"catégorie={musique.get('categorie_audio')}")
    sfx = audio.get("sfx_scenes") or []
    scenes_avec_sfx = {x.get("scene") for x in sfx}
    record("PASS" if sfx else "FAIL", f"{gid}/sfx",
           f"{len(sfx)} effets sonores sur {len(scenes_avec_sfx)} scènes")

    # 3 modes : voix / musique seule / voix+musique. La structure doit porter
    # la décision VOIX par scène (voix.active) ET une musique : les deux étant
    # indépendants, les 3 combinaisons sont représentables. Exigence « aucune
    # obligation de parler » : au moins une scène à voix inactive OU aucune
    # voix obligatoire dans la politique de saisie.
    voix_par_scene = [bool((s.get("voix") or {}).get("active")) for s in scenes]
    a_voix = any(voix_par_scene)
    a_sans_voix = not all(voix_par_scene) if voix_par_scene else True
    record("PASS" if voix_par_scene and a_sans_voix else "FAIL",
           f"{gid}/modes_audio_3",
           f"voix active sur {sum(voix_par_scene)}/{len(voix_par_scene)} scènes ; musique présente ; "
           f"mode musique seule représentable ({sum(1 for v in voix_par_scene if not v)} scènes sans voix)")
    pol = d.get("politique_saisie") or {}
    record("PASS" if pol else "FAIL", f"{gid}/politique_saisie", f"{json.dumps(pol, ensure_ascii=False)[:120]}")

    # --- montage / effets / transitions / export ------------------------------
    trans = [s.get("transition_sortie") for s in scenes[:-1]]
    effets = [s.get("effet") for s in scenes if s.get("effet")]
    record("PASS" if all(trans) else "FAIL", f"{gid}/transitions",
           f"{len([t for t in trans if t])}/{len(trans)} transitions de sortie définies")
    record("PASS" if effets else "FAIL", f"{gid}/effets", f"{len(effets)} effets de scène")
    etapes = d.get("etapes_montage") or []
    durees_ok = all("temps_s" in e and "action" in e for e in etapes)
    record("PASS" if etapes and durees_ok else "FAIL", f"{gid}/structure_montage",
           f"{len(etapes)} étapes de montage horodatées")
    record("PASS" if d.get("ratio") == "9:16" else "FAIL", f"{gid}/ratio", f"ratio={d.get('ratio')}")


def audit_manifeste():
    mf = RACINE / "MANIFEST_SHA256.txt"
    if not mf.is_file():
        record("FAIL", "manifeste/presence", "MANIFEST_SHA256.txt introuvable")
        return
    lignes = [l.split(None, 1) for l in mf.read_text(encoding="utf-8").splitlines() if l.strip()]
    # Le manifeste utilise parfois deux espaces : normaliser.
    paires = []
    for l in mf.read_text(encoding="utf-8").splitlines():
        m = re.match(r"^([0-9a-f]{64})\s+(.+?)\s*$", l)
        if m:
            paires.append((m.group(1), m.group(2)))
    if not paires:
        record("FAIL", "manifeste/format", "aucune ligne « sha256  chemin » lisible")
        return
    manquants, alters = [], []
    for somme, rel in paires:
        cible = RACINE / rel
        if not cible.is_file():
            manquants.append(rel)
            continue
        reel = hashlib.sha256(cible.read_bytes()).hexdigest()
        if reel != somme:
            alters.append(rel)
    gabarits_listes = [rel for _, rel in paires if rel.startswith("gabarits/")]
    record("PASS" if not manquants and not alters else "FAIL",
           "manifeste/integrite",
           f"{len(paires)} entrées, {len(gabarits_listes)} gabarits, "
           + ("tous conformes" if not manquants and not alters
              else f"{len(manquants)} MANQUANTS (ex: {manquants[:2]}), "
                   f"{len(alters)} MODIFIÉS par rapport au manifeste (ex: {alters[:3]}) — "
                   "constat d'intégrité du lot, à documenter (aucune modification faite par l'audit)"))


def main():
    print("=" * 70)
    print("AUDIT DE CONTENU — 30 GABARITS × 6 SECTEURS (D42.26 action F)")
    print("=" * 70)
    vus = 0
    for secteur in SECTEURS:
        dossier = RACINE / "gabarits" / secteur
        if not dossier.is_dir():
            record("FAIL", f"catalogue/{secteur}", "dossier secteur introuvable")
            continue
        fichiers = sorted(dossier.glob("*.json"))
        attendus = {f"{t}.json" for t in FORMATS}
        record("PASS" if {f.name for f in fichiers} == attendus else "FAIL",
               f"catalogue/{secteur}",
               f"{len(fichiers)} gabarits (T1..T5 attendus : {'OK' if {f.name for f in fichiers} == attendus else 'INCOMPLET'})")
        for f in fichiers:
            try:
                d = json.loads(f.read_text(encoding="utf-8"))
            except Exception as e:
                record("FAIL", f"{f.stem}/json_valide", f"JSON illisible : {e}")
                continue
            if d.get("secteur") != secteur:
                record("FAIL", f"{f.stem}/secteur_coherent",
                       f"secteur déclaré {d.get('secteur')} ≠ dossier {secteur}")
                continue
            vus += 1
            audit_un_gabarit(f, d)
    record("PASS" if vus == 30 else "FAIL", "catalogue/completude",
           f"{vus}/30 gabarits audités")
    audit_manifeste()

    print("=" * 70)
    print(f"BILAN : PASS={passages} FAIL={echecs} BLOCKED={bloques}")
    print("=" * 70)
    sortie = Path("artifacts/gabarits-audit")
    sortie.mkdir(parents=True, exist_ok=True)
    (sortie / "results.tsv").write_text("\n".join(lignes_rapport) + "\n", encoding="utf-8")
    (sortie / "summary.txt").write_text(
        f"PASS={passages}\nFAIL={echecs}\nBLOCKED={bloques}\ngabarits={vus}/30\n", encoding="utf-8")
    return 1 if echecs else 0


if __name__ == "__main__":
    sys.exit(main())
