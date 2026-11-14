# D42.32 — Audit UX : 7 constats et statut de correction

> Recréé après rollback sandbox (statuts de la passe initiale perdus —
> réalignés sur l'état Git réel des lots). « CORRIGÉ » = code + tests poussés ;
> la vérification VISUELLE finale passe par la galerie (captures du commit
> candidat) — c'est l'objet de la porte d'approbation.

| # | Constat (audit initial) | Écrans | Correction | Statut |
|---|---|---|---|---|
| 1 | Le dashboard ne dit pas ce que le commerçant a (crédits, état sync honnête) — pas de hiérarchie pro | DashboardScreen | Lot 5 : en-tête pro, carte crédits, action principale, état sync réel | **CORRIGÉ** (f07ae5c) — visuel à confirmer galerie |
| 2 | Catalogue : filtre intégré confus, on ne voit pas les 5 gabarits de SON secteur, cartes inégales | CatalogScreen, VignetteCatalogue | Lot 1 : secteur ⇒ 5 gabarits, retour = sélection ; Lot 2 : cartes premium | **CORRIGÉ** (90f1ac5, 095d645) — visuel à confirmer galerie |
| 3 | Tarifs flous (« illimité », limites non affichées) — confiance tarifaire absente | PaywallScreen | Lot 7 : 3 formules exactes 500/3000/7500, badge Recommandé, 501 honnête ; §4 : Pro 90/30 j réellement appliqué serveur | **CORRIGÉ** (e47262a + 79e4b14) — visuel à confirmer galerie |
| 4 | Formulaires : WhatsApp refusé, prix sauté au clavier, tutoiement incohérent | GabaritBriefScreen | Lot 8 : WhatsApp E.164 (+229/+33/+1), prix stable, conjugaison corrigée, ImeAction Suivant, erreur 130 % | **CORRIGÉ** (6d1ad6a) — visuel à confirmer galerie (capture clavier ouvert) |
| 5 | Caméra : mosaïque inquiétante, pas de repères de confiance pendant le tournage | PriseGuideScreen | Lot 3 : diagnostic différentiel 4 sources (outil) ; AUCUNE modif CameraX sans cause racine ; physique = fondateur | **OUTIL LIVRÉ** (b0a988b) — §5 récupération artefacts en cours ; mosaïque émulateur ≠ cause app |
| 6 | Bienvenue : pas de confirmation des crédits, bouton d'appui incertain | WelcomeScreen | Lot 9 : patron étapes 1-2, carte crédits confirmés, bouton épinglé 56 dp ; Lot 10 : barre d'action standard 52 dp (brief) | **CORRIGÉ** (d88dbbf, 1b42df4) — visuel à confirmer galerie |
| 7 | Parcours uniquement FR : anglophones exclus du parcours commercial | tout le parcours | Lot 4 : FR/EN complet (parcours + 30 gabarits, 376 chaînes par IDs stables) | **CORRIGÉ** (316bb80) — campagne e2e-langue-en PASS (run 43520993407) |

## Conditions de vérification (outre FR standard)

Petit écran (petit-ecran, 60 PNG run 43520993407) · police 130 % · clavier
ouvert (Lot 8) · EN (lang_en) · offline · caméra (camerap) · dashboard/paywall
(pixel5 23 PASS).
