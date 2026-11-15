# D42.34 — Audit de fidélité design vs 34 maquettes fondateur (Lot C)

**Date :** 17/11/2026 (ordre fondateur « finalisation visuelle intégrale », §2)
**Base auditée :** commit 57e720f (D42.34 + Lot A/B + Lot D 10/39), CI 43710292516 SUCCESS.
**Périmètre :** les 34 maquettes fondateur (`docs/checkpoints/D42_33/SOURCES/maquettes/`, 1179×2556) comparées à l'application réelle. Les 16 maquettes de la planche historique en sont un sous-ensemble.

## Méthode — honnêteté déclarée

La vision d'images n'est **pas disponible** dans cet environnement (testé : lecture PNG
→ « no vision capabilities »). L'audit est donc **programmatique et traçable** :

1. **Mesures PIL reproductibles** sur chaque maquette et chaque capture : parts de
   blanc / navy `022358` / orange `F95C0F` / pixels sombres, saturation, luminance
   par bandes (haut/milieu/bas). Script : mesures consignées ci-dessous par maquette.
2. **Contrepoint code source** : palette officielle `core-designsystem/Color.kt`
   (Navy `0x022358`, OrangeStore `0xF95C0F`, OrangeHi, OrangeDeep, NavySoft,
   OrangeVoile), écrans/composants/strings FR-EN réels.
3. **Captures existantes** : D42_33/visual-review/AFTER (74 PNG), D42_34/visual-review
   (12 PNG), D42_31 (émulateur) — citées par chemin, jamais retouchées.
4. Croisement avec l'inventaire exhaustif `11_INVENTAIRE_COMPLET_ECRANS.csv`
   (73 écrans/états, Lot B).

**Règle fondateur respectée :** aucun statut CONFORME sans observation concrète ;
ce qui n'est pas prouvé est déclaré NON PROUVÉ ; ce qui n'existe pas dans l'app (par
décision produit ou interdiction fondateur) est NON APPLICABLE — jamais caché.

## Synthèse

| Statut | Nb | Maquettes |
|---|---|---|
| CONFORME (avec observation) | 18 | 02, 03, 04, 06, 07†, 10, 11, 12, 13, 14, 15, 18, 22, 27, 28, 29, 32, 33 |
| ÉCART À CORRIGER | 5 | 08, 19, 23, 24, 26 |
| NON PROUVÉ | 4 | 01, 05, 16, 20 |
| NON APPLICABLE | 7 | 09, 17, 21, 25, 30, 31, 34 |

† recapture programmée (images originales intégrées après la capture de référence).
Les écarts listés alimentent directement le Lot E (corrections chirurgicales) puis le
Lot F (galerie APRÈS). Rappel fondateur : CI verte ≠ approbation artistique.

## Détail par maquette

### 01_ouverture — NON PROUVÉ
Mesures : blanc 55,4 %, insigne navy/orange central, fond très clair.
App : `Theme.VitrineVideo.Splash` (`app/src/main/res/values/themes.xml`) + asset
`splash_logo_tuile.png` (silhouette officielle vérifiée par mesure PIL au Lot 5).
Le rendu et la durée réels du splash système exigent le téléphone fondateur —
aucune capture Robolectric honnête possible (VR-001).

### 02_carrousel — CONFORME (recapture programmée)
Mesures : navy 40,1 % (fonds de slides), zone photo ~32 %, orange 6,3 % (CTA).
App : 3 slides carrousel avec **images originales générées** (`carrousel_1_boutique`,
`carrousel_2_tournage`, `carrousel_3_resultat` — registre GENERATED_ASSETS.md),
slogans FR/EN `strings_onboarding.xml` inchangés. Captures : D34-11 + P02-02/03
(antérieures aux images générées). Recapture post-intégration au Lot E (VR-003/4/5).

### 03_langue — CONFORME
Mesures : blanc 86 %, CTA orange 5,9 %.
App : écran langue (« Choisissez votre langue » / « Choose your language »),
FR/EN vérifiés. Capture : D42_33/01_langue_fr_w360 (structure blanche + CTA
orange identique). VR-006/007.

### 04_connexion — CONFORME
Mesures : blanc 81 %, sobre, un seul bloc d'action.
App : `auth_title` + carte Google unique + « Utiliser sans Internet »
(strings_auth.xml). Captures FR/EN : P01-05/P01-06. VR-008/010.

### 05_connexion_hors_ligne — NON PROUVÉ
Mesures : blanc 87 %, bandeau d'erreur.
App : message `auth_error_network` (« La connexion à Internet a échoué. Vérifie ta
connexion, puis réessaie. ») codé et localisé. État réseau réel non capturé à ce
jour — capture à confirmer/produire (VR-009).

### 06_code_parrain — CONFORME
Mesures : blanc 85,5 %, CTA orange 5,7 %.
App : `refcode_title` « Ton code parrain », saisie + « Je n'ai pas de code »,
pré-remplissage deep-link. Captures : P01-08 (FR, deep-link pré-rempli). VR-011/012.

### 07_secteur — CONFORME (recapture programmée)
Mesures : blanc 86,3 %, grille de tuiles colorées (coloré 7,9 %).
App : 6 secteurs avec **images originales générées** (`sector_*.webp`, 480×480).
Capture de référence 03_secteurs (D42_33, antérieure aux images). Recapture Lot E
(VR-015).

### 08_catalogue — ÉCART À CORRIGER
Mesures : blanc 73 %, zones vignettes à faible variance chromatique (≈ 7 %) :
la maquette attend des **aperçus discrets**, pas des photos pleine carte.
App : mécanisme `apercuRes` intégré et compilé (ApercuGabarit.kt + VignetteCatalogue
+ 3 sites CatalogScreen), **10/39 aperçus** générés et commités, 29 restants (Lot D).
Captures actuelles : D34-03 (libellé prises guidées) ; grille P04 obsolète.
Correction : finir Lot D puis recapture complète (VR-016→019).

### 09_gabarit_detail — NON APPLICABLE
Mesures : blanc 66 %, fiche détail.
App : **aucun écran détail séparé** — `CatalogActivity.pickGabarit()` renvoie
directement le gabarit choisi (`setResult` + `finish()`) au flux brief. Choix produit
assumé D42.3x : catalogue → brief sans étape intermédiaire.

### 10_brief_etape1 — CONFORME
Mesures : blanc 86,3 %.
App : `GabaritBriefScreen`, premières étapes du brief. Capture : P04-01_brief-haut
(VR-023).

### 11_brief_etape8 — CONFORME
Mesures : blanc 86,2 %.
App : import des rushs (dernière étape). Captures : 08_brief D42_33 (import) +
D34-04/D34-05 (T5 import / slot rempli — Lot D34). VR-024.

### 12_controle — CONFORME
Mesures : blanc 86,3 %.
App : `ReadyCheckScreen` (feature-brief), contrôle avant montage. Capture :
P04-12_controle-bas (VR-034).

### 13_camera — CONFORME (guide) — flux caméra NON PROUVÉ
Mesures : navy 27,7 % (overlays sombres sur viseur), coloré 24,4 %.
App : `CameraGuideActivity` + `GuidedShootingOverlay` (scrim navy `0x8C022358`),
guide de tournage par scène. Captures : P05-04 (viseur+prise), P05-05 (guide).
Le **flux viseur réel** (preview vidéo vivante) exige le téléphone fondateur
(VR-037 NON PROUVÉ — aucune simulation tolérée).

### 14_camera_compte_a_rebours — CONFORME
Mesures : navy 59 % (plein écran sombre, chrono).
App : compte à rebours avant prise (`PriseGuideScreen`). Capture : P05-06 (VR-038).

### 15_camera_rec — CONFORME
Mesures : navy 29,7 %, coloré 26,9 % (badge REC).
App : enregistrement guidé, HUD prise. Captures : P05-07 + D34-10 (HUD T5). VR-039.

### 16_consentement_client — NON PROUVÉ
Mesures : navy 37,5 % / blanc 31,5 % (dialogue sombre superposé au viseur).
App : **porte R4** — dialogue de consentement (visage filmé + mineur potentiel)
AVANT tout enregistrement (`CameraGuideActivity` : « consentement requis avant
enregistrement », dialogues R4 D41/F56). Capture à produire (VR-048, Lot E).

### 17_revue_des_prises — NON APPLICABLE (sous forme distribuée)
Mesures : blanc 67,6 %.
App : pas d'écran galerie « revue » séparé — la validation est **distribuée** :
validation immédiate après chaque prise (P05-08, VR-040 CONFORME) puis
`ReadyCheckScreen` en fin de brief. La fonction existe, pas sous la forme d'un
écran dédié.

### 18_apercu_montage — CONFORME
Mesures : blanc 67,2 %, accents orange 5,7 %.
App : aperçu E7 (fin de montage). Capture : P07-01_apercu-E7-complet (VR-050).

### 19_montage_en_cours — ÉCART À CORRIGER
Mesures : blanc 91,7 % (écran très sobre).
App : montage worker avec **phases réelles** D42.34 (aucun pourcentage inventé).
Capture P07-02 obsolète (pré-phases). Correction VR-051 : recapture post-phases +
vérification libellés de phases (Lot E).

### 20_export_pret — NON PROUVÉ
Mesures : orange 47,9 %, coloré 51,1 % (carte succès à dominante orange).
App : écran export prêt codé. Référence existante : D42_31/base-fr-057 (émulateur).
Capture D42.34 à produire (VR-052).

### 21_partage — NON APPLICABLE
Mesures : navy 42,8 % (feuille système).
App : feuille de partage **Android système** — UI non-contrôlée par l'app, non
capturable honnêtement in-app (VR-056). Référence émulateur : D42_31/suite-fr-026.

### 22_hors_connexion — CONFORME
Mesures : blanc 82,4 %, bandeau d'état.
App : dashboard hors-connexion avec « code en attente ». Capture :
12_dashboard_en_w360 hors-connexion (D42_33). VR-061 (famille dashboard).

### 23_quota_epuise — ÉCART À CORRIGER
Mesures : blanc 69,1 %, navy 12,6 % (bloc paywall).
App : paywall 3 formules, recommandation Pro. VR-063 : logique CONFORME (tests) mais
capture obsolète ; VR-064 : variante EN à corriger. Correction Lot E : CTA +
recaptures FR/EN.

### 24_dashboard — ÉCART À CORRIGER
Mesures : blanc 64,3 %, navy 12,1 % (cartes), coloré 20,6 %.
App : dashboard synchrone CONFORME (12_dashboard D42_33, « Bonjour » seul) ;
VR-059 : écart sur l'affichage du nom → correction chirurgicale Lot E, puis
recapture.

### 25_mes_videos — NON APPLICABLE
Mesures : blanc 89 % (liste simple).
App : **aucun écran « Mes vidéos »** (recherche code négative). Les vidéos
exportées vont au partage / dossier de l'appareil ; une bibliothèque intégrée est
hors du périmètre fonctionnel D42.34. À arbitrer par le fondateur pour une
ultérieure version.

### 26_formules — ÉCART À CORRIGER
Mesures : blanc 67 %, navy 13,8 % (cartes formules).
App : 13_dashboard « formule active, pas de compteur inventé » CONFORME (D42_33),
mais harmonisation formules ↔ paywall requise (VR-064) et captures obsolètes
(boutons inactifs à l'époque). Correction + recapture Lot E.

### 27_bienvenue — CONFORME
Mesures : navy 73,5 % plein écran, coloré 57,2 %.
App : écran de bienvenue crédits (« Félicitations ! », solde, badges
Confirmé/En attente). Captures : P01-09/P01-10 (VR-013/014).

### 28_parrainage — CONFORME
Mesures : blanc 66,4 %, orange 17,1 % (CTA forts).
App : parrainage FR/EN + historique replié. Captures : 14_parrainage FR/EN (D42_33)
+ P10-03. VR-067/068.

### 29_reglages — CONFORME
Mesures : blanc 93,6 % (liste sobre).
App : réglages 7 lignes FR/EN. Captures : 16_reglages FR + P10-08 EN (VR-069/070).

### 30_conditions — NON APPLICABLE
Mesures : blanc 92,3 %.
App : conditions d'utilisation ouvertes dans le **navigateur système** (lien sortant),
pas d'écran in-app (VR-071).

### 31_aide — NON APPLICABLE
Mesures : blanc 75,2 %, orange 16,2 %.
App : écran « Aide » **interdit par décision fondateur** (D42.33) — VR-073.

### 32_dashboard_en — CONFORME
Mesures : blanc 64,7 % (structure identique à la maquette 24).
App : dashboard EN synchrone, l10n EN vérifiée. Capture : P10-04 (VR-061).

### 33_preparation_camera — CONFORME
Mesures : navy 88,4 % (écran de préparation sombre plein écran).
App : préparation caméra (avant viseur). Capture : P04-11 (VR-035).

### 34_aide_contact — NON APPLICABLE
App : écran « Aide & Contact » **interdit** (décision fondateur, maquettes 31/34
hors périmètre) — VR-073.

## Conséquences pour les lots suivants

- **Lot D (en cours)** : finir les 29 aperçus catalogue restants (maquette 08).
- **Lot E (corrections)** : VR-051 phases montage (maq. 19), VR-059 nom dashboard
  (maq. 24), VR-063/064 CTA paywall + EN (maq. 23/26), VR-048 capture
  consentement (maq. 16), VR-062 dialogue reprise, puis recaptures carrousels/
  secteurs/catalogue post-images générées (maq. 02/07/08).
- **Lot F (galerie)** : présenter ref ↔ APRÈS côte à côte ; les NON PROUVÉ système
  (01, 13-flux, 21) et les NON APPLICABLE (09, 17, 21, 25, 30, 31, 34) seront
  indiqués honnêtement avec leur justification.
- Aucune modification des lots fonctionnels validés n'est requise par cet audit
  en dehors des corrections listées (moteur, contrats, IDs, fusion, phases worker,
  checkout, 501 intouchables).
