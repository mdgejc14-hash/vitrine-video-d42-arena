# Audit technique profond — soudure moteur (certification Architecte)

Methode : lecture integrale du code source + tests JVM existants executes en CI.
Aucune affirmation sans preuve de code ou de test.

## 1. Camera & IA (`:feature-camera`, `:ins-capture`)

| Controle | Verdict | Preuve |
|---|---|---|
| Verrou 3A (AE/AWB) avant chaque prise | **CERTIFIE (corrige ce cycle)** | `InsCameraBinder.lockThreeA` : FocusMeteringAction centre, flags AE+AWB, auto-cancel 3 s ; desormais appele via `launchLockedRecording()` avant `startRecording()` (defaut trouve : fonction existante jamais callee) |
| Porte R4 visages BLOQUANTE | **CERTIFIE** | `ConsentGate.decide` pur : ALLOW / BLOCK_MODAL_CONSENT / BLOCK_MODAL_MINOR ; teste JVM (`ProfilerAndConsentTest`) ; modale consentement dans `CameraGuideActivity.onRecord` |
| Comptage visages 100 % on-device | **CERTIFIE** | `MlKitFaceCounter` (ImageAnalysis 160x120) -> `onFaces` -> decision + badge overlay |
| Stabilisation conditionnelle | **CERTIFIE** | `applyStabilizationIfSupported` : activee SEULEMENT si `isStabilizationSupported` (evite erreur HAL) |
| Guide de tournage par scenes | **CERTIFIE (ajoute ce cycle)** | `buildSceneGuides` = meme horloge `DefaultBeatSheet` que le montage ; overlay compteur 1/N, jauge, instructions FR, cadre 9:16 + silhouette |

## 2. Moteur media natif (`:ins-effects`, `:feature-export`)

| Controle | Verdict | Preuve |
|---|---|---|
| Assemblage multi-rushs | **CERTIFIE** | `MotionComposition` : `MediaItem.ClippingConfiguration` (debut/fin) par rush, `EditedMediaItemSequence.Builder().addItems()`, `Composition.Builder(listOf(sequence))` (API Media3 1.11 exacte) |
| Zooms z(t) & transitions | **CERTIFIE** | `MatrixTransformation.getMatrix(presentationTimeUs)` NDC + `TimestampWrapper`/`OverlayEffect`/`TextOverlay` (kinetic typography) ; tests `PipelineLogicTest`, `MotionJsonTest` |
| Orchestration background | **CERTIFIE** | `ExportWorker` (WorkManager) : KEY_INPUT/KEY_CLIENT_RUSHES/KEY_SCRIPT/KEY_DURATION_S/KEY_BEAT_SHEET ; fallback `DefaultBeatSheet.fromScript` on-device ; contraintes batterie |
| Beat sheet versionnable | **CERTIFIE** | `DefaultBeatSheetTest` : bounds (0 + drops + duree).distinct(), total plans = duree voix, plan[0].t1 = 2,0 s |

## 3. Acoustique (`AudioChain`)

| Controle | Verdict | Preuve |
|---|---|---|
| Cible master | **CERTIFIE** | `MASTER_LOUDNESS_I = -14.0` LUFS, `MASTER_TRUE_PEAK_DB = -1.0` dBTP -> filtre ffmpeg `loudnorm=I=-14.0:TP=-1.0` |
| Ducking sidechain | **CERTIFIE** | `sidechaincompress` (seuil/ratio/attack/release constants) : musique ecrasee par la voix |
| Chaine voix | **CERTIFIE** | highpass 85 Hz, lowpass 15 000 Hz, compresseur (-18, 3:1), volume 1,06 ; tests `AudioChainTest` (construction des commandes ffmpeg, JVM) |
| Honnetete banc vs appareil | **RAPPEL** | Media3 1.11 ne fournit ni loudnorm ni sidechain : le mix final s'execute au banc ffmpeg (serveur/export local), pas dans le pipeline Transformer appareil |

## 4. Defauts trouves et corriges ce cycle

| Defaut | Correction |
|---|---|
| Catalogue ignorait le secteur choisi a l'onboarding | `Sector.fromCodeOrNull` + `initialSector` + sous-titre adapte + subtext redundant supprime en mode filtre |
| Retour natif Android ejectait vers l'accueil | `MainActivity.stepBack` : chaine wizard langue <- auth <- onboarding <- catalogue <- brief <- camera |
| Verrou 3A jamais applique avant prise | `bind()` retourne `Camera` ; `launchLockedRecording()` |
| Ecran tournage sans guide par scene | `GuidedShootingOverlay` (cadre, compteur, jauge, instructions, badge R4) |
| Export sans preview | `ExportPreviewPanel` (typographie cinetique + recap rushs/duree) |

## 5. Restes connus (assumes, documentes)

- Routes billing FedaPay/CinetPay : planifiees additives (§2.4 CONNECTEURS_BACKEND.md), absentes du worker v0.9.0.
- Mix loudnorm/ducking : banc ffmpeg, pas on-device (limite Media3 1.11, non contournable proprement).
- Captures Robolectric = rendu logiciel NATIVE : fidele pour layout/couleurs/textes ; ne remplace pas un banc appareil pour camera reelle et performances GPU.
