# D42.14 — Backend HTTP (Worker réellement démarré)

## Dispositif (aucune production touchée)

| Élément | Valeur |
|---|---|
| Base | **D1 locale** construite par les **12 migrations** `db/migrations/*.sql` |
| Serveur | `wrangler dev --local` sur `127.0.0.1:8788` — **Worker réellement exécuté** |
| Run | dépôt miroir public, job `backend-http`, commit `7bcc41f` |
| Secrets | **aucun** secret réel ; aucune requête sortante vers Cloudflare |
| Durée | 26 s (job) — coût 0 FCFA |

## Résultat : 15 / 15 PASS — 0 FAIL

| # | Vérification | Attendu | Obtenu |
|---|---|---|---|
| H1 | `GET /health` | 200 | **200** `{"status":"ok","database":"connected","schema":"re…"}` |
| H2 | `GET /` | 200 | **200** `vitrine-video-api 0.9.0` |
| H3–H7 | 5 routes protégées **sans jeton** (`/me`, `/me/entitlements`, `/me/referral`, `quota/consume`, `me/welcome-grant`) | 401 | **401** chacune |
| H8 | JWT `alg=none` | 401 | **401** |
| H9 | **Confusion d'algorithme** (HS256 signé avec la clé publique) | 401 | **401** |
| H10 | `POST /billing/checkout` sans identité | **401 avant 501** | **401** |
| H11 | Route inconnue | 404 | **404** |
| H12 | Méthode incorrecte sur `/health` | 404/405 | **404** |
| H13 | Préflight CORS | 200–204 | **204** |
| H14 | Type de contenu | `application/json` | `application/json; charset=utf-8` |
| H15 | Jeton dans l'URL (`?token=`) | 401 | **401** |

Artefacts : `artefacts/http_run.txt`, `artefacts/http_contract_report.json`.

## Ce que cela prouve

1. Le Worker **démarre** sur le schéma complet et **atteint la base**.
2. **Aucune route sensible n'est ouverte sans identité**, facturation comprise (401 **avant** 501 : aucune fuite d'état).
3. **La vérification de signature est réelle** : `alg=none` et confusion RS256/HS256 rejetés.
4. La surface est fermée : route inconnue → 404, jeton en URL inutilisable, CORS borné.

## Ce que cela ne prouve pas — et pourquoi c'est écrit

Les routes **authentifiées** (crédits, parrainage, isolation inter-comptes, `501` réel de la facturation)
n'ont **pas** été exercées :

```js
// src/index.js, lignes 8-12
const FIREBASE_KEYS = createRemoteJWKSet(
  new URL("https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com")
);
```

L'URL JWKS est **en dur** : aucun jeton local ne peut la contourner, et aucune clé privée Google
n'est disponible (et ne doit l'être). **Statut : `BLOCKED`** pour ces routes.

### Alternatives examinées (et pourquoi elles ne sont pas retenues)

| Alternative | Verdict |
|---|---|
| Rendre l'URL JWKS configurable (`env.FIREBASE_JWKS_URL`) | **refusée sans autorisation** : une variable d'environnement mal réglée en production permettrait de forger des jetons. C'est un point d'entrée d'attaque permanent pour gagner un test. |
| Signer des jetons avec la clé privée Google | impossible (et interdit) |
| Compte Firebase de test (e-mail + mot de passe) + `FIREBASE_WEB_API_KEY` | **la seule voie propre** — 10 min, aucun code à modifier |
| Contourner la couche HTTP et tester la base | déjà fait : `backend_invariants.py` — **14 PASS / 0 FAIL**, 24 tables / 37 index, isolations A/B à 0 ligne |

## Complément déjà acquis (D42.13, conservé) : invariants de base

| Contrôle | Résultat |
|---|---|
| `welcome_grants.fingerprint` UNIQUE | PASS |
| `quota_ledger.event_id` clé primaire (idempotence) | PASS |
| `referrals.referred_id` UNIQUE | PASS |
| `merchant_identity.referral_code` UNIQUE | PASS |
| Isolation compte A / compte B | **0 ligne** traversante |
| Auto-parrainage | **accepté par la base** — la garde n'existe que dans `src/index.js:2478` (défaut ouvert D11) |
