package video.vitrine.feature.catalog

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import video.vitrine.core.model.GabaritSummary
import video.vitrine.core.model.Sector

/** Logique pure du catalogue E4 V2.0 : filtrage secteur des 30 gabarits. */
class GabaritCatalogTest {

    private fun g(id: String, secteur: String) = GabaritSummary(
        id = id,
        secteur = secteur,
        secteurLibelle = secteur,
        format = "T1_x",
        nomFormatAffiche = "Nouvel arrivage",
        dureeTotaleS = 35,
        nombreScenes = 15,
        nombrePrises = 3,
        ratio = "9:16",
        phraseCourte = "phrase",
        promesse = "promesse"
    )

    private val all = listOf(
        g("batiment_travaux_T1", "batiment_travaux"),
        g("coiffure_beaute_T1", "coiffure_beaute"),
        g("vetements_mode_T4", "vetements_mode")
    )

    @Test
    fun `TOUS montre les 30 sans filtre`() {
        assertEquals(3, GabaritCatalog.visible(all, Sector.TOUS).size)
    }

    @Test
    fun `filtre secteur mappe depuis codes JSON`() {
        assertEquals(listOf("batiment_travaux_T1"), GabaritCatalog.visible(all, Sector.BTP).map { it.id })
        assertEquals(listOf("coiffure_beaute_T1"), GabaritCatalog.visible(all, Sector.COIFFURE).map { it.id })
        assertEquals(listOf("vetements_mode_T4"), GabaritCatalog.visible(all, Sector.MODE).map { it.id })
        assertTrue(GabaritCatalog.visible(all, Sector.IMMO_AUTO).isEmpty())
    }
}
