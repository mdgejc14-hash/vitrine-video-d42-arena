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

## C — APK de mise à jour signée (BLOQUÉ — secrets de signature absents)

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
