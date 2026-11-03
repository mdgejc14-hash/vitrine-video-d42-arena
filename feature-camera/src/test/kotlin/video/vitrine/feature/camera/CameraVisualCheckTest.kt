package video.vitrine.feature.camera

import android.graphics.Bitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.test.SemanticsNodeInteraction
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onRoot
import java.io.File
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.core.designsystem.VitrineTheme

/**
 * Harnais CI-Visual-Check : tournage guide INS pour 3 gabarits distincts
 * (mode, coiffure, restauration) : instructions francaises, cadre 9:16 +
 * silhouette, compteur de scenes, jauge temporelle, badge visages / porte R4.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class CameraVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun shoot(name: String, script: String, idx: Int, progress: Float, faces: Int, recording: Boolean) {
        compose.setContent {
            VitrineTheme {
                GuidedShootingOverlay(
                    scenes = buildSceneGuides(script, 30),
                    currentIdx = idx,
                    progress = progress,
                    faceCount = faces,
                    gateAllowed = true,
                    recording = recording,
                )
            }
        }
        compose.onRoot().save(name)
    }

    @Test
    fun tournage_guide_mode() {
        shoot(
            "05-camera-mode.png",
            "Nouvel arrivage chez Awa Boutique : 3 robes coupees main a moins de 15 000 francs",
            0, 0.35f, 0, true,
        )
    }

    @Test
    fun tournage_guide_coiffure() {
        shoot(
            "06-camera-coiffure.png",
            "Transformation complete au Salon Nokoue : tresses posees en 45 minutes, resultat brillant",
            1, 0.6f, 1, true,
        )
    }

    @Test
    fun tournage_guide_restauration() {
        shoot(
            "07-camera-restauration.png",
            "Chez Mama Resto : le poisson braise du jour, sauce tomate fraiche, servi en 10 minutes",
            2, 0.2f, 0, false,
        )
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
