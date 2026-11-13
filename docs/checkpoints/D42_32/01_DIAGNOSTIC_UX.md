# D42.32 — Diagnostic UX ciblé (observations → causes → fichiers)

## P0-1 · Catalogue : filtres de secteurs redondants

- **Observation** (fondateur, capture catalogue) : secteur « Vente de Voitures &
  Maisons » déjà choisi, mais le catalogue affiche encore des filtres horizontaux
  (Mode, Coiffure, Bâtiment, Immo-Auto, « Tous les métiers ») + « Changer de secteur ».
- **Cause** : `CatalogScreen.kt` — `filtresOuverts` repliable mais présent ;
  `SectorRow` + toggle « Changer de secteur » toujours rendus.
- **Correction (Lot 1)** : quand `initialSector != null` (parcours normal —
  l'onboarding garantit un choix), AUCUNE sélection intégrée : le retour arrière
  (`MainActivity.stepBack REQ_CATALOG → launchOnboarding`) redevient l'unique
  chemin de changement de secteur, et le catalogue redémarre avec le nouveau
  secteur (`launchCatalog()` repasse `sectorCode`).
- **Tests** : `GabaritCatalogTest` (6 secteurs × 5 gabarits, aucun mélange) +
  `CatalogVisualCheckTest` (secteur choisi → 5 cartes, 0 filtre, 0 « Changer de
  secteur », 0 « Tous les métiers »).

## Diagnostic en cours (lots suivants)

- P0-2 présentation catalogue → `CatalogScreen.kt` GabaritLayout/VignetteSecteur.
- P0 caméra mosaïque → diagnostic différentiel 4 sources (à documenter dans
  `06_CAMERA_DIAGNOSTIC.md`).
- P0 dashboard → `DashboardScreens.kt` DashboardHeader (badge COMPTE empilé).
- P0 parrainage → code sous les 5 paliers.
- P0 tarifs → « Exports illimités (usage loyal : 90) » contradictoire ;
  source de vérité des plans à identifier (D1 / plan model / worker).
- P1 formulaires → clavier/prix (adjustResize/imePadding), WhatsApp international.
- P1 langues → mélanges FR/EN (caméra : « Film your take » + consignes FR).
