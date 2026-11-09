# D42.26 — PLAN DE VÉRIFICATIONS PHYSIQUES FONDATEUR (post-qualification logicielle)

**Statut** : PRÉPARÉ, **NON EXÉCUTÉ** (règle D42.26-6 : préparer sans
prétendre exécutées). Ces vérifications se font sur TÉLÉPHONE RÉEL, par le
fondateur, APRÈS la qualification logicielle complète et la production du
rc12 (voir rapport final, décision D6). Chaque ligne indique ce qui est déjà
qualifié côté logiciel (ne pas re-tester exhaustivement) et la vérification
terrain qui manque.

**Mode d'emploi** : installer l'APK rc12 (fourni à la remise), suivre les
étapes dans l'ordre, cocher et noter l'heure + éventuellement une
photo/vidéo de l'écran comme preuve. Durée totale estimée : 45-60 minutes.
Un test FAIL n'invalide pas la qualification logicielle : il ouvre un
ticket de défaut avec les étapes exactes pour reproduction.

---

## A. Compte réel — Google Sign-In (exigences 2.2/2.3/2.4/2.5)

*Déjà qualifié logiciel* : bouton affiché et localisé 4 langues ; cycle
complet côté serveur (18 contrôles Worker, comptes A/B créés par API,
jeton signé JWKS, /me, isolation) ; app hors ligne sans crash à la
tentative Google.

1. **Première connexion** : app neuve → « Se connecter avec Google » →
   choisir un compte Gmail réel → attendu : écran suivant de l'app, aucun
   crash, aucune boucle. ☐
2. **Persistance session** : fermer l'app (swipe) → rouvrir → attendu :
   session conservée (pas de retour à l'écran de connexion) pendant la
   validité du jeton (1 h). ☐
3. **Expiration** : laisser l'app >1 h (ou attendre le lendemain) →
   rouvrir → attendu : redirection propre vers la connexion, AUCUN écran
   d'erreur brut, aucune donnée locale corrompue. ☐
4. **Déconnexion** (si bouton exposé dans l'app) → attendu : retour
   connexion, session serveur invalidée. ☐
5. **Isolation** : se connecter avec un 2e compte Google → attendu :
   crédits/historique du 1er compte NON visibles. ☐

## B. Caméra réelle (exigences 5.4/5.8, arbitrage C)

*Déjà qualifié logiciel* : parcours guidé complet avec rushs réels
(émulateur), permissions refusées sans crash, « Refaire », conservation,
export MP4.

1. **Permission système** : 1re ouverture de l'écran caméra → dialogue
   SYSTÈME Android réel → refuser → attendu : dialogue produit « Accès
   caméra nécessaire » (PLUS TARD/AUTORISER), ré-explication au 2e appui,
   aucun crash. ☐
2. **Caméra avant** : vérifier le comportement (le guide utilise la caméra
   ARRIÈRE uniquement — arbitrage C) : confirmer sur le terrain si la
   caméra arrière convient à toutes les scènes (notamment « Un vêtement
   porté »). ☐
3. **Occupation caméra** : ouvrir une autre app caméra en mode
   enregistrement (ex. appareil photo en vidéo), basculer sur l'app →
   attendu : pas de crash bloquant (note : le bind initial n'a pas de
   garde explicite — défaut documenté 5.8, à signaler si reproduit). ☐
4. **Pendant l'enregistrement** : couper/pré-remplir le stockage (vidéos
   jusqu'à presque plein) → prendre une vidéo → attendu : message « prise
   échouée » propre, fichier corrompu supprimé, reprise possible. ☐
5. **Micro** : refuser la permission micro au dialogue système → attendu :
   vidéo muette, parcours JAMAIS bloqué. ☐

## C. Voix réelle / tournage (exigence 6.8)

*Déjà qualifié logiciel* : structure 3 modes (voix/musique seule/voix+musique),
bancs JVM, e2e musique seule, guide tournage 817 contrôles.

1. Choisir un gabarit en mode **voix** → parler pendant les prises →
   attendu : la voix est présente dans l'export, synchronisée avec le
   guide. ☐
2. Mode **musique seule** → aucun mot à dire n'est exigé (règle produit :
   parler est facultatif). ☐
3. Écouter l'export final (casque + haut-parleur) : niveaux corrects, pas
   de saturation, démarrage sonore sans coupure. ☐

## D. Terrain réseau (exigences 3.11/3.12 vécues)

1. **Mode avion** : lancer l'app, parcourir catalogue/gabarits → attendu :
   tout consultable (contenu embarqué), aucun écran de blocage. ☐
2. Réseau faible (2G/3G si possible) → attendu : lenteurs tolérées, aucun
   crash, état local jamais corrompu. ☐

## E. Confort téléphone réel (exigences 9.x)

1. **Rotation** : tourner le téléphone en paysage partout → attendu :
   l'app reste portrait (verrouillé par design) — aucun écran cassé. ☐
2. **Fontes agrandies** : paramètres Android → police au max → refaire le
   parcours onboarding→brief → attendu : textes lisibles, boutons
   accessibles (déjà 23/0/0 en fontScale 1.3 émulateur). ☐
3. **Clavier** : remplir le brief avec le clavier du téléphone (dont le
   champ WhatsApp avec +code pays) → attendu : validation à 5 champs OK. ☐

## F. Après les tests — rapport

Noter tout FAIL avec : étapes exactes, modèle du téléphone, version
Android, heure, capture si possible. Les FAIL ouvrent des correctifs
avant remise publique ; les arbitrages A-E restent des décisions produit
(rapport final §2, D1-D9).
