# Parcours et liaisons — document pour coder

**État :** 197 captures statiques, dont 34 écrans ou états communs et 163 captures propres aux 30 gabarits (30 E5, 103 E6, 30 E7). Les flèches ci-dessous sont des comportements à développer, pas des fonctions testées.

![Vue d’ensemble des liaisons](ressources/schema_parcours.png)

**À lire en complément :** [liaisons_gabarits.md](liaisons_gabarits.md) donne, pour les 30 combinaisons, chaque capture E6 dans l’ordre et son retour. Les captures sont dans `ecrans/`.

## Tarifs affichés dans les maquettes

| Formule | UEMOA — E9A | Afrique hors UEMOA / monde — E9B et E9C |
|---|---:|---:|
| Pass 24 h | 500 FCFA | ≈ 0,76 € |
| Pro / 30 jours | 3 000 FCFA | ≈ 4,57 € |
| Boutique / 30 jours | 7 500 FCFA | ≈ 11,43 € |

Conversion mathématique arrondie à deux décimales, à la parité fixe officielle de **1 EUR = 655,957 XOF** ([BCEAO](https://www.bceao.int/fr/cours/cours-des-devises-contre-Franc-CFA-appliquer-aux-transferts)). Les montants EUR sont indicatifs pour illustrer les deux zones hors UEMOA : la devise de facturation réelle, le barème commercial final, les taxes, les frais et les éventuels tarifs USD ou locaux restent à valider. Ne pas déduire la devise de la langue.

## Conventions

- Les noms E1, E3, E10, etc. renvoient aux fichiers JPG du même nom dans `ecrans/`.
- Les deux états d’une case (ex. E4b et E4b_Ready) représentent un même écran interactif, pas deux formulaires différents.
- « Service externe / à concevoir » indique explicitement une étape dont aucune maquette complète ni fonction réelle n’est livrée.
- La flèche retour préserve le contexte tant que la session de travail reste ouverte ; la reprise d’un brouillon après fermeture n’est pas promise.

## 1. Entrée, connexion et retour

| Départ | Action / condition | Destination ou comportement à coder |
|---|---|---|
| E1_Splash_Langue | Choisir une langue puis Continuer. | E1b_Onboarding_Slide1. Depuis les réglages, prévoir une flèche retour et revenir à E12 au lieu de relancer l’entrée. |
| E1b_Onboarding_Slide1 | Suivant ; Passer ; flèche retour. | Slide2 ; E2 ; E1, respectivement. |
| E1b_Onboarding_Slide2 | Suivant ; Passer ; flèche retour. | Slide3 ; E2 ; Slide1. |
| E1b_Onboarding_Slide3 | C’est parti ou Passer ; flèche retour. | E2 ; Slide2. |
| E2_Connexion_Google | Continuer avec Google ; nouveau profil. | Service Google externe, puis E3a_Secteur_Vide après connexion réussie. |
| E2_Connexion_Google | Compte reconnu et configuration terminée. | E10_Dashboard, sans refaire E1/E1b/E3. |
| E2_Connexion_Google | Inscription inachevée ; annulation ou erreur. | Reprendre la dernière étape enregistrée (E3a, E3b, E3c ou E4) ; si échec, rester sur E2 et proposer de réessayer. |
| Démarrage | Session valide / expirée. | Compte configuré : E10 direct si session valide. Sinon E2, puis E10 ou dernière étape enregistrée selon l’état du compte. |

## 2. Secteur et parrainage à l’inscription

| Départ | Action / condition | Destination ou comportement à coder |
|---|---|---|
| E3a_Secteur_Vide | Choisir un métier ; Continuer sans choix. | E3a_Secteur_Selectionne ; le bouton reste désactivé tant qu’aucun secteur n’est choisi. |
| E3a_Secteur_Selectionne | Continuer ; flèche retour. | E3b_Code_Parrain ; E2. Enregistrer le choix avant la suite. |
| E3b_Code_Parrain | Code valide ; code invalide ; Je n’ai pas de code. | E3b_Code_Parrain_Valide ; rester sur E3b avec erreur ; E3c_Compte_En_Cours sans code. |
| E3b_Code_Parrain_Valide | Continuer ; flèche retour. | E3c_Compte_En_Cours ; E3a avec secteur choisi. Le code entré est facultatif. |
| E3c_Compte_En_Cours | Création terminée ; erreur de création. | E4_Catalogue ; rester sur cet état et prévoir un message/réessai non maquettés. |

## 3. Vidéo : du catalogue au tournage

| Départ | Action / condition | Destination ou comportement à coder |
|---|---|---|
| E10_Dashboard | Créer. | E4_Catalogue, avec le secteur du compte. |
| E4_Catalogue | Choisir l’un des cinq formats puis Continuer. | E5_{secteur}_{format}_Brief correspondant au choix. Changer de métier → S3_Changer_Secteur. |
| E4_Catalogue | Flèche retour, une fois le compte configuré. | E10_Dashboard ; ne pas rouvrir l’écran de création du compte. |
| E5_*_Brief | Continuer avec champs requis valides ; flèche retour. | E4b_Controle_Avant_Tournage ; E4. La valeur et la devise du produit restent celles choisies pour cette vidéo. |
| E4b_Controle_Avant_Tournage | Cocher la case ; sans coche. | E4b_Ready ; bouton inactif tant que la case n’est pas cochée. Retour → E5 correspondant. |
| E4b_Ready | OK, je commence. | Si autorisations manquantes : P1. Sinon, si T5 avec personne filmée : E6bis. Sinon première capture E6 du gabarit. |
| P1_Permissions_Explication | Autoriser ; retour. | P2_Systeme_Android ; E4b_Ready. |
| P2_Systeme_Android | Caméra autorisée / refusée. | Si T5 : E6bis, sinon première capture E6 ; en cas de refus caméra : P3_Refus_Camera. |
| P3_Refus_Camera | Ouvrir les réglages ; flèche retour. | Réglages du téléphone puis vérifier de nouveau les autorisations ; retour à E4b. Ne pas promettre un brouillon sauvegardé. |
| E6bis_Consentement_Client | Oui, accord confirmé ; Non, ne pas publier. | Première prise E6 du T5 ; retour au brief E5 sans tourner ni publier le témoignage. |
| E6_* | Tourner, Refaire, Suivant. | Refaire la même prise ; Suivant passe au segment de guide ou à la prise suivante dans le JSON. Après la dernière prise → E7b. |
| E6_* | Flèche retour. | État caméra précédent ; depuis le premier état, retour à E4b_Ready. Garder l’état courant si la session est encore ouverte. |

## 4. Vérification, montage et export

| Départ | Action / condition | Destination ou comportement à coder |
|---|---|---|
| E7b_Controle_Avant_Montage | Case non cochée / cochée ; retour. | OK inactif / E7b_Montage_OK ; retour à la dernière prise E6. |
| E7b_Montage_OK | OK, je passe au montage. | E7_{secteur}_{format}_Editeur correspondant. Décocher → contrôle non validé. |
| E7_*_Editeur | Créer ma vidéo ; flèche retour. | E8_Export_Progression ; E7b_Controle_Avant_Montage. |
| E8_Export_Progression | Export terminé / échoué. | E8_Export_Succes / E8_Export_Erreur. État calculé, pas un bouton. |
| E8_Export_Erreur | Réessayer ; flèche retour. | E8_Export_Progression ; E7 correspondant, si l’état de travail est encore disponible. |
| E8_Export_Succes | Voir ma vidéo ; Partager ; Tableau de bord. | Lecteur ou feuille de partage du téléphone (non maquettés) ; E10_Dashboard pour le retour. |

## 5. Région, formules et paiement

| Départ | Action / condition | Destination ou comportement à coder |
|---|---|---|
| E10_Dashboard | Acheter ; quota épuisé à la création. | O3_Choisir_Region. Le retour au travail en cours après achat n’est pas garanti. |
| O3_Choisir_Region | Choisir une zone puis Confirmer la région. | UEMOA → E9A_Paywall_UEMOA ; Afrique hors UEMOA → E9B_Paywall_Afrique ; reste du monde → E9C_Paywall_Monde. |
| E9A_Paywall_UEMOA | Choisir formule et moyen de paiement ; Continuer. | Prestataire de paiement externe à intégrer. Montants XOF, Mobile Money ou carte selon disponibilité. |
| E9B_Paywall_Afrique | Choisir formule et carte ; Continuer. | Prestataire externe ; les euros affichés sont une conversion indicative à valider. |
| E9C_Paywall_Monde | Choisir formule et carte ; Continuer. | Prestataire externe ; les euros affichés sont une conversion indicative à valider. |
| E9A / E9B / E9C | Paiement accepté, vérifié côté serveur ; refus/annulation ; retour. | Mettre à jour les droits une seule fois puis E10. Sinon revenir au même paywall ; flèche retour → O3. |

## 6. Parrainage, réglages et changement de métier

| Départ | Action / condition | Destination ou comportement à coder |
|---|---|---|
| E10_Dashboard | Parrainage ; Voir mes filleuls ; Réglages. | E11_Parrainage ; S1_Historique_Filleuls ; E12_Reglages. |
| E10_Dashboard / E11_Parrainage | Copier ; Partager sur WhatsApp. | Presse-papiers ou partage externe ; revenir à l’écran d’origine. |
| E11_Parrainage | Flèche retour. | E10_Dashboard. |
| S1_Historique_Filleuls | Flèche retour. | E10 ou E12 selon l’écran d’origine. |
| E12_Reglages | Langue / Voir tes filleuls / Accords / Modifier le secteur. | E1 en mode réglages, avec retour direct à E12 / S1 / S2_Consentements / S3_Changer_Secteur. |
| E12_Reglages | Déconnexion ; effacer les prises brutes. | Après confirmation à concevoir : fermer la session et aller sur E2 ; pour la suppression, demander confirmation avant action. |
| S2_Consentements | Retirer un accord ; flèche retour. | Mettre à jour l’accord après confirmation à concevoir ; retour E12. Ne pas supposer qu’une vidéo externe est automatiquement retirée. |
| S3_Changer_Secteur | Choisir un autre secteur ; Annuler ou retour. | S3_Confirmer_Changement ; Annuler retourne à E4 ou E12 selon l’origine, sans changement. |
| S3_Confirmer_Changement | Oui, changer ; Garder mon secteur. | Après sauvegarde, retourner à l’origine avec catalogue actualisé ; sinon revenir à S3 sans modifier le secteur. Les vidéos existantes restent. |
| O2_Conflit_Synchronisation | Voir les deux versions. | Comparaison et choix de version à concevoir ; ne rien écraser avant confirmation. Synchronisation non implémentée. |

## 7. Règles de données et points à valider

### Continuité du compte

Conserver côté compte l’identifiant Google stable, la langue, le secteur, le code de parrainage attribué, la formule et la dernière étape d’inscription réussie. Après chaque étape validée, enregistrer la prochaine étape à reprendre. Session valide + compte configuré : E10. Session expirée : E2, puis le compte reconnu.

### Brouillon vidéo et données du produit

Les champs d’une vidéo, son prix et sa monnaie sont distincts des données du compte et des tarifs d’abonnement. Les JSON ne prévoient pas leur sauvegarde dans le profil. Conserver en mémoire pendant la navigation si possible, sans promettre de reprise après fermeture forcée.

### Codes de parrainage

La saisie d’un code de parrain facultatif a lieu uniquement sur E3b après le secteur. Distinguer le code reçu à l’inscription du code personnel à partager depuis E10/E11. Pas de champ de parrain sur E3a, les briefs ou les paywalls.

### Vérifications OK

Avant le tournage et avant le montage, laisser le bouton OK inactif sans coche. Une fois coché, l’état correspondant devient E4b_Ready ou E7b_Montage_OK. La case peut être décochée.

### Permissions et consentement

Caméra et micro dépendent des permissions réelles du système, dont le texte exact peut varier. Pour T5, obtenir l’accord explicite de filmer et publier avant le tournage. Une option sans parole après refus du micro reste à concevoir.

### Paiements

Ne pas déduire le succès d’un simple retour du prestataire. Vérifier le paiement côté serveur, empêcher les doubles activations et conserver le prix, la devise et la formule confirmés. Disponibilité des opérateurs, taxes, frais et prix commerciaux restent à valider.

### États à concevoir

Le paiement externe et ses résultats détaillés, le lecteur et le partage système, la comparaison O2, les confirmations de suppression/déconnexion et certains messages d’erreur ne sont pas dessinés. Ils ne doivent pas être présentés comme déjà implémentés.

## 8. Correspondance des 30 gabarits

La liste complète, avec les 103 états caméra et leurs précédents/suivants exacts, est dans [liaisons_gabarits.md](liaisons_gabarits.md). `SCxx` est un segment de guide de parole pour la même prise : ce n’est pas une nouvelle prise à filmer à chaque fois.

| Secteur | Format | Entrée et sortie correspondantes | Nombre d’états caméra |
|---|---|---|---:|
| Vêtements et Mode | T1 — Nouvel arrivage | `E5_vetements_mode_T1_Brief` → `E7_vetements_mode_T1_Editeur` | 3 |
| Vêtements et Mode | T2 — Avant et après | `E5_vetements_mode_T2_Brief` → `E7_vetements_mode_T2_Editeur` | 3 |
| Vêtements et Mode | T3 — Montrer un produit | `E5_vetements_mode_T3_Brief` → `E7_vetements_mode_T3_Editeur` | 3 |
| Vêtements et Mode | T4 — Promotion | `E5_vetements_mode_T4_Brief` → `E7_vetements_mode_T4_Editeur` | 2 |
| Vêtements et Mode | T5 — Un client raconte | `E5_vetements_mode_T5_Brief` → `E7_vetements_mode_T5_Editeur` | 5 |
| Coiffure et Beauté | T1 — Nouvel arrivage | `E5_coiffure_beaute_T1_Brief` → `E7_coiffure_beaute_T1_Editeur` | 3 |
| Coiffure et Beauté | T2 — Avant et après | `E5_coiffure_beaute_T2_Brief` → `E7_coiffure_beaute_T2_Editeur` | 3 |
| Coiffure et Beauté | T3 — Montrer un produit | `E5_coiffure_beaute_T3_Brief` → `E7_coiffure_beaute_T3_Editeur` | 3 |
| Coiffure et Beauté | T4 — Promotion | `E5_coiffure_beaute_T4_Brief` → `E7_coiffure_beaute_T4_Editeur` | 2 |
| Coiffure et Beauté | T5 — Un client raconte | `E5_coiffure_beaute_T5_Brief` → `E7_coiffure_beaute_T5_Editeur` | 6 |
| Restaurants et Maquis | T1 — Nouvel arrivage | `E5_restaurants_maquis_T1_Brief` → `E7_restaurants_maquis_T1_Editeur` | 3 |
| Restaurants et Maquis | T2 — Avant et après | `E5_restaurants_maquis_T2_Brief` → `E7_restaurants_maquis_T2_Editeur` | 4 |
| Restaurants et Maquis | T3 — Montrer un produit | `E5_restaurants_maquis_T3_Brief` → `E7_restaurants_maquis_T3_Editeur` | 3 |
| Restaurants et Maquis | T4 — Promotion | `E5_restaurants_maquis_T4_Brief` → `E7_restaurants_maquis_T4_Editeur` | 2 |
| Restaurants et Maquis | T5 — Un client raconte | `E5_restaurants_maquis_T5_Brief` → `E7_restaurants_maquis_T5_Editeur` | 5 |
| Bâtiment et Travaux | T1 — Nouvel arrivage | `E5_batiment_travaux_T1_Brief` → `E7_batiment_travaux_T1_Editeur` | 3 |
| Bâtiment et Travaux | T2 — Avant et après | `E5_batiment_travaux_T2_Brief` → `E7_batiment_travaux_T2_Editeur` | 4 |
| Bâtiment et Travaux | T3 — Montrer un produit | `E5_batiment_travaux_T3_Brief` → `E7_batiment_travaux_T3_Editeur` | 3 |
| Bâtiment et Travaux | T4 — Promotion | `E5_batiment_travaux_T4_Brief` → `E7_batiment_travaux_T4_Editeur` | 3 |
| Bâtiment et Travaux | T5 — Un client raconte | `E5_batiment_travaux_T5_Brief` → `E7_batiment_travaux_T5_Editeur` | 6 |
| Maisons et Voitures | T1 — Nouvel arrivage | `E5_immo_auto_T1_Brief` → `E7_immo_auto_T1_Editeur` | 3 |
| Maisons et Voitures | T2 — Avant et après | `E5_immo_auto_T2_Brief` → `E7_immo_auto_T2_Editeur` | 3 |
| Maisons et Voitures | T3 — Montrer un produit | `E5_immo_auto_T3_Brief` → `E7_immo_auto_T3_Editeur` | 3 |
| Maisons et Voitures | T4 — Promotion | `E5_immo_auto_T4_Brief` → `E7_immo_auto_T4_Editeur` | 2 |
| Maisons et Voitures | T5 — Un client raconte | `E5_immo_auto_T5_Brief` → `E7_immo_auto_T5_Editeur` | 6 |
| Boutiques | T1 — Nouvel arrivage | `E5_shops_small_business_T1_Brief` → `E7_shops_small_business_T1_Editeur` | 3 |
| Boutiques | T2 — Avant et après | `E5_shops_small_business_T2_Brief` → `E7_shops_small_business_T2_Editeur` | 3 |
| Boutiques | T3 — Montrer un produit | `E5_shops_small_business_T3_Brief` → `E7_shops_small_business_T3_Editeur` | 3 |
| Boutiques | T4 — Promotion | `E5_shops_small_business_T4_Brief` → `E7_shops_small_business_T4_Editeur` | 2 |
| Boutiques | T5 — Un client raconte | `E5_shops_small_business_T5_Brief` → `E7_shops_small_business_T5_Editeur` | 6 |

## 9. Recette à réaliser pendant le développement

Ce sont des contrôles proposés, **pas des tests de l’application déjà exécutés**.

| Scénario | À essayer | Résultat attendu |
|---|---|---|
| Compte nouveau | Connexion Google réussie pour la première fois. | E3a puis E3b facultatif, E3c et E4 ; pas de saisie de parrain avant le secteur. |
| Compte existant | Ouvrir avec session valide, puis simuler expiration. | Session valide : E10 direct. Après expiration : E2 puis E10 pour le même compte configuré. |
| Inscription interrompue | Interrompre après la sauvegarde du secteur ou du code. | Après reconnexion, reprendre à la dernière étape enregistrée, sans refaire le début. |
| Six secteurs | Changer de métier depuis E4 ou E12 puis annuler et confirmer. | Annulation sans changement ; confirmation actualise le secteur et le catalogue, sans supprimer les vidéos existantes. |
| Trente gabarits | Pour chaque secteur × format, suivre E5 et toutes les captures E6. | Bon E7 ; ordre JSON respecté ; SC d’une même prise ne compte pas comme une nouvelle prise physique. |
| Contrôles OK | Laisser chaque case décochée avant tournage et montage. | Le bouton OK reste désactivé jusqu’à la coche ; le retour reste disponible. |
| Accord et permissions | Refuser la caméra ou refuser l’accord client T5. | Pas de tournage caméra refusée ; pas de témoignage filmé ou publié sans accord. |
| Trois régions et paiement | Choisir UEMOA, Afrique hors UEMOA et monde ; simuler succès puis refus. | La bonne maquette E9 s’affiche ; aucun droit n’est activé sur simple retour ou refus ; succès vérifié côté serveur. |
| Sortie et export | Simuler réussite puis erreur de montage. | Succès : lecture, partage ou retour E10 ; erreur : réessayer ou revenir à l’aperçu. |

Maquettes conceptuelles seulement : Google, persistance, paiement, synchronisation et moteur vidéo ne sont ni construits ni testés dans ce livrable.
