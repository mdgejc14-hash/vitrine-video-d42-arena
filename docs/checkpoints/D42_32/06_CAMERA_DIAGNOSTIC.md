# D42.32 — Lot 3 (P0) : diagnostic différentiel de la mosaïque caméra

## Principe directeur (exigence fondatrice)

**AVANT TOUTE modification CameraX** : mesurer. Le viseur n'est jamais
masqué, aucune image fixe n'est superposée, aucune fausse prévisualisation.
Aucune preuve d'émulateur n'est présentée comme validation physique.

## Les 4 sources mesurées (indépendamment)

| # | Source | Méthode | Métriques |
|---|---|---|---|
| 1 | **ImageAnalysis** | 30 frames YUV_420_888 brutes du capteur | dimensions, format, timestamps (premier/dernier/Δ ns), luminance plan Y (min/max/moyenne/σ), PNG gris de la frame |
| 2 | **Rendu PreviewView** | `PreviewView.bitmap` (TextureView) OU `PixelCopy(SurfaceView)` | dimensions, luminance, quadrants, grille 8×8, cast R/G/B, PNG — **dans les DEUX modes** (PERFORMANCE=SurfaceView / COMPATIBLE=TextureView) |
| 3 | **Fichier VideoCapture** | enregistrement 2 s → `MediaMetadataRetriever` | octets, codec/MIME, largeur, hauteur, rotation, durée |
| 4 | **MP4 décodé** | `getFrameAtTime` ×3 (décodage réel, ce que consomme le montage) | luminance/grille/cast par frame, 3 PNG |

**Grille 8×8** : moyenne de luminance par cellule — une mosaïque se lit comme
une forte disparité inter-blocs (champ `grille_ecart_max`). **Cast vert** :
`g_moyen` très supérieur à `r_moyen`/`b_moyen` = planes YUV mal gérés.

## Implémentation

- `feature-camera/.../CameraDiagnosticActivity.kt` (non exporté, hors parcours
  commercial) : bind **Preview + VideoCapture + ImageAnalysis simultanés**
  (même configuration que l'écran de tournage : `InsCameraBinder.bind` avec
  analysis fusionnée — leçon B1), viseur réel visible en permanence, statut
  sous le viseur, rapport JSON + PNG dans `getExternalFilesDir("d42/camera-diagnostic")`.
- `app/src/androidTest/.../CameraMosaicDiagnosticTest.kt` : lance le diagnostic
  dans les 2 modes, attend le rapport (45 s max), vérifie la complétude
  (4 sources présentes, ≥10 frames analysis, fichier >0, ≥1 frame MP4 décodée,
  champ `emulateur` TOUJOURS présent, portée identifiée). **Un SUCCÈS = le
  diagnostic a produit ses mesures, PAS « caméra validée ».**
- Job `camera-diagnostic` (android-e2e-lab) : Pixel 5 API 30, **caméra
  émulée**, installe les 2 APK, `am instrument -e class …CameraMosaicDiagnosticTest`,
  `adb pull` du rapport + PNG, artefact 30 j. Échec du banc = job ROUGE
  (aucun FAIL masqué).

## Comment lire le rapport (`rapport-<mode>.json`)

- `appareil.emulateur` : true = résultats d'AVD (caméra virtuelle) — **ne
  valent jamais validation capteur physique** ; false = capteur réel.
- `constats.ecart_luminance_preview_mp4` : écart moyen de luminance entre ce
  que voit le marchand (viseur) et ce que produira la vidéo. Grand écart +
  preview saine = problème pipeline ENREGISTREMENT ; les deux dégradés =
  problème amont (capteur/surface).
- `sources.image_analysis` saine + `preview_view` dégradée = problème de
  SURFACE de rendu (→ tester l'autre mode PreviewView : le rapport des DEUX
  modes permet la comparaison directe).
- `mp4_decode.grille_8x8` structurée en blocs = mosaïque DANS le fichier.

## Validation fondateur (capteur physique) — procédure

```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb install -r app/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk
adb shell pm grant video.vitrine.app android.permission.CAMERA
adb shell am instrument -w -e class video.vitrine.d42.CameraMosaicDiagnosticTest \
  video.vitrine.app.test/androidx.test.runner.AndroidJUnitRunner
adb pull /sdcard/Android/data/video.vitrine.app/files/d42/camera-diagnostic/
```

Le rapport aura `emulateur=false` : c'est la SEULE preuve qui vaut pour le
comportement du capteur réel. **Aucune correction CameraX ne sera appliquée
avant que la cause soit démontrée par ce rapport** (RCA exigée).

## Écran de tournage (état existant, D42.30 — aucune régression nécessaire)

Vérifié ce lot — déjà conforme à la maquette pro : PreviewView pleine surface
comme SEULE zone de cadrage, HUD Compose informatif (TopHud : compteur de
scènes + jauge + état STREAMING ; BottomHud : visages/R4 ; compte à rebours
3-2-1 VÉRITABLE avant enregistrement ; badge REC), barre de commandes unique
ancrée en bas (Refaire / ENREGISTRER / Suivant + bascule caméra avant/arrière,
IDs stables `camera_record_button`, `camera_flip_button`…), texte de guide
borné 2 lignes.

## Résultats

- **Émulateur (job camera-diagnostic), run 43578603832 (2a9ad15)** :
  **RÉCUPÉRATION RÉUSSIE** — 12 fichiers de preuve (64 077 o, artefact
  14106994681), conservés dans `visual-review/camera-preuves/`. Métriques :

  | Source | PERFORMANCE | COMPATIBLE |
  |---|---|---|
  | ImageAnalysis | 31 frames 640×480 YUV_420_888, lum. moy 204,1 | 30 frames, lum. moy 198,1 |
  | PreviewView (bitmap) | 1080×1916, lum. moy 204,4 | 1080×1916, lum. moy 202,4 |
  | VideoCapture | MP4 442 370 o, 720×1280, 1 947 ms | MP4 433 047 o, 2 018 ms |
  | MP4 décodé | 3 frames | 3 frames |
  | **Écart luminance Preview/MP4** | **0,1** | **1,0** |
  | Identification | `emulateur: true` | `emulateur: true` |

  **CONCLUSION (§5)** : PreviewView et MP4 décodé sont pratiquement identiques
  (écart ≤ 1,0/255) — le rendu « coloré » observé est la **scène synthétique
  de la caméra virtuelle de l'AVD**, pas un défaut CameraX. **AUCUNE
  modification CameraX** (RCA : la source virtuelle elle-même ; la mosaïque
  émulateur ≠ mosaïque physique). Portée : ces résultats ne valent JAMAIS
  validation capteur physique — le fondateur testera son téléphone.
- **Historique récupération** : run 43520993407 (2a19d49) artefact 300 o
  (adb pull refusé, scoped storage API 30) → v3 `adb root` APRÈS
  l'instrumentation (le root PENDANT la session caméra crashait l'émulateur :
  `INSTRUMENTATION_ABORTED: System has crashed`, run 43575685106) → v3 a
  récupéré les 12 fichiers mais le **contrôle final échouait sur le heredoc**
  (le runner exécute le script LIGNE PAR LIGNE via `sh -c` : `import: not
  found`) → **v4** : vérificateur `tools/e2e/verify_camera_artifacts.py`
  invoqué en une ligne (2 JSON ≥ 500 o + 4 sources + emulateur=true + PNG
  analysis/preview/mp4 + 2 MP4 réels ≥ 100 Ko) + **copie du MP4 dans le
  dossier de preuve** (`video-<mode>.mp4`, activité diagnostic — le MP4
  restait en cacheDir, invisible de l'artefact).
- **Capteur physique** : EN ATTENTE de la validation fondateur (procédure
  ci-dessus). Aucun résultat physique n'existe à ce jour.

## Décisions

- AUCUNE modification CameraX dans ce lot : la cause de la mosaïque n'est pas
  encore démontrée (exigence : diagnostic AVANT correction). Le diagnostic
  établit la base de preuve pour la RCA.
- L'activity n'est pas exportée : aucune app tierce ne peut déclencher la
  caméra via ce diagnostic.
