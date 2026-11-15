#!/usr/bin/env python3
"""D42.34 — génération de 02_MATRICE_GABARITS_30.csv depuis les 30 JSON canoniques.
Lecture seule des assets ; aucune modification des gabarits."""
import csv, glob, json, os

ROOT = "data/src/main/assets/gabarits"
OUT = "docs/checkpoints/D42_34/02_MATRICE_GABARITS_30.csv"

rows = []
for path in sorted(glob.glob(os.path.join(ROOT, "*", "*.json"))):
    d = json.load(open(path, encoding="utf-8"))
    prises = d.get("prises", [])
    rows.append({
        "id": d["id"],
        "secteur": d["secteur"],
        "secteur_libelle": d.get("secteur_libelle", ""),
        "nom_format_affiche": d.get("nom_format_affiche", ""),
        "format": d.get("format", ""),
        "ratio": d.get("ratio", ""),
        "duree_totale_s": d.get("duree_totale_secondes", 0),
        "nombre_scenes": d.get("nombre_scenes", 0),
        "nombre_prises": len(prises),
        "libelles_prises": " | ".join(p.get("libelle", "?") for p in prises),
        "durees_cibles_s": " | ".join(str(p.get("duree_cible_s", "?")) for p in prises),
        "types_plan": " | ".join(p.get("type_plan", "?") for p in prises),
        "photo_acceptee_partout": "oui" if all(p.get("photo_acceptee") for p in prises) else "non",
        "fichier": os.path.relpath(path, ROOT),
    })

rows.sort(key=lambda r: (r["secteur"], r["id"]))
with open(OUT, "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

print(f"{len(rows)} lignes -> {OUT}")
secteurs = {}
for r in rows:
    secteurs.setdefault(r["secteur"], []).append(r["id"])
for s, ids in sorted(secteurs.items()):
    print(f"  {s}: {len(ids)} ({', '.join(ids)})")
assert len(rows) == 30, "ERREUR : != 30 gabarits"
