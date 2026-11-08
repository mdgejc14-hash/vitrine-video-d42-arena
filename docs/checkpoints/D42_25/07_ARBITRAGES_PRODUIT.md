# D42.25 — 07. ARBITRAGES PRODUIT (décisions fondateur — aucune modification sans décision)

Deux constats issus de l'audit audio P1-D (run 42493755744, preuves
complètes dans 04_AUDIO_AUDIT.md) appellent un arbitrage produit. **Rien
n'a été modifié** — ni les 600 compositions, ni D1, ni le code. Ce document
pose les faits, les options et leurs conséquences pour permettre la
décision.

---

## ARBITRAGE A — Silence initial de la musique (1,0 à 3,1 s)

### Les faits (mesurés + lus dans le code)

- Audit acoustique : **60/60 pistes** (30 gabarits × v01+v20, 6 secteurs)
  commencent par **1,03 à 3,07 s de silence** (seuil −40 dB) ; silence
  final 0,00 s ; pistes calibrées −16 LUFS / −1 dBTP ; 0 clipping.
- Diagnostic code (ce tour, lecture seule) : `BgmDecoder.kt` décode la
  piste **depuis l'échantillon 0** (aucun retrait de silence) et
  `BgmSfxAudioMixer.kt` démarre la musique **à la frame 0** de la
  composition avec un **fade-in de 0,45 s** (`AudioChain.MUSIC_FADE_IN_S`)
  puis un fade-out de 0,75 s en fin.
- **Conséquence directe** : dans les vidéos exportées, la musique devient
  audible environ **1,5 à 3,5 s** après le début (silence source + fade-in).
  Le montage auto n'absorbe PAS le silence — il s'ajoute au fade-in.
- Nuance importante : quand la vidéo contient une **voix off**, c'est elle
  qui ouvre la vidéo (la musique est atténuée par le ducking −14 dB) — le
  silence initial est alors peu perceptible. Il est surtout audible en
  **mode solo** (rushs sans voix, musique seule).

### Les options

**A1. Statu quo accepté et documenté** *(0 modification)*
- Ce que ça implique : rien à changer ; la décision est inscrite au
  rapport final comme choix produit.
- Avantages : 0 FCFA, 0 risque, 0 requalification ; les 1 200 preuves
  d'intégrité (600 pistes + sha256) restent valides.
- Inconvénients : chaque vidéo démarre ~1,5-3,5 s sans musique ; sur les
  réseaux sociaux, les 3 premières secondes sont stratégiques (démarrage
  possiblement perçu comme « mou » en mode solo).
- Quand la choisir : si l'effet d'entrée progressive est voulu
  (esthétique « la musique arrive »), ou si la voix off couvre le début
  dans la plupart des usages réels.

**A2. Absorption au montage (côté application)** *(recommandée si correction souhaitée)*
- Ce que ça implique : détecter le silence initial au décodage/mixage
  (premier échantillon au-dessus d'un seuil RMS) et décaler d'autant le
  point de départ de la musique — le fade-in de 0,45 s s'appliquerait
  alors sur le DÉBUT RÉEL du son. Changement confiné au module
  `ins-effects` (BgmDecoder/BgmSfxAudioMixer + test MixBenchAudioTest).
- **Ne touche NI aux 600 compositions, NI à B2, NI à D1** : les fichiers
  servis restent strictement identiques (compatible avec la règle « ne pas
  modifier arbitrairement les 600 compositions ») ; seul le rendu local
  change.
- Coût : 0 FCFA (développement + CI gratuits).
- Inconvénients : cycle de requalification complet — tests JVM du module,
  e2e P1, **nouvelle APK (rc12)** à rebuilt/signer/requalifier, redépôt de
  la référence distribution. De l'engénierie pour un détail esthétique.
- Quand la choisir : si après écoute d'une vidéo réelle le démarrage paraît
  manquer de punch.

**A3. Retrait du silence dans les 600 fichiers sources** *(non recommandé)*
- Ce que ça implique : re-traiter les 600 fichiers (trim ffmpeg), les
  re-téléverser, mettre à jour les sha256 dans D1.
- Inconvénients majeurs : **modifie les compositions certifiées** (votre
  règle l'interdit sans décision expresse) ; invalide TOUTES les preuves
  d'intégrité actuelles (chaque sha256 change) ; nécessite une
  re-certification P1-C/P1-D complète ; risques de régression (coupures
  abruptes, attaque trop sèche sans fade d'entrée).
- Quand la choisir : uniquement si des sources « parfaites » sont exigées
  pour un autre usage (par ex. banque musicale réutilisée ailleurs).

### Élément de décision pratique
Écouter une vidéo exportée réelle (l'e2e P1 en produit — artefact MP4 de
9,1 Mo disponible) : si le démarrage convient → **A1** ; sinon → **A2**.
Dans tous les cas, A2 reste possible plus tard sans rien refaire côté
serveur.

---

## ARBITRAGE B — Clés titulaires `audio_catalog` (54/60 absentes de B2)

### Les faets (mesurés + lus dans le code)

- La table `audio_catalog` référence un « master titulaire » par gabarit
  (clés `.mp3`/`.m4a` SANS numéro de variation) : **54/60 n'existent pas
  dans le bucket B2 (HTTP 404)** ; 6 existent.
- `routeAudioTrack` (src/index.js, prouvé) : sans `?v`, le worker sert le
  master titulaire **s'il existe, SINON repli sur la variation 1** de
  `bgm_library`. Le service est donc 100 % fonctionnel : l'utilisateur
  reçoit toujours de l'audio (v01 pour 54 gabarits).
- La bibliothèque servie (`bgm_library`, 600 variations) est, elle,
  **complète et réconciliée** (600/600 en B2, sha256 conformes).

### Les options

**B1. Aligner D1 sur la réalité** *(recommandée)*
- Ce que ça implique : une migration D1 versionnée (0013) qui remplace,
  dans `audio_catalog`, les clés titulaires fantômes par les clés v01
  réelles de `bgm_library` (ou supprime les lignes et laisse le repli
  opérer).
- Avantages : cohérence D1↔B2 parfaite (l'audit audio passerait 100 %,
  plus aucun FAIL de réconciliation) ; **comportement utilisateur strictement
  identique** (v01 servie avant comme après) ; dette technique fermée ;
  0 FCFA.
- Prérequis (règles maison) : **sauvegarde D1 avant migration + retour
  arrière préparé** → il faut donc d'abord FERMER P1-E (la sauvegarde est
  justement le filet de sécurité).
- Quand la choisir : dès que P1-E est vert, si vous voulez un état
  propre pour la suite (recommandé avant tout nouveau développement).

**B2. Téléverser les 54 masters dans B2** *(seulement s'ils existent et sont distincts)*
- Ce que ça implique : retrouver les fichiers masters d'origine et les
  téléverser sous les clés D1 existantes.
- Point critique : **d'où viendraient-ils ?** S'ils n'ont jamais été
  générés/téléversés, il faudrait les créer — et s'ils ne sont qu'une
  copie de v01, c'est du stockage redondant (~36 Mo) pour un contenu
  identique : inutile. Cette option n'a de sens QUE si un master
  réellement distinct (qualité supérieure, version longue…) existe
  quelque part et a une valeur produit.
- Coût : 0 FCFA (stockage dans les limites gratuites), mais sans bénéfice
  si contenu = v01.

**B3. Statu quo documenté** *(0 action)*
- Ce que ça implique : rien ; la divergence reste inscrite dans l'audit
  comme échec documenté couvert par le repli.
- Inconvénients : à CHAQUE futur audit audio, le même FAIL réapparaîtra
  (bruit de fond dans les rapports) ; dette visible permanentement ;
  risque de confusion pour un futur repreneur (« pourquoi 54 clés 404 ? »).

### Élément de décision pratique
Si les masters n'ont pas de valeur distincte (cas le plus probable —
héritage de migration) : **B1** après fermeture de P1-E. Sinon : **B2**.
**B3** reste acceptable si vous préférez ne rien toucher pour l'instant.

---

## Récapitulatif des décisions attendues

| Arbitrage | Options | Recommandation agent | Décision fondateur |
|---|---|---|---|
| A — silence initial 1-3 s | A1 statu quo / A2 montage / A3 sources | A2 si correction voulue, sinon A1 (A3 déconseillé) | ☐ |
| B — clés titulaires | B1 aligner D1 / B2 téléverser / B3 statu quo | B1 (après P1-E vert) | ☐ |

**Aucune action ne sera entreprise sur ces deux sujets sans votre décision
explicite.** En attendant : les 600 compositions, D1 et le code restent
intouchés ; l'attente active ne porte que sur les 2 secrets
`B2_BACKUP_KEY_ID`/`B2_BACKUP_APPLICATION_KEY` (guide 06).
