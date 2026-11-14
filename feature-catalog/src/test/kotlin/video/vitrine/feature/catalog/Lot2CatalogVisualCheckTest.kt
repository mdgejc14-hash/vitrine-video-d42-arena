package video.vitrine.feature.catalog

import android.content.Context
import android.graphics.Bitmap
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.test.SemanticsNodeInteraction
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onLast
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onRoot
import androidx.compose.ui.test.performScrollTo
import androidx.compose.ui.unit.Density
import androidx.test.core.app.ApplicationProvider
import java.io.File
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.core.designsystem.VitrineTheme
import video.vitrine.core.model.CatalogManifest
import video.vitrine.core.model.GabaritSummary
import video.vitrine.core.model.Sector
import video.vitrine.core.model.Skin
import video.vitrine.data.gabarits.GabaritJson

/**
 * Lot 2 D42.33 v2 — captures APRÈS manquantes du catalogue.
 * Les gabarits affichés sont les VRAIS résumés parsés des JSON embarqués
 * (data/src/main/assets/gabarits) — aucune donnée inventée.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class Lot2CatalogVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    /** Résumés RÉELS des 5 formats du secteur Mode (JSON embarqués). */
    private fun gabaritsReels(): List<GabaritSummary> = gabaritsSecteur("vetements_mode")

    /**
     * Les 30 gabarits universels réels (état de repli hors-ligne documenté :
     * « Les 30 formats universels restent disponibles ») — c'est l'état qui
     * défile réellement (5 tuiles d'un secteur tiennent à l'écran).
     * Robolectric liste les sous-dossiers en chemins relatifs
     * (« secteur/T1.json ») : on ouvre chaque JSON directement.
     */
    private fun tousLesGabarits(): List<GabaritSummary> {
        val assets = ctx().assets
        return assets.list("gabarits").orEmpty()
            .filter { it.endsWith(".json") }
            .mapNotNull { chemin ->
                assets.open("gabarits/$chemin").use { flux ->
                    runCatching { GabaritJson.parse(flux.readBytes().decodeToString()) }.getOrNull()
                }
            }
    }

    private fun gabaritsSecteur(secteur: String): List<GabaritSummary> {
        val assets = ctx().assets
        return assets.list("gabarits/$secteur").orEmpty()
            .filter { it.endsWith(".json") }
            .sorted()
            .mapNotNull { fichier ->
                assets.open("gabarits/$secteur/$fichier").use { flux ->
                    runCatching { GabaritJson.parse(flux.readBytes().decodeToString()) }.getOrNull()
                }
            }
    }

    private fun manifeste(): CatalogManifest = CatalogManifest(
        version = "1.0.0",
        minAppVersion = "1.0.0",
        skins = listOf(
            Skin("F001", "F001_mode_01", Sector.MODE, "", "1"),
        )
    )

    private fun contenu(fontScale: Float, bloc: @androidx.compose.runtime.Composable () -> Unit) {
        compose.setContent {
            VitrineTheme {
                CompositionLocalProvider(
                    LocalDensity provides Density(
                        density = LocalDensity.current.density,
                        fontScale = fontScale
                    )
                ) {
                    bloc()
                }
            }
        }
    }

    // ---- P03-02 : tuiles de gabarits peuplées (vrais formats du secteur) ----
    @Test
    fun catalogue_tuiles_peuplees() {
        val gabarits = gabaritsReels()
        check(gabarits.isNotEmpty()) { "JSON gabarits absents des ressources de test" }
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = manifeste(),
                    offline = false,
                    initialSector = Sector.MODE,
                    gabarits = gabarits,
                )
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.catalog_title)).assertExists()
        check(
            compose.onAllNodesWithText(gabarits.first().nomFormatAffiche)
                .fetchSemanticsNodes().isNotEmpty()
        ) { "tuile du premier gabarit absente" }
        compose.onRoot().save("P03-02_catalogue-tuiles-peuplees_APRES.png")
    }

    // ---- P03-03 : catalogue — bas (30 formats universels, repli réel) ----
    @Test
    fun catalogue_scroll_bas() {
        val gabarits = tousLesGabarits()
        check(gabarits.size >= 25) { "attendu ~30 gabarits, trouvé ${gabarits.size}" }
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = null,
                    offline = false,
                    initialSector = Sector.TOUS,
                    gabarits = gabarits,
                )
            }
        }
        val dernier = gabarits.last().nomFormatAffiche
        // NOTE Robolectric : performScrollTo (action sémantique réelle) +
        // assertIsDisplayed prouvent l'état « bas ». Le nom du dernier format
        // existe dans les 6 secteurs (formats universels) : on cible la
        // DERNIÈRE occurrence (ordre de composition = ordre visuel).
        compose.onAllNodesWithText(dernier).onLast().performScrollTo().assertIsDisplayed()
        compose.onRoot().save("P03-03_catalogue-scroll-bas_APRES.png")
    }

    // ---- P03-04 : catalogue EN ----
    @Test
    @Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
    fun catalogue_en() {
        val gabarits = gabaritsReels()
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = manifeste(),
                    offline = false,
                    initialSector = Sector.MODE,
                    gabarits = gabarits,
                )
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.catalog_title)).assertExists()
        compose.onRoot().save("P03-04_catalogue-en_APRES.png")
    }

    // ---- P03-05 : catalogue hors connexion (bandeau + repli 30 formats) ----
    @Test
    fun catalogue_hors_connexion() {
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = null,
                    offline = true,
                    initialSector = Sector.TOUS,
                    gabarits = tousLesGabarits(),
                )
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.catalog_offline)).assertExists()
        compose.onRoot().save("P03-05_catalogue-hors-connexion_APRES.png")
    }

    // ---- P12-03 : fontScale 1,3 — catalogue (§12.1) ----
    @Test
    fun catalogue_font_scale_130() {
        val gabarits = gabaritsReels()
        contenu(fontScale = 1.3f) {
            CatalogScreen(
                manifest = manifeste(),
                offline = false,
                initialSector = Sector.MODE,
                gabarits = gabarits,
            )
        }
        compose.onNodeWithText(ctx().getString(R.string.catalog_title)).assertExists()
        compose.onRoot().save("P12-03_catalogue-fontScale-1.3_APRES.png")
    }

    // ---- P12-09 : petit écran 360×640 — catalogue (§12.2) ----
    @Test
    @Config(sdk = [34], qualifiers = "fr-w360dp-h640dp")
    fun catalogue_petit_ecran() {
        val gabarits = gabaritsReels()
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = manifeste(),
                    offline = false,
                    initialSector = Sector.MODE,
                    gabarits = gabarits,
                )
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.catalog_title)).assertExists()
        compose.onRoot().save("P12-09_catalogue-petit-ecran_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
