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
| 5 | `05_CATALOGUE.md` | catalogue, vignettes, détail gabarit | ✅ |
| 6 | `06_BRIEF_FORMULAIRES.md` | brief 8 étapes, champs, ReadyCheck + §9.6 préparation caméra | ✅ |
| 7 | `07_CAMERA.md` | viseur, overlay, countdown, REC, revue des prises, consentement | ✅ |
| 8 | `08_MONTAGE_EXPORT.md` | aperçu, montage en cours, export prêt, partage | ✅ |
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

- **Familles 04-05** : onboarding §9.1/9.2/9.4 complet (commits eba2f2d, fd74b69,
  16d78c6) + catalogue §8-C (16d78c6). Leçons CI : réassignation `val` paramètre →
  callback ; `weight` hors RowScope → paramètre modifier ; clé i18n FR-only.
- **Rollback sandbox n°5** (13:50 UTC) : HEAD local repéré à 8d530b1 (D42.27),
  famille 06 non commitée perdue de la sandbox — **refaite intégralement** ;
  GitHub = vérité durable (16d78c6 intact), débris archivés
  (`/home/user/debris_*.tar.gz`), remote+identité git restaurés.
- **Sortie de la boule CI** (ordre fondateur) : diagnostic run 43600512583 =
  detekt LongMethod CatalogScreen + Robolectric MavenArtifactFetcher (404
  transient Maven Central au runtime, hors Gradle). Fix déterministe offline
  (voir 06_BRIEF_FORMULAIRES.md) + extractions detekt. **Un seul commit/push
  pour famille 05-fix + 06 + CI** — plus de micro-campagnes.
- **Famille 06+fixes CI** (628917e) : Robolectric offline déterministe VALIDÉ
  en CI (jars résolus par Gradle, zéro MavenArtifactFetcher) ; échec compile
  restant = imports manquants GabaritBriefScreen (ancre de replace inexistante,
  silencieuse) — corrigé avec ancre vérifiée + audit automatisé.
- **Famille 07 caméra** : §7.15 intégral (navy 55 %, OverlayViseur, consigne
  floutée, rouge = arrêt uniquement), labels techniques « visages détectés /
  (R4) » supprimés de l'UI, moteur ConsentGate/dialogue/e2e intacts.

- **Famille 08 montage/export** (1d1eb6b) : E7 vignette navy héro SANS glyph ▶
  (faux bouton lecture supprimé), bannière sous-titres 0xCC022358 r14, tuile
  vérif blanche r22 ; E8 XML padding/typo/ProgressBar 8 dp #F95C0F, boutons
  56/48 dp, bg_card r22 blanc. ExportActivity AUCUNE modification. **CI verte
  (43603381967)** — 0000c9b (07) aussi verte (43603190662).
- **Famille 09 dashboard/parrainage** : §7.12/§9.3 intégral — header avatar
  (initiale réelle/insigne), héros navy r26 + CTA soudé, Reprendre (brouillon
  Room réel, dialogue D42.27 réutilisé via extra vv_reprise), parrainage tuile
  blanche (code OrangeDeep/OrangeVoile, copie = secondaire doux), derniers
  exports (comptage Room réel), tab BarreOnglets centrale. Paywall INTACT
  (famille 10). DAO +2 requêtes lecture seule. Test dash_app_name retiré
  (header), +dash_tab_create/home. Détails : 09_DASHBOARD_PARRAINAGE.md.

- **Rollbacks sandbox n°6+n°7** (reprise famille 10) : la sandbox est retombée
  deux fois à 8d530b1 (D42.27) avec .git/config détruit. GitHub intouchable =
  fae6000 vérifié via API à chaque fois (CI 07/08/09 = 43603190662 /
  43603381967 / 43604879046, toutes success). Débris archivés
  (debris_rollback6.tar.gz, chemins vérifiés présents à distance avant
  nettoyage), remote+identité reconstruits, reset --hard fae6000, arbre
  propre. **Aucune perte : tout le travail validé était poussé.** Leçon
  consolidée : committer/pousser les preuves CI dans le MÊME tour que le
  constat, pas après.
- **Ordre fondateur (reprise)** : famille 10 = TARIFICATION SEULE — l'app n'a
  pas de centre d'aide, n'en pas créer (aucun écran/parcours/entrée réglages).
  CinetPay reporté (501 honnête), contrats de paiement intouchés.

- **Famille 10 tarification** : PaywallScreen refondu en CarteFormule ×3
  (grille stricte 500/3 000/7 500), prix « · N FCFA » une ligne (24 sp),
  état quota épuisé = écran dédié (solde 0 en Num + « Recharger plus
  tard »), badge Recommandé en aplat OrangeStore (OrangePlein). AUCUN
  écran d'aide créé (ordre fondateur). CinetPay reporté, contrats
  intacts, PaywallMapper intact. price_* recollé via testTagPrix.
  Détails : 10_TARIFICATION.md.

- **Famille 10 VALIDÉE** : fbc7f8c + fix fe92f42, **CI verte 43608643954**
  (run rouge 43608092097 : detekt complexité CarteFormule + trailing lambda
  onChoose — diagnostiqués, corrigés, leçons consignées dans 10_TARIFICATION.md).
  Nota : commit initial brièvement tombé sur main LOCALE (branche perdue au
  rollback n°7) — repoussé sur d42.33, main locale remise à bb759f8,
  **aucun push sur main** (vérifié origin/main inchangé).

- **Famille 11 responsive/a11y** : six contrôles — fontScale 1,3 + 360×640 +
  rotation + EN via ResponsiveA11yCheckTest (Robolectric, captures preuve) ;
  contraste audité par calcul WCAG (socle conforme, écarts = tokens de marque
  documentés pour la porte d'approbation) ; cibles tactiles corrigées
  (CtaSecondaire 48, réglages 48, liens 12 dp). Détails : 11_RESPONSIVE_A11Y.md.
