# D42.22 — 01. DÉPLOIEMENT WORKER

## Cible
- `src/index.js` @ main (logique D42.21 `?v=N` 1..20 strict + EN_LIGNE + cache bord).
- Compte Cloudflare : `d7dac13da931423a19812f6d9116bd47` ; D1 `vitrine-video-db` ;
  B2 `vitrine-video-media`.

## Résultat worker-deploy-2 : FAILURE — cause D22-1 (jetons VIDES), PAS le code
- Tag `worker-deploy-2` → run **42455579181** (08/11 06:38:28 → 06:38:59) :
  les secrets `CLOUDFLARE_API_TOKEN` et `CLOUDFLARE_D1_PREVIEW_API_TOKEN`
  sont **VIDES** dans l'env du job (logs l.175-177) → Cloudflare répond
  « Invalid format for Authorization header » (jeton vide).
- Échec précédent worker-deploy-1 (42430521024, 08/11 00:36) : même cause.
- Les déploiements réussis du 01/11 (41312068176 / 41312551179, D40) ont tourné
  sur le dépôt **PRIVÉ** principal, pas dans CE miroir public — les secrets
  y existent (captures fondateur), ils ne sont pas injectés ici.
- Wiring vérifié CORRECT : noms de secrets exacts dans le workflow, aucun
  environnement GitHub requis (API environnements : total_count = 0).
  Ce n'est donc PAS un défaut de raccordement à corriger côté code.

## État de production (conséquence)
- Le Worker en production (dernier déploiement 01/11, pré-D42.21) ne sert pas
  encore `?v=N` : l'app dégrade gracieusement vers le repli titulaire
  (constaté preuve A). La chaîne 20 variations complète s'activera au
  prochain déploiement réussi.

## Déblocage (action fondateur unique — voir checkpoint 08)
1. Ajouter `CLOUDFLARE_API_TOKEN` (jeton « Edit Cloudflare Workers » du compte
   d7dac13d…) dans Settings → Secrets and variables → Actions de
   `mdgejc14-hash/vitrine-video-d42-arena`.
2. Re-tag `worker-deploy-3` sur `453e470ddc60180bfe6783e807990fb8450363ba`.
3. Vérifier : run worker-deploy-3 SUCCESS + validation 30 × {1..20} via
   `audio-audit-1`.

**AUCUN contournement tenté : le jeton ne doit jamais apparaître en clair
dans un commit, un log ou le code (règle D42.17 maintenue).**
