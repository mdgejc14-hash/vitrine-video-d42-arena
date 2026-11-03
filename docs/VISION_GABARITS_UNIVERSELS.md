# VISION OFFICIELLE — Vitrine Vidéo v1
## 5 gabarits universels par secteur, qualité exceptionnelle, langage du commerçant

Document de décision stratégique & ingénierie. Écrit au terme de tout le cycle
(harnais visuel, audit moteur, cartographies). Aucune ligne de code modifiée ici :
ce document fixe CE QU'ON CONSTRUIT et POURQUOI, avant le comment.

---

## 1. La vision en une phrase

**Donner à chaque commerçant d'Afrique de l'Ouest une agence vidéo dans sa
poche : en moins de 2 minutes, avec 2 à 4 prises filmées au téléphone et sa
propre voix, il publie une vidéo de vente verticale, dynamisée, au rendu
professionnel — sans compétence technique, sans connexion, sans dépenser 1 FCFA.**

Ce que l'application fait RÉELLEMENT, vu du terrain :
- elle TRADUIT un commerce (secteur, produit, prix, offre) en langage vidéo viral ;
- elle GUIDE la main (cadre, lumière, 2–4 prises, pas une de plus) ;
- elle MONTE toute seule (cut 1,5 s, zooms, transitions, texte cinétique orange,
  voix synchronisée au mot près, mix propre) ;
- elle LIVRE là où ça vend ici : WhatsApp Statut, TikTok, Facebook (9:16, ≤ 30 s).

Ce qu'elle ne fait JAMAIS : demander au commerçant de penser comme un monteur.
Ni scènes multiples, ni timeline, ni réglages. Jamais.

---

## 2. Fonctionnalités finales (périmètre v1 officiel)

| Bloc | Fonctionnalités |
|---|---|
| Entrée | 4 langues (fr/en/es/ja) ; SSO Google 1-tap sans téléphone ; tuto 3 slides skippable, 1re fois seulement |
| Ciblage | secteur en cartes 3D ; catalogue = **5 gabarits prouvés du secteur**, noms commerciaux, sous-titre « adapté à votre commerce » |
| Brief | **3 variables** : Nom produit · Prix · Offre (+ rushs galerie optionnels) ; script voix AUTO-GENERÉ depuis ces 3 variables |
| Tournage | guide INS 2–4 prises par gabarit ; cadre 9:16 + silhouette ; 1 tap = verrou 3A + rec ; gate R4 visages/consentement ; consignes FR courtes |
| Moteur | beat sheet 1,5 s mappé sur les prises (rushIndex) ; zooms z(t) ; transitions cut/swipe/flash/glitch ; Kinetic Typography orange (prix = mot-clé) ; WordClock voix/texte |
| Son | voix réelle du commerçant/client ; highpass anti-marché ; ducking musique ; master −14 LUFS / −1,0 dBTP |
| Sortie | preview dynamisée auto ; export local WorkManager ; partage 1 tap WhatsApp/TikTok/Facebook ; notification écran éteint |
| Backend léger | manifeste JSON 30 gabarits (6 secteurs × 5) + vignettes B2 ; crédits/abonnement 1 requête à l'export ; sync silencieuse ; 0 FCFA fixe |
| Garde-fous | offline-first total (hors SSO initial) ; retour natif = étape précédente ; zéro écran bloquant ; anti-surchauffe par classe d'appareil |

---

## 3. Les 5 gabarits universels — et pourquoi EUX

Au lieu de 180 gabarits, **5 archétypes par secteur = 30 gabarits** (6 secteurs × 5).
Ces 5 archétypes sont les formats viraux commerce les plus éprouvés au monde ET
les plus compatibles avec nos usages locaux (WhatsApp Statut, bouche-à-oreille
numérique, preuve sociale orale) :

| # | Archétype | Pourquoi ça vend ici | Preuve virale |
|---|---|---|---|
| T1 | **Nouvel Arrivage & Nouveautés** | la nouveauté = événement de quartier ; crée le « passe me voir » | unboxing / new stock, format n°1 retail |
| T2 | **Avant / Après Transformation** | la preuve par les yeux, sans argument ; roi en coiffure, beauté, BTP, auto | format transformation = plus fort taux de partage |
| T3 | **Présentation Rapide de Produit** | le catalogue vivant : 3 angles, le prix, c'est tout | hero product 15 s, standard e-commerce |
| T4 | **Promo Flash & Réduction** | l'urgence + le prix en grand = trafic immédiat en boutique | flash sale, countdown, prix ancré |
| T5 | **Témoignage & Avis Client** | la confiance ici est ORALE : une voix réelle vaut 10 affiches | social proof video, conversion max |

### 3.1 Instantiation par secteur (ce qui change / ce qui ne change pas)

Ce qui NE CHANGE JAMAIS : la structure en 4 actes (ci-dessous), 2–4 prises,
la voix réelle, le prix en typographie orange, ≤ 30 s.
Ce qui CHANGE par secteur : le vocabulaire du script, la « prise preuve »,
le format d'offre par défaut.

| Secteur | T1 Arrivage | T2 Avant/Après | T3 Présentation | T4 Promo | T5 Témoignage |
|---|---|---|---|---|---|
| Vêtements & Mode | nouvelle collection arrivée | tenue transformée/retouche | robe portée 3 angles | prix cassé du week-end | cliente essayage |
| Coiffure & Beauté | nouveaux styles/tresses | tête avant → tresses posées | détail tresses/makeup | forfait du mois | cliente miroir |
| Restaurants & Maquis | plat du jour | ingrédient → plat dressé | plat fumant gros plan | menu midi à X FCFA | client qui goûte |
| Bâtiment & Travaux | matériaux/livraison chantier | chantier avant → après | matériel en action | devis gratuit ce mois | client sur site |
| Immo & Auto | nouveau bien/véhicule | véhicule detailing avant/après | visite guidée 3 plans | prix de lancement | client au volant |
| Shops & Small Business | stock arrivé | boutique rangée avant/après | produit phare en main | réduction flash | client fidèle |

---

## 4. L'ADN commun des 5 gabarits (les invariants universels)

Analyse de ce que TOUS les gabarits efficaces partagent — c'est notre contrat
de rendu, valable pour les 30 gabarits et tous les futurs :

1. **4 actes obligatoires** : HOOK (0–2 s : logo/prix/visage choc) → PREUVE
   (les prises, 2–4) → OFFRE (prix + argument en typographie orange géante) →
   CTA (nom boutique + WhatsApp + logo, 2 s finales).
2. **≤ 30 secondes** : limite WhatsApp Statut = notre cahier des charges, pas une
   contrainte subie. 15 s si le script est court.
3. **2 à 4 prises maximum** : le commerçant filme des OBJETS, le moteur fabrique
   des PLANS (cut 1,5 s via rushIndex : 1 prise = 3 à 8 plans dynamisés).
4. **Voix réelle, jamais synthétique** : le commerçant lit 1–2 phrases auto-
   générées (ou le client parle en T5). Zéro API voix payante = 0 FCFA et
   authenticité totale.
5. **Le prix TOUJOURS à l'écran en orange cinétique** : 80 % des feeds se
   regardent SANS SON (data) ; le message doit passer muet.
6. **Sous-titres permanents** mot à mot (WordClock) : muted viewing + confort
   de lecture multilingue.
7. **9:16 avec marges de sécurité** : ne jamais placer texte/prix sous les
   zones UI WhatsApp/TikTok (boutons droite, légende bas).
8. **−14 LUFS / −1,0 dBTP** : calibré pour haut-parleur téléphone, pas pour studio.
9. **Lumière guidée** : consigne « visage/produit face à la lumière, jamais à
   contre-jour » + verrou 3A : le soleil de Cotonou devient notre éclairage pro.
10. **Carte finale identité** : nom boutique + secteur + numéro WhatsApp =
    chaque vidéo est une carte de visite qui travaille toute seule.

---

## 5. Le brief universel : ce qu'on demande à TOUS les gabarits

Trois variables, point final. Le reste est déduit (secteur connu, boutique connue,
langue connue, durée auto depuis la longueur du script).

| Variable | Exemple | Usage moteur |
|---|---|---|
| Nom produit/service | « Robes coupées main » | mot-clé du HOOK + sous-titres |
| Prix | « 15 000 F » | typographie orange géante acte OFFRE |
| Offre/argument | « −20 % jusqu'à samedi » | acte OFFRE + urgence du CTA |

Script voix AUTO-GENERÉ (modèle par archétype), exemple T1 :
« Nouvel arrivage chez Awa Boutique : robes coupées main, à partir de 15 000 francs.
Moins 20 pour cent jusqu'à samedi. Passez me voir, ou commandez sur WhatsApp. »
(≈ 11 s de voix → WordClock → 7 plans dynamisés sur 3 prises.)

### 5.1 Protocole de prises par archétype (2–4 prises, consignes FR courtes)

| Archétype | Prise 1 | Prise 2 | Prise 3 | Prise 4 |
|---|---|---|---|---|
| T1 Arrivage | étalage/lot de face, lumière du jour | détail qui vend, rapproché | produit en main | — |
| T2 Avant/Après | état AVANT, immobile 3 s | résultat APRÈS, panoramique lent | détail fier du résultat | — |
| T3 Présentation | produit de face | texture/détail rapproché | produit en usage | — |
| T4 Promo | produit + prix visible (étiquette/ardoise) | produit en main, dynamique | — | — |
| T5 Témoignage | client qui parle, 10 s max (consentement R4) | produit en usage pendant qu'il parle | — | — |

Chaque prise = 1 tap démarrage, 1 tap arrêt. L'overlay affiche : « Prise 1/3 »,
jauge de durée de la prise, consigne d'une ligne, badge visages R4. C'est TOUT.

---

## 6. Qualité exceptionnelle dans nos réalités (Afrique de l'Ouest)

| Réalité terrain | Réponse d'ingénierie (déjà dans le moteur ou ciblé) |
|---|---|
| Data coûteuse, vidéo regardée muette | typo cinétique + sous-titres portent le message ; export optimisé par classe d'appareil (DeviceProfiler) : 720p/1080p, cible < 10 Mo pour 30 s afin que WhatsApp ne massacre pas le rendu |
| Soleil dur, contre-jour fréquents | consigne lumière + verrou 3A (exposition figée après convergence) + zooms z(t) qui masquent le bruit des zones cramées |
| Marché bruyant (klaxons, voix) | highpass 85 Hz coupe le rumble ; ducking musique sous la voix ; loudnorm −14 LUFS pour petit haut-parleur |
| Téléphones modestes, chauffe | classes d'appareil → bitrate/effets réduits ; WorkManager export écran éteint ; jamais de traitement parallèle lourd |
| Coupures réseau quotidiennes | offline-first : tournage, montage, preview, export = 100 % locaux ; partage WhatsApp une fois le fichier prêt |
| Confiance orale, preuve sociale | T5 témoignage natif + gate R4 consentements : la preuve sociale reste légale et digne |
| WhatsApp = canal n°1 | 9:16 ≤ 30 s, marges UI respectées, carte finale WhatsApp : la vidéo sort PRÊTE pour Statut |

---

## 7. Comment on l'implémente (plan d'ingénierie, micro-commits)

1. **Manifeste v2 = 30 gabarits** : JSON serveur (6 secteurs × 5 archétypes),
   chaque entrée = archétype + vocabulaire secteur + liste de prises (2–4) +
   beat-grid par défaut + set typographique. Injection B2 inchangée.
2. **ShootingProtocol** : remplace l'overlay 26 plans par le protocole de prises
   de l'archétype (consignes FR, compteur « Prise 1/3 », jauge de prise).
3. **Générateur de script** : 3 variables → phrase voix par archétype (i18n ×4) ;
   durée = longueur voix (WordClock), pas l'inverse.
4. **Mapping rushIndex** : DefaultBeatSheet affecte chaque plan 1,5 s à une prise
   (plan i → prise i mod nPrises) ; MotionComposition clippe déjà par rush.
5. **Brief 3 champs** remplace le script libre (script libre conservé en mode
   avancé/admin, caché au parcours marchand).
6. **Preview auto** : lecture du rendu dès export fini + partage 1 tap.
Chaque étape : commit + push + CI verte + captures Robolectric FR de preuve.

---

## 8. Décision finale (ce que je ferais à ta place)

- Oui aux **5 gabarits par secteur** : 30 gabarits prouvés battent 180 dilués —
  moins de choix = plus de vidéos publiées, et chaque gabarit reçoit notre
  meilleure ingénierie (c'est ça, la qualité exceptionnelle).
- Le brief universel = **Nom · Prix · Offre** : c'est exactement ce qu'un
  commerçant sait dire sans réfléchir ; tout le reste est du ressort du moteur.
- L'ADN 4 actes / ≤ 30 s / 2–4 prises / voix réelle / prix orange = contrat de
  rendu INTANGIBLE : tout futur gabarit injecté par B2 devra s'y conformer
  (validateur de manifeste côté app).
- La promesse tenant en un chiffre : **du premier tap à la vidéo partagée :
  moins de 2 minutes, 8 à 11 taps, 0 FCFA.**
