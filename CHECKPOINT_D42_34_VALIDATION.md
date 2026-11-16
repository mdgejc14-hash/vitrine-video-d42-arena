# CHECKPOINT D42.34 — VERROUILLAGE CAMÉRA, APK UPDATE, AUDIT KAGGLE

**Branche** : `d42.34-founder-acceptance-fixes` · **Base de reprise** : `0fa09ab` (réconciliation documentaire, CI run 288 SUCCESS)
**Ordre fondateur** : 5 volets A (caméra) / B (labo Android) / C (APK update signée) / D (audit Kaggle) / E (ce checkpoint).
**Règles** : un commit ciblé par correction · arrêt après le rapport final · aucun push `main`, aucun reset destructif, aucun RC16, aucune publication commerciale · CinetPay reste 501 · 600 compositions audio et 30 gabarits protégés · `gradle.properties` jamais modifié dans le dépôt.

## État des volets

| Volet | État | Commit | Run CI | Notes |
|---|---|---|---|---|
| A. Verrouillage caméra | **TERMINÉ** | 0cd7ac3 | à poller | 6 correctifs + 5 tests verts, module 22/22 |
| B. Labo Android (e2e) | **TERMINÉ (code) — runs EN COURS** | c0e4125 | lab 43762868411 + CI 43762868387 | branche ajoutée + preuves renforcées |
| C. APK update signée | **MIGRÉ VERS KAGGLE** (build local R8 impossible : 2 Go RAM) — keystore préservé, re-signature finale réservée à Arena | 068b884 | kernel Kaggle v3 à lancer | APK PRE-SIGN → re-signature Arena |
| D. Audit Kaggle | **EN EXÉCUTION** | 213b713→8bcfd1e | kaggle-audit run 5 + rapport auto | referral 13 PASS ; notebook tournant |
| E. Checkpoint | ACTIF | — | — | ce fichier |

## A — Verrouillage caméra (TERMINÉ)

Correctifs appliqués dans `feature-camera/src/main/kotlin/video/vitrine/feature/camera/CameraGuideActivity.kt` uniquement :

1. **Validité d'une prise** : fichier existant + fichier RÉGULIER + taille > 0 (`priseValide()`).
2. **Finalize** : prise validée seulement si `hasError() == false` ET fichier non vide ; sinon fichier incomplet SUPPRIMÉ, prise à refaire (`validerPriseFinalisee()`).
3. **« Suivant »** : ne contourne jamais une prise obligatoire sans rush valide — blocage à l'index courant + message `camera_take_required`.
4. **`finishWithPrises()`** : `RESULT_OK` uniquement si TOUS les slots requis par `prises.size` sont valides.
5. **Prise manquante** : retour à SON index + message compréhensible, montage NON lancé (`signalerPriseManquante()`).
6. **`restaurerBrouillon()`** : positions vides conservées, aucun compactage (un chemin disparu/vide devient `""` à son index).

Aucun nombre de prises codé en dur (référence = `prises.size`, matrice 30 gabarits / 81 prises, 2-4 par modèle). JSON des gabarits et moteur de montage NON modifiés.

**Tests** (`D34CameraVerrouillagePriseTest`, Robolectric sdk 34) :
- `matrice_gabarits_30_et_prises_81_de_2_a_4` — matrice lue des JSON canoniques ;
- `toutes_les_prises_requises_presentes_result_ok` — RESULT_OK + ordre des slots ;
- `prise_manquante_bloque_la_progression` — blocage, pas de montage ;
- `fichier_vide_rejete` — Finalize sans erreur mais fichier vide → rejet + suppression ; hasError → idem ;
- `slot_vide_conserve_son_index_apres_restauration` — trou conservé à son index, ordre final prouvé.

**Résultats locaux** : `D34CameraVerrouillagePriseTest` **5/5 VERT** ; module `:feature-camera` complet **22/22 VERT** (aucune régression).

## B — Labo Android (code TERMINÉ, runs lancés par le push)

- `.github/workflows/android-e2e-lab.yml` : `d42.34-founder-acceptance-fixes` ajouté aux branches `push` → chaque push relance le laboratoire complet, dont `android-e2e-p1`, `android-e2e-camerap`, `camera-diagnostic`.
- `tools/e2e/run_p1.sh` — preuves renforcées :
  - **P1_verrouillage_prises** : « Suivant » sans rush valide → guide conservé + message « obligatoire » (D42.34-A.3 prouvé sur émulateur) ;
  - **P1_preview_streaming** : marqueur VV_E2E `PREVIEW STREAMING` exigé ;
  - **P1_countdown_avant_recorder** : décompte 3-2-1 complet AVANT chaque `startRecording` (ordre des marqueurs) ;
  - **P1_finalize_sans_erreur** : `Finalize hasError=false` partout, aucun `hasError=true` ;
  - **P1_rushs_decodables** : chaque rush non vide ET décodable (ffprobe) ;
  - étiquettes « caméra virtuelle (émulateur) » sur les preuves de prise + `summary.txt`.
- `tools/e2e/run_camerap.sh` : mêmes contrôles de marqueurs en fin de phase B (CPB_preview_streaming / CPB_countdown_avant_recorder / CPB_finalize_sans_erreur), étiquettes « caméra virtuelle », commentaire B4 mis en cohérence avec le verrouillage A.3.
- Mention « caméra virtuelle » explicite dans les summaries — les résultats d'émulateur ne sont jamais présentés comme une validation du capteur physique (validation fondateur sur téléphone réel).

## C — APK de mise à jour signée (complément du fondateur : signature officielle D42.17 RÉCUPÉRÉE et VÉRIFIÉE)

**Recherche ordonnée exécutée (complément mission C) :**
1. `~/keystores/vitrine.keystore` : **EXISTE** (environnement de confiance restauré) — PKCS12, alias `vitrine`, PrivateKeyEntry unique, validité → 2056, DN `CN=Vitrine Video, OU=Mobile, O=EPD HOLDING, L=Cotonou, ST=Littoral, C=BJ`. Accompagné de `signing.properties` (4 clés, valeurs jamais affichées), `.store_pw` et `VV_KEYSTORE_B64.txt` (décodage = keystore octet pour octet, SHA-256 `8aef33ca…`).
2. `~/.cache/vv-toolchain/` : absent (non persisté entre sessions).
3. `vv-signing/` des anciens environnements : absent — recréé pour le build local (gitignoré, ligne 172 du .gitignore).
4. Docs D42.17 recoupées : `00_ETAT.md` §1 documente ce keystore et cette empreinte ; `01_OPTIONS_SIGNATURE.md` : option C retenue — **la clé ne quitte JAMAIS la sandbox, seul l'artefact signé est transmis**.
5. Dépôt privé `mdgejc14-hash/vitrine-video` : existe (HTTP 200), **17 secrets dont `VV_KEYSTORE_B64` et `VV_STORE_PASSWORD` TOUJOURS PRÉSENTS** (noms seuls listés, valeurs jamais lisibles ni affichées).

**Contrôles de sécurité (empreinte EXACTE exigée `758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192`) :**
- `keytool` (JDK 11) sur le keystore : certificat SHA-256 = **758077eb…33e192 EXACT** (comparaison canonique).
- `apksigner` (build-tools 37) sur l'APK RC15 livrée (release publique `d42.30-rc15`, 44 470 123 o, SHA-256 APK `fd28ffc7…b78936`) : signataire V3.0 = **même DN, même SHA-256 758077eb…33e192** → le keystore local est EXACTEMENT la clé qui a signé l'APK installée (contrôle triangulaire keytool/apksigner/empreinte documentée).
- Badging RC15 : `video.vitrine.app`, versionCode 2, versionName 0.9.0-rc15, minSdk 24, targetSdk 36 → la mise à jour versionCode 3 (même applicationId, versionName inchangé) est la mise à jour Android exacte.
- Clé Firebase réelle (identifiant public embarqué, unique dans les dex de la RC15, factice absente) : extraite vers `~/keystores/firebase_api_key.local` (chmod 600, **jamais affichée, jamais committée**, injectée au build via `ORG_GRADLE_PROJECT_vvFirebaseApiKey`).

**Production (voie D42.17 conforme, frontière inchangée)** : build LOCAL `:app:assembleRelease` sur checkout exact de `e04756b` (arbre strictement propre vérifié), porte d'intégrité `-PvvApkSha256=758077eb…`, R8 full + shrinkResources, signature par `vv-signing/signing.properties` (keystore copié dans la sandbox de build, **hors git**), `--no-daemon --max-workers=1 -Xmx1024m`, swap 2G. **Aucun secret ajouté au dépôt public** (le workflow `release-update-apk` CI reste inerte sans secrets — conformément au complément, la frontière D42.17 n'est pas modifiée). Statut : **EN COURS** (dépendances + natif vvguard + R8 : durée longue).

## C-historique — constat initial (15/11, avant récupération)

**Détermination (API GitHub, valeurs jamais affichées)** : le dépôt expose 16 secrets ; `FIREBASE_WEB_API_KEY` ✓, `KAGGLE_KEY` ✓, `KAGGLE_USERNAME` ✓, comptes de test Firebase A/B ✓ — mais **`VV_KEYSTORE_B64` et `VV_STORE_PASSWORD` sont ABSENTS**.

Conformément à l'ordre : **statut BLOQUÉ**, aucune APK produite, aucune clé de substitution (une APK signée différemment ne mettrait PAS à jour l'installation précédente et ne sera jamais présentée comme telle).

**Livré pour débloquer immédiatement quand le fondateur ajoute les secrets** :
- `.github/workflows/release-update-apk.yml` (workflow_dispatch) : pré-vol des 3 secrets (arrêt BLOQUÉ explicite si absents) → décodage base64 du keystore + `signing.properties` dans `vv-signing/` (gitignoré) → `:app:assembleRelease` avec porte d'intégrité `-PvvApkSha256=758077eb…` → vérifications **SHA-256 APK, package `video.vitrine.app`, versionCode 3, empreinte certificat exacte `758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192`** (rejet sinon) → contrôle dex (clé Firebase réelle, factice absente) → **artefact Actions 30 jours uniquement** (aucun tag, aucune Release, aucun store).
- `build-logic/.../vitrine.android-app.gradle.kts` : `versionCode = 3` (supérieur au 2 installé), package et versionName inchangés (RC15 — aucun RC16).
- Alias de clé : découvert par `keytool` dans le keystore (ou secret optionnel `VV_KEY_ALIAS`) ; mot de passe de clé : `VV_STORE_PASSWORD` par défaut (ou secret optionnel `VV_KEY_PASSWORD`).

**Déblocage** : ajouter `VV_KEYSTORE_B64` (keystore du 8 novembre en base64) et `VV_STORE_PASSWORD` dans Settings → Secrets and variables → Actions, puis relancer `release-update-apk` (workflow_dispatch).

## D — Audit Kaggle (code TERMINÉ, exécution via workflow_dispatch)

- `tools/kaggle/vitrine_video_d42_34_validation.py` : notebook/script poussé sur Kaggle comme `KAGGLE_USERNAME/vitrine-video-d42-34-validation` (privé, Internet activé). Pré-vol : Internet, clone du miroir public `mdgejc14-hash/vitrine-video-d42-arena` au SHA EXACT (vérifié après clonage), JDK 17 Temurin, Android SDK (platforms;android-37.0, build-tools;37.0.0, ndk;28.2.13676358).
- Exécute dans le notebook : tests JVM/Robolectric (compte exact consigné), `ktlintCheck`, `detekt`, `checkModuleGraph`.
- Valide/audite : matrice 30 gabarits / 81 prises (2-4 par modèle, lecture des JSON) ; les DEUX manifests audio `scripts/audio/bgm_lib_manifest_v2.json` et `bgm_r2_manifest.json` (600 compositions déclarées chacun, identifiants uniques) ; ressources R.string (android.R exclu) ; boutons findViewById↔layouts ; routes Activities ::class ↔ manifests (noms relatifs et qualifiés) ; références gabarits ↔ assets JSON ; crédits/quotas application (StorageGate, + tests exécutés) et Worker (`src/index.js`, decideQuota/credits) ; parrainage sans code (tests onboarding exécutés) et avec code (RefCodeParserTest exécuté).
- **Verdicts exclusifs** : COMPLET / CASSÉ / NON JUGEABLE PAR LECTURE SEULE, avec citations fichiers et lignes. Aucun contrôle statique n'est présenté comme preuve d'exécution.
- **Parrainage sur comptes de test dédiés** : NON exécuté dans le notebook (l'ordre n'autorise que KAGGLE_USERNAME/KAGGLE_KEY — aucun autre secret transmis à Kaggle) ; la qualification est exécutée côté GitHub par le workflow existant `referral-qualification` (comptes A/B), déclenché séparément.
- `.github/workflows/kaggle-audit.yml` (workflow_dispatch) : pré-vol secrets (valeurs jamais affichées) → push notebook → attente (≤ ~8 h) → sorties récupérées → **artefact 30 jours** → commit de `REPORT_D42_34.md` + mise à jour de ce checkpoint (bloc ci-dessous), branche uniquement.

<!--D:AUDIT-->
Dernier audit Kaggle : workflow `kaggle-audit` run 5 (commit 8bcfd1e, 15/11) — notebook
`vitrine-video-d42-34-validation` poussé (auth par token, CLI 2.2.5) et EN EXÉCUTION sur
Kaggle ; à la fin, `REPORT_KAGGLE_D42_34.md` + checkpoint commités automatiquement sur la
branche, sorties en artefact 30 jours. Qualification parrainage comptes A/B : run 4 du
15/11, 13 PASS / 0 FAIL (détail dans REPORT_D42_34.md §D.1).
<!--/D:AUDIT-->

## E — Rapport final (RÉDIGÉ, poussé)

`REPORT_D42_34.md` à la racine : statuts A/B/C/D/E, distinction logique vérifiée par
code vs à confirmer sur téléphone réel, 6 NON PROUVÉ exacts (VR-001, 009, 037, 048, 053,
065), VR-056 NON APPLICABLE, restrictions respectées, arrêt en attente d'acceptation.

## Prochaine action exacte

(1) Attendre la fin du build local APK (processus « Build APK mise à jour ») → vérifications finales : `apksigner verify --print-certs` (empreinte EXACTE attendue), `aapt dump badging` (video.vitrine.app / versionCode 3 / 0.9.0-rc15), contrôle dex (clé réelle présente, factice absente), SHA-256 APK consigné → livraison de l'APK signée dans `~/apk_update/` (jamais le keystore). (2) Attendre le run kaggle-audit 5 (auto-commit de `REPORT_KAGGLE_D42_34.md`) et le dernier run lab. Arrêt après mise à jour du rapport en attendant le fondateur.

## MIGRATION KAGGLE (ordre fondateur du 16/11, 2026-11-16 07:45 UTC)

**A. Build local ARRÊTÉ (échec définitif, journal préservé)** :
- Tentative 2 : daemon Gradle **disparu pendant `:app:minifyReleaseWithR8`** (« daemon disappeared unexpectedly » — OOM noyau, 1 982 Mo RAM + swap 2G insuffisants pour R8 full multi-modules). Aucune APK produite. Journal complet : `~/apk_update/build_log.txt` (799 lignes ; dernière tâche : `:app:minifyReleaseWithR8`). Tentative 1 : OOM Metaspace à `:data:kspReleaseKotlin` (corrigée 512m→900m puis re-tentative 2).
- Verdict : la compilation R8 locale est INFaisable dans la sandbox Arena (2 vCPU/2 Go) — conforme à l'option B D42.17 « écartée pour OOM ». Migration des calculs lourds vers Kaggle (CPU, ~30 Go) décidée par le fondateur.
- **Keystore PRÉSERVÉ** : `~/keystores/vitrine.keystore` intact, empreinte SHA-256 **EXACTE** `758077eb…33e192` (keytool JDK 11), alias `vitrex→vitrine`, + `signing.properties`, `.store_pw`, `VV_KEYSTORE_B64.txt`, `firebase_api_key.local` (chmod 600, valeurs jamais affichées). `~/lab23/vv-signing/` en place (gitignoré). **Jamais dans le dépôt, jamais vers Kaggle.**
- Frontière D42.17 inchangée : Kaggle produit une APK **PRE-SIGN** (clé debug de recette, clairement étiquetée, jamais présentée installable) ; **Arena seul** réalise la re-signature officielle finale avec le keystore historique.

**B. Traitements distants en cours (intouchés)** : kaggle-audit run 6 (id 43819575333, in_progress — reprise d'attente du kernel v2 du SHA 8bcfd1e, sans re-push) ; android-e2e-lab run 265 (id 43819575327, in_progress sur 068b884) ; CI 298/299 SUCCESS. Répartition : Arena = architecte/superviseur ; GitHub = source de vérité + orchestration ; Kaggle = exécution lourde ; téléphone fondateur = validation physique.

**C. Worker Kaggle v3 (à pousser)** : notebook `KAGGLE_USERNAME/vitrine-video-d42-34-validation` — clone public au SHA exact vérifié, JDK 17 + SDK (platforms;android-37.0, build-tools;37.0.0, NDK 28.2.13676358), mémoire Gradle `-Xmx6g` via ligne de commande (gradle.properties du dépôt INTACT), ordre : SHA → testDebugUnitTest (compte réel) → ktlintCheck → detekt → checkModuleGraph → 30 gabarits/81 prises → 2 manifests audio 600 → ressources/boutons/routes/références → quotas/crédits → `:app:assembleRelease` versionCode 3 + porte d'intégrité `-PvvApkSha256=758077eb…` → APK **PRE-SIGN** + SHA-256 + mapping + logs. Clé Firebase : extraite à l'exécution de la RC15 PUBLIQUE (release d42.30-rc15), jamais affichée, jamais une fausse clé — si indisponible : partie build BLOQUÉE consignée.

**MIGRATION PRÊTE (2026-11-16 07:54 UTC, commit 6f280d4)** : notebook v3 (audit complet + assembleRelease PRE-SIGN versionCode 3, porte d'intégrité, mémoire -Xmx6g/8g, clé Firebase extraite de la RC15 publique) + `tools/kaggle/pilotage.sh` (envoi unique, reprise SANS re-push, vérification RÉELLE post-push, erreur exacte si échec, fichiers attendus avant succès, re-push unique si version ancienne terminée) + `preparer_metadata.py` (title OBLIGATOIRE préservé — « New kernels must have a title specified » définitivement corrigé) + `commit_rapport.py` (checkpoint D:AUDIT avec état/SHA/run/heure). Workflow : jobs `pilot` + `resume` (suivi ~9 h), artefacts 30 j (APK PRE-SIGN, SHA-256, logs Gradle, résultats tests, rapports).

**Chaîne de re-signature Arena PRÊTE** : `~/apk_update/fetch_presign.sh <run_id>` (télécharge l'artefact) → `~/apk_update/resign_finale.sh <apk PRE-SIGN>` (zipalign → apksigner sign keystore officiel via env — mots de passe jamais en clair ni affichés → verify --print-certs empreinte EXACTE 758077eb…33e192 → portes package video.vitrine.app / versionCode 3 / versionName 0.9.0-rc15 → contrôle dex clé réelle/factice → `vitrine-video-d42-34-update-SIGNED.apk` + `verification_finale.txt`). build-tools 37 réinstallé, apksigner OK sur JDK 11.

**BANCS CAMÉRA VIRTUELLE — lab run 268 (SHA 358a3a1, id 43827120638) : 15 jobs SUCCESS au niveau JOB, MAIS lecture des résultats internes (2026-11-16 09:58 UTC) : P1 = PASS 16 / FAIL 12 / BLOCKED 8 ; camerap = CPA_catalogue + CPB_catalogue FAIL (cascade BLOCKED). CAUSE : l'écran de bienvenue D42.33 §9.4 « Compte créé / Félicitations » (solde 3 exports, CTA « Créer ma première vidéo ») s'intercale entre le parrainage et le catalogue — l'APPLICATION est correcte (P0 S16 le franchit, run 254 bb759f8 = 35/35 AVANT l'ajout de l'écran), ce sont les HARNAIS P1/camerap qui ne savaient pas le franchir. Deux défauts de harnais corrigés (commit cf. git log) : (1) franchise du CTA §9.4 (motif éprouvé run_p0.sh S16) ; (2) honnêteté du statut — exit 0 inconditionnel + `true` final masquaient les FAIL (job vert avec 12 FAIL) → désormais exit 1 si FAIL, exit 2 si BLOCKED, et ligne awk autonome dans le workflow qui dérive le statut du job depuis results.tsv. Vérités POSITIVES du 268 : P0 Pixel 5 = 3 variantes 23 PASS/0 FAIL chacune (S16 franchit l'écran §9.4) ; l'échec du run 263 était un flake de boot émulateur (confirmé environnemental) ; camera-diagnostic + auth/offline/drafts/deeplink/langues/security/backend/gabarits/harness verts. Re-validation attendue sur le prochain lab (run ≥ 270).

**Runs Kaggle** : run 6 (ancien workflow, attente du kernel v2 du SHA 8bcfd1e — silencieux depuis 06:50, délai 4h45 vers ~11:38) ; run 7 (id 43826749515, SHA 6f280d4, NOUVEAU pilotage) EN FILE — à son démarrage : sonde kernel → si terminé sans APK PRE-SIGN → re-push v3 (build) → suivi. Workspace nettoyé (caches/rc15.apk supprimés ; keystore et fichiers de signature intacts, jamais dans le dépôt).

**Prochaine action exacte** : attendre la fin du run 6 (récup v2 ou EN_COURS) → le run 7 démarre : sonde kernel → si v2 terminée sans APK PRE-SIGN → re-push v3 (build) → suivi jusqu'à APK PRE-SIGN → `fetch_presign.sh` → `resign_finale.sh` → rapports finaux (REPORT_D42_34.md + REPORT_KAGGLE_D42_34.md) → arrêt en attente du fondateur.

