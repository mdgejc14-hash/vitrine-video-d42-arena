# D42.14 — Backend HTTP : deux environnements, 33 contrôles

## 1. Contrat non authentifié — 15/15 (reproduit deux fois)

| Environnement | Où | Résultat |
|---|---|---|
| GitHub Actions (runner public) | job `backend-http`, run `42228009767` | **15 PASS / 0 FAIL** |
| **Bac à sable local** (6 nov., 14 h 12 UTC) | `wrangler dev --local` + 12 migrations | **15 PASS / 0 FAIL** (log : `artefacts/http_run_sandbox.txt`) |

Cette **reproduction indépendante** compte : le résultat CI n'est plus un point unique.
Détail des 15 contrôles : voir `05_BACKEND_HTTP_D42_13.md` — inchangés
(`/health`, `/`, 5 routes sans jeton → 401, `alg=none` → 401, confusion HS256/RS256 → 401,
facturation sans identité → **401 avant 501**, route inconnue → 404, méthode → 404,
préflight → 204, `application/json`, jeton en URL → 401).

## 2. Contrat authentifié — 18/18 (nouveau, ce n'est pas une simulation d'écran)

### Le problème

Les 15 contrôles précédents prouvaient seulement que **tout est rejeté**. Aucune route
métier (crédits, parrainage, isolation, `501` de facturation) n'avait jamais été exécutée :
la JWKS Google est **écrite en dur** (`src/index.js:8-12`) et aucun jeton local ne peut la
satisfaire. Un compte Firebase de test n'existe pas.

### La solution retenue (aucune ligne du produit modifiée)

`tools/e2e/auth_harness.mjs` :

1. **le Worker est importé tel quel** (`import worker from "../../src/index.js"`) ;
2. avant l'import, `globalThis.fetch` est remplacé : l'URL **exacte** de la JWKS Google
   reçoit une **JWKS locale** ; toute autre sortie réseau est **refusée** (compteur à 0) ;
3. `jose` vérifie donc réellement signature, émetteur `securetoken.google.com/vitrine-video`,
   audience `vitrine-video`, expiration ;
4. la base est une **vraie SQLite** (`node:sqlite`, Node 22) sur laquelle sont appliquées
   les **12 migrations**, exposée par un adaptateur D1 minimal (`prepare`/`bind`/`first`/`all`/`run`).

### Résultats

| # | Contrôle | Attendu | Obtenu |
|---|---|---|---|
| 1 | 12 migrations appliquées sur SQLite | 12 | **12/12** |
| 2 | `POST /me/bootstrap` compte A | 200 | **200** |
| 3 | `POST /me/bootstrap` compte B | 200 | **200** |
| 4 | `GET /me` avec jeton valide | 200 | **200** |
| 5 | Identités A et B **distinctes** | oui | `01a1b131-…` ≠ `01a1b131-…f4` |
| 6 | Signature **forgée** (même `kid`, autre clé) | 401 | **401** |
| 7 | Mauvaise **audience** | 401 | **401** |
| 8 | Mauvais **émetteur** | 401 | **401** |
| 9 | Jeton **expiré** | 401 | **401** |
| 10 | Dotation de bienvenue | 200 `granted:true` | **200 `{granted:true, credits_total:3}`** |
| 11 | Dotation **rejouée** | pas de second crédit | `{granted:false, credits_left:3}` — solde inchangé |
| 12 | **Nouvel appareil** pour un compte déjà doté (anti-fraude C16) | refusé | `{granted:false, reason:"already_granted"}` |
| 13 | `POST /billing/checkout` authentifié, plan réel `pass24h` / 500 | **501** | **501 `billing_not_configured`** |
| 14 | `POST /quota/consume` (eventId `evt-d42-001`) | 200 | **200 `{ok:true}`** |
| 15 | **Rejeu** du même `eventId` | pas de second débit | `{ok:true, dup:true}` — aucun débit supplémentaire |
| 16 | **Isolation** : B tente de débiter l'appareil de A | 403 | **403 `fingerprint non lie a ce compte`** |
| 17 | **Auto-parrainage** (`code` = le sien) | refusé | **404 `code invalide`** |
| 18 | Aucune requête sortante hors JWKS | 0 | **0 appel** |

**BILAN : 18/18 PASS — statut `PASS_LOCAL_HARNESS`.**

### Ce que ce banc prouve, et ce qu'il ne prouve pas

| Prouvé | Non prouvé |
|---|---|
| La chaîne de **vérification** (signature, iss, aud, exp) accepte un jeton **valide** — jamais testé jusqu'ici | Que Google émette bien ces jetons pour l'application (aucun compte Firebase réel) |
| Les routes métier **fonctionnent** : dotation, idempotence, anti-fraude, isolation, parrainage, `501` | Un parcours **Android → API** de bout en bout (l'app n'appelle pas ce banc) |
| Le Worker **ne sort pas sur le réseau** et lit réellement la base | Les performances, la charge, la concurrence réellement observées en production |

**Le mot « simulation » s'applique au fournisseur d'identité, pas au serveur** : c'est le
vrai code du Worker, la vraie vérification JWT, la vraie base. Ce n'est **pas** un
`PASS_PROD` et ce n'est pas présenté comme tel.

### Reproduit en CI

Un job `auth-local` a été ajouté à `.github/workflows/android-e2e-lab.yml` :
il installe Node 22 et `jose`, puis exécute les 18 contrôles et publie l'artefact
`auth-local`. Dès qu'un push sera possible, le résultat sera vérifiable publiquement.

## 3. Ce qui reste bloqué

| Sujet | Cause | Ce qu'il faudrait |
|---|---|---|
| Jeton **Google réel** accepté par le Worker | pas de projet Firebase à nous | compte Firebase de test (e-mail + mot de passe) → `scripts/security-ci.mjs` couvre alors **tout** |
| Parcours **app → API** | l'APK utilise l'API de production | identifiants Google + appareil |
| 24 tables / 37 index | vérifiés en D42.13 (`backend_invariants.py`, 14 PASS) | conservé, non refait |
