package video.vitrine.feature.dashboard

import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.onRoot
import androidx.compose.ui.graphics.asAndroidBitmap
import java.io.File
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.core.designsystem.VitrineTheme

/**
 * VV Remote QA s5 : assertions semantiques des tarifs exacts (500 / 3 000 /
 * 7 500 FCFA), footnote parite BCEAO zone EUR, et controle pixel des aplats
 * charte (#F95C0F orange, #022358 bleu nuit) sur capture non compressee.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class PaywallUiCheckTest {

    @get:Rule
    val compose = createComposeRule()

    @Test
    fun `tarifs exacts UEMOA et tags stables`() {
        compose.setContent {
            VitrineTheme {
                PaywallScreen(PaywallMapper.ui(welcomeCreditsLeft = 0, exportsLimit = 0)) { }
            }
        }
        compose.onNodeWithText("  ·  500 FCFA").assertExists()
        compose.onNodeWithText("  ·  3 000 FCFA / 30 j").assertExists()
        compose.onNodeWithText("  ·  7 500 FCFA / 30 j").assertExists()
        compose.onNodeWithTag("paywall_pass24h").assertExists()
        compose.onNodeWithTag("paywall_pro").assertExists()
        compose.onNodeWithTag("paywall_boutique").assertExists()
    }

    @Test
    fun `footnote parite BCEAO zone EUR`() {
        compose.setContent {
            VitrineTheme {
                PaywallScreen(
                    PaywallMapper.ui(
                        welcomeCreditsLeft = 0,
                        exportsLimit = 0,
                        zone = PaywallZone.MONDE
                    )
                ) { }
            }
        }
        compose.onNodeWithText(
            "Equivalents indicatifs au taux fixe BCEAO : 1 EUR = 655,957 FCFA. " +
                "La devise de facturation reelle reste a valider."
        ).assertExists()
    }

    @Test
    fun `aplats charte presents dans la capture`() {
        compose.setContent {
            VitrineTheme {
                PaywallScreen(PaywallMapper.ui(welcomeCreditsLeft = 0, exportsLimit = 0)) { }
            }
        }
        val bitmap = compose.onRoot().captureToImage().asAndroidBitmap()
        val out = File("build/visual-check")
        out.mkdirs()
        val png = File(out, "paywall-uemoa.png")
        png.outputStream().use { stream ->
            bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, stream)
        }
        var orange = false
        var nuit = false
        for (x in 0 until bitmap.width step 4) {
            for (y in 0 until bitmap.height step 4) {
                val p = bitmap.getPixel(x, y)
                val r = (p shr 16) and 0xFF
                val g = (p shr 8) and 0xFF
                val b = p and 0xFF
                if (r == 0xF9 && g == 0x5C && b == 0x0F) orange = true
                if (r == 0x02 && g == 0x23 && b == 0x58) nuit = true
            }
        }
        assertTrue("aplat orange #F95C0F absent", orange)
        assertTrue("aplat bleu nuit #022358 absent", nuit)
    }
}
