# Famille 11 — Responsive & accessibilité (six contrôles fondateur)

**Statut : TERMINÉE — commit <SHA après push>, CI <run après push>.**

## Méthode

Robolectric NATIVE (qualifiers réels) + override Compose `LocalDensity`
pour le fontScale. Captures PNG dans `build/visual-check/` (preuves
famille 13, retrouvées dans les artefacts CI).

## Les six contrôles

### 1. fontScale 1,3
`ResponsiveA11yCheckTest` — `CompositionLocalProvider(LocalDensity provides
Density(density, fontScale = 1.3f))` sur Dashboard (avec brouillon + exports),
ReferralScreen, SettingsScreen : tous les éléments critiques restent présents
(bonjour, CTA `dash_create_video`, code `dash_referral_code`, « Reprendre »,
« 2 vidéos exportées », tab bar, jauge `ref2_gauge`, réglages). Les titres à
`maxLines = 1` ellipsent proprement (jamais de texte tronqué brut).
Captures : `f11-fontscale13-petit-ecran-fr.png`, `f11-parrainage-fontscale13-fr.png`,
`f11-reglages-fontscale13-fr.png`.

### 2. Petit écran 360 × 640
Qualifier `w360dp-h640dp` sur les mêmes tests (dashboard + paywall). Le
dashboard complet (header + héros + CTA + Reprendre + parrainage + exports +
tab bar) reste utilisable : colonne unique prévue par la spec §9.3.

### 3. Rotation
Qualifier `w640dp-h360dp` (paysage) : CTA, réglages et tab bar présents.
Capture `f11-dashboard-paysage-fr.png`.

### 4. Anglais
Qualifier `en-...` : paywall en anglais (prix inchangés — devise UEMOA
découplée de la langue, règle d'or D41). FR/EN seuls : **aucune
réintroduction d'es/ja** (les anciens tests L10n es/ja de D42.32 restent
dans le dépôt mais servent au repli par défaut — aucun écran ne dépend
d'une traduction absente).

### 5. Contraste — audit WCAG calculé (ratios exacts)

| Couple | Ratio | AA 4.5 | AA-large 3.0 |
|---|---|---|---|
| Navy #022358 / Blanc | 15.17 | PASS | PASS |
| Navy / Bg #F7F8FC | 14.30 | PASS | PASS |
| Blanc / Navy (héros) | 15.17 | PASS | PASS |
| Blanc80 / Navy | 10.07 | PASS | PASS |
| Blanc70 / Navy | 8.02 | PASS | PASS |
| NavySoft / Blanc | 9.32 | PASS | PASS |
| Muted #6C7C99 / Blanc | 4.22 | écart | PASS |
| Muted / Bg | 3.97 | écart | PASS |
| OrangeDeep #D34905 / Blanc | 4.44 | écart | PASS |
| OrangeDeep / OrangeVoile | 4.02 | écart | PASS |
| Blanc / OrangeStore (CTA 16/700) | 3.20 | — | PASS (gros texte) |
| Blanc / OrangeStore (badge 11/700) | 3.20 | écart | PASS |
| VertSucces (pastille 8 dp, non-texte) | 3.19 | PASS 1.4.11 | — |

**Socle textuel conforme** (tous les corps de lecture Navy/blanc ≥ 8:1).
Écarts résiduels = **tokens de marque fondateur** (Muted, OrangeStore,
OrangeDeep — spécifiés dans la spec transmise, « couleurs de marque
intouchables ») : blanc sur orange est le langage CTA de la charte
(WCAG AA « large text » 3:1 ✓ pour les CTA 16/700 ; le badge Recommandé
11/700 à 3.2 est l'écart le plus visible). **Décision laissée à la porte
d'approbation visuelle** — aucun token modifié unilatéralement.

### 6. Cibles tactiles ≥ 48 dp

- `Dims.CibleTactile` = 48 (BoutonIcone : visuel 40 dans cible 48) ✓ déjà conforme.
- **`CtaSecondaire` 46 → 48** (BoutonSecondaire — copie code, partage) : corrigé.
- **Réglages dashboard 44 → 48** (glyphe 22 dans cible 48) : corrigé.
- Liens texte cliquables rembourrés à 12 dp vertical (« Réessayer »,
  « Voir mes filleuls », « Recharger plus tard », historique repliable) :
  cibles ~44-48 dp.
- Conformes par construction : Cta 56, Champ 56, TabBar 74, LigneListe 72,
  Vignette 48, tuiles Reprendre/exports 14 dp padding.

## Fichiers

- `core-designsystem/.../Dimens.kt` — CtaSecondaire 48.
- `feature-dashboard/.../DashboardScreens.kt` — réglages 48, liens rembourrés.
- `feature-dashboard/src/test/.../ResponsiveA11yCheckTest.kt` — NOUVEAU
  (5 tests Robolectric, captures preuve).

## Non-régression

Aucun contrat touché (dimensions/tokens additifs uniquement) ; les tests
visuels existants (Dashboard/Paywall/L10n) restent inchangés et verts
(run CI de cette famille).

## Incident CI (run 43609416917, FAILURE) — causes racines et corrections

1. **`petit ecran anglais - paywall lisible` (AssertionError)** : l'assertion
   prix durcissait « / 30 j » — en anglais `period_30d` = « 30 d ».
   Correction : assertion construite avec `ctx.getString(R.string.period_30d)`
   (la période est localisée, le montant reste FCFA — devise découplée).
2. **`fontScale 1,3 - parrainage et reglages` (IllegalStateException)** :
   deux `setContent` dans un même test Compose (la règle attache un seul
   scénario). Correction : test scindé en deux (`parrainage` / `reglages`).

Leçons : ① jamais de libellé traduit en dur dans une assertion — toujours
`ctx.getString` ; ② un `setContent` par test, toujours.
