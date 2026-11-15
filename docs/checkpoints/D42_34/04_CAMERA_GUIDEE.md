# D42.34 — CR-3 · Caméra guidée par les prises du gabarit (P0 ③)

## Défauts fondateur (captures 015706/015809/015948/020028)

« Scène 1/26 » + « 1,2 s » ; « caméra + PRISE 1/3 » simultanés ; compte à
rebours ; écran noir « Scène 1/0 » + nom technique de package.

## Cause racine (démontrée, base f586678)

`CameraGuideActivity.onCreate()` (l.121-127) :

```kotlin
if (gabaritId != null) chargerGabarit(gabaritId) else masquerBoutonsGabarit()
guides = buildSceneGuides(            // ← construit DANS TOUS LES CAS
    intent.getStringExtra("script").orEmpty(),
    intent.getIntExtra("duration_s", 30),
)
```

`chargerGabarit()` est ASYNCHRONE (`lifecycleScope.launch`, l.152-172) :
`prises` reste vide pendant le chargement — et pour toujours si
`repo.rawJson()` échoue (repli `getOrNull()` silencieux). Or
`installerOverlayCompose()` (l.188-191) affiche `GuidedShootingOverlay`
(scènes génériques) dès que `guideMode && prises.isNotEmpty()` est faux :

- **pendant le chargement** : le parcours générique construit par
  `buildSceneGuides(script, 35)` depuis le « script » = libellés de prises
  joints → `DefaultBeatSheet.fromScript` le découpe en **26 micro-plans**
  → « Scène 1/26 » + « 1,2 s » par plan (le `%.1f s` du TopHud générique) ;
- **si le JSON est illisible** : idem, à vie — le HUD prise correct
  (`PriseGuideScreen`, badge `PRISE n/prises.size`) n'apparaît JAMAIS ;
- **script vide** (parcours libre) : `guides` = liste vide → TopHud affiche
  « Scène %1$d/%2$d » avec `scene?.index ?: 1` et total 0 → « Scène 1/0 ».

C'est le double parcours interdit par l'ordre : le guide générique
`buildSceneGuides(script, durationS)` est affiché quand le mode
gabarit/données n'est pas chargé. **Le branchement est en cause, pas le
texte** : on ne masque pas « Scène », on empêche le parcours générique
d'exister en mode gabarit.

## Points déjà conformes (vérifiés, non retouchés)

- `PriseTopHud` : badge `PRISE ${priseIdx+1}/$total` uniquement + secteur ·
  format ; AUCUN compteur de scène ;
- `EtatFlux` : « Caméra prête » uniquement si `previewStreamState ==
  STREAMING` (flux réel observé), sinon « Démarrage… » ;
- consignes par prise : `PriseInstructionBottom(prise)` (label,
  cameraInstruction via parser, segments show/tell/example, repliable) ;
- compte à rebours D42.30 VÉRITABLE : 3 numéros de 1 s affichés PUIS
  `startRecording()` — l'enregistrement ne démarre JAMAIS pendant le
  décompte ; annulable au 2e tap (y compris fenêtre verrou 3A) ;
- slots alignés : `finishWithPrises()` (1 fichier/prise, `""` si sautée).

## Nom de package (capture 020028) — recherche négative honnête

Aucun affichage de `packageName`/`applicationId`/`javaClass` n'existe dans
les écrans caméra (recherche par symbole exhaustive). Le porteur le plus
probable : un message d'erreur SYSTÈME (dialogue permission OEM, tuile
appareil photo du constructeur) ou un écran d'export. Consigné : si le
défaut persiste après CR-3 sur le téléphone fondateur, capturer l'écran
exact pour localisation.

## Correction racine appliquée (Lot 3)

1. **`onCreate`** : `guides = buildSceneGuides(...)` UNIQUEMENT en mode
   libre (`gabaritId == null`). En mode gabarit : AUCUN parcours générique
   n'est construit — le double parcours ne peut plus exister.
2. **États explicites** : `guideChargement` (chargement async — écran
   honnête « Chargement du modèle… », pas un faux guide) et `guideErreur`
   (JSON impossible ou `prises.isEmpty()` — écran d'erreur récupérable
   « Retour » → `RESULT_CANCELED`, retour brief/catalogue).
3. **Caméra guidée interdite sans prises** : `onRecord` bloqué en mode
   gabarit tant que `prises` est vide (chargement/erreur) — jamais de
   fausse prise guidée.
4. **Mode libre vrai** : `GuidedShootingOverlay` réservé à
   `gabaritId == null` ; son compteur ne s'affiche plus si
   `total == 0` (fin du « Scène 1/0 » — tournage libre honnête).

## Preuves (Lot 3) — exécutées, toutes vertes

- Robolectric `feature-camera` : `D34Lot3CameraStatesVisualCheckTest` —
  4 tests PASS : écran erreur (titre + bouton Retour), écran chargement
  sans compteur, `GuidedShootingOverlay` à 0 scènes SANS « Scène 1/0 »,
  HUD prise T5 réel avec badge PRISE 1/2 et sans compteur de scène.
- Captures `D34-07/08/09/10_*.png` (build/visual-check).
- Module complet : feature-camera 16/16 (0 échec) ; ktlint + detekt verts.

## Non-touchés

Moteur de capture (InsCameraBinder, verrou 3A, ConsentGate R4), compte à
rebours D42.30, `finishWithPrises`, extras/brouillon, permissions.
