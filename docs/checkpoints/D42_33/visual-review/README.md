# Galerie visual-review D42.33 — captures Android avant/après

**36 captures réelles** (11 AVANT + 25 APRÈS), identification complète dans
`MANIFEST.tsv` : écran, langue, résolution (qualifier + pixels réels), état.

## Provenance — aucune maquette

Toutes les images sont des **captures du rendu Android réel** produites par
les tests Robolectric (`GraphicsMode NATIVE` = pipeline Skia d'Android) dans
la CI, extraites de l'artefact `ci-visual-check` :

- **BEFORE/** — run android-ci **43586092209**, commit `b5a1462`
  (D42.32, état avant refonte ; main = bb759f8).
- **AFTER/** — run android-ci **43610784376**, commit `0a114ce`
  (D42.33, familles 04 → 11).

Les PNG `20-24_*` (famille 11) couvrent fontScale 1,3, petit écran 360×640,
rotation paysage et anglais. Les identifiants `12-16_*` couvrent les écrans
du hub refondus en familles 09/10 (dashboard, parrainage, paywall, réglages).

## Limites honnêtes

- Les captures **dashboard/paywall « avant »** n'existent pas dans les
  artefacts : `feature-dashboard` n'était pas inclus dans l'upload
  `ci-visual-check` avant le commit 0a114ce (workflow corrigé). L'état
  « avant » de ces écrans reste consultable dans le code D42.32
  (`git show bb759f8:feature-dashboard/.../DashboardScreens.kt`) et décrit
  dans les checkpoints 09/10.
- **FR/EN uniquement** : les captures l10n es/ja générées par les vieux
  tests D42.32 (repli par défaut) ne sont volontairement pas incluses —
  l'application ne supporte que FR/EN (règle fondateur).
- **FLAG_SECURE jamais contourné** : les captures proviennent de tests
  Compose en environnement de test, pas d'écrans protégés contournés.
- Les captures d'écrans caméra réels (runner physique) des campagnes
  acquises D42.32 (runs 43586092282 / 43582492529) ne sont pas relancées
  (budget 0 FCFA, réutilisation des preuves).

## Correspondance écrans ↔ familles

| Préfixe | Écran | Famille de refonte |
|---|---|---|
| 01-03, 10 | langue, carrousel, secteurs, marque | 04 |
| 04 | catalogue | 05 |
| 05-07 | brief, guides caméra | 06 / 07 |
| 08 | import rushs | 06 |
| 09 | aperçu export | 08 |
| 12-13 | dashboard | 09 |
| 14 | parrainage | 09 |
| 15 | paywall / formules | 10 |
| 16 | réglages | 09 |
| 20-24 | responsive/a11y | 11 |
