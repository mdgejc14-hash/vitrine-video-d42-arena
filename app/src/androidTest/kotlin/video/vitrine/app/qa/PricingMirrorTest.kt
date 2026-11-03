package video.vitrine.app.qa

import androidx.test.ext.junit.runners.AndroidJUnit4
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import video.vitrine.core.model.billing.Plan

/**
 * Regle d'or tarifaire : le mock staging doit miroiter EXACTEMENT la grille
 * officielle de l'app (500 / 3 000 / 7 500 FCFA — contrat 9.1). Toute derive
 * du backend de test est detectee ici avant qu'un test metier ne valide un
 * comportement sur des prix faux.
 */
@RunWith(AndroidJUnit4::class)
class PricingMirrorTest {
    @Test
    fun tarifsMock_sontIdentiquesALenumPlan() {
        val response = MockEndpoint.get("/api/v1/pricing/uemoa")
        assertEquals(200, response.code)
        val plans = response.body.getJSONArray("plans")
        assertEquals(Plan.entries.size, plans.length())
        for (i in 0 until plans.length()) {
            val remote = plans.getJSONObject(i)
            val local = Plan.entries.first { it.code == remote.getString("id") }
            assertEquals(local.priceFcfa, remote.getInt("price_fcfa"))
            if (local.renewDays == null) {
                assertTrue(remote.isNull("renew_days"))
            } else {
                assertEquals(local.renewDays, remote.getInt("renew_days"))
            }
        }
        assertEquals("XOF", response.body.getString("currency"))
    }
}
