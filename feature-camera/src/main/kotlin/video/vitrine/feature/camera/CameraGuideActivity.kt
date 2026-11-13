package video.vitrine.feature.camera

import android.Manifest
import android.app.AlertDialog
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Button
import android.widget.TextView
import androidx.activity.compose.setContent
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.platform.ComposeView
import video.vitrine.core.designsystem.VitrineActivity
import video.vitrine.core.designsystem.VitrineTheme
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.camera.video.FileOutputOptions
import androidx.camera.video.Recording
import androidx.core.content.ContextCompat
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import java.io.File
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import video.vitrine.ins.capture.CaptureSpec
import video.vitrine.ins.capture.ConsentGate
import video.vitrine.ins.capture.DeviceProfiler
import video.vitrine.core.guard.StorageGate
import video.vitrine.ins.capture.InsCameraBinder
import video.vitrine.ins.capture.MlKitFaceCounter
import video.vitrine.core.model.GabaritSummary
import video.vitrine.core.model.PriseGuide
import video.vitrine.data.gabarits.GabaritJson
import video.vitrine.data.gabarits.GabaritRepository
import video.vitrine.data.local.VitrineLocalDatabase

/**
 * Ecran 7 (camera guidee) : guide cadrage/lumiere, porte R4 BLOQUANTE sur visages
 * sans consentement, verrou 3A, stabilisation conditionnelle. Bouton unique :
 * 1er tap = verrou 3A + enregistrement ; 2e tap = stop + rendu au navigateur.
 * Aucun tap mort : chaque etat a une action explicite.
 */
class CameraGuideActivity : VitrineActivity() {

    private lateinit var executor: ExecutorService
    private var useCases: InsCameraBinder.InsUseCases? = null
    private var recording: Recording? = null
    private var outputFile: File? = null
    private var consentGiven = false
    private var minorConsent = false
    private var decision = ConsentGate.Decision.ALLOW
    private var overlayIdx by mutableStateOf(0)
    private var overlayProgress by mutableStateOf(0f)
    private var overlayFaces by mutableStateOf(0)
    private var overlayRecording by mutableStateOf(false)
    private var gateAllowed by mutableStateOf(true)
    // D42.30 : état RÉEL du flux (PreviewView.previewStreamState observé) —
    // distingue « Caméra prête » (STREAMING) de « Démarrage… » (IDLE).
    private var fluxStreamState by mutableStateOf<Boolean?>(null)
    // D42.30 : compte à rebours 3-2-1 VÉRITABLE — le recorder ne démarre
    // qu'à la fin du décompte (avant : démarrage immédiat, cercle « 3 » factice).
    private var compteARebours by mutableStateOf<Int?>(null)
    private var compteAReboursJob: Job? = null
    // D42.30 : fenêtre verrouillage 3A — le job du compte à rebours reste
    // ACTIF pendant lockThreeA : un 2e tap y annule le lancement (sinon la
    // fenêtre montrait « PRÊT » et un re-tap provoquait un DOUBLE
    // enregistrement, la 1re référence Recording étant écrasée).
    private var verrouillageEnCours = false
    // D42.30 : confirmation transitoire après Finalize réussi.
    private var priseValideeMsg by mutableStateOf<Int?>(null)
    private var guides: List<SceneGuide> = emptyList()
    private var prises by mutableStateOf<List<PriseGuide>>(emptyList())
    private var priseIdx by mutableStateOf(0)
    private var guideMode by mutableStateOf(false)
    private var guideSummary: GabaritSummary? = null
    // Audit D40 (B11) : E6 guide = n fichiers (2 a 4 prises, D23), plus un seul.
    // Audit D41 (F55) : slots ALIGNES sur l'index de prise ("" = prise sautee) —
    // avant, un saut compactait la liste et DECALAIT tout le montage sur les
    // mauvais rushs (rid absolu cote beat sheet vs index compacte cote fichiers).
    private val priseFiles = mutableListOf<String>()
    private var lastRecordedForIdx = -1
    private var guideFlowActive = false
    private var priseEnCoursDeFinalisation = false
    private var boundCamera: androidx.camera.core.Camera? = null
    // D42.27 (5.4) : lentille active — arrière par défaut (comportement
    // historique inchangé), avant après « Changer de caméra ».
    private var lensFront = false
    private var boundBinder: InsCameraBinder? = null
    private var boundProvider: ProcessCameraProvider? = null
    // D42.16 (A3) : cache des libellés déjà appliqués — voir updateStatus().
    private var dernierTexteGuide = 0
    private var dernierTexteBouton = 0
    private val handler = Handler(Looper.getMainLooper())
    private var sceneStartMs = 0L
    private val ticker: Runnable = object : Runnable {
        override fun run() {
            val scene = guides.getOrNull(overlayIdx) ?: return
            val elapsed = (System.currentTimeMillis() - sceneStartMs) / 1000.0
            overlayProgress = (elapsed / scene.durationS).coerceIn(0.0, 1.0).toFloat()
            if (elapsed >= scene.durationS && overlayIdx < guides.size - 1) {
                overlayIdx += 1
                sceneStartMs = System.currentTimeMillis()
                overlayProgress = 0f
            }
            handler.postDelayed(this, TICK_MS)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_camera_guide)
        executor = Executors.newSingleThreadExecutor()
        restaurerBrouillon()
        val gabaritId = intent.getStringExtra("gabarit_id")
        if (gabaritId != null) chargerGabarit(gabaritId) else masquerBoutonsGabarit()
        guides = buildSceneGuides(
            intent.getStringExtra("script").orEmpty(),
            intent.getIntExtra("duration_s", 30),
        )
        installerOverlayCompose()
        observerFluxCamera()
        brancherCommandes()
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            bindCamera()
        } else {
            requestPermissions(arrayOf(Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO), 1)
        }
    }

    /** D42.27 (§7) : reprise de tournage — slots restaurés du brouillon (uniquement
     *  les fichiers ENCORE EXISTANTS : un chemin disparu ne bloque jamais). */
    private fun restaurerBrouillon() {
        intent.getStringArrayExtra("restore_prise_files")?.forEach { chemin ->
            if (chemin.isNotBlank() && File(chemin).exists()) priseFiles.add(chemin)
        }
        val restoreIdx = intent.getIntExtra("restore_prise_idx", -1)
        if (restoreIdx in 0..99) priseIdx = restoreIdx
    }

    /** Charge prises + résumé du gabarit ; D42.30 : Refaire/Suivant n'existent
     *  QUE pour un gabarit à prises (commandes uniques, jamais en générique). */
    private fun chargerGabarit(gabaritId: String) {
        guideMode = true
        val repo = GabaritRepository(this, VitrineLocalDatabase.get(this).gabarits())
        lifecycleScope.launch {
            val raw = runCatching { repo.rawJson(gabaritId) }.getOrNull()
            if (raw != null) {
                // D42.32 (Lot 4) : consignes de prises en EN si langue choisie —
                // fin du mélange « Film your take » + consignes FR.
                val t = video.vitrine.data.i18n.GabaritUiL10n.traductions(
                    this@CameraGuideActivity,
                    video.vitrine.core.designsystem.VitrineLocale.saved(this@CameraGuideActivity),
                    gabaritId
                )
                prises = runCatching { GabaritJson.parsePrises(raw, t) }.getOrDefault(emptyList())
                guideSummary = runCatching { GabaritJson.parse(raw, t) }.getOrNull()
                majVisibiliteBoutonsGabarit()
            }
        }
    }

    private fun masquerBoutonsGabarit() {
        findViewById<Button>(R.id.camera_redo_button).visibility = android.view.View.GONE
        findViewById<Button>(R.id.camera_next_button).visibility = android.view.View.GONE
    }

    private fun majVisibiliteBoutonsGabarit() {
        findViewById<Button>(R.id.camera_redo_button).visibility =
            if (prises.isNotEmpty()) android.view.View.VISIBLE else android.view.View.GONE
        findViewById<Button>(R.id.camera_next_button).visibility =
            if (prises.isNotEmpty()) android.view.View.VISIBLE else android.view.View.GONE
    }

    /** HUD Compose informatif (D42.30 : plus AUCUNE commande dupliquée). */
    private fun installerOverlayCompose() {
        findViewById<ComposeView>(R.id.camera_overlay).setContent {
            VitrineTheme {
                if (guideMode && prises.isNotEmpty()) {
                    PriseGuideScreen(
                        prises = prises,
                        priseIdx = priseIdx,
                        sectorLabel = guideSummary?.secteurLibelle.orEmpty(),
                        formatLabel = guideSummary?.nomFormatAffiche.orEmpty(),
                        streaming = fluxStreamState,
                        recording = overlayRecording,
                        countdown = compteARebours,
                        priseValidee = priseValideeMsg,
                        faceCount = overlayFaces,
                        gateAllowed = gateAllowed,
                    )
                } else {
                    GuidedShootingOverlay(
                        scenes = guides,
                        currentIdx = overlayIdx,
                        progress = overlayProgress,
                        faceCount = overlayFaces,
                        gateAllowed = gateAllowed,
                        recording = overlayRecording,
                        countdown = compteARebours,
                        streaming = fluxStreamState,
                    )
                }
            }
        }
    }

    /** D42.30 : état RÉEL du flux caméra observé UNE fois — STREAMING prouvé
     *  (jamais plus de cadre noir présenté comme prévisualisation). */
    private fun observerFluxCamera() {
        val previewView = findViewById<PreviewView>(R.id.camera_preview)
        previewView.previewStreamState.observe(this) { etat ->
            val streamingNow = etat == PreviewView.StreamState.STREAMING
            if (fluxStreamState != streamingNow) {
                fluxStreamState = streamingNow
                Log.i(
                    TAG_E2E,
                    if (streamingNow) {
                        "PREVIEW STREAMING : le flux caméra est actif (frames réelles)"
                    } else {
                        "PREVIEW IDLE : flux caméra non encore actif"
                    }
                )
            }
        }
    }

    /** Commandes UNIQUES (barre XML) — Refaire/Suivant neutralisés pendant
     *  une prise ; bascule avant/arrière jamais à chaud. */
    private fun brancherCommandes() {
        findViewById<Button>(R.id.camera_record_button).setOnClickListener { onRecord() }
        findViewById<Button>(R.id.camera_redo_button).setOnClickListener {
            if (recording == null) redoCurrentPrise()
        }
        findViewById<Button>(R.id.camera_next_button).setOnClickListener {
            if (recording == null) skipPrise()
        }
        findViewById<Button>(R.id.camera_flip_button).setOnClickListener {
            if (recording == null) {
                lensFront = !lensFront
                Log.i(TAG_E2E, "bascule caméra : " + if (lensFront) "AVANT" else "ARRIÈRE")
                bindCamera()
            }
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, results: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, results)
        // Audit D40 (B11) : decision par permission nommee, plus par results[0]
        // (RECORD_AUDIO refuse = video muette, mais parcours jamais bloque).
        val cameraIndex = permissions.indexOf(Manifest.permission.CAMERA)
        if (cameraIndex >= 0 && results.getOrNull(cameraIndex) == PackageManager.PERMISSION_GRANTED) {
            bindCamera()
        }
    }

    private fun bindCamera() {
        val profiler = DeviceProfiler(this)
        val spec = CaptureSpec.forClass(DeviceProfiler.provisionalClass(profiler.profile()))
        val binder = InsCameraBinder(this)
        val cases = binder.buildUseCases(spec)
        useCases = cases
        boundBinder = binder
        // D42.30 — CORRECTION P0 (retour terrain RC14 : écran noir malgré
        // permission accordée) : le Preview était binder à CameraX SANS jamais
        // recevoir de surface — le PreviewView restait noir. Branchement
        // officiel CameraX (developer.android.com/media/camera/camerax/preview)
        // AVANT le bind : le flux démarre dès que la session est active.
        val previewView = findViewById<PreviewView>(R.id.camera_preview)
        cases.preview.setSurfaceProvider(previewView.surfaceProvider)
        Log.i(TAG_E2E, "setSurfaceProvider appliqué : le PreviewView recevra le flux")
        val future = ProcessCameraProvider.getInstance(this)
        future.addListener({
            // D42.27 (5.8) : caméra occupée/indisponible → message clair,
            // JAMAIS de crash (le bind non gardé était la limite documentée).
            runCatching {
                val provider = future.get()
                boundProvider = provider
                // Audit D40 (B1) : UN SEUL bindToLifecycle — CameraX remplace toutes
                // les liaisons du meme owner ; le second bind (analysis) tuait le
                // recorder (preview noire, enregistrement impossible).
                val analysis = ImageAnalysis.Builder()
                    .setTargetResolution(android.util.Size(160, 120))
                    .build()
                analysis.setAnalyzer(executor, MlKitFaceCounter { count -> onFaces(count) })
                boundCamera = binder.bind(
                    provider, this, cases, analysis,
                    if (lensFront) CameraSelector.DEFAULT_FRONT_CAMERA
                    else CameraSelector.DEFAULT_BACK_CAMERA
                )
                Log.i(
                    TAG_E2E,
                    "caméra liée (" + (if (lensFront) "AVANT" else "ARRIÈRE") +
                        ") : preview + videoCapture + analysis attachés"
                )
            }.onFailure { erreur ->
                Log.e(TAG_E2E, "échec du bind caméra : ${erreur.message}")
                runOnUiThread {
                    // Message EN DERNIER (updateStatus écraserait) — cf. F53.
                    updateStatus()
                    dernierTexteGuide = 0
                    findViewById<TextView>(R.id.camera_guide_text)
                        .setText(R.string.camera_bind_failed)
                }
            }
        }, ContextCompat.getMainExecutor(this))
    }

    private fun onFaces(count: Int) {
        decision = ConsentGate.decide(
            faceCount = count,
            adultConsentRecorded = consentGiven,
            minorConsentRecorded = minorConsent,
            minorSuspected = false
        )
        Log.i(TAG_E2E, "visages détectés : $count -> decision=$decision")
        runOnUiThread {
            overlayFaces = count
            gateAllowed = decision == ConsentGate.Decision.ALLOW
            updateStatus()
        }
    }

    private fun updateStatus() {
        val lancement = compteARebours != null || verrouillageEnCours
        val guideRes = when {
            lancement -> R.string.camera_countdown_status
            recording != null -> R.string.camera_recording
            decision != ConsentGate.Decision.ALLOW -> R.string.camera_blocked
            else -> R.string.camera_guide
        }
        val boutonRes = when {
            lancement -> R.string.camera_countdown_cancel
            recording != null -> R.string.camera_stop
            else -> R.string.camera_record
        }
        // D42.16 (défaut A3) : setText sur un texte IDENTIQUE invalide quand
        // même le layout. À 30 appels/s (comptage visage par frame avant le
        // dédoublonnage), la thread UI saturait. On ne touche la vue QUE si le
        // libellé change réellement.
        if (guideRes != dernierTexteGuide) {
            dernierTexteGuide = guideRes
            findViewById<TextView>(R.id.camera_guide_text).setText(guideRes)
        }
        if (boutonRes != dernierTexteBouton) {
            dernierTexteBouton = boutonRes
            findViewById<Button>(R.id.camera_record_button).setText(boutonRes)
        }
    }

    private fun onRecord() {
        Log.i(
            TAG_E2E,
            "onRecord finalisation=$priseEnCoursDeFinalisation enregistrement=${recording != null} decision=$decision",
        )
        if (priseEnCoursDeFinalisation) return          // D41 : attente du fichier finalise
        // D42.30 : second tap pendant le décompte = ANNULATION (aucun
        // enregistrement démarré) — le recorder ne démarre JAMAIS avant la fin.
        if (compteAReboursJob?.isActive == true) {
            compteAReboursJob?.cancel()
            compteAReboursJob = null
            compteARebours = null
            verrouillageEnCours = false
            Log.i(TAG_E2E, "lancement ANNULÉ par l'utilisateur (décompte ou verrouillage 3A)")
            updateStatus()
            return
        }
        if (recording != null) {
            stopRecording()
            return
        }
        // D41 (F52) : permission camera absente = bouton EXPLIQUE (avant : return
        // silencieux de startRecording, bouton mort sans aucun message).
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            Log.i(TAG_E2E, "onRecord -> dialogue permission camera")
            showPermissionDialog()
            return
        }
        if (decision != ConsentGate.Decision.ALLOW) {
            Log.i(TAG_E2E, "onRecord -> porte R4 : consentement requis avant enregistrement")
            AlertDialog.Builder(this)
                .setTitle(R.string.camera_consent_title)
                .setMessage(R.string.camera_consent_body)
                .setPositiveButton(R.string.camera_consent_ok) { _, _ ->
                    consentGiven = true
                    minorConsent = true
                    envoyerConsentementsServeur(1)
                    onFaces(1)
                    lancerCompteARebours()
                }
                .setNegativeButton(R.string.camera_consent_ko) { dialog, _ -> dialog.dismiss() }
                .show()
            return
        }
        lancerCompteARebours()
    }

    /**
     * D42.30 — compte à rebours 3-2-1 VÉRITABLE : 3 numéros affichés (1 s
     * chacun) PUIS lancement du recorder (verrou 3A puis enregistrement).
     * Avant : l'enregistrement démarrait immédiatement au tap et l'écran
     * affichait un cercle « 3 » statique décoratif (simulation constatée sur
     * téléphone réel). Annulable par un second tap (onRecord).
     */
    private fun lancerCompteARebours() {
        compteAReboursJob = lifecycleScope.launch {
            for (numero in 3 downTo 1) {
                compteARebours = numero
                Log.i(TAG_E2E, "compte à rebours : $numero")
                updateStatus()
                delay(1000)
            }
            compteARebours = null
            // D42.30 : le job reste ACTIF pendant le verrouillage 3A — le
            // 2e tap annule aussi dans CETTE fenêtre (bouton « Annuler le
            // décompte ») : VideoCapture.start() n'est atteint QUE si le job
            // va au bout. Plus JAMAIS de double enregistrement.
            verrouillageEnCours = true
            updateStatus()
            launchLockedRecording()
            verrouillageEnCours = false
            startRecording()
        }
    }

    /**
     * Verrou 3A (AE/AWB ponderes centre) applique juste avant la prise.
     * D42.30 : SUSPEND, appelé DANS le job du compte à rebours (plus de
     * launch interne fire-and-forget) pour que l'annulation couvre cette
     * fenêtre. runCatching avale la CancellationException — on la RELANCE
     * toujours, sinon un tap d'annulation pendant le verrouillage
     * laisserait startRecording() s'exécuter : défaut interdit.
     */
    private suspend fun launchLockedRecording() {
        runCatching {
            val binder = boundBinder
            val camera = boundCamera
            val provider = boundProvider
            if (binder != null && camera != null && provider != null) {
                binder.lockThreeA(provider, camera)
                Log.i(TAG_E2E, "verrou 3A appliqué")
            } else {
                Log.i(
                    TAG_E2E,
                    "verrou 3A sauté : caméra non liée " +
                        "(binder=${binder != null} camera=${camera != null} " +
                        "provider=${provider != null})",
                )
            }
        }.onFailure {
            if (it is kotlinx.coroutines.CancellationException) throw it
        }
    }

    private fun startRecording() {
        verrouillageEnCours = false
        val cases = useCases ?: run { showPermissionDialog(); return }
        // D42.27 (§8/5.7) : contrôle PRÉVENTIF d'espace disque — refus PROPRE
        // AVANT de faire jouer la scène à l'utilisateur (le Finalize F53 reste
        // la seconde ligne si le disque se remplit PENDANT la prise). Ce garde
        // ne supprime JAMAIS de fichier utilisateur.
        val disponible = android.os.StatFs(filesDir.absolutePath).availableBytes
        if (!StorageGate.espaceSuffisant(disponible)) {
            Log.w(
                TAG_E2E,
                "prise refusée : stockage insuffisant ($disponible o < ${StorageGate.SEUIL_PRISE_OCTETS} o)"
            )
            dernierTexteGuide = 0
            findViewById<TextView>(R.id.camera_guide_text)
                .setText(R.string.camera_storage_low)
            return
        }
        // Flux guide = le gabarit declare des prises (slots alignes, D41 F55).
        guideFlowActive = prises.isNotEmpty()
        // D41 (F50) : rushs dans filesDir (persistant) — cacheDir peut etre purge
        // par le systeme entre la prise et l'export (WorkManager differe).
        val dir = File(filesDir, "rushes").apply { mkdirs() }
        val file = File(dir, "rush-${System.currentTimeMillis()}.mp4")
        outputFile = file
        val options = FileOutputOptions.Builder(file).build()
        val pending = cases.recorder.prepareRecording(this, options)
        Log.i(TAG_E2E, "startRecording : start() sur ${file.name}")
        // D42.30 : un échec de start() (SecurityException si permission
        // révoquée entre-temps, recorder invalide…) ne doit laisser NI fichier
        // vide NI état incohérent — sortie propre, prise rejouable.
        recording = try {
            pending.start(ContextCompat.getMainExecutor(this)) { event -> onVideoEvent(event, file) }
        } catch (t: Throwable) {
            runCatching { file.delete() }
            Log.e(TAG_E2E, "startRecording : ÉCHEC démarrage (${t.javaClass.simpleName}: ${t.message})")
            updateStatus()
            dernierTexteGuide = 0
            findViewById<TextView>(R.id.camera_guide_text).setText(R.string.camera_take_failed)
            return
        }
        Log.i(TAG_E2E, "startRecording : ENREGISTREMENT ACTIF -> ${file.absolutePath}")
        overlayRecording = true
        // D42.30 : en tournage guidé, le HUD de PRISE reste affiché pendant
        // l'enregistrement (badge REC) — FINI le basculement vers l'overlay
        // générique à 30 scènes artificielles qui faisait « simulation ».
        // L'horloge de scènes ne vit QUE dans le mode générique (sans gabarit).
        overlayIdx = 0
        overlayProgress = 0f
        sceneStartMs = System.currentTimeMillis()
        if (!guideFlowActive) handler.postDelayed(ticker, TICK_MS)
        updateStatus()
    }

    /**
     * D41 (F53) : la prise n'est validee qu'au FINALIZE reussi du recorder —
     * avant, stopRecording ajoutait le fichier immediatement (potentiellement
     * incomplet/corrompu) et l'echec d'enregistrement etait totalement muet.
     */
    private fun onVideoEvent(event: androidx.camera.video.VideoRecordEvent, file: File) {
        if (event !is androidx.camera.video.VideoRecordEvent.Finalize) return
        Log.i(TAG_E2E, "Finalize : hasError=${event.hasError()} taille=${file.length()} octets -> ${file.name}")
        runOnUiThread {
            if (!event.hasError()) {
                onPriseFinalisee(file)
            } else {
                runCatching { file.delete() }
                priseEnCoursDeFinalisation = false
                // Message d'echec EN DERNIER (updateStatus() ecraserait le texte
                // du guide) : la prise echouee est supprimee, l'utilisateur reste
                // sur la meme prise et peut la refaire (aucun fichier corrompu
                // n'atteint le montage).
                updateStatus()
                findViewById<TextView>(R.id.camera_guide_text).setText(R.string.camera_take_failed)
                // D42.16 (A3) : le setText direct invalide le cache de libellés.
                dernierTexteGuide = 0
            }
        }
    }

    private fun onPriseFinalisee(file: File) {
        priseEnCoursDeFinalisation = false
        if (guideFlowActive) {
            // Audit D40 (B11/A5) + D41 (F55) : chaque prise guidee devient un rush
            // distinct, stocke dans un slot ALIGNE sur son index ("" = sautee).
            setSlot(priseIdx, file.absolutePath)
            lastRecordedForIdx = priseIdx
            // D42.30 : preuve VISIBLE que la scène vient d'être réellement
            // enregistrée (Finalize réussi) — confirmation transitoire à l'écran.
            priseValideeMsg = priseIdx + 1
            handler.postDelayed({ priseValideeMsg = null }, 2500)
            // D42.27 (§7) : persistance du brouillon à CHAQUE prise validée —
            // une fermeture de l'app (ou un redémarrage du téléphone) juste
            // après une scène ne perd NI la prise, NI la position.
            val gabId = intent.getStringExtra("gabarit_id").orEmpty()
            val fichiers = priseFiles.toList()
            val position = if (priseIdx < prises.size - 1) priseIdx + 1 else priseIdx
            lifecycleScope.launch(kotlinx.coroutines.Dispatchers.IO) {
                runCatching {
                    video.vitrine.data.local.DraftStore.majPrises(
                        this@CameraGuideActivity, gabId, fichiers, position
                    )
                }
            }
            if (priseIdx < prises.size - 1) {
                priseIdx += 1
                guideMode = true
                updateStatus()
                return
            }
            finishWithPrises()
            return
        }
        setResult(RESULT_OK, Intent().putExtra("input", file.absolutePath))
        finish()
    }

    private fun setSlot(index: Int, value: String) {
        while (priseFiles.size <= index) priseFiles.add("")
        priseFiles[index] = value
    }

    private fun stopRecording() {
        recording?.stop()
        recording = null
        handler.removeCallbacks(ticker)
        overlayRecording = false
        priseEnCoursDeFinalisation = true     // verdict au Finalize (F53)
        updateStatus()
    }

    private fun finishWithPrises() {
        while (priseFiles.size < prises.size) priseFiles.add("")
        val files = priseFiles.toTypedArray()
        val premierReel = priseFiles.firstOrNull { it.isNotBlank() }
        if (premierReel == null) {
            setResult(RESULT_CANCELED)
            finish()
            return
        }
        setResult(
            RESULT_OK,
            Intent()
                .putExtra("input", premierReel)
                .putExtra("client_rushes", files),
        )
        finish()
    }

    /** « Refaire » (D19 : aucun bouton mort) : vide le slot de la prise courante. */
    private fun redoCurrentPrise() {
        if (lastRecordedForIdx == priseIdx && priseFiles.getOrNull(priseIdx)?.isNotBlank() == true) {
            runCatching { File(priseFiles[priseIdx]).delete() }
            priseFiles[priseIdx] = ""
            lastRecordedForIdx = -1
        }
    }

    /** « Suivant » sans enregistrer = passer cette prise (slot vide tolere).
     *  D41 (F49) : derniere prise passee SANS aucune prise reelle = retour honnete
     *  au navigateur (RESULT_CANCELED), plus d'ecran muet sans issue. */
    private fun skipPrise() {
        if (priseIdx < prises.size - 1) {
            priseIdx += 1
        } else if (priseFiles.any { it.isNotBlank() }) {
            finishWithPrises()
        } else {
            setResult(RESULT_CANCELED)
            finish()
        }
    }

    /**
     * D41 (F56) : les consentements R4 (visage filme + mineur potentiel) sont
     * desormais ENREGISTRES SERVEUR (POST /api/v1/consents, batch idempotent)
     * et plus seulement en variables d'activite perdues a la fermeture.
     * Best-effort : l'echec reseau ne bloque jamais la prise (la porte locale
     * ConsentGate reste l'autorite du recorder).
     */
    private fun envoyerConsentementsServeur(faces: Int) {
        val token = getSharedPreferences("vv_session", MODE_PRIVATE)
            .getString("token", null) ?: return
        lifecycleScope.launch(kotlinx.coroutines.Dispatchers.IO) {
            runCatching {
                video.vitrine.data.api.BackendSync.sendConsents(
                    this@CameraGuideActivity,
                    BuildConfig.API_BASE_URL,
                    token,
                    listOf(
                        video.vitrine.data.api.BackendSync.ConsentRecord("camera_visage_r4", faces),
                        video.vitrine.data.api.BackendSync.ConsentRecord("camera_mineur_r4", faces)
                    )
                )
            }
        }
    }

    /** D41 (F52) : permission manquante — explication + re-demande ou reglages. */
    private fun showPermissionDialog() {
        AlertDialog.Builder(this)
            .setTitle(R.string.camera_permission_needed)
            .setMessage(R.string.camera_permission_body)
            .setPositiveButton(R.string.camera_permission_grant) { _, _ ->
                if (shouldShowRequestPermissionRationale(Manifest.permission.CAMERA)) {
                    requestPermissions(arrayOf(Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO), 1)
                } else {
                    runCatching {
                        startActivity(
                            Intent(
                                android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                                android.net.Uri.fromParts("package", packageName, null)
                            )
                        )
                    }
                }
            }
            .setNegativeButton(R.string.camera_permission_later) { dialog, _ -> dialog.dismiss() }
            .show()
    }

    override fun onDestroy() {
        recording?.stop()
        handler.removeCallbacks(ticker)
        executor.shutdown()
        super.onDestroy()
    }

    private companion object {
        const val TICK_MS = 100L
        const val TAG_E2E = "VV_E2E"
    }
}
