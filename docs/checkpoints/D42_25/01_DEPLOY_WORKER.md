# D42.25 — 01. DÉPLOIEMENT WORKER (P1-A) — **PASS** (worker-deploy-5)

## DÉNOUEMENT (08/11 14:48-14:55 UTC)

Le fondateur a recollé les jetons CF à **14:48:27** (principal AVEC le
périmètre Workers ; preview également recollé et valide). Séquence
automatique exécutée sans interruption :

| Étape | Preuve |
|---|---|
| Sonde durcie cf-token-probe | **42491960095 SUCCESS** : `service vitrine-video-api → HTTP 200 success=True` + « PASS: périmètre Workers CONFIRMÉ — déployable » ; fallback preview verify=True |
| Tag `worker-deploy-5` (2632f4c) | Deploy Production **42492066614 SUCCESS** — TOUTES les étapes vertes |
| Migrations D1 distantes | 0001→0012 (idempotes), schéma vérifié |
| **Déploiement du Worker** | **SUCCESS — première réussite depuis D40 (01/11)** |
| **Smoke production** | `/health` → `{"status":"ok","database":"connected","schema":"ready","applicationTables":8,"version":"0.9.1-d42.23"}` ; routes auth `catalog=401 library=401 welcome-grant=401` (aligné Phase B/C) ; `billing/return=200` (route SKYPAY D42.23) |

**Production réelle : Worker `vitrine-video-api` = 0.9.1-d42.23, D1
`vitrine-video-db` = schéma complet 0001→0012 (600 pistes BGM V2).**

Suite immédiate : tag `audio-audit-1` poussé → run **42492361577**
(audit acoustique réel contre le Worker à jour — P1-D).

---

## Historique de l'échec worker-deploy-4 (conservé pour la mémoire)

**Run** : `worker-deploy-4` → Deploy Production **42477858757** (tag sur
`984cda4`, 08/11 11:55–11:56 UTC). Conclusion : FAILURE — blocage
externe (action fondateur, ~2 min). Aucun demi-déploiement : l'échec a eu
lieu AVANT tout `wrangler deploy`, la production est restée intacte
(Worker 0.9.0).

## Ce qui avait RÉUSSI dans worker-deploy-4 (preuves réelles)

| Étape | Résultat | Preuve (log du run) |
|---|---|---|
| Gate OPS_ENABLED | PASS | secret OPS_ENABLED=true détecté |
| Pré-vol secrets | PASS | les secrets requis sont présents (valeurs masquées) |
| Diagnostic jeton CF | PASS | `verify: success=True status=active` ; D1 : bases `vitrine-video-db` (0dacf519…) + `vitrine-video-db-preview` (5b9060b1…) visibles |
| Migrations D1 distantes | **PASS — 0001 → 0012 appliquées** | chaque fichier `db/migrations/0001…0012` exécuté ; erreurs « duplicate column name: signup_fingerprint / sector » = re-passages idempotents tolérés (colonnes déjà posées), PAS des échecs |
| Vérification schéma distant | **PASS** | tables `merchant_identity`, `billing_orders`, `audio_catalog`, `bgm_library` présentes en D1 prod |
| Déploiement Worker | FAIL (à l'époque) | sonde service HTTP 403 → jeton sans périmètre Workers |
| Smoke production | SKIPPED (à l'époque) | — |

## Cause racine de l'échec d'alors (vérifiée, corrigée par le fondateur)

`CLOUDFLARE_API_TOKEN` actuel : **valide, actif, périmètre D1 OK — mais SANS
périmètre Workers Scripts:Edit**.

Deux preuves concordantes dans le run :
1. `GET /accounts/d7dac…/workers/scripts` → `success: True` mais **liste
   vide**, alors que le service `vitrine-video-api` **existe** (0.9.0 déployé
   le 01/11, D40). Un jeton avec le scope verrait le script.
2. `GET /accounts/d7dac…/workers/services/vitrine-video-api` → **HTTP 403
   `success=False`** avec le jeton principal ET le jeton D1 preview.

## Leçon consignée (sonde cf-token-probe)

La sonde 42477734593 avait conclu « Workers API OK » à tort : l'appel LIST
`/workers/scripts` renvoie `success:true` + liste vide **même sans le scope
Workers**. Liste vide ≠ périmètre. Le vrai test est la sonde du **service
nommé** (celle du workflow de déploiement). Ne pas re-sonder inutilement.

## Action fondateur requise à l'époque (~2 minutes) — **✔ ACCOMPLIE 14:48:27Z**

1. Dashboard Cloudflare → **My Profile → API Tokens → Create Token**.
2. Choisir le modèle **« Edit Cloudflare Workers »** (Workers Scripts: Edit
   + D1: Edit), périmètre : compte `d7dac13da931423a19812f6d9116bd47`.
3. Copier la valeur (une seule ligne, sans espace).
4. Mettre à jour le secret GitHub du miroir **`CLOUDFLARE_API_TOKEN`**
   (Settings → Secrets and variables → Actions).
   — `CLOUDFLARE_D1_PREVIEW_API_TOKEN` peut rester tel quel (fallback seul).
5. Prévenir l'agent : suite automatique = tag `worker-deploy-5` → smoke
   (billing/return 200, version 0.9.1-d42.23, routes auth 401) → tag
   `audio-audit-1`.
   → **Exécutée intégralement par le fondateur le 08/11 à 14:48:27Z
   (jeton principal ET preview recollés) ; séquence automatique déroulée
   ci-dessus avec succès.**

## Enchaînement dépendant (pour mémoire)

- **audio-audit-1 (P1-D) : BLOCKED derrière ce déploiement, par conception.**
  L'audit tape le Worker PROD (`/health`, `/api/v1/audio/library`,
  `/api/v1/audio/track/…` + B2 direct). Lancer l'audit contre le 0.9.0
  auditerait l'ancien binaire : preuve invalide pour D42.25. On attend le
  0.9.1-d42.23 en prod (ordre fondateur : deploy → puis audio-audit).
- **api-security (P1-B) : indépendant du Worker** (D1 local + B2/Firebase
  réels, zéro appel au worker prod) → re-dispatché sur le commit exact du
  tag : run **42478068047** (984cda4) en cours.
