# RAPPORT_AUDIT_SERVEUR.md — Infrastructure Cloudflare, Stockage & Authentification

**Rôle :** Lead Backend & Infrastructure Architect · **Périmètre audité :** dépôt
`vitrine-video` (worker `src/index.js`, `wrangler.jsonc`, migrations D1) ·
**Méthode :** chaque affirmation cite sa preuve (fichier/ligne) ; ce qui n'existe
pas est déclaré absent, jamais imaginé.

---

## A. ARCHITECTURE & SÉCURITÉ CLOUDFLARE

### A.1 Rôle du Worker (`vitrine-video-api`)

Configuration (`wrangler.jsonc`) : `main = src/index.js`, `compatibility_date`
figée (2026-10-17), `workers_dev = true`, binding D1 `DB` (prod
`0dacf519-c4bd-40f6-baf7-75d9cdde2af6` ; preview isolée `5b9060b1-…` via
`wrangler.preview-migrations.jsonc`), `vars` stockage B2, observabilité logs
**persistés** (sampling 1).

| Fonction | Implémentation | Preuve |
|---|---|---|
| Automatisation | cron `0 3 * * *` = audit orphelins du bucket (ListObjectsV2 **lecture seule**, pages bornées, plafond 1 500 objets, clé d'audit **séparée**) | `triggers.crons`, `src/index.js:800-971` |
| Traitement des requêtes | routeur REST stateless : 25 routes (`/health`, `/api/v1/me*`, `/templates*`, `/merchants`, `/projects`, `/orders*` + uploads sign/confirm, `/notifications*`, `/assets/*`, `/telemetry`, `/flags`, `/consents`, `/me/referral*`, `/me/welcome-grant`, `/quota/consume`, `/internal/billing/webhook`) | `src/index.js:4927-5003` |
| Quotas & bornes | pagination stricte `limit 1-50` validée (400 sinon) ; réponses bornées (« Invalid response size limit ») ; SQL 100 % préparé (`bind`, zéro concaténation) | `src/index.js:641-653,139` ; grep concaténation SQL = vide |
| Quota plateforme (free) | Workers ≈ 100 k req/j ; D1 free (lectures/écritures j bornées) ; B2 free 10 Go / 1 Go download j ; cron quotidien compatible free | documentation plateforme (ordre de grandeur) |

### A.2 Stockage & distribution des fichiers — **Backblaze B2, pas R2**

Correction factuelle importante : **aucun binding R2 n'existe** dans ce projet.
Le stockage objet = **Backblaze B2** via API S3 (`B2_ENDPOINT s3.us-east-005.backblazeb2.com`),
plus un bucket d'assets publics (`VV_ASSETS_BUCKET`).

| Mécanisme | État | Preuve / attention |
|---|---|---|
| Uploads rushs commandes | ✅ **URLs signées** : `POST /orders/{id}/uploads/sign` → signature HMAC + `ORDER_LIFECYCLE_SECRET`, confirm obligatoire avant traitement | `src/index.js:40,4936-4937` |
| Séparation des clés | ✅ clé orders (`B2_APPLICATION_KEY`) ≠ clé audit cron (`B2_AUDIT_*`, lecture seule) ; secrets via `wrangler secret put`, **absents du repo** | `src/index.js:736,859` ; grep repo = vide |
| Lecture assets gabarits | 🔓 bucket **public** en lecture (`/api/v1/assets/*` = proxy URL directe) : **pas d'URL signée en lecture, pas d'anti-hotlinking** | `src/index.js:1786-1801` |
| Audit orphelins | ✅ lecture seule, préfixe borné, plafond 1 500, clé dédiée | `src/index.js:800-971` |
| Identifiant non sensible en clair | ⚠️ `B2_KEY_ID` dans `vars` (commité) : identifiant public par nature chez B2, mais à déplacer en secret si politiquement sensible | `wrangler.jsonc` |

### A.3 Sécurité réseau & edge

| Protection | État réel | Commentaire |
|---|---|---|
| Anti-DDoS | ✅ passif | tout Worker est derrière le réseau Cloudflare (mitigation always-on incluse) |
| WAF personnalisé | ❌ non configuré | domaine `workers.dev` ; règles WAF managées non activées (free : règles limitées) |
| Rate-limiting | ❌ **absent** (ni règle Cloudflare, ni middleware worker) | point d'attention n°1 : `/quota/consume` et `/telemetry` sont les cibles naturelles |
| Filtrage applicatif | ✅ validation stricte des entrées (enums, bornes 1-50, regex refs `^[A-Z]{2,6}-…`) | `BillingCheckout.isValidRef`, `src/index.js:641-653` |
| CORS / headers sécurité | ❌ absents (pas d'`OPTIONS`, ni HSTS/CSP) | acceptable tant que le client est natif Android ; **obligatoire avant la PWA iOS** |
| Observabilité | 🔧 logs persistés ✅ ; `traces` et `issue_detection` **désactivés** | à activer en production réelle |

---

## B. CONFIGURATION « KAFA » & BACKEND

### B.1 Kafa : **absent du périmètre — déclaration honnête**

`grep -ri kafa` sur l'intégralité du dépôt (code, configs, docs, migrations) :
**zéro occurrence**. Aucun composant, service, variable d'environnement, route ou
document nommé « Kafa » n'existe dans l'infrastructure sous ma responsabilité.
Je ne peux donc pas auditer une configuration que je ne vois pas, et je ne vais
pas en inventer une.

Deux hypothèses, à trancher par vous :
1. **Kafa est un orchestrateur externe côté EPD HOLDING** (hors de ce repo) :
   le contrat d'intégration existant dont il dispose est exactement la table des
   25 routes ci-dessus + D1 (via migrations versionnées 0001-0003, coffre-fort
   intouchable) + B2 (uploads signés) + JWT Firebase. Toute évolution doit passer
   par routes additives §2.4, jamais par modification de `src/` existant.
2. **Kafa est un nom interne pour une partie de ce worker** : donnez-moi sa
   définition fonctionnelle et je produis l'audit correspondant point par point.

### B.2 Authentification & maintien d'état (ce qui existe réellement)

| Mécanisme | Implémentation | Preuve |
|---|---|---|
| Jetons | Firebase ID token vérifié **à chaque requête protégée** : `jwtVerify` (jose) via JWKS distant `createRemoteJWKSet`, algorithme **RS256 imposé**, `issuer = securetoken.google.com/vitrine-video`, `audience = PROJECT_ID`, `sub` obligatoire ; **aucun secret partagé** pour l'auth | `src/index.js:2,407-435` |
| Routes publiques assumées | `/health`, `/templates*`, `/assets/*`, `/flags`, `/ins/profile` (contenu non sensible) | `src/index.js:4944-4964` |
| Route interne billing | bearer secret dédié **+ signature HMAC** (`ORDER_LIFECYCLE_SECRET`, `B2_AUDIT` séparés) — le webhook paiement **existe côté worker** | `src/index.js:40,798,4969` |
| État serveur | D1 (users, credits/entitlements, referrals, orders, notifications, telemetry, consents) ; worker **stateless** (zéro session cookie, zéro mémoire) | schémas migrations 0001-0003 |
| État client | Room local (`EntitlementsDao`…) = droits offline + grace ; cache catalogue disque | module `data` |
| Admin | ⚠️ **aucune route admin serveur** : gate admin = `AdminGate` côté client (email) | grep admin src/index.js = vide |

---

## C. BILAN SÉCURITÉ ACTUEL

### C.1 100 % opérationnel & verrouillé

1. Auth JWT Firebase RS256 JWKS, issuer/audience/sub stricts, sans secret partagé.
2. SQL intégralement préparé (bind) — injection SQL fermée.
3. Uploads B2 par URLs signées HMAC + confirmation obligatoire ; clés orders/audit séparées ; secrets hors repo.
4. Audit orphelins cron lecture seule, borné (1 500), clé dédiée.
5. Isolation prod/preview D1 + migrations versionnées preview séparées.
6. Validations d'entrée strictes (bornes, enums, regex) ; réponses bornées.
7. Webhook billing interne protégé (bearer + HMAC) — idempotence spécifiée.
8. Observabilité logs persistés ; compatibility_date figée (pas de dérive runtime).

### C.2 Limites & points d'attention (priorisés)

| # | Point | Sévérité | Recommandation |
|---|---|---|---|
| 1 | Pas de rate-limiting (app ou edge) | **Haute** | middleware worker (fenêtre glissante par JWT/IP via D1 ou cache edge) + règle Cloudflare au passage en domaine propre |
| 2 | Bucket assets public : pas d'URL signée lecture, pas d'anti-hotlinking | Moyenne | signer la lecture (expiry courte) ou référentiel-token ; sinon assumer le public (gabarits = non sensibles) |
| 3 | Domaine `workers_dev` public, pas de WAF custom | Moyenne | domaine propre + TLS strict + règles WAF managées à l'ouverture publique |
| 4 | Pas de headers sécurité/CORS | Moyenne (PWA) | HSTS/CSP/CORS au moment de la PWA iOS |
| 5 | Pas de route admin serveur (gate client seulement) | Moyenne | routes admin sous JWT + claim email vérifié **serveur** |
| 6 | `traces`/`issue_detection` désactivés | Basse | activer à la mise en production commerciale |
| 7 | `B2_KEY_ID` en clair dans `wrangler.jsonc` | Basse | acceptable (identifiant), à basculer en secret par politique interne |
| 8 | « Kafa » : composant inconnu/absent | **À clarifier** | définition fonctionnelle ou accès à sa config pour audit complet |

**Verdict d'architecte :** le socle serveur est sain et défendable en production
communautaire (auth sans secret, écriture signée, lecture bornée, zéro SQL brut) ;
les trois chantiers de durcissement à planifier avant ouverture commerciale sont
**rate-limiting, domaine propre+WAF, admin serveur**. Aucune vulnérabilité
critique active identifiée dans le code audité.
