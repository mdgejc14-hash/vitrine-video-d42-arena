#!/usr/bin/env python3
"""Lot 3 D42.33 (v2) — génération de la galerie complète depuis l'inventaire.

Produit (déterministe et idempotent — source de vérité = SCREEN_INVENTORY.csv) :
  - BEFORE_AFTER.csv : correspondance état -> AVANT / APRÈS / statut ;
  - MANIFEST.tsv     : inventaire complet des fichiers BEFORE/ et AFTER/ ;
  - README.md        : galerie chronologique défilante, images Markdown
                       intégrées (rendues directement par GitHub).

Règles :
  - aucun lien vers une image inexistante (contrôle avant émission) ;
  - aucun doublon (les fichiers doivent être uniques par md5 — contrôlé) ;
  - les états sans capture honnête restent visibles avec leur statut ;
  - les captures sœurs P01-08 (saisie manuelle / détection) figurent sous
    leur état parent (états de remplissage réels et distincts).
"""

import csv
import hashlib
import os
import re
import sys

ICI = os.path.dirname(os.path.abspath(__file__))
GAL = os.path.abspath(os.path.join(ICI, ".."))            # .../D42_33/visual-review
D42_33 = os.path.abspath(os.path.join(GAL, ".."))         # .../D42_33
ROOT = os.path.abspath(os.path.join(D42_33, "..", "..", ".."))  # racine du repo
INV = os.path.join(D42_33, "SCREEN_INVENTORY.csv")

SOEURS = {
    "P01-08": [
        "P01-08_code-parrain-saisie-manuelle_APRES.png",
        "P01-08_connexion-code-parrain-detected_APRES.png",
    ],
    # Captures v1 orphelines : états RÉELS du code (repli défensif catalogue,
    # composant de marque) conservés comme variantes documentées — aucun état
    # inventaire supplémentaire n'est inventé.
    "P03-01": [
        "04_catalogue_fr_w360_APRES_filtre-Mode-actif.png",
    ],
    "P02-06": [
        "10_marque_fr_defaut_APRES_header-logo-officiel.png",
    ],
}

PROV_V1 = "run android-ci 43610784376 (0a114ce, D42.33 v1)"
PROV_LOT2 = "Lot 2 D42.33 v2 (c110c46, CI 43626981859 SUCCESS) — tests Lot2*VisualCheckTest"
PROV_CORR = {
    "01_langue_fr_w360_APRES_selection-langue.png":
        "Lot 2 D42.33 v2 — CORRECTION écart : rendu FR authentique (v1 = EN par défaut Robolectric)",
    "03_secteurs_fr_w360_APRES_grille-secteurs-3D.png":
        "Lot 2 D42.33 v2 — CORRECTION écart : rendu FR authentique (v1 = EN par défaut Robolectric)",
}


def chemin(celle):
    """Extrait le chemin PNG d'une cellule 'chemin (prose)'."""
    if not celle:
        return ""
    m = re.match(r"^(docs/\S+\.png)", celle.strip())
    return m.group(1) if m else ""


def chemin_xml(celle):
    """Extrait un éventuel chemin de dump XML (AVANT sans image)."""
    if not celle:
        return ""
    m = re.match(r"^(docs/\S+\.xml)", celle.strip())
    return m.group(1) if m else ""


def existe(path):
    return bool(path) and os.path.exists(os.path.join(ROOT, path))


def rel_depuis_readme(path):
    """Chemin relatif au README (docs/checkpoints/D42_33/visual-review)."""
    return os.path.relpath(os.path.join(ROOT, path), GAL).replace(os.sep, "/")


def md5(path):
    h = hashlib.md5()
    with open(path, "rb") as f:
        for bloc in iter(lambda: f.read(65536), b""):
            h.update(bloc)
    return h.hexdigest()


# ------------------------------------------------------------------- lecture
rows = list(csv.DictReader(open(INV, encoding="utf-8")))
apres_files = sorted(os.listdir(os.path.join(GAL, "AFTER")))
avant_files = sorted(os.listdir(os.path.join(GAL, "BEFORE")))

# ------------------------------------------------------- BEFORE_AFTER.csv
avec_avant = avec_apres = 0
avec_paire = 0
with open(os.path.join(GAL, "BEFORE_AFTER.csv"), "w", encoding="utf-8", newline="") as f:
    w = csv.writer(f)
    w.writerow(["id", "parcours", "ecran", "etat", "statut",
                "fichier_avant", "fichier_apres", "remarque"])
    for r in rows:
        av = chemin(r["capture_avant"])
        ap = chemin(r["capture_apres"])
        av_ok, ap_ok = existe(av), existe(ap)
        if av_ok:
            avec_avant += 1
        if ap_ok:
            avec_apres += 1
        if av_ok and ap_ok:
            avec_paire += 1
        w.writerow([r["id"], r["parcours"], r["ecran"], r["etape_etat"], r["statut"],
                    av if av_ok else "", ap if ap_ok else "", r["observation"]])


# ------------------------------------------------------------- MANIFEST.tsv
# correspondance fichier APRÈS -> ligne d'inventaire (états + sœurs P01-08)
inv_apres = {}
parent_soeurs = {}
for r in rows:
    ap = chemin(r["capture_apres"])
    if ap and os.path.basename(ap) in apres_files:
        inv_apres[os.path.basename(ap)] = r
    for s in SOEURS.get(r["id"], []):
        parent_soeurs[s] = r

# provenances de l'ancien MANIFEST (BEFORE inchangés)
old_manifest = {}
for ln in open(os.path.join(GAL, "MANIFEST.tsv"), encoding="utf-8").read().splitlines()[1:]:
    p = ln.split("\t")
    if len(p) >= 7 and p[0]:
        old_manifest[os.path.basename(p[0])] = ln

lignes_manifest = []
for name in avant_files:
    src = old_manifest.get(name)
    lignes_manifest.append(src if src else f"BEFORE/{name}\t?\t?\t?\t?\t?\tprovenance inconnue (à compléter)")
for name in apres_files:
    r = inv_apres.get(name) or parent_soeurs.get(name)
    if name in PROV_CORR:
        prov = PROV_CORR[name]
    elif re.match(r"^P\d+-\d+_", name):
        prov = PROV_LOT2
    else:
        prov = PROV_V1
    if r is not None:
        langue = r["langue"] if r["langue"] in ("fr", "en") else "fr"
        etat = (r["etape_etat"].replace("|", "/") or r["ecran"])[:60]
        suffixe = " — variante de remplissage réelle" if name in parent_soeurs and name not in inv_apres else ""
        lignes_manifest.append(
            f"AFTER/{name}\t{r['ecran'][:36]}\t{langue}\t{r['resolution'][:24]}\t"
            f"\t{etat}{suffixe}\t{prov}")
    else:
        lignes_manifest.append(f"AFTER/{name}\t?\t?\t?\t?\t?\t{prov} — non référencé (à vérifier)")

with open(os.path.join(GAL, "MANIFEST.tsv"), "w", encoding="utf-8", newline="") as f:
    f.write("fichier\tecran\tlangue\tresolution\tpixels\tetat\tprovenance\n")
    f.write("\n".join(lignes_manifest) + "\n")

# ------------------------------------------------------------------ README.md
images_emises = 0
chemins_valides = 0
cellules_texte = 0
captures_indisponibles = []
manquants = []

sections = []
cur = None
for r in rows:
    if r["parcours"] != cur:
        cur = r["parcours"]
        sections.append((cur, []))
    sections[-1][1].append(r)

compte = {}
for r in rows:
    compte[r["statut"]] = compte.get(r["statut"], 0) + 1

L = []
L.append("# Galerie visuelle D42.33 v2 — les 12 parcours, avant/après")
L.append("")
L.append(f"**{len(rows)} états inventoriés** · {len(avant_files)} captures AVANT (D42.32) · "
         f"**{len(apres_files)} captures APRÈS (D42.33)** — toutes des rendus Android "
         "**réels** (Robolectric `GraphicsMode NATIVE`, pipeline Skia ; AVANT d'émulateur "
         "1080×2340 pour la campagne D42.32). Aucune maquette, aucune preuve fabriquée.")
L.append("")
L.append("Sources : [`SCREEN_INVENTORY.csv`](../SCREEN_INVENTORY.csv) · "
         "[`MANIFEST.tsv`](MANIFEST.tsv) · [`BEFORE_AFTER.csv`](BEFORE_AFTER.csv) · "
         "généré par [`tools/build_gallery.py`](tools/build_gallery.py) (idempotent).")
L.append("")
L.append("## Synthèse des statuts")
L.append("")
L.append("| Statut | États |")
L.append("|---|---|")
for st in sorted(compte, key=lambda s: (-compte[s], s)):
    L.append(f"| {st} | {compte[st]} |")
L.append(f"| **Total** | **{len(rows)}** |")
L.append("")
L.append(f"Correspondances AVANT↔APRÈS complètes : **{avec_paire}** paires d'images "
         f"(sur {len(rows)} états — les autres n'ont pas d'AVANT exploitable ou pas "
         "d'APRÈS rendable honnêtement ; chaque cas est explicité ci-dessous).")
L.append("")
L.append("---")
L.append("")

for parcours, rs in sections:
    pid = rs[0]["id"].split("-")[0]
    L.append(f"## Parcours {pid} — {parcours.split(' ', 1)[1]}")
    L.append("")
    for r in rs:
        av = chemin(r["capture_avant"])
        ap = chemin(r["capture_apres"])
        av_ok, ap_ok = existe(av), existe(ap)
        if av and not av_ok:
            manquants.append((r["id"], "AVANT", av))
        if ap and not ap_ok:
            manquants.append((r["id"], "APRÈS", ap))
        L.append(f"### {r['id']} · {r['ecran']} — {r['etape_etat']}")
        L.append("")
        L.append(f"**{r['statut']}** · langue **{r['langue']}** · résolution **{r['resolution']}**")
        L.append("")
        L.append(f"> {r['observation']}")
        L.append("")
        L.append("| AVANT (D42.32) | APRÈS (D42.33) |")
        L.append("|---|---|")
        # cellule AVANT
        if av_ok:
            cellules_texte += 0
            L_c_av = f"![{r['id']} avant]({rel_depuis_readme(av)})"
            images_emises += 1
            chemins_valides += 1
        elif av:
            cellules_texte += 1
            raison = r["capture_avant"].split("(", 1)[-1].rstrip(")") if "(" in r["capture_avant"] else ""
            L_c_av = f"_AVANT non disponible_{(' — ' + raison) if raison else ''}"
            captures_indisponibles.append(r["id"])
        elif chemin_xml(r["capture_avant"]):
            cellules_texte += 1
            L_c_av = f"_AVANT : dump XML uniquement (pas d'image) — `{chemin_xml(r['capture_avant'])}`_"
        else:
            cellules_texte += 1
            L_c_av = "_aucune capture AVANT_"
        # cellule APRÈS
        if ap_ok:
            L_c_ap = f"![{r['id']} après]({rel_depuis_readme(ap)})"
            images_emises += 1
            chemins_valides += 1
        elif ap:
            cellules_texte += 1
            L_c_ap = f"_APRÈS référencé mais absent : `{ap}`_"
            captures_indisponibles.append(r["id"])
        else:
            cellules_texte += 1
            L_c_ap = "_pas de capture APRÈS (voir statut ci-dessus)_"
        L.append(f"| {L_c_av} | {L_c_ap} |")
        L.append("")
        # captures sœurs (états réels distincts : remplissage, repli défensif…)
        for s in SOEURS.get(r["id"], []):
            sp = os.path.join(GAL, "AFTER", s)
            if os.path.exists(sp):
                L.append(f"Variante réelle complémentaire — `{s}` :")
                L.append("")
                L.append("| |")
                L.append("|---|")
                L.append(f"| ![{r['id']} variante](AFTER/{s}) |")
                L.append("")
                images_emises += 1
                chemins_valides += 1
    L.append("---")
    L.append("")

L.append("## Provenance — aucune image fabriquée")
L.append("")
L.append("- **BEFORE/** — run android-ci 43586092209, commit `b5a1462` (D42.32). "
         "Écart documenté : les 3 fichiers onboarding (langue, carrousel, secteurs) "
         "y sont rendus en **anglais** (défaut Robolectric — harnais v0 sans qualifier "
         "de locale) ; détail dans `MANIFEST.tsv`.")
L.append("- **AFTER/** — deux vagues :")
L.append("  - fichiers `NN_ecran_*` : run android-ci 43610784376, commit `0a114ce` (v1) ;")
L.append("  - fichiers `PNN-NN_*` : **Lot 2 D42.33 v2** — commit `c110c46`, CI "
         "**43626981859 SUCCESS** — 8 fichiers de test `Lot2*VisualCheckTest.kt`, "
         "vrais composants, états et données (JSON embarqués, seed DB, ActivityScenario) ;")
L.append("  - `01_langue_fr` et `03_secteurs_fr` : **corrigés au Lot 2** — les fichiers "
         "v1 étaient des rendus EN (preuve md5 : byte-identiques aux rendus EN de "
         "P01-04/P02-08, différents des rendus FR des tests `correction_galerie_*`).")
L.append("- **AVANT d'émulateur (1080×2340)** : campagne D42.32 conservée sous "
         "`docs/checkpoints/D42_32/visual-review/captures/` (réutilisation des preuves, "
         "budget 0 FCFA).")
L.append("")
L.append("## Limites honnêtes (Robolectric et états non rendables)")
L.append("")
L.append("- **Splash (P01-01/P01-02)** : la splash screen API 12+ n'est pas rendue par "
         "Robolectric — NON PROUVÉ assumé (code conforme vérifié au Lot 1).")
L.append("- **Dialogue système (P05-12)** : la demande de permission caméra est un "
         "dialogue système, non rendable honnêtement ; la réponse in-app est capturée "
         "(P05-13).")
L.append("- **Clavier logiciel** : jamais rendu par Robolectric.")
L.append("- **PreviewView caméra** : vide sans matériel — les captures caméra montrent "
         "le HUD réel autour d'une zone de viseur vide (P05-04…P05-09).")
L.append("- **Épinglé vs scroll** : `swipeUp()` sur `onRoot()` ne défile rien quand un "
         "élément est épinglé (tab bar dashboard, CTA brief) — les états « bas d'écran » "
         "utilisent `performScrollTo` + `assertIsDisplayed` (preuve de visibilité réelle "
         "dans les tests).")
L.append("- **États sans rendu distinct** (P01-07, P02-05, P02-07, P05-10, P12-14, "
         "P12-16) : DOCUMENTÉS dans l'inventaire — aucune capture dupliquée pour gonfler "
         "la galerie.")
L.append("- **FLAG_SECURE jamais contourné** : captures issues des tests Compose en "
         "environnement de test.")
L.append("")

open(os.path.join(GAL, "README.md"), "w", encoding="utf-8").write("\n".join(L) + "\n")

# ------------------------------------------------------- contrôle de cohérence
doublons_md5 = {}
for name in apres_files:
    h = md5(os.path.join(GAL, "AFTER", name))
    doublons_md5.setdefault(h, []).append(name)
dups = [v for v in doublons_md5.values() if len(v) > 1]

img_readme = len(re.findall(r"!\[[^\]]*\]\(", "\n".join(L)))
err = 0
print("=" * 62)
print("CONTRÔLE DE COHÉRENCE — build_gallery.py")
print("=" * 62)
print(f"états inventaire           : {len(rows)}")
print(f"captures BEFORE (disques)  : {len(avant_files)}")
print(f"captures AFTER  (disques)  : {len(apres_files)}")
print(f"lignes MANIFEST (fichiers) : {len(lignes_manifest)} (dont AFTER {len(apres_files)}, BEFORE {len(avant_files)})")
print(f"états avec AVANT valide    : {avec_avant}")
print(f"états avec APRÈS valide    : {avec_apres}")
print(f"paires AVANT+APRÈS         : {avec_paire}")
print(f"images émises dans README  : {images_emises} (regex trouvées : {img_readme})")
print(f"chemins d'images valides   : {chemins_valides}")
print(f"cellules non-image expliquées : {cellules_texte} (AVANT indisponible ou APRÈS non rendable, chacune explicitée dans le README)")
print(f"captures indisponibles     : {len(captures_indisponibles)} états {sorted(set(captures_indisponibles))}")
print(f"doublons md5 AFTER         : {len(dups)} {['='.join(v) for v in dups]}")
if manquants:
    print(f"CHEMINS RÉFÉRENCÉS ABSENTS : {len(manquants)}")
    for mid, kind, p in manquants:
        print(f"  - {mid} {kind}: {p}")
else:
    print("chemins référencés absents : 0")
non_ref = [n for n in apres_files if n not in inv_apres and n not in parent_soeurs]
if non_ref:
    err += 1
    print(f"!! APRÈS non référencés par l'inventaire : {non_ref}")
# concordance entre les 3 fichiers
ba = list(csv.DictReader(open(os.path.join(GAL, "BEFORE_AFTER.csv"), encoding="utf-8")))
assert len(ba) == len(rows), "BEFORE_AFTER.csv != inventaire"
mf = len(lignes_manifest)
assert mf == len(avant_files) + len(apres_files), "MANIFEST != fichiers sur disque"
assert img_readme == images_emises, "images README != images émises"
if len(dups):
    err += 1
print("concordance inventaire/manifest/galerie : " + ("OK" if err == 0 else "ÉCART"))
print("=" * 62)
sys.exit(1 if (err or manquants) else 0)
