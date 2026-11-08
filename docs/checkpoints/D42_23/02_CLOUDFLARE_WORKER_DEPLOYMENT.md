# D42.23 — 02. RACCORDEMENT CLOUDFLARE (Phase B)

## Worker réellement appelé par Android (vérifié)
- APK (rc10-audio-v2) : `vvApiBaseUrl=https://vitrine-video-api.mdgejcinfluence.workers.dev`
  (gradle.properties → BuildConfig.API_BASE_URL des features) — IDENTIQUE
  à l'URL du wrangler.jsonc (name `vitrine-video-api`, workers_dev true,
  compte d7dac13da931423a19812f6d9116bd47). **App ↔ Worker alignés.**

## État RÉEL de la production (sondes du 08/11 ~08:56-09:10 UTC)
- `GET /` → 200 : service vitrine-video-api, version **0.9.0**, en ligne.
- `GET /health` → 200 : database connected, schema ready,
  applicationTables **8**.
- `GET /api/v1/templates` → 200 (ancien système de templates — non utilisé
  par l'app actuelle, gabarits locaux embarqués).
- `GET /api/v1/me` → **401 « A valid Firebase ID token is required »**
  → **auth Firebase ACTIVE en production**.
- `GET /api/v1/audio/track/{categorie}` (forme EXACTE du code client) →
  **401** : les routes audio (track/catalog/library) EXISTENT en
  production et sont protégées par auth.
- `POST /api/v1/me/welcome-grant` → 401 (route présente, auth).
- `GET /api/v1/billing/return` → **404 Route not found** : marqueur
  DÉCISIF — cette route existe depuis l'ère D41 dans le code du dépôt.
  **→ Le Worker en production exécute le code D40** (celui de `74edd98`,
  déployé le 01/11 via runs 41312068176/41312551179 du privé).
  Il LUI MANQUE : la logique D42.21 `?v=N` (20 variations strictes),
  les routes SKYPAY (checkout/notify/return), les correctifs D41-D42.22.

## D1 (validation indirecte, lecture seule)
- /health : D1 « connected », schéma « ready », 8 tables applicatives —
  cohérent avec migrations 0001-0012 (appliquées au déploiement D40 du
  01/11 selon wrangler.jsonc). **AUCUNE migration nouvelle** entre D40 et
  D42.23 (db/migrations identiques privé↔miroir) → le prochain
  déploiement est CODE-SEUL, sans risque de schéma.
- Validation directe des données (counts bgm_library, EN_LIGNE 564,
  réconciliation B2) : via `audio-audit-1` (lectures uniquement) —
  exécution bloquée D23-1 (voir 01/10).

## Découverte importante : la musique de l'e2e D42.22 n'était PAS la BGM réseau
- Le logcat e2e-official (artefact 13608501901) montre :
  `D42-VERIF: D42.21 : rushs sans audio + BGM planifiée — base silencieuse
  35000ms, musique en gain solo` et AUCUNE requête réseau applicative
  (HttpURLConnection ne journalise pas).
- Le parcours e2e utilise la **session locale (sans compte)** → pas de
  token Firebase → `ensureGabaritCached` n'est PAS appelé →
  `localFile()` seul → fresh émulateur = aucun fichier → le mix audio de
  l'export provient des **SFX/ambiance EMBARQUÉS** (assets WAV :
  amb_chantier, whoosh, clic… — analysis : audio continu sans silence
  > 0,4 s, moyenne −53 dB, identique v1/v2).
- **Conclusion honnête** : l'e2e officiel valide la chaîne EXPORT + SFX,
  PAS le téléchargement BGM authentifié. La chaîne complète
  (login → token → catalog → variation → B2 → cache) sera validée par
  audio-audit-1 (sondes authentifiées) + le test physique. L'affirmation
  D42.22 « musique servie via la route titulaire » est CORRIGÉE ici.

## Déploiement préparé (prêt à exécuter dès déblocage D23-1)
1. Branche `d42.23-production` poussée dans le PRIVÉ (arbre D42.23 =
   miroir main + marqueurs de version).
2. Marqueur de version : `/health` et `/` annoncent `0.9.1-d42.23`
   (bump des 2 chaînes ; aucun test n'assertait 0.9.0 — vérifié).
3. Smoke test deploy RENFORCÉ : en plus des 401 Phase B/C, il exige
   `billing/return = 200` ET `/health` contenant `0.9.1-d42.23` —
   preuve que le code D42.23 est réellement en production.
3bis. **Cadrage architectural des workflows ops** : les 6 workflows
   dépendants de secrets (api-security, deploy, backup, audio-audit,
   audit-retention, preview-migrations) portent désormais
   `if: github.repository == 'mdgejc14-hash/vitrine-video'` — ils
   s'exécutent dans le dépôt PRIVÉ (qui détient les 16 secrets) et sont
   explicitement SAUTÉS dans le miroir public (où ils ne pourraient que
   échouer sans information). Le saut est visible (« skipped »), jamais
   masqué ; la validation fail-fast interne reste en seconde couche.
4. Séquence de déblocage (une fois la limite de dépenses relevée) :
   a. (sécurité) dispatch `Backup D1 to Backblaze B2` sur main du privé
      → backup AVANT toute modification (aucune migration prévue) ;
   b. tag `worker-deploy-3` sur `d42.23-production` dans le privé
      → deploy + smoke (25 min max) ;
   c. dispatch `API Security CI` ref=`d42.23-production` (tests 2 comptes,
      D1 local + .dev.vars depuis secrets) ;
   d. tag `audio-audit-1` sur `d42.23-production` (audit 600/30×20/B2,
      lectures) ;
   e. re-sondage manuel : /health version, ?v=1..20 (401 sans token),
      billing/return 200.
5. Retour arrière : `git revert`/re-tag de l'ancien commit + re-déploiement
   (wrangler deploy est atomique ; le Worker D40 reste en ligne tant que
   le nouveau déploiement ne réussit pas).

## Bindings
- D1 `vitrine-video-db` : connecté (health). B2 `vitrine-video-media` :
  servi via les routes audio (indirectement constaté par le D40 qui a
  servi l'audio aux tests du 01/11) — vérification directe bloquée D23-1.
