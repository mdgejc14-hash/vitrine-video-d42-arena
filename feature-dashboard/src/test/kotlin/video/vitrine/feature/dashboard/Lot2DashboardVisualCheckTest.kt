package video.vitrine.feature.dashboard

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
import androidx.compose.ui.test.performScrollTo
import androidx.compose.ui.test.performTouchInput
import androidx.compose.ui.test.swipeUp
import androidx.test.core.app.ApplicationProvider
import java.io.File
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.core.designsystem.VitrineTheme
import video.vitrine.data.local.EntitlementsCache

/**
 * Lot 2 D42.33 v2 — captures APRÈS manquantes du dashboard / réglages /
 * paywall. Mêmes fixtures réelles que ResponsiveA11yCheckTest (aucune
 * donnée inventée : compteurs réels ou absents).
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class Lot2DashboardVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    private fun entitles(): EntitlementsCache = EntitlementsCache(
        merchantId = "test-d42-33",
        endcardMention = true,
        maxRes = "1080p",
        exportsLimit = 6,
        fairUse = null,
        cloudRenders = 1,
        brandKit = false,
        watermark = false,
        cacheDays = 1,
        welcomeCreditsLeft = 6,
        welcomeCloudLeft = 1,
        fetchedAt = 0L
    )

    /** Filleuls réels (2 convertis + 1 en attente) : historique visible. */
    private fun referralGauge() = ReferralGauge.ui(
        "SHALOM-842", converted = 2, rewards = 0,
        entries = listOf(
            ReferralEntry(status = "converted", converted = true),
            ReferralEntry(status = "pending", converted = false),
        )
    )

    private fun dashboard() {
        compose.setContent {
            VitrineTheme {
                DashboardScreen(
                    entitlements = entitles(),
                    welcomeCreditsLeft = 6,
                    onBuy = { },
                    onReferral = { },
                    onSettings = { },
                    merchantName = "Boutique Fatou",
                    sectorLabel = "Restauration",
                    referralCode = "SHALOM-842",
                    referralGauge = referralGauge(),
                    syncState = SyncState.SYNCHRONISE,
                    planExportsLimit = 0,
                    onRetrySync = { },
                    onCreateVideo = { },
                    onCopyCode = { },
                    onShareWhatsApp = { },
                    onViewFilleuls = { },
                    draftSkinName = "Promo douce",
                    draftEtape = "CAMERA",
                    exportsReussis = 2,
                    dernierExportTs = 0L
                )
            }
        }
    }

    // ---- P10-02 : dashboard — bas (exports récents + tab bar) ----
    // NOTE Robolectric : swipeUp() sur onRoot() démarre sur la tab bar ÉPINGLÉE
    // (hors zone scrollable) et ne défile rien — performScrollTo (action
    // sémantique réelle) + assertIsDisplayed prouvent l'état « bas ».
    @Test
    fun dashboard_bas() {
        dashboard()
        compose.onNodeWithText(ctx().getString(R.string.dash_exports_recents))
            .performScrollTo()
            .assertIsDisplayed()
        compose.onNodeWithText(ctx().getString(R.string.dash_tab_create)).assertExists()
        compose.onRoot().save("P10-02_dashboard-bas_APRES.png")
    }

    // ---- P10-03 : dashboard — suite : carte parrainage intégrée ----
    @Test
    fun dashboard_suite_parrainage() {
        dashboard()
        compose.onNodeWithTag("dash_referral_gauge").performScrollTo()
        compose.onNodeWithTag("dash_referral_gauge").assertIsDisplayed()
        compose.onNodeWithText("SHALOM-842", substring = true).assertIsDisplayed()
        compose.onRoot().save("P10-03_dashboard-suite-parrainage_APRES.png")
    }

    // ---- P10-04 : dashboard EN — synchrone ----
    @Test
    @Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
    fun dashboard_en_synchrone() {
        dashboard()
        compose.onNodeWithText(ctx().getString(R.string.dash_hello, "Boutique Fatou"))
            .assertExists()
        compose.onRoot().save("P10-04_dashboard-en-synchrone_APRES.png")
    }

    // ---- P10-08 : réglages EN ----
    @Test
    @Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
    fun reglages_en() {
        compose.setContent {
            VitrineTheme {
                SettingsScreen(
                    accountEmail = "awa@example.com",
                    languageLabel = "English",
                    referralCode = "SHALOM-842",
                    sectorLabel = "Catering",
                    consentsCount = 2,
                    storageUsedLabel = "128 MB",
                )
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.set_title)).assertExists()
        compose.onRoot().save("P10-08_reglages-en_APRES.png")
    }

    // ---- P11-04 : formules — bas (scroll) ----
    @Test
    fun paywall_bas() {
        compose.setContent {
            VitrineTheme {
                PaywallScreen(
                    PaywallMapper.ui(welcomeCreditsLeft = 0, exportsLimit = 0),
                    onChoose = { },
                )
            }
        }
        compose.onNodeWithText(ctx().getString(R.string.paywall_title)).assertExists()
        repeat(4) {
            compose.onRoot().performTouchInput { swipeUp() }
            compose.waitForIdle()
        }
        compose.onNodeWithText(ctx().getString(R.string.paywall_later))
            .performScrollTo()
            .assertIsDisplayed()
        compose.onRoot().save("P11-04_paywall-bas_APRES.png")
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
