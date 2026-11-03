package video.vitrine.feature.catalog

import android.graphics.Bitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.test.SemanticsNodeInteraction
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.assertCountEquals
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onRoot
import java.io.File
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.core.designsystem.VitrineTheme
import video.vitrine.core.model.CatalogManifest
import video.vitrine.core.model.Sector
import video.vitrine.core.model.Skin

/**
 * Harnais CI-Visual-Check : ecran catalogue REEL, pre-filtre par le secteur
 * choisi a l'onboarding (continuite du parcours) : seuls les gabarits du
 * secteur s'affichent, sous-titre adapte, zero etiquette hors-sujet.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class CatalogVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private val manifest = CatalogManifest(
        version = "1.0.0",
        minAppVersion = "1.0.0",
        skins = listOf(
            Skin("F001", "F001_mode_01", Sector.MODE, "", "1"),
            Skin("F002", "F002_coiffure_02", Sector.COIFFURE, "", "1"),
            Skin("F003", "F003_restauration_03", Sector.RESTAURATION, "", "1"),
            Skin("F004", "F004_commerce_04", Sector.COMMERCE, "", "1"),
            Skin("F005", "F005_immo_auto_05", Sector.IMMO_AUTO, "", "1")
        )
    )

    @Test
    fun catalogue_filtre_secteur_mode() {
        compose.setContent {
            VitrineTheme { CatalogScreen(manifest, offline = false, initialSector = Sector.MODE) }
        }
        compose.onRoot().save("04-catalogue-filtre-mode.png")
        // Preuve semantique du filtrage : le gabarit du secteur choisi existe,
        // ceux des autres secteurs sont absents (zero etiquette hors-sujet).
        compose.onAllNodesWithText("Nouvel Arrivage & Nouveautés").assertCountEquals(1)
        compose.onAllNodesWithText("Avant / Après Transformation").assertCountEquals(0)
        compose.onAllNodesWithText("Témoignage & Avis Client").assertCountEquals(0)
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
