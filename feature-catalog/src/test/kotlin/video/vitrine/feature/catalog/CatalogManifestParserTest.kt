package video.vitrine.feature.catalog

import org.junit.Assert.assertEquals
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
class CatalogManifestParserTest {

    private val sample = """
        {
          "version": "2026.10.24",
          "min_app_version": "1.0.0",
          "skins": [
            {"id":"F021","name":"Mode Abidjan","sector":"mode","thumb":"https://x/F021.jpg"},
            {"id":"F022","name":"Salon Nokoué","sector":"coiffure","thumb":"https://x/F022.jpg"},
            {"id":"F023","name":"Inconnu","sector":"zzz","thumb":"https://x/F023.jpg"}
          ]
        }
    """.trimIndent()

    @Test
    fun `manifeste JSON 3_7 parse tel quel`() {
        val manifest = CatalogManifestParser.parse(sample)
        assertEquals("2026.10.24", manifest.version)
        assertEquals(3, manifest.skins.size)
        assertEquals(Sector.MODE, manifest.skins[0].sector)
        assertEquals(Sector.COMMERCE, manifest.skins[2].sector)
        assertEquals(1, manifest.bySector(Sector.COIFFURE).size)
        assertTrue(manifest.skins.none { it.isCanary })
    }

    @Test
    fun `canary marque les skins`() {
        val manifest = CatalogManifestParser.parse(sample, canary = true)
        assertTrue(manifest.skins.all { it.isCanary })
    }
}
