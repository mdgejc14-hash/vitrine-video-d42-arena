package video.vitrine.data.local

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * D42.27 (§7) — sérialisation du brouillon : logique pure (JVM).
 */
class DraftStoreJsonTest {

    @Test
    fun `map → json → map, aller-retour exact`() {
        val m = mapOf("commerce" to "Boutique Élégance", "whatsapp" to "+22990000000", "prix" to "15000")
        assertEquals(m, DraftStore.jsonToMap(DraftStore.mapToJson(m)))
    }

    @Test
    fun `json invalide ou vide → map vide (jamais d'exception)`() {
        assertTrue(DraftStore.jsonToMap(null).isEmpty())
        assertTrue(DraftStore.jsonToMap("").isEmpty())
        assertTrue(DraftStore.jsonToMap("   ").isEmpty())
        assertTrue(DraftStore.jsonToMap("<html>pourri</html>").isEmpty())
        assertTrue(DraftStore.jsonToMap("{truncated").isEmpty())
    }

    @Test
    fun `liste → json → liste, chemins de rushs préservés (ordre inclus)`() {
        val l = listOf(
            "/data/user/0/video.vitrine.app/files/rushes/rush-1.mp4",
            "",
            "/data/user/0/video.vitrine.app/files/rushes/rush-2.mp4"
        )
        assertEquals(l, DraftStore.jsonToList(DraftStore.listToJson(l)))
    }

    @Test
    fun `json liste invalide → liste vide (jamais d'exception)`() {
        assertTrue(DraftStore.jsonToList(null).isEmpty())
        assertTrue(DraftStore.jsonToList("not json {{{").isEmpty())
    }

    @Test
    fun `unicode, accents, emoji préservés (FR-JA, noms de commerce réels)`() {
        val m = mapOf("nom" to "ブティック優雅", "emoji" to "🥇 ✓", "accent" to "Élégance à côuté")
        assertEquals(m, DraftStore.jsonToMap(DraftStore.mapToJson(m)))
    }

    @Test
    fun `étapes - constantes stables (contrat de migration du dialogue)`() {
        assertEquals("BRIEF", DraftStore.ETAPE_BRIEF)
        assertEquals("CAMERA", DraftStore.ETAPE_CAMERA)
    }
}
