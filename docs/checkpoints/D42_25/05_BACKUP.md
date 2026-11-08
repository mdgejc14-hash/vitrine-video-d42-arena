# D42.25 — 05. BACKUP D1 → B2 (P1-E) — chaîne prête, bloquée sur la clé d'application

**Chronologie des runs** (workflow `backup-d1-to-b2.yml`, dispatch manuel) :

| Run | Commit | Résultat | Cause |
|---|---|---|---|
| 42494678205 | f7e2560⁻ | FAILURE (30 s) | `B2_S3_ENDPOINT` collé sans schéma `https://` (la console B2 l'affiche ainsi) → rejet par la validation stricte |
| 42494796528 | f7e2560 | FAILURE | Normalisation OK + **export D1 réussi (468 371 octets SQL + sha256)** ; upload mort sur `ConnectionClosedError` SANS réponse HTTP (non-diagnostique) |
| 42495212327 | 531a204 | FAILURE PROPRE au pré-vol | **HeadBucket signé : 403 AccessDenied** — bucket existant/joignable, clé non autorisée |
| 42497033223 | c8899ae | FAILURE PROPRE au pré-vol | Reprise fondateur : fallback clé `B2_KEY_ID` (pas de secrets dédiés posés) → HeadBucket 403 identique |
| 42497382603 | 4cd3e29 | FAILURE à l'upload | **Pré-vol corrigé** (403 HeadBucket non bloquant — une clé writeFiles-only n'a pas listFiles) → **PUT réel : ConnectionClosedError = la clé utilisée n'a PAS writeFiles sur ce bucket** |

## Diagnostic définitif (preuves croisées, 08/11 soir)

1. **Bucket backup : EXISTE, us-east-005, 33 caractères** (HeadBucket 403 et
   non 404 ; joignable).
2. **Secrets vérifiés exhaustivement (noms uniquement)** : miroir 12 secrets,
   privé 16 secrets, aucune variable, aucun environment —
   `B2_BACKUP_KEY_ID`/`B2_BACKUP_APPLICATION_KEY` **absents partout** ;
   la valeur actuelle de `B2_KEY_ID`/`B2_APPLICATION_KEY` **n'a pas
   writeFiles sur le bucket backup** (PUT → connexion fermée, 2 fois).
3. Toute la chaîne amont est PROUVÉE : gate OPS_ENABLED ✓, secrets détectés ✓,
   **export D1 réel de production** (468 371 octets SQL, sha256, contenu
   jamais imprimé) ✓, client S3 ✓, routage endpoint/bucket ✓,
   pré-vol discriminant ✓, PUT tentative réelle ✓.

**Conclusion : il ne manque EXACTEMENT qu'une clé d'application B2 autorisée
en écriture, déclarée dans les secrets du MIROIR.**

## Correctifs apportés au workflow (f7e2560 → 4cd3e29)

1. **Normalisation** de `B2_S3_ENDPOINT` (schéma `https://` optionnel,
   domaine re-validé strictement).
2. **Pré-vol HeadBucket signé** : 404 (bucket inexistant) et connexion
   fermée (région) = bloquants avec message actionnable ; **403 = non
   bloquant** (une clé writeFiles-only répond 403 à HeadBucket qui exige
   listFiles, alors qu'elle peut uploader — défaut de la version initiale
   du pré-vol, corrigé après le run 42497033223).
3. **Fallback de clé** : `B2_BACKUP_KEY_ID`/`B2_BACKUP_APPLICATION_KEY`
   (dédiés, recommandés) sinon `B2_KEY_ID`/`B2_APPLICATION_KEY` — le PUT
   réel tranche dans tous les cas, avec message final actionnable par cas.

## Demande fondateur UNIQUE (~2 min, une des deux voies) — débloque P1-E

Backblaze B2 → App Keys → **Add a New Application Key** :
- Name : `vv-backup-writer` ; Allow access to Bucket(s) : **le bucket de
  backup uniquement** ; Capabilities : **writeFiles** (+ `listFiles`
  optionnel, pour un diagnostic plus verbeux).

Puis, au choix :
- **Voie dédiée (recommandée)** : miroir → Settings → Secrets and variables
  → Actions → poser `B2_BACKUP_KEY_ID` (keyID) et
  `B2_BACKUP_APPLICATION_KEY` (applicationKey) ;
- **Voie remplacement** : mettre à jour les VALEURS de `B2_KEY_ID` et
  `B2_APPLICATION_KEY` du **miroir** avec une clé couvrant média-lecture +
  backup-écriture (moins propre : élargit la clé utilisée par l'audit audio).

⚠️ Les secrets doivent être posés sur le dépôt **MIROIR**
(`mdgejc14-hash/vitrine-video-d42-arena`) — ceux du privé ne sont pas lus
par ses workflows.

Dès réception : re-dispatch « Backup D1 to Backblaze B2 » → pré-vol (PASS ou
ATTENTION 403) → upload `d1/<AAAAMMJJ>/<HHMMSS>/vitrine-video-db.sql` +
`.sha256` → **P1-E PASS** (le cron `0 3 * * *` prendra le relais).

## Statut P1-E : **BLOCKED (1 action fondateur — clé writeFiles backup + secrets miroir)**
