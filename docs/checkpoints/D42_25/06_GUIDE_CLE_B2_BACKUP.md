# D42.25 — 06. GUIDE EXACT : clé B2 dédiée à la sauvegarde (P1-E)

Objectif : permettre au workflow `backup-d1-to-b2.yml` du **miroir** d'écrire
l'export D1 dans le bucket de backup. Tout le reste de la chaîne est déjà
prouvé (export D1 réel, routage, pré-vol). Durée totale : ~2 minutes.

## Étape 1 — Créer la clé d'application dans Backblaze (~1 min)

1. Se connecter à **backblaze.com** → menu **B2 Cloud Storage** →
   **App Keys** (ou Account → App Keys).
2. Cliquer **« Add a New Application Key »** (NE PAS utiliser la
   « Master Application Key » existante — trop large).
3. Renseigner EXACTEMENT :
   - **Name** : `vv-backup-writer`
   - **Allow access to Bucket(s)** : sélectionner **uniquement le bucket de
     sauvegarde** (celui dont le nom est dans le secret `B2_BACKUP_BUCKET`
     du miroir — c'est celui qui a déjà été utilisé par le privé ; son nom
     fait 33 caractères). **Ne pas choisir « All buckets »**.
   - **Capabilities** : cocher **`writeFiles`** (obligatoire — c'est le
     droit PutObject utilisé par l'upload) ; cocher aussi `listFiles`
     (facultatif mais recommandé : permet au pré-vol HeadBucket d'afficher
     un PASS franc au lieu d'un avertissement 403).
     Ne cocher ni `deleteFiles`, ni `readFiles` si inutiles.
   - **Duration (validité)** : laisser vide = illimitée (ou votre politique
     interne).
4. Cliquer **« Create New Key »**. Backblaze affiche alors **une seule
   fois** :
   - `keyID` (commence typiquement par des chiffres/lettres, ~25 caractères)
   - `applicationKey` (longue chaîne affichée une unique fois)
   → **Copier les deux immédiatement** (l'applicationKey ne peut plus être
   relue ensuite ; si elle est perdue, il faudra recréer une clé).

## Étape 2 — Poser les 2 secrets sur le DÉPÔT MIROIR (~1 min)

⚠️ Les workflows du miroir ne lisent QUE les secrets du miroir. Poser ces
secrets sur le dépôt privé (`mdgejc14-hash/vitrine-video`) n'aurait AUCUN
effet pour ce workflow.

1. Ouvrir **https://github.com/mdgejc14-hash/vitrine-video-d42-arena**
   → **Settings** → **Secrets and variables** → **Actions** → onglet
   **Secrets**.
2. Cliquer **« New repository secret »** et créer :
   - Name : `B2_BACKUP_KEY_ID` — Secret : le `keyID` de l'étape 1 ;
   - Name : `B2_BACKUP_APPLICATION_KEY` — Secret : l'`applicationKey`
     de l'étape 1.
3. Vérifier que les 2 noms sont EXACTS (majuscules, underscores) — le
   workflow les référence par ces identifiants précis.

## Étape 3 — Signaler, puis test final automatique

Dès que les 2 secrets sont posés, dites-le simplement (ex. « secrets posés »).
Le protocole exécuté ensuite (déjà prêt, rien à installer) :

1. **Dispatch** du workflow « Backup D1 to Backblaze B2 » sur `main` ;
2. **Pré-vol signé** (HeadBucket) : `PASS` (si `listFiles` coché) ou
   `ATTENTION 403` (si writeFiles seul — cas géré, non bloquant) ;
3. **Export D1 réel** de production (~468 Ko SQL + sha256, contenu jamais
   imprimé dans les journaux) ;
4. **Upload** de `d1/<AAAAMMJJ>/<HHMMSS>/vitrine-video-db.sql` et du
   `.sha256` dans le bucket de backup ;
5. **Verdict** : SUCCESS → **P1-E FERMÉ** et inscription au rapport final ;
   le cron `0 3 * * *` (04:00 au Bénin) prendra ensuite le relais
   automatiquement chaque nuit.

En cas d'échec, les messages du workflow sont déjà discriminants :
`PutObject 403` = la clé n'a pas writeFiles sur ce bucket ;
`NoSuchBucket 404` = mauvais nom de bucket ;
connexion fermée = mauvaise région d'endpoint.

## Ce qui N'est PAS nécessaire (déjà en place)

- `B2_S3_ENDPOINT` et `B2_BACKUP_BUCKET` : déjà posés (lot 3) et validés ;
- normalisation du schéma `https://` : gérée par le workflow ;
- OPS_ENABLED : déjà armé ;
- aucune modification des 600 compositions audio : ce flux n'y touche pas.
