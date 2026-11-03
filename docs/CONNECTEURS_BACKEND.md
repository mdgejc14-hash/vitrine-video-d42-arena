# Connecteurs backend — autonomie totale 0 FCFA (guide opératoire)

Objectif : rendre l'APK `vitrine-video-apk-release` 100 % autonome en production
(side-loading site EPD HOLDING) sans aucun coût fixe d'infrastructure.
Rappel architecture : **Firebase Auth** (SSO Google) + **Cloudflare Workers v0.9.0 + D1**
(Phase A livrée, commit `4439cf6`) + paiements **FedaPay / CinetPay** (frais par transaction uniquement).

---

## 1. Firebase Auth & Google SSO (1-tap, sans téléphone)

### 1.1 Particularité du projet : PAS de `google-services.json`
L'initialisation est **manuelle** (`FirebaseAuthGateway` : `FirebaseOptions.Builder()`),
les clés sont injectées **au build** par propriétés Gradle — aucun fichier de clés
dans le dépôt (coffre-fort intact). Si vous préférez malgré tout le plugin
`google-services` : placer `google-services.json` à la racine `app/` — mais ce n'est
pas requis et ce n'est pas le chemin câblé aujourd'hui.

### 1.2 Console Google Cloud (compte Gmail administrateur)
1. **Client OAuth Web** (type « Application Web ») → copier l'ID
   `xxxxxxxx.apps.googleusercontent.com` → c'est `vvGoogleServerClientId`
   (utilisé par `GoogleSsoClient` via Credential Manager) ET `vvWebClientId`.
2. **Client OAuth Android** (package `video.vitrine.app`) avec le **SHA-256 de la clé
   qui signe l'APK distribué** :
   ```bash
   keytool -list -v -keystore vitrine.keystore -alias vitrine
   # empreinte SHA-256 interne actuelle : d18c1098…3a (certificat CN=Vitrine Video Interne)
   ```
   Répéter pour la clé **debug** (tests) : `~/.android/debug.keystore` (alias androiddebugkey).
3. **Écran de consentement OAuth** : ajouter le Gmail administrateur en compte de test
   pendant la phase « Testing », puis publier en production.

### 1.3 Console Firebase (projet `vitrine-video`)
1. Authentication → Sign-in method → **Google** : activer, coller le client OAuth Web.
2. Paramètres du projet → Général : récupérer **Clé API web** (`AIza…`) → `vvFirebaseApiKey`
   et **ID de l'application Android** (`1:…:android:…`) → `vvFirebaseAppId`.
3. Ajouter l'empreinte SHA-256 release dans l'app Android Firebase (utile Analytics/Dynamic Links).

### 1.4 Build de production autonome
```bash
./gradlew :app:assembleRelease \
  -PvvGoogleServerClientId="XXXX.apps.googleusercontent.com" \
  -PvvWebClientId="XXXX.apps.googleusercontent.com" \
  -PvvFirebaseApiKey="AIza…" \
  -PvvFirebaseAppId="1:…:android:…" \
  -PvvAdminEmails="admin@epdholding.com"
```
`AdminGate` (core-model, testé JVM) reconnaît alors le Gmail administrateur pour les accès complets.

---

## 2. Cloudflare Workers v0.9.0 + base D1 (`wrangler.jsonc`)

### 2.1 Bases D1 existantes (Phase A, à NE PAS recréer)
| Environnement | Nom | database_id |
|---|---|---|
| Production | `vitrine-video-db` | `0dacf519-c4bd-40f6-baf7-75d9cdde2af6` |
| Preview | `vitrine-video-db-preview` | `5b9060b1-60c5-460c-b88f-702d3cf6e432` |

Migrations 0001–0003 déjà appliquées (11 tables). Fichiers : `wrangler.jsonc` +
`wrangler.preview-migrations.jsonc` ; cron d'audit `0 3 * * *`.

### 2.2 Liaison D1 dans `wrangler.jsonc` (existant, vérifier les IDs)
```jsonc
"d1_databases": [
  { "binding": "DB", "database_name": "vitrine-video-db",
    "database_id": "0dacf519-c4bd-40f6-baf7-75d9cdde2af6",
    "migrations_dir": "migrations" }
]
```

### 2.3 Variables & secrets à poser pour l'autonomie crédits/parrainage
```bash
wrangler secret put FEDAPAY_SECRET_KEY      # sk_live_… (jamais en clair dans wrangler.jsonc)
wrangler secret put FEDAPAY_PUBLIC_KEY      # pk_live_…
wrangler secret put CINETPAY_API_KEY        # clé API checkout v2
wrangler secret put CINETPAY_SITE_ID        # id de site (numérique)
wrangler secret put WEBHOOK_HMAC_SECRET     # secret partagé de signature webhooks
wrangler secret put B2_AUDIT_BEARER         # bearer dédié audit orphelins (existant Phase A)
```
`[vars]` (non sensibles) :
```jsonc
"vars": {
  "CURRENCY": "XOF",
  "CREDIT_PACKS": "[{\"id\":\"pack_3\",\"credits\":3,\"price_xof\":1500},{\"id\":\"pack_10\",\"credits\":10,\"price_xof\":4000}]",
  "REFERRAL_BONUS_CREDITS": "1",
  "JWT_ISSUER": "https://securetoken.google.com/vitrine-video"
}
```
Le solde de crédits et la jauge de parrainage vivent déjà en D1 (tables applicatives
Phase A) ; le worker lit/écrit via le binding `DB` — aucune nouvelle table nécessaire
pour la recharge (ligne de transaction = table existante des crédits).

### 2.4 Routes additives prévues (coffre-fort src/ intact, migrations 0004+ si besoin)
| Route | Rôle |
|---|---|
| `POST /api/v1/billing/checkout` | crée la transaction FedaPay ou CinetPay selon `channel` |
| `POST /api/v1/billing/webhook/fedapay` | confirme + crédite (idempotent) |
| `POST /api/v1/billing/webhook/cinetpay` | confirme + crédite (idempotent) |
| `GET  /api/v1/credits/balance` | solde + jauge parrainage (déjà authentifié JWKS Phase A) |

---

## 3. Passerelles Mobile Money & Cartes (0 FCFA de fixe)

### 3.1 FedaPay (Bénin : MTN Mobile Money, Moov Money, Celtiis Cash)
| Élément | Valeur |
|---|---|
| Base production | `https://api.fedapay.com` |
| Base sandbox | `https://sandbox-api.fedapay.com` |
| Authentification | Header `Authorization: Bearer sk_live_…` |
| Création | `POST /v1/transactions` : `{amount, currency:"XOF", description, customer{email,phone}, metadata{uid, pack_id}}` |
| Webhook | Route réelle du Worker : `POST /api/v1/internal/billing/webhook` (générique, signature HMAC-SHA256 `x-webhook-signature`, idempotent par `ref`). Un adaptateur FedaPay traduit `transaction.succeeded` vers ce format ; il reste à développer (route additive §2.4). URL publique officielle : `https://vitrine-video-api.mdgejcinfluence.workers.dev/api/v1/internal/billing/webhook`. |
| Checkout client | `checkout_url` renvoyé par l'API → ouvrir dans Custom Tab (USSD/OTP opérateur) |

### 3.2 CinetPay (Wave + cartes bancaires + complément MTN/Moov)
| Élément | Valeur |
|---|---|
| Base | `https://api-checkout.cinetpay.com/v2` |
| Authentification | Body : `apikey` + `site_id` |
| Création | `POST /payment/init` : `{transaction_id, amount, currency:"XOF", description, channels:["MOBILE_MONEY","CARD"], notify_url, return_url, customer{...}}` |
| Confirmation | Notification POST sur `notify_url` puis vérification serveur `POST /payment/check` (source de vérité) |
| Webhook HMAC | comparer l'en-tête de signature avec `WEBHOOK_HMAC_SECRET` avant tout crédit |

### 3.3 Matrice de couverture recherchée
| Moyen | Passerelle |
|---|---|
| MTN Mobile Money | FedaPay (principal), CinetPay (repli) |
| Moov Money | FedaPay (principal), CinetPay (repli) |
| Celtiis Cash | FedaPay |
| Wave | CinetPay |
| Carte bancaire | CinetPay |

Règle d'or webhook : **idempotence** (clé = id transaction passerelle) + re-vérification
serveur (`/payment/check` CinetPay, `GET /v1/transactions/{id}` FedaPay) avant d'écrire
le crédit en D1. Aucune créditation sur simple appel client.

---

## 4. Checklist de recette avant mise en ligne
1. `./gradlew :app:assembleRelease -P…` (4 propriétés §1.4) → APK signé clé interne.
2. Installer sur téléphone test → SSO 1-tap Gmail administrateur OK.
3. `wrangler deployments` (prod) → `/health` = `status=ok, database=connected, schema=ready`.
4. Checkout sandbox FedaPay 100 XOF → crédit D1 +1 pack ; webhook rejoué 2× = solde inchangé (idempotence).
5. Artifact CI `ci-visual-check` : 5 PNG conformes (langues, carousel, secteurs 3D, catalogue, header).
