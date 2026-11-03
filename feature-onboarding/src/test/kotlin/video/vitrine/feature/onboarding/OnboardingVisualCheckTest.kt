package video.vitrine.feature.onboarding

import android.graphics.Bitmap
import androidx.compose.material3.Surface
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
import video.vitrine.core.designsystem.VitrineLogoHeader
import video.vitrine.core.designsystem.VitrineTheme

/**
 * Harnais CI-Visual-Check : rendus PNG reels des ecrans d'entree, generes en CI
 * (Robolectric graphics NATIVE + Compose), sans build APK local.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class OnboardingVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    @Config(qualifiers = "w360dp-h820dp")
    @Test
    fun ecran_selection_langue() {
        compose.setContent { VitrineTheme { LanguageScreen { } } }
        compose.onRoot().save("01-selection-langue.png")
    }

    @Test
    fun carousel_onboarding_slogan() {
        compose.setContent { VitrineTheme { CarouselScreen { } } }
        compose.onRoot().save("02-carousel-slogan.png")
    }

    @Config(qualifiers = "w360dp-h820dp")
    @Test
    fun grille_secteurs_3d() {
        compose.setContent { VitrineTheme { OnboardingScreen { } } }
        compose.onRoot().save("03-secteurs-3d.png")
    }

    @Test
    fun header_logo_officiel() {
        compose.setContent { VitrineTheme { Surface { VitrineLogoHeader() } } }
        compose.onRoot().save("10-header-branding.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
