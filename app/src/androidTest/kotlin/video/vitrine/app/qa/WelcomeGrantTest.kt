package video.vitrine.app.qa

import androidx.test.ext.junit.runners.AndroidJUnit4
import java.util.UUID
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import video.vitrine.core.model.billing.Plan

/**
 * D13 : grant de bienvenue UNE fois par empreinte (SSO sans telephone).
 * Verifie sur appareil contre le mock staging : premiere demande = granted,
 * seconde demande meme empreinte = refused, et credits = WELCOME_CREDITS.
 */
@RunWith(AndroidJUnit4::class)
class WelcomeGrantTest {
    @Test
    fun grantBienvenue_estUniqueParEmpreinte() {
        val fingerprint = "fp-qa-" + UUID.randomUUID()
        val first = MockEndpoint.post(
            "/api/v1/me/welcome-grant",
            JSONObject().put("fingerprint", fingerprint)
        )
        assertEquals(200, first.code)
        assertTrue(first.body.getBoolean("granted"))
        assertEquals(Plan.WELCOME_CREDITS, first.body.getInt("credits_total"))

        val second = MockEndpoint.post(
            "/api/v1/me/welcome-grant",
            JSONObject().put("fingerprint", fingerprint)
        )
        assertEquals(200, second.code)
        assertFalse(second.body.getBoolean("granted"))
        assertEquals(Plan.WELCOME_CREDITS, second.body.getInt("credits_total"))
    }
}
