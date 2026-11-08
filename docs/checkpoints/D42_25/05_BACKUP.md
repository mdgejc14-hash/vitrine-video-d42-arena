# D42.25 — 05. BACKUP D1 → B2 (P1-E) — débloqué par lot 3, bloqué sur la clé d'application

**Chronologie des runs** (workflow `backup-d1-to-b2.yml`, dispatch manuel) :

| Run | Commit | Résultat | Cause |
|---|---|---|---|
| 42494678205 | f7e2560⁻ | FAILURE (30 s) | `B2_S3_ENDPOINT` collé sans schéma `https://` (la console B2 l'affiche ainsi) → rejet par la validation stricte |
| 42494796528 | f7e2560 | FAILURE | Normalisation OK + **export D1 réussi (468 371 octets SQL + sha256)** ; upload mort sur `ConnectionClosedError` SANS réponse HTTP (non-diagnostique) |
| 42495212327 | 531a204 | FAILURE **PROPRE au pré-vol** | **Pré-vol HeadBucket SIGNÉ : 403 AccessDenied** — diagnostic définitif (ci-dessous) |

## Diagnostic définitif (preuves, run 42495212327)

Le pré-vol signé a établi :
- **B2_S3_ENDPOINT = us-east-005** (région du bucket média — cohérente) ;
- **B2_BACKUP_BUCKET : 33 caractères, bucket EXISTANT et JOIGNABLE**
  (un HeadBucket sur un bucket inexistant aurait répondu 404 NoSuchBucket ;
  403 = présent mais interdit à cette clé) ;
- **la clé d'application B2_KEY_ID/B2_APPLICATION_KEY du miroir n'a PAS les
  droits sur le bucket de backup** : elle est restreinte au bucket média
  `vitrine-video-media` (lecture — c'est la clé de l'audit audio, et cette
  restriction est une BONNE chose).

Le `ConnectionClosedError` du run 42494796528 était une autre manifestation
du même refus (B2 ferme la connexion sur un PUT signé hors périmètre de la
clé) ; le HeadBucket donne, lui, un 403 propre et interprétable.

## Correctifs apportés au workflow (commits f7e2560, 531a204, 6c64ba9)

1. **Normalisation** de `B2_S3_ENDPOINT` : accepter `s3.<région>.backblazeb2.com`
   sans schéma (format affiché par la console B2), préfixage `https://`,
   re-validation stricte du domaine (rejet explicite de l'API native
   `apiNNN…` avec message format attendu).
2. **Pré-vol HeadBucket signé** avant l'upload : discrimine 404 (bucket
   inexistant) / 403 (clé non autorisée) / connexion fermée (région
   incorrecte) — messages actionnables par cas, échec propre sans effet
   de bord.
3. **Secrets dédiés au backup** : `B2_BACKUP_KEY_ID` +
   `B2_BACKUP_APPLICATION_KEY` (moindre privilège — on n'ÉLARGIT PAS la clé
   média qui sert l'audit audio). La validation liste ces noms et échoue
   clairement s'ils sont absents.

## Ce qui est DÉJÀ PROUVÉ

- La chaîne backup fonctionne jusqu'à l'écriture B2 : gate OPS_ENABLED ✓,
  secrets détectés ✓, **export D1 réel de production réussi**
  (`wrangler d1 export --remote` : 468 371 octets SQL, sha256 généré,
  contenu jamais imprimé dans les logs) ✓, client S3 installé ✓,
  routage endpoint/bucket validé par HeadBucket ✓.
- Il ne manque QUE la clé d'application autorisée en écriture.

## Demande fondateur (précise, ~2 min) — débloque P1-E

1. Backblaze B2 → **App Keys** → **Add a New Application Key** :
   - Name : `vv-backup-writer` (par exemple) ;
   - Allow access to Bucket(s) : **le bucket de backup uniquement** ;
   - Capabilities : **writeFiles** (suffit pour l'upload SQL + sha256) ;
   - Duration : illimitée (ou renouvelable).
2. GitHub (miroir) → Settings → Secrets and variables → Actions →
   **New repository secret** ×2 :
   - `B2_BACKUP_KEY_ID` = keyID de la nouvelle clé ;
   - `B2_BACKUP_APPLICATION_KEY` = applicationKey (affichée une seule fois).

Dès réception : re-dispatch « Backup D1 to Backblaze B2 » → le pré-vol
doit afficher `PASS : HeadBucket 200`, l'upload écrit
`d1/<AAAAMMJJ>/<HHMMSS>/vitrine-video-db.sql` + `.sha256`, statut final
SUCCESS → **P1-E PASS** (le cron quotidien `0 3 * * *` prendra le relais).

## Statut P1-E : **BLOCKED (1 action fondateur — clé writeFiles backup)**
