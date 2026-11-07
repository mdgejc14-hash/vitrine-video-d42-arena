package video.vitrine.data.audio

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import kotlin.random.Random

/**
 * Contrat de sélection D42.21 : UNE musique parmi les 20 variations du gabarit.
 * Propriétés (Property-Based Testing — vérifiées sur un grand nombre de tirages) :
 *  - jamais une piste d'un autre gabarit ou secteur, même si la liste est corrompue ;
 *  - jamais une piste non EN_LIGNE ;
 *  - anti-répétition : les K dernières utilisées ne ressortent pas s'il existe
 *    une alternative ;
 *  - uniformité approximative sur grand N ;
 *  - déterminisme avec Random seedé (tests reproductibles) ;
 *  - liste vide → null (repli titulaire côté appelant).
 */
class BgmSelectionTest {

    private fun variations(
        gabarit: String = "coiffure_beaute_T1",
        n: Int = 20,
        statut: String = "EN_LIGNE"
    ): List<BgmLibraryParser.Variation> = (1..n).map { v ->
        BgmLibraryParser.Variation(
            pisteId = "musique_t1_coiffure_beaute_v%02d".format(v),
            categorieAudio = "musique_t1_coiffure_beaute",
            gabaritId = gabarit,
            variation = v,
            sha256 = "sha%02d".format(v),
            tailleOctets = 700_000L,
            dureeS = 40.0,
            statut = statut
        )
    }

    @Test
    fun `liste vide donne null`() {
        assertNull(BgmSelection.choisir(emptyList(), "x_T1"))
    }

    @Test
    fun `jamais de piste d un autre gabarit meme si la reponse est corrompue`() {
        val corrompue = variations() + variations(gabarit = "restaurants_maquis_T1", n = 20)
        val random = Random(42)
        repeat(500) {
            val choisie = BgmSelection.choisir(corrompue, "coiffure_beaute_T1", random = random)
            assertTrue(choisie != null)
            assertEquals("coiffure_beaute_T1", choisie!!.gabaritId)
        }
    }

    @Test
    fun `les pistes non EN_LIGNE ne sont jamais choisies`() {
        val melangee = variations(n = 20, statut = "HORS_LIGNE") + variations(n = 5, statut = "EN_LIGNE")
        val random = Random(7)
        repeat(200) {
            val choisie = BgmSelection.choisir(melangee, "coiffure_beaute_T1", random = random)
            assertEquals("EN_LIGNE", choisie!!.statut)
        }
    }

    @Test
    fun `anti repetition - les 4 dernieres utilisees sont exclues quand c est possible`() {
        val liste = variations()
        val historique = listOf(
            "musique_t1_coiffure_beaute_v03",
            "musique_t1_coiffure_beaute_v07",
            "musique_t1_coiffure_beaute_v11",
            "musique_t1_coiffure_beaute_v15"
        )
        val random = Random(1234)
        repeat(300) {
            val choisie = BgmSelection.choisir(liste, "coiffure_beaute_T1", historique, random)
            assertTrue(choisie!!.pisteId !in historique)
        }
    }

    @Test
    fun `anti repetition saturee - retombe sur l ensemble complet sans echouer`() {
        val liste = variations(n = 3)
        val historique = listOf("musique_t1_coiffure_beaute_v01", "musique_t1_coiffure_beaute_v02",
            "musique_t1_coiffure_beaute_v03", "musique_t1_coiffure_beaute_v02")
        val choisie = BgmSelection.choisir(liste, "coiffure_beaute_T1", historique, Random(5))
        assertTrue(choisie != null)
    }

    @Test
    fun `uniformite approximative sur grand N`() {
        val liste = variations(n = 20)
        val compteur = mutableMapOf<Int, Int>()
        val random = Random(2026)
        repeat(20_000) {
            val choisie = BgmSelection.choisir(liste, "coiffure_beaute_T1", random = random)!!
            compteur[choisie.variation] = (compteur[choisie.variation] ?: 0) + 1
        }
        assertEquals(20, compteur.size) // toutes touchées
        val attendu = 20_000 / 20
        compteur.values.forEach { c ->
            // loi multinomiale : ±15 % de l'attendu avec marge très large
            assertTrue("tirage $c hors bornes pour attendu $attendu", c in attendu * 85 / 100..attendu * 115 / 100)
        }
    }

    @Test
    fun `determinisme - meme seed meme suite de choix`() {
        val liste = variations()
        val a = Random(987)
        val b = Random(987)
        repeat(50) {
            assertEquals(
                BgmSelection.choisir(liste, "coiffure_beaute_T1", random = a),
                BgmSelection.choisir(liste, "coiffure_beaute_T1", random = b)
            )
        }
    }

    @Test
    fun `historique borne a HISTOIRE_TAILLE`() {
        val h = BgmSelection.pousserHistorique(listOf("a", "b", "c", "d"), "e")
        assertEquals(listOf("b", "c", "d", "e"), h)
        assertEquals(
            listOf("c", "d", "e"),
            BgmSelection.pousserHistorique(listOf("c", "d", "e"), "c").distinct()
        )
        assertTrue(BgmSelection.pousserHistorique(emptyList(), "x").size == 1)
    }
}
