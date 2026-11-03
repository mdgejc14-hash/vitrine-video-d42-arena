package video.vitrine.data.gabarits

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/** Formulaire E5 parse depuis le gabarit source T1 (maquette E5_batiment_travaux_T1_Brief). */
class GabaritBriefTest {

    private val brief = GabaritJson.parseBrief(
        javaClass.getResourceAsStream("/fixtures/batiment_travaux_T1.json")!!
            .readBytes().decodeToString()
    )

    @Test
    fun `7 champs et 5 sections dont options repliees`() {
        assertEquals(7, brief.fields.size)
        assertEquals(5, brief.sections.size)
        assertTrue(brief.sections.last().optional)
        assertFalse(brief.sections.first().optional)
    }

    @Test
    fun `tutoiement maquette applique aux libelles`() {
        assertEquals("Ton commerce et ton WhatsApp", brief.sections[0].title)
        assertEquals("Ce que tu proposes", brief.sections[1].title)
        assertEquals("Où te trouver", brief.sections[3].title)
        assertEquals("Nom de ton commerce", brief.fields.first { it.id == "nom_commerce" }.label)
        assertTrue(brief.fields.first { it.id == "nom_commerce" }.help.startsWith("Écris le nom"))
    }

    @Test
    fun `obligatoires et devise par defaut source`() {
        assertTrue(brief.fields.first { it.id == "prix" }.required)
        assertFalse(brief.fields.first { it.id == "badge_engagement_actif" }.required)
        assertEquals("FCFA", brief.defaultCurrency)
        assertEquals("Bâtiment & Travaux", brief.sectorLabel)
        assertEquals("Nouvel arrivage", brief.formatLabel)
    }
}
