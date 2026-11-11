# D42.30 — 06_LANGUES_FR_EN

**Étape 7 (P1-G) — codée dans b5033f7, CI verte (android-ci 5082856 ;
e2e-lab : langues (en) SUCCESS, suite principale FR SUCCESS).**

Décision fondatrice : **FR/EN uniquement** (l'espagnol et le japonais sont
retirés du produit). Carrousel initial conservé.

## Ce qui a été retiré (produit actif)

- `VitrineLocale.SUPPORTED = ["fr", "en"]` ; un choix `es`/`ja` hérité d'une
  version antérieure est IGNORÉ (`takeIf { it in SUPPORTED }`) — jamais de
  locale fantôme sur un appareil mis à jour.
- Sélecteur de langue : 2 cartes (Français, English).
- Dialog de langue du dashboard : 2 entrées.
- `GabaritL10n.LANGUES = ["fr", "en"]` (les clés es/ja du JSON deviennent
  inertes — aucune suppression de données).
- **16 dossiers `values-es`/`values-ja` ARCHIVÉS dans `content/archive_i18n/`**
  (7 modules × 2 locales + app × 2) : hors des source sets, conservés dans
  l'historique Git et sur GitHub.

## CI et harnais alignés

- `android-e2e-lab.yml` : matrice langues `[en]` (le FR est couvert par la
  suite principale run_p0/p1/camerap/drafts ; ce job prouve l'EN) — fin des
  FAIL es/ja « par design » constatés au run 43031453562.
- `run_p3_matrix.sh` : boucle `fr en`.
- `run_langue.sh` / `run_audio_modes.sh` : blocs es/ja supprimés, message
  explicite.
- `virtual-render-validation.yml` : matrices `[fr, en]` (60 rendus au lieu
  de 120), descriptions à jour.

## Tests convertis (JVM + instrumentés)

- `I18nKeyCoverageTest` : couverture FR ↔ EN exacte sur les 7 modules
  (l'échec du run 10a12e1 — clés brief_phone_* absentes en ES/JA — est
  résolu par le retrait de ces locales ; le test est la preuve anti-régression).
- `GabaritL10nTest` : `lAnglaisEstReellementDeLanglais` (badge « LIMITED
  STOCK », « DISCOVER », couverture EN vérifiée contre le JSON réel),
  `leRenduAnglaisRemplaceLeFrancaisSansPerdreLesVariables` (badge
  « LIMITED SEATS », zéro texte FR résiduel, zéro variable non substituée).
- `GabaritCombinaisonsL10nTest` : 60 combinaisons gabarit × langue (fr/en).
- `ProductionRenderInstrumentedTest` : échantillons fr/en uniquement,
  gabarits de référence fr/en.

## Preuves

- e2e-lab 5082856 : **langues (en) SUCCESS** (sélection English → écrans
  vérifiés en anglais jusqu'au catalogue) + suite principale FR SUCCESS.
- Anciennes preuves ES/JA (runs D42.14/D42.28, artefacts et rapports) :
  conservées dans l'historique GitHub — rien n'est effacé, le produit
  actif est simplement restreint.
