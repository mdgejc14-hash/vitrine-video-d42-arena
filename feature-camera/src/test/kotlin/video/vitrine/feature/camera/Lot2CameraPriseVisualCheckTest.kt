package video.vitrine.feature.camera

import android.content.Context
import android.graphics.Bitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.test.SemanticsNodeInteraction
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
import video.vitrine.core.designsystem.VitrineTheme
import video.vitrine.core.model.PriseGuide
import video.vitrine.data.gabarits.GabaritJson

/**
 * Lot 2 D42.33 v2 — captures APRÈS manquantes du viseur prise guide (E6).
 * Prises RÉELLES parsées du T1 (vetements_mode) : consignes authentiques.
 * Limites honnêtes : pas de flux caméra physique en Robolectric (le fond du
 * viseur est vide), et la bascule avant/arrière ne change aucune apparence.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class Lot2CameraPriseVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    private fun prises(): List<PriseGuide> {
        val raw = ctx().assets.open("gabarits/vetements_mode/T1.json")
            .use { it.readBytes().decodeToString() }
        return GabaritJson.parsePrises(raw)
    }

    private fun viseur(
        priseIdx: Int = 0,
        streaming: Boolean? = null,
        recording: Boolean = false,
        countdown: Int? = null,
        priseValidee: Int? = null,
    ) {
        compose.setContent {
            VitrineTheme {
                PriseGuideScreen(
                    prises = prises(),
                    priseIdx = priseIdx,
                    sectorLabel = "Vêtements & Mode",
                    formatLabel = "Nouvel arrivage",
                    streaming = streaming,
                    recording = recording,
                    countdown = countdown,
                    priseValidee = priseValidee,
                )
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.e6_title)).assertExists()
    }

    // ---- P05-04 : viseur — HUD informatif, flux non démarré ----
    @Test
    fun viseur_prise() {
        viseur()
        compose.onRoot().save("P05-04_viseur-prise_APRES.png")
    }

    // ---- P05-05 : viseur — flux STREAMING actif (chip verte) ----
    @Test
    fun viseur_flux_streaming() {
        viseur(streaming = true)
        compose.onNodeWithText(ctx().getString(R.string.camera_stream_ready)).assertExists()
        compose.onRoot().save("P05-05_flux-streaming_APRES.png")
    }

    // ---- P05-06 : compte à rebours 3-2-1 ----
    @Test
    fun compte_a_rebours() {
        viseur(countdown = 3)
        compose.onRoot().save("P05-06_compte-a-rebours_APRES.png")
    }

    // ---- P05-07 : enregistrement — badge REC ----
    @Test
    fun rec_badge() {
        viseur(recording = true)
        compose.onNodeWithText(ctx().getString(R.string.camera_rec_badge)).assertExists()
        compose.onRoot().save("P05-07_rec_APRES.png")
    }

    // ---- P05-08 : prise validée (retour visuel de fin de prise) ----
    @Test
    fun prise_validee() {
        viseur(priseValidee = 1)
        compose.onRoot().save("P05-08_prise-validee_APRES.png")
    }

    // ---- P05-11 : scène suivante — PRISE 2/3 ----
    @Test
    fun scene_suivante() {
        viseur(priseIdx = 1)
        compose.onRoot().save("P05-11_scene-2_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
