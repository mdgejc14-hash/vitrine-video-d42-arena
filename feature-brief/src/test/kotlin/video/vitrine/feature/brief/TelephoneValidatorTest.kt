package video.vitrine.feature.brief

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * D42.30-09 — RCA run 8c9f514 : le champ WhatsApp du brief camerap recevait
 * une valeur INVALIDE (le « + » perdu à l'injection + re-remplissages avec
 * effacement partiel → concaténation) et le bouton Continuer, correctement,
 * restait désactivé. La validation elle-même est Saine (vérifié JVM :
 * libphonenumber 8.13.50 connaît le Bénin 10 chiffres « 01 »).
 * Ce test verrouille les formes acceptées/refusées, dont la nouvelle
 * tolérance « indicatif collé sans + » (clavier qui perd le « + »).
 */
class TelephoneValidatorTest {

    private val BJ = TelephoneValidator.PAYS_DEFAUT

    @Test
    fun `forme nationale béninoise 10 chiffres acceptée`() {
        assertEquals("+2290197000000", TelephoneValidator.versE164("0197000000", BJ))
        assertEquals("+2290197000000", TelephoneValidator.versE164("01 97 00 00 00", BJ))
    }

    @Test
    fun `collage international complet accepté et pays détecté`() {
        val (region, formeNationale) = TelephoneValidator.depuisInternational("+2290197000000")!!
        assertEquals("BJ", region)
        assertEquals("01 97 00 00 00", formeNationale)
        // la forme nationale re-publiée reste valide (aller-retour champ -> E.164)
        assertEquals("+2290197000000", TelephoneValidator.versE164(formeNationale, region))
    }

    @Test
    fun `indicatif colle sans plus toléré apres echec direct`() {
        // D42.30-09 : « 2290197000000 » (le + perdu au clavier) doit passer.
        assertEquals("+2290197000000", TelephoneValidator.versE164("2290197000000", BJ))
    }

    @Test
    fun `ancien format 8 chiffres toujours valide en transition`() {
        assertEquals("+22997000000", TelephoneValidator.versE164("97000000", BJ))
        assertEquals("+22997000000", TelephoneValidator.versE164("97 00 00 00", BJ))
    }

    @Test
    fun `nombres invalides refuses`() {
        assertNull(TelephoneValidator.versE164("1234", BJ))                    // trop court
        assertNull(TelephoneValidator.versE164("2290197000000123456", BJ))    // concaténation de re-remplissage
        assertNull(TelephoneValidator.versE164("019700000", BJ))              // 9 chiffres
        assertNull(TelephoneValidator.versE164("", BJ))                       // vide
        assertTrue(TelephoneValidator.estValide("+2290197000000"))
        assertFalse(TelephoneValidator.estValide("+2291234"))
    }

    @Test
    fun `exemple affiche est un numero valide du pays`() {
        val exemple = TelephoneValidator.exemplePays(BJ)
        assertNotNull(exemple)
        assertTrue(TelephoneValidator.estValide(exemple!!))
        // l'exemple généré (pas codé en dur) est bien le nouveau format 10 chiffres
        assertTrue(exemple.replace(" ", "").startsWith("+22901"))
    }

    @Test
    fun `autre pays indicatif et detection`() {
        assertEquals("+33", TelephoneValidator.indicatif("FR"))
        val (region, forme) = TelephoneValidator.depuisInternational("+33612345678")!!
        assertEquals("FR", region)
        assertEquals("06 12 34 56 78", forme)
        assertEquals("+33612345678", TelephoneValidator.versE164("06 12 34 56 78", "FR"))
        // indicatif collé sans + toléré aussi pour la France
        assertEquals("+33612345678", TelephoneValidator.versE164("33612345678", "FR"))
    }
}
