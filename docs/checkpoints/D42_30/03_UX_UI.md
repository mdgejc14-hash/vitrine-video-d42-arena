# D42.30 — 03_UX_UI

**Étapes 5 (P1-F écrans vérification) + 6 (P1-C catalogue) — codées, poussées
(b5033f7), CI verte (android-ci 5082856 SUCCESS ; e2e-lab suite principale +
camerap + petit-écran SUCCESS).**

## P1-F — écran de vérification (« Avant de commencer », ReadyCheckScreen)

Retour terrain : badge « VÉRIFICATION » coupé/superposé, bloc ressemblant à une
case à cocher factice, bouton final sous un long scroll.

- **Header responsive** : `ReadyHeader` passe par `BoxWithConstraints` — sous
  340 dp, le badge `VÉRIFICATION` descend sur sa PROPRE ligne (plus jamais de
  superposition avec le titre). ≥ 340 dp : ligne unique titre + badge.
- **Bloc confirmation honnête** : `ReadyConfirmBox` redevient un bandeau
  d'information NEUTRE (fond BleuVoile, bord arrondi, texte `weight(1f)`) —
  plus de carré rempli « ✓ » imitant une case à cocher active.
- **Boutons d'action ÉPINGLÉS hors du scroll (D42.30-08)** : « Continuer »
  (brief) et « OK, je commence » (vérification) sont des pieds FIXES —
  `navigationBarsPadding()` + `imePadding()`, formulaire en `weight(1f)`
  défilant SOUS le bouton. Preuves du défaut (runs 5082856/67f6421, dumps
  22b/CPA_brief_bas) : bouton en fin de scroll collé au bord de fenêtre,
  texte à 1 px de haut dans la zone de gestes système → taps perdus,
  parcours bloqué. Désormais le CTA est TOUJOURS visible sans défiler,
  au-dessus du clavier ET de la barre de navigation.
- Preuve : les bancs e2e-lab qui traversent ReadyCheck (suite principale,
  camerap `CPx_brief_valide`, p1) atteignent tous l'écran suivant après
  « OK, je commence » — la chaîne est fonctionnelle (p1 sur 67f6421).

## P1-C — catalogue commercial (CatalogScreen + VignetteCatalogue)

Retour terrain : cartes 100 % textuelles uniformes, filtres secteurs toujours
déployés, aucune miniature (et miniatures réseau B2 en 404 → « … » gris).

- **Vignette sectorielle DESSINÉE** (`VignetteCatalogue.kt`, Compose Canvas
  pur, zéro dépendance, marche hors-ligne) :
  - quatre **coins de viseur caméra** (langage métier) ;
  - **pastille lecture** centrale (ce que vend le produit : une vidéo) ;
  - **pellicule** en bas = une cellule par scène (info RÉELLE du gabarit,
    pas décorative) ;
  - **badge durée** (haut-droite) ;
  - **icône métier** dessinée par secteur (t-shirt, ciseaux, fourchette,
    marteau, maison, auvent boutique, éclair) ;
  - **palette profonde par secteur** (6 teintes + TOUS), jamais de gris.
  - Honnêteté contractuelle : ce n'est pas un faux aperçu de la vidéo du
    commerçant — c'est un visuel de marque qui informe (durée, scènes).
- **Carte gabarit** : vignette + nom du format + méta (secteur · durée ·
  scènes · prises) + phrase bénéfice — le commerçant comprend ce que le
  modèle va produire.
- **Repli SkinCard** : miniature réseau absente → vignette dessinée + libellé
  (fini le « … » gris sur fond noir).
- **« Changer de secteur » discret** : sur la ligne du titre (labelMedium,
  couleur primaire) ; les filtres secteurs sont REPLIÉS quand un secteur est
  déjà choisi (moins de bruit), dépliés au tap. Les 30 gabarits et 6 secteurs
  sont conservés (aucun changement de contenu).
- `sectorFromGabaritCode` pour la teinte (jamais de code technique visible).

## Preuves restantes (étape 8 / matrice finale)

- Captures du catalogue (cartes vignettes) FR/EN sur l'émulateur — artefacts
  du lab (07_catalogue_*.png du run_audio_modes / p1) ;
- capture clavier ouvert sur petit écran (run_p0 petit_ecran) montrant le
  bouton au-dessus de Gboard ;
- preuve avant/après de la stabilité du champ prix (saisie continue sans
  saut de curseur — vidéo/captures du run p1).
