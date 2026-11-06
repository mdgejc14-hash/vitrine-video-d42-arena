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
import androidx.camera.video.FileOutputOptions
import androidx.camera.video.Recording
import androidx.core.content.ContextCompat
import java.io.File
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import video.vitrine.ins.capture.CaptureSpec
import video.vitrine.ins.capture.ConsentGate
import video.vitrine.ins.capture.DeviceProfiler
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
        val gabaritId = intent.getStringExtra("gabarit_id")
        if (gabaritId != null) {
            guideMode = true
            val repo = GabaritRepository(this, VitrineLocalDatabase.get(this).gabarits())
            lifecycleScope.launch {
                val raw = runCatching { repo.rawJson(gabaritId) }.getOrNull()
                if (raw != null) {
                    prises = runCatching { GabaritJson.parsePrises(raw) }.getOrDefault(emptyList())
                    guideSummary = runCatching { GabaritJson.parse(raw) }.getOrNull()
                }
            }
        }
        guides = buildSceneGuides(
            intent.getStringExtra("script").orEmpty(),
            intent.getIntExtra("duration_s", 30),
        )
        findViewById<ComposeView>(R.id.camera_overlay).setContent {
            VitrineTheme {
                if (guideMode && prises.isNotEmpty()) {
                    PriseGuideScreen(
                        prises = prises,
                        priseIdx = priseIdx,
                        sectorLabel = guideSummary?.secteurLibelle.orEmpty(),
                        formatLabel = guideSummary?.nomFormatAffiche.orEmpty(),
                        onRedo = { redoCurrentPrise() },
                        onRecord = { onRecord() },
                        onNext = { skipPrise() },
                    )
                } else {
                    GuidedShootingOverlay(
                        scenes = guides,
                        currentIdx = overlayIdx,
                        progress = overlayProgress,
                        faceCount = overlayFaces,
                        gateAllowed = gateAllowed,
                        recording = overlayRecording,
                    )
                }
            }
        }
        findViewById<Button>(R.id.camera_record_button).setOnClickListener { onRecord() }
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            bindCamera()
        } else {
            requestPermissions(arrayOf(Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO), 1)
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
        val future = ProcessCameraProvider.getInstance(this)
        future.addListener({
            val provider = future.get()
            boundProvider = provider
            // Audit D40 (B1) : UN SEUL bindToLifecycle — CameraX remplace toutes
            // les liaisons du meme owner ; le second bind (analysis) tuait le
            // recorder (preview noire, enregistrement impossible).
            val analysis = ImageAnalysis.Builder()
                .setTargetResolution(android.util.Size(160, 120))
                .build()
            analysis.setAnalyzer(executor, MlKitFaceCounter { count -> onFaces(count) })
            boundCamera = binder.bind(provider, this, cases, analysis)
            Log.i(TAG_E2E, "caméra liée : preview + videoCapture + analysis attachés")
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
        val guideRes = when {
            recording != null -> R.string.camera_recording
            decision != ConsentGate.Decision.ALLOW -> R.string.camera_blocked
            else -> R.string.camera_guide
        }
        val boutonRes = if (recording != null) R.string.camera_stop else R.string.camera_record
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
                    startRecording()
                }
                .setNegativeButton(R.string.camera_consent_ko) { dialog, _ -> dialog.dismiss() }
                .show()
            return
        }
        launchLockedRecording()
    }

    /** Verrou 3A (AE/AWB ponderes centre) applique juste avant la prise, puis record. */
    private fun launchLockedRecording() {
        lifecycleScope.launch {
            runCatching {
                val binder = boundBinder
                val camera = boundCamera
                val provider = boundProvider
                if (binder != null && camera != null && provider != null) {
                    binder.lockThreeA(provider, camera)
                    Log.i(TAG_E2E, "verrou 3A appliqué")
                } else {
                    Log.i(TAG_E2E, "verrou 3A sauté : caméra non liée (binder=${binder != null} camera=${camera != null} provider=${provider != null})")
                }
            }
            startRecording()
        }
    }

    private fun startRecording() {
        val cases = useCases ?: run { showPermissionDialog(); return }
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
        recording = pending.start(ContextCompat.getMainExecutor(this)) { event -> onVideoEvent(event, file) }
        Log.i(TAG_E2E, "startRecording : ENREGISTREMENT ACTIF -> ${file.absolutePath}")
        overlayRecording = true
        if (guideFlowActive) guideMode = false    // overlay generique = indicateur REC
        overlayIdx = 0
        overlayProgress = 0f
        sceneStartMs = System.currentTimeMillis()
        handler.postDelayed(ticker, TICK_MS)
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
