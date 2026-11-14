package video.vitrine.feature.brief

import android.content.Context
import android.graphics.Bitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.test.SemanticsNodeInteraction
import androidx.compose.ui.test.assertIsEnabled
import androidx.compose.ui.test.assertIsNotEnabled
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
import video.vitrine.data.gabarits.GabaritJson

/**
 * Lot 2 D42.33 v2 — captures APRÈS manquantes du brief / préparation.
 * Le formulaire est le VRAI T1 (vetements_mode) parsé du JSON embarqué :
 * champs, défauts (FCFA), exemples et section facultative réels.
 * Limites honnêtes : le clavier logiciel n'est pas rendu par Robolectric.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class Lot2BriefVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    /** Vrai brief T1 (secteur Mode, format Nouvel arrivage). */
    private fun brief(): GabaritBrief {
        val raw = ctx().assets.open("gabarits/vetements_mode/T1.json")
            .use { it.readBytes().decodeToString() }
        return GabaritJson.parseBrief(raw)
    }

    /** Exemples RÉELS du JSON (aucune donnée inventée). */
    private fun exemples(b: GabaritBrief): Map<String, String> =
        b.fields.associate { f -> f.id to f.example }

    private fun ecran(b: GabaritBrief, initial: Map<String, String> = emptyMap()) {
        compose.setContent {
            VitrineTheme {
                GabaritBriefScreen(brief = b, initialValues = initial, onSubmit = { })
            }
        }
    }

    // ---- P04-01 : haut du formulaire (1re section, défaut FCFA, CTA bloqué) ----
    @Test
    fun brief_haut() {
        val b = brief()
        ecran(b)
        compose.onNodeWithTag("brief_nom_commerce").assertExists()
        compose.onNodeWithTag("brief_continue").assertIsNotEnabled()
        compose.onRoot().save("P04-01_brief-haut_APRES.png")
    }

    // ---- P04-03 : vide (champs requis vides — défaut FCFA effacé) ----
    @Test
    fun brief_vide() {
        val b = brief()
        val vides = b.fields.filter { it.required }.associate { it.id to "" }
        ecran(b, vides)
        compose.onNodeWithTag("brief_nom_commerce").assertExists()
        compose.onNodeWithTag("brief_continue").assertIsNotEnabled()
        compose.onRoot().save("P04-03_brief-vide_APRES.png")
    }

    // ---- P04-04 : rempli (exemples du JSON, CTA débloqué) ----
    @Test
    fun brief_rempli() {
        val b = brief()
        ecran(b, exemples(b))
        compose.onNodeWithTag("brief_continue").assertIsEnabled()
        compose.onRoot().save("P04-04_brief-rempli_APRES.png")
    }

    // ---- P04-05 : final rempli — bas du formulaire, CTA actif visible ----
    @Test
    fun brief_final_rempli() {
        val b = brief()
        ecran(b, exemples(b))
        compose.onNodeWithTag("brief_quartier_ville").performScrollTo()
        compose.onNodeWithTag("brief_continue").assertIsEnabled()
        compose.onRoot().save("P04-05_brief-final-rempli_APRES.png")
    }

    // ---- P04-02 : dernière section (lieu) — options repliées ----
    @Test
    fun brief_derniere_section() {
        val b = brief()
        ecran(b)
        compose.onNodeWithTag("brief_quartier_ville").performScrollTo()
        compose.onRoot().save("P04-02_brief-derniere-section_APRES.png")
    }

    // ---- P04-06 : reprise de brouillon (saisie partielle restaurée) ----
    @Test
    fun brief_reprise_brouillon() {
        val b = brief()
        val partiel = mapOf(
            "nom_commerce" to "Boutique Élégance",
            "prix" to "15000",
        )
        ecran(b, partiel)
        compose.onNodeWithTag("brief_nom_commerce").assertExists()
        compose.onNodeWithTag("brief_continue").assertIsNotEnabled()
        compose.onRoot().save("P04-06_brief-reprise-brouillon_APRES.png")
    }

    // ---- P04-07 : bas — options facultatives DÉPLIÉES + CTA épinglé ----
    @Test
    fun brief_options_depliees() {
        val b = brief()
        ecran(b)
        val titreOptions = b.sections.first { it.optional }.title
        compose.onNodeWithText(titreOptions).performScrollTo()
        compose.onNodeWithText(titreOptions).performClick()
        compose.waitForIdle()
        compose.onNodeWithTag("brief_continue").assertExists()
        compose.onRoot().save("P04-07_brief-options-depliees_APRES.png")
    }

    // ---- P04-09 : champ WhatsApp international REMPLI (E.164 réel du JSON ;
    //      sélecteur de pays + forme nationale ; clavier non rendu par Robolectric) ----
    @Test
    fun whatsapp_champ_fr() {
        val b = brief()
        val exemple = b.fields.first { it.id == "whatsapp" }.example
        ecran(b, mapOf("whatsapp" to exemple))
        compose.onNodeWithText(
            b.fields.first { it.id == "whatsapp" }.label, substring = true
        ).performScrollTo().assertExists()
        compose.onRoot().save("P04-09_whatsapp-champ-fr_APRES.png")
    }

    // ---- P04-10 : champ WhatsApp international EN REMPLI ----
    @Test
    @Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
    fun whatsapp_champ_en() {
        val b = brief()
        val exemple = b.fields.first { it.id == "whatsapp" }.example
        ecran(b, mapOf("whatsapp" to exemple))
        compose.onNodeWithText(
            b.fields.first { it.id == "whatsapp" }.label, substring = true
        ).performScrollTo().assertExists()
        compose.onRoot().save("P04-10_whatsapp-champ-en_APRES.png")
    }

    // ---- P04-11 : préparation caméra (§9.6) — liste de tests + CTA ----
    @Test
    fun preparation_camera() {
        val b = brief()
        compose.setContent {
            VitrineTheme {
                ReadyCheckScreen(
                    sectorLabel = b.sectorLabel,
                    formatLabel = b.formatLabel,
                    prisesCount = 3,
                    infos = "Boutique Élégance · Robe wax · 15000",
                    onOk = { },
                )
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.e4b_title)).assertExists()
        compose.onNodeWithTag("ready_ok").assertExists()
        compose.onRoot().save("P04-11_preparation-camera_APRES.png")
    }

    // ---- P04-12 : préparation caméra — fontScale 1,3 + scroll (CTA épinglé) ----
    @Test
    fun controle_bas() {
        val b = brief()
        compose.setContent {
            VitrineTheme {
                androidx.compose.runtime.CompositionLocalProvider(
                    androidx.compose.ui.platform.LocalDensity provides androidx.compose.ui.unit.Density(
                        density = androidx.compose.ui.platform.LocalDensity.current.density,
                        fontScale = 1.3f
                    )
                ) {
                    ReadyCheckScreen(
                        sectorLabel = b.sectorLabel,
                        formatLabel = b.formatLabel,
                        prisesCount = 3,
                        infos = "Boutique Élégance · Robe wax · 15000",
                        onOk = { },
                    )
                }
            }
        }
        // NOTE Robolectric : le CTA ready_ok est ÉPINGLÉ hors de la zone
        // scrollable — swipeUp() sur onRoot() ne défile rien ; performScrollTo
        // (action sémantique) + assertIsDisplayed prouvent l'état « bas ».
        compose.onNodeWithText("Boutique Élégance", substring = true)
            .performScrollTo()
            .assertIsDisplayed()
        compose.onNodeWithTag("ready_ok").assertIsDisplayed()
        compose.onRoot().save("P04-12_controle-bas_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
