package video.vitrine.feature.brief

import android.content.Context
import android.graphics.Bitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.test.SemanticsNodeInteraction
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onRoot
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performScrollTo
import androidx.test.core.app.ApplicationProvider
import java.io.File
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.core.designsystem.VitrineTheme
import video.vitrine.core.model.GabaritBrief
import video.vitrine.core.model.PriseGuide
import video.vitrine.data.gabarits.GabaritJson

/**
 * D42.34 Lot 2 — non-régression de l'import de rushs dans le parcours
 * gabarit (CR-2, P0 ④). Données RÉELLES des JSON embarqués :
 * T5 témoignage client (section import affichée, 2 prises réelles) et
 * T1 nouvel arrivage (section ABSENTE — import non proposé partout).
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class D34Lot2BriefImportVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    private fun raw(fichier: String): String =
        ctx().assets.open("gabarits/$fichier").use { it.readBytes().decodeToString() }

    /** Vrai brief T5 témoignage (secteur Mode, « Un client raconte »). */
    private fun briefT5(): GabaritBrief = GabaritJson.parseBrief(raw("vetements_mode/T5.json"))

    /** Vraies prises du T5 (« Le client qui parle », « Le vêtement porté »). */
    private fun prisesT5(): List<PriseGuide> = GabaritJson.parsePrises(raw("vetements_mode/T5.json"))

    // ---- D34-04 : T5 témoignage = section import avec les 2 prises réelles ----
    @Test
    fun t5_section_import_affichee_avec_prises_reelles() {
        val prises = prisesT5()
        check(prises.size == 2) { "attendu 2 prises T5, trouvé ${prises.size}" }
        compose.setContent {
            VitrineTheme {
                GabaritBriefScreen(
                    brief = briefT5(),
                    prisesPourImport = prises,
                    rushSlots = listOf("", ""),
                    onImportRush = { },
                    onClearRush = { },
                    onSubmit = { },
                )
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.brief_import_titre))
            .performScrollTo()
            .assertIsDisplayed()
        // Les libellés RÉELS des prises du JSON, alignés par slot.
        compose.onNodeWithText(
            ctx().getString(R.string.brief_import_prise, 1, prises[0].label)
        ).performScrollTo().assertIsDisplayed()
        compose.onNodeWithText(
            ctx().getString(R.string.brief_import_prise, 2, prises[1].label)
        ).performScrollTo().assertIsDisplayed()
        compose.onRoot().save("D34-04_brief-t5-import_APRES.png")
    }

    // ---- D34-05 : slot rempli → média affiché + Retirer ; vide → Ajouter ----
    @Test
    fun t5_slot_rempli_bouton_retirer() {
        val prises = prisesT5()
        compose.setContent {
            VitrineTheme {
                GabaritBriefScreen(
                    brief = briefT5(),
                    prisesPourImport = prises,
                    rushSlots = listOf("content://media/external/video/42", ""),
                    onImportRush = { },
                    onClearRush = { },
                    onSubmit = { },
                )
            }
        }
        compose.onNodeWithText(
            ctx().getString(R.string.brief_import_prise, 1, prises[0].label)
        ).performScrollTo().assertIsDisplayed()
        compose.onNodeWithText(ctx().getString(R.string.brief_import_retirer))
            .performScrollTo().assertIsDisplayed()
        compose.onRoot().save("D34-05_brief-t5-slot-rempli_APRES.png")
    }

    // ---- D34-06 : T1 (non témoignage) = AUCUNE section import ----
    @Test
    fun t1_aucune_section_import() {
        compose.setContent {
            VitrineTheme {
                GabaritBriefScreen(
                    brief = GabaritJson.parseBrief(raw("vetements_mode/T1.json")),
                    onSubmit = { },
                )
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.brief_import_titre))
            .assertDoesNotExist()
        compose.onNodeWithTag("brief_import_choisir").assertDoesNotExist()
        compose.onRoot().save("D34-06_brief-t1-sans-import_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
