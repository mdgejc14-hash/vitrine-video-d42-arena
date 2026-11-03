package video.vitrine.data.audio

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Contrat du parseur catalogue BGM (réponse Phase C /api/v1/audio/catalog) :
 * lecture stricte — toute réponse invalide donne une liste vide, jamais
 * d'exception (le prefetch ne doit jamais casser la navigation catalogue).
 */
class BgmCatalogParserTest {

    private val echantillon = """
        {"pistes":[
          {"categorie_audio":"musique_t1_vetements_mode","gabarit_id":"vetements_mode_T1",
           "secteur":"vetements_mode","format":"T1","genre":"afrobeats élégant instrumental",
           "bpm_min":100,"bpm_max":112,"duree_gabarit_s":35,"disponible":true},
          {"categorie_audio":"musique_t5_restaurants_maquis","gabarit_id":"restaurants_maquis_T5",
           "secteur":"restaurants_maquis","format":"T5","genre":"afro-soul maquis instrumental",
           "bpm_min":78,"bpm_max":96,"duree_gabarit_s":40,"disponible":false}
        ],"count":2}
    """.trimIndent()

    @Test
    fun `reponse valide parsee integralement`() {
        val pistes = BgmCatalogParser.parse(echantillon)
        assertEquals(2, pistes.size)
        val t1 = pistes[0]
        assertEquals("musique_t1_vetements_mode", t1.categorieAudio)
        assertEquals("vetements_mode_T1", t1.gabaritId)
        assertEquals(100, t1.bpmMin)
        assertEquals(112, t1.bpmMax)
        assertEquals(35.0, t1.dureeGabaritS, 0.001)
        assertTrue(t1.disponible)
        assertTrue(!pistes[1].disponible)
    }

    @Test
    fun `reponses invalides donnent une liste vide sans exception`() {
        assertTrue(BgmCatalogParser.parse(null).isEmpty())
        assertTrue(BgmCatalogParser.parse("").isEmpty())
        assertTrue(BgmCatalogParser.parse("{ ceci n'est pas du JSON").isEmpty())
        assertTrue(BgmCatalogParser.parse("""{"pistes":"pas_un_tableau"}""").isEmpty())
    }

    @Test
    fun `entree sans cle obligatoire est ignoree`() {
        val partiel = """
            {"pistes":[
              {"categorie_audio":"","gabarit_id":"x_T1"},
              {"categorie_audio":"musique_t1_x","gabarit_id":"x_T1","secteur":"x","format":"T1"}
            ]}
        """.trimIndent()
        val pistes = BgmCatalogParser.parse(partiel)
        assertEquals(1, pistes.size)
        assertEquals("musique_t1_x", pistes[0].categorieAudio)
    }
}
