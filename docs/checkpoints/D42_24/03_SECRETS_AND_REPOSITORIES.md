# D42.24 — 03. SECRETS ET DÉPÔTS (confirmé par API le 08/11 ~10:20 UTC)

## Inventaire vérifié (noms uniquement — valeurs jamais lues/affichées)
| Dépôt | Visibilité | Secrets (API 08/11) |
|---|---|---|
| `mdgejc14-hash/vitrine-video` | privé | **16 — confirmés à l'identique de D42.23** |
| `mdgejc14-hash/vitrine-video-d42-arena` (miroir) | public | **0 — confirmé** |
| `mdgejc14-hash/le-labeur` / `LE-LABEURs` | privés | 0 (D42.23, sans changement) |
| `mdgejc14-hash/LE-LABEUR-PRE-ARENA` | public | 0 (D42.23) |

Les 16 du privé : B2_APPLICATION_KEY, B2_BACKUP_BUCKET, B2_KEY_ID,
B2_RETENTION_APPLICATION_KEY, B2_RETENTION_KEY_ID, B2_S3_ENDPOINT,
CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_API_TOKEN,
CLOUDFLARE_D1_PREVIEW_API_TOKEN, FIREBASE_TEST_A_EMAIL,
FIREBASE_TEST_A_PASSWORD, FIREBASE_TEST_B_EMAIL,
FIREBASE_TEST_B_PASSWORD, FIREBASE_WEB_API_KEY, VV_KEYSTORE_B64,
VV_STORE_PASSWORD.

## Ce que chaque workflow consomme (lu dans les fichiers, e5f2f8c)
- **deploy-production** : `CLOUDFLARE_API_TOKEN` +
  `CLOUDFLARE_D1_PREVIEW_API_TOKEN` — l'ID de compte est committé en
  clair NON-secret (`d7dac13d…`).
- **api-security** : FIREBASE_WEB_API_KEY, FIREBASE_TEST_A/B_EMAIL +
  PASSWORD, B2_KEY_ID, B2_APPLICATION_KEY.
- **audio-audit** : les 2 Cloudflare + FIREBASE_WEB_API_KEY,
  FIREBASE_TEST_A_EMAIL/PASSWORD, B2_KEY_ID, B2_APPLICATION_KEY.
- **backup-d1-to-b2** : les 2 Cloudflare + B2_KEY_ID,
  B2_APPLICATION_KEY, B2_S3_ENDPOINT, B2_BACKUP_BUCKET — ⚠ utilise le
  secret CLOUDFLARE_ACCOUNT_ID qui « pointait ailleurs » (diagnostic du
  31/10) → le workflow sera corrigé pour utiliser le littéral committé
  correct (comme deploy-production) avant relance.
- **release-official-build / release-official-e2e** : **aucun secret**.

## Ensemble minimal à ajouter AU MIROIR par le fondateur (UI GitHub)
Settings → Secrets and variables → Actions → New repository secret —
**mêmes noms exacts, mêmes valeurs que le privé** (copier depuis un
gestionnaire sécurisé, jamais dans la conversation) :

**Lot 1 — déploiement Worker (2)** :
1. `CLOUDFLARE_API_TOKEN`
2. `CLOUDFLARE_D1_PREVIEW_API_TOKEN`

**Lot 2 — API Security + audit audio (7)** :
3. `FIREBASE_WEB_API_KEY` *(posé par l'agent via API si le PAT le
   permet — valeur issue du gradle.properties du privé, jamais
   affichée ; le fondateur n'a à l'ajouter manuellement que si l'API
   refuse)*
4. `FIREBASE_TEST_A_EMAIL`
5. `FIREBASE_TEST_A_PASSWORD`
6. `FIREBASE_TEST_B_EMAIL`
7. `FIREBASE_TEST_B_PASSWORD`
8. `B2_KEY_ID`
9. `B2_APPLICATION_KEY`

**Lot 3 — backup D1 (2, optionnel)** :
10. `B2_S3_ENDPOINT`
11. `B2_BACKUP_BUCKET`

**Jamais transférés au miroir** (interdits en public, décisions
D42.17/D42.24) : `VV_KEYSTORE_B64`, `VV_STORE_PASSWORD` (signature
officielle) ; `B2_RETENTION_*` (hors chaîne). `CLOUDFLARE_ACCOUNT_ID`
inutile (littéral committé correct).

## Sécurité du miroir à secrets (revue détaillée au 08)
- Déclencheurs des workflows à secrets : tags + dispatch uniquement →
  réservés aux collaborateurs (création de tag = accès écrit requis) ;
  `pull_request` neutralisé sur le miroir par la garde (les PR n'ont de
  toute façon jamais les secrets).
- Jamais `pull_request_target`.
- `permissions: contents: read` minimal (déjà en place
  deploy/api-security ; à vérifier pour audio-audit/backup).
- Secrets passés exclusivement par `env:`, jamais en argument affiché.
- Actions tierces limitées aux sources officielles (actions/*,
  gradle/actions, reactivecircus/android-emulator-runner,
  cloudflare/wrangler-action).
- La variable `OPS_ENABLED` (repo variable) = interrupteur auditable :
  la supprimer désactive toute la chaîne ops du miroir sans toucher
  aux fichiers.

## PAT fondateur (règles maintenues)
Restitué par le fondateur le 08/11 après perte par le snapshot ;
stocké `/home/user/.d42_secrets/gh_pat_fondateur.txt` chmod 600,
jamais affiché/committé/élargi. Périmètre constaté : contenus dépôts
vitrine + Actions + releases ; billing REFUSÉ (403) — aucun impact sur
la mission. Ne pas supprimer de sa propre initiative (décision
fondateur après livraison vérifiée).
