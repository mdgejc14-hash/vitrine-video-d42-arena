package video.vitrine.feature.dashboard

import android.content.Context
import androidx.compose.ui.test.assertCountEquals
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onRoot
import androidx.compose.ui.test.performClick
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
import video.vitrine.data.local.EntitlementsCache

/**
 * D42.32 (Lots 5/6) — controle visuel du dashboard reconcu :
 * - badge « COMPTE » supprime, en-tete pro (identite + bienvenue + secteur)
 * - carte credits : exports restants + rendus cloud + sync HONNETE
 *   (jamais « Synchronise » sans preuve, plus de « Droits non synchronises »)
 * - action principale « Creer une video »
 * - code parrain VISIBLE SANS DEFILEMENT + « Copier mon code » + progression
 * Capture PNG dans build/visual-check/ (preuve D42.32, Phase B avant/apres).
 */
@RunWith(RobolectricTestRunner::class)
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class DashboardVisualCheckTest {

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

    private fun entitlesTest(): EntitlementsCache = EntitlementsCache(
        merchantId = "test-d42-32",
        watermark = false,
        endcardMention = true,
        maxRes = "1080p",
        exportsLimit = 6,
        fairUse = null,
        cloudRenders = 1,
        brandKit = false,
        cacheDays = 1,
        welcomeCreditsLeft = 6,
        welcomeCloudLeft = 1,
        fetchedAt = 0L
    )

    @Test
    @Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
    fun `dashboard synchronise - en tete pro, credits, code visible`() {
        val ctx = contexte()
        compose.setContent {
            VitrineTheme {
                DashboardScreen(
                    entitlements = entitlesTest(),
                    welcomeCreditsLeft = 6,
                    onBuy = { },
                    onReferral = { },
                    onSettings = { },
                    merchantName = "Boutique Fatou",
                    sectorLabel = "Restauration",
                    referralCode = "SHALOM-842",
                    referralGauge = ReferralGauge.ui(
                        "SHALOM-842", converted = 3, rewards = 0, entries = emptyList()
                    ),
                    syncState = SyncState.SYNCHRONISE,
                    onRetrySync = { },
                    onCreateVideo = { },
                    onCopyCode = { },
                    onShareWhatsApp = { },
                    onViewFilleuls = { }
                )
            }
        }
        // Lot 5 : badge « COMPTE » supprime (plus jamais de mot empile)
        compose.onAllNodesWithText("COMPTE").assertCountEquals(0)
        compose.onAllNodesWithText("ACCOUNT").assertCountEquals(0)
        // en-tete pro : identite + bienvenue nommee + secteur
        compose.onNodeWithText(ctx.getString(R.string.dash_app_name)).assertExists()
        compose.onNodeWithText(ctx.getString(R.string.dash_hello, "Boutique Fatou")).assertExists()
        compose.onNodeWithText("Restauration").assertExists()
        // carte credits : exports restants + details reels + sync prouvee
        compose.onNodeWithText(ctx.getString(R.string.dash_exports_left_label)).assertExists()
        compose.onNodeWithText(ctx.getString(R.string.dash_exports_count, 6)).assertExists()
        compose.onNodeWithText(
            ctx.getString(R.string.dash_quality_no_wm, "1080p"), substring = true
        ).assertExists()
        compose.onNodeWithText(ctx.getString(R.string.sync_synced)).assertExists()
        // action principale
        compose.onNodeWithText(ctx.getString(R.string.dash_create_video)).assertExists()
        // Lot 6 : code personnel visible sans defilement + copie + partage
        compose.onNodeWithText("SHALOM-842").assertExists()
        compose.onNodeWithText(ctx.getString(R.string.ref_copy_mine)).assertExists()
        compose.onNodeWithText(ctx.getString(R.string.ref_share_whatsapp)).assertExists()
        // progression vers le palier suivant (3 convertis -> 3/5)
        compose.onNodeWithText(
            ctx.getString(R.string.ref2_sub_label, 3, 5, 2), substring = true
        ).assertExists()
        capturer("d42-32-lot5-dashboard-synchrone-fr.png")
    }

    @Test
    @Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
    fun `dashboard hors connexion - etat honnete et reessayer`() {
        val ctx = contexte()
        compose.setContent {
            VitrineTheme {
                DashboardScreen(
                    entitlements = null,
                    welcomeCreditsLeft = 0,
                    onBuy = { },
                    onReferral = { },
                    onSettings = { },
                    merchantName = "",
                    sectorLabel = "",
                    referralCode = "",
                    referralGauge = null,
                    syncState = SyncState.HORS_CONNEXION,
                    onRetrySync = { },
                    onCreateVideo = { },
                    onCopyCode = { },
                    onShareWhatsApp = { },
                    onViewFilleuls = { }
                )
            }
        }
        // etat honnete : hors connexion + bouton Reessayer
        compose.onNodeWithText(ctx.getString(R.string.sync_offline)).assertExists()
        compose.onNodeWithText(ctx.getString(R.string.sync_retry)).assertExists()
        // jamais « Synchronise » sans preuve dans cet etat
        compose.onAllNodesWithText(ctx.getString(R.string.sync_synced)).assertCountEquals(0)
        // l'ancien message trompeur a disparu (cle retiree, texte introuvable)
        compose.onAllNodesWithText("Droits non synchronises", substring = true).assertCountEquals(0)
        // code parrain : message honnete, pas de code invente
        compose.onNodeWithText(ctx.getString(R.string.ref_code_pending)).assertExists()
        capturer("d42-32-lot5-dashboard-hors-connexion-en.png")
    }

    @Test
    @Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
    fun `ecran parrainage - historique repliable`() {
        val ctx = contexte()
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
        // ouvert par defaut : le bouton propose de masquer
        compose.onNodeWithText(ctx.getString(R.string.ref2_history_hide, 2)).assertExists()
        compose.onNodeWithText(ctx.getString(R.string.ref2_status_pending), substring = true)
            .assertExists()
        // repli : l'historique disparait, le bouton propose d'afficher
        compose.onNodeWithText(ctx.getString(R.string.ref2_history_hide, 2)).performClick()
        compose.onNodeWithText(ctx.getString(R.string.ref2_history_show, 2)).assertExists()
        compose.onAllNodesWithText(
            ctx.getString(R.string.ref2_filleul_n, 2), substring = true
        ).assertCountEquals(0)
        capturer("d42-32-lot6-parrainage-historique-replie-fr.png")
    }
}
