package video.vitrine.feature.catalog

import android.content.Context
import android.graphics.Bitmap
import androidx.compose.ui.test.SemanticsNodeInteraction
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onFirst
import androidx.compose.ui.test.onRoot
import androidx.compose.ui.graphics.asAndroidBitmap
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
 * D42.34 P3 (Lot 12) — preuve de rendu du catalogue EN avec les aperçus
 * photographiques réels (VR-019) : la locale EN de Robolectric résout les
 * vraies chaînes values-en (libellés secteur, méta « N s · N guided takes »),
 * le CatalogScreen réel est rendu avec les gabarits réels du secteur Shops
 * et leurs 5 aperçus webp intégrés.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class D34Lot12CatalogEnVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

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

    @Test
    fun catalogue_en_rend_les_apercus_integres() {
        val shops = gabaritsDuSecteur("shops_small_business")
        check(shops.size == 5) { "attendu 5 gabarits Shops, trouvé ${shops.size}" }
        shops.forEach { g ->
            check(ApercuGabarit.resPour(g.id) != null) {
                "aperçu manquant dans ApercuGabarit pour ${g.id}"
            }
        }
        // la méta EN contient bien « guided takes » (aucun mot français)
        val meta = metaFormatte(shops.first())
        check(meta.contains("guided takes")) { "méta EN inattendue : \"$meta\"" }
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = null,
                    offline = false,
                    initialSector = Sector.COMMERCE,
                    gabarits = shops,
                )
            }
        }
        compose.onAllNodesWithText(metaFormatte(shops.first())).onFirst().assertIsDisplayed()
        compose.onRoot().save("D34-34_catalogue-en-apercus_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
