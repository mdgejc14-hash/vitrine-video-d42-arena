# D42.32 — RAPPORT FINAL (clôture Phase A + Phase B)

> Livraison acceptée comme candidate à l'approbation visuelle. Ce rapport
> clôture la mission : bilan, preuves, réserves. **Aucune modification
> applicative n'accompagne ce document.**

## 1. Identité de la livraison

| | |
|---|---|
| **Candidat logiciel (code)** | `a799c50` — dernier commit touchant l'app et ses outils |
| **HEAD final (galerie + clôture)** | `b5a1462` + commit de clôture documentaire (docs seuls) |
| **Avant (référence historique)** | RC15 `d42.30-rc15`, release 442574529, SHA-256 `fd28ffc75cc7ec22c0edd6dcf2c63b1d9fab31469505ede079ddb3aeb3b78936` — **IMMUEBLE** |
| **Statut RC16** | **AUCUNE construite ni publiée** — condition §12 : approbation visuelle d'abord |
| **Budget** | 0 FCFA (émulateurs GitHub Actions uniquement) · CinetPay reporté · 600 compositions audio intactes |

## 2. Ce qui a été corrigé (Phase A — 10 lots + 3 chantiers directive)

| # | Correction | Commit | Preuve visuelle |
|---|---|---|---|
| 1 | Catalogue : secteur choisi ⇒ SES 5 gabarits, zéro filtre intégré | 90f1ac5 | `captures/07_catalogue/` |
| 2 | Catalogue : cartes premium, hiérarchie claire | 095d645 | `captures/07_catalogue/catalogue_haut_fr.png` |
| 3 | Caméra : diagnostic différentiel 4 sources (OUTIL, aucune modif CameraX) | b0a988b | `camera-preuves/` |
| 4 | Localisation FR/EN complète (parcours + 30 gabarits) | 316bb80 | run EN intégral 50 captures |
| 5 | Dashboard : en-tête pro, carte crédits, sync honnête | f07ae5c | `captures/17_historique/dashboard_fr.png` |
| 6 | Parrainage : code visible, copier/partager, paliers | f07ae5c | `captures/04_parrainage/` |
| 7 | Tarifs : 3 formules exactes 500/3000/7500, 501 honnête | e47262a | `captures/05_credits/paywall_fr.png` |
| 8 | Formulaires : WhatsApp E.164, prix stable, tutoiement, ImeAction | 6d1ad6a | `captures/10_formulaires/whatsapp_clavier_fr.png` |
| 9 | Bienvenue : crédits confirmés, bouton épinglé 56 dp | d88dbbf | `captures/05_credits/credits_bienvenue_fr.png` |
| 10 | Design system : PiedContinuer 52 dp, barre d'action standard | 95d0734 (ex-1b42df4) | `captures/09_brief/brief_final_fr.png` |
| §4 | **Quota Pro 90/30 j RÉELLEMENT appliqué serveur** (attribution serveur, contrôle atomique D1, idempotence event_id, 403 empreinte D41, Pass 6 / Boutique 200 / cloud 1-5-20, périodes glissantes) | ae64aa1 (ex-79e4b14) | quota 21/21 en CI + auth-local 22/22 + preuve Room |
| §5 | Récupération réelle des artefacts caméra (v2→v4, RCA sur 4 runs) | 905a4f6 → 163e215 | `camera-preuves/` (2 rapports, 10 PNG, **2 MP4 réels**) |
| §6 | Harmonisation DS : token AmbreAlerte, OrangeStore, déviations justifiées documentées | ac29fdd (ex-e7ffe5b) | `10_DESIGN_SYSTEM.md` §3bis |

## 3. Vérification non-régression (§9)

- **Candidat code `a799c50`** : android-ci **SUCCESS** · e2e-lab **SUCCESS
  15/15** · visual-gallery-d32 **SUCCESS 3/3**.
- **HEAD galerie `b5a1462`** (docs seuls) : android-ci **SUCCESS** · e2e-lab
  **SUCCESS 15/15** — le laboratoire a revalidé le HEAD exact livré.
- Détail par job et identifiants d'artefacts : [visual-review/RUNS.md](visual-review/RUNS.md).
- API Security CI : SUCCESS sur `2a9ad15` (dernier commit touchant `src/`) —
  inchangé depuis (aucun commit ultérieur ne touche le worker).

## 4. Galerie avant/après (§8) — la pièce à conviction

`docs/checkpoints/D42_32/visual-review/` — **produit réellement exécuté sur le
candidat, aucune maquette, aucune image générée, aucune capture retouchée** :

- **README illustré** : 80 images embarquées, 21 sections miroir de la galerie
  D42.31 (avant RC15), liens avant ↔ après pour les 12 corrections.
- **Couverture** : accueil, langue, inscription, secteurs, catalogue, 30
  gabarits (inventaire), brief (8 étapes), formulaires (clavier ouvert),
  vérification, caméra, prises (compte à rebours, REC, avant/arrière,
  refaire), montage, export, historique/dashboard, parrainage, tarifs,
  partage, réglages, hors connexion, petit écran, police 130 %, paysage, EN.
- **Preuves spéciales** : `export-tire-candidat.mp4` (4,4 Mo — vidéo
  réellement exportée par le candidat, musique BGM automatique incluse) ·
  `preuve_room_export_journal.db` (base Room tirée du device : export_journal
  CONFIRMED, balanceAfter=2 — le crédit bienvenue a réellement été débité) ·
  4 dumps XML des écrans FLAG_SECURE.
- **Vérification d'intégrité faite** : 167 liens locaux — 0 manquant ;
  manifeste 86 entrées — 0 fichier absent ; sections « avant » valides.

## 5. Bilan caméra (§5) — conclusion démontrée

Quatre sources mesurées × 2 modes sur émulateur (run 43582492529, v4) :
ImageAnalysis 30-31 frames YUV_420_888 · PreviewView rendu mesuré · VideoCapture
MP4 réel ~2 s (443/430 Ko, 720×1280) · MP4 décodé 3 frames. **Écart de
luminance Preview/MP4 : 0,1 (performance) / 1,0 (compatible)** — le rendu
« coloré » est la **scène synthétique de la caméra virtuelle de l'AVD**, pas
un défaut CameraX. **Aucune modification CameraX appliquée** (RCA exigée par
la directive, jamais démontrée contre l'app). Historique complet des 4 runs
et RCA : [06_CAMERA_DIAGNOSTIC.md](06_CAMERA_DIAGNOSTIC.md).

## 6. Réserves explicites portées au fondateur

1. **Capteur physique** : TOUTES les captures caméra de la galerie sont
   ÉMULÉES (AVD). La validation du vrai capteur se fait par le fondateur sur
   son téléphone, après approbation (Phase C). Le diagnostic est prêt à
   tourner sur appareil physique (`emulateur=false` dans le rapport).
2. **FLAG_SECURE** : les écrans d'aperçu/export/partage sont protégés par
   conception (protection produit) — captures pixel impossibles, **jamais
   contournées** ; preuves par dumps XML + MP4 réellement exporté.
3. **Paiement** : le paiement en ligne reste **501 billing_not_configured**
   (honnête, aucun paiement simulé, aucune transaction réelle). CinetPay
   reporté. Le bouton d'achat est inactif avec mention explicite.
4. **PNG vides sous charge swiftshader** : listés dans les gaps du README,
   jamais présentés comme captures.
5. **Quota serveur en production** : le contrôle est dans le Worker du dépôt ;
   son déploiement effectif sur l'API de production suivra le processus de
   deploy existant lors de la Phase C (aucun déploiement fait sans accord).

## 7. La porte (§12)

La livraison D42.32 Phase A/B est **candidate à l'approbation visuelle**.
Le fondateur review la galerie :

👉 **[visual-review/README.md](visual-review/README.md)**

- **Approbation** ⇒ Phase C : APK signée officiellement (cert existant),
  SHA-256 consigné, E2E sur l'APK exacte, release GitHub, test capteur
  physique par le fondateur.
- **Refus** ⇒ corrections ciblées, nouvelle galerie, nouvelle passe.

RC15 reste la référence tant que la porte n'est pas passée.
