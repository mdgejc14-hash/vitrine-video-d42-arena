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

## P0-2 · Catalogue : présentation des gabarits (Lot 2)

- **Observation** : cartes verticales très hautes (vignette 16:9 pleine largeur
  puis 3 textes) → les 5 gabarits du secteur ne tiennent pas à l'écran ; méta
  ligne codée en dur « X s · N scenes · M prises » non localisée (« scenes » en
  FR) ; pastille LECTURE dessinée au centre de la vignette = faux bouton Play
  sans prévisualisation réelle (interdit, exigence fondateur §3).
- **Cause** : `CatalogScreen.kt` (Card verticale + méta `buildString` codé en
  dur), `VignetteCatalogue.kt` (`dessinerDecorVignette` dessine la pastille
  lecture).
- **Correction (Lot 2)** : suppression de la pastille LECTURE (le visuel reste
  cadrage caméra + pellicule scènes + icône métier + badge durée, tous réels) ;
  cartes horizontales compactes (vignette 112 dp à gauche, nom SemiBold, méta
  localisée `catalog_gabarit_meta`, phrase courte 2 lignes max, chevron orange
  dessiné = indication de choix) ; en-tête : badge secteur compact (pastille
  teinte métier + libellé localisé) remplace la phrase tronquée
  « Gabarits adaptés à votre commerce : … ».
- **Tests** : `CatalogVisualCheckTest` inchangé (assertions par nom de gabarit —
  toujours valides) ; captures `04-catalogue-*.png` régénérées par CI.

## P0-5 · Dashboard : en-tête non pro, jargon, sync trompeuse (Lot 5)

- **Observation** : badge « COMPTE » (mot empilé, aucune action) ; « TES VIDÉOS /
  Max 1080p · cloud 1 · cache 1 j » (jargon + tutoiement incohérent) ; secteur
  vide remplacé par « Droits non synchronisés : mode par défaut prudent »
  (message anxiogène et faux en écran stable) ; aucun état de synchronisation
  réel ; « Créer » bouton discret dans une carte.
- **Cause** : `DashboardScreens.kt` DashboardHeader/DashboardVideosCard ;
  `dash_rights_default` utilisé comme libellé de repli du secteur.
- **Correction (Lot 5)** : en-tête pro (logo + nom marque, « Bonjour, {commerce} »,
  secteur, icône réglages dessinée 44 dp — badge COMPTE supprimé) ; carte crédits
  (exports restants en grand, rendus cloud, résolution + filigrane, stockage
  cloud, **ligne sync honnête à 4 états** : Synchronisé [preuve = flushPending
  réussi] / Synchronisation en cours / Hors connexion + Réessayer) ; action
  principale « Créer une vidéo » bouton orange plein 52 dp ; « Voir les
  formules » remplace « Acheter ». `SyncState` + `synchroniser()`/`relancerSync()`
  dans `DashboardActivity.kt`.
- **Tests** : `DashboardVisualCheckTest` (nouveau) — badge COMPTE absent, en-tête,
  crédits, sync prouvée, code visible, hors connexion + Réessayer, plus jamais
  « Droits non synchronisés » ; captures `d42-32-lot5-dashboard-*.png`.

## P0-6 · Parrainage : code noyé sous les paliers (Lot 6)

- **Observation** : 5 lignes de paliers AVANT le code → code personnel sous le
  pli ; « Copier » ouvrait le partage (pas de copie réelle) ; historique filleuls
  toujours déplié.
- **Cause** : `DashboardScreens.kt` DashboardReferralCard (ordre paliers → code) ;
  `DashboardActivity.kt` `onCopyCode = { share() }`.
- **Correction (Lot 6)** : ordre imposé titre → phrase → **code en grand dans un
  bloc BleuVoile, visible sans défilement** (repli honnête « Code disponible
  après synchronisation ») → « Copier mon code » (presse-papiers réel +
  confirmation) → « Partager sur WhatsApp » → progression (jauge serveur +
  palier suivant) → accès « Voir mes filleuls » ; paliers détaillés reportés à
  l'écran 12 ; historique REPLIABLE (ouvert par défaut, pliable).
- **Tests** : `DashboardVisualCheckTest` (code visible, Copier mon code, partage,
  progression 3/5, repli historique par clic) ; `DashboardL10nCheckTest` inchangé
  (historique ouvert par défaut → assertions substring toujours valides).

## Diagnostic en cours (lots suivants)

- P0 caméra mosaïque → diagnostic différentiel 4 sources (à documenter dans
  `06_CAMERA_DIAGNOSTIC.md`).
- P0 tarifs → « Exports illimités (usage loyal : 90) » contradictoire ;
  source de vérité des plans à identifier (D1 / plan model / worker).
- P1 formulaires → clavier/prix (adjustResize/imePadding), WhatsApp international.
- P1 langues → mélanges FR/EN (caméra : « Film your take » + consignes FR).
