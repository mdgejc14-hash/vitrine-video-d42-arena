# D42.32 — Manifeste des runs (preuves)

Tous les runs ci-dessous portent le **commit candidat `a799c50`** (main), sauf mention
contraire. Artefacts accessibles depuis l'interface GitHub Actions (rétention 14-30 j) ;
les preuves essentielles sont copiées dans ce dépôt (captures/, camera-preuves/).

## android-ci — 43582492468 — SUCCESS
Compile + tests unitaires (modules touchés §6/Lot 10 : brief, dashboard, export, designsystem).

## android-e2e-lab — 43582492529 — SUCCESS 15/15

| Job | Résultat notable | Artefact (id) |
|---|---|---|
| android-e2e (pixel5 base/font130/rot90) | 23 PASS / 0 FAIL par profil | e2e-pixel5 14108848569 |
| petit-ecran (small/font130) | 60 PNG valides | e2e-petit-ecran 14109651591 |
| android-e2e-p1 | catalogue→brief→caméra→export ; FLAG_SECURE = PNG vides + dumps | e2e-p1 14109791548 |
| android-e2e-camerap | permission, prises, refaire, avant/arrière | e2e-camerap 14109614889 |
| android-e2e-drafts | brouillons/reprise 36/36 | e2e-drafts 14109252925 |
| android-e2e-auth | auth 11/11 | e2e-auth 14108992908 |
| auth-local | **22/22 PASS** (dont 403 empreinte D41 restaurée, course 8×1 débit) | auth-local 14109200899 |
| backend-http | contrat H1-H10 + **quota_unit.mjs 21/21** (quota_run.txt) | backend-http 14109131468 |
| android-e2e-langues (en) | parcours EN | e2e-langue-en 14108124285 |
| android-e2e-offline | hors réseau + retour | e2e-offline 14109346481 |
| android-e2e-offline-export | export offline 41 PASS + **export.mp4 + vitrine-local.db** | e2e-offline-export 14109673377 |
| camera-diagnostic (v4) | **PASS** : 2 rapports 4 sources, emulateur=true, 10 PNG, **2 MP4 réels** (443/430 Ko) | camera-diagnostic 14108693562 |
| security-local / gabarits-audit / harness-selftest | PASS | 14108789229 / 14108243660 / — |

## visual-gallery-d42 — 43582523983 — SUCCESS 3/3

| Job | Captures | Artefact (id) |
|---|---|---|
| gallery-d32-fr (base) | 31 (onboarding→brief 8 étapes→dashboard/parrainage/réglages/paywall) | gallery-d32-fr 14110100262 |
| gallery-d32-suite | 26 + screenrecord + **export.mp4 (MP4 tiré)** | gallery-d32-suite 14109886328 |
| gallery-d32-en (base) | 50, parcours complet EN (0 gap de navigation) | gallery-d32-en 14110216058 |

## Historique des runs caméra (RCA complète)

| Run | Commit | Verdict | Cause |
|---|---|---|---|
| 43520993407 | 2a19d49 | artefact 300 o | adb pull refusé (scoped storage API 30) |
| 43575685106 | 33abc37 | instrumentation crashée | adb root PENDANT la session caméra |
| 43578603832 | 2a9ad15 | 14/15 — récupération OK (12 fichiers, artefact 14106994681), contrôle en échec | heredoc exécuté ligne à ligne par sh -c |
| **43582492529** | **a799c50** | **PASS — preuves complètes** | v4 : vérificateur en fichier + MP4 copiés |

## Preuves quota §4

- `tools/e2e/quota_unit.mjs` : 21/21 (CI backend-http, quota_run.txt).
- SQLite réel : 90e export changes=1, 91e changes=0, rejeu dup, cloud séparé (journal de session).
- App : `captures/05_credits/preuve_room_export_journal.db` — export_journal CONFIRMED, balanceAfter=2.
- Worker : attribution serveur decideQuota, INSERT conditionnel atomique, eventId PK idempotent,
  403 empreinte non liée (auth-local 22/22).
