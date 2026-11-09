package video.vitrine.ins.capture

import android.content.Context
import androidx.camera.core.CameraSelector
import androidx.camera.core.FocusMeteringAction
import androidx.camera.core.Preview
import androidx.camera.core.SurfaceOrientedMeteringPointFactory
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.video.FallbackStrategy
import androidx.camera.video.Quality
import androidx.camera.video.QualitySelector
import androidx.camera.video.Recorder
import androidx.camera.video.VideoCapture
import java.util.concurrent.TimeUnit

/**
 * Capture INS (contrat 4.1, R&D ADVANCED 6.3) :
 * - 30 FPS deterministe via SessionConfig feature group (pas de VFR) ;
 * - bitrate eleve : Recorder.setTargetVideoEncodingBitRate (stable depuis 1.3.0-alpha03) ;
 * - stabilisation SEULEMENT si isStabilizationSupported (sinon erreur HAL, expo#32413) ;
 * - verrou AE/AWB pondere central avant chaque plan (anti-pompage) ;
 * - toujours binder un Preview (piege b/449913903).
 */
class InsCameraBinder(private val context: Context) {

    fun buildUseCases(spec: CaptureSpec): InsUseCases {
        val preview = Preview.Builder().build()

        // D42.14 (crash mesuré, run 42257226019) : sans strategie de repli,
        // bindToLifecycle levait IllegalArgumentException « Unable to find
        // selected quality » des que le capteur n'expose pas FHD/UHD — cas de
        // l'émulateur de CI mais AUSSI des téléphones d'entrée de gamme.
        // Repli CameraX canonique : FallbackStrategy.lowerQualityOrHigherThan.
        // (Première tentative avec « QualitySelector.fallbackStrategyOf » :
        // API inexistante, refusée par la compilation — run 42261788337.)
        val quality = if (spec.captureHeight >= 2160) Quality.UHD else Quality.FHD
        val recorder = Recorder.Builder()
            .setQualitySelector(
                QualitySelector.from(quality, FallbackStrategy.lowerQualityOrHigherThan(Quality.SD))
            )
            .setTargetVideoEncodingBitRate(spec.captureBitrateBps)
            .build()

        val videoCapture = VideoCapture.Builder(recorder).build()

        return InsUseCases(preview, videoCapture, recorder)
    }

    /**
     * Stabilisation conditionnelle : n'est activee QUE si le materiel la declare
     * supportee ; desactivable par gabarit (recadrage <= 20 % documente).
     */
    fun applyStabilizationIfSupported(
        videoCaptureBuilder: VideoCapture.Builder<Recorder>,
        capabilities: androidx.camera.video.VideoCapabilities
    ): VideoCapture.Builder<Recorder> =
        if (capabilities.isStabilizationSupported) {
            videoCaptureBuilder.setVideoStabilizationEnabled(true)
        } else {
            videoCaptureBuilder
        }

    /**
     * Binding UNIQUE (audit D40, B1) : CameraX remplace TOUTES les liaisons d'un
     * LifecycleOwner a chaque bindToLifecycle — le second appel (ImageAnalysis
     * seule, cote CameraGuideActivity) debindait preview + videoCapture :
     * preview noire et recorder mort. [analysis] est donc fusionne ici.
     *
     * D42.27 (exigence 5.4) : le sélecteur de lentille est PARAMÉTRABLE —
     * arrière par défaut (comportement inchangé), avant pour la bascule
     * « Changer de caméra ». Un re-bind complet (unbindAll ci-dessous) remplace
     * proprement la liaison précédente : aucun useCase orphelin.
     */
    fun bind(
        provider: ProcessCameraProvider,
        lifecycleOwner: androidx.lifecycle.LifecycleOwner,
        useCases: InsUseCases,
        analysis: androidx.camera.core.ImageAnalysis? = null,
        selector: CameraSelector = CameraSelector.DEFAULT_BACK_CAMERA
    ): androidx.camera.core.Camera {
        provider.unbindAll()
        val cases = mutableListOf<androidx.camera.core.UseCase>(useCases.preview, useCases.videoCapture)
        if (analysis != null) cases += analysis
        return provider.bindToLifecycle(
            lifecycleOwner,
            selector,
            *cases.toTypedArray()
        )
    }

    /**
     * Verrou 3A du plan : mesure ponderee centrale puis verrou AE/AWB apres convergence
     * (R&D ADVANCED 6.3e). A executer juste avant chaque prise.
     */
    suspend fun lockThreeA(provider: ProcessCameraProvider, camera: androidx.camera.core.Camera) {
        val factory = SurfaceOrientedMeteringPointFactory(1f, 1f)
        val point = factory.createPoint(CENTER_X, CENTER_Y)
        val action = FocusMeteringAction.Builder(point)
            .addPoint(point, FocusMeteringAction.FLAG_AE or FocusMeteringAction.FLAG_AWB)
            .setAutoCancelDuration(LOCK_SECONDS, TimeUnit.SECONDS)
            .build()
        camera.cameraControl.startFocusAndMetering(action)
    }

    data class InsUseCases(
        val preview: Preview,
        val videoCapture: VideoCapture<Recorder>,
        val recorder: Recorder
    )

    private companion object {
        const val CENTER_X = 0.5f
        const val CENTER_Y = 0.5f
        const val LOCK_SECONDS = 3L
    }
}
