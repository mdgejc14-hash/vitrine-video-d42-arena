# Vitrine Vidéo — maquettes conceptuelles mobile 9:16

**État :** maquettes statiques de conception. Aucune application ni fonctionnalité n’est présentée comme construite ou testée.

**Design :** logo fourni; navy `#022358`, orange `#F95C0F`, blanc et gris clair; typographie sans sérif; contraste élevé; cartes et contrôles mobiles cohérents; retours visibles sur les écrans internes.

**Copywriting :** les écrans parlent avec la saveur demandée — tutoiement, phrases simples, bénéfice d’abord, ton direct et rassurant. Les textes visibles des 30 variantes E5/E6/E7 sont adaptés pour l’interface; champs, IDs, ordre, scènes, prises et cadrages proviennent toujours des JSON source, qui restent intacts pour ne pas changer les tests.

**Parcours :** première visite : E1 langue → onboarding 1/3 (Passer va à E2) → E2 Google; nouveau compte → E3a secteur → E3b code facultatif → E3c → E4. Compte déjà configuré : E2 ou session active → E10; inscription interrompue : reprise à la dernière étape enregistrée, sans refaire le début.

**E5/E6/E7 :** 30 briefs, 103 écrans caméra correspondant aux prises et segments, 30 aperçus/éditeurs. E6 garde les prises muettes sans consigne orale; les exemples de parole sont balisés « pas à répéter ». T5 conserve accord explicite du client, citation facultative et questions neutres.

**Visuels et tarifs :** les trois photos fournies E1, E2 et E3 remplacent les visuels précédents sur les trois slides d’entrée, dans cet ordre. Six illustrations métiers en 3D sont reprises dans E3a et S3; le code parrain se saisit sur E3b seulement. E9A garde les tarifs UEMOA en FCFA; E9B/E9C affichent leurs équivalents en EUR (0,76 € / 4,57 € / 11,43 €), au taux fixe BCEAO de 655,957 FCFA pour 1 EUR ([source](https://www.bceao.int/fr/cours/cours-des-devises-contre-Franc-CFA-appliquer-aux-transferts)). Ces équivalents ne fixent pas le prix commercial final ni les frais de carte.

**Total : 197 écrans individuels en 1080 × 1920 px.**

## Phase 1 — Entrée — E1_Splash_Langue

![E1_Splash_Langue](ecrans/E1_Splash_Langue.jpg)

Logo source, drapeaux FR/UK/ES/JP, sélection visible et rappel « Tu pourras changer ce choix plus tard ».

## Phase 1 — Entrée — E1b_Onboarding_Slide1

![E1b_Onboarding_Slide1](ecrans/E1b_Onboarding_Slide1.jpg)

Photo fournie E1 intégrée au premier défilement; texte sur les clients, WhatsApp, TikTok, le produit, le prix et la vente directe.

## Phase 1 — Entrée — E1b_Onboarding_Slide2

![E1b_Onboarding_Slide2](ecrans/E1b_Onboarding_Slide2.jpg)

Photo fournie E2 intégrée dans le cadre 9:16; texte sur les infos simples, la langue libre et l’exemple à comprendre, pas à réciter.

## Phase 1 — Entrée — E1b_Onboarding_Slide3

![E1b_Onboarding_Slide3](ecrans/E1b_Onboarding_Slide3.jpg)

Photo fournie E3 intégrée au troisième défilement; texte sur les trois vidéos offertes et les invitations Pro.

## Phase 1 — Entrée — E2_Connexion_Google

![E2_Connexion_Google](ecrans/E2_Connexion_Google.jpg)

Google sert à créer le compte la première fois ou à retrouver un compte existant; après connexion, un compte déjà configuré va vers le tableau de bord.

## Phase 1 — Entrée — E3a_Secteur_Vide

![E3a_Secteur_Vide](ecrans/E3a_Secteur_Vide.jpg)

Les six secteurs sont illustrés par des objets en 3D; Continuer reste grisé sans choix.

## Phase 1 — Entrée — E3a_Secteur_Selectionne

![E3a_Secteur_Selectionne](ecrans/E3a_Secteur_Selectionne.jpg)

État sélectionné de Restaurants et Maquis; code parrain absent; Continuer devient actif.

## Phase 1 — Entrée — E3b_Code_Parrain

![E3b_Code_Parrain](ecrans/E3b_Code_Parrain.jpg)

Saisie unique et facultative du code parrain après le choix du secteur; retour vers E3a.

## Phase 1 — Entrée — E3b_Code_Parrain_Valide

![E3b_Code_Parrain_Valide](ecrans/E3b_Code_Parrain_Valide.jpg)

Exemple de code validé; la récompense est conditionnée à la prise d’un Pro.

## Phase 1 — Entrée — E3c_Compte_En_Cours

![E3c_Compte_En_Cours](ecrans/E3c_Compte_En_Cours.jpg)

État de chargement entre l’inscription et le catalogue; retour disponible.

## Phase 2 — Création — E4_Catalogue

![E4_Catalogue](ecrans/E4_Catalogue.jpg)

Cinq formats en mots simples, compteur des trois vidéos gratuites et accès pour changer de métier.

## Phase 2 — Création — E5_batiment_travaux_T1_Brief

![E5_batiment_travaux_T1_Brief](ecrans/E5_batiment_travaux_T1_Brief.jpg)

Brief Bâtiment & Travaux / Nouvel arrivage; 7 champs issus du JSON : Nom de votre commerce, Nom du travail à faire, Prix du travail, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_batiment_travaux_T2_Brief

![E5_batiment_travaux_T2_Brief](ecrans/E5_batiment_travaux_T2_Brief.jpg)

Brief Bâtiment & Travaux / Avant et après; 7 champs issus du JSON : Nom de votre commerce, Nom du travail à faire, Prix du travail, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_batiment_travaux_T3_Brief

![E5_batiment_travaux_T3_Brief](ecrans/E5_batiment_travaux_T3_Brief.jpg)

Brief Bâtiment & Travaux / Montrer un produit; 7 champs issus du JSON : Nom de votre commerce, Nom du travail à faire, Prix du travail, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_batiment_travaux_T4_Brief

![E5_batiment_travaux_T4_Brief](ecrans/E5_batiment_travaux_T4_Brief.jpg)

Brief Bâtiment & Travaux / Promotion; 9 champs issus du JSON : Nom de votre commerce, Nom du travail à faire, Prix du travail, Monnaie, Prix avant la réduction, Dernier jour de l’offre, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_batiment_travaux_T5_Brief

![E5_batiment_travaux_T5_Brief](ecrans/E5_batiment_travaux_T5_Brief.jpg)

Brief Bâtiment & Travaux / Un client raconte; 10 champs issus du JSON : Nom de votre commerce, Nom du travail à faire, Prix du travail, Monnaie, Prénom du client, Le client accepte-t-il que la vidéo soit publiée ?, Les mots du client (facultatif), Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_coiffure_beaute_T1_Brief

![E5_coiffure_beaute_T1_Brief](ecrans/E5_coiffure_beaute_T1_Brief.jpg)

Brief Coiffure & Beauté / Nouvel arrivage; 7 champs issus du JSON : Nom de votre commerce, Nom du soin ou de la coiffure, Prix du soin, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_coiffure_beaute_T2_Brief

![E5_coiffure_beaute_T2_Brief](ecrans/E5_coiffure_beaute_T2_Brief.jpg)

Brief Coiffure & Beauté / Avant et après; 7 champs issus du JSON : Nom de votre commerce, Nom du soin ou de la coiffure, Prix du soin, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_coiffure_beaute_T3_Brief

![E5_coiffure_beaute_T3_Brief](ecrans/E5_coiffure_beaute_T3_Brief.jpg)

Brief Coiffure & Beauté / Montrer un produit; 7 champs issus du JSON : Nom de votre commerce, Nom du soin ou de la coiffure, Prix du soin, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_coiffure_beaute_T4_Brief

![E5_coiffure_beaute_T4_Brief](ecrans/E5_coiffure_beaute_T4_Brief.jpg)

Brief Coiffure & Beauté / Promotion; 9 champs issus du JSON : Nom de votre commerce, Nom du soin ou de la coiffure, Prix du soin, Monnaie, Prix avant la réduction, Dernier jour de l’offre, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_coiffure_beaute_T5_Brief

![E5_coiffure_beaute_T5_Brief](ecrans/E5_coiffure_beaute_T5_Brief.jpg)

Brief Coiffure & Beauté / Un client raconte; 10 champs issus du JSON : Nom de votre commerce, Nom du soin ou de la coiffure, Prix du soin, Monnaie, Prénom du client, Le client accepte-t-il que la vidéo soit publiée ?, Les mots du client (facultatif), Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_immo_auto_T1_Brief

![E5_immo_auto_T1_Brief](ecrans/E5_immo_auto_T1_Brief.jpg)

Brief Maisons & Voitures / Nouvel arrivage; 7 champs issus du JSON : Nom de votre commerce, Nom du bien ou de la voiture, Prix du bien ou de la voiture, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_immo_auto_T2_Brief

![E5_immo_auto_T2_Brief](ecrans/E5_immo_auto_T2_Brief.jpg)

Brief Maisons & Voitures / Avant et après; 7 champs issus du JSON : Nom de votre commerce, Nom du bien ou de la voiture, Prix du bien ou de la voiture, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_immo_auto_T3_Brief

![E5_immo_auto_T3_Brief](ecrans/E5_immo_auto_T3_Brief.jpg)

Brief Maisons & Voitures / Montrer un produit; 7 champs issus du JSON : Nom de votre commerce, Nom du bien ou de la voiture, Prix du bien ou de la voiture, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_immo_auto_T4_Brief

![E5_immo_auto_T4_Brief](ecrans/E5_immo_auto_T4_Brief.jpg)

Brief Maisons & Voitures / Promotion; 9 champs issus du JSON : Nom de votre commerce, Nom du bien ou de la voiture, Prix du bien ou de la voiture, Monnaie, Prix avant la réduction, Dernier jour de l’offre, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_immo_auto_T5_Brief

![E5_immo_auto_T5_Brief](ecrans/E5_immo_auto_T5_Brief.jpg)

Brief Maisons & Voitures / Un client raconte; 10 champs issus du JSON : Nom de votre commerce, Nom du bien ou de la voiture, Prix du bien ou de la voiture, Monnaie, Prénom du client, Le client accepte-t-il que la vidéo soit publiée ?, Les mots du client (facultatif), Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_restaurants_maquis_T1_Brief

![E5_restaurants_maquis_T1_Brief](ecrans/E5_restaurants_maquis_T1_Brief.jpg)

Brief Restaurants & Maquis / Nouvel arrivage; 7 champs issus du JSON : Nom de votre commerce, Nom du plat, Prix du plat, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_restaurants_maquis_T2_Brief

![E5_restaurants_maquis_T2_Brief](ecrans/E5_restaurants_maquis_T2_Brief.jpg)

Brief Restaurants & Maquis / Avant et après; 7 champs issus du JSON : Nom de votre commerce, Nom du plat, Prix du plat, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_restaurants_maquis_T3_Brief

![E5_restaurants_maquis_T3_Brief](ecrans/E5_restaurants_maquis_T3_Brief.jpg)

Brief Restaurants & Maquis / Montrer un produit; 7 champs issus du JSON : Nom de votre commerce, Nom du plat, Prix du plat, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_restaurants_maquis_T4_Brief

![E5_restaurants_maquis_T4_Brief](ecrans/E5_restaurants_maquis_T4_Brief.jpg)

Brief Restaurants & Maquis / Promotion; 9 champs issus du JSON : Nom de votre commerce, Nom du plat, Prix du plat, Monnaie, Prix avant la réduction, Dernier jour de l’offre, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_restaurants_maquis_T5_Brief

![E5_restaurants_maquis_T5_Brief](ecrans/E5_restaurants_maquis_T5_Brief.jpg)

Brief Restaurants & Maquis / Un client raconte; 10 champs issus du JSON : Nom de votre commerce, Nom du plat, Prix du plat, Monnaie, Prénom du client, Le client accepte-t-il que la vidéo soit publiée ?, Les mots du client (facultatif), Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_shops_small_business_T1_Brief

![E5_shops_small_business_T1_Brief](ecrans/E5_shops_small_business_T1_Brief.jpg)

Brief Boutiques / Nouvel arrivage; 7 champs issus du JSON : Nom de votre commerce, Nom du produit, Prix du produit, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_shops_small_business_T2_Brief

![E5_shops_small_business_T2_Brief](ecrans/E5_shops_small_business_T2_Brief.jpg)

Brief Boutiques / Avant et après; 7 champs issus du JSON : Nom de votre commerce, Nom du produit, Prix du produit, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_shops_small_business_T3_Brief

![E5_shops_small_business_T3_Brief](ecrans/E5_shops_small_business_T3_Brief.jpg)

Brief Boutiques / Montrer un produit; 7 champs issus du JSON : Nom de votre commerce, Nom du produit, Prix du produit, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_shops_small_business_T4_Brief

![E5_shops_small_business_T4_Brief](ecrans/E5_shops_small_business_T4_Brief.jpg)

Brief Boutiques / Promotion; 9 champs issus du JSON : Nom de votre commerce, Nom du produit, Prix du produit, Monnaie, Prix avant la réduction, Dernier jour de l’offre, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_shops_small_business_T5_Brief

![E5_shops_small_business_T5_Brief](ecrans/E5_shops_small_business_T5_Brief.jpg)

Brief Boutiques / Un client raconte; 10 champs issus du JSON : Nom de votre commerce, Nom du produit, Prix du produit, Monnaie, Prénom du client, Le client accepte-t-il que la vidéo soit publiée ?, Les mots du client (facultatif), Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_vetements_mode_T1_Brief

![E5_vetements_mode_T1_Brief](ecrans/E5_vetements_mode_T1_Brief.jpg)

Brief Vêtements & Mode / Nouvel arrivage; 7 champs issus du JSON : Nom de votre commerce, Nom du vêtement, Prix, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_vetements_mode_T2_Brief

![E5_vetements_mode_T2_Brief](ecrans/E5_vetements_mode_T2_Brief.jpg)

Brief Vêtements & Mode / Avant et après; 7 champs issus du JSON : Nom de votre commerce, Nom du vêtement, Prix, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_vetements_mode_T3_Brief

![E5_vetements_mode_T3_Brief](ecrans/E5_vetements_mode_T3_Brief.jpg)

Brief Vêtements & Mode / Montrer un produit; 7 champs issus du JSON : Nom de votre commerce, Nom du vêtement, Prix, Monnaie, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_vetements_mode_T4_Brief

![E5_vetements_mode_T4_Brief](ecrans/E5_vetements_mode_T4_Brief.jpg)

Brief Vêtements & Mode / Promotion; 9 champs issus du JSON : Nom de votre commerce, Nom du vêtement, Prix, Monnaie, Prix avant la réduction, Dernier jour de l’offre, Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E5_vetements_mode_T5_Brief

![E5_vetements_mode_T5_Brief](ecrans/E5_vetements_mode_T5_Brief.jpg)

Brief Vêtements & Mode / Un client raconte; 10 champs issus du JSON : Nom de votre commerce, Nom du vêtement, Prix, Monnaie, Prénom du client, Le client accepte-t-il que la vidéo soit publiée ?, Les mots du client (facultatif), Quartier et ville, votre numéro WhatsApp, Afficher un message spécial (facultatif). T4 ajoute ancien prix et date; T5 ajoute prénom, accord et citation facultative.

## Phase 2 — Création — E4b_Controle_Avant_Tournage

![E4b_Controle_Avant_Tournage](ecrans/E4b_Controle_Avant_Tournage.jpg)

Vérification affichée avant le tournage; récapitulatif du format, métier, prises et infos; OK inactif avant validation.

## Phase 2 — Création — E4b_Ready

![E4b_Ready](ecrans/E4b_Ready.jpg)

Même contrôle validé; bouton OK, je commence ouvre le tournage.

## Phase 2 — Création — P1_Permissions_Explication

![P1_Permissions_Explication](ecrans/P1_Permissions_Explication.jpg)

Écran in-app qui explique caméra et micro avant le dialogue système Android.

## Phase 2 — Création — P2_Systeme_Android

![P2_Systeme_Android](ecrans/P2_Systeme_Android.jpg)

Dialogue système Android simulé, avec micro et vidéo explicitement listés.

## Phase 2 — Création — P3_Refus_Camera

![P3_Refus_Camera](ecrans/P3_Refus_Camera.jpg)

État de refus: explication non bloquante, CTA réglages caméra et sortie.

## Phase 2 — Création — E6bis_Consentement_Client

![E6bis_Consentement_Client](ecrans/E6bis_Consentement_Client.jpg)

Confirmation humaine du consentement à filmer et publier; aucune détection automatique n’est représentée.

## Phase 2 — Tournage — E6_batiment_travaux_T1_prise_1_SC02

![E6_batiment_travaux_T1_prise_1_SC02](ecrans/E6_batiment_travaux_T1_prise_1_SC02.jpg)

Caméra Bâtiment & Travaux / Nouvel arrivage — prise_1 « Le chantier et les matériaux », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_batiment_travaux_T1_prise_2_SILENCIEUSE

![E6_batiment_travaux_T1_prise_2_SILENCIEUSE](ecrans/E6_batiment_travaux_T1_prise_2_SILENCIEUSE.jpg)

Caméra Bâtiment & Travaux / Nouvel arrivage — prise_2 « Un geste de travail », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_batiment_travaux_T1_prise_3_SILENCIEUSE

![E6_batiment_travaux_T1_prise_3_SILENCIEUSE](ecrans/E6_batiment_travaux_T1_prise_3_SILENCIEUSE.jpg)

Caméra Bâtiment & Travaux / Nouvel arrivage — prise_3 « Le résultat du travail », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_batiment_travaux_T2_prise_1_SC02

![E6_batiment_travaux_T2_prise_1_SC02](ecrans/E6_batiment_travaux_T2_prise_1_SC02.jpg)

Caméra Bâtiment & Travaux / Avant et après — prise_1 « Le chantier au début », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_batiment_travaux_T2_prise_2_SILENCIEUSE

![E6_batiment_travaux_T2_prise_2_SILENCIEUSE](ecrans/E6_batiment_travaux_T2_prise_2_SILENCIEUSE.jpg)

Caméra Bâtiment & Travaux / Avant et après — prise_2 « Une première étape », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_batiment_travaux_T2_prise_3_SILENCIEUSE

![E6_batiment_travaux_T2_prise_3_SILENCIEUSE](ecrans/E6_batiment_travaux_T2_prise_3_SILENCIEUSE.jpg)

Caméra Bâtiment & Travaux / Avant et après — prise_3 « Une deuxième étape », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_batiment_travaux_T2_prise_4_SILENCIEUSE

![E6_batiment_travaux_T2_prise_4_SILENCIEUSE](ecrans/E6_batiment_travaux_T2_prise_4_SILENCIEUSE.jpg)

Caméra Bâtiment & Travaux / Avant et après — prise_4 « Le travail terminé », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_batiment_travaux_T3_prise_1_SC02

![E6_batiment_travaux_T3_prise_1_SC02](ecrans/E6_batiment_travaux_T3_prise_1_SC02.jpg)

Caméra Bâtiment & Travaux / Montrer un produit — prise_1 « Le lieu du travail », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_batiment_travaux_T3_prise_2_SILENCIEUSE

![E6_batiment_travaux_T3_prise_2_SILENCIEUSE](ecrans/E6_batiment_travaux_T3_prise_2_SILENCIEUSE.jpg)

Caméra Bâtiment & Travaux / Montrer un produit — prise_2 « Les outils et matériaux », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_batiment_travaux_T3_prise_3_SILENCIEUSE

![E6_batiment_travaux_T3_prise_3_SILENCIEUSE](ecrans/E6_batiment_travaux_T3_prise_3_SILENCIEUSE.jpg)

Caméra Bâtiment & Travaux / Montrer un produit — prise_3 « Le résultat de près », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_batiment_travaux_T4_prise_1_SILENCIEUSE

![E6_batiment_travaux_T4_prise_1_SILENCIEUSE](ecrans/E6_batiment_travaux_T4_prise_1_SILENCIEUSE.jpg)

Caméra Bâtiment & Travaux / Promotion — prise_1 « Le travail proposé », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_batiment_travaux_T4_prise_2_SILENCIEUSE

![E6_batiment_travaux_T4_prise_2_SILENCIEUSE](ecrans/E6_batiment_travaux_T4_prise_2_SILENCIEUSE.jpg)

Caméra Bâtiment & Travaux / Promotion — prise_2 « Un détail du travail », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_batiment_travaux_T4_prise_3_SC02

![E6_batiment_travaux_T4_prise_3_SC02](ecrans/E6_batiment_travaux_T4_prise_3_SC02.jpg)

Caméra Bâtiment & Travaux / Promotion — prise_3 « Une étape du chantier », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_batiment_travaux_T5_prise_1_SC01

![E6_batiment_travaux_T5_prise_1_SC01](ecrans/E6_batiment_travaux_T5_prise_1_SC01.jpg)

Caméra Bâtiment & Travaux / Un client raconte — prise_1 « Le client qui parle », segment 1/5, scène finale 1. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_batiment_travaux_T5_prise_1_SC02

![E6_batiment_travaux_T5_prise_1_SC02](ecrans/E6_batiment_travaux_T5_prise_1_SC02.jpg)

Caméra Bâtiment & Travaux / Un client raconte — prise_1 « Le client qui parle », segment 2/5, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_batiment_travaux_T5_prise_1_SC03

![E6_batiment_travaux_T5_prise_1_SC03](ecrans/E6_batiment_travaux_T5_prise_1_SC03.jpg)

Caméra Bâtiment & Travaux / Un client raconte — prise_1 « Le client qui parle », segment 3/5, scène finale 3. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_batiment_travaux_T5_prise_1_SC05

![E6_batiment_travaux_T5_prise_1_SC05](ecrans/E6_batiment_travaux_T5_prise_1_SC05.jpg)

Caméra Bâtiment & Travaux / Un client raconte — prise_1 « Le client qui parle », segment 4/5, scène finale 5. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_batiment_travaux_T5_prise_1_SC12

![E6_batiment_travaux_T5_prise_1_SC12](ecrans/E6_batiment_travaux_T5_prise_1_SC12.jpg)

Caméra Bâtiment & Travaux / Un client raconte — prise_1 « Le client qui parle », segment 5/5, scène finale 12. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_batiment_travaux_T5_prise_2_SILENCIEUSE

![E6_batiment_travaux_T5_prise_2_SILENCIEUSE](ecrans/E6_batiment_travaux_T5_prise_2_SILENCIEUSE.jpg)

Caméra Bâtiment & Travaux / Un client raconte — prise_2 « Le travail terminé », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_coiffure_beaute_T1_prise_1_SC02

![E6_coiffure_beaute_T1_prise_1_SC02](ecrans/E6_coiffure_beaute_T1_prise_1_SC02.jpg)

Caméra Coiffure & Beauté / Nouvel arrivage — prise_1 « Le poste de travail ou le soin », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_coiffure_beaute_T1_prise_2_SILENCIEUSE

![E6_coiffure_beaute_T1_prise_2_SILENCIEUSE](ecrans/E6_coiffure_beaute_T1_prise_2_SILENCIEUSE.jpg)

Caméra Coiffure & Beauté / Nouvel arrivage — prise_2 « Le geste du coiffeur », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_coiffure_beaute_T1_prise_3_SILENCIEUSE

![E6_coiffure_beaute_T1_prise_3_SILENCIEUSE](ecrans/E6_coiffure_beaute_T1_prise_3_SILENCIEUSE.jpg)

Caméra Coiffure & Beauté / Nouvel arrivage — prise_3 « Le résultat sur les cheveux ou le visage », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_coiffure_beaute_T2_prise_1_SC02

![E6_coiffure_beaute_T2_prise_1_SC02](ecrans/E6_coiffure_beaute_T2_prise_1_SC02.jpg)

Caméra Coiffure & Beauté / Avant et après — prise_1 « Les cheveux ou le visage avant », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_coiffure_beaute_T2_prise_2_SILENCIEUSE

![E6_coiffure_beaute_T2_prise_2_SILENCIEUSE](ecrans/E6_coiffure_beaute_T2_prise_2_SILENCIEUSE.jpg)

Caméra Coiffure & Beauté / Avant et après — prise_2 « Le travail du coiffeur », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_coiffure_beaute_T2_prise_3_SILENCIEUSE

![E6_coiffure_beaute_T2_prise_3_SILENCIEUSE](ecrans/E6_coiffure_beaute_T2_prise_3_SILENCIEUSE.jpg)

Caméra Coiffure & Beauté / Avant et après — prise_3 « Le résultat après », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_coiffure_beaute_T3_prise_1_SC02

![E6_coiffure_beaute_T3_prise_1_SC02](ecrans/E6_coiffure_beaute_T3_prise_1_SC02.jpg)

Caméra Coiffure & Beauté / Montrer un produit — prise_1 « Le visage ou le soin », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_coiffure_beaute_T3_prise_2_SILENCIEUSE

![E6_coiffure_beaute_T3_prise_2_SILENCIEUSE](ecrans/E6_coiffure_beaute_T3_prise_2_SILENCIEUSE.jpg)

Caméra Coiffure & Beauté / Montrer un produit — prise_2 « Le geste et les outils », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_coiffure_beaute_T3_prise_3_SILENCIEUSE

![E6_coiffure_beaute_T3_prise_3_SILENCIEUSE](ecrans/E6_coiffure_beaute_T3_prise_3_SILENCIEUSE.jpg)

Caméra Coiffure & Beauté / Montrer un produit — prise_3 « Le résultat de près », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_coiffure_beaute_T4_prise_1_SC02

![E6_coiffure_beaute_T4_prise_1_SC02](ecrans/E6_coiffure_beaute_T4_prise_1_SC02.jpg)

Caméra Coiffure & Beauté / Promotion — prise_1 « Le résultat du soin », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_coiffure_beaute_T4_prise_2_SILENCIEUSE

![E6_coiffure_beaute_T4_prise_2_SILENCIEUSE](ecrans/E6_coiffure_beaute_T4_prise_2_SILENCIEUSE.jpg)

Caméra Coiffure & Beauté / Promotion — prise_2 « Un détail du résultat », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_coiffure_beaute_T5_prise_1_SC01

![E6_coiffure_beaute_T5_prise_1_SC01](ecrans/E6_coiffure_beaute_T5_prise_1_SC01.jpg)

Caméra Coiffure & Beauté / Un client raconte — prise_1 « Le client qui parle », segment 1/5, scène finale 1. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_coiffure_beaute_T5_prise_1_SC02

![E6_coiffure_beaute_T5_prise_1_SC02](ecrans/E6_coiffure_beaute_T5_prise_1_SC02.jpg)

Caméra Coiffure & Beauté / Un client raconte — prise_1 « Le client qui parle », segment 2/5, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_coiffure_beaute_T5_prise_1_SC03

![E6_coiffure_beaute_T5_prise_1_SC03](ecrans/E6_coiffure_beaute_T5_prise_1_SC03.jpg)

Caméra Coiffure & Beauté / Un client raconte — prise_1 « Le client qui parle », segment 3/5, scène finale 3. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_coiffure_beaute_T5_prise_1_SC05

![E6_coiffure_beaute_T5_prise_1_SC05](ecrans/E6_coiffure_beaute_T5_prise_1_SC05.jpg)

Caméra Coiffure & Beauté / Un client raconte — prise_1 « Le client qui parle », segment 4/5, scène finale 5. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_coiffure_beaute_T5_prise_1_SC12

![E6_coiffure_beaute_T5_prise_1_SC12](ecrans/E6_coiffure_beaute_T5_prise_1_SC12.jpg)

Caméra Coiffure & Beauté / Un client raconte — prise_1 « Le client qui parle », segment 5/5, scène finale 12. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_coiffure_beaute_T5_prise_2_SILENCIEUSE

![E6_coiffure_beaute_T5_prise_2_SILENCIEUSE](ecrans/E6_coiffure_beaute_T5_prise_2_SILENCIEUSE.jpg)

Caméra Coiffure & Beauté / Un client raconte — prise_2 « Le résultat du soin », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_immo_auto_T1_prise_1_SC02

![E6_immo_auto_T1_prise_1_SC02](ecrans/E6_immo_auto_T1_prise_1_SC02.jpg)

Caméra Maisons & Voitures / Nouvel arrivage — prise_1 « L’extérieur du bien ou de la voiture », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_immo_auto_T1_prise_2_SILENCIEUSE

![E6_immo_auto_T1_prise_2_SILENCIEUSE](ecrans/E6_immo_auto_T1_prise_2_SILENCIEUSE.jpg)

Caméra Maisons & Voitures / Nouvel arrivage — prise_2 « L’intérieur », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_immo_auto_T1_prise_3_SILENCIEUSE

![E6_immo_auto_T1_prise_3_SILENCIEUSE](ecrans/E6_immo_auto_T1_prise_3_SILENCIEUSE.jpg)

Caméra Maisons & Voitures / Nouvel arrivage — prise_3 « Une information importante », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_immo_auto_T2_prise_1_SC02

![E6_immo_auto_T2_prise_1_SC02](ecrans/E6_immo_auto_T2_prise_1_SC02.jpg)

Caméra Maisons & Voitures / Avant et après — prise_1 « Le bien ou la voiture avant », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_immo_auto_T2_prise_2_SILENCIEUSE

![E6_immo_auto_T2_prise_2_SILENCIEUSE](ecrans/E6_immo_auto_T2_prise_2_SILENCIEUSE.jpg)

Caméra Maisons & Voitures / Avant et après — prise_2 « Le travail de préparation », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_immo_auto_T2_prise_3_SILENCIEUSE

![E6_immo_auto_T2_prise_3_SILENCIEUSE](ecrans/E6_immo_auto_T2_prise_3_SILENCIEUSE.jpg)

Caméra Maisons & Voitures / Avant et après — prise_3 « Le résultat après », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_immo_auto_T3_prise_1_SC02

![E6_immo_auto_T3_prise_1_SC02](ecrans/E6_immo_auto_T3_prise_1_SC02.jpg)

Caméra Maisons & Voitures / Montrer un produit — prise_1 « Le bien ou la voiture de face », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_immo_auto_T3_prise_2_SILENCIEUSE

![E6_immo_auto_T3_prise_2_SILENCIEUSE](ecrans/E6_immo_auto_T3_prise_2_SILENCIEUSE.jpg)

Caméra Maisons & Voitures / Montrer un produit — prise_2 « Le côté ou une pièce », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_immo_auto_T3_prise_3_SILENCIEUSE

![E6_immo_auto_T3_prise_3_SILENCIEUSE](ecrans/E6_immo_auto_T3_prise_3_SILENCIEUSE.jpg)

Caméra Maisons & Voitures / Montrer un produit — prise_3 « L’intérieur et les détails », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_immo_auto_T4_prise_1_SILENCIEUSE

![E6_immo_auto_T4_prise_1_SILENCIEUSE](ecrans/E6_immo_auto_T4_prise_1_SILENCIEUSE.jpg)

Caméra Maisons & Voitures / Promotion — prise_1 « Le bien ou la voiture », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_immo_auto_T4_prise_2_SC02

![E6_immo_auto_T4_prise_2_SC02](ecrans/E6_immo_auto_T4_prise_2_SC02.jpg)

Caméra Maisons & Voitures / Promotion — prise_2 « Un détail important », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_immo_auto_T5_prise_1_SC01

![E6_immo_auto_T5_prise_1_SC01](ecrans/E6_immo_auto_T5_prise_1_SC01.jpg)

Caméra Maisons & Voitures / Un client raconte — prise_1 « Le client qui parle », segment 1/5, scène finale 1. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_immo_auto_T5_prise_1_SC02

![E6_immo_auto_T5_prise_1_SC02](ecrans/E6_immo_auto_T5_prise_1_SC02.jpg)

Caméra Maisons & Voitures / Un client raconte — prise_1 « Le client qui parle », segment 2/5, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_immo_auto_T5_prise_1_SC03

![E6_immo_auto_T5_prise_1_SC03](ecrans/E6_immo_auto_T5_prise_1_SC03.jpg)

Caméra Maisons & Voitures / Un client raconte — prise_1 « Le client qui parle », segment 3/5, scène finale 3. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_immo_auto_T5_prise_1_SC05

![E6_immo_auto_T5_prise_1_SC05](ecrans/E6_immo_auto_T5_prise_1_SC05.jpg)

Caméra Maisons & Voitures / Un client raconte — prise_1 « Le client qui parle », segment 4/5, scène finale 5. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_immo_auto_T5_prise_1_SC12

![E6_immo_auto_T5_prise_1_SC12](ecrans/E6_immo_auto_T5_prise_1_SC12.jpg)

Caméra Maisons & Voitures / Un client raconte — prise_1 « Le client qui parle », segment 5/5, scène finale 12. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.4 s et marqueur Suivant.

## Phase 2 — Tournage — E6_immo_auto_T5_prise_2_SILENCIEUSE

![E6_immo_auto_T5_prise_2_SILENCIEUSE](ecrans/E6_immo_auto_T5_prise_2_SILENCIEUSE.jpg)

Caméra Maisons & Voitures / Un client raconte — prise_2 « Le bien dont il parle », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_restaurants_maquis_T1_prise_1_SILENCIEUSE

![E6_restaurants_maquis_T1_prise_1_SILENCIEUSE](ecrans/E6_restaurants_maquis_T1_prise_1_SILENCIEUSE.jpg)

Caméra Restaurants & Maquis / Nouvel arrivage — prise_1 « Le plat entier », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_restaurants_maquis_T1_prise_2_SILENCIEUSE

![E6_restaurants_maquis_T1_prise_2_SILENCIEUSE](ecrans/E6_restaurants_maquis_T1_prise_2_SILENCIEUSE.jpg)

Caméra Restaurants & Maquis / Nouvel arrivage — prise_2 « Le plat de près », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_restaurants_maquis_T1_prise_3_SC02

![E6_restaurants_maquis_T1_prise_3_SC02](ecrans/E6_restaurants_maquis_T1_prise_3_SC02.jpg)

Caméra Restaurants & Maquis / Nouvel arrivage — prise_3 « La préparation ou le service », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_restaurants_maquis_T2_prise_1_SC02

![E6_restaurants_maquis_T2_prise_1_SC02](ecrans/E6_restaurants_maquis_T2_prise_1_SC02.jpg)

Caméra Restaurants & Maquis / Avant et après — prise_1 « Les ingrédients », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_restaurants_maquis_T2_prise_2_SILENCIEUSE

![E6_restaurants_maquis_T2_prise_2_SILENCIEUSE](ecrans/E6_restaurants_maquis_T2_prise_2_SILENCIEUSE.jpg)

Caméra Restaurants & Maquis / Avant et après — prise_2 « La cuisson », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_restaurants_maquis_T2_prise_3_SILENCIEUSE

![E6_restaurants_maquis_T2_prise_3_SILENCIEUSE](ecrans/E6_restaurants_maquis_T2_prise_3_SILENCIEUSE.jpg)

Caméra Restaurants & Maquis / Avant et après — prise_3 « Le dressage du plat », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_restaurants_maquis_T2_prise_4_SILENCIEUSE

![E6_restaurants_maquis_T2_prise_4_SILENCIEUSE](ecrans/E6_restaurants_maquis_T2_prise_4_SILENCIEUSE.jpg)

Caméra Restaurants & Maquis / Avant et après — prise_4 « Le plat terminé de près », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_restaurants_maquis_T3_prise_1_SC02

![E6_restaurants_maquis_T3_prise_1_SC02](ecrans/E6_restaurants_maquis_T3_prise_1_SC02.jpg)

Caméra Restaurants & Maquis / Montrer un produit — prise_1 « Le plat de côté », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_restaurants_maquis_T3_prise_2_SILENCIEUSE

![E6_restaurants_maquis_T3_prise_2_SILENCIEUSE](ecrans/E6_restaurants_maquis_T3_prise_2_SILENCIEUSE.jpg)

Caméra Restaurants & Maquis / Montrer un produit — prise_2 « Le plat vu du dessus », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_restaurants_maquis_T3_prise_3_SILENCIEUSE

![E6_restaurants_maquis_T3_prise_3_SILENCIEUSE](ecrans/E6_restaurants_maquis_T3_prise_3_SILENCIEUSE.jpg)

Caméra Restaurants & Maquis / Montrer un produit — prise_3 « La taille et les détails du plat », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_restaurants_maquis_T4_prise_1_SC02

![E6_restaurants_maquis_T4_prise_1_SC02](ecrans/E6_restaurants_maquis_T4_prise_1_SC02.jpg)

Caméra Restaurants & Maquis / Promotion — prise_1 « Le plat chaud », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_restaurants_maquis_T4_prise_2_SILENCIEUSE

![E6_restaurants_maquis_T4_prise_2_SILENCIEUSE](ecrans/E6_restaurants_maquis_T4_prise_2_SILENCIEUSE.jpg)

Caméra Restaurants & Maquis / Promotion — prise_2 « La cuisson ou un détail du plat », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_restaurants_maquis_T5_prise_1_SC01

![E6_restaurants_maquis_T5_prise_1_SC01](ecrans/E6_restaurants_maquis_T5_prise_1_SC01.jpg)

Caméra Restaurants & Maquis / Un client raconte — prise_1 « Le client qui parle », segment 1/4, scène finale 1. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_restaurants_maquis_T5_prise_1_SC02

![E6_restaurants_maquis_T5_prise_1_SC02](ecrans/E6_restaurants_maquis_T5_prise_1_SC02.jpg)

Caméra Restaurants & Maquis / Un client raconte — prise_1 « Le client qui parle », segment 2/4, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_restaurants_maquis_T5_prise_1_SC03

![E6_restaurants_maquis_T5_prise_1_SC03](ecrans/E6_restaurants_maquis_T5_prise_1_SC03.jpg)

Caméra Restaurants & Maquis / Un client raconte — prise_1 « Le client qui parle », segment 3/4, scène finale 3. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_restaurants_maquis_T5_prise_1_SC05

![E6_restaurants_maquis_T5_prise_1_SC05](ecrans/E6_restaurants_maquis_T5_prise_1_SC05.jpg)

Caméra Restaurants & Maquis / Un client raconte — prise_1 « Le client qui parle », segment 4/4, scène finale 5. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_restaurants_maquis_T5_prise_2_SILENCIEUSE

![E6_restaurants_maquis_T5_prise_2_SILENCIEUSE](ecrans/E6_restaurants_maquis_T5_prise_2_SILENCIEUSE.jpg)

Caméra Restaurants & Maquis / Un client raconte — prise_2 « Le plat et la table », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_shops_small_business_T1_prise_1_SC02

![E6_shops_small_business_T1_prise_1_SC02](ecrans/E6_shops_small_business_T1_prise_1_SC02.jpg)

Caméra Boutiques / Nouvel arrivage — prise_1 « L’ouverture du colis ou le rayon », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_shops_small_business_T1_prise_2_SILENCIEUSE

![E6_shops_small_business_T1_prise_2_SILENCIEUSE](ecrans/E6_shops_small_business_T1_prise_2_SILENCIEUSE.jpg)

Caméra Boutiques / Nouvel arrivage — prise_2 « Le produit », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_shops_small_business_T1_prise_3_SILENCIEUSE

![E6_shops_small_business_T1_prise_3_SILENCIEUSE](ecrans/E6_shops_small_business_T1_prise_3_SILENCIEUSE.jpg)

Caméra Boutiques / Nouvel arrivage — prise_3 « Le produit et ses détails », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_shops_small_business_T2_prise_1_SC02

![E6_shops_small_business_T2_prise_1_SC02](ecrans/E6_shops_small_business_T2_prise_1_SC02.jpg)

Caméra Boutiques / Avant et après — prise_1 « Le produit avant », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_shops_small_business_T2_prise_2_SILENCIEUSE

![E6_shops_small_business_T2_prise_2_SILENCIEUSE](ecrans/E6_shops_small_business_T2_prise_2_SILENCIEUSE.jpg)

Caméra Boutiques / Avant et après — prise_2 « La mise en place ou l’emballage », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_shops_small_business_T2_prise_3_SILENCIEUSE

![E6_shops_small_business_T2_prise_3_SILENCIEUSE](ecrans/E6_shops_small_business_T2_prise_3_SILENCIEUSE.jpg)

Caméra Boutiques / Avant et après — prise_3 « Le résultat », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_shops_small_business_T3_prise_1_SC02

![E6_shops_small_business_T3_prise_1_SC02](ecrans/E6_shops_small_business_T3_prise_1_SC02.jpg)

Caméra Boutiques / Montrer un produit — prise_1 « Le produit de face », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_shops_small_business_T3_prise_2_SILENCIEUSE

![E6_shops_small_business_T3_prise_2_SILENCIEUSE](ecrans/E6_shops_small_business_T3_prise_2_SILENCIEUSE.jpg)

Caméra Boutiques / Montrer un produit — prise_2 « Le produit en main », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_shops_small_business_T3_prise_3_SILENCIEUSE

![E6_shops_small_business_T3_prise_3_SILENCIEUSE](ecrans/E6_shops_small_business_T3_prise_3_SILENCIEUSE.jpg)

Caméra Boutiques / Montrer un produit — prise_3 « Un détail du produit », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_shops_small_business_T4_prise_1_SC02

![E6_shops_small_business_T4_prise_1_SC02](ecrans/E6_shops_small_business_T4_prise_1_SC02.jpg)

Caméra Boutiques / Promotion — prise_1 « Le produit proposé », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_shops_small_business_T4_prise_2_SILENCIEUSE

![E6_shops_small_business_T4_prise_2_SILENCIEUSE](ecrans/E6_shops_small_business_T4_prise_2_SILENCIEUSE.jpg)

Caméra Boutiques / Promotion — prise_2 « Un détail du produit », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_shops_small_business_T5_prise_1_SC01

![E6_shops_small_business_T5_prise_1_SC01](ecrans/E6_shops_small_business_T5_prise_1_SC01.jpg)

Caméra Boutiques / Un client raconte — prise_1 « Le client qui parle », segment 1/5, scène finale 1. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_shops_small_business_T5_prise_1_SC02

![E6_shops_small_business_T5_prise_1_SC02](ecrans/E6_shops_small_business_T5_prise_1_SC02.jpg)

Caméra Boutiques / Un client raconte — prise_1 « Le client qui parle », segment 2/5, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_shops_small_business_T5_prise_1_SC03

![E6_shops_small_business_T5_prise_1_SC03](ecrans/E6_shops_small_business_T5_prise_1_SC03.jpg)

Caméra Boutiques / Un client raconte — prise_1 « Le client qui parle », segment 3/5, scène finale 3. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_shops_small_business_T5_prise_1_SC05

![E6_shops_small_business_T5_prise_1_SC05](ecrans/E6_shops_small_business_T5_prise_1_SC05.jpg)

Caméra Boutiques / Un client raconte — prise_1 « Le client qui parle », segment 4/5, scène finale 5. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_shops_small_business_T5_prise_1_SC12

![E6_shops_small_business_T5_prise_1_SC12](ecrans/E6_shops_small_business_T5_prise_1_SC12.jpg)

Caméra Boutiques / Un client raconte — prise_1 « Le client qui parle », segment 5/5, scène finale 12. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_shops_small_business_T5_prise_2_SILENCIEUSE

![E6_shops_small_business_T5_prise_2_SILENCIEUSE](ecrans/E6_shops_small_business_T5_prise_2_SILENCIEUSE.jpg)

Caméra Boutiques / Un client raconte — prise_2 « Le produit acheté ou utilisé », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_vetements_mode_T1_prise_1_SC02

![E6_vetements_mode_T1_prise_1_SC02](ecrans/E6_vetements_mode_T1_prise_1_SC02.jpg)

Caméra Vêtements & Mode / Nouvel arrivage — prise_1 « Les nouveaux vêtements », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_vetements_mode_T1_prise_2_SILENCIEUSE

![E6_vetements_mode_T1_prise_2_SILENCIEUSE](ecrans/E6_vetements_mode_T1_prise_2_SILENCIEUSE.jpg)

Caméra Vêtements & Mode / Nouvel arrivage — prise_2 « Un vêtement porté », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_vetements_mode_T1_prise_3_SILENCIEUSE

![E6_vetements_mode_T1_prise_3_SILENCIEUSE](ecrans/E6_vetements_mode_T1_prise_3_SILENCIEUSE.jpg)

Caméra Vêtements & Mode / Nouvel arrivage — prise_3 « Le tissu de près », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_vetements_mode_T2_prise_1_SC02

![E6_vetements_mode_T2_prise_1_SC02](ecrans/E6_vetements_mode_T2_prise_1_SC02.jpg)

Caméra Vêtements & Mode / Avant et après — prise_1 « La tenue avant », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_vetements_mode_T2_prise_2_SILENCIEUSE

![E6_vetements_mode_T2_prise_2_SILENCIEUSE](ecrans/E6_vetements_mode_T2_prise_2_SILENCIEUSE.jpg)

Caméra Vêtements & Mode / Avant et après — prise_2 « Le changement de tenue », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_vetements_mode_T2_prise_3_SILENCIEUSE

![E6_vetements_mode_T2_prise_3_SILENCIEUSE](ecrans/E6_vetements_mode_T2_prise_3_SILENCIEUSE.jpg)

Caméra Vêtements & Mode / Avant et après — prise_3 « La tenue après », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_vetements_mode_T3_prise_1_SC02

![E6_vetements_mode_T3_prise_1_SC02](ecrans/E6_vetements_mode_T3_prise_1_SC02.jpg)

Caméra Vêtements & Mode / Montrer un produit — prise_1 « Le vêtement de face », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_vetements_mode_T3_prise_2_SILENCIEUSE

![E6_vetements_mode_T3_prise_2_SILENCIEUSE](ecrans/E6_vetements_mode_T3_prise_2_SILENCIEUSE.jpg)

Caméra Vêtements & Mode / Montrer un produit — prise_2 « Le vêtement de côté », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_vetements_mode_T3_prise_3_SILENCIEUSE

![E6_vetements_mode_T3_prise_3_SILENCIEUSE](ecrans/E6_vetements_mode_T3_prise_3_SILENCIEUSE.jpg)

Caméra Vêtements & Mode / Montrer un produit — prise_3 « Le tissu et les détails », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_vetements_mode_T4_prise_1_SC02

![E6_vetements_mode_T4_prise_1_SC02](ecrans/E6_vetements_mode_T4_prise_1_SC02.jpg)

Caméra Vêtements & Mode / Promotion — prise_1 « Le vêtement proposé », segment 1/1, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_vetements_mode_T4_prise_2_SILENCIEUSE

![E6_vetements_mode_T4_prise_2_SILENCIEUSE](ecrans/E6_vetements_mode_T4_prise_2_SILENCIEUSE.jpg)

Caméra Vêtements & Mode / Promotion — prise_2 « Un détail du vêtement », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Tournage — E6_vetements_mode_T5_prise_1_SC01

![E6_vetements_mode_T5_prise_1_SC01](ecrans/E6_vetements_mode_T5_prise_1_SC01.jpg)

Caméra Vêtements & Mode / Un client raconte — prise_1 « Le client qui parle », segment 1/4, scène finale 1. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_vetements_mode_T5_prise_1_SC02

![E6_vetements_mode_T5_prise_1_SC02](ecrans/E6_vetements_mode_T5_prise_1_SC02.jpg)

Caméra Vêtements & Mode / Un client raconte — prise_1 « Le client qui parle », segment 2/4, scène finale 2. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_vetements_mode_T5_prise_1_SC03

![E6_vetements_mode_T5_prise_1_SC03](ecrans/E6_vetements_mode_T5_prise_1_SC03.jpg)

Caméra Vêtements & Mode / Un client raconte — prise_1 « Le client qui parle », segment 3/4, scène finale 3. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_vetements_mode_T5_prise_1_SC05

![E6_vetements_mode_T5_prise_1_SC05](ecrans/E6_vetements_mode_T5_prise_1_SC05.jpg)

Caméra Vêtements & Mode / Un client raconte — prise_1 « Le client qui parle », segment 4/4, scène finale 5. Image en viseur, cadre de sécurité, décompte 3–2–1, consigne caméra, quoi montrer, quoi raconter, exemple non récité, durée 2.0 s et marqueur Suivant.

## Phase 2 — Tournage — E6_vetements_mode_T5_prise_2_SILENCIEUSE

![E6_vetements_mode_T5_prise_2_SILENCIEUSE](ecrans/E6_vetements_mode_T5_prise_2_SILENCIEUSE.jpg)

Caméra Vêtements & Mode / Un client raconte — prise_2 « Le vêtement porté », 12 s. Viseur et consigne de cadrage; aucune consigne orale ni exemple dans cette prise muette.

## Phase 2 — Création — E7b_Controle_Avant_Montage

![E7b_Controle_Avant_Montage](ecrans/E7b_Controle_Avant_Montage.jpg)

Contrôle avant chaque montage; aperçu de ce qui a été préparé et bouton inactif avant confirmation.

## Phase 2 — Création — E7b_Montage_OK

![E7b_Montage_OK](ecrans/E7b_Montage_OK.jpg)

État confirmé du contrôle de montage; OK mène à l’aperçu/éditeur.

## Phase 2 — Création — E7_batiment_travaux_T1_Editeur

![E7_batiment_travaux_T1_Editeur](ecrans/E7_batiment_travaux_T1_Editeur.jpg)

Éditeur/aperçu Bâtiment & Travaux / Nouvel arrivage; 30–60 s prévus, 15 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_batiment_travaux_T2_Editeur

![E7_batiment_travaux_T2_Editeur](ecrans/E7_batiment_travaux_T2_Editeur.jpg)

Éditeur/aperçu Bâtiment & Travaux / Avant et après; 30–60 s prévus, 17 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_batiment_travaux_T3_Editeur

![E7_batiment_travaux_T3_Editeur](ecrans/E7_batiment_travaux_T3_Editeur.jpg)

Éditeur/aperçu Bâtiment & Travaux / Montrer un produit; 30–60 s prévus, 14 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_batiment_travaux_T4_Editeur

![E7_batiment_travaux_T4_Editeur](ecrans/E7_batiment_travaux_T4_Editeur.jpg)

Éditeur/aperçu Bâtiment & Travaux / Promotion; 30–60 s prévus, 17 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_batiment_travaux_T5_Editeur

![E7_batiment_travaux_T5_Editeur](ecrans/E7_batiment_travaux_T5_Editeur.jpg)

Éditeur/aperçu Bâtiment & Travaux / Un client raconte; 30–60 s prévus, 13 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_coiffure_beaute_T1_Editeur

![E7_coiffure_beaute_T1_Editeur](ecrans/E7_coiffure_beaute_T1_Editeur.jpg)

Éditeur/aperçu Coiffure & Beauté / Nouvel arrivage; 30–60 s prévus, 15 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_coiffure_beaute_T2_Editeur

![E7_coiffure_beaute_T2_Editeur](ecrans/E7_coiffure_beaute_T2_Editeur.jpg)

Éditeur/aperçu Coiffure & Beauté / Avant et après; 30–60 s prévus, 16 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_coiffure_beaute_T3_Editeur

![E7_coiffure_beaute_T3_Editeur](ecrans/E7_coiffure_beaute_T3_Editeur.jpg)

Éditeur/aperçu Coiffure & Beauté / Montrer un produit; 30–60 s prévus, 14 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_coiffure_beaute_T4_Editeur

![E7_coiffure_beaute_T4_Editeur](ecrans/E7_coiffure_beaute_T4_Editeur.jpg)

Éditeur/aperçu Coiffure & Beauté / Promotion; 30–60 s prévus, 17 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_coiffure_beaute_T5_Editeur

![E7_coiffure_beaute_T5_Editeur](ecrans/E7_coiffure_beaute_T5_Editeur.jpg)

Éditeur/aperçu Coiffure & Beauté / Un client raconte; 30–60 s prévus, 13 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_immo_auto_T1_Editeur

![E7_immo_auto_T1_Editeur](ecrans/E7_immo_auto_T1_Editeur.jpg)

Éditeur/aperçu Maisons & Voitures / Nouvel arrivage; 30–60 s prévus, 15 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_immo_auto_T2_Editeur

![E7_immo_auto_T2_Editeur](ecrans/E7_immo_auto_T2_Editeur.jpg)

Éditeur/aperçu Maisons & Voitures / Avant et après; 30–60 s prévus, 15 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_immo_auto_T3_Editeur

![E7_immo_auto_T3_Editeur](ecrans/E7_immo_auto_T3_Editeur.jpg)

Éditeur/aperçu Maisons & Voitures / Montrer un produit; 30–60 s prévus, 14 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_immo_auto_T4_Editeur

![E7_immo_auto_T4_Editeur](ecrans/E7_immo_auto_T4_Editeur.jpg)

Éditeur/aperçu Maisons & Voitures / Promotion; 30–60 s prévus, 17 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_immo_auto_T5_Editeur

![E7_immo_auto_T5_Editeur](ecrans/E7_immo_auto_T5_Editeur.jpg)

Éditeur/aperçu Maisons & Voitures / Un client raconte; 30–60 s prévus, 13 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_restaurants_maquis_T1_Editeur

![E7_restaurants_maquis_T1_Editeur](ecrans/E7_restaurants_maquis_T1_Editeur.jpg)

Éditeur/aperçu Restaurants & Maquis / Nouvel arrivage; 30–60 s prévus, 15 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_restaurants_maquis_T2_Editeur

![E7_restaurants_maquis_T2_Editeur](ecrans/E7_restaurants_maquis_T2_Editeur.jpg)

Éditeur/aperçu Restaurants & Maquis / Avant et après; 30–60 s prévus, 16 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_restaurants_maquis_T3_Editeur

![E7_restaurants_maquis_T3_Editeur](ecrans/E7_restaurants_maquis_T3_Editeur.jpg)

Éditeur/aperçu Restaurants & Maquis / Montrer un produit; 30–60 s prévus, 14 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_restaurants_maquis_T4_Editeur

![E7_restaurants_maquis_T4_Editeur](ecrans/E7_restaurants_maquis_T4_Editeur.jpg)

Éditeur/aperçu Restaurants & Maquis / Promotion; 30–60 s prévus, 17 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_restaurants_maquis_T5_Editeur

![E7_restaurants_maquis_T5_Editeur](ecrans/E7_restaurants_maquis_T5_Editeur.jpg)

Éditeur/aperçu Restaurants & Maquis / Un client raconte; 30–60 s prévus, 13 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_shops_small_business_T1_Editeur

![E7_shops_small_business_T1_Editeur](ecrans/E7_shops_small_business_T1_Editeur.jpg)

Éditeur/aperçu Boutiques / Nouvel arrivage; 30–60 s prévus, 15 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_shops_small_business_T2_Editeur

![E7_shops_small_business_T2_Editeur](ecrans/E7_shops_small_business_T2_Editeur.jpg)

Éditeur/aperçu Boutiques / Avant et après; 30–60 s prévus, 15 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_shops_small_business_T3_Editeur

![E7_shops_small_business_T3_Editeur](ecrans/E7_shops_small_business_T3_Editeur.jpg)

Éditeur/aperçu Boutiques / Montrer un produit; 30–60 s prévus, 14 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_shops_small_business_T4_Editeur

![E7_shops_small_business_T4_Editeur](ecrans/E7_shops_small_business_T4_Editeur.jpg)

Éditeur/aperçu Boutiques / Promotion; 30–60 s prévus, 17 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_shops_small_business_T5_Editeur

![E7_shops_small_business_T5_Editeur](ecrans/E7_shops_small_business_T5_Editeur.jpg)

Éditeur/aperçu Boutiques / Un client raconte; 30–60 s prévus, 13 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_vetements_mode_T1_Editeur

![E7_vetements_mode_T1_Editeur](ecrans/E7_vetements_mode_T1_Editeur.jpg)

Éditeur/aperçu Vêtements & Mode / Nouvel arrivage; 30–60 s prévus, 15 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_vetements_mode_T2_Editeur

![E7_vetements_mode_T2_Editeur](ecrans/E7_vetements_mode_T2_Editeur.jpg)

Éditeur/aperçu Vêtements & Mode / Avant et après; 30–60 s prévus, 15 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_vetements_mode_T3_Editeur

![E7_vetements_mode_T3_Editeur](ecrans/E7_vetements_mode_T3_Editeur.jpg)

Éditeur/aperçu Vêtements & Mode / Montrer un produit; 30–60 s prévus, 14 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_vetements_mode_T4_Editeur

![E7_vetements_mode_T4_Editeur](ecrans/E7_vetements_mode_T4_Editeur.jpg)

Éditeur/aperçu Vêtements & Mode / Promotion; 30–60 s prévus, 17 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E7_vetements_mode_T5_Editeur

![E7_vetements_mode_T5_Editeur](ecrans/E7_vetements_mode_T5_Editeur.jpg)

Éditeur/aperçu Vêtements & Mode / Un client raconte; 30–60 s prévus, 13 scènes; titres issus des scènes du JSON et contrôles nom/prix/lieu/WhatsApp. Valeurs de contenu remplacées par des champs génériques dans la maquette.

## Phase 2 — Création — E8_Export_Erreur

![E8_Export_Erreur](ecrans/E8_Export_Erreur.jpg)

État d’erreur avec message compréhensible, nouvelle tentative et retour.

## Phase 2 — Création — E8_Export_Progression

![E8_Export_Progression](ecrans/E8_Export_Progression.jpg)

Progression de préparation, étape claire et durée indicative fournie par le wireframe.

## Phase 2 — Création — E8_Export_Succes

![E8_Export_Succes](ecrans/E8_Export_Succes.jpg)

État succès avec actions distinctes pour voir, partager ou revenir au tableau de bord; contenu conceptuel.

## Phase 3 — Paiement — O3_Choisir_Region

![O3_Choisir_Region](ecrans/O3_Choisir_Region.jpg)

Choix de région : UEMOA en FCFA avec Mobile Money/carte; autres régions en euros par carte.

## Phase 3 — Paiement — E9A_Paywall_UEMOA

![E9A_Paywall_UEMOA](ecrans/E9A_Paywall_UEMOA.jpg)

UEMOA : 500, 3 000 et 7 500 FCFA; Mobile Money et carte.

## Phase 3 — Paiement — E9B_Paywall_Afrique

![E9B_Paywall_Afrique](ecrans/E9B_Paywall_Afrique.jpg)

Afrique hors UEMOA : prix convertis en euros, à la parité fixe BCEAO (655,957 FCFA pour 1 EUR).

## Phase 3 — Paiement — E9C_Paywall_Monde

![E9C_Paywall_Monde](ecrans/E9C_Paywall_Monde.jpg)

Reste du monde : prix affichés en euros, convertis depuis les tarifs FCFA à la parité fixe BCEAO.

## Phase 4 — Tableau de bord — E10_Dashboard

![E10_Dashboard](ecrans/E10_Dashboard.jpg)

Solde, CTA, paliers de parrainage et code fourni dans le wireframe. Valeurs d’exemple de maquette.

## Phase 4 — Tableau de bord — E11_Parrainage

![E11_Parrainage](ecrans/E11_Parrainage.jpg)

Code, progression 3/5, filleuls et récompense selon les valeurs du wireframe.

## Phase 4 — Tableau de bord — S1_Historique_Filleuls

![S1_Historique_Filleuls](ecrans/S1_Historique_Filleuls.jpg)

Historique des filleuls, états payés/en attente et progression vers le palier suivant.

## Phase 5 — Réglages — E12_Reglages

![E12_Reglages](ecrans/E12_Reglages.jpg)

Compte, code parrain, secteur, consentements, stockage local et déconnexion.

## Phase 5 — Réglages — S2_Consentements

![S2_Consentements](ecrans/S2_Consentements.jpg)

Registre de consentements; dates et noms sont les exemples fournis par le wireframe.

## Phase 5 — Réglages — S3_Changer_Secteur

![S3_Changer_Secteur](ecrans/S3_Changer_Secteur.jpg)

Changer de secteur avec les six illustrations 3D métiers; Restaurants & Maquis est le secteur actuel dans cet exemple.

## Phase 5 — Réglages — S3_Confirmer_Changement

![S3_Confirmer_Changement](ecrans/S3_Confirmer_Changement.jpg)

Confirmation avant changement de secteur; les vidéos existantes restent.

## Phase 6 — Système — O2_Conflit_Synchronisation

![O2_Conflit_Synchronisation](ecrans/O2_Conflit_Synchronisation.jpg)

Bannière de conflit de synchronisation avec action pour comparer les deux versions.
