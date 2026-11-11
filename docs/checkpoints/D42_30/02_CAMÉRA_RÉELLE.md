# D42.30 — 02_CAMÉRA_RÉELLE

**Étape 1 (P0-A) — caméra réelle.** Défauts terrain traités : n°6 (écran noir),
n°7 (compte à rebours simulé), n°8 (rien ne prouve le tournage) + commandes dupliquées.

## Ce qui a changé (commits dd5ca28 → 10a12e1, code dans feature-camera)

| Sujet | Avant (RC14) | Après (D42.30) |
|---|---|---|
| Flux preview | `Preview` binder **sans `setSurfaceProvider`** → PreviewView noir | `previewView.surfaceProvider` fourni via `surfaceProviderListener` (obtention MAINTENANTE du provider — CameraX 1.6.2) : frames réelles dès l'ouverture |
| État du flux | aucun | `previewView.previewStreamState` observé UNE fois (`observerFluxCamera()`) → `fluxStreamState` = STREAMING/IDLE ; l'écran affiche « Démarrage… » tant que IDLE, « Caméra prête » seulement si STREAMING — **jamais un cadre noir présenté comme prévisualisation** ; log E2E `PREVIEW STREAMING`/`PREVIEW IDLE` |
| Viseur de prise | maquette Compose factice (cercle « 3 » codé en dur) | la maquette est SUPPRIMÉE : le viseur EST le PreviewView réel plein écran ; l'overlay Compose n'affiche plus que le HUD informatif |
| Compte à rebours | inexistant (REC immédiat au tap) | décompte 3-2-1 VÉRITABLE (`compteAReboursJob`, 1 s par pas) ; le `Recorder` ne démarre QU'À LA FIN du décompte ; le HUD affiche le chiffre courant ; tap pendant le décompte = annulation propre |
| Commandes | barre XML + contrôles Compose superposés (Refaire/Tourner/Suivant dupliqués) | commandes UNIQUES dans la barre XML (`brancherCommandes()`) ; Refaire/Suivant neutralisés pendant une prise ; bascule avant/arrière jamais à chaud |
| Badge REC | absent du HUD | badge REC animé lié à l'état `recording` réel du Recorder |
| Arrêt | implicite | arrêt EXPLICITE « Arrêter et continuer » (libellé conservé pour le harnais) |

## Conservés tels quels (garde-fous acquis D42.27–D42.29)

R4 visages (porte bloquante + ConsentRecord), verrou 3A 3 s, avertissement stockage,
`Finalize` + vérification d'intégrité du fichier, slots de prises, brouillons/reprise
(`restaurerBrouillon()` — seuls les fichiers ENCORE EXISTANTS sont restaurés),
piège b/449913903, `InsCameraBinder` (QualitySelector + FallbackStrategy + fusion
MlKitFaceCounter), suppression du fichier incomplet à l'échec de prise.

## Contrôle des rushs (règle invariante : l'existence d'un MP4 ne suffit JAMAIS)

Un rush n'est accepté que si : fichier non vide + durée > seuil + **décodage
intégral** (MediaExtractor/MediaCodec sans erreur) + frames évolutives (au moins
2 frames décodées différentes). Ce contrôle existait (D42.29) et reste la porte
de sortie du tournage guidé — inchangé par l'étape 1.

## Règle produit (défaut n°7, mode générique)

En tournage guidé avec gabarit à prises : l'overlay générique 30 scènes n'est
JAMAIS affiché pendant REC — seul le HUD de prise + badge REC restent. Le
ticker/horloge de progression ne vit QUE dans le mode générique sans gabarit.

## Compatibilité harnais (vérifiée au code)

- `run_audio_modes.sh:569` tape le texte « Tourner » (E6_REC) avec `|| true` —
  toléré ; l'action réelle est « Verrouiller et enregistrer » (CAM_REC,
  `camera_record_button`), présent ; « Arrêter et continuer » (CAM_STOP)
  conservé comme libellé d'état recording.
- Waits « Arrêter et continuer » avec timeout ≥ 8 s > compte à rebours 3 s :
  le flux harnais reste compatible (le REC ne démarre qu'après le décompte,
  l'attente couvre largement).
- `run_official_e2e.sh` : n'utilise PAS « Tourner ». Aucun autre harnais impacté.
- `CameraVisualCheckTest` : paramètres nommés — signatures `PriseGuideScreen`
  (prises, priseIdx, sectorLabel, formatLabel, streaming, recording, countdown,
  priseValidee, faceCount, gateAllowed) et `GuidedShootingOverlay` vérifiées
  conformes aux appels.

## Machine à états du tournage (audit complété, correctif D42.30-07)

États : PRÊT → DÉCOMPTE 3-2-1 → (ANNULÉ) → VERROUILLAGE 3A → ENREGISTREMENT →
ARRÊT → FINALISATION → PRISE VALIDÉE / ÉCHEC.

| Règle | Constat d'audit | Statut |
|---|---|---|
| 2e appui pendant le décompte = annulation | `onRecord` : `compteAReboursJob?.isActive` → cancel + retour PRÊT, aucun `start()` | déjà en place (dd5ca28) |
| `VideoCapture.start()` jamais avant la fin du décompte | `startRecording()` n'est appelé qu'après la boucle 3×`delay(1000)` | déjà en place |
| **Fenêtre verrouillage 3A couverte** | **TROU (5082856) : le job se terminait avant `lockThreeA` (≤3 s) ; l'écran montrait PRÊT → un re-tap relançait un décompte → 2e `startRecording()` pendant que le 1er enregistrement tournait (référence `Recording` écrasée, fichier orphelin)** | **CORRIGÉ (non poussé) : `launchLockedRecording()` devient SUSPEND et vit DANS le job du décompte — `isActive` couvre décompte + verrouillage, le 2e tap annule dans les deux fenêtres** |
| `runCatching` avalait la `CancellationException` | un tap d'annulation pendant `lockThreeA` n'aurait PAS interrompu `startRecording()` | CORRIGÉ : `onFailure { if (it is CancellationException) throw it }` |
| Aucune prise vide/incomplète | Finalize `hasError()` → `file.delete()` + message + prise rejouable ; `start()` blindé try/catch → échec de démarrage = fichier supprimé + sortie propre | renforcé |
| Appuis rapides ≠ plusieurs enregistrements | gardes : `priseEnCoursDeFinalisation` (taps ignorés), `isActive` (annulation), `recording != null` (stop) | vérifié |
| Bouton/indication = état réel | `updateStatus()` : `lancement = compteARebours != null || verrouillageEnCours` → texte « Prépare-toi… » + bouton « Annuler le décompte » pendant décompte ET verrouillage ; « Arrêter et continuer » dès l'enregistrement réel | vérifié |

Compatibilité harnais conservée : l'attente « Arrêter et continuer » (8 s) couvre
décompte 3 s + verrouillage 3 s ; le harnais ne tape jamais pendant ces fenêtres
(il attend d'abord le libellé).

## Réfection detekt/AAPT (-suite dd5ca28, corrigée dans 10a12e1)

- `onCreate` 98 → ~20 lignes : extraction `restaurerBrouillon()`,
  `chargerGabarit()`, `masquerBoutonsGabarit()`, `majVisibiliteBoutonsGabarit()`,
  `installerOverlayCompose()`, `observerFluxCamera()`, `brancherCommandes()`.
- `activity_camera_guide.xml` : 3× `?attr/materialButtonOutlinedStyle` (attr
  Material Components indisponible dans le module) → styles locaux
  `backgroundTint`/`textColor` sur les boutons Retour caméra / Refaire / Suivant.

## Preuve matérielle — reste à produire (étape 8)

Le fondateur a testé sur téléphone physique ; le sandbox n'a pas de matériel
fondateur. Les preuves caméra D42.30 seront produites par :
1. émulateur CI avec caméra **émulée réelle** (VirtualScene/EmulatedCamera —
   jamais FixtureFrameSource) : logs `PREVIEW STREAMING` + MP4 rushs décodés ;
2. si le matériel fondateur est absent au moment du scellage :
   `BLOCKED_DEVICE_TEST` explicite — **jamais** une preuve émulateur présentée
   comme physique.

## État

- **android-ci SUCCESS sur 5082856** (D42.30-06) : ktlint + detekt + tests JVM +
  compile tous modules + packaging APK — tout le lot D42.30 (caméra, WhatsApp,
  catalogue, prix, FR/EN) compile et passe la qualité.
- **e2e-lab 5082856 : suite principale (run_p0 base/font130/rot90, petit écran)
  SUCCESS** ; auth/offline/deeplink/security/gabarits/backend-http SUCCESS ;
  **langues (en) SUCCESS** ; langues (es)/(ja) FAILURE attendue (matrices non
  encore restreintes dans android-e2e-lab.yml — corrigé dans le commit suivant).
- Correctif machine à états (fenêtre verrouillage) codé, commit en attente de
  la fin du lab (pour ne pas annuler la validation en cours).
- Points de contrôle restants : verdict camerap (en cours au moment de l'écriture),
  preuve STREAMING sur émulateur, prises réelles ×3 dans le parcours 25 étapes.
