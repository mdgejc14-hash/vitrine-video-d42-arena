package video.vitrine.ins.effects

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Audit D41 (F62, regression) : les keywords du beat sheet sont des VALEURS
 * entieres (« 5000 FCFA ») alors que words sont des tokens blancs (« 5000 »).
 * L'ancien `keywords.contains(mot)` ne pouvait jamais etre vrai sur une valeur
 * multi-mots — le surlignage orange des prix/offres ne s'affichait jamais.
 */
class KeywordMatchingTest {

    @Test
    fun `token d une phrase mot-cle est surligne`() {
        val tokens = KeywordMatching.keywordTokens(setOf("5000 FCFA", "50 % de remise"))
        assertTrue(KeywordMatching.isKeyword("5000", tokens))
        assertTrue(KeywordMatching.isKeyword("FCFA", tokens))
        assertTrue(KeywordMatching.isKeyword("remise", tokens))
        assertFalse(KeywordMatching.isKeyword("bonjour", tokens))
    }

    @Test
    fun `ponctuation et casse ignorees de part et d autre`() {
        val tokens = KeywordMatching.keywordTokens(setOf("Stock Limité !"))
        assertTrue(KeywordMatching.isKeyword("stock", tokens))
        assertTrue(KeywordMatching.isKeyword("limité", tokens))
        assertTrue(KeywordMatching.isKeyword("LIMITÉ.", tokens))
    }

    @Test
    fun `mot-cle token unique fonctionne comme avant`() {
        val tokens = KeywordMatching.keywordTokens(setOf("3"))
        assertTrue(KeywordMatching.isKeyword("3", tokens))
        assertFalse(KeywordMatching.isKeyword("30", tokens))   // pas de sous-chaine
    }

    @Test
    fun `entrees degeneres sans plantage`() {
        val tokens = KeywordMatching.keywordTokens(setOf("", "   ", "..."))
        assertTrue(tokens.isEmpty())
        assertFalse(KeywordMatching.isKeyword("", tokens))
        assertFalse(KeywordMatching.isKeyword("...", tokens))
    }
}
