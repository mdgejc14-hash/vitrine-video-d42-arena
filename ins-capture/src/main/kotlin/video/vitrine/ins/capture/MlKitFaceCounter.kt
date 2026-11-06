package video.vitrine.ins.capture

import androidx.annotation.OptIn
import androidx.camera.core.ExperimentalGetImage
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.face.FaceDetection
import com.google.mlkit.vision.face.FaceDetectorOptions

/**
 * Comptage de visages ML Kit, 100 % LOCAL (aucun upload ; privacy 7.3).
 * Branche sur ImageAnalysis basse resolution (160x120 suffisent, R&D effet 3).
 */
class MlKitFaceCounter(private val onFaces: (Int) -> Unit) : ImageAnalysis.Analyzer {

    private val detector = FaceDetection.getClient(
        FaceDetectorOptions.Builder()
            .setPerformanceMode(FaceDetectorOptions.PERFORMANCE_MODE_FAST)
            .setClassificationMode(FaceDetectorOptions.CLASSIFICATION_MODE_NONE)
            .build()
    )

    // D42.16 (défaut A3, runs 42278038365 et 42281822052) : onFaces était
    // appelé À CHAQUE frame (~30/s) ; chaque appel déclenchait runOnUiThread +
    // updateStatus() (findViewById + setText) — une relayout par frame qui
    // saturait la thread UI au point que les dumps uiautomator ne se terminaient
    // PLUS (le harnais E2E relisait alors un écran périmé et restait aveugle).
    // Le comptage n'est publié QUE s'il change : même sémantique pour la porte
    // R4, sans tempête de layout.
    @Volatile
    private var dernierCompte = -1

    @OptIn(ExperimentalGetImage::class)
    override fun analyze(imageProxy: ImageProxy) {
        val mediaImage = imageProxy.image
        if (mediaImage == null) {
            imageProxy.close()
            return
        }
        val input = InputImage.fromMediaImage(mediaImage, imageProxy.imageInfo.rotationDegrees)
        detector.process(input)
            .addOnSuccessListener { faces ->
                if (faces.size != dernierCompte) {
                    dernierCompte = faces.size
                    onFaces(faces.size)
                }
            }
            .addOnCompleteListener { imageProxy.close() }
    }
}
