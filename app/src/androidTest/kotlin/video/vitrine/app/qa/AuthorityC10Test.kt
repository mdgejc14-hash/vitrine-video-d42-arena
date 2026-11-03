package video.vitrine.app.qa

import androidx.test.ext.junit.runners.AndroidJUnit4
import java.util.UUID
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith

/**
 * C10 (rapport audit) : protocole authority reset -> install -> verify,
 * teste SUR APPAREIL contre le mock staging local. Complement du test JVM
 * C10 (PASS_JVM) : ici la preuve est dynamique, reseau reel de l'appareil.
 * Prérequis : mock-server lance sur l'hote (node mock-server/server.js).
 */
@RunWith(AndroidJUnit4::class)
class AuthorityC10Test {
    private val appId = "video.vitrine.app.qa"
    private val userId = "qa-user-" + UUID.randomUUID()
    private val deviceId = "qa-device-" + UUID.randomUUID()

    private fun ids() = JSONObject()
        .put("appId", appId)
        .put("userId", userId)
        .put("deviceId", deviceId)

    @Test
    fun resetPuisInstallPuisVerify_estValide() {
        val reset = MockEndpoint.post("/authority/reset", ids())
        assertEquals(200, reset.code)
        val token = reset.body.getString("resetToken")
        assertTrue(token.isNotBlank())

        val install = MockEndpoint.post("/authority/install", ids().put("resetToken", token))
        assertEquals(200, install.code)
        assertEquals("INSTALLED", install.body.getString("status"))

        val verify = MockEndpoint.get("/authority/verify?appId=$appId&userId=$userId&deviceId=$deviceId")
        assertEquals(200, verify.code)
        assertTrue(verify.body.getBoolean("isValid"))
    }

    @Test
    fun replayDuMemeResetToken_estRefuse() {
        val reset = MockEndpoint.post("/authority/reset", ids())
        val token = reset.body.getString("resetToken")
        val first = MockEndpoint.post("/authority/install", ids().put("resetToken", token))
        assertEquals(200, first.code)
        val replay = MockEndpoint.post("/authority/install", ids().put("resetToken", token))
        assertEquals(400, replay.code)
    }

    @Test
    fun verifySansInstallation_repond404() {
        val verify = MockEndpoint.get(
            "/authority/verify?appId=$appId&userId=inconnu-${UUID.randomUUID()}&deviceId=x"
        )
        assertEquals(404, verify.code)
        assertFalse(verify.body.has("installation"))
    }
}
