# D42.33 — Rapport final de livraison (v2) — Lots 1→3

**Date** : 14–17 novembre 2026 · **Échéance fondateur** : 18/11/2026 ✅
**Branche** : `d42.33-visual-redesign` · **HEAD** : `7b4fd32` (Lot 3)
Chaîne : `3a28366` → `90b5c33` (Lot 1) → `c110c46` (Lot 2) → **`7b4fd32` (Lot 3)**
`main` = `bb759f8` (intouché ✓) · RC15 immuable (release 442574529) ✓ · Pas de RC16 ✓

## Livrables de l'ordre D42.33

| # | Demande | État |
|---|---|---|
| 1 | Audit de fidélité design | ✅ Lot 1 (`90b5c33`, CI 43617353639 SUCCESS) — SCREEN_INVENTORY.csv 90 états + audits 01→14 |
| 2 | Galerie exhaustive 12 parcours | ✅ Lots 2+3 — voir chiffres ci-dessous |
| 3 | README galerie défilante, images Markdown intégrées | ✅ `docs/checkpoints/D42_33/visual-review/README.md` — 148 images rendues directement par GitHub |
| 4 | Corriger uniquement les écarts avérés | ✅ Écart galerie v1 corrigé (rendus EN étiquetés FR) ; Lot 4 = **néant** (aucun autre écart démontré) |
| 5 | Rapport de livraison | ✅ ce document |

## Chiffres exacts (contrôlés par `tools/build_gallery.py`, sortie « concordance OK »)

- **90 états inventoriés** (SCREEN_INVENTORY.csv = BEFORE_AFTER.csv = galerie) :
  - 50 CONFORME (capture) — dont 48 ex-NON PROUVÉ prouvés au Lot 2 + P02-01/P07-01 refaites ;
  - 21 CONFORME (Lot 1) ; 1 CONFORME (partiel) (P12-17, décision Lot 1) ;
  - 6 DOCUMENTÉ (Lot 2 : aucun rendu distinct ou impossible — P01-07, P02-05, P02-07, P05-10, P12-14, P12-16) ;
  - 3 NON PROUVÉ maintenus (P01-01/P01-02 splash API non rendue par Robolectric ; P05-12 dialogue système) ;
  - 6+1 ÉCART ASSUMÉ, 1 NON APPLICABLE, 1 DOCUMENTÉ (es/ja) — décisions fondateur Lot 1.
- **Captures** : 12 BEFORE (run 43586092209, `b5a1462`) + **74 AFTER** = 86 fichiers, **0 doublon md5**.
- **README galerie** : **148 images intégrées** (72 AVANT + 72 APRÈS + 4 variantes réelles),
  148/148 chemins valides vérifiés PNG (PIL) ; **59 paires AVANT↔APRÈS complètes** ;
  36 cellules non-image, chacune explicite (dump XML AVANT, AVANT absent, APRÈS non rendable).
- **Provenance AFTER** : v1 = run 43610784376 (`0a114ce`) ; Lot 2 = `c110c46`
  (CI **43626981859 SUCCESS**) ; 2 fichiers corrigés (rendus FR authentiques).

## Écart avéré corrigé (ordre ④)

Le harnais v1 `OnboardingVisualCheckTest` n'avait **aucun qualifier de locale** →
`01_langue_fr` et `03_secteurs_fr` étaient des rendus **anglais** (défaut Robolectric).
Preuve md5 : byte-identiques aux rendus EN (P01-04/P02-08), différents des rendus FR.
Corrigé par les tests `correction_galerie_*` (Lot 2) ; `02_carrousel` v1 (EN, 320×470)
supprimé, supersédé par la refonte P02-01. Les 3 BEFORE onboarding portent la mention
« langue réelle : en » dans MANIFEST.tsv. Aucun autre écart démontré → aucun changement
du code applicatif (moteur, contrats et parcours préservés).

## Tests et CI

- 8 fichiers `Lot2*VisualCheckTest.kt` (54 tests) : vrais composants, états et données
  (JSON embarqués, seed DB, ActivityScenario). ktlint ✓ detekt ✓ (0 finding).
- CI android-ci : Lot 2 = **43626981859 SUCCESS** (`c110c46`) ;
  Lot 3 = **43661894482 SUCCESS** (`7b4fd32`).
- Notes Robolectric documentées dans les tests et la galerie : swipeUp sur onRoot()
  inopérant derrière un élément épinglé → `performScrollTo` + `assertIsDisplayed` ;
  splash, dialogue système, clavier logiciel et PreviewView non rendables — jamais
  contournés, jamais fabriqués.

## Réserves honnêtes

1. Les 3 NON PROUVÉ restants sont des limites de plateforme, pas des trous de conformité
   (code vérifié conforme au Lot 1 pour la splash).
2. P12-17 (partiel, Lot 1) : l'e2e « retour réseau » relève des tests non-régression.
3. AVANT dashboard/paywall inexistants en artefacts D42.32 (feature-dashboard ajouté à
   l'upload ci-visual-check seulement au commit 0a114ce) — documenté dans la galerie v1.
4. Budget 0 FCFA : aucune campagne d'acquisition relancée, réutilisation des preuves.

## Liens directs (branche d42.33-visual-redesign)

- Galerie : `https://github.com/mdgejc14-hash/vitrine-video-d42-arena/blob/d42.33-visual-redesign/docs/checkpoints/D42_33/visual-review/README.md`
- Inventaire : `…/blob/d42.33-visual-redesign/docs/checkpoints/D42_33/SCREEN_INVENTORY.csv`
- Correspondances : `…/blob/d42.33-visual-redesign/docs/checkpoints/D42_33/visual-review/BEFORE_AFTER.csv`
- Manifeste : `…/blob/d42.33-visual-redesign/docs/checkpoints/D42_33/visual-review/MANIFEST.tsv`
- Générateur : `…/blob/d42.33-visual-redesign/docs/checkpoints/D42_33/visual-review/tools/build_gallery.py`

## Porte d'approbation

Conformément aux instructions fondateur : **STOP ici** — revue visuelle humaine de la
galerie attendue avant toute décision de RC16/publication. Aucun push main, aucun build
commercial signé, CinetPay reste en 501 `billing_not_configured`.
