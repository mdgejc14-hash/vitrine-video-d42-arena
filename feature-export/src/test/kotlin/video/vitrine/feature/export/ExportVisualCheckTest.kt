package video.vitrine.feature.export

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

/** Harnais CI-Visual-Check : preview export (typographie cinetique + recap). */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class ExportVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    @Test
    fun ecran_preview_export() {
        compose.setContent {
            VitrineTheme {
                ExportPreviewPanel(
                    script = "Nouvel arrivage chez Awa Boutique : 3 robes coupees main a moins de 15 000 francs",
                    durationS = 30,
                    clientRushCount = 4,
                    cameraRushCount = 5,
                )
            }
        }
        compose.onRoot().save("09-preview-export.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
