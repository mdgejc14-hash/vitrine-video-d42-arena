package video.vitrine.data.gabarits

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** Apercu E7 : cartes texte variables remplacees + lignes de verification. */
class PreviewTextsTest {

    private val raw = javaClass.getResourceAsStream("/fixtures/batiment_travaux_T1.json")!!
        .readBytes().decodeToString()

    @Test
    fun `cartes texte avec variable commerce remplacee`() {
        val texts = GabaritJson.parsePreviewTexts(raw, mapOf("nom_commerce" to "Chez Shalom"))
        assertEquals("Voici le nouveau travail de Chez Shalom.", texts[0])
        assertEquals("À DÉCOUVRIR", texts[1])
    }

    @Test
    fun `lignes verification sans cases a cocher`() {
        val rows = GabaritJson.parseCheckRows(raw)
        assertTrue(rows.any { it.first == "nom_commerce" })
        assertTrue(rows.none { it.first.contains("message") })
        assertEquals("Nom de ton commerce", rows.first { it.first == "nom_commerce" }.second)
    }
}
