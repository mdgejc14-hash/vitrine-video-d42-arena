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

    // ---- D34-29 : catalogue Immo/Auto — 5 aperçus photographiques rendus ----
    @Test
    fun catalogue_immo_rend_les_apercus_integres() {
        val immo = gabaritsDuSecteur("immo_auto")
        check(immo.size == 5) { "attendu 5 gabarits Immo/Auto, trouvé ${immo.size}" }
        immo.forEach { g ->
            check(ApercuGabarit.resPour(g.id) != null) {
                "aperçu manquant dans ApercuGabarit pour ${g.id}"
            }
        }
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = null,
                    offline = false,
                    initialSector = Sector.IMMO_AUTO,
                    gabarits = immo,
                )
            }
        }
        compose.onAllNodesWithText(metaFormatte(immo.first())).onFirst().assertIsDisplayed()
        compose.onRoot().save("D34-29_catalogue-immo-apercus_APRES.png")
    }

    // ---- D34-30 : catalogue Restauration — 5 aperçus photographiques rendus ----
    @Test
    fun catalogue_restauration_rend_les_apercus_integres() {
        val resto = gabaritsDuSecteur("restaurants_maquis")
        check(resto.size == 5) { "attendu 5 gabarits Restauration, trouvé ${resto.size}" }
        resto.forEach { g ->
            check(ApercuGabarit.resPour(g.id) != null) {
                "aperçu manquant dans ApercuGabarit pour ${g.id}"
            }
        }
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = null,
                    offline = false,
                    initialSector = Sector.RESTAURATION,
                    gabarits = resto,
                )
            }
        }
        compose.onAllNodesWithText(metaFormatte(resto.first())).onFirst().assertIsDisplayed()
        compose.onRoot().save("D34-30_catalogue-restauration-apercus_APRES.png")
    }

    // ---- D34-31 : catalogue Shops — 5 aperçus photographiques rendus ----
    @Test
    fun catalogue_shops_rend_les_apercus_integres() {
        val shops = gabaritsDuSecteur("shops_small_business")
        check(shops.size == 5) { "attendu 5 gabarits Shops, trouvé ${shops.size}" }
        shops.forEach { g ->
            check(ApercuGabarit.resPour(g.id) != null) {
                "aperçu manquant dans ApercuGabarit pour ${g.id}"
            }
        }
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
        compose.onRoot().save("D34-31_catalogue-shops-apercus_APRES.png")
    }

    // ---- D34-32 : catalogue Mode — 5 aperçus photographiques rendus ----
    @Test
    fun catalogue_mode_rend_les_apercus_integres() {
        val mode = gabaritsDuSecteur("vetements_mode")
        check(mode.size == 5) { "attendu 5 gabarits Mode, trouvé ${mode.size}" }
        mode.forEach { g ->
            check(ApercuGabarit.resPour(g.id) != null) {
                "aperçu manquant dans ApercuGabarit pour ${g.id}"
            }
        }
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = null,
                    offline = false,
                    initialSector = Sector.MODE,
                    gabarits = mode,
                )
            }
        }
        compose.onAllNodesWithText(metaFormatte(mode.first())).onFirst().assertIsDisplayed()
        compose.onRoot().save("D34-32_catalogue-mode-apercus_APRES.png")
    }

    // ---- D34-33 : scroll bas — les dernières tuiles du secteur visibles ----
    @Test
    fun catalogue_scroll_bas_dernieres_tuiles() {
        val shops = gabaritsDuSecteur("shops_small_business")
        check(shops.size == 5) { "attendu 5 gabarits Shops, trouvé ${shops.size}" }
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
        // Défilement réel jusqu'à la DERNIÈRE tuile (méta du 5e gabarit) :
        // l'état « scroll bas » montre les tuiles du bas avec leurs aperçus.
        compose.onAllNodesWithText(metaFormatte(shops.last()))
            .onFirst()
            .performScrollTo()
            .assertIsDisplayed()
        compose.onRoot().save("D34-33_catalogue-scroll-bas_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
