# CHECKPOINT D42.34 — VERROUILLAGE CAMÉRA, APK UPDATE, AUDIT KAGGLE

**Branche** : `d42.34-founder-acceptance-fixes` · **Base de reprise** : `0fa09ab` (réconciliation documentaire, CI run 288 SUCCESS)
**Ordre fondateur** : 5 volets A (caméra) / B (labo Android) / C (APK update signée) / D (audit Kaggle) / E (ce checkpoint).
**Règles** : un commit ciblé par correction · arrêt après le rapport final · aucun push `main`, aucun reset destructif, aucun RC16, aucune publication commerciale · CinetPay reste 501 · 600 compositions audio et 30 gabarits protégés · `gradle.properties` jamais modifié dans le dépôt.

## État des volets

| Volet | État | Commit | Run CI | Notes |
|---|---|---|---|---|
| A. Verrouillage caméra | **TERMINÉ** | 0cd7ac3 | à poller | 6 correctifs + 5 tests verts, module 22/22 |
| B. Labo Android (e2e) | **TERMINÉ (code) — runs EN COURS** | c0e4125 | lab 43762868411 + CI 43762868387 | branche ajoutée + preuves renforcées |
| C. APK update signée | **BLOQUÉ (secrets absents)** | 290781a | workflow créé | VV_KEYSTORE_B64 / VV_STORE_PASSWORD manquants |
| D. Audit Kaggle | **TERMINÉ (code) — exécution lancée** | (commit D) | à poller | notebook + workflow créés |
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

## C — APK de mise à jour signée (BLOQUÉ — secrets de signature absents)

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
Dernier audit Kaggle : en attente du premier déclenchement du workflow `kaggle-audit`.
<!--/D:AUDIT-->

## Prochaine action exacte

Déclencher `kaggle-audit` (workflow_dispatch) + `referral-qualification` (workflow_dispatch, comptes de test A/B), suivre les runs, consigner les résultats au checkpoint puis produire le rapport final (logique vérifiée par le code vs éléments restant à confirmer sur le téléphone).
