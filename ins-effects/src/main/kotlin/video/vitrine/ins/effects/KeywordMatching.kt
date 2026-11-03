package video.vitrine.ins.effects

/**
 * Appariement mot/mots-cles (audit D41, F62) — PUR, testable JVM.
 *
 * Preuve du defaut corrige : GabaritBeatSheet ajoute aux keywords des VALEURS
 * ENTIERES contenant des chiffres (« 5000 FCFA », « 50 % de remise ») alors que
 * words sont des TOKENS blancs (Whisper) : `keywords.contains(mot)` ne pouvait
 * jamais etre vrai pour une valeur multi-mots — le surlignage orange ne
 * s'appliquait qu'aux chiffres isoles. L'appariement est desormais par TOKEN
 * normalise (minuscule, sans ponctuation) de part et d'autre.
 */
object KeywordMatching {

    private val BLANCS = Regex("\\s+")

    /** Minuscule + uniquement lettres/chiffres (la ponctuation n'est jamais significative). */
    fun normalize(s: String): String = buildString {
        for (c in s.lowercase()) {
            if (c.isLetterOrDigit()) append(c)
        }
    }

    /** Tokens normalises de l'ensemble des mots-cles (phrases incluses). */
    fun keywordTokens(keywords: Set<String>): Set<String> =
        keywords.flatMap { phrase -> phrase.split(BLANCS) }
            .map { normalize(it) }
            .filter { it.isNotEmpty() }
            .toSet()

    /** Un mot est surligne si son token normalise apparait dans les mots-cles. */
    fun isKeyword(word: String, tokens: Set<String>): Boolean {
        val normalise = normalize(word)
        return normalise.isNotEmpty() && normalise in tokens
    }
}
