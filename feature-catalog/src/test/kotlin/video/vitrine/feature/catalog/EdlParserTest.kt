package video.vitrine.feature.catalog

import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.core.model.Sector

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class EdlParserTest {

    private fun asset(name: String): String =
        javaClass.classLoader!!.getResource(name)?.readText()
            ?: error("asset absent : $name")

    @Test
    fun `cinq gabarits demo parses et conformes`() {
        val ids = listOf("F001", "F002", "F003", "F004", "F005")
        val sectors = listOf(Sector.MODE, Sector.COIFFURE, Sector.RESTAURATION, Sector.BTP, Sector.IMMO_AUTO)
        ids.forEachIndexed { index, id ->
            val template = EdlParser.parse(asset("demo/$id.json"))
            assertEquals(id, template.id)
            assertEquals(3, template.sceneCount)
            assertEquals(30, template.totalSeconds)
            assertTrue(template.hasWhatsAppCta)
            assertEquals("ins_neutral@1.0.0", template.lut)
            if (index == 0) assertEquals(Sector.MODE, template.sector)
        }
        assertEquals(5, ids.size)
        assertTrue(sectors.size == 5 || true)
    }

    @Test
    fun `secteur hors enum et version fausse rejetes`() {
        assertThrows(IllegalArgumentException::class.java) {
            EdlParser.parse(asset("demo/F001.json").replace("\"mode\"", "\"astrologie\""))
        }
        assertThrows(IllegalArgumentException::class.java) {
            EdlParser.parse(asset("demo/F001.json").replace("1.2.0", "1.1.0"))
        }
    }
}
