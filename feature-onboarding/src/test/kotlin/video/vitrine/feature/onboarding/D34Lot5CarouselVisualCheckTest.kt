package video.vitrine.feature.onboarding

import android.content.Context
import android.graphics.Bitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.test.SemanticsNodeInteraction
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onRoot
import androidx.test.core.app.ApplicationProvider
import java.io.File
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.core.designsystem.MarqueVitrine
import video.vitrine.core.designsystem.VitrineTheme

/**
 * D42.34 Lot 5 — carrousel 3 métiers (CR-5) : images remplacées par les
 * ressources Drive D (photo-merchant / secteur_food / secteur_mode),
 * TEXTES INCHANGÉS ; marque officielle (mark.png Drive D) dans la tuile.
 * Le splash système n'est pas rendable par Robolectric (thème API 31+) —
 * couvert par la vérification d'asset (dimensions/officialité mesurées
 * hors test, consignées dans 07_DESIGN_VISUEL.md).
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class D34Lot5CarouselVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    // ---- D34-11 : slide 1 avec la marchande (photo-merchant), textes inchangés ----
    @Test
    fun carrousel_slide1_texts_inchanges_et_image_chargee() {
        compose.setContent {
            VitrineTheme {
                CarouselScreen(onDone = { })
            }
        }
        // Textes fondateur inchangés (aucun nouveau texte marketing).
        compose.onNodeWithText(ctx().getString(R.string.slide1_slogan))
            .assertIsDisplayed()
        compose.onNodeWithText(ctx().getString(R.string.slide1_sub))
            .assertIsDisplayed()
        compose.onRoot().save("D34-11_carrousel-slide1-marchande_APRES.png")
    }

    // ---- D34-12 : marque officielle dans la tuile blanche ----
    @Test
    fun marque_officielle_dans_tuile() {
        compose.setContent {
            VitrineTheme {
                MarqueVitrine()
            }
        }
        compose.onRoot().save("D34-12_marque-officielle_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
