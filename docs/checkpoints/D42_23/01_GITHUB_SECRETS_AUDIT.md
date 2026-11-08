# D42.23 — 01. AUDIT SECRETS GITHUB (Phase A)

## Méthode
PAT fondateur (fine-grained, fourni dans l'ordre de mission, stocké à
permissions minimales hors Git, jamais affiché ni committé). Inventaire
des 5 dépôts visibles, listing des secrets par LEUR NOM UNIQUEMENT (les
valeurs sont masquées par GitHub et ne doivent jamais être lues/affichées
— règle respectée).

## Résultat : le dépôt qui détient les secrets

| Dépôt | Visibilité | Secrets Actions |
|---|---|---|
| `mdgejc14-hash/vitrine-video` | **privé** | **16 — TOUS les secrets** |
| `mdgejc14-hash/vitrine-video-d42-arena` (miroir) | public | 0 |
| `mdgejc14-hash/le-labeur` | privé | 0 |
| `mdgejc14-hash/LE-LABEURs` | privé | 0 |
| `mdgejc14-hash/LE-LABEUR-PRE-ARENA` | public | 0 |

Environnements GitHub : **0** sur les 5 dépôts (pas de problème de
raccordement environnement — les workflows n'exigent aucun environnement).

## Les 16 secrets du privé `vitrine-video` (noms, dates de mise à jour)

**Cloudflare** (utilisés par deploy-production.yml, backup, audits) :
- `CLOUDFLARE_ACCOUNT_ID` (20/10)
- `CLOUDFLARE_API_TOKEN` (31/10)
- `CLOUDFLARE_D1_PREVIEW_API_TOKEN` (23/10)

**Firebase** (utilisés par api-security-tests.yml, audio-audit.yml) :
- `FIREBASE_WEB_API_KEY` (21/10)
- `FIREBASE_TEST_A_EMAIL` / `FIREBASE_TEST_A_PASSWORD` (21/10)
- `FIREBASE_TEST_B_EMAIL` / `FIREBASE_TEST_B_PASSWORD` (21/10)

**Backblaze B2** (backup-d1-to-b2.yml, audio-audit.yml) :
- `B2_KEY_ID` / `B2_APPLICATION_KEY` / `B2_S3_ENDPOINT` /
  `B2_BACKUP_BUCKET` (01/11) ; `B2_RETENTION_KEY_ID` /
  `B2_RETENTION_APPLICATION_KEY` (20/10)

**Signature Android** (builds signés en CI) :
- `VV_KEYSTORE_B64` / `VV_STORE_PASSWORD` (31/10)

→ **Tous les noms de l'ordre D42.23 §Phase A sont présents** dans le dépôt
privé. Le wiring des workflows du privé (noms exacts, injection env) est
vérifié conforme (backup-d1-to-b2.yml et deploy-production.yml relus en
entier ; api-security-tests.yml idem).

## Découverte structurante : deux dépôts, deux rôles
- **Privé `vitrine-video`** : dépôt de production (secrets + workflows
  ops). main = `74edd98` (état D40, celui déployé le 01/11). Dernier
  work : branche `d42.14-critical-paths` (06/11). Les workflows D42.15-22
  (audio-audit, release-official-*, e2e-lab) n'y existent PAS.
- **Miroir public `vitrine-video-d42-arena`** : tout l'historique validé
  D42.15-22 (main = `43de5bc`), workflows complets, CI verte, AUCUN secret.
- Les deux historiques sont **sans ancêtre commun** (miroir créé par
  snapshot) — la synchronisation se fait par poussée d'une branche dédiée
  (`d42.23-production`), jamais en touchant les mains.

## Défaut D23-1 (critique, découverte de l'audit)
Les workflows du dépôt PRIVÉ **ne peuvent plus démarrer** : chaque run
meurt en 3-5 secondes, zéro étape exécutée, aucun runner attribué
(preuves : runs 42360598815, 42268839448, 41813589786 + dispatch de
contrôle 42464996752 du 08/11 08:55 — 4 s, failure, 0 étape). Le miroir
public (gratuit) exécute normalement les mêmes types de jobs.
**Diagnostic : minutes Actions du compte épuisées pour les dépôts privés**
(facturation/limite de dépenses — seule une action fondateur la relève ;
les APIs billing/permissions renvoient 403 au PAT, conformément à son
périmètre). Conséquences actuelles : backup D1 quotidien en échec depuis
le 04/11 (dernier succès 41573746856 du 03/11 03:41), deploy bloqué,
api-security bloqué. Un runner self-hosted serait la voie autonome, mais
l'API runners renvoie 403 au PAT (permission Administration absente) —
non contournable sans élargir le jeton (interdit sans autorisation).
