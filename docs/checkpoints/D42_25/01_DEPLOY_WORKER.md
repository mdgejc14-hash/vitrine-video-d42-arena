# D42.25 — 01. DÉPLOIEMENT WORKER (P1-A) — BLOCKED sur périmètre jeton

**Run** : `worker-deploy-4` → Deploy Production **42477858757** (tag poussé sur
`984cda4`, exécuté 08/11 11:55–11:56 UTC). Conclusion : **FAILURE — blocage
externe (action fondateur, ~2 min)**. Aucun demi-déploiement : l'échec a lieu
AVANT tout `wrangler deploy`, la production reste intacte (Worker 0.9.0).

## Ce qui a RÉUSSI dans ce run (preuves réelles)

| Étape | Résultat | Preuve (log du run) |
|---|---|---|
| Gate OPS_ENABLED | PASS | secret OPS_ENABLED=true détecté |
| Pré-vol secrets | PASS | les secrets requis sont présents (valeurs masquées) |
| Diagnostic jeton CF | PASS | `verify: success=True status=active` ; D1 : bases `vitrine-video-db` (0dacf519…) + `vitrine-video-db-preview` (5b9060b1…) visibles |
| Migrations D1 distantes | **PASS — 0001 → 0012 appliquées** | chaque fichier `db/migrations/0001…0012` exécuté ; erreurs « duplicate column name: signup_fingerprint / sector » = re-passages idempotents tolérés (colonnes déjà posées), PAS des échecs |
| Vérification schéma distant | **PASS** | tables `merchant_identity`, `billing_orders`, `audio_catalog`, `bgm_library` présentes en D1 prod |
| Déploiement Worker | **FAIL** | sonde service HTTP 403 `success=False` pour les DEUX jetons → refus propre avant deploy |
| Smoke production | SKIPPED (conséquence) | — |

**Conséquence réelle : la base D1 de production est À JOUR (schéma complet
0001→0012, bibliothèque BGM V2 / 600 pistes en base). Seul le binaire Worker
reste en 0.9.0.**

## Cause racine (précise, vérifiée)

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

## Action fondateur requise (minimale, ~2 minutes)

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

## Enchaînement dépendant (pour mémoire)

- **audio-audit-1 (P1-D) : BLOCKED derrière ce déploiement, par conception.**
  L'audit tape le Worker PROD (`/health`, `/api/v1/audio/library`,
  `/api/v1/audio/track/…` + B2 direct). Lancer l'audit contre le 0.9.0
  auditerait l'ancien binaire : preuve invalide pour D42.25. On attend le
  0.9.1-d42.23 en prod (ordre fondateur : deploy → puis audio-audit).
- **api-security (P1-B) : indépendant du Worker** (D1 local + B2/Firebase
  réels, zéro appel au worker prod) → re-dispatché sur le commit exact du
  tag : run **42478068047** (984cda4) en cours.
