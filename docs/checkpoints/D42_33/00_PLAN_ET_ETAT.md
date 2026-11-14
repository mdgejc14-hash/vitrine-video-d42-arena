# D42.33 — Plan d'exécution et état — Refonte visuelle premium

**Mission** : appliquer la refonte visuelle validée (32 maquettes, 393×852 dp) à l'intégralité de
l'application, **sans régression fonctionnelle** (mêmes états / ViewModels / contrats / services,
parcours invariant, textes = ressources du dépôt FR/EN).

**Branche** : `d42.33-visual-redesign` (créée depuis bb759f8 = main distant D42.32 clos).
**Interdits pendant la revue** : aucun push sur main, aucune RC16, aucun build signé/publication,
RC15 immuable (release 442574529, SHA-256 fd28ffc…). Prévisualisation = debug + captures.

## Référentiels (hiérarchie officielle)

1. Décisions de la mission D42.33 (message fondateur).
2. `SOURCES/spec/05_Spec_design_a_transmettre.md` — 418 lignes, lues intégralement.
3. `SOURCES/spec/03_Note_de_recommandations.pdf` — 6 pages, texte extrait (pypdf).
4. `SOURCES/maquettes/` — 34 PNG 1179×2556 (01_ouverture → 34_aide_contact).
5. `SOURCES/references/` — 02_Systeme_de_design.png, 01_Avant_Apres.png.
6. Contenu réel du dépôt (bb759f8).
7. Expertise.

⚠️ L'environnement d'exécution n'a **pas de capacité vision** sur les PNG : la **spécification
chiffrée** (sections 2–13) fait autorité pour l'implémentation ; les maquettes versionnées
servent de référence de trace pour le fondateur. Aucune valeur inventée depuis une image.

## Décisions de la note PDF intégrées (sans effet sur la copie existante)

- Prénom : les maquettes montrent « Félicitations, Awa ! » = **exemple de maquette**. Règle
  fondateur appliquée : titre générique « Félicitations ! » (strings du dépôt), jamais de prénom
  démo. Dashboard : si prénom manquant → « Bonjour » seul, **jamais « Bonjour, — »** (tiret interdit).
- Solde non confirmé serveur → « en attente de synchronisation », jamais un « 0 » sec.
- Tutoiement/vouvoiement : copie existante conservée telle quelle (règle : ne pas réécrire le
  copywriting existant ; les NOUVEAUX textes des 2 écrans créés restent sobres).

## Ordre d'exécution (spec §0) et checkpoints (mission §13)

| # | Checkpoint | Contenu | État |
|---|---|---|---|
| 0 | `00_PLAN_ET_ETAT.md` | Ce document | ✅ |
| 1 | `01_AUDIT_VISUEL.md` | Audit écrans/composants/écarts vs spec | ⏳ |
| 2 | `02_TOKENS.md` | Color/Type/Shape/Dimens/Elevation + polices locales + Theme | ⬜ |
| 3 | `03_COMPOSANTS.md` | 18 composants uniques core-designsystem | ⬜ |
| 4 | `04_ONBOARDING.md` | ouverture, carrousel, langue, auth, code parrain, secteurs, bienvenue | ⬜ |
| 5 | `05_CATALOGUE.md` | catalogue, vignettes, détail gabarit | ⬜ |
| 6 | `06_BRIEF_FORMULAIRES.md` | brief 8 étapes, champs, ReadyCheck + §9.6 préparation caméra | ⬜ |
| 7 | `07_CAMERA.md` | viseur, overlay, countdown, REC, revue des prises, consentement | ⬜ |
| 8 | `08_MONTAGE_EXPORT.md` | aperçu, montage en cours, export prêt, partage | ⬜ |
| 9 | `09_DASHBOARD_PARRAINAGE.md` | dashboard §9.3, mes vidéos, réglages | ⬜ |
| 10 | `10_TARIFICATION.md` | formules, quota épuisé, aide & contact §9.7 | ⬜ |
| 11 | `11_RESPONSIVE_ACCESSIBILITE.md` | 6 contrôles §12 (fontScale 1,3 / 360×640 / rotation / EN / contrastes / cibles) | ⬜ |
| 12 | `12_NON_REGRESSION.md` | tests ciblés par famille + e2e-lab + CI | ⬜ |
| 13 | `13_RAPPORT_FINAL.md` | verdict + galerie complète | ⬜ |

(États mis à jour au fil de l'exécution ; ⏳ = en cours, ⬜ = à faire.)

## Polices (décision d'implémentation)

minSdk 24 → **fichiers statiques** (les axes variables ne s'appliquent qu'à partir d'API 26 ;
le rendu 700/800 doit être garanti sur les appareils économiques API 24-25 du marché cible) :
- Plus Jakarta Sans Bold (700) + ExtraBold (800) — titres, chiffres, boutons.
- Inter Regular (400) + Medium (500) + SemiBold (600) — corps, méta, champs.
- Licences SIL OFL 1.1 versionnées dans `core-designsystem/licenses/` + manifeste
  `visual-review/ASSET_LICENSES.md` (mission §12). Aucun téléchargement au runtime.

## Jalons GitOps

- Chaque famille livrée = diff → tests ciblés → checkpoint → commit → push → vérif HEAD distant.
- CI : `android-ci.yml` se déclenche sur PR → **PR draft `d42.33-visual-redesign` → main** ouverte
  dès le premier commit poussé (validation continue sans toucher main).
- Galerie `docs/checkpoints/D42_33/visual-review/` : avant (PNG D42_32) ↔ après (captures
  debug D42.33) pour **tous les écrans du manifeste**, + README, SCREEN_INVENTORY.csv,
  BEFORE_AFTER.csv, DESIGN_SYSTEM.md, ASSET_LICENSES.md, UX_AUDIT.md, VISUAL_REGRESSION.md,
  RUNS.md, MANIFEST.tsv.
- Fin : message unique de livraison → **STOP porte d'approbation visuelle**.

## Journal

- **J0** : Phase 0 vérifiée (origin/main = bb759f8, RC15 intacte, rollback sandbox n°4 réparé,
  branche créée). Sources fondateur rapatriées du Drive : spec md (418 l. lues), note PDF (6 p.
  extraites), 34 maquettes PNG vérifiées (PNG 1179×2556), système de design, avant/après →
  `SOURCES/` (28 Mo). Polices + OFL téléchargées. Audit dépôt (01_AUDIT_VISUEL.md).
