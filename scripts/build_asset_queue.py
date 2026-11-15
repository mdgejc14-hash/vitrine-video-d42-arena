#!/usr/bin/env python3
"""Construit ASSET_GENERATION_QUEUE.csv — file persistante des 29 aperçus restants.

Source de vérité du contenu métier : les JSON des gabarits (prises, consignes,
hooks). Les descriptions fondateur (ordre §3.2) servent de base, enrichie par
les données réelles de chaque gabarit. Les 10 ressources déjà intégrées ne sont
PAS dans cette file (elles sont VERIFIED dans GENERATED_ASSETS.md).
"""
import csv, json, os

GAB = "data/src/main/assets/gabarits"
SECTEURS = [
    ("batiment_travaux", "Bâtiment & Travaux"),
    ("coiffure_beaute", "Coiffure & Beauté"),
    ("immo_auto", "Immo & Auto"),
    ("restaurants_maquis", "Restaurants & Maquis"),
    ("shops_small_business", "Shops & Small Business"),
    ("vetements_mode", "Vêtements & Mode"),
]

# Descriptions fondateur (ordre §3.2) — base des prompts
BASE = {
    ("batiment_travaux", 2): "a mason finishing a smooth plaster coating on a wall, one half of the wall still rough unfinished concrete blocks and the other half beautifully finished, showing the before/after transformation of the job",
    ("batiment_travaux", 3): "close-up of a craftsman's hands with trowel and spirit level laying neat tiles, visible careful finishing work, finished painted wall in background",
    ("batiment_travaux", 4): "a proud building contractor standing with arms crossed in front of a freshly completed small modern house, clean rendered walls and new gate",
    ("batiment_travaux", 5): "a happy woman homeowner smiling next to the builder in front of her freshly renovated house facade, credible testimonial moment",
    ("coiffure_beaute", 1): "a hairstylist braiding a seated female client in a bright hair salon, hands working on natural hair, warm professional moment",
    ("coiffure_beaute", 2): "final result of freshly done professional braids on an African woman, beauty portrait framing, salon lighting",
    ("coiffure_beaute", 3): "hair care treatment in progress, professional hands applying hair product, close-up gesture in a salon",
    ("coiffure_beaute", 4): "a finished elegant hairstyle showcased in a salon, client facing camera",
    ("coiffure_beaute", 5): "a satisfied female client smiling and presenting her new hairstyle after the service",
    ("immo_auto", 1): "a car in a dealership courtyard with a key handover between seller and customer",
    ("immo_auto", 2): "a car being prepared and cleaned before sale, before/after care situation, washing and detailing",
    ("immo_auto", 3): "interior presentation of a vehicle, dashboard details, clean seats, natural light through windows",
    ("immo_auto", 4): "a clean villa or house with a courtyard, real-estate photography style, bright day",
    ("immo_auto", 5): "a customer giving his testimony in front of the property or car he just visited",
    ("restaurants_maquis", 1): "a served maquis plate: grilled chicken with attieke and spicy sauce, appetizing presentation",
    ("restaurants_maquis", 2): "cooking over fire, professional chef gesture in a maquis kitchen, flames and steam",
    ("restaurants_maquis", 3): "a dish photographed from several angles, close-up appetizing detail, sauce and texture visible",
    ("restaurants_maquis", 4): "a hot freshly plated dish served on a maquis table",
    ("restaurants_maquis", 5): "a customer enjoying and tasting his meal in a local restaurant environment",
    ("shops_small_business", 1): "opening a parcel box / new stock arrival in a small neighborhood shop, merchandise being unpacked",
    ("shops_small_business", 2): "new products being placed on shelves, tidy neighborhood grocery store",
    ("shops_small_business", 3): "a product presented from the front, from the side and in close-up on a shelf",
    ("shops_small_business", 4): "a product highlighted on a commercial display stand in a small shop",
    ("shops_small_business", 5): "a customer holding his purchase inside a neighborhood shop",
    ("vetements_mode", 1): "racks of newly arrived colorful African wax fabric clothing in a boutique",
    ("vetements_mode", 2): "before/after restyling result on the same subject in the same place, outfit transformation",
    ("vetements_mode", 3): "a garment presented from the front, from the side and in close-up, fabric texture detailed",
    ("vetements_mode", 4): "a clothing item highlighted on a hanger in an elegant boutique",
    ("vetements_mode", 5): "a female client wearing the garment inside the boutique, fashion pose",
}

# Lots fondateur : 1 = batiment T2-T5 + coiffure T1-T5 + immo T1 ; 2 = immo T2-T5 + resto T1-T5 + shops T1 ; 3 = shops T2-T5 + vetements T1-T5
def lot_de(sect, tier):
    if sect == "batiment_travaux" or (sect == "coiffure_beaute"):
        return 1
    if sect == "immo_auto" and tier == 1:
        return 1
    if sect == "immo_auto" or sect == "restaurants_maquis":
        return 2
    if sect == "shops_small_business" and tier == 1:
        return 2
    return 3

STYLE = ("Realistic professional documentary photograph, West Africa (Benin / "
         "Cotonou), authentic local trade environment, natural warm light, "
         "clear commercial composition, horizontal 16:9 framing, shallow depth "
         "of field, high detail, photorealistic, no text, no captions, no "
         "watermark, no third-party logos, no brand names, not artificial "
         "looking")

rows = []
for sect, libelle in SECTEURS:
    for tier in range(1, 6):
        if sect == "batiment_travaux" and tier == 1:
            continue  # déjà intégré (VERIFIED)
        path = os.path.join(GAB, sect, f"T{tier}.json")
        d = json.load(open(path, encoding="utf-8"))
        prises = d.get("prises", [])
        prises_txt = " ; ".join(p.get("libelle", "") for p in prises[:5])
        lum = prises[0].get("lumiere", "") if prises else ""
        hook = (d.get("copywriting", {}).get("hooks") or [""])[0]
        notes = d.get("notes_adaptation", "")
        base = BASE[(sect, tier)]
        prompt = (f"{STYLE}. Scene: {base}. This illustrates the video ad "
                  f"template \"{d.get('nom_format_affiche', d['id'])}\" for the "
                  f"sector {libelle}: the merchant films {prises_txt}. "
                  f"Tone of the ad: {hook}. Lighting mood: {lum}. "
                  f"Editorial rule respected: {notes}")
        rows.append({
            "gabarit_id": d["id"],
            "secteur": sect,
            "secteur_libelle": libelle,
            "nom_format": d.get("nom_format_affiche", ""),
            "json_reference": path,
            "contenu_metier": prises_txt[:300],
            "consigne_tournage": (prises[0].get("consigne_camera", "") if prises else "")[:200],
            "prompt_generation": prompt,
            "fichier_final": f"apercu_{sect}_t{tier}.webp",
            "emplacement_android": "feature-catalog/src/main/res/drawable-nodpi/",
            "lot": lot_de(sect, tier),
            "statut": "PENDING",
            "provenance": "Originale générée IA — projet VITRINE VIDÉO",
            "dimensions": "",
            "taille_octets": "",
            "sha256": "",
            "date_generation": "",
            "date_integration": "",
            "statut_validation": "",
        })

assert len(rows) == 29, f"attendu 29, obtenu {len(rows)}"
par_lot = {}
for r in rows:
    par_lot.setdefault(r["lot"], []).append(r)
for l in sorted(par_lot):
    print(f"Lot {l}: {len(par_lot[l])} images — " +
          ", ".join(r["gabarit_id"].split("_")[0] + " T" + r["gabarit_id"][-2:] for r in par_lot[l]))

out = "docs/checkpoints/D42_34/ASSET_GENERATION_QUEUE.csv"
with open(out, "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)
print(f"\n{out}: {len(rows)} lignes PENDING")
