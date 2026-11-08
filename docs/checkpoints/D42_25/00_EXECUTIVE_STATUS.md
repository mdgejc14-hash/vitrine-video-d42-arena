# D42.25 — 00. STATUT EXÉCUTIF (reprise totale)

**Mandat** : reprise depuis l'état réel GitHub ; 9 secrets fondateur posés
sur le miroir (11:14-11:32 UTC) ; autonomie complète sauf opérations
destructives/dépense/exposition ; budget 0 FCFA ; P0 sécurité AVANT
usage des secrets ; livraison qualifiée PASS/FAIL/BLOCKED/NOT RUN/
CONDITIONAL.

## Matrice de suivi (mise à jour au fil des exécutions)

| Domaine | État | Action | Preuve |
|---|---|---|---|
| P0 Sécurité workflows | **PASS** | audit complet + OPS_ENABLED fermé par défaut | 08 + commit `df15b6f`/`bb4e8b3` |
| Miroir CI (android-ci) | flaky réseau → relance durcie | amorçage retry ajouté | runs 42477195501 (timeout Gradle) → 53b573f |
| Miroir e2e-lab | PASS (f1ddd5b 42472291434) | rien à refaire | run cité |
| API Security (P1-B) | **PASS** | — | **42477195502 SUCCESS** (bb4e8b3) : Firebase A/B réel, streaming B2 réel, isolation crédits, BGM 600 |
| Deploy Worker (P1-A) | **BLOCKED (fondateur)** | jetons CF malformés à recoller | 42476870643 : code 6111 CF « Invalid format for Authorization header » |
| Audit audio (P1-D) | BLOCKED (même cause CF) | après recollage : tag `audio-audit-1` | — |
| Backup D1→B2 (P1-E) | BLOCKED (2 secrets lot 3 absents) | noms exacts communiqués au fondateur | — |
| E2E équivalent release | en cours (2e fix + durci) | run sur 53b573f | 42472303159 (fix empreinte appliqué), 42477208491 (timeout Gradle), relance |
| APK rc11 (P2) | CONDITIONAL | qualification par équivalence + e2e officiel privé au reset minutes | release privée 438156110 |
| SKYPAY | 501 volontaire | maintenir | — |

## Chronologie du tour (08/11, UTC)
1. **11:40** `df15b6f` : P0 sécurité (gate OPS_ENABLED fermé par défaut
   sur deploy/audio-audit/backup — variable OU secret, aucun = refus ;
   api-security exempté car tests locaux sans écriture) + fix empreinte
   e2e-équivalent (deux-points → hexa continue, conforme
   IntegrityGuard.apkCertSha256). ⚠ ce commit a aussi perdu les bits
   d'exécution de 7 fichiers (cause : snapshot sandbox retire les bits x
   + `git add -A`) — détecté et corrigé au commit suivant ;
   `core.fileMode=false` posé sur les clones locaux pour immuniser.
2. **11:41** runs `df15b6f` : Deploy **échec** (jetons CF malformés,
   code 6111), api-security **échec à 1 seul contrôle** (BGM 600 :
   migration 0012 absente du setup local — tous les autres PASS dont
   Firebase A/B réel et streaming B2 réel), android-ci + e2e-équivalent
   **échec** (`gradlew: Permission denied` — les bits x).
3. **11:45** `bb4e8b3` : modes restaurés (755), 0012 ajoutée au setup
   local api-security, workflow `cf-token-probe` créé (prévol lecture
   seule ~30 s pour vérifier les jetons CF sans déployer). Secret
   `OPS_ENABLED=true` posé sur le miroir via API (PUT 201) — la chaîne
   est armée, fermée par défaut sinon.
4. **11:46-11:48** runs `bb4e8b3` : **API Security CI 42477195502
   SUCCESS** (première suite complète verte du miroir). android-ci +
   e2e-équivalent : **timeout transitoire** du téléchargement Gradle
   (services.gradle.org lent, wrapper sans retry — runs 42477195501 /
   42477208491).
5. **11:50** `53b573f` : amorçage distribution Gradle avec retry dans
   android-ci + e2e-équivalent. e2e-équivalent re-dispatché sur ce
   commit (conclusions au prochain point).

## Blocage fondateur unique (requête précise et minimale)
**Recoller les 2 secrets Cloudflare sur le MIROIR** (Settings → Secrets
and variables → Actions) : `CLOUDFLARE_API_TOKEN` et
`CLOUDFLARE_D1_PREVIEW_API_TOKEN` — valeurs actuelles MALFORMÉES
(en-tête Authorization refusé par l'API Cloudflare, code 6111 ; les
valeurs du privé fonctionnaient : comparer/coller depuis la même
source, une seule ligne, sans espace ni retour). Vérification en 30 s
par le workflow `cf-token-probe` (dispatch), puis déploiement réel.
Optionnel (backup D1) : `B2_S3_ENDPOINT` et `B2_BACKUP_BUCKET`
(mêmes valeurs que le privé).

## Enseignements consignés (ne pas répéter)
- Snapshot sandbox = bits d'exécution ET `.git/config` retirés →
  toujours `git config core.fileMode false` + vérifier `git status`
  avant tout commit ; recréer remote+identité chaque tour.
- Wrapper Gradle sans retry réseau → amorçage `--version` avec retry
  avant toute commande réelle.
- keytool sort l'empreinte avec deux-points ; IntegrityGuard compare de
  l'hexa continue minuscule → normaliser (`tr -d ':' | tr 'A-F' 'a-f'`).
