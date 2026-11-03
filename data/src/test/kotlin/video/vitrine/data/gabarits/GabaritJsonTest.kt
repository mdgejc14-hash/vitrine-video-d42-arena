package video.vitrine.data.gabarits

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import video.vitrine.core.model.Sector
import video.vitrine.core.model.sectorFromGabaritCode

/**
 * Validateur JVM du parseur des gabarits V2.0 sur 3 fixtures reelles
 * (copies conformes de l'archive Drive) + table de correspondance secteurs.
 * Les 30 JSON restent par ailleurs valides par les scripts Python
 * content/gabarits_v2/contrats_et_validation (errors=0).
 */
class GabaritJsonTest {

    private fun fixture(name: String): String =
        javaClass.getResourceAsStream("/fixtures/$name.json")!!
            .readBytes()
            .decodeToString()

    @Test
    fun `T1 batiment_travaux parse aux valeurs source`() {
        val g = GabaritJson.parse(fixture("batiment_travaux_T1"))
        assertEquals("batiment_travaux_T1", g.id)
        assertEquals("batiment_travaux", g.secteur)
        assertEquals("Bâtiment & Travaux", g.secteurLibelle)
        assertEquals("Nouvel arrivage", g.nomFormatAffiche)
        assertEquals(35, g.dureeTotaleS)
        assertEquals(15, g.nombreScenes)
        assertEquals(3, g.nombrePrises)
        assertEquals("9:16", g.ratio)
        assertTrue(g.phraseCourte.startsWith("On montre le chantier"))
        assertTrue(g.promesse.isNotEmpty())
    }

    @Test
    fun `T5 coiffure_beaute parse aux valeurs source`() {
        val g = GabaritJson.parse(fixture("coiffure_beaute_T5"))
        assertEquals("coiffure_beaute_T5", g.id)
        assertEquals("Un client raconte", g.nomFormatAffiche)
        assertEquals(50, g.dureeTotaleS)
        assertEquals(13, g.nombreScenes)
        assertEquals(2, g.nombrePrises)
    }

    @Test
    fun `T4 vetements_mode parse aux valeurs source`() {
        val g = GabaritJson.parse(fixture("vetements_mode_T4"))
        assertEquals("vetements_mode_T4", g.id)
        assertEquals("Promotion", g.nomFormatAffiche)
        assertEquals(33, g.dureeTotaleS)
        assertEquals(17, g.nombreScenes)
        assertEquals(2, g.nombrePrises)
    }

    @Test
    fun `correspondance secteurs JSON vers Sector enum`() {
        assertEquals(Sector.BTP, sectorFromGabaritCode("batiment_travaux"))
        assertEquals(Sector.COIFFURE, sectorFromGabaritCode("coiffure_beaute"))
        assertEquals(Sector.IMMO_AUTO, sectorFromGabaritCode("immo_auto"))
        assertEquals(Sector.RESTAURATION, sectorFromGabaritCode("restaurants_maquis"))
        assertEquals(Sector.COMMERCE, sectorFromGabaritCode("shops_small_business"))
        assertEquals(Sector.MODE, sectorFromGabaritCode("vetements_mode"))
        assertNull(sectorFromGabaritCode("inconnu"))
        assertNull(sectorFromGabaritCode(null))
    }
}
