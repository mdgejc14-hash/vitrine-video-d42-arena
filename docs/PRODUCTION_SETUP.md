# Passage en production — mode opératoire exact (0 FCFA d'infrastructure fixe)

État validé par l'audit final (31/10/2026) : le code est prêt ; il ne manque que
des **secrets externes** que seul le propriétaire du produit peut créer. Aucune
clé n'est dans le dépôt (scan anti-secrets CI + `.gitignore` + `.dev.vars`).

## 0. ~~BLOQUEUR N°1~~ RÉSOLU — URL officielle du Worker (31/10/2026)

Constat vérifié le 31/10/2026 (audit final) :

| Vérification | Résultat |
|---|---|
| DNS `vitrine.video` | **NXDOMAIN** (non résolu) |
| DNS `api.vitrine.video` | **NXDOMAIN** |
| HTTP `https://api.vitrine.video/health` | aucune réponse (000) |
| `wrangler.jsonc` → `routes` / `custom_domain` | **absent** (seul `workers_dev: true`) |
| Base d'API codée dans l'app | `https://api.vitrine.video` (feature-onboarding, feature-catalog) |

Conséquence : en production, **aucun** appel serveur n'aboutit (bootstrap,
welcome-grant, entitlements, parrainage, webhook). L'app continue de fonctionner
en mode hors-ligne (miroir Room local, conçu pour), ce qui masque le problème à
l'usage — mais la comptabilité serveur, le parrainage et l'encaissement restent
inopérants tant que ce point n'est pas réglé.

**DÉNOUEMENT (fourni par la direction le 31/10/2026)** : option B retenue —
`https://vitrine-video-api.mdgejcinfluence.workers.dev` (health 200, `v0.9.0`).
L'app est alignée (`vvApiBaseUrl` dans `gradle.properties` + fallbacks `.kts`).

⚠ **La version déployée est périmée** : sondée le 31/10/2026, elle ne connaît
pas les routes Phase B (`/api/v1/mobile/bootstrap` → 404) ni les migrations
0004–0010. Avant la mise en production réelle, exécuter :

```bash
npx wrangler deploy                                        # publie le code actuel
npx wrangler d1 migrations apply vitrine-video-db --remote # applique 0001..0010
npx wrangler secret put B2_APPLICATION_KEY                 # cle B2 (voir §0bis)
```

Deux options historiques (le bloc prêt-à-activer est commenté dans `wrangler.jsonc`) :

**A. Domaine propre** — acheter/héberger `vitrine.video` dans le compte
Cloudflare du projet, puis décommenter le bloc `routes` et :
```bash
npx wrangler deploy          # applique routes + vars + D1
```

**B. URL workers.dev (0 FCFA, immédiat)** — déployer puis aligner l'app :
```bash
npx wrangler deploy                      # affiche l'URL réelle *.workers.dev
# puis, côté app (1 ligne dans gradle.properties, aucun code modifié) :
vvApiBaseUrl=https://<url-reelle>.workers.dev
```

Le déploiement exige des credentials Cloudflare (absents du sandbox) : c'est une
action humaine. Dès que l'URL est connue, l'alignement de l'app est une ligne.

## 0bis. Backblaze B2 — clé applicative (fournie le 31/10/2026)

| Élément | Valeur / état |
|---|---|
| Bucket | `vitrine-video-media` (région `us-east-005`) |
| `B2_KEY_ID` | `0051874222bd9b00000000009` — **mis à jour dans `wrangler.jsonc`** (l'ancienne valeur `…001` était périmée) |
| `B2_APPLICATION_KEY` | secret — **jamais en clair dans Git** ; injecté en local via `.dev.vars` (gitignoré) |
| Validation live (31/10/2026) | `ListObjectsV2` signé SigV4 → **HTTP 200**, bucket vide (0 objet) → credentials + bucket + région confirmés |

Commandes de publication (action humaine, credentials Cloudflare requis) :

```bash
npx wrangler secret put B2_APPLICATION_KEY   # coller la clé applicative B2
npx wrangler deploy                          # republie avec le B2_KEY_ID …009
```

⚠ Deux points d'hygiène :
1. La clé applicative a transité par un canal de discussion : **la faire tourner**
   (B2 → App Keys → nouvelle clé, révoquer l'ancienne) après le premier déploiement.
2. `VV_ASSETS_BUCKET` (utilisé par `routeAsset`, Phase A `/api/v1/assets/*`) n'est
   **pas déclaré** dans `wrangler.jsonc` → en production ces routes renvoient 404.
   À ajouter (`wrangler secret put VV_ASSETS_BUCKET` ou var) si le flux assets est requis.

## 1. Firebase / Google Auth (SSO sans téléphone)

L'app n'utilise **pas** `google-services.json` : `FirebaseOptions` est construit
manuellement (`FirebaseAuthGateway.kt`), donc aucune modification de code.

1. Créer le projet Firebase **`vitrine-video`** (l'ID est codé dans
   `src/index.js` : `PROJECT_ID = "vitrine-video"` — issuer + audience du JWT
   sont vérifiés strictement ; un autre ID = 401 systématique).
2. Activer **Authentication → Sign-in method → Google**.
3. Créer un **OAuth Client ID Web** (Credential Manager) :
   `APIs & Services → Credentials → OAuth client ID → Web application`.
4. Récupérer : `FIREBASE_API_KEY` (clé Web), `FIREBASE_APP_ID` (`1:…:android:…`),
   `GOOGLE_WEB_CLIENT_ID`.

Injection (aucun secret dans le dépôt) :

```bash
# Build Android (local ou CI) :
./gradlew :app:assembleReleaseCandidateRelease \
  -PvvFirebaseApiKey=AIza... -PvvFirebaseAppId=1:...:android:... \
  -PvvWebClientId=....apps.googleusercontent.com
```

```yaml
# GitHub Actions (android-ci) — ajouter dans secrets du dépôt :
# VV_FIREBASE_API_KEY, VV_FIREBASE_APP_ID, VV_WEB_CLIENT_ID
# puis passer : -PvvFirebaseApiKey=${{ secrets.VV_FIREBASE_API_KEY }} etc.
```

Sans injection : placeholders `REMPLACE_PAR_*` → le SSO échoue proprement
(message d'erreur E2), le **repli hors-connexion** (bouton E2) reste fonctionnel.

### ÉTAT VÉRIFIÉ (31/10/2026, clés réelles injectées)

Les 3 valeurs fournies par le propriétaire sont **injectées dans
`gradle.properties`** (identifiants clients publics, embarqués dans l'APK ;
override ponctuel : `-PvvFirebaseApiKey=…`). Vérifications exécutées :

| Contrôle | Résultat |
|---|---|
| Projet Firebase réel (claims d'un vrai token) | `iss = https://securetoken.google.com/vitrine-video`, `aud = vitrine-video` → **identique au `PROJECT_ID` du worker** : aucune bascule nécessaire |
| Provider Google (`signInWithIdp`) | Activé (sonde : `INVALID_IDP_RESPONSE` = le token a bien été traité) |
| Provider Email/Mot de passe | Activé (`INVALID_LOGIN_CREDENTIALS`) |
| JWKS Google (validation worker) | HTTP 200 |
| Chaîne auth complète (worker + D1 local) | bootstrap 200 → grant 3 crédits → **entitlements 3** → décompte strict 3→2→1→0 → 4ᵉ consommation reste 0 |
| Anti-abus empreinte (D13) | 2ᵉ grant même empreinte = `granted:false` ; autre compte Google sur même empreinte = rien n'est ré-attribué |
| Jeton falsifié (claims `aud`/`iss` truqués) | 401 |
| JWT imité (bonne forme, clé inconnue) | 401 |
| Sans jeton | 401 |
| Isolation inter-comptes | Compte B = 0 crédit (n'hérite de rien) |

**Comptes de sonde créés dans le projet Firebase** (supprimables dans
Console → Authentication → Users, ou réutilisables comme comptes de test CI) :
`vv-auth-probe@vitrine.video`, `vv-auth-probe-b@vitrine.video`.

### ⚠ Restant à fournir : identifiant d'application ANDROID

Le `FirebaseAppId` fourni est de type **web** (`1:609889830251:web:…`). Pour
Android, l'identifiant attendu est `1:609889830251:android:<hash>`.

1. Console Firebase → *Paramètres du projet* → *Vos applications* →
   **Ajouter une app Android** :
   - package : `video.vitrine.app` (variante release ; la variante QA utilise
     `video.vitrine.app.qa`, à déclarer comme app distincte si vous voulez
     l'authentifier aussi) ;
   - **SHA-1** : celui du keystore de release (`keytool -list -v -keystore …`),
     plus celui de la clé debug pour les bancs QA.
2. Me transmettre l'`applicationId` Android résultant → je remplace
   `vvFirebaseAppId` (1 ligne, `gradle.properties`).

L'authentification fonctionne déjà avec l'ID web (Auth s'appuie sur la clé API),
mais l'ID Android est requis pour App Check / Play Integrity et pour les
restrictions de clé par application — donc à faire avant mise en production.

## 2. Paiement Mobile Money (CinetPay opérationnel ; FedaPay documenté)

### CinetPay (intégré, page hébergée)
1. Ouvrir un compte marchand CinetPay → récupérer le **site_id PUBLIC**.
2. Build Android : `-PvvCinetPaySiteId=XXXX` (champ `BuildConfig.CINETPAY_SITE_ID`).
   Non injecté = le paywall affiche « Paiement non configuré » (jamais de faux succès).
3. Le bouton « Payer avec Mobile Money » ouvre
   `https://sandbox-checkout.cinetpay.com/payment?site_id=…&transaction_ref=VV-…&amount=500|3000|7500&currency=XOF`.
   **Passage production** : remplacer `sandbox-checkout` par `checkout` dans
   `BillingCheckout.cinetPaySandboxUrl` (1 ligne, core-model) après validation
   en sandbox.

### Webhook (créditation automatique, corrigé par l'audit final)
Route : `POST /api/v1/internal/billing/webhook`, signature HMAC-SHA256
(`x-webhook-signature`), idempotent (replay = `200 duplicate:true`), grille
tarifaire finale imposée (montant ≠ 500/3000/7500 pour un plan connu = 422),
statuts normalisés (`paid→active`, `refunded/failed/expired→canceled`).

Il reste à brancher l'**adaptateur prestataire** (relai signé qui traduit le
webhook CinetPay brut vers ce format interne — route additive §2.4, ou petit
relai self-hosté sur la machine QA). Preuves locales :
`livraison/qa-oracle/billing-webhook-proof.txt` + CI « API Security » verte.

### FedaPay (enum `BillingProvider` prêt)
Checkout créé **côté serveur** (secret) → l'app ouvre l'URL de redirection
renvoyée par le worker. Route additive future documentée dans `Plans.kt`.

## 3. Secrets Worker Cloudflare (à poser une fois)

```bash
npx wrangler secret put BILLING_WEBHOOK_SECRET   # >= 32 car. : openssl rand -hex 24
npx wrangler secret put ORDER_LIFECYCLE_SECRET   # >= 32 car.
npx wrangler secret put B2_APPLICATION_KEY       # Backblaze : writeFiles sur vitrine-video-media
npx wrangler secret put B2_ORPHAN_AUDIT_TOKEN    # token interne audit orphelins
npx wrangler secret put B2_AUDIT_KEY_ID          # compte B2 lecture seule
npx wrangler secret put B2_AUDIT_APPLICATION_KEY
```

Vars publiques déjà en place (`wrangler.jsonc`) : bucket, endpoint, région,
`B2_KEY_ID` (identifiant public, pas un secret).

Migrations D1 production (0001→0008, ordre strict, additive seulement) :

```bash
for m in 0001_init 0002_query_indexes 0003_purge_operation_ledger \
         0004_phase_b_mobile 0005_monetisation 0006_consentements \
         0007_croissance 0008_billing_orders; do
  npx wrangler d1 execute vitrine-video-db --remote --file=db/migrations/$m.sql
done
```

## 4. Banc QA self-hosted (déjà livré, C15)

`scripts/setup_runner.sh` sur la machine opérateur (runbook complet), puis
GitHub → Actions → « QA interactive (self-hosted) ». Mock staging :
`mock-server/` (Node pur, port 3200, jamais exposé Internet).

## 4bis. Phase C — audio BGM/SFX (état au 31/10/2026)

| Action | État |
|---|---|
| Structure B2 `audio/bgm/` (30 dossiers + contrat `STRUCTURE.json`) | ✅ créée et vérifiée (31 objets) |
| **Bibliothèque BGM : 600 variations CC0 sur B2** (`audio/bgm/<secteur>/<T#>/…_vNN.mp3`) | ✅ téléversées par script et vérifiées HEAD×600 (existence + taille exacte, 31/10/2026) |
| **Migrations 0001→0011 sur D1 prod** (`merchant_identity`, `billing_orders`, `audio_catalog`, `bgm_library` 600 lignes) | ✅ appliquées à distance (run Deploy Production 41208913362, 31/10/2026) |
| **Déploiement du Worker prod (code Phase B/C)** | ⛔ BLOQUÉ : aucun jeton du dépôt n'a « Workers Scripts: Edit » (403 vérifié sur les 2 jetons). Action client 2 min : dashboard Cloudflare → My Profile → API Tokens → *Edit Cloudflare Workers* (compte d7dac13d…) → mettre à jour le secret GitHub `CLOUDFLARE_API_TOKEN` → relancer le workflow `Deploy Production` (tout le reste est autonome) |
| Secret `B2_APPLICATION_KEY` sur le Worker prod | ⬜ `npx wrangler secret put B2_APPLICATION_KEY` (puis `deploy`) — sera possible dès le jeton Workers obtenu ; en attendant, la CI utilise les secrets GitHub (paire …009) |
| 30 morceaux réels (CC0, −14 LUFS, ≥ durée gabarit) | ⬜ acquisition + téléversement humains (`docs/AUDIO_BGM_TELEVERSEMENT.md`) — les 600 variations de synthèse servent de repli ÉTIQUETÉ (`origine=synthese_procedurale_v1`), priorité au master humain |
| Écoute humaine banque SFX (9 fichiers embarqués) | ⬜ puis `generate_sfx_bank.py --approuver` |
| Routes Worker + bibliothèque + cache téléphone | ✅ code livré ; suite locale **tous PASS** (49 + 6 contrôles Phase D) avec B2 réel ; CI verte (streaming 200 Range/immutable, library 401/600/100 par secteur) |
| Icône application (APK release) | ✅ logo officiel vérifié DANS l'APK (legacy ×5 densités, adaptive foreground+background+**monochrome**, splash nodpi 288px — couleurs #022358/#F95C0F au pixel) |

## 5. Checklist de bascule (résumé)

> **Mise à jour 31/10/2026** : les clés Firebase sont injectées et la chaîne
> d'authentification est vérifiée de bout en bout contre le projet de
> production. Le worker n'a **pas** été modifié pour cela (`PROJECT_ID`
> était déjà correct).

| Élément | Fourni par | État code |
|---|---|---|
| Projet Firebase `vitrine-video` + Google Sign-In | Propriétaire | Prêt (injecteurs `-Pvv*`) |
| Clés Firebase (API key, app id, web client id) | Propriétaire | Prêt (BuildConfig) |
| site_id CinetPay + compte marchand | Propriétaire | Prêt (`-PvvCinetPaySiteId`) |
| 6 secrets wrangler | Propriétaire | Prêt (`.dev.vars.example`) |
| Adaptateur webhook CinetPay→interne | Dév (route additive) | **À faire** (le reste de la chaîne est prouvé) |
| URL checkout production (sandbox→prod) | Dév (1 ligne) | **À faire** après validation sandbox |
| Runner self-hosted (machine physique) | Opérateur | Prêt (`setup_runner.sh`) |
