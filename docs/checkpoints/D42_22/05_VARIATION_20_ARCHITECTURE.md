# D42.22 — 05. ARCHITECTURE 20 VARIATIONS — VÉRIFIÉE AU CODE (D42.22)

## Serveur (src/index.js, routeAudioTrack)
- `?v=N` : N entier 1..20 sinon **400 invalid_variation** ; piste STRICTEMENT
  `categorie_audio = ? AND variation = ? AND statut='EN_LIGNE'` — **jamais de
  bascule silencieuse vers un autre gabarit** ; absente → **404
  variation_not_available**.
- Sans `?v` : master titulaire → object_key_mp3 → repli bgm_library
  variation 1 (ORDRE BY variation) avec promotion EN_LIGNE honnête.
- Cache bord : clé (catégorie, ?v, AUDIO_CACHE_EPOCH) ; les requêtes Range ne
  sont JAMAIS servies depuis/vers le cache plein ; cache-control immutable.

## Client (data/audio/BgmSelection.kt + BgmStore.kt)
- `BgmSelection.choisir` : logique PURE, Random **injectable** (déterministe en
  tests, aléatoire en production) ; ne considère QUE les EN_LIGNE du gabarit
  demandé (revérification du filtre serveur) ; **anti-répétition : exclut les
  K=4 dernières pistes utilisées** du gabarit ; choix uniforme → **jamais la
  variation 1 systématique** ; vide → null → repli titulaire.
- `BgmStore` : historique persisté par gabarit ; téléchargement
  `categorie?v=N` ; **sha256 du fichier vs bgm_library — fichier rejeté si
  divergent** ; adoption du cache legacy si sha conforme ; cache local de la
  bibliothèque par (secteur, format).

## État de production (échelle réelle)
- Le Worker en production (déployé 01/11, pré-D42.21) ne sert PAS encore ?v=N :
  l'app dégrade gracieusement vers le repli titulaire (constaté dans la
  preuve A : musique servie via la route titulaire). Le déploiement D42.22
  (worker-deploy-2) activera la chaîne complète — **BLOQUÉ : secret
  CLOUDFLARE_API_TOKEN vide dans CE dépôt** (voir 08).
- Validation 30 × {1..20} en production : via audio-audit-1 (après déploiement).
