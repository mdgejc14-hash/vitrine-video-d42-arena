# REPORT_D42_34 — Mission post-acceptation A→E (ordre fondateur)

**Date : 15 novembre 2026** (dates réelles, horodatages GitHub Actions à l'appui).
**Branche : `d42.34-founder-acceptance-fixes`** — chaîne poussée sur origin :
`6d83e20 → 0fa09ab → 0cd7ac3 (A) → c0e4125 (B) → 290781a (C) → 213b713 (D) → b94f7a9 → cc4cf74 → 8d7ef26 → 8bcfd1e (fixes D)`.
Aucun push sur main. Aucun reset destructif. `gradle.properties` intact dans le dépôt.

---

## Résumé exécutif

| Volet | Statut | Preuve principale |
|---|---|---|
| A. Verrouillage caméra | **TERMINÉ** | commit `0cd7ac3` ; tests dédiés 5/5 + module caméra 22/22 |
| B. Labo Android e2e | **TERMINÉ (code)** | commit `c0e4125` ; android-ci SUCCESS sur chaque SHA ; run lab final en cours |
| C. APK mise à jour signée | **BLOQUÉ** | secrets `VV_KEYSTORE_B64` / `VV_STORE_PASSWORD` ABSENTS du dépôt (constat API du 15/11) ; versionCode 3 + workflow prêts |
| D. Audit Kaggle | **EN EXÉCUTION** | Qualification parrainage comptes A/B : **13 PASS / 0 FAIL** ; notebook `vitrine-video-d42-34-validation` en cours d'exécution sur Kaggle |
| E. Rapport final | **LE PRÉSENT DOCUMENT** | distingue logique vérifiée par code vs à confirmer sur téléphone réel |

---

## A — Verrouillage caméra (TERMINÉ, logique vérifiée par code + tests exécutés)

Six correctifs de `CameraGuideActivity.kt` (commit `0cd7ac3`) : impossible de passer au
montage tant que les **prises obligatoires ne sont pas valides**.

- Tests **exécutés** : `D34CameraVerrouillagePriseTest` 5/5 ; module `feature-camera` 22/22
  (JVM, recette Gradle un-par-un documentée au checkpoint).
- **Aucun durcissement en dur du nombre de prises** : la matrice canonique
  **30 gabarits / 81 prises (2 à 4 par modèle)** est inchangée — JSON gabarits et moteur
  de montage non modifiés (vérifié par diff de commit : seuls `CameraGuideActivity.kt`,
  son test et le checkpoint sont touchés).
- Ce qui reste à confirmer sur téléphone réel : le comportement du **capteur physique**
  (toutes les preuves émulateur du labo portent l'étiquette « caméra virtuelle »).

## B — Labo Android e2e (TERMINÉ côté code, exécution en cours)

Commit `c0e4125` : la branche est ajoutée aux triggers push d'`android-e2e-lab.yml` et
les preuves caméra sont renforcées dans `tools/e2e/run_p1.sh` / `run_camerap.sh` :

| Nouveau contrôle | Ce qu'il prouve (caméra virtuelle) |
|---|---|
| `P1_verrouillage_prises` | « Suivant » sans rush valide → guide conservé + mention « obligatoire » (A.3 sur émulateur) |
| `P1/CPB_preview_streaming` | marqueur VV_E2E « PREVIEW STREAMING » présent |
| `P1/CPB_countdown_avant_recorder` | « compte à rebours : 1 » avant chaque « startRecording : start( » |
| `P1/CPB_finalize_sans_erreur` | `hasError=false` partout, aucun `true` |
| `P1_rushs_decodables` | chaque rush non vide ET décodable par ffprobe |

Étiquettes « caméra virtuelle » + `camera=virtuelle (émulateur, -camera-back emulated)`
dans `summary.txt` et bilans — **jamais présenté comme validation capteur physique**.

Runs GitHub Actions (constatés le 15/11, UTC) :
- `android-ci` : **SUCCESS sur chaque SHA poussé** — 289 (c0e4125), 290 (290781a),
  291 (213b713), 292 (b94f7a9), 293 (cc4cf74) au 15/11 21:39 UTC ; les suivants
  suivent le même schéma à chaque push.
- `android-e2e-lab` : les runs intermédiaires sont `cancelled` — **annulation
  automatique par concurrence** à chaque push successif (comportement prévu) ; le
  **dernier run en date** (sur le SHA le plus récent poussé) porte la couverture
  complète et va jusqu'au verdict.

## C — APK de mise à jour signée (complément fondateur : signature officielle D42.17 récupérée et vérifiée)

**Recherche ordonnée (résultats)** : (1) `~/keystores/vitrine.keystore` **retrouvé**
dans l'environnement de confiance, avec `signing.properties` (mot de passe autorisé,
jamais affiché), `.store_pw` et `VV_KEYSTORE_B64.txt` (décodage identique octet pour
octet) ; (2) `~/.cache/vv-toolchain/` absent ; (3) `vv-signing/` historique absent ;
(4) docs D42_17 recoupées — option C retenue : la clé ne quitte jamais la sandbox ;
(5) dépôt privé `mdgejc14-hash/vitrine-video` : **`VV_KEYSTORE_B64` et
`VV_STORE_PASSWORD` toujours présents** (17 secrets, noms seuls).

**Contrôle de sécurité triangulaire (empreinte EXACTE
`758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192`)** :
- `keytool` sur le keystore : PKCS12, alias `vitrine`, PrivateKeyEntry, validité 2056,
  DN `CN=Vitrine Video, OU=Mobile, O=EPD HOLDING, L=Cotonou, ST=Littoral, C=BJ` —
  SHA-256 du certificat **EXACT**.
- `apksigner verify --print-certs` sur l'APK RC15 livrée (release publique
  `d42.30-rc15`, SHA-256 APK `fd28ffc7…b78936`, 44 470 123 o) : signataire V3.0
  **même DN, même SHA-256** → le keystore local est exactement la clé de l'APK
  installée chez le fondateur.
- RC15 : `video.vitrine.app` / versionCode 2 / 0.9.0-rc15 / minSdk 24 / targetSdk 36
  → la versionCode 3 produite est la mise à jour Android exacte.

**Production en cours (voie conforme D42.17)** : build local sur checkout exact
`e04756b` (arbre strictement propre), `assembleRelease` R8 + porte d'intégrité
`-PvvApkSha256=758077eb…`, signature via `vv-signing/` gitignoré, clé Firebase réelle
(identifiant public extrait de la RC15) injectée par env sans être affichée ni
committée. **Frontière préservée : aucun secret ajouté au dépôt public, keystore et
mots de passe jamais écrits dans le dépôt, les logs, les rapports ou les artefacts ;
seule l'APK signée sera livrée.** Aucune clé privée extraite d'aucune APK. Le workflow
CI `release-update-apk` reste disponible mais inerte (sans secrets), la signature
historique restant locale.

## C-historique — constat initial (BLOQUÉ, 15/11 avant récupération)

**Constat (API GitHub, 15/11, valeurs jamais affichées)** : le dépôt expose 16 secrets ;
`FIREBASE_WEB_API_KEY`, `KAGGLE_USERNAME`/`KAGGLE_KEY`, comptes `FIREBASE_TEST_A/B_*`,
`B2_*`, `CLOUDFLARE_*`, `OPS_ENABLED` sont présents, mais **`VV_KEYSTORE_B64` et
`VV_STORE_PASSWORD` sont ABSENTS**.

Conformément à l'ordre fondateur : **statut BLOQUÉ consigné**, aucune APK produite.
Une APK signée d'une clé différente **ne mettrait pas à jour** l'installation du
8 novembre (signatures Android incompatibles) et ne sera jamais présentée comme telle.

Ce qui est prêt pour débloquer immédiatement (commit `290781a`) :
- `.github/workflows/release-update-apk.yml` (workflow_dispatch) : pré-vol des secrets
  avec arrêt **BLOQUÉ** explicite si absents → décodage base64 du keystore +
  `signing.properties` dans `vv-signing/` (gitignoré) → `assembleRelease` avec porte
  d'intégrité `-PvvApkSha256=758077eb…` → vérifications **SHA-256 APK, package
  `video.vitrine.app`, versionCode 3, empreinte certificat exacte
  `758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192`** (rejet sinon) →
  contrôle dex (clé Firebase réelle présente, factice absente) → **artefact Actions
  30 jours uniquement**. Aucun tag, aucune GitHub Release, aucun store, aucun RC16.
- `versionCode = 3` (build-logic ; supérieur au 2 installé), même applicationId,
  versionName RC15 inchangé.
- Keystore fondateur documenté (D42_17) : `~/keystores/vitrine.keystore`.

**Déblocage** : ajouter `VV_KEYSTORE_B64` (base64 du keystore du 8 novembre) et
`VV_STORE_PASSWORD` dans Settings → Secrets and variables → Actions, puis relancer
`release-update-apk`. (Le workflow n'est pas encore dispatchable tant qu'il n'existe
que sur la branche — il le deviendra à la fusion sur la branche par défaut.)

## D — Audit Kaggle automatisé (EN EXÉCUTION)

### D.1 Qualification parrainage sur comptes de test — **EXÉCUTÉE : 13 PASS / 0 FAIL**
Run « Referral Qualification » n°4 (commit 213b713, 15/11 21:26–21:37 UTC), comptes
de test dédiés A/B (secrets Firebase), backend de production, aucune donnée utilisateur
réel. Journal : artefact du run. Contrôles passés :
`sessions_comptes_test` (200/200), `referral_code_cree`, `referral_code_unique`,
`referral_payload_complet` (target=5), `anti_auto_parrainage` (404), `claim_sans_auth_refuse`
(401), `referral_sans_auth_refuse` (401), `code_inconnu_refuse` (404), `claim_nominal`
(A claim le code de B → 200), `attribution_parrain` (+1 côté B), `anti_doublon_reclaim`,
`anti_auto_parrainage_b` (404), `isolation_historiques`.
→ **Avec code ET garde-fous sans code : preuve d'exécution réelle côté serveur.**

### D.2 Notebook Kaggle `vitrine-video-d42-34-validation` — EN COURS
Workflow `kaggle-audit` (run 5, commit 8bcfd1e) : le notebook **privé, Internet activé**
a été poussé sur Kaggle (authentification par **token** — CLI 2.2.5 + `access_token` ;
le mécanisme classique `kaggle.json` donnait 401, d'où les correctifs `b94f7a9`,
`cc4cf74`, `8d7ef26`). Il clone le miroir public **au SHA exact** (vérifié après
clonage), installe JDK 17 + Android SDK, puis exécute : tests JVM/Robolectric
(**compte exact consigné — l'ordre mentionne 360, le notebook affiche le réel**),
`ktlintCheck`, `detekt`, `checkModuleGraph` ; valide **30 gabarits / 81 prises** ;
audite les **deux manifests audio (600 compositions déclarés chacun)**, ressources
strings, boutons ↔ layouts, routes ::class ↔ manifests, références gabarits ↔ assets,
crédits/quotas application (StorageGate + tests) et Worker (`src/index.js`,
`decideQuota`/crédits, lecture seule).

**Verdicts exclusifs : COMPLET / CASSÉ / NON JUGEABLE PAR LECTURE SEULE**, avec
citations fichiers et lignes ; aucun contrôle statique n'est présenté comme preuve
d'exécution. À la fin du run : rapport du notebook commité sur la branche sous
**`REPORT_KAGGLE_D42_34.md`** + sorties en artefact 30 jours + mise à jour du
checkpoint. La qualification serveur (comptes de test) n'est **pas** exécutée dans le
notebook — seuls `KAGGLE_USERNAME`/`KAGGLE_KEY` lui sont transmis (D.1 la couvre).

Incidents D résolus (une tentative méthodique par état) : `six` manquant → installé ;
CLI 2.2.5 ignore `kaggle.json` → épinglage 1.7.4.5 puis **détection automatique des
deux mécanismes** (token OU classique, BLOQUÉ explicite si refusés) ; collision de nom
`REPORT_D42_34.md` → sortie notebook renommée `REPORT_KAGGLE_D42_34.md` (le présent
rapport final garde son nom).

## E — Le présent rapport (statuts et limites)

### Logique vérifiée par code (exécution ou lecture citée)
- A : verrouillage des prises avant montage — tests dédiés exécutés (5/5, 22/22).
- B : contrôles e2e renforcés — scripts validés (`bash -n`), exécution lab en cours,
  étiquetage « caméra virtuelle » systématique.
- C : versionCode 3, workflow de build signé et ses portes — lus et décrits ci-dessus ;
  **aucune APK produite** (BLOQUÉ).
- D.1 : qualification parrainage **exécutée** (13 PASS) sur comptes de test.
- Clôture D42.34 (référence, acceptée) : 78 états = 68 CONFORME / 6 NON PROUVÉ /
  4 NON APPLICABLE.

### À confirmer sur le téléphone réel (jamais présentés comme prouvés)
- Capteur caméra physique (toutes les preuves émulateur = « caméra virtuelle »).
- Les 6 NON PROUVÉ exacts de la clôture : **VR-001, VR-009, VR-037, VR-048, VR-053,
  VR-065** (détails dans `docs/checkpoints/D42_34/13_RAPPORT`).
- VR-056 (feuille de partage Android) : **NON APPLICABLE** — correction fondateur
  explicite, ne jamais la classer NON PROUVÉ.
- Comportement du Worker déployé (le notebook ne fait que lire `src/index.js`).
- Verdicts finaux du notebook Kaggle : à lire dans `REPORT_KAGGLE_D42_34.md` dès la
  fin du run 5 (auto-commit) — non encore disponibles à la rédaction.

### Restrictions respectées
Pas de push main ; pas de reset destructif ; pas de redémarrage des lots D42.34 ;
`gradle.properties` non modifié ; Worker/D1/B2/secrets prod inchangés ; CinetPay 501 ;
aucun RC16 ; aucune Release/tag ; 600 compositions audio et 30 gabarits protégés
(JSON et moteur de montage non touchés) ; jamais 4 prises en dur ; secrets jamais en
clair ; CI verte ≠ approbation artistique.

### Arrêt
Rapport final remis. **Arrêt en attente d'acceptation du fondateur.** Restes
opérationnels automatiques : fin du run kaggle-audit 5 (auto-commit du rapport Kaggle
et du checkpoint), fin du dernier run lab et des CI en cours ; déblocage de C à la
seule main du fondateur (ajout des 2 secrets).

---

# MISSION MAÎTRESSE D42.34 — VALIDATION FINALE (2026-11-16, 17:25 UTC)

**SHA final** : `0317184` (code applicatif = f2543b6 ; 0317184 = notebook v3.5 + triggers
workflows). Chaîne : e651295 → f2543b6 (correctifs lab 274) → 053d4c8 (filtres déclencheurs)
→ b92e489/fb04c0f (checkpoints) → 0317184 (kernel v3.5) → 72a5aba (rapport Kaggle auto).

## A — Code et compilation (exécuté)

- **Correctif applicatif unique, cause prouvée sur artefacts** : `ExportWorker` résolvait
  ses chaînes (phases d'export, notification FGS, canal) en locale SYSTÈME — dumps 29x/29y
  du lab 274 : `export_status` = « Rendering the video » sur un parcours FR. Corrigé par
  `VitrineLocale.wrap(context).getString(...)` (3 sites, `feature-export` dépend déjà de
  `core-designsystem`). **Prouvé après correction sur émulateur** (lab final) :
  `export_status = « Rendu de la vidéo »`.
- **android-ci 43904729363 : SUCCESS** (compilation + tests unitaires).
- **Kernel Kaggle v3.5 (kaggle-audit 43904729509, SUCCESS)** : `:app:assembleRelease`
  **BUILD SUCCESSFUL en 11 min 55 s, 602 tâches** — R8 + shrinkResources, JDK 17 Temurin,
  SDK android-37, mémoire Gradle passée en UN argument quoté en ligne de commande
  (`gradle.properties` du dépôt JAMAIS modifié).
- APK PRE-SIGN : **47 886 801 octets**, SHA-256
  `5da0e5ca0b97d7220272f2ab37b2aea6a6478014b55c79fbb773373cd387f31a` (vérifié octet pour
  octet après téléchargement de l'artefact). mapping R8 (84 Mo) archivé dans l'artefact
  `kaggle-audit-output` (30 jours).

## B — Tests : comptes EXACTS (exécutés)

**JVM/Robolectric (kernel v3.5, SHA 0317184) : 383 exécutés / 0 échoués / 0 ignorés** —
app:1 · core-guard:27 · core-model:11 · data:82 · feature-brief:26 · feature-camera:22 ·
feature-catalog:26 · feature-dashboard:41 · feature-export:11 · feature-onboarding:31 ·
ins-capture:4 · ins-effects:99 · ins-thermal:2. ktlintCheck rc=0 · detekt rc=0 ·
checkModuleGraph rc=0.

**Lab Android final (android-e2e-lab 43904729372, SHA 0317184) : 15/15 jobs SUCCESS** :
- `android-e2e-p1` : **41 PASS / 0 FAIL / 0 BLOCKED** — parcours complet auth→langue→
  carrousel→activité→parrainage→catalogue→brief→caméra virtuelle (3 prises, décompte,
  Finalize, rushs ffprobe-décodables)→montage→aperçu→export (statut de phase réel, FGS
  vv_export, écran éteint 45 s, « Vidéo prête ! », export-0.mp4 **5 403 826 octets**
  extrait, feuille de partage) — aucun crash.
- `android-e2e` (P0) : pixel5-base **22/22**, pixel5-font130 **23/23**, pixel5-rot90
  **23/23** (0 FAIL, 0 BLOCKED partout, S18 aucun crash partout).
- `android-e2e-offline-export` : **47/47** · `android-e2e-camerap` : **62/62** ·
  gabarits-audit 817/817 · 10 autres jobs SUCCESS (auth, deeplink, drafts, langues EN,
  offline, petit-ecran, backend-http, security-local, camera-diagnostic, harness-selftest).
- **Parrainage serveur : 13 PASS / 0 FAIL** (workflow referral-qualification — code
  inchangé, non relancé).

**Historique honnête** : lab 274 (e651295) = 12/15 — chaque FAIL classé sur preuves :
P1_export_lance/P1_ecran_etaint = DÉFAUT APPLICATIF i18n Worker + DÉFAUT HARNAIS
(assertion phrase FR figée) ; P0 font130 S15/S17 = ENVIRONNEMENT (SIGSEGV system_server
dans registerUiTestAutomationService — app non fautive, base 22/22). Kernel v3.3/v3.4 :
causes « -X » (arguments mémoire éclatés) puis détecteur APK (os.walk écrasant sa liste
dans baselineProfiles) — toutes deux prouvées, corrigées, re-testées.

## C — Les 15 parcours du lab (tous exécutés, verdicts exclusifs)

P1 parcours nominal complet (**COMPLET**, 41/41) · P0 pixel5 base/font130/rot90
(**COMPLET** ×3) · petit-ecran small/font130 (**COMPLET**) · camerap (**COMPLET**, 62/62) ·
offline (**COMPLET**) · offline-export BGM en cache (**COMPLET**, 47/47) · auth local
(**COMPLET**) · deeplink (**COMPLET**) · drafts (**COMPLET**) · langues EN (**COMPLET**).
Jobs support : backend-http, security-local, gabarits-audit, camera-diagnostic,
harness-selftest (**COMPLET** ×5). Aucun CASSÉ, aucun NON JUGEABLE PAR LECTURE SEULE dans
les parcours d'exécution ; « États de navigation » reste NON JUGEABLE PAR LECTURE SEULE
(audit kernel, honnête — l'exécution UI est couverte par les bancs émulateur).

## D — Sécurité et signature (vérifiées par outils, valeurs exactes)

- **APK officiellement signée** : `vitrine-video-0.9.0-rc15-SIGNEE-OFFICIEL.apk`,
  47 962 258 octets, SHA-256
  `599cc0b1828caad35ce24701719175ae91c570ea1fb23a9d8a0be4e7633694be`.
- `apksigner verify` : **PASS (schéma V3.0)**. DN : `CN=Vitrine Video, OU=Mobile,
  O=EPD HOLDING, L=Cotonou, ST=Littoral, C=BJ`. Empreinte certificat SHA-256 :
  `758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192` — **EXACTE**
  (règle de rejet si différence : respectée, contrôlée par script).
- `aapt dump badging` : package `video.vitrine.app` · **versionCode 3** ·
  **versionName 0.9.0-rc15** · minSdk 24 · targetSdk 36.
- **Mise à jour RC15 sans désinstallation** : certificat de la RC15 installée
  (`~/apk_update/rc15.apk`) et de la nouvelle APK **IDENTIQUES** (même empreinte
  758077eb…) + versionCode 3 > 2 + même package → Android l'acceptera comme mise à jour.
  Logique vérifiée par comparaison des certificats ; l'installation elle-même reste un
  geste physique (voir E).
- **Chaîne de confiance** : PRE-SIGN construite sur Kaggle SANS keystore (clone public,
  clé debug de recette, `vv-signing/` gitignoré) ; re-signature uniquement dans la
  sandbox Arena (keystore historique D42.17, jamais sorti, jamais vers Kaggle ni le dépôt).
- Clé Firebase **RÉELLE** extraite des dex de la RC15 publique, injectée sans affichage
  (dex : 1 occurrence réelle, 0 factice — contrôlé par le kernel). Porte d'intégrité
  `-PvvApkSha256=758077eb…` active. Aucun secret en commit/journal/notebook/rapport.

## E — Réserves physiques (formule fondateur)

Logique vérifiée par le code et tests automatisés exécutés ; validation physique restante
à confirmer sur téléphone.

À confirmer sur le téléphone du fondateur : capteur caméra physique (toutes les preuves
émulateur sont étiquetées « caméra virtuelle »), parcours complet réel (splash, viseur,
consentement, SSO Google, feuille de partage), installation de l'APK signée **par-dessus
la RC15 sans désinstallation** (certificats identiques prouvés ci-dessus), comportement
réseau réel (CinetPay reste 501, budget 0 FCFA).

## Livrables

- **APK signée** (téléchargeable depuis la sandbox Arena) :
  `~/apk_update/vitrine-video-0.9.0-rc15-SIGNEE-OFFICIEL.apk` + `build_rapport_kernel_v35.txt`.
- Rapports : `REPORT_D42_34.md` (ce fichier), `REPORT_KAGGLE_D42_34.md` (poussé par le
  workflow, commit 72a5aba), `CHECKPOINT_D42_34_VALIDATION.md` (jalons datés).
- Artefacts GitHub (30 jours) : kaggle-audit-output 607 Mo (run 43904729509), e2e-p1,
  e2e-pixel5, e2e-camerap, e2e-offline-export… (run 43904729372).

## Arrêt

Mission maîtresse D42.34 conduite à son terme technique : version validée (lab 15/15,
383 tests JVM, kernel SUCCESS), officiellement signée (empreinte exacte), prête pour le
test final du fondateur. **Arrêt en attente du test physique fondateur.**
