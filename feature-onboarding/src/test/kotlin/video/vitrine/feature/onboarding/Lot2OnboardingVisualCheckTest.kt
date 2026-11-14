package video.vitrine.feature.onboarding

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
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onRoot
import androidx.compose.ui.test.performScrollTo
import androidx.compose.ui.test.performClick
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
import video.vitrine.core.model.Sector

/**
 * Lot 2 D42.33 v2 — captures APRÈS manquantes (SCREEN_INVENTORY.csv).
 * Harnais CI-Visual-Check : mêmes composants/états réels que l'app.
 * Chaque capture démontre un état DISTINCT (aucun doublon).
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class Lot2OnboardingVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    /** fontScale paramétrable (contrôle §12.1, même approche que le dashboard). */
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

    // ---- P01-04 : sélection de langue EN ----
    @Test
    @Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
    fun langue_en() {
        compose.setContent { VitrineTheme { LanguageScreen { } } }
        compose.onNodeWithText(ctx().getString(R.string.lang_title)).assertExists()
        compose.onRoot().save("P01-04_langue-en_APRES.png")
    }

    // ---- P01-08 : écran code parrain (E3b) — saisie manuelle ----
    @Test
    fun code_parrain_saisie_manuelle() {
        compose.setContent { VitrineTheme { ReferralCodeScreen(sector = Sector.MODE) { } } }
        compose.onNodeWithText(ctx().getString(R.string.refcode_title)).assertExists()
        compose.onRoot().save("P01-08_code-parrain-saisie-manuelle_APRES.png")
    }

    // ---- P01-08 : écran code parrain — deep-link pré-rempli ----
    @Test
    fun code_parrain_deep_link_prefilled() {
        compose.setContent {
            VitrineTheme { ReferralCodeScreen(sector = Sector.MODE, initial = "SHALOM-842") { } }
        }
        compose.onNodeWithText(ctx().getString(R.string.refcode_title)).assertExists()
        compose.onRoot().save("P01-08_code-parrain-deep-link-prefilled_APRES.png")
    }

    // ---- P01-09 : bienvenue — crédits confirmés (§9.4) ----
    @Test
    fun bienvenue_credits_confirmes() {
        compose.setContent {
            VitrineTheme {
                WelcomeScreen(credits = 3, statut = "ok", refusStatut = 0, refusCode = "") { }
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.welcome_solde_titre)).assertExists()
        compose.onRoot().save("P01-09_bienvenue-credits-confirmes_APRES.png")
    }

    // ---- P01-10 : bienvenue — solde en attente de synchronisation ----
    @Test
    fun bienvenue_solde_en_attente() {
        compose.setContent {
            VitrineTheme {
                WelcomeScreen(credits = 0, statut = "attente", refusStatut = 0, refusCode = "") { }
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.welcome_credits_pending)).assertExists()
        compose.onRoot().save("P01-10_bienvenue-solde-en-attente_APRES.png")
    }

    // ---- P12-15 : bienvenue — hors connexion (message dédié, §10) ----
    @Test
    fun bienvenue_hors_connexion() {
        compose.setContent {
            VitrineTheme {
                WelcomeScreen(credits = 0, statut = "horsligne", refusStatut = 0, refusCode = "") { }
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.welcome_offline)).assertExists()
        compose.onRoot().save("P12-15_bienvenue-hors-connexion_APRES.png")
    }

    // ---- P02-01 : carrousel slide 1 — résolution de conception w360dp ----
    @Test
    fun carrousel_slide_1_w360() {
        compose.setContent { VitrineTheme { CarouselScreen { } } }
        compose.onNodeWithText(ctx().getString(R.string.slide1_slogan)).assertExists()
        compose.onRoot().save("P02-01_carrousel-slide-1_APRES.png")
    }

    // ---- P02-02 : carrousel slide 2 (avancer via le CTA réel) ----
    @Test
    fun carrousel_slide_2() {
        compose.setContent { VitrineTheme { CarouselScreen { } } }
        compose.onNodeWithText(ctx().getString(R.string.carousel_next)).performClick()
        compose.waitUntil(5_000) {
            compose.onAllNodesWithText(ctx().getString(R.string.slide2_title))
                .fetchSemanticsNodes().isNotEmpty()
        }
        compose.onRoot().save("P02-02_carrousel-slide-2_APRES.png")
    }

    // ---- P02-03 : carrousel slide 3 (CTA d'entrée) ----
    @Test
    fun carrousel_slide_3() {
        compose.setContent { VitrineTheme { CarouselScreen { } } }
        compose.onNodeWithText(ctx().getString(R.string.carousel_next)).performClick()
        compose.waitUntil(5_000) {
            compose.onAllNodesWithText(ctx().getString(R.string.slide2_title))
                .fetchSemanticsNodes().isNotEmpty()
        }
        compose.onNodeWithText(ctx().getString(R.string.carousel_next)).performClick()
        compose.waitUntil(5_000) {
            compose.onAllNodesWithText(ctx().getString(R.string.slide3_slogan))
                .fetchSemanticsNodes().isNotEmpty()
        }
        compose.onRoot().save("P02-03_carrousel-slide-3_APRES.png")
    }

    // ---- CORRECTION galerie v1 (écart avéré Lot 2) : le harnais v1
    //      (OnboardingVisualCheckTest, run 43610784376) n'avait AUCUN qualifier
    //      de locale — Robolectric rendait en ANGLAIS par défaut alors que les
    //      fichiers étaient étiquetés « fr ». Ces deux tests produisent les
    //      rendus FR authentiques qui remplacent les fichiers v1 (P01-03,
    //      P02-06) — preuve : le rendu EN (P01-04/P02-08) est byte-identique
    //      aux fichiers v1, le rendu FR en diffère. ----
    @Test
    fun correction_galerie_langue_fr() {
        compose.setContent { VitrineTheme { LanguageScreen { } } }
        compose.onNodeWithText(ctx().getString(R.string.lang_title)).assertExists()
        compose.onRoot().save("CORRECTION_langue_fr_w360.png")
    }

    @Test
    fun correction_galerie_secteurs_fr() {
        compose.setContent { VitrineTheme { OnboardingScreen { } } }
        compose.onNodeWithText(ctx().getString(R.string.sector_title)).assertExists()
        compose.onRoot().save("CORRECTION_secteurs_fr_w360.png")
    }

    // ---- P02-04 : carrousel slide 1 EN ----
    @Test
    @Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
    fun carrousel_slide_1_en() {
        compose.setContent { VitrineTheme { CarouselScreen { } } }
        compose.onNodeWithText(ctx().getString(R.string.slide1_slogan)).assertExists()
        compose.onRoot().save("P02-04_carrousel-slide-1-en_APRES.png")
    }

    // ---- P02-07 : secteurs — bas de l'écran (scroll) ----
    @Test
    fun secteurs_bas_scroll() {
        compose.setContent { VitrineTheme { OnboardingScreen { } } }
        val dernier = ctx().getString(video.vitrine.core.designsystem.R.string.sector_commerce)
        // NOTE Robolectric : performScrollTo (action sémantique réelle) +
        // assertIsDisplayed — preuve que le dernier secteur est visible.
        compose.onNodeWithText(dernier).performScrollTo().assertIsDisplayed()
        compose.onRoot().save("P02-07_secteurs-bas_APRES.png")
    }

    // ---- P02-08 : secteurs EN ----
    @Test
    @Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
    fun secteurs_en() {
        compose.setContent { VitrineTheme { OnboardingScreen { } } }
        compose.onNodeWithText(ctx().getString(R.string.sector_title)).assertExists()
        compose.onRoot().save("P02-08_secteurs-en_APRES.png")
    }

    // ---- P12-01 : fontScale 1,3 — bienvenue (§12.1) ----
    @Test
    fun bienvenue_font_scale_130() {
        contenu(fontScale = 1.3f) {
            WelcomeScreen(credits = 3, statut = "ok", refusStatut = 0, refusCode = "") { }
        }
        compose.onNodeWithText(ctx().getString(R.string.welcome_cta)).assertExists()
        compose.onRoot().save("P12-01_bienvenue-fontScale-1.3_APRES.png")
    }

    // ---- P12-02 : fontScale 1,3 — langue (§12.1) ----
    @Test
    fun langue_font_scale_130() {
        contenu(fontScale = 1.3f) { LanguageScreen { } }
        compose.onNodeWithText(ctx().getString(R.string.lang_title)).assertExists()
        compose.onRoot().save("P12-02_langue-fontScale-1.3_APRES.png")
    }

    // ---- P12-07 : petit écran 360×640 — langue (§12.2) ----
    @Test
    @Config(sdk = [34], qualifiers = "fr-w360dp-h640dp")
    fun langue_petit_ecran() {
        compose.setContent { VitrineTheme { LanguageScreen { } } }
        compose.onNodeWithText(ctx().getString(R.string.lang_title)).assertExists()
        compose.onRoot().save("P12-07_langue-petit-ecran_APRES.png")
    }

    // ---- P12-08 : petit écran 360×640 — bienvenue (§12.2) ----
    @Test
    @Config(sdk = [34], qualifiers = "fr-w360dp-h640dp")
    fun bienvenue_petit_ecran() {
        compose.setContent {
            VitrineTheme {
                WelcomeScreen(credits = 3, statut = "ok", refusStatut = 0, refusCode = "") { }
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.welcome_cta)).assertExists()
        compose.onRoot().save("P12-08_bienvenue-petit-ecran_APRES.png")
    }

    // ---- P12-12 : rotation paysage — bienvenue (§12.3) ----
    @Test
    @Config(sdk = [34], qualifiers = "fr-w640dp-h360dp")
    fun bienvenue_rotation() {
        compose.setContent {
            VitrineTheme {
                WelcomeScreen(credits = 3, statut = "ok", refusStatut = 0, refusCode = "") { }
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.welcome_cta)).assertExists()
        compose.onRoot().save("P12-12_bienvenue-rotation_APRES.png")
    }

    // ---- P12-13 : rotation paysage — carrousel (§12.3) ----
    @Test
    @Config(sdk = [34], qualifiers = "fr-w640dp-h360dp")
    fun carrousel_rotation() {
        compose.setContent { VitrineTheme { CarouselScreen { } } }
        compose.onNodeWithText(ctx().getString(R.string.slide1_slogan)).assertExists()
        compose.onRoot().save("P12-13_carrousel-rotation_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
