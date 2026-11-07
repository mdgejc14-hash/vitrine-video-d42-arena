package video.vitrine.data.audio

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Contrat du parseur bibliothèque BGM (D42.21) : réponse
 * /api/v1/audio/library?secteur=&format= — les 20 variations du gabarit avec
 * sha256. Lecture stricte : toute entrée invalide est ignorée, jamais
 * d'exception (un échec de liste ne doit jamais casser l'export).
 */
class BgmLibraryParserTest {

    private val echantillon = """
        {"pistes":[
          {"piste_id":"musique_t1_vetements_mode_v01","categorie_audio":"musique_t1_vetements_mode",
           "gabarit_id":"vetements_mode_T1","secteur":"vetements_mode","format":"T1","variation":1,
           "bpm":104,"genre":"afrobeats élégant instrumental","origine":"synthese_procedurale_v2",
           "licence":"CC0-1.0","duree_s":40.5,"taille_octets":680123,"statut":"EN_LIGNE",
           "sha256":"e7695fb26b98e7b3000000000000000000000000000000000000000000000000"},
          {"piste_id":"musique_t1_vetements_mode_v02","categorie_audio":"musique_t1_vetements_mode",
           "gabarit_id":"vetements_mode_T1","secteur":"vetements_mode","format":"T1","variation":2,
           "bpm":101,"genre":"afrobeats élégant instrumental","origine":"synthese_procedurale_v2",
           "licence":"CC0-1.0","duree_s":41.0,"taille_octets":690456,"statut":"EN_LIGNE",
           "sha256":"b42fb993b48687cc0000000000000000000000000000000000000000000000000"}
        ],"count":2,"total":600}
    """.trimIndent()

    @Test
    fun `reponse valide parsee integralement`() {
        val variations = BgmLibraryParser.parse(echantillon)
        assertEquals(2, variations.size)
        val v1 = variations[0]
        assertEquals("musique_t1_vetements_mode_v01", v1.pisteId)
        assertEquals("musique_t1_vetements_mode", v1.categorieAudio)
        assertEquals("vetements_mode_T1", v1.gabaritId)
        assertEquals(1, v1.variation)
        assertEquals(680123L, v1.tailleOctets)
        assertEquals(40.5, v1.dureeS, 0.001)
        assertEquals("EN_LIGNE", v1.statut)
        assertTrue(v1.sha256.startsWith("e7695fb2"))
    }

    @Test
    fun `entree sans sha256 est ignoree (integrite obligatoire)`() {
        val json = """
            {"pistes":[
              {"piste_id":"x_v01","categorie_audio":"musique_t1_x","gabarit_id":"x_T1",
               "variation":1,"statut":"EN_LIGNE","sha256":""}
            ]}
        """.trimIndent()
        assertTrue(BgmLibraryParser.parse(json).isEmpty())
    }

    @Test
    fun `reponses invalides donnent une liste vide sans exception`() {
        assertNull(null)
        assertTrue(BgmLibraryParser.parse(null).isEmpty())
        assertTrue(BgmLibraryParser.parse("").isEmpty())
        assertTrue(BgmLibraryParser.parse("pas du tout du json").isEmpty())
        assertTrue(BgmLibraryParser.parse("{\"pistes\":null}").isEmpty())
        assertTrue(BgmLibraryParser.parse("{}").isEmpty())
    }
}
