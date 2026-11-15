# D42.34 — Registre des ressources visuelles ORIGINALES générées

Décision fondateur (ordre finalisation visuelle §6) : les images sans droits
vérifiables sont remplacées par des visuels originaux générés pour le
projet. Ce registre trace la provenance de chaque ressource intégrée.

## Statut : EN COURS (10/39 au 17/11 — limite de génération par session)

| Ressource app | Fichier source généré | Contenu | Licence |
|---|---|---|---|
| carrousel_1_boutique.webp | assets_gen/carrousel_1_marchande.png | Commerçante ouest-africaine dans sa boutique (Cotonou) | Originale générée IA — projet VITRINE VIDÉO |
| carrousel_2_tournage.webp | assets_gen/carrousel_2_restauration.png | Cheffe de maquis dressant une assiette | Originale générée IA |
| carrousel_3_resultat.webp | assets_gen/carrousel_3_mode.png | Vendeur mode rangeant des vêtements wax | Originale générée IA |
| sector_batiment_travaux.webp | assets_gen/sector_batiment_travaux.png | Maçon sur chantier | Originale générée IA |
| sector_coiffure_beaute.webp | assets_gen/sector_coiffure_beaute.png | Salon de coiffure, tresses | Originale générée IA |
| sector_immo_auto.webp | assets_gen/sector_immo_auto.png | Remise de clés en concession | Originale générée IA |
| sector_restaurants_maquis.webp | assets_gen/sector_restaurants_maquis.png | Assiette maquis (poulet braisé) | Originale générée IA |
| sector_shops_small_business.webp | assets_gen/sector_shops_small_business.png | Épicerie de quartier rangée | Originale générée IA |
| sector_vetements_mode.webp | assets_gen/sector_vetements_mode.png | Portants de vêtements wax | Originale générée IA |
| apercu_batiment_travaux_t1.webp | assets_gen/apercu_batiment_T1.png | Arrivage matériaux (T1 BTP) | Originale générée IA |

## Recaptures effectuées (17/11 soir, Robolectric NATIVE, toolchain locale)

- D34-11 (slide 1 marchande) REMPLACÉE — diff PIL 68,1 % vs ancienne (image originale rendue)
- D34-13 (slide 2 restauration) + D34-14 (slide 3 mode) AJOUTÉES
- D34-15 (grille 6 secteurs) AJOUTÉE — chromatisme 10,8 % → 14,4 % (images rendues)
- Catalogue D34-01/02/03 : diff 0,1 % (tests en secteur Mode — aperçu BTP non impliqué) ;
  recapture définitive APRÈS complétude des 29 aperçus restants (Lot D)
- Tests : :feature-onboarding:testDebugUnitTest et :feature-catalog:testDebugUnitTest
  BUILD SUCCESSFUL en local (aucun échec, aucun FAIL→PASS)

## Reste à générer (29) — aperçus catalogue 16:9

batiment T2→T5 (4), coiffure T1→T5 (5), immo_auto T1→T5 (5), restaurants
T1→T5 (5), shops T1→T5 (5), vetements T1→T5 (5). Nommage cible :
`apercu_<secteur>_t<n>.webp` + entrée `ApercuGabarit.map`.

## Exigences respectées (§6.2/6.3)

Réalistes, éclairage professionnel, sujets ouest-africains diversifiés
(femmes/hommes, métiers distincts), sans logo tiers, sans texte parasite,
sans filigrane. AUCUNE fausse capture d'app, AUCUNE simulation de flux
caméra — uniquement des ressources décoratives (fonds carrousel, cartes
secteur, aperçus de gabarit). Les captures de preuve restent produites par
les VRAIS composants Android (Robolectric/émulateur).

Les sources PNG générées restent hors dépôt (assets_gen/, reproductibles) ;
seules les versions WebP optimisées sont commitées.
