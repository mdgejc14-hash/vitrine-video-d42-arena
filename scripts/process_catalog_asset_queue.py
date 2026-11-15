#!/usr/bin/env python3
"""Chaîne de traitement des aperçus catalogue (ordre fondateur final §2).

File : docs/checkpoints/D42_34/ASSET_GENERATION_QUEUE.csv (mémoire permanente).
Statuts : PENDING → GENERATING → GENERATED → OPTIMIZED → INTEGRATED → VERIFIED
(ou BLOCKED). Les images déjà VERIFIED ne sont jamais régénérées.

Commandes :
  status                état de la file par lot/statut
  next [n]              n prochains PENDING (défaut 10) avec prompt complet
  integrate IDS...      convertit les sources assets_gen en WebP 640×360 q86,
                        intègre drawable-nodpi, SHA-256, update la file
  verify                contrôle les 30 aperçus : présence, dimensions, ratio,
                        format, doublons exacts (SHA-256) et perceptuels
                        (hash moyen), cohérence ApercuGabarit.map
  emit-map              régénère ApercuGabarit.kt depuis les entrées intégrées
  mark-verified IDS...  passe à VERIFIED après vérification distante GitHub
"""
import csv, hashlib, json, os, subprocess, sys
from PIL import Image

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
QUEUE = os.path.join(REPO, "docs/checkpoints/D42_34/ASSET_GENERATION_QUEUE.csv")
DRAW = os.path.join(REPO, "feature-catalog/src/main/res/drawable-nodpi")
SRC = "/home/user/assets_gen"
KT = os.path.join(REPO, "feature-catalog/src/main/kotlin/video/vitrine/feature/catalog/ApercuGabarit.kt")
GAB = os.path.join(REPO, "data/src/main/assets/gabarits")
VALID = {"PENDING", "GENERATING", "GENERATED", "OPTIMIZED", "INTEGRATED", "VERIFIED", "BLOCKED"}

def load():
    with open(QUEUE, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))

def save(rows):
    with open(QUEUE, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)

def ahash(path, size=8):
    im = Image.open(path).convert("L").resize((size, size), Image.LANCZOS)
    px = list(im.getdata())
    avg = sum(px) / len(px)
    return sum((1 << i) for i, v in enumerate(px) if v > avg)

def hamming(a, b):
    return bin(a ^ b).count("1")

def find_source(sect, tier):
    for ext in (".png", ".jpg"):
        for pat in (f"apercu_{sect}_T{tier}", f"apercu_{sect}_t{tier}"):
            p = os.path.join(SRC, pat + ext)
            if os.path.exists(p):
                return p
    return None

def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()

def cmd_status():
    rows = load()
    from collections import Counter
    print("File:", len(rows), "entrées")
    for l in ("1", "2", "3"):
        sub = [r for r in rows if r["lot"] == l]
        c = Counter(r["statut"] for r in sub)
        print(f"  Lot {l}: {len(sub)} — " + ", ".join(f"{k}:{v}" for k, v in sorted(c.items())))
    v = [r for r in rows if r["statut"] == "VERIFIED"]
    print(f"  VERIFIED: {len(v)}/29 | intégrés total (avec T1 existant): {len(v)+1}/30")

def cmd_next(n=10):
    rows = load()
    pend = [r for r in rows if r["statut"] in ("PENDING", "GENERATING", "BLOCKED")][:n]
    if not pend:
        print("Aucun PENDING — file terminée.")
        return
    # marque GENERATING (réservation du curseur)
    for r in rows:
        if r["gabarit_id"] in {p["gabarit_id"] for p in pend}:
            r["statut"] = "GENERATING"
    save(rows)
    for i, r in enumerate(pend, 1):
        print(f"--- {i}/{len(pend)} {r['gabarit_id']} (lot {r['lot']}) → {r['fichier_final']}")
        print(f"PROMPT:\n{r['prompt_generation']}\n")

def cmd_integrate(ids):
    rows = load()
    by = {r["gabarit_id"]: r for r in rows}
    for gid in ids:
        r = by[gid]
        sect, tier = r["secteur"], int(r["gabarit_id"][-1])
        src = find_source(sect, tier)
        if not src:
            print(f"{gid}: SOURCE INTROUVABLE dans {SRC} — BLOCKED")
            r["statut"], r["statut_validation"] = "BLOCKED", "source manquante"
            continue
        dst = os.path.join(DRAW, r["fichier_final"])
        im = Image.open(src).convert("RGB")
        # recadrage 16:9 centré puis 640×360 LANCZOS
        w, h = im.size
        target = 16 / 9
        if w / h > target:
            nw = int(h * target)
            im = im.crop(((w - nw) // 2, 0, (w + nw) // 2, h))
        else:
            nh = int(w / target)
            im = im.crop((0, (h - nh) // 2, w, (h + nh) // 2))
        im = im.resize((640, 360), Image.LANCZOS)
        im.save(dst, "WEBP", quality=86, method=6)
        r.update({
            "statut": "INTEGRATED",
            "dimensions": "640x360",
            "taille_octets": str(os.path.getsize(dst)),
            "sha256": sha256(dst),
            "date_integration": subprocess.run(["date", "+%Y-%m-%d %H:%M"],
                capture_output=True, text=True).stdout.strip(),
            "statut_validation": "intégré, en attente de vérification distante",
        })
        print(f"{gid}: {r['fichier_final']} {r['taille_octets']} o sha={r['sha256'][:12]}…")
    save(rows)

def cmd_verify():
    ids_json = []
    for sect in os.listdir(GAB):
        d = os.path.join(GAB, sect)
        if os.path.isdir(d):
            for f in os.listdir(d):
                if f.endswith(".json"):
                    j = json.load(open(os.path.join(d, f), encoding="utf-8"))
                    ids_json.append((j["id"], sect, int(f[1]))
                                    if False else (j["id"], sect, int(f.replace(".json", "")[1:])))
    assert len(ids_json) == 30, f"30 gabarits attendus, {len(ids_json)}"
    rows = load()
    by = {r["gabarit_id"]: r for r in rows}
    kt = open(KT, encoding="utf-8").read()
    errs, warns = [], []
    hashes, ahashes = {}, {}
    # T1 batiment déjà intégré avant la file
    files = {"batiment_travaux_T1": "apercu_batiment_travaux_t1.webp"}
    for r in rows:
        files[r["gabarit_id"]] = r["fichier_final"]
    for gid, sect, tier in sorted(ids_json):
        fn = files.get(gid)
        p = os.path.join(DRAW, fn or "")
        if not fn or not os.path.exists(p):
            errs.append(f"{gid}: FICHIER MANQUANT ({fn})")
            continue
        im = Image.open(p)
        if im.size != (640, 360):
            errs.append(f"{gid}: dimensions {im.size} != 640x360")
        if im.format != "WEBP":
            errs.append(f"{gid}: format {im.format} != WEBP")
        h = sha256(p)
        if h in hashes:
            errs.append(f"{gid}: DOUBLON EXACT de {hashes[h]}")
        hashes[h] = gid
        a = ahash(p)
        for other, og in ahashes.items():
            d = hamming(a, other)
            if d <= 5:
                warns.append(f"{gid}: très similaire à {og} (hamming {d})")
        ahashes[a] = gid
        key = f'"{gid}" to'
        if key not in kt:
            errs.append(f"{gid}: absent de ApercuGabarit.map")
    print(f"Gabarits: {len(ids_json)} | fichiers: {len(hashes)} | erreurs: {len(errs)} | avertissements: {len(warns)}")
    for e in errs:
        print("  ERREUR:", e)
    for w in warns:
        print("  ATTENTION:", w)
    return not errs

def cmd_emit_map():
    rows = load()
    entries = [("batiment_travaux_T1", "apercu_batiment_travaux_t1")]
    for r in rows:
        if r["statut"] in ("INTEGRATED", "VERIFIED"):
            entries.append((r["gabarit_id"], r["fichier_final"].replace(".webp", "")))
    entries.sort()
    body = ",\n".join(f'        "{gid}" to R.drawable.{res}' for gid, res in entries)
    kt = f'''package video.vitrine.feature.catalog

/**
 * D42.34 (ordre finalisation visuelle §5.1) : aperçus photographiques RÉELS
 * par gabarit du catalogue — « les blocs colorés génériques ne remplacent
 * pas de véritables aperçus visuels ». Une image originale générée pour le
 * projet (aucune licence tierce, registre GENERATED_ASSETS) par gabarit.
 *
 * Contrat : resPour() renvoie null quand l'aperçu n'existe pas encore —
 * la vignette dessinée de marque (D42.30) reste le repli honnête (jamais
 * un bloc gris, jamais une photo répétée pour tromper).
 *
 * Généré par scripts/process_catalog_asset_queue.py (emit-map) —
 * {len(entries)} entrées intégrées / 30.
 */
internal object ApercuGabarit {{

    private val map: Map<String, Int> = mapOf(
{body},
    )

    fun resPour(gabaritId: String?): Int? = gabaritId?.let {{ map[it] }}
}}
'''
    open(KT, "w", encoding="utf-8").write(kt)
    print(f"ApercuGabarit.kt régénéré : {len(entries)} entrées")

def cmd_mark_verified(ids):
    rows = load()
    by = {r["gabarit_id"]: r for r in rows}
    for gid in ids:
        r = by[gid]
        r["statut"] = "VERIFIED"
        r["statut_validation"] = "présent sur GitHub, contrôlé, intégration vérifiée"
        print(gid, "→ VERIFIED")
    save(rows)

if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "status"
    if cmd == "status":
        cmd_status()
    elif cmd == "next":
        cmd_next(int(sys.argv[2]) if len(sys.argv) > 2 else 10)
    elif cmd == "integrate":
        cmd_integrate(sys.argv[2:])
    elif cmd == "verify":
        sys.exit(0 if cmd_verify() else 1)
    elif cmd == "emit-map":
        cmd_emit_map()
    elif cmd == "mark-verified":
        cmd_mark_verified(sys.argv[2:])
    else:
        print(__doc__)
