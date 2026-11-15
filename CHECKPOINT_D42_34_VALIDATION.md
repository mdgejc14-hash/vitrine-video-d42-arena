# CHECKPOINT D42.34 — VERROUILLAGE CAMÉRA, APK UPDATE, AUDIT KAGGLE

**Branche** : `d42.34-founder-acceptance-fixes` · **Base de reprise** : `0fa09ab` (réconciliation documentaire, CI run 288 SUCCESS)
**Ordre fondateur** : 5 volets A (caméra) / B (labo Android) / C (APK update signée) / D (audit Kaggle) / E (ce checkpoint).
**Règles** : un commit ciblé par correction · arrêt après le rapport final · aucun push `main`, aucun reset destructif, aucun RC16, aucune publication commerciale · CinetPay reste 501 · 600 compositions audio et 30 gabarits protégés · `gradle.properties` jamais modifié dans le dépôt.

## État des volets

| Volet | État | Commit | Run CI | Notes |
|---|---|---|---|---|
| A. Verrouillage caméra | **TERMINÉ** | 0cd7ac3 | à poller | 6 correctifs + 5 tests verts, module 22/22 |
| B. Labo Android (e2e) | **TERMINÉ (code) — runs EN COURS** | (commit B) | à poller | branche ajoutée + preuves renforcées |
| C. APK update signée | EN COURS | — | — | secrets à vérifier |
| D. Audit Kaggle | EN COURS | — | — | notebook à créer |
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

## Prochaine action exacte

Volet C : vérifier les secrets `VV_KEYSTORE_B64` / `VV_STORE_PASSWORD` / `FIREBASE_WEB_API_KEY` (présence, sans afficher les valeurs), puis workflow APK release versionCode 3 signée du keystore du 8 novembre (empreinte `758077eb…`) publiée en artefact 30 jours. Si secrets absents : statut BLOQUÉ consigné, poursuite vers D.
