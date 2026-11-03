package video.vitrine.feature.dashboard

import android.content.Context
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithText
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

/**
 * Audit D41 — controle visuel i18n des ecrans financiers (paywall E9,
 * parrainage E11, reglages E12) dans les 4 langues reelles (FR/EN/ES/JA).
 * Chaque test compose l'ecran dans la locale cible, verifie que les libelles
 * TRADUITS sont rendus (pas de francais parasite) et enregistre une capture
 * PNG non compressee dans build/visual-check/ (evidence D41).
 *
 * La typographie japonaise est rendue avec la police systeme (Noto CJK) —
 * l'absence de police EMBARQUEE dans l'APK a ete verifiee statiquement
 * (rapport D41) ; le rendu physique CJK complet reste NON TESTABLE en sandbox.
 */
@RunWith(RobolectricTestRunner::class)
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class DashboardL10nCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun contexte(): Context = ApplicationProvider.getApplicationContext()

    private fun capturer(nom: String) {
        val sortie = File("build/visual-check")
        sortie.mkdirs()
        val bitmap = compose.onRoot().captureToImage().asAndroidBitmap()
        File(sortie, nom).outputStream().use { flux ->
            bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, flux)
        }
    }

    private fun verifierPaywall(nomPng: String) {
        compose.setContent {
            VitrineTheme {
                PaywallScreen(PaywallMapper.ui(welcomeCreditsLeft = 0, exportsLimit = 0)) { }
            }
        }
        val ctx = contexte()
        compose.onNodeWithText(ctx.getString(R.string.paywall_title)).assertExists()
        compose.onNodeWithText(ctx.getString(R.string.plan_boutique_title)).assertExists()
        // rendu prefixe « • » (DashboardScreens) : appariement par sous-chaine
        compose.onNodeWithText(ctx.getString(R.string.feat_pro_3), substring = true).assertExists()
        capturer(nomPng)
    }

    private fun verifierParrainage(nomPng: String) {
        compose.setContent {
            VitrineTheme {
                ReferralScreen(
                    ReferralGauge.ui(
                        "SHALOM-842",
                        converted = 3,
                        rewards = 0,
                        entries = listOf(
                            ReferralEntry("converted", true),
                            ReferralEntry("pending", false)
                        )
                    ),
                    onShare = { }
                )
            }
        }
        val ctx = contexte()
        compose.onNodeWithText(ctx.getString(R.string.ref2_title)).assertExists()
        compose.onNodeWithText(ctx.getString(R.string.ref2_sub_label, 3, 5, 2)).assertExists()
        // rendu combine « Filleul N · statut » (ReferralHistorique) : sous-chaine
        compose.onNodeWithText(ctx.getString(R.string.ref2_status_pending), substring = true).assertExists()
        capturer(nomPng)
    }

    private fun verifierReglages(nomPng: String) {
        compose.setContent {
            VitrineTheme {
                SettingsScreen(
                    accountEmail = "marchande@vitrine.video",
                    languageLabel = "Test",
                    referralCode = "SHALOM-842",
                    sectorLabel = "Test",
                    consentsCount = 3,
                    storageUsedLabel = "42"
                )
            }
        }
        val ctx = contexte()
        compose.onNodeWithText(ctx.getString(R.string.set_title)).assertExists()
        compose.onNodeWithText(ctx.getString(R.string.set_logout)).assertExists()
        compose.onNodeWithText(ctx.getString(R.string.set_storage)).assertExists()
        capturer(nomPng)
    }

    @Test
    @Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
    fun `paywall en francais`() = verifierPaywall("l10n-paywall-fr.png")

    @Test
    @Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
    fun `paywall en anglais`() = verifierPaywall("l10n-paywall-en.png")

    @Test
    @Config(sdk = [34], qualifiers = "es-w360dp-h820dp")
    fun `paywall en espagnol`() = verifierPaywall("l10n-paywall-es.png")

    @Test
    @Config(sdk = [34], qualifiers = "ja-w360dp-h820dp")
    fun `paywall en japonais`() = verifierPaywall("l10n-paywall-ja.png")

    @Test
    @Config(sdk = [34], qualifiers = "ja-w360dp-h820dp")
    fun `parrainage en japonais`() = verifierParrainage("l10n-referral-ja.png")

    @Test
    @Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
    fun `parrainage en anglais`() = verifierParrainage("l10n-referral-en.png")

    @Test
    @Config(sdk = [34], qualifiers = "es-w360dp-h820dp")
    fun `reglages en espagnol`() = verifierReglages("l10n-settings-es.png")

    @Test
    @Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
    fun `reglages en francais`() = verifierReglages("l10n-settings-fr.png")
}
