# D42.27-05 — Brouillons inter-sessions + réparation CI du lot 01..04

**Commit : 200b8a6** (1143bfe..200b8a6) — poussé 09/11 ~13:05 UTC.
CI : android-ci 42619094767 + android-e2e-lab 42619096543 — lancés, résultat à vérifier.

## 1. Échec du lot 1143bfe — diagnostic COMPLET (aucune dissimulation)

Runs 42610768031 (android-ci) + 42610768032 (android-e2e-lab) : **failure**.
Les jobs p1/langues/camerap « success » de ce run sont des **runs VIDES**
(APK jamais compilé → échec d'installation → harnais exit 0 par conception ;
ils ne comptent PAS comme validation).

Quatre causes racines :
1. **aapt** : apostrophes non échappées dans `camera_storage_low` (FR) et
   `export_storage_low` (FR) → `mergeDebugResources` FAILED → aucun APK.
2. **ktlint** : double espace avant `//` dans data + ins-capture
   `build.gradle.kts` (« Unnecessary long whitespace »).
3. **tests JVM** : caractère `:` illégal dans les noms backtickés de
   StorageGateTest (l.28, l.33) — interdit par la JVM.
4. **compilation** : dépendance `core-guard` MANQUANTE dans feature-camera
   (Unresolved StorageGate) — révélée par le build local ; jamais atteinte
   en CI car masquée par l'échec ressources en amont.

## 2. Nouvelle règle opérationnelle (leçon)

**Build local complet AVANT tout push** : `:app:assembleDebug` + `ktlintCheck`
+ `detekt` + `testDebugUnitTest` + `checkModuleGraph`. Environnement
reproductible dans le sandbox : JDK 17 Temurin + SDK Android 37 dans
`/home/user/.cache/androidlab/` (exclu du snapshot, à réinstaller si besoin),
`GRADLE_USER_HOME=/home/user/.cache/gradle` avec heap réduit + swap 4 Go.

Validation locale du 200b8a6 : **assembleDebug SUCCESS** (3 itérations :
StorageGate dep, R non-transitif, `/` dans nom de test) ; **ktlint SUCCESS** ;
**detekt SUCCESS** ; **testDebugUnitTest SUCCESS tous modules** ;
**checkModuleGraph SUCCESS**. DraftStoreJsonTest 6/6, StorageGateTest 5/5.

## 3. Brouillons inter-sessions (mission §7) — implémentation

- Room v3→v4 : `project_draft` STRICTEMENT additive (colonnes nullabilité
  exactes), DraftEntity id=1 unique (« dernier parcours gagne »), DraftDao.
- `DraftStore` : sauverBrief / promouvoirCamera / majPrises (garde même
  gabarit + étape CAMERA) / effacer / valuesPourGabarit + JSON pur.
- GabaritBriefScreen : `initialValues` (restaurées priment) + onValuesChange.
- BriefActivity : pré-remplissage + persistance à CHAQUE champ (Dispatchers.IO).
- MainActivity : dialogue framework bloquant (Reprendre/Nouvelle) au retour
  onboarding SI brouillon actif ; promotion CAMERA au REQ_BRIEF ; reprise
  CAMERA : restore_prise_files filtrés File.exists + restore_prise_idx +
  **briefValues restaurés** (extras brief_* de l'export préservés).
- CameraGuideActivity : slots restaurés onCreate + majPrises à chaque
  Finalize réussi (position = prise suivante).
- ExportActivity : SUCCEEDED → brouillon consommé (effacer).
- Chaînes `draft_resume_*` ×4 langues dans le **module app**
  (R non-transitif : les mettre dans core-designsystem ne les expose pas
  au R de l'app — piège documenté).

## 4. Banc e2e dédié

`tools/e2e/run_drafts.sh` (S1 saisie partielle → force-stop → dialogue →
pré-remplissage ; S2 1re scène → force-stop **sans réseau** → reprise
PRISE 2/3 + rush conservé (preuve run-as fichiers) ; S3 fin du montage
≥3 rushs + « Aperçu de ta vidéo » ; S4 retour réseau sans crash).
Job `android-e2e-drafts` (60 min). **camera-front emulated** ajouté au job
camerap : la phase C bascule AVANT exige une caméra avant émulée (`none`
l'aurait bloquée au bind — le garde 5.8 aurait tenu, mais CPC_bascule_avant
aurait été FAIL).

Sûreté : dialogue uniquement si brouillon actif → runners CI frais =
P0/P1/langues/offline/camerap strictement inchangés.

## 5. Suite des corrections (05b/05c) — journal des runs

| Run | Commit | Résultats drafts | Corrections qui en découlent |
|---|---|---|---|
| 42610768032 (1143bfe) | lot initial cassé | APK non compilé (apostrophes/ktlint/dep) | réparation complète → 200b8a6 |
| 42619096543 (200b8a6) | 05 complet | 25/7/1 : dialogue ×2 ✓, pré-remplissage « Boutiq » TRONQUÉ, cascade S2/S3 | 05b : race condition (collectLatest+Mutex, dernière valeur gagne) + banc durci (contrôle d'effet par champ) |
| 42626010820 (988fa48) | 05b | 29/4/1 : S1 pré-rempli « BoutiqueAwa » COMPLET ✓, brief validé ✓, 1re scène filmée ✓ ; S2_champs_effet (scroll bas), S2_reprise_position (brouillon pas encore promu au force-stop) | 05c : promotion GARANTIE avant le guide + logs VV_E2E + swipe corrigé + dump S02_apres_reprendre |
| 42635348805 (7a7c06a) | 05c | EN COURS | — |

**Mécanisme de la race (05b)** : un launch(IO) par frappe → upserts Room
concurrents désordonnés → l'écriture d'une frappe intermédiaire pouvait
commiter en dernier. Preuve : dump S01_saisie_partielle « BoutiqueAwa »
complet vs S01_brief_repris « Boutiq » (6 caractères).

**Mécanisme du S2 (05c)** : promouvoirCamera courait en parallèle du
lancement du guide ; un force-stop entre les deux laissait le brouillon
en état BRIEF → reprise détournée vers le formulaire (vide : pas de
valuesPourGabarit hors étape BRIEF — dump S03 placeholder « Boutique
Élégance »). Désormais la promotion PRÉCÈDE le guide.

## 6. Reste à faire

- Runs 42635348927/42635348805 (7a7c06a) : drafts attendu S1+S2+S3
  complets ; auth (image playstore) ; deeplink (E2E-123).
- 10 : matrice finale ; 11 : RC12. **0 FCFA.**
