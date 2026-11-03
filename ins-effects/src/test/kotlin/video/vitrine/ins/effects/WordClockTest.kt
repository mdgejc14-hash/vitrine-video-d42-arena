package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class WordClockTest {

    private val words = listOf(
        WordStamp("trois", 3.44, 3.90),
        WordStamp("cent", 3.90, 4.20),
        WordStamp("mille", 4.20, 4.48),
        WordStamp("francs", 4.48, 5.46)
    )

    @Test
    fun `bornes calees sur timecodes de mots`() {
        val bounds = WordClock.boundariesOnWords(words, 2)
        assertEquals(3.44, bounds[0], 0.001)
        assertEquals(5.46, bounds.last(), 0.001)
    }

    @Test
    fun `portes de controle acceptent un beat sheet conforme`() {
        val plans = listOf(
            BeatSheetPlan(0.0, 1.5, "clip", 0.6, 0.5, 0.5, 1.10, 1.02, "glitch", 1.0),
            BeatSheetPlan(1.5, 3.0, "clip", 0.2, 0.5, 0.4, 1.05, 1.00, "cut", 0.0)
        )
        assertTrue(WordClock.validate(plans, 3.0).isEmpty())
    }

    @Test
    fun `porte rejette plan trop long`() {
        val plans = listOf(
            BeatSheetPlan(0.0, 3.5, "clip", 0.0, 0.5, 0.5, 1.0, 1.0, "cut", 0.0)
        )
        assertTrue(WordClock.validate(plans, 3.5).isNotEmpty())
    }
}
