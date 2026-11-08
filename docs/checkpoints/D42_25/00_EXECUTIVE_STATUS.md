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
| E2E équivalent release | **PASS COMPLET** (run 42482295447 attempt 2) : porte artefact réparée, P0 base 22/0 + font130 23/0, **P1 officiel 37/0/0** (MP4 réel 9,16 Mo, crédits CONFIRMED/2, zéro crash) | défauts accessibilité rot90/petit écran → backlog produit | détail 03_E2E_EQUIV_RESULTATS.md |
| Miroir CI (android-ci) | **PASS ×4 consécutifs** (984cda4, 5fcc600, ac2b7dc/f3fa0bd, 0a5d2bb) | rien à refaire | runs cités |
| Miroir e2e-lab | PASS (f1ddd5b 42472291434) | rien à refaire | run cité |
| API Security (P1-B) | **PASS** | re-dispatch demandé sur le commit exact du tag → run **42478068047** en cours (984cda4) | **42477195502 SUCCESS** (bb4e8b3) : Firebase A/B réel, streaming B2 réel, isolation crédits, BGM 600 |
| Deploy Worker (P1-A) | **BLOCKED (fondateur — périmètre jeton)** | migrations D1 prod **À JOUR 0001→0012** ✓ ; il manque Workers Scripts:Edit au jeton → recréer token (modèle « Edit Cloudflare Workers ») | 42477858757 (worker-deploy-4) : FAIL propre avant deploy, prod intacte 0.9.0 ; détail 01_DEPLOY_WORKER.md |
| Audit audio (P1-D) | BLOCKED (derrière deploy — par conception) | l'audit tape le worker prod ; attendre 0.9.1-d42.23 sinon preuve invalide | — |
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
6. **11:52** `984cda4` : checkpoints 00 + 08 poussés. Runs déclenchés :
   android-ci 42477577218, e2e-lab 42477577217, e2e-équivalent
   42477586620 (en cours au dernier relevé).
7. **11:54** sonde cf-token-probe 42477734593 : jeton principal
   **VALIDE/actif** (D1 ✓ 2 bases) — mais conclusion « Workers OK »
   ERRONÉE (liste scripts vide = pas de scope Workers ; leçon consignée).
   Jeton D1 preview toujours invalide (code 1000) — fallback seul.
8. **11:56** `worker-deploy-4` → **42477858757 FAILURE** à l'étape deploy
   uniquement : sonde service 403 avec les 2 jetons. **Migrations D1 prod
   0001→0012 APPLIQUÉES + schéma vérifié** (bgm_library V2 en base) ;
   aucun demi-déploiement (prod = 0.9.0 intacte). Cause : jeton sans
   périmètre Workers Scripts:Edit → **requête fondateur ci-dessous**.
9. **12:01** API Security CI re-dispatché sur 984cda4 (commit exact du
   tag) : run **42478068047 SUCCESS** (12:07) — preuve verte sur le commit
   du déploiement.
10. **12:08-12:25** android-ci **42477577218 SUCCESS** (984cda4) —
    l'amorçage Gradle a porté ses fruits. e2e-équivalent 42477586620 :
    FAILURE à l'étape « Vérifications de l'artefact » — dex sans AUCUNE
    clé (ni réelle, ni dummy, ni fallback).
11. **12:10-12:30** ENQUÊTE MÉTHODIQUE (checkpoint 02) : secret prouvé bon
    (api-security), mécanisme ORG_GRADLE_PROJECT_ prouvé sous Gradle 9.6
    (test local multi-module, env > gradle.properties), instrumentation du
    workflow (runs 42479256822, 42480435635) : propriété résolue ✓,
    BuildConfig.java avec clé réelle ✓, mapping R8 uploadé.
12. **12:43** PREUVE ABSOLUE : mappings R8 rc11 (asset privé) et miroir
    (artefact run) **octet pour octet identiques** (sha256 8cef1f5a…,
    même pg_map_id) ⇒ dex identiques ⇒ la clé est dans le dex. Coupable :
    le check `strings` (stdout vide sur le runner). Fix f3fa0bd = analyse
    binaire (`key.encode() in data`).
13. **12:51** run 42481593759 : clé réelle présente (binaire) ✓ mais
    faux positif « factice » — b'DUMMY' matche 2 chaînes CEA/media3
    anodines (vérifié sur le dex rc11 sain). Fix 0a5d2bb = dummy EXACTE
    (AIzaSyD42LABDUMMYKEY).
14. **13:03** run **42482295447** : étape « Vérifications de l'artefact »
    **SUCCESS** (première fois) — puis parcours P0 Pixel 5 : échec
    d'infrastructure (DeadSystemException de l'émulateur au keyevent 82,
    AVANT tout lancement d'app). Re-run attempt 2 lancé (13:20).
15. **14:08** attempt 2 : **SUCCESS COMPLET** — P0 pixel5-base 22/0/0,
    font130 23/0/0 (rot90 17/3/3 et petit écran 13/1/4 : défauts
    d'accessibilité consignés) ; **P1 officiel 37 PASS/0 FAIL/0 BLOCKED**
    (3 prises caméra émulée, export-0.mp4 9 158 574 o, notification
    vv_export, export écran éteint, partage, **crédits serveur CONFIRMED
    solde 2**, zéro FATAL EXCEPTION). Checkpoint 03 poussé.
16. **14:20-14:35** clôture du tour : android-ci SUCCESS sur tous les
    commits du tour (×7) ; e2e-lab SUCCESS (4548afd) ; **RAPPORT FINAL
    99_RAPPORT_FINAL.md poussé (a350cce)** — matrice complète, §9 des 15
    items, 2 demandes fondateur (jeton CF Workers, secrets lot 3),
    leçons durables. État final : tout l'automatisable est VERT ; P1-A/D/E
    BLOCKED sur actions fondateur documentées.

## Blocage fondateur unique (requête précise et minimale)
**Recréer le jeton Cloudflare principal avec le périmètre Workers** (~2 min) :
1. Dashboard Cloudflare → My Profile → API Tokens → **Create Token** →
   modèle **« Edit Cloudflare Workers »** (Workers Scripts: Edit + D1: Edit)
   sur le compte `d7dac13da931423a19812f6d9116bd47`.
2. Mettre à jour le secret GitHub `CLOUDFLARE_API_TOKEN` du miroir avec la
   nouvelle valeur (une ligne, sans espace).
Le jeton actuel est valide (D1 ✓, migrations appliquées ✓) mais **sans
périmètre Workers** — preuve : 42477858757, sonde service 403 + liste
scripts vide alors que `vitrine-video-api` existe. Dès la mise à jour :
tag `worker-deploy-5` → smoke → tag `audio-audit-1`.
(`CLOUDFLARE_D1_PREVIEW_API_TOKEN` : fallback seul, non bloquant.)

Blocage secondaire (backup D1→B2, P1-E) : secrets lot 3 absents —
`B2_S3_ENDPOINT` et `B2_BACKUP_BUCKET` (mêmes valeurs que le privé).

## Enseignements consignés (ne pas répéter)
- Snapshot sandbox = bits d'exécution ET `.git/config` retirés →
  toujours `git config core.fileMode false` + vérifier `git status`
  avant tout commit ; recréer remote+identité chaque tour.
- Wrapper Gradle sans retry réseau → amorçage `--version` avec retry
  avant toute commande réelle.
- keytool sort l'empreinte avec deux-points ; IntegrityGuard compare de
  l'hexa continue minuscule → normaliser (`tr -d ':' | tr 'A-F' 'a-f'`).
