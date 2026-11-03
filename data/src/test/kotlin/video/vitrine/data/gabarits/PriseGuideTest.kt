package video.vitrine.data.gabarits

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** Guide prises E6 parse depuis T1 source (maquettes E6_batiment_travaux_*). */
class PriseGuideTest {

    private val prises = GabaritJson.parsePrises(
        javaClass.getResourceAsStream("/fixtures/batiment_travaux_T1.json")!!
            .readBytes().decodeToString()
    )

    @Test
    fun `3 prises avec durees cibles source`() {
        assertEquals(3, prises.size)
        assertEquals(12, prises[0].targetS)
        assertEquals("Le chantier et les matériaux", prises[0].label)
    }

    @Test
    fun `consignes tutoyees sans casser assez`() {
        val c = prises[0].cameraInstruction
        assertTrue(c.startsWith("Commence par montrer"))
        assertTrue(c.contains("Tiens ton téléphone"))
        assertTrue(c.contains("assez"))
    }

    @Test
    fun `segment parole unique avec exemple et temps conseille`() {
        assertEquals(1, prises[0].segments.size)
        val seg = prises[0].segments[0]
        assertEquals("Voici le chantier.", seg.example)
        assertEquals(2.0, seg.advisedS, 0.001)
        assertEquals(0, prises[1].segments.size)
    }
}
