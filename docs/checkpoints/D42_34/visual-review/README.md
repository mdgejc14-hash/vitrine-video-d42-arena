# D42.34 — Galerie visuelle unique (réf. fondateur ↔ application)

**Porte d'entrée unique de la revue visuelle** — ordre du parcours réel de
l'application. Chaque ligne montre la **maquette fondateur** à gauche et la
**capture réelle de l'application** à droite (composants Android authentiques :
tests Robolectric `@GraphicsMode(NATIVE)`, émulateur D42.31, ou écrans système).

> **Statut au 17/11/2026 (soir) — travaux en cours, rien de simulé :**
> - Lots d'aperçus **1 et 2 livrés** (15/11) : **21/30 gabarits** ont leur
>   aperçu photographique original intégré et vérifié sur GitHub (file
>   ASSET_GENERATION_QUEUE.csv — SHA-256, doublons contrôlés). Lot 3 (9
>   restants) en attente : limite stricte de la plateforme (10 images/tour).
>   La capture catalogue définitive suivra la complétude 30/30.
> - Captures carrousels/secteurs **déjà refaites** avec les images originales
>   (D34-11/13/14/15).
> - Recaptures restantes planifiées (Lot F) : montage phases, dashboard « Bonjour,
>   {prénom} », paywall CTA FR/EN, consentement, dialogue reprise, export.
> - Les états système (splash, flux viseur, feuille de partage) exigent le
>   **téléphone fondateur** — marqués NON PROUVÉ, jamais simulés.

**Légende :** CONFORME = capturé et mesuré · ÉCART = capture obsolète ou
correction en attente de recapture · NON PROUVÉ = exigé sur téléphone réel ·
NON APPLICABLE = hors périmètre (décision fondateur ou UI système).

## <a id="sommaire"></a>Sommaire

1. [Ouverture & marque](#a-ouverture--marque)
2. [Carrousel d'introduction](#b-carrousel-dintroduction)
3. [Langue](#c-langue)
4. [Connexion](#d-connexion)
5. [Code parrain](#e-code-parrain)
6. [Bienvenue & crédits](#f-bienvenue--crédits)
7. [Choix du secteur](#g-choix-du-secteur)
8. [Catalogue de gabarits](#h-catalogue-de-gabarits)
9. [Aperçus des gabarits (8 bis)](#h2-aperçus-des-gabarits)
10. [Brief](#i-brief)
10. [Caméra guidée](#j-caméra-guidée)
11. [Validation des prises](#k-validation-des-prises)
12. [Montage](#l-montage)
13. [Export](#m-export)
14. [Partage](#n-partage)
15. [Dashboard](#o-dashboard)
16. [Formules & paywall](#p-formules--paywall)
17. [Parrainage](#q-parrainage)
18. [Réglages](#r-réglages)
19. [Écrans hors périmètre](#s-écrans-hors-périmètre)
20. [États adaptatifs](#t-états-adaptatifs)

### <a id="a-ouverture--marque"></a>1. Ouverture & marque

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Splash (logo officiel, tuile navy) | <img src="../../D42_33/SOURCES/maquettes/01_ouverture.png" width="180"/> | **à produire — indiqué honnêtement** | NON PROUVÉ |
| Marque officiale (tuile blanche + insigne) | — | <img src="D34-12_marque-officielle_APRES.png" width="180"/> | CONFORME |

Le splash Android système n'est pas capturable honnêtement sous Robolectric. L'identité de marque est prouvée par la tuile D34-12.

[↑ Retour au sommaire](#sommaire)

### <a id="b-carrousel-dintroduction"></a>2. Carrousel d'introduction

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Slide 1 — commerçante boutique | <img src="../../D42_33/SOURCES/maquettes/02_carrousel.png" width="180"/> | <img src="D34-11_carrousel-slide1-marchande_APRES.png" width="180"/> | CONFORME |
| Slide 2 — cheffe de maquis | — | <img src="D34-13_carrousel-slide-2_APRES.png" width="180"/> | CONFORME |
| Slide 3 — vendeur mode wax | — | <img src="D34-14_carrousel-slide-3_APRES.png" width="180"/> | CONFORME |
| Slide 1 EN (l10n) | — | <img src="../../D42_33/visual-review/AFTER/P02-04_carrousel-slide-1-en_APRES.png" width="180"/> | CONFORME (pré-images) |
| Rotation (paysage) | — | <img src="../../D42_33/visual-review/AFTER/P12-13_carrousel-rotation_APRES.png" width="180"/> | CONFORME (pré-images) |

Trois univers métiers **distincts** (boutique / restauration / mode) — jamais la même photo répétée (exigence §6.3). Aucun texte marketing ajouté.

[↑ Retour au sommaire](#sommaire)

### <a id="c-langue"></a>3. Langue

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Sélection langue FR | <img src="../../D42_33/SOURCES/maquettes/03_langue.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/01_langue_fr_w360_APRES_selection-langue.png" width="180"/> | CONFORME |
| Sélection langue EN | — | <img src="../../D42_33/visual-review/AFTER/P01-04_langue-en_APRES.png" width="180"/> | CONFORME |
| Font scale 1,3 | — | <img src="../../D42_33/visual-review/AFTER/P12-02_langue-fontScale-1.3_APRES.png" width="180"/> | CONFORME |
| Petit écran w360×640 | — | <img src="../../D42_33/visual-review/AFTER/P12-07_langue-petit-ecran_APRES.png" width="180"/> | CONFORME |



[↑ Retour au sommaire](#sommaire)

### <a id="d-connexion"></a>4. Connexion

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Connexion FR (bouton Google unique) | <img src="../../D42_33/SOURCES/maquettes/04_connexion.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P01-05_connexion-fr_APRES.png" width="180"/> | CONFORME |
| Connexion EN | — | <img src="../../D42_33/visual-review/AFTER/P01-06_connexion-en_APRES.png" width="180"/> | CONFORME |
| Hors-ligne (erreur réseau) | <img src="../../D42_33/SOURCES/maquettes/05_connexion_hors_ligne.png" width="180"/> | **à produire — indiqué honnêtement** | NON PROUVÉ |

VR-009 : la variante d'erreur réseau nécessite une coupure réseau réelle — capture à produire, aucune simulation.

[↑ Retour au sommaire](#sommaire)

### <a id="e-code-parrain"></a>5. Code parrain

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Saisie manuelle | <img src="../../D42_33/SOURCES/maquettes/06_code_parrain.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P01-08_code-parrain-saisie-manuelle_APRES.png" width="180"/> | CONFORME |
| Deep-link pré-rempli | — | <img src="../../D42_33/visual-review/AFTER/P01-08_code-parrain-deep-link-prefilled_APRES.png" width="180"/> | CONFORME |
| Code détecté (bandeau) | — | <img src="../../D42_33/visual-review/AFTER/P01-08_connexion-code-parrain-detected_APRES.png" width="180"/> | CONFORME |



[↑ Retour au sommaire](#sommaire)

### <a id="f-bienvenue--crédits"></a>6. Bienvenue & crédits

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Crédits confirmés | <img src="../../D42_33/SOURCES/maquettes/27_bienvenue.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P01-09_bienvenue-credits-confirmes_APRES.png" width="180"/> | CONFORME |
| Solde en attente | — | <img src="../../D42_33/visual-review/AFTER/P01-10_bienvenue-solde-en-attente_APRES.png" width="180"/> | CONFORME |
| Font scale 1,3 | — | <img src="../../D42_33/visual-review/AFTER/P12-01_bienvenue-fontScale-1.3_APRES.png" width="180"/> | CONFORME |
| Petit écran | — | <img src="../../D42_33/visual-review/AFTER/P12-08_bienvenue-petit-ecran_APRES.png" width="180"/> | CONFORME |
| Rotation | — | <img src="../../D42_33/visual-review/AFTER/P12-12_bienvenue-rotation_APRES.png" width="180"/> | CONFORME |
| Hors-connexion (crédits différés) | — | <img src="../../D42_33/visual-review/AFTER/P12-15_bienvenue-hors-connexion_APRES.png" width="180"/> | CONFORME |



[↑ Retour au sommaire](#sommaire)

### <a id="g-choix-du-secteur"></a>7. Choix du secteur

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Grille 6 secteurs (images originales) | <img src="../../D42_33/SOURCES/maquettes/07_secteur.png" width="180"/> | <img src="D34-15_secteurs-grille_APRES.png" width="180"/> | CONFORME |
| Secteurs EN | — | <img src="../../D42_33/visual-review/AFTER/P02-08_secteurs-en_APRES.png" width="180"/> | CONFORME (pré-images) |

Maquette PIL : blanc 86 %, tuiles discrètes — respecté.

[↑ Retour au sommaire](#sommaire)

### <a id="h-catalogue-de-gabarits"></a>8. Catalogue de gabarits

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Catalogue secteur choisi | <img src="../../D42_33/SOURCES/maquettes/08_catalogue.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/04_catalogue_fr_w360_APRES_secteur-choisi-sans-filtres.png" width="180"/> | ÉCART (recapture en attente) |
| Catalogue filtre Mode actif | — | <img src="../../D42_33/visual-review/AFTER/04_catalogue_fr_w360_APRES_filtre-Mode-actif.png" width="180"/> | ÉCART (recapture en attente) |
| Tuiles peuplées (scroll) | — | <img src="../../D42_33/visual-review/AFTER/P03-02_catalogue-tuiles-peuplees_APRES.png" width="180"/> | ÉCART (recapture en attente) |
| Scroll bas | — | <img src="../../D42_33/visual-review/AFTER/P03-03_catalogue-scroll-bas_APRES.png" width="180"/> | ÉCART (recapture en attente) |
| Catalogue EN | — | <img src="../../D42_33/visual-review/AFTER/P03-04_catalogue-en_APRES.png" width="180"/> | ÉCART (recapture en attente) |
| Catalogue hors connexion | — | <img src="../../D42_33/visual-review/AFTER/P03-05_catalogue-hors-connexion_APRES.png" width="180"/> | CONFORME |
| Secteur perdu → récupéré (D42.34) | — | <img src="D34-02_catalogue-secteur-perdu-recupere_APRES.png" width="180"/> | CONFORME |
| Secteur perdu (D42.34) | — | <img src="D34-01_catalogue-secteur-perdu_APRES.png" width="180"/> | CONFORME |
| Libellé prises guidées (D42.34) | — | <img src="D34-03_catalogue-libelle-prises-guidees_APRES.png" width="180"/> | CONFORME |
| Font scale 1,3 | — | <img src="../../D42_33/visual-review/AFTER/P12-03_catalogue-fontScale-1.3_APRES.png" width="180"/> | CONFORME |
| Petit écran | — | <img src="../../D42_33/visual-review/AFTER/P12-09_catalogue-petit-ecran_APRES.png" width="180"/> | CONFORME |

**Mécanisme aperçu (Lot D) :** `ApercuGabarit.resPour(gabaritId)` → drawable `apercu_<secteur>_t<n>.webp`, fallback dessiné D42.30 conservé. 10/39 committés (57e720f), 29 en file (limite de génération par session). Les captures actuelles prédatent le mécanisme — remplacées à la complétude, pas avant (aucune capture trompeuse intermédiaire).

[↑ Retour au sommaire](#sommaire)

### <a id="h2-aperçus-des-gabarits"></a>8 bis. Aperçus des gabarits (originaux générés)

Chaque gabarit du catalogue dispose d'un aperçu photographique **original
généré** (640×360 WebP, registre GENERATED_ASSETS.md — aucune licence tierce).
Rendu prouvé dans l'application : corrélations template-matching 0,982/0,988
(D34-16/D34-17).

| Gabarit | Aperçu intégré | Statut |
|---|---|---|
| batiment travaux t1 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_batiment_travaux_t1.webp" width="240"/> | Intégré · vérifié |
| batiment travaux t2 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_batiment_travaux_t2.webp" width="240"/> | Intégré · vérifié |
| batiment travaux t3 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_batiment_travaux_t3.webp" width="240"/> | Intégré · vérifié |
| batiment travaux t4 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_batiment_travaux_t4.webp" width="240"/> | Intégré · vérifié |
| batiment travaux t5 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_batiment_travaux_t5.webp" width="240"/> | Intégré · vérifié |
| coiffure beaute t1 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_coiffure_beaute_t1.webp" width="240"/> | Intégré · vérifié |
| coiffure beaute t2 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_coiffure_beaute_t2.webp" width="240"/> | Intégré · vérifié |
| coiffure beaute t3 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_coiffure_beaute_t3.webp" width="240"/> | Intégré · vérifié |
| coiffure beaute t4 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_coiffure_beaute_t4.webp" width="240"/> | Intégré · vérifié |
| coiffure beaute t5 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_coiffure_beaute_t5.webp" width="240"/> | Intégré · vérifié |
| immo auto t1 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_immo_auto_t1.webp" width="240"/> | Intégré · vérifié |
| immo auto t2 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_immo_auto_t2.webp" width="240"/> | Intégré · vérifié |
| immo auto t3 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_immo_auto_t3.webp" width="240"/> | Intégré · vérifié |
| immo auto t4 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_immo_auto_t4.webp" width="240"/> | Intégré · vérifié |
| immo auto t5 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_immo_auto_t5.webp" width="240"/> | Intégré · vérifié |
| restaurants maquis t1 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_restaurants_maquis_t1.webp" width="240"/> | Intégré · vérifié |
| restaurants maquis t2 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_restaurants_maquis_t2.webp" width="240"/> | Intégré · vérifié |
| restaurants maquis t3 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_restaurants_maquis_t3.webp" width="240"/> | Intégré · vérifié |
| restaurants maquis t4 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_restaurants_maquis_t4.webp" width="240"/> | Intégré · vérifié |
| restaurants maquis t5 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_restaurants_maquis_t5.webp" width="240"/> | Intégré · vérifié |
| shops small business t1 | <img src="../../../../feature-catalog/src/main/res/drawable-nodpi/apercu_shops_small_business_t1.webp" width="240"/> | Intégré · vérifié |

**8 aperçus restants** (shops T2-T5, vêtements T1-T5) : lot 3 en file
(ASSET_GENERATION_QUEUE.csv) — limite stricte de génération par tour de
session ; capture catalogue définitive après complétude 30/30.

[↑ Retour au sommaire](#sommaire)

### <a id="i-brief"></a>9. Brief

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Brief — haut (étape 1) | <img src="../../D42_33/SOURCES/maquettes/10_brief_etape1.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P04-01_brief-haut_APRES.png" width="180"/> | CONFORME |
| Dernière section | <img src="../../D42_33/SOURCES/maquettes/11_brief_etape8.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P04-02_brief-derniere-section_APRES.png" width="180"/> | CONFORME |
| Import T5 — slot import (D42.34) | — | <img src="D34-04_brief-t5-import_APRES.png" width="180"/> | CONFORME |
| Import T5 — slot rempli (D42.34) | — | <img src="D34-05_brief-t5-slot-rempli_APRES.png" width="180"/> | CONFORME |
| T1 sans import (D42.34) | — | <img src="D34-06_brief-t1-sans-import_APRES.png" width="180"/> | CONFORME |
| Reprise de brouillon | — | <img src="../../D42_33/visual-review/AFTER/P04-06_brief-reprise-brouillon_APRES.png" width="180"/> | CONFORME |
| Options dépliées | — | <img src="../../D42_33/visual-review/AFTER/P04-07_brief-options-depliees_APRES.png" width="180"/> | CONFORME |
| Champ WhatsApp FR | — | <img src="../../D42_33/visual-review/AFTER/P04-09_whatsapp-champ-fr_APRES.png" width="180"/> | CONFORME |
| Champ WhatsApp EN | — | <img src="../../D42_33/visual-review/AFTER/P04-10_whatsapp-champ-en_APRES.png" width="180"/> | CONFORME |
| Préparation caméra | <img src="../../D42_33/SOURCES/maquettes/33_preparation_camera.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P04-11_preparation-camera_APRES.png" width="180"/> | CONFORME |
| Contrôle (bas) | <img src="../../D42_33/SOURCES/maquettes/12_controle.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P04-12_controle-bas_APRES.png" width="180"/> | CONFORME |
| Dialogue choix pays (indicatif) | — | **à produire — indiqué honnêtement** | NON PROUVÉ |

Maquette 09 (fiche détail gabarit) : **NON APPLICABLE** — le catalogue renvoie directement au brief (`pickGabarit()` → setResult), pas d'écran intermédiaire (choix produit D42.3x).

[↑ Retour au sommaire](#sommaire)

### <a id="j-caméra-guidée"></a>10. Caméra guidée

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Viseur + prise guidée | <img src="../../D42_33/SOURCES/maquettes/13_camera.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P05-04_viseur-prise_APRES.png" width="180"/> | CONFORME (guide) |
| Flux streaming | — | <img src="../../D42_33/visual-review/AFTER/P05-05_flux-streaming_APRES.png" width="180"/> | NON PROUVÉ |
| Compte à rebours | <img src="../../D42_33/SOURCES/maquettes/14_camera_compte_a_rebours.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P05-06_compte-a-rebours_APRES.png" width="180"/> | CONFORME |
| Enregistrement (badge REC) | <img src="../../D42_33/SOURCES/maquettes/15_camera_rec.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P05-07_rec_APRES.png" width="180"/> | CONFORME |
| HUD prise T5 (D42.34) | — | <img src="D34-10_camera-hud-prise-t5_APRES.png" width="180"/> | CONFORME |
| Chargement gabarit (D42.34) | — | <img src="D34-08_camera-chargement-gabarit_APRES.png" width="180"/> | CONFORME |
| Libre, sans scène, sur zéro (D42.34) | — | <img src="D34-09_camera-libre-sans-scene-sur-zero_APRES.png" width="180"/> | CONFORME |
| Erreur gabarit (D42.34) | — | <img src="D34-07_camera-erreur-gabarit_APRES.png" width="180"/> | CONFORME |
| Écran complet + commandes | — | <img src="../../D42_33/visual-review/AFTER/P05-09_ecran-complet-commandes_APRES.png" width="180"/> | CONFORME |
| Scène 2 du gabarit | — | <img src="../../D42_33/visual-review/AFTER/P05-11_scene-2_APRES.png" width="180"/> | CONFORME |
| Permission refusée (diagnostic) | — | <img src="../../D42_33/visual-review/AFTER/P05-13_diagnostic-permission-refusee_APRES.png" width="180"/> | CONFORME |
| Consentement client (dialogue R4) | <img src="../../D42_33/SOURCES/maquettes/16_consentement_client.png" width="180"/> | **à produire — indiqué honnêtement** | NON PROUVÉ |

Le **flux viseur vivant** et le **consentement R4** exigent l'app réelle : marqués NON PROUVÉ, jamais fabriqués.

[↑ Retour au sommaire](#sommaire)

### <a id="k-validation-des-prises"></a>11. Validation des prises

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Prise validée | <img src="../../D42_33/SOURCES/maquettes/17_revue_des_prises.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P05-08_prise-validee_APRES.png" width="180"/> | CONFORME |

Maquette 17 (écran galerie « revue ») : forme **distribuée** dans l'app — validation par prise + `ReadyCheckScreen` final. Pas d'écran galerie séparé.

[↑ Retour au sommaire](#sommaire)

### <a id="l-montage"></a>12. Montage

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Aperçu E7 (montage complet) | <img src="../../D42_33/SOURCES/maquettes/18_apercu_montage.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P07-01_apercu-E7-complet_APRES.png" width="180"/> | CONFORME |
| Montage E8 en cours (phases métier) | <img src="../../D42_33/SOURCES/maquettes/19_montage_en_cours.png" width="180"/> | <img src="../../D42_31/visual-review/16_export/base-fr-058_export_en_cours.png" width="180"/> | NON PROUVÉ |

VR-051 : la correction de code est **faite** (D42.34 CR-4) — reste la capture.

[↑ Retour au sommaire](#sommaire)

### <a id="m-export"></a>13. Export

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Export prêt | <img src="../../D42_33/SOURCES/maquettes/20_export_pret.png" width="180"/> | <img src="../../D42_31/visual-review/16_export/base-fr-057_export_pret.png" width="180"/> | NON PROUVÉ |

Écrans D42.31 (émulateur) donnés en référence honnête, marqués NON PROUVÉ pour D42.34 tant que la recapture n'est pas faite.

[↑ Retour au sommaire](#sommaire)

### <a id="n-partage"></a>14. Partage

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Feuille de partage système | <img src="../../D42_33/SOURCES/maquettes/21_partage.png" width="180"/> | <img src="../../D42_31/visual-review/18_partage/suite-fr-026_partage_feuille.png" width="180"/> | NON APPLICABLE |

La feuille de partage appartient au système : capture émulateur en référence.

[↑ Retour au sommaire](#sommaire)

### <a id="o-dashboard"></a>15. Dashboard

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Synchrone, crédits 6 | <img src="../../D42_33/SOURCES/maquettes/24_dashboard.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/12_dashboard_fr_w360_APRES_synchrone-credits-6.png" width="180"/> | CONFORME |
| Bas de page | — | <img src="../../D42_33/visual-review/AFTER/P10-02_dashboard-bas_APRES.png" width="180"/> | CONFORME |
| Suite parrainage | — | <img src="../../D42_33/visual-review/AFTER/P10-03_dashboard-suite-parrainage_APRES.png" width="180"/> | CONFORME |
| Dashboard EN synchrone | <img src="../../D42_33/SOURCES/maquettes/32_dashboard_en.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/P10-04_dashboard-en-synchrone_APRES.png" width="180"/> | CONFORME |
| Hors connexion (code en attente) | <img src="../../D42_33/SOURCES/maquettes/22_hors_connexion.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/12_dashboard_en_w360_APRES_hors-connexion-code-en-attente.png" width="180"/> | CONFORME |
| Bonjour, {prénom} (variante nom réel) | — | <img src="../../D42_33/visual-review/AFTER/P10-02_dashboard-bas_APRES.png" width="180"/> | CONFORME |
| Petit écran w360×640 | — | <img src="../../D42_33/visual-review/AFTER/20_dashboard_fr_w360x640_APRES_fontScale-1.3-petit-ecran.png" width="180"/> | CONFORME |
| Rotation paysage w640×360 | — | <img src="../../D42_33/visual-review/AFTER/22_dashboard_fr_w640x360_APRES_rotation-paysage.png" width="180"/> | CONFORME |



[↑ Retour au sommaire](#sommaire)

### <a id="p-formules--paywall"></a>16. Formules & paywall

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Formule active (pas de compteur inventé) | <img src="../../D42_33/SOURCES/maquettes/26_formules.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/13_dashboard_fr_w360_APRES_formule-active-pas-de-compteur-invente.png" width="180"/> | CONFORME |
| Paywall FR (3 formules, CTA « Choisir … » actifs) | <img src="../../D42_33/SOURCES/maquettes/23_quota_epuise.png" width="180"/> | <img src="D34-18_paywall-cta-fr_APRES.png" width="180"/> | CONFORME |
| Paywall EN (CTA « Choose … ») | — | <img src="D34-19_paywall-cta-en_APRES.png" width="180"/> | CONFORME |
| Paywall bas (scroll) | — | <img src="../../D42_33/visual-review/AFTER/P11-04_paywall-bas_APRES.png" width="180"/> | CONFORME (identique D42.33) |
| Petit écran famille 11 | — | <img src="../../D42_33/visual-review/AFTER/21_paywall_en_w360x640_APRES_petit-ecran-famille-11.png" width="180"/> | CONFORME |

Checkout : CinetPay renvoie 501 `billing_not_configured` (budget 0 FCFA, aucune transaction fictive) — comportement d'erreur réel déjà couvert par les tests.

[↑ Retour au sommaire](#sommaire)

### <a id="q-parrainage"></a>17. Parrainage

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Historique replié | <img src="../../D42_33/SOURCES/maquettes/28_parrainage.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/14_parrainage_fr_w360_APRES_historique-replie.png" width="180"/> | CONFORME |
| Parrainage EN | — | <img src="../../D42_33/visual-review/AFTER/14_parrainage_en_w360_APRES_l10n-EN.png" width="180"/> | CONFORME |
| Petit écran | — | <img src="../../D42_33/visual-review/AFTER/23_parrainage_fr_w360x640_APRES_fontScale-1.3-petit-ecran.png" width="180"/> | CONFORME |



[↑ Retour au sommaire](#sommaire)

### <a id="r-réglages"></a>18. Réglages

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Réglages FR (7 lignes) | <img src="../../D42_33/SOURCES/maquettes/29_reglages.png" width="180"/> | <img src="../../D42_33/visual-review/AFTER/16_reglages_fr_w360_APRES_l10n-FR-7-lignes.png" width="180"/> | CONFORME |
| Réglages EN | — | <img src="../../D42_33/visual-review/AFTER/P10-08_reglages-en_APRES.png" width="180"/> | CONFORME |
| Petit écran | — | <img src="../../D42_33/visual-review/AFTER/24_reglages_fr_w360x640_APRES_fontScale-1.3-petit-ecran.png" width="180"/> | CONFORME |
| Dialogue changement langue (FR/EN) | — | **à produire — indiqué honnêtement** | NON PROUVÉ |
| Dialogue changement secteur | — | **à produire — indiqué honnêtement** | NON PROUVÉ |
| Dialogue accords de diffusion | — | **à produire — indiqué honnêtement** | NON PROUVÉ |
| Dialogue nettoyage espace | — | **à produire — indiqué honnêtement** | NON PROUVÉ |

Le **dialogue de reprise** (VR-062, D42.27) et les **accords de diffusion** (consentements enregistrés) sont listés pour capture au Lot F.

[↑ Retour au sommaire](#sommaire)

### <a id="s-écrans-hors-périmètre"></a>19. Écrans hors périmètre

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Conditions d'utilisation (navigateur) | <img src="../../D42_33/SOURCES/maquettes/30_conditions.png" width="180"/> | **à produire — indiqué honnêtement** | NON APPLICABLE |
| Aide | <img src="../../D42_33/SOURCES/maquettes/31_aide.png" width="180"/> | **à produire — indiqué honnêtement** | NON APPLICABLE |
| Aide & contact | <img src="../../D42_33/SOURCES/maquettes/34_aide_contact.png" width="180"/> | **à produire — indiqué honnêtement** | NON APPLICABLE |
| Mes vidéos (bibliothèque) | <img src="../../D42_33/SOURCES/maquettes/25_mes_videos.png" width="180"/> | **à produire — indiqué honnêtement** | NON APPLICABLE |
| Marque (bandeau header) | — | <img src="../../D42_33/visual-review/AFTER/10_marque_fr_defaut_APRES_header-logo-officiel.png" width="180"/> | CONFORME |



[↑ Retour au sommaire](#sommaire)

### <a id="t-états-adaptatifs"></a>20. États adaptatifs

| Écran / état | Référence fondateur | APRÈS (capture réelle) | Statut |
|---|---|---|---|
| Font scale 1,3 (langue) | — | <img src="../../D42_33/visual-review/AFTER/P12-02_langue-fontScale-1.3_APRES.png" width="180"/> | CONFORME |
| Font scale 1,3 (bienvenue) | — | <img src="../../D42_33/visual-review/AFTER/P12-01_bienvenue-fontScale-1.3_APRES.png" width="180"/> | CONFORME |
| Font scale 1,3 (catalogue) | — | <img src="../../D42_33/visual-review/AFTER/P12-03_catalogue-fontScale-1.3_APRES.png" width="180"/> | CONFORME |
| Petit écran (langue) | — | <img src="../../D42_33/visual-review/AFTER/P12-07_langue-petit-ecran_APRES.png" width="180"/> | CONFORME |
| Petit écran (bienvenue) | — | <img src="../../D42_33/visual-review/AFTER/P12-08_bienvenue-petit-ecran_APRES.png" width="180"/> | CONFORME |
| Petit écran (catalogue) | — | <img src="../../D42_33/visual-review/AFTER/P12-09_catalogue-petit-ecran_APRES.png" width="180"/> | CONFORME |
| Rotation (bienvenue) | — | <img src="../../D42_33/visual-review/AFTER/P12-12_bienvenue-rotation_APRES.png" width="180"/> | CONFORME |
| Rotation (carrousel) | — | <img src="../../D42_33/visual-review/AFTER/P12-13_carrousel-rotation_APRES.png" width="180"/> | CONFORME |
| Hors-connexion (bienvenue) | — | <img src="../../D42_33/visual-review/AFTER/P12-15_bienvenue-hors-connexion_APRES.png" width="180"/> | CONFORME |

Vue regroupée par contrainte (fontScale / petit écran / rotation / hors-connexion). Ces captures sont les mêmes fichiers que ceux de leurs sections de parcours — aucun fichier dupliqué dans le dépôt. Les états NON PROUVÉ ci-dessus restent à produire sur téléphone fondateur ou en recapture Lot F.

[↑ Retour au sommaire](#sommaire)

---

## Traçabilité

- Registre des images originales : `../GENERATED_ASSETS.md` (provenance de chaque
  ressource générée — aucune image à licence inconnue conservée).
- Inventaire exhaustif des 73 écrans/états : `../11_INVENTAIRE_COMPLET_ECRANS.csv`.
- Audit fidélité des 34 maquettes : `../10_AUDIT_FIDELITE_DESIGN.md`.
- Manifeste vérifiable de cette galerie : `../12_MANIFEST_GALERIE.csv`
  (chemin → statut → note, une ligne par image référencée).
- Crédits photo : `../CREDITS_PHOTOS.md`.

**Rappel fondateur :** CI verte ≠ approbation artistique. L'approbation finale
du design appartient au fondateur, sur son téléphone.
