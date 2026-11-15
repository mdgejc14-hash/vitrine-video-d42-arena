package video.vitrine.feature.camera

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
import androidx.test.core.app.ApplicationProvider
import java.io.File
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.core.designsystem.VitrineTheme
import video.vitrine.data.gabarits.GabaritJson

/**
 * D42.34 Lot 3 — non-régression des états caméra (CR-3, P0 ③) :
 * le parcours générique « Scène par scène » n'existe plus en mode gabarit
 * (chargement/erreur explicites), et le compteur de scènes ne s'affiche
 * jamais avec un total vide (« Scène 1/0 »). Le HUD prise reste le seul
 * affichage de guidage en mode gabarit.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class D34Lot3CameraStatesVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    private fun prisesT5Reelles(): List<video.vitrine.core.model.PriseGuide> {
        val raw = ctx().assets.open("gabarits/vetements_mode/T5.json")
            .use { it.readBytes().decodeToString() }
        return GabaritJson.parsePrises(raw)
    }

    // ---- D34-07 : erreur gabarit = état explicite récupérable ----
    @Test
    fun erreur_gabarit_etat_explicite_avec_retour() {
        compose.setContent {
            VitrineTheme {
                ErreurGabaritScreen(onRetour = { })
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.camera_gabarit_erreur_titre))
            .assertIsDisplayed()
        compose.onNodeWithTag("camera_gabarit_retour")
            .assertIsDisplayed()
        compose.onRoot().save("D34-07_camera-erreur-gabarit_APRES.png")
    }

    // ---- D34-08 : chargement gabarit = état honnête, pas de faux guide ----
    @Test
    fun chargement_gabarit_etat_honnete() {
        compose.setContent {
            VitrineTheme {
                EcranChargementGabarit()
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.camera_gabarit_chargement))
            .assertIsDisplayed()
        // Aucun compteur de scène pendant le chargement.
        compose.onNodeWithText(
            ctx().getString(R.string.camera_scene_counter, 1, 26)
        ).assertDoesNotExist()
        compose.onRoot().save("D34-08_camera-chargement-gabarit_APRES.png")
    }

    // ---- D34-09 : mode libre sans script = PLUS de « Scène 1/0 » ----
    @Test
    fun mode_libre_sans_script_pas_de_scene_sur_zero() {
        compose.setContent {
            VitrineTheme {
                GuidedShootingOverlay(
                    scenes = emptyList(),
                    currentIdx = 0,
                    progress = 0f,
                    recording = false,
                )
            }
        }
        compose.onNodeWithText(
            ctx().getString(R.string.camera_scene_counter, 1, 0)
        ).assertDoesNotExist()
        compose.onRoot().save("D34-09_camera-libre-sans-scene-sur-zero_APRES.png")
    }

    // ---- D34-10 : HUD prise (T5 réel) = PRISE 1/2, aucun compteur de scène ----
    @Test
    fun hud_prise_t5_reel_sans_compteur_scene() {
        val prises = prisesT5Reelles()
        check(prises.size == 2) { "attendu 2 prises T5, trouvé ${prises.size}" }
        compose.setContent {
            VitrineTheme {
                PriseGuideScreen(
                    prises = prises,
                    priseIdx = 0,
                    sectorLabel = "Vêtements & Mode",
                    formatLabel = "Un client raconte",
                    streaming = true,
                    recording = false,
                    countdown = null,
                    priseValidee = null,
                )
            }
        }
        compose.onNodeWithText("PRISE 1/2").assertIsDisplayed()
        compose.onNodeWithText(
            ctx().getString(R.string.camera_scene_counter, 1, 26)
        ).assertDoesNotExist()
        compose.onRoot().save("D34-10_camera-hud-prise-t5_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
