# D42.34 — RAPPORT DE LIVRAISON (porte d'approbation fondateur)

Branche : `d42.34-founder-acceptance-fixes` · Base : 85bb823 (D42.33 CI
verte) → 0c5b4ce (Lot 0) → 420d697 (Lot 1) → f586678 (Lot 2) → 80b0cf8
(Lot 3) → c83e884 (Lot 4) → 01f1044 (correctif seed CI) → 139e4b3 (Lot 5)
→ commit final (Lot 6). Budget : 0 FCFA. Durée : 15→17/11/2026.

## Ce qui a été corrigé (résumé fondateur)

1. **Catalogue (P0-1/2)** — le secteur choisi n'est plus perdu à la
   reprise (`restaurerSession` relit `sector`) ; un secteur perdu affiche un
   ÉTAT D'ERREUR EXPLICITE (jamais 30 gabarits mélangés en silence, jamais
   de repli TOUS caché) ; les cartes affichent « N s · N prises guidées »
   (jamais « 15 scènes ») — `nombre_scenes` des JSON inchangé.
2. **Import des rushs (P0-4)** — les gabarits témoignage « Un client
   raconte » (T5, 6 secteurs) proposent d'ajouter des VIDÉOS du client,
   prise par prise (1 prise = 1 média, URI persistantes, brouillon) ;
   filmer au guide reste possible ; la fusion respecte le contrat slots
   (la prise filmée prime sur l'importée — plus de concaténation aveugle).
3. **Caméra guidée (P0-3)** — le parcours générique « Scène 1/26 · 1,2 s »
   n'existe plus en mode gabarit : le HUD montre uniquement
   `PRISE n/prises.size` avec les consignes réelles de la prise ; chargement
   et erreur ont des états explicites (retour proposé) ; impossible de
   lancer une caméra guidée sans prises ; « Caméra prête » seulement après
   flux réel ; compte à rebours 3-2-1 véritable (déjà D42.30) ; « Scène 1/0 »
   impossible.
4. **Identité & abonnements & montage (CR-4)** — le nom affiché est le nom
   RÉEL du profil Google (ou le nom de commerce renseigné), sinon
   « Bonjour » seul — jamais déduit d'un email, jamais inventé ; les CTA du
   paywall sont actifs (« Choisir Pass 24 h / Pro / Boutique », 500/3 000/
   7 500 FCFA, Pro recommandé) et branchés au checkout réel — 501 reste le
   message discret honnête (CinetPay non intégré, aucune transaction
   fictive) ; l'export affiche les phases métier réelles (assemblage,
   musique, rendu, vérification) sans pourcentage inventé.
5. **Carrousel & logo & splash (CR-5)** — 3 slides = 3 métiers différents
   (marchande / plat de maquis / boutique wax — ressources Drive D, textes
   inchangés) ; le logo officiel (mark.png) remplace les badges dessinés
   (mesure : ils n'étaient pas votre insigne) dans le splash et les
   en-têtes ; splash statique centré, aucune fausse animation ; registre de
   licences commité.

## Preuves

- **360 tests unitaires/Robolectric, 0 échec** (12 modules) + ktlint +
  detekt + graphe de modules — commande CI exacte, locale ;
- **CI GitHub Actions verte** sur les commits 8bb3dcc et 01f1044
  ( Lots 1→4 + correctif) ; Lot 5 + final vérifiés au push ;
- **12 captures visuelles** `docs/checkpoints/D42_34/visual-review/`
  (D34-01 → D34-12) ;
- Checkpoints détaillés : 01 (causes racines), 02 (matrice 30 gabarits +
  colonnes import), 03/04/05/07 (par défaut), 08 (non-régression).

## Ce que le fondateur doit vérifier sur SON téléphone (avant publication)

1. Parcours complet avec secteur choisi → catalogue filtré, cartes
   « N s · N prises guidées » ;
2. Refus d'un brouillon/dashboard « Reprendre » → secteur conservé ;
3. T5 « Un client raconte » : ajouter une vidéo du client à la prise 1 →
   Terminer → filmer la prise 2 au guide → export : la vidéo du client doit
   apparaître à SA prise ;
4. Caméra gabarit : HUD `PRISE 1/3` seul, consignes réelles, « Caméra
   prête » après flux, décompte 3-2-1 avant l'enregistrement ;
5. Paywall : les 3 boutons « Choisir … » réagissent (501 = message discret
   attendu tant que CinetPay n'est pas configuré) ;
6. Connexion Google : « Bonjour, {votre nom} » (sinon « Bonjour » seul) ;
7. Carrousel : 3 métiers différents, vos textes inchangés ; splash : votre
   logo centré, sans animation ;
8. Banc émulateur (avant publication) : `connectedAndroidTest` avec
   `renduTemoignageSlotsImportes` (E2E témoignage slots importés + MP4
   vérifié) et `rendusDeProduction` (matrice complète).

## Limites honnêtes

- Images de maquette (Drive D) : **licences à acquérir ou remplacement par
  vos photos avant le Play Store** (CREDITS_PHOTOS.md) ;
- Import rushs : vidéos uniquement (le moteur ne compose pas de photos —
  évolution à autoriser explicitement si voulue) ;
- Si un nom de package technique réapparaît à l'écran (capture 020028) :
  aucune occurrence dans le code — capturer l'écran exact pour localisation
  (probable dialogue système) ;
- Montage : aucune progression en % (indéterminé honnête — Transformer
  1.11.1 n'expose pas de progression exploitable).

## Gouvernance respectée

Pas de push main · RC15 immuable · pas de RC16 · aucun APK commercial
signé · CinetPay 501 inchangé · aucune transaction/URL fictive · moteur et
600 compos audio protégés · contrats serveur inchangés · IDs canoniques
gabarits inchangés · budget 0 FCFA.

**Arrêt à la porte d'approbation du fondateur.**
