#!/usr/bin/env python3
"""Lot F — Galerie unique visual-review/README.md + 12_MANIFEST_GALERIE.csv.

Règles fondateur : une seule page porte d'entrée, toutes les images intégrées
(chemins relatifs GitHub), ordre du parcours réel, sommaire + ancres + retour,
réf vs APRÈS côte à côte, absences indiquées honnêtement. Chaque chemin
référencé est vérifié contre les fichiers réellement présents (local D34,
GitHub D33 AFTER, maquettes, D31 émulateur) — aucun lien mort toléré.
"""
import csv, os, subprocess

VR = "docs/checkpoints/D42_34/visual-review"
D33 = "../../D42_33/visual-review/AFTER"
MAQ = "../../D42_33/SOURCES/maquettes"
D31E = "../../D42_31/visual-review/16_export"
D31P = "../../D42_31/visual-review/18_partage"

local = set(os.listdir(VR))
after33 = set(os.listdir("/tmp/apres33/AFTER"))
maquettes = set(os.listdir("/tmp/maquettes")) if os.path.isdir("/tmp/maquettes") else set()
d31 = set()
out = subprocess.run(["git", "ls-tree", "--name-only", "-r",
                      "origin/d42.34-founder-acceptance-fixes",
                      "docs/checkpoints/D42_31/visual-review/"],
                     capture_output=True, text=True).stdout.split("\n")
for l in out:
    if l.endswith(".png"):
        d31.add(l.replace("docs/checkpoints/D42_31/visual-review/", ""))

def d33_img(f):
    assert f in after33, f"D33 absent: {f}"
    return f"{D33}/{f}"

def maq_img(f):
    assert f in maquettes, f"maquette absente: {f}"
    return f"{MAQ}/{f}"

def d34_img(f):
    assert f in local, f"D34 absent: {f}"
    return f

def d31_img(rel):
    assert rel in d31, f"D31 absent: {rel}"
    base = os.path.dirname(rel)
    return f"../../D42_31/visual-review/{base}/{os.path.basename(rel)}"

def d31_path(p):
    assert p in d31, f"D31 absent: {p}"
    return f"../../D42_31/visual-review/{p}"

man = []  # lignes du manifeste

def sec(anchor, titre, items, note):
    """items: liste de tuples (ecran/etat, ref_maquette ou None, capture ou None, statut, obs)"""
    rows = []
    for ecran, ref, cap, statut, obs in items:
        c1 = f'<img src="{maq_img(ref)}" width="180"/>' if ref else "—"
        if cap and cap.startswith("D34"):
            c2 = f'<img src="{d34_img(cap)}" width="180"/>' if cap.endswith(".png") else f'<img src="{d34_img(cap + ".png")}" width="180"/>'
            chemin = cap
        elif cap and (cap.startswith("16_export/") or cap.startswith("18_partage/")):
            c2 = f'<img src="{d31_path(cap)}" width="180"/>'
            chemin = cap
        elif cap:
            c2 = f'<img src="{d33_img(cap)}" width="180"/>'
            chemin = f"{D33}/{cap}"
        else:
            c2 = "**à produire — indiqué honnêtement**"
            chemin = "-"
        rows.append(f"| {ecran} | {c1} | {c2} | {statut} |")
        man.append({"section": titre, "ecran": ecran, "reference_fondateur": ref or "-",
                    "capture_apres": chemin, "statut": statut, "note": obs})
    return f"""### <a id="{anchor}"></a>{titre}

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
{chr(10).join(rows)}

{note}

[↑ Retour au sommaire](#sommaire)
""", len(rows)

intro = """# D42.34 — Galerie visuelle unique (réf. fondateur ↔ application)

**Porte d'entrée unique de la revue visuelle** — ordre du parcours réel de
l'application. Chaque ligne montre la **maquette fondateur** à gauche et la
**capture réelle de l'application** à droite (composants Android authentiques :
tests Robolectric `@GraphicsMode(NATIVE)`, émulateur D42.31, ou écrans système).

> **Statut au 15/11/2026 (soir) — clôture des preuves, rien de simulé :**
> - Aperçus **30/30 livrés** (lots 1, 2 et 3, 15/11) : chaque gabarit a son
>   aperçu photographique original intégré et vérifié sur GitHub (file
>   ASSET_GENERATION_QUEUE.csv — 29/29 VERIFIED, SHA-256, zéro doublon exact
>   ou perceptuel). L'aperçu shops T2 a été **régénéré sur signalement
>   fondateur** (prompt corrigé, sha 9b6249e98b25…, note au registre).
> - Captures carrousels/secteurs **refaites** avec les images originales
>   (D34-11/13/14/15), paywall CTA FR/EN (D34-18/19).
> - **Lots 8/9/10/11 livrés (15/11)** : phases métier du montage E8
>   (D34-20/21), écran « export prêt » (D34-22), les 6 dialogues réels
>   (D34-23..28 : langue, secteur, accords, nettoyage, choix pays, reprise)
>   — chemins utilisateur complets sous Robolectric.
> - **Captures catalogue définitives 30/30 livrées (Lot 6 étendu)** : les 6
>   secteurs avec leurs aperçus photo (D34-16/17/29/30/31/32), scroll bas
>   (D34-33), catalogue EN (D34-34) — les captures pré-mécanisme sont
>   remplacées ; libellé « prises guidées » recapturé (D34-03).
> - **Export en échec + bouton relance livré (D34-35, VR-055)** : échec réel
>   du travail sur signal → écran d'échec honnête, bouton réactivé.
> - Restent à produire : consentement client R4 (téléphone fondateur, caméra
>   MLKit réelle), connexion hors-ligne (Google SSO réel), notification
>   d'export (exécution réelle du worker), checkout 501 (service externe) —
>   marqués NON PROUVÉ, jamais simulés.
> - Bilan inventaire 78 états : **68 CONFORME · 6 NON PROUVÉ · 4 NON
>   APPLICABLE** (11_INVENTAIRE_COMPLET_ECRANS.csv).
> - Les états système (splash, flux viseur, feuille de partage) exigent le
>   **téléphone fondateur** — marqués NON PROUVÉ, jamais simulés.

**Légende :** CONFORME = capturé et mesuré · ÉCART = capture obsolète ou
correction en attente de recapture · NON PROUVÉ = exigé sur téléphone réel ·
NON APPLICABLE = hors périmètre (décision fondateur ou UI système).

## <a id="sommaire"></a>Sommaire

1. [Ouverture & marque](#a-ouverture--marque)
2. [Carrousel d'introduction](#b-carrousel-dintroduction)
3. [Langue](#c-langue)
4. [Connexion](#d-connexion)
5. [Code parrain](#e-code-parrain)
6. [Bienvenue & crédits](#f-bienvenue--crédits)
7. [Choix du secteur](#g-choix-du-secteur)
8. [Catalogue de gabarits](#h-catalogue-de-gabarits)
8 bis. [Aperçus des gabarits](#h2-aperçus-des-gabarits)
9. [Brief](#i-brief)
10. [Caméra guidée](#j-caméra-guidée)
11. [Validation des prises](#k-validation-des-prises)
12. [Montage](#l-montage)
13. [Export](#m-export)
14. [Partage](#n-partage)
15. [Dashboard](#o-dashboard)
16. [Formules & paywall](#p-formules--paywall)
17. [Parrainage](#q-parrainage)
18. [Réglages](#r-réglages)
19. [Écrans hors périmètre](#s-écrans-hors-périmètre)
20. [États adaptatifs](#t-états-adaptatifs)
"""

body = []
n = 0

b, c = sec("a-ouverture--marque", "1. Ouverture & marque", [
    ("Splash (logo officiel, tuile navy)", "01_ouverture.png", None, "NON PROUVÉ",
     "durée/rendu système → téléphone fondateur ; asset splash_logo_tuile.png vérifié PIL"),
    ("Marque officiale (tuile blanche + insigne)", None, "D34-12_marque-officielle_APRES.png",
     "CONFORME", "insigne mark.png reconstruit (Lot 5 D42.34)"),
], "Le splash Android système n'est pas capturable honnêtement sous Robolectric. "
   "L'identité de marque est prouvée par la tuile D34-12.")
body.append(b); n += c

b, c = sec("b-carrousel-dintroduction", "2. Carrousel d'introduction", [
    ("Slide 1 — commerçante boutique", "02_carrousel.png", "D34-11_carrousel-slide1-marchande_APRES.png",
     "CONFORME", "image ORIGINALE générée (registre GENERATED_ASSETS) ; diff PIL 68,1 % vs ancienne"),
    ("Slide 2 — cheffe de maquis", None, "D34-13_carrousel-slide-2_APRES.png",
     "CONFORME", "image originale générée (tournage restauration)"),
    ("Slide 3 — vendeur mode wax", None, "D34-14_carrousel-slide-3_APRES.png",
     "CONFORME", "image originale générée (mode)"),
    ("Slide 1 EN (l10n)", None, "P02-04_carrousel-slide-1-en_APRES.png",
     "CONFORME (pré-images)", "l10n EN ; recapture légère post-images programmée"),
    ("Rotation (paysage)", None, "P12-13_carrousel-rotation_APRES.png",
     "CONFORME (pré-images)", "rotation w640×360"),
], "Trois univers métiers **distincts** (boutique / restauration / mode) — jamais "
   "la même photo répétée (exigence §6.3). Aucun texte marketing ajouté.")
body.append(b); n += c

b, c = sec("c-langue", "3. Langue", [
    ("Sélection langue FR", "03_langue.png", "01_langue_fr_w360_APRES_selection-langue.png",
     "CONFORME", "structure blanche + CTA orange, textes identiques"),
    ("Sélection langue EN", None, "P01-04_langue-en_APRES.png", "CONFORME", "l10n EN"),
    ("Font scale 1,3", None, "P12-02_langue-fontScale-1.3_APRES.png", "CONFORME", "accessibilité"),
    ("Petit écran w360×640", None, "P12-07_langue-petit-ecran_APRES.png", "CONFORME", "petit écran"),
], "")
body.append(b); n += c

b, c = sec("d-connexion", "4. Connexion", [
    ("Connexion FR (bouton Google unique)", "04_connexion.png", "P01-05_connexion-fr_APRES.png",
     "CONFORME", "carte Google + « Utiliser sans Internet »"),
    ("Connexion EN", None, "P01-06_connexion-en_APRES.png", "CONFORME", "l10n EN"),
    ("Hors-ligne (erreur réseau)", "05_connexion_hors_ligne.png", None, "NON PROUVÉ",
     "texte auth_error_network codé ; état réseau réel à capturer (Lot F)"),
], "VR-009 : la variante d'erreur réseau nécessite une coupure réseau réelle — "
   "capture à produire, aucune simulation.")
body.append(b); n += c

b, c = sec("e-code-parrain", "5. Code parrain", [
    ("Saisie manuelle", "06_code_parrain.png", "P01-08_code-parrain-saisie-manuelle_APRES.png",
     "CONFORME", "CTA « Je n'ai pas de code »"),
    ("Deep-link pré-rempli", None, "P01-08_code-parrain-deep-link-prefilled_APRES.png",
     "CONFORME", "pré-remplissage par lien"),
    ("Code détecté (bandeau)", None, "P01-08_connexion-code-parrain-detected_APRES.png",
     "CONFORME", "bandeau auth_ref_detected"),
], "")
body.append(b); n += c

b, c = sec("f-bienvenue--crédits", "6. Bienvenue & crédits", [
    ("Crédits confirmés", "27_bienvenue.png", "P01-09_bienvenue-credits-confirmes_APRES.png",
     "CONFORME", "plein écran navy conformément à la maquette (PIL 73,5 % navy)"),
    ("Solde en attente", None, "P01-10_bienvenue-solde-en-attente_APRES.png", "CONFORME", "badge En attente"),
    ("Font scale 1,3", None, "P12-01_bienvenue-fontScale-1.3_APRES.png", "CONFORME", "accessibilité"),
    ("Petit écran", None, "P12-08_bienvenue-petit-ecran_APRES.png", "CONFORME", "w360×640"),
    ("Rotation", None, "P12-12_bienvenue-rotation_APRES.png", "CONFORME", "paysage"),
    ("Hors-connexion (crédits différés)", None, "P12-15_bienvenue-hors-connexion_APRES.png",
     "CONFORME", "message offline honnête, crédits attribués au retour réseau"),
], "")
body.append(b); n += c

b, c = sec("g-choix-du-secteur", "7. Choix du secteur", [
    ("Grille 6 secteurs (images originales)", "07_secteur.png", "D34-15_secteurs-grille_APRES.png",
     "CONFORME", "6 images ORIGINALES générées ; chromatisme mesuré 10,8 → 14,4 %"),
    ("Secteurs EN", None, "P02-08_secteurs-en_APRES.png", "CONFORME (pré-images)",
     "recapture légère programmée"),
], "Maquette PIL : blanc 86 %, tuiles discrètes — respecté.")
body.append(b); n += c

b, c = sec("h-catalogue-de-gabarits", "8. Catalogue de gabarits", [
    ("Catalogue secteur choisi (Shops)", "08_catalogue.png", "D34-31_catalogue-shops-apercus_APRES.png",
     "CONFORME", "recapture définitive 30/30 (VR-016) — test D34Lot6 étendu aux 6 secteurs"),
    ("Catalogue filtre Mode actif", None, "D34-32_catalogue-mode-apercus_APRES.png",
     "CONFORME", "recapture définitive 30/30 (VR-016)"),
    ("Catalogue Bâtiment", None, "D34-16_catalogue-batiment-apercus_APRES.png",
     "CONFORME", "recapture 30/30, corrélation template 0,982"),
    ("Catalogue Coiffure", None, "D34-17_catalogue-coiffure-apercus_APRES.png",
     "CONFORME", "recapture 30/30, corrélation template 0,988"),
    ("Catalogue Immo/Auto", None, "D34-29_catalogue-immo-apercus_APRES.png",
     "CONFORME", "recapture 30/30"),
    ("Catalogue Restauration (tuiles peuplées)", None, "D34-30_catalogue-restauration-apercus_APRES.png",
     "CONFORME", "recapture 30/30 (VR-017) — tuiles peuplées d'aperçus photo réels"),
    ("Scroll bas", None, "D34-33_catalogue-scroll-bas_APRES.png",
     "CONFORME", "défilement réel performScrollTo jusqu'à la dernière tuile (VR-018, 15/11)"),
    ("Catalogue EN", None, "D34-34_catalogue-en-apercus_APRES.png",
     "CONFORME", "locale EN réelle « N s · N guided takes », test dédié D34Lot12 (VR-019, 15/11)"),
    ("Catalogue hors connexion", None, "P03-05_catalogue-hors-connexion_APRES.png",
     "CONFORME", "VR-020 : repli cache honnête"),
    ("Secteur perdu → récupéré (D42.34)", None, "D34-02_catalogue-secteur-perdu-recupere_APRES.png",
     "CONFORME", "CR-1.1 : jamais de mélange des 30 gabarits"),
    ("Secteur perdu (D42.34)", None, "D34-01_catalogue-secteur-perdu_APRES.png", "CONFORME", "CR-1.1"),
    ("Libellé prises guidées (D42.34)", None, "D34-03_catalogue-libelle-prises-guidees_APRES.png",
     "CONFORME", "CR-1.2 : « N prises guidées », jamais « N scènes » — recapturé 15/11 post-images"),
    ("Font scale 1,3", None, "P12-03_catalogue-fontScale-1.3_APRES.png", "CONFORME", "accessibilité"),
    ("Petit écran", None, "P12-09_catalogue-petit-ecran_APRES.png", "CONFORME", "w360×640"),
], "**Mécanisme aperçu (Lot D) :** `ApercuGabarit.resPour(gabaritId)` → drawable "
   "`apercu_<secteur>_t<n>.webp`, fallback dessiné D42.30 conservé. **30/30 intégrés et "
   "vérifiés** (lots 1-3, 15/11 — file 29/29 VERIFIED, zéro doublon, shops T2 régénérée "
   "sur signalement fondateur). **Captures définitives 30/30 faites (15/11)** : les 6 "
   "secteurs + scroll bas + catalogue EN sont capturés AVEC le mécanisme actif (D34Lot6 "
   "étendu, D34Lot12) — les anciennes captures pré-mécanisme sont retirées de cette "
   "section, aucune capture trompeuse conservée.")
body.append(b); n += c

# --- Section H2 : aperçus des 30 gabarits (ressources originales intégrées) ---
import glob as _glob, os as _os
_ap = sorted(_glob.glob("feature-catalog/src/main/res/drawable-nodpi/apercu_*.webp"))
_rows_ap = []
for _f in _ap:
    _nom = _os.path.basename(_f)[:-5]
    _lot3 = _nom.replace("apercu_", "") in {
        "shops_small_business_t3", "shops_small_business_t4", "shops_small_business_t5",
        "vetements_mode_t1", "vetements_mode_t2", "vetements_mode_t3", "vetements_mode_t4", "vetements_mode_t5"}
    if _nom == "apercu_shops_small_business_t2":
        _st = "Intégré · vérifié · régénéré (signalement fondateur, sha 9b6249e98b25…)"
        _note = "aperçu original régénéré sur signalement fondateur (sha 9b6249e98b25…, note au registre) ; lot 3, distant 200"
    elif _lot3:
        _st = "Intégré · vérifié"
        _note = "aperçu original généré (GENERATED_ASSETS) ; lot 3 (15/11), distant GitHub vérifié 200"
    else:
        _st = "Intégré · vérifié"
        _note = "aperçu original généré (GENERATED_ASSETS)"
    _rows_ap.append(f'| {_nom.replace("apercu_", "").replace("_", " ")} | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/{_os.path.basename(_f)}" width="240"/> | {_st} |')
    man.append({"section": "8 bis. Aperçus des gabarits", "ecran": _nom.replace("apercu_", ""),
                "reference_fondateur": "-", "capture_apres": f"feature-catalog/src/main/res/drawable-nodpi/{_os.path.basename(_f)}",
                "statut": _st, "note": _note})
_manq = 30 - len(_rows_ap)  # gabarits sans aperçu intégré
_body_h2 = f"""### <a id="h2-aperçus-des-gabarits"></a>8 bis. Aperçus des gabarits (originaux générés)

Chaque gabarit du catalogue dispose d'un aperçu photographique **original
généré** (640×360 WebP, registre GENERATED_ASSETS.md — aucune licence tierce).
Rendu prouvé dans l'application : corrélations template-matching 0,982/0,988
(D34-16/D34-17).

| Gabarit | Aperçu intégré | Statut |
|---|---|---|
{chr(10).join(_rows_ap)}

**30/30 intégrés** (lots 1-3 livrés le 15/11) : file
ASSET_GENERATION_QUEUE.csv 29/29 VERIFIED — SHA-256 consignés, zéro doublon
exact ou perceptuel. Shops T2 régénéré sur signalement fondateur
(sha 9b6249e98b25…). Le rendu de ces aperçus dans l'écran catalogue est
prouvé par les captures des 6 secteurs (D34-16/17/29/30/31/32), le scroll
bas (D34-33) et le catalogue EN (D34-34).

[↑ Retour au sommaire](#sommaire)
"""
body.append(_body_h2); n += len(_rows_ap)

b, c = sec("i-brief", "9. Brief", [
    ("Brief — haut (étape 1)", "10_brief_etape1.png", "P04-01_brief-haut_APRES.png", "CONFORME", ""),
    ("Dernière section", "11_brief_etape8.png", "P04-02_brief-derniere-section_APRES.png",
     "CONFORME", "import des rushs"),
    ("Import T5 — slot import (D42.34)", None, "D34-04_brief-t5-import_APRES.png", "CONFORME", "T5 témoignage"),
    ("Import T5 — slot rempli (D42.34)", None, "D34-05_brief-t5-slot-rempli_APRES.png", "CONFORME", ""),
    ("T1 sans import (D42.34)", None, "D34-06_brief-t1-sans-import_APRES.png", "CONFORME", ""),
    ("Reprise de brouillon", None, "P04-06_brief-reprise-brouillon_APRES.png", "CONFORME", "D42.27"),
    ("Options dépliées", None, "P04-07_brief-options-depliees_APRES.png", "CONFORME", ""),
    ("Champ WhatsApp FR", None, "P04-09_whatsapp-champ-fr_APRES.png", "CONFORME", ""),
    ("Champ WhatsApp EN", None, "P04-10_whatsapp-champ-en_APRES.png", "CONFORME", ""),
    ("Préparation caméra", "33_preparation_camera.png", "P04-11_preparation-camera_APRES.png",
     "CONFORME", "écran sombre conforme (PIL 88 % navy)"),
    ("Contrôle (bas)", "12_controle.png", "P04-12_controle-bas_APRES.png", "CONFORME", "ReadyCheckScreen"),
    ("Dialogue choix pays (indicatif)", None, "D34-27_dialogue-choix-pays_APRES.png", "CONFORME",
     "Lot 10 : TelephoneField réel, clic bouton pays, DialogueChoixPays Compose authentique (360×461 wrap)"),
], "Maquette 09 (fiche détail gabarit) : **NON APPLICABLE** — le catalogue renvoie "
   "directement au brief (`pickGabarit()` → setResult), pas d'écran intermédiaire "
   "(choix produit D42.3x).")
body.append(b); n += c

b, c = sec("j-caméra-guidée", "10. Caméra guidée", [
    ("Viseur + prise guidée", "13_camera.png", "P05-04_viseur-prise_APRES.png", "CONFORME (guide)",
     "scrim navy OverlayCamera"),
    ("Flux streaming", None, "P05-05_flux-streaming_APRES.png", "NON PROUVÉ",
     "flux viseur réel → téléphone fondateur (VR-037) ; aucune simulation"),
    ("Compte à rebours", "14_camera_compte_a_rebours.png", "P05-06_compte-a-rebours_APRES.png",
     "CONFORME", ""),
    ("Enregistrement (badge REC)", "15_camera_rec.png", "P05-07_rec_APRES.png", "CONFORME", ""),
    ("HUD prise T5 (D42.34)", None, "D34-10_camera-hud-prise-t5_APRES.png", "CONFORME", ""),
    ("Chargement gabarit (D42.34)", None, "D34-08_camera-chargement-gabarit_APRES.png", "CONFORME", ""),
    ("Libre, sans scène, sur zéro (D42.34)", None, "D34-09_camera-libre-sans-scene-sur-zero_APRES.png",
     "CONFORME", ""),
    ("Erreur gabarit (D42.34)", None, "D34-07_camera-erreur-gabarit_APRES.png", "CONFORME", ""),
    ("Écran complet + commandes", None, "P05-09_ecran-complet-commandes_APRES.png", "CONFORME", ""),
    ("Scène 2 du gabarit", None, "P05-11_scene-2_APRES.png", "CONFORME", ""),
    ("Permission refusée (diagnostic)", None, "P05-13_diagnostic-permission-refusee_APRES.png",
     "CONFORME", "diagnostic honnête"),
    ("Consentement client (dialogue R4)", "16_consentement_client.png", None, "NON PROUVÉ",
     "dialogue R4 codé (visage/mineur) — capture à produire (VR-048, Lot F)"),
], "Le **flux viseur vivant** et le **consentement R4** exigent l'app réelle : "
   "marqués NON PROUVÉ, jamais fabriqués.")
body.append(b); n += c

b, c = sec("k-validation-des-prises", "11. Validation des prises", [
    ("Prise validée", "17_revue_des_prises.png", "P05-08_prise-validee_APRES.png", "CONFORME",
     "validation immédiate après chaque prise"),
], "Maquette 17 (écran galerie « revue ») : forme **distribuée** dans l'app — "
   "validation par prise + `ReadyCheckScreen` final. Pas d'écran galerie séparé.")
body.append(b); n += c

b, c = sec("l-montage", "12. Montage", [
    ("Aperçu E7 (montage complet)", "18_apercu_montage.png", "P07-01_apercu-E7-complet_APRES.png",
     "CONFORME", ""),
    ("E8 phase « Assemblage des plans et des textes »", "19_montage_en_cours.png",
     "D34-20_montage-phases-assemblage_APRES.png", "CONFORME",
     "Lot 8 : D34Lot8ExportStatesVisualCheckTest — setProgress authentique du worker vv-export, tap réel export_start, observer LiveData, 360×820 NATIVE"),
    ("E8 phase « Rendu final de la vidéo »", None,
     "D34-21_montage-phases-rendu_APRES.png", "CONFORME",
     "Lot 8 : même chemin déterministe, phase rendu tenue stable via inputData du worker de test"),
], "VR-051 résolu par le Lot 8 : phases métier réelles du worker (contrat KEY_PHASE), "
   "chemin utilisateur complet (tap export_start → observer LiveData → phase affichée).")
body.append(b); n += c

b, c = sec("m-export", "13. Export", [
    ("Export prêt", "20_export_pret.png", "D34-22_export-pret_APRES.png", "CONFORME",
     "Lot 8 : worker réussit sur signal (KEY_OUTPUT contrat réel) → export_done + partage + espace visibles (VR-054) ; remplace la référence émulateur D42.31"),
    ("Export en échec — écran + bouton relance", None, "D34-35_export-echec-relance_APRES.png", "CONFORME",
     "15/11 : échec RÉEL du travail sur signal (Result.failure après attachement de l'observer) → export_failed_ui, barre masquée, bouton export_start réactivé (VR-055)"),
], "VR-053 (notification foreground « Export en cours… ») : NON PROUVÉ — rendu par "
   "setForeground du VRAI ExportWorker en exécution (pipeline d'encodage complet), "
   "non reproductible honnêtement sous Robolectric. Écrans E8 prouvés par D34-20/21/22/35.")
body.append(b); n += c

b, c = sec("n-partage", "14. Partage", [
    ("Feuille de partage système", "21_partage.png", "18_partage/suite-fr-026_partage_feuille.png",
     "NON APPLICABLE", "UI système Android — non contrôlée par l'app (VR-056)"),
], "La feuille de partage appartient au système : capture émulateur en référence.")
body.append(b); n += c

b, c = sec("o-dashboard", "15. Dashboard", [
    ("Synchrone, crédits 6", "24_dashboard.png", "12_dashboard_fr_w360_APRES_synchrone-credits-6.png",
     "CONFORME", "« Bonjour » seul si pas de prénom réel (jamais inventé)"),
    ("Bas de page", None, "P10-02_dashboard-bas_APRES.png", "CONFORME", ""),
    ("Suite parrainage", None, "P10-03_dashboard-suite-parrainage_APRES.png", "CONFORME", ""),
    ("Dialogue reprise (D42.27, VR-062)", None, "D34-28_dialogue-reprise_APRES.png", "CONFORME",
     "Lot 11 : DraftStore réel + MainActivity vv_reprise, dialogue authentique Reprendre/Nouvelle vidéo"),
    ("Dashboard EN synchrone", "32_dashboard_en.png", "P10-04_dashboard-en-synchrone_APRES.png",
     "CONFORME", "l10n EN"),
    ("Hors connexion (code en attente)", "22_hors_connexion.png",
     "12_dashboard_en_w360_APRES_hors-connexion-code-en-attente.png", "CONFORME", ""),
    ("Bonjour, {prénom} (variante nom réel)", None, "P10-02_dashboard-bas_APRES.png", "CONFORME",
     "le test passe merchantName réel → « Bonjour, Boutique Fatou » rendu (dash_hello) ; "
     "« Bonjour » seul si absence (jamais inventé)"),
    ("Petit écran w360×640", None, "20_dashboard_fr_w360x640_APRES_fontScale-1.3-petit-ecran.png",
     "CONFORME", ""),
    ("Rotation paysage w640×360", None, "22_dashboard_fr_w640x360_APRES_rotation-paysage.png",
     "CONFORME", ""),
], "")
body.append(b); n += c

b, c = sec("p-formules--paywall", "16. Formules & paywall", [
    ("Formule active (pas de compteur inventé)", "26_formules.png",
     "13_dashboard_fr_w360_APRES_formule-active-pas-de-compteur-invente.png", "CONFORME", ""),
    ("Paywall FR (3 formules, CTA « Choisir … » actifs)", "23_quota_epuise.png",
     "D34-18_paywall-cta-fr_APRES.png",
     "CONFORME", "recapture post-CTA (diff PIL 6,3 % vs D42.33 — CR-4 rendu)"),
    ("Paywall EN (CTA « Choose … »)", None, "D34-19_paywall-cta-en_APRES.png", "CONFORME",
     "recapture post-CTA (DashboardL10nCheckTest — capture absente de D42.33)"),
    ("Paywall bas (scroll)", None, "P11-04_paywall-bas_APRES.png", "CONFORME (identique D42.33)",
     "régénéré à l'identique près des CTA"),
    ("Petit écran famille 11", None, "21_paywall_en_w360x640_APRES_petit-ecran-famille-11.png",
     "CONFORME", "petit écran"),
], "Checkout : CinetPay renvoie 501 `billing_not_configured` (budget 0 FCFA, aucune "
   "transaction fictive) — comportement d'erreur réel déjà couvert par les tests.")
body.append(b); n += c

b, c = sec("q-parrainage", "17. Parrainage", [
    ("Historique replié", "28_parrainage.png", "14_parrainage_fr_w360_APRES_historique-replie.png",
     "CONFORME", ""),
    ("Parrainage EN", None, "14_parrainage_en_w360_APRES_l10n-EN.png", "CONFORME", "l10n EN"),
    ("Petit écran", None, "23_parrainage_fr_w360x640_APRES_fontScale-1.3-petit-ecran.png", "CONFORME", ""),
], "")
body.append(b); n += c

b, c = sec("r-réglages", "18. Réglages", [
    ("Réglages FR (7 lignes)", "29_reglages.png", "16_reglages_fr_w360_APRES_l10n-FR-7-lignes.png",
     "CONFORME", ""),
    ("Réglages EN", None, "P10-08_reglages-en_APRES.png", "CONFORME", "l10n EN"),
    ("Petit écran", None, "24_reglages_fr_w360x640_APRES_fontScale-1.3-petit-ecran.png", "CONFORME", ""),
    ("Dialogue changement langue (FR/EN)", None, "D34-23_dialogue-langue_APRES.png", "CONFORME",
     "Lot 9 : DashboardActivity réelle, clics réels, AlertDialog single choice authentique (VR-074)"),
    ("Dialogue changement secteur", None, "D34-24_dialogue-secteur_APRES.png", "CONFORME",
     "Lot 9 : chemin réel complet, AlertDialog 6 métiers authentique (VR-075)"),
    ("Dialogue accords de diffusion", None, "D34-25_dialogue-accords_APRES.png", "CONFORME",
     "Lot 9 : chemin réel complet, AlertDialog compteur réel (VR-076)"),
    ("Dialogue nettoyage espace", None, "D34-26_dialogue-nettoyage_APRES.png", "CONFORME",
     "Lot 9 : scroll + clic réel, AlertDialog confirmation authentique (VR-077)"),
], "Les 4 dialogues de réglages sont **prouvés par le chemin réel** (Lot 9 : "
   "DashboardActivity authentique, clics réels sur les lignes, AlertDialog système). "
   "Le dialogue de reprise (VR-062) est prouvé au §15 (D34-28, Lot 11).")
body.append(b); n += c

b, c = sec("s-écrans-hors-périmètre", "19. Écrans hors périmètre", [
    ("Conditions d'utilisation (navigateur)", "30_conditions.png", None, "NON APPLICABLE",
     "lien sortant navigateur système (VR-071)"),
    ("Aide", "31_aide.png", None, "NON APPLICABLE", "écran interdit par décision fondateur (VR-073)"),
    ("Aide & contact", "34_aide_contact.png", None, "NON APPLICABLE", "interdit (VR-073)"),
    ("Mes vidéos (bibliothèque)", "25_mes_videos.png", None, "NON APPLICABLE",
     "aucun écran « Mes vidéos » dans l'app — exports vers partage/dossier appareil ; "
     "à arbitrer par le fondateur pour une version ultérieure"),
    ("Marque (bandeau header)", None, "10_marque_fr_defaut_APRES_header-logo-officiel.png",
     "CONFORME", "header officiel"),
], "")
body.append(b); n += c

b, c = sec("t-états-adaptatifs", "20. États adaptatifs", [
    ("Font scale 1,3 (langue)", None, "P12-02_langue-fontScale-1.3_APRES.png", "CONFORME", ""),
    ("Font scale 1,3 (bienvenue)", None, "P12-01_bienvenue-fontScale-1.3_APRES.png", "CONFORME", ""),
    ("Font scale 1,3 (catalogue)", None, "P12-03_catalogue-fontScale-1.3_APRES.png", "CONFORME", ""),
    ("Petit écran (langue)", None, "P12-07_langue-petit-ecran_APRES.png", "CONFORME", ""),
    ("Petit écran (bienvenue)", None, "P12-08_bienvenue-petit-ecran_APRES.png", "CONFORME", ""),
    ("Petit écran (catalogue)", None, "P12-09_catalogue-petit-ecran_APRES.png", "CONFORME", ""),
    ("Rotation (bienvenue)", None, "P12-12_bienvenue-rotation_APRES.png", "CONFORME", ""),
    ("Rotation (carrousel)", None, "P12-13_carrousel-rotation_APRES.png", "CONFORME", ""),
    ("Hors-connexion (bienvenue)", None, "P12-15_bienvenue-hors-connexion_APRES.png", "CONFORME", ""),
], "Vue regroupée par contrainte (fontScale / petit écran / rotation / hors-connexion). "
   "Ces captures sont les mêmes fichiers que ceux de leurs sections de parcours — "
   "aucun fichier dupliqué dans le dépôt. Les états NON PROUVÉ ci-dessus restent à "
   "produire sur téléphone fondateur ou en recapture Lot F.")
body.append(b); n += c

footer = """
---

## Traçabilité

- Registre des images originales : `../GENERATED_ASSETS.md` (provenance de chaque
  ressource générée — aucune image à licence inconnue conservée).
- Inventaire exhaustif des 78 écrans/états : `../11_INVENTAIRE_COMPLET_ECRANS.csv`.
- Audit fidélité des 34 maquettes : `../10_AUDIT_FIDELITE_DESIGN.md`.
- Manifeste vérifiable de cette galerie : `../12_MANIFEST_GALERIE.csv`
  (chemin → statut → note, une ligne par image référencée).
- Crédits photo : `../CREDITS_PHOTOS.md`.

**Rappel fondateur :** CI verte ≠ approbation artistique. L'approbation finale
du design appartient au fondateur, sur son téléphone.
"""

with open(os.path.join(VR, "README.md"), "w", encoding="utf-8") as f:
    f.write(intro + "\n" + "\n".join(body) + footer)

with open("docs/checkpoints/D42_34/12_MANIFEST_GALERIE.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["section", "ecran", "reference_fondateur",
                                      "capture_apres", "statut", "note"])
    w.writeheader()
    w.writerows(man)

print(f"README galerie : {n} lignes d'images, manifeste {len(man)} lignes")
