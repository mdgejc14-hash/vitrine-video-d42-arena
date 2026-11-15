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
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onRoot
import androidx.compose.ui.test.performClick
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
 * D42.34 Lot 1 — non-régression des corrections catalogue (CR-1.1 / CR-1.2).
 *
 * P0 fondateur : après le choix d'un secteur à l'onboarding, le catalogue ne
 * doit JAMAIS mélanger les 30 gabarits (repli `Sector.TOUS` silencieux), et
 * le libellé des cartes doit parler en PRISES GUIDÉES (jamais « N scènes »).
 *
 * Les gabarits affichés sont les VRAIS résumés parsés des JSON embarqués.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class D34Lot1CatalogVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    /** Les 30 gabarits réels (l'état qui alimentait le repli fautif). */
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

    /** Résumés RÉELS des 5 formats du secteur Mode (JSON embarqués). */
    private fun gabaritsMode(): List<GabaritSummary> {
        val assets = ctx().assets
        return assets.list("gabarits/vetements_mode").orEmpty()
            .filter { it.endsWith(".json") }
            .sorted()
            .mapNotNull { fichier ->
                assets.open("gabarits/vetements_mode/$fichier").use { flux ->
                    runCatching { GabaritJson.parse(flux.readBytes().decodeToString()) }.getOrNull()
                }
            }
    }

    /** Libellé méta formaté d'un gabarit (même calcul que la carte). */
    private fun metaFormatte(g: GabaritSummary): String = ctx().getString(
        R.string.catalog_gabarit_meta,
        g.dureeTotaleS,
        g.nombreScenes,
        g.nombrePrises,
    )

    // ---- D34-01 : secteur perdu = état EXPLICITE, jamais 30 en silence ----
    @Test
    fun secteur_perdu_etat_explicite_sans_grille_silencieuse() {
        val gabarits = tousLesGabarits()
        check(gabarits.size >= 25) { "attendu ~30 gabarits, trouvé ${gabarits.size}" }
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = null,
                    offline = false,
                    initialSector = null,
                    gabarits = gabarits,
                )
            }
        }
        // L'état d'erreur explicite est affiché (exigence : pas de TOUS muet).
        compose.onNodeWithText(ctx().getString(R.string.catalog_secteur_perdu_titre))
            .assertIsDisplayed()
        // Et la grille des 30 ne s'est PAS affichée en silence : aucune carte
        // gabarit (méta réelle du 1er gabarit) n'est présente.
        compose.onNodeWithText(metaFormatte(gabarits.first())).assertDoesNotExist()
        compose.onRoot().save("D34-01_catalogue-secteur-perdu_APRES.png")
    }

    // ---- D34-02 : état récupérable — choisir un métier reaffiche SES 5 ----
    @Test
    fun secteur_perdu_recuperable_par_choix_du_metier() {
        val gabarits = tousLesGabarits()
        compose.setContent {
            VitrineTheme {
                CatalogScreen(
                    manifest = null,
                    offline = false,
                    initialSector = null,
                    gabarits = gabarits,
                )
            }
        }
        // La rangée de filtres est ouverte : le choix « Vêtements & Mode »
        // réaffiche les 5 modèles du secteur (chemin de récupération).
        compose.onNodeWithText(
            ctx().getString(video.vitrine.core.designsystem.R.string.sector_mode)
        ).performClick()
        val mode = gabaritsMode()
        check(mode.size == 5) { "attendu 5 gabarits Mode, trouvé ${mode.size}" }
        // Plusieurs cartes du secteur peuvent partager le même libellé méta
        // (35 s · 3 prises) : on cible la première, affichée sans défilement.
        compose.onAllNodesWithText(metaFormatte(mode.first())).onFirst().assertIsDisplayed()
        compose.onRoot().save("D34-02_catalogue-secteur-perdu-recupere_APRES.png")
    }

    // ---- D34-03 : libellé « N s · N prises guidées » (jamais « scènes ») ----
    @Test
    fun libelle_carte_prises_guidees_sans_mot_scenes() {
        val mode = gabaritsMode()
        check(mode.isNotEmpty()) { "JSON gabarits Mode absents des ressources de test" }
        // Données fondateur vérifiées : vetements_mode/T1 = 35 s, 3 prises.
        val t1 = mode.first()
        check(t1.nombrePrises == 3) { "T1 Mode attendu en 3 prises, trouvé ${t1.nombrePrises}" }
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
        compose.onAllNodesWithText(metaFormatte(t1)).onFirst().assertIsDisplayed()
        // L'ancien format fautif (« N scènes ») n'existe plus nulle part.
        val ancien = ctx().getString(R.string.catalog_gabarit_meta, t1.dureeTotaleS, t1.nombreScenes, t1.nombrePrises)
        check(!ancien.contains("scènes")) { "le libellé contient encore « scènes » : $ancien" }
        compose.onRoot().save("D34-03_catalogue-libelle-prises-guidees_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
