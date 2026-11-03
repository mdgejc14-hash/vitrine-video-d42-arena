package video.vitrine.feature.brief

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class BriefValidatorTest {

    @Test
    fun `script court ou duree hors bornes refuses`() {
        assertFalse(BriefValidator.validate("trop court", 30, "visites").valid)
        assertFalse(BriefValidator.validate("Un script suffisamment long pour passer.", 5, "visites").valid)
        assertFalse(BriefValidator.validate("Un script suffisamment long pour passer.", 30, " ").valid)
        assertTrue(BriefValidator.validate("Bienvenue chez nous, nous coiffons toute la famille.", 30, "visites").valid)
    }

    @Test
    fun `chaque refus porte sa ressource traduisable et ses arguments`() {
        // D41 (F67) : le validateur ne renvoie plus de FRANCAIS en dur — chaque
        // erreur porte un id de ressource (traduit FR/EN/ES/JA) + args bornes.
        val court = BriefValidator.validate("trop court", 30, "visites")
        assertEquals(R.string.brief_err_min, court.messageRes)
        assertEquals(listOf(BriefValidator.SCRIPT_MIN), court.messageArgs)
        val long = BriefValidator.validate("x".repeat(BriefValidator.SCRIPT_MAX + 1), 30, "visites")
        assertEquals(R.string.brief_err_max, long.messageRes)
        val duree = BriefValidator.validate("Un script suffisamment long pour passer.", 5, "visites")
        assertEquals(R.string.brief_err_duration, duree.messageRes)
        assertEquals(
            listOf(BriefValidator.DURATION_MIN_S, BriefValidator.DURATION_MAX_S),
            duree.messageArgs
        )
        val objectif = BriefValidator.validate("Un script suffisamment long pour passer.", 30, " ")
        assertEquals(R.string.brief_err_objective, objectif.messageRes)
        val ok = BriefValidator.validate("Bienvenue chez nous, nous coiffons toute la famille.", 30, "visites")
        assertNull(ok.messageRes)
    }

    @Test
    fun `scenes decoupees pour sous-titres`() {
        val script = "Bonjour. Nous cuisinons. Venez nombreux."
        val scenes = BriefValidator.splitScenes(script)
        assertEquals(3, scenes.size)
        assertEquals("Bonjour", scenes[0])
        val long = (1..12).joinToString(". ") { "Scene $it" }
        assertEquals(6, BriefValidator.splitScenes(long, 6).size)
    }
}
