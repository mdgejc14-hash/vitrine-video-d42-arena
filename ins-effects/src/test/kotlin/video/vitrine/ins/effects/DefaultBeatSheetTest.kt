package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class DefaultBeatSheetTest {

    private val script = "Trois poulets fermiers a 3000 francs seulement chez moi aujourd'hui"

    @Test
    fun `horloge estimee couvre toute la duree voix`() {
        val words = DefaultBeatSheet.wordClock(script, 6.0)
        assertEquals(0.0, words.first().startS, 0.001)
        assertEquals(6.0, words.last().endS, 0.001)
        assertEquals(10, words.size)
    }

    @Test
    fun `beat sheet par defaut respecte les portes de controle`() {
        val sheet = DefaultBeatSheet.fromScript(script, 6.0, emptyList())
        assertTrue(sheet.plans.isNotEmpty())
        assertTrue(WordClock.validate(sheet.plans, 6.0).isEmpty())
        assertTrue(sheet.keywords.contains("3000"))
    }

    @Test
    fun `beat grid du gabarit prioritaire sur uniforme`() {
        val sheet = DefaultBeatSheet.fromScript(script, 6.0, listOf(2.0, 4.0))
        assertEquals(2.0, sheet.plans[0].t1, 0.001)
        assertEquals(4.0, sheet.plans[1].t1, 0.001)
    }
}
