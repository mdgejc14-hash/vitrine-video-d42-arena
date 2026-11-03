package video.vitrine.core.model

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class AdminGateTest {

    @Test
    fun `email configure est administrateur`() {
        assertTrue(AdminGate.isAdmin("Chef@Exemple.com", "chef@exemple.com, auto@vitrine.video"))
    }

    @Test
    fun `email absent ou vide nest pas administrateur`() {
        assertFalse(AdminGate.isAdmin("inconnu@gmail.com", "chef@exemple.com"))
        assertFalse(AdminGate.isAdmin(null, "chef@exemple.com"))
        assertFalse(AdminGate.isAdmin("  ", "chef@exemple.com"))
    }
}
