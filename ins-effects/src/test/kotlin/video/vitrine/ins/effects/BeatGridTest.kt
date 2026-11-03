package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Test

class BeatGridTest {
    @Test
    fun `beat index et durees de scene`() {
        val grid = BeatGrid.fromEdl(listOf(11.8, 3.2, 19.4))
        assertEquals(listOf(3.2, 11.8, 19.4), grid.dropAtSeconds)
        assertEquals(-1, grid.beatIndexAt(1.0))
        assertEquals(0, grid.beatIndexAt(3.2))
        assertEquals(1, grid.beatIndexAt(12.0))
        assertEquals(2, grid.beatIndexAt(99.0))
        assertEquals(8.6, grid.sceneDuration(0, 30.0), 1e-9)
        assertEquals(10.6, grid.sceneDuration(2, 30.0), 1e-9)
    }

    @Test
    fun `beat-grid invalide refusee`() {
        assertThrows(IllegalArgumentException::class.java) { BeatGrid(listOf(2.0, 2.0)) }
        assertThrows(IllegalArgumentException::class.java) { BeatGrid(listOf(-1.0)) }
    }
}
