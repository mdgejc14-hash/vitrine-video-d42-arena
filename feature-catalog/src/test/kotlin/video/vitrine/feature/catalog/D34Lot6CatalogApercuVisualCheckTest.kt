package video.vitrine.feature.catalog

import android.content.Context
import android.graphics.Bitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.test.SemanticsNodeInteraction
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onFirst
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
import video.vitrine.core.model.GabaritSummary
import video.vitrine.core.model.Sector
import video.vitrine.data.gabarits.GabaritJson

/**
 * D42.34 ordre final — preuve de RENDU des aperçus photographiques intégrés
 * (lot 1 : Bâtiment T1→T5 + Coiffure T1→T5 + Immo T1).
 *
 * P0 fondateur : chaque gabarit doit montrer un véritable aperçu visuel.
 * Ces captures prouvent que ApercuGabarit.resPour() alimente bien la vignette
 * avec les WebP originaux générés (registre GENERATED_ASSETS) — capture
 * INTERMÉDIAIRE : la recapture définitive du catalogue aura lieu à 30/30
 * (ordre final §6), ces fichiers ne remplacent pas D34-01/02/03.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class D34Lot6CatalogApercuVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    /** Résumés RÉELS d'un secteur (JSON embarqués). */
    private fun gabaritsDuSecteur(dossier: String): List<GabaritSummary> {
        val assets = ctx().assets
        return assets.list("gabarits/$dossier").orEmpty()
            .filter { it.endsWith(".json") }
            .sorted()
            .mapNotNull { fichier ->
                assets.open("gabarits/$dossier/$fichier").use { flux ->
                    runCatching { GabaritJson.parse(flux.readBytes().decodeToString()) }.getOrNull()
                }
            }
    }

    private fun metaFormatte(g: GabaritSummary): String = ctx().getString(
        R.string.catalog_gabarit_meta,
        g.dureeTotaleS,
        g.nombreScenes,
        g.nombrePrises,
    )

    // ---- D34-16 : catalogue Bâtiment — 5 aperçus photographiques rendus ----
    @Test
    fun catalogue_batiment_rend_les_apercus_integres() {
        val btp = gabaritsDuSecteur("batiment_travaux")
        check(btp.size == 5) { "attendu 5 gabarits Bâtiment, trouvé ${btp.size}" }
        // Les 5 aperçus du secteur sont déclarés dans ApercuGabarit.
        btp.forEach { g ->
            check(ApercuGabarit.resPour(g.id) != null) {
                "aperçu manquant dans ApercuGabarit pour ${g.id}"
            }
        }
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = null,
                    offline = false,
                    initialSector = Sector.BTP,
                    gabarits = btp,
                )
            }
        }
        compose.onAllNodesWithText(metaFormatte(btp.first())).onFirst().assertIsDisplayed()
        compose.onRoot().save("D34-16_catalogue-batiment-apercus_APRES.png")
    }

    // ---- D34-17 : catalogue Coiffure — 5 aperçus photographiques rendus ----
    @Test
    fun catalogue_coiffure_rend_les_apercus_integres() {
        val coiffure = gabaritsDuSecteur("coiffure_beaute")
        check(coiffure.size == 5) { "attendu 5 gabarits Coiffure, trouvé ${coiffure.size}" }
        coiffure.forEach { g ->
            check(ApercuGabarit.resPour(g.id) != null) {
                "aperçu manquant dans ApercuGabarit pour ${g.id}"
            }
        }
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = null,
                    offline = false,
                    initialSector = Sector.COIFFURE,
                    gabarits = coiffure,
                )
            }
        }
        compose.onAllNodesWithText(metaFormatte(coiffure.first())).onFirst().assertIsDisplayed()
        compose.onRoot().save("D34-17_catalogue-coiffure-apercus_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
