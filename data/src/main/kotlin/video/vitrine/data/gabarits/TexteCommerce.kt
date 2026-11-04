package video.vitrine.data.gabarits

/**
 * Regles de texte commercial, **sans aucune dependance Android** : ce fichier
 * est compilable et testable sur la JVM nue, donc verifiable hors emulateur.
 *
 * D42.4 — la segmentation d'affichage coupait tout libelle SANS espace en
 * tranches de 7 unites UTF-16. Le japonais y trouvait son compte, mais
 * « CONTACTEZ-NOUS » sortait en « CONTACT » / « EZ-NOUS » dans le MP4 : un
 * appel a l'action coupe en deux est inutilisable pour un commercant.
 *
 * Principe retenu : **la segmentation ne reecrit jamais le texte**. Elle ne
 * calcule que des POSITIONS de coupure typographiquement valides ; les
 * morceaux rendus sont des tranches (substring) de la chaine d'origine.
 * Invariant garanti et teste pour toute entree :
 *
 *     segmenter(t).joinToString("") == t
 *
 * Un changement de ligne ne peut donc plus modifier la chaine commerciale.
 *
 * Choix d'implementation : les proprietes Unicode sont evaluees directement
 * (categories generales, plages pleine chasse, frontieres de grapheme)
 * plutot que via `BreakIterator`, dont les tables changent entre la JVM de
 * la CI et le runtime Android. Ici le resultat est identique partout.
 */
internal object TexteCommerce {

    /** Budget d'un segment, en colonnes : 1 par caractere etroit, 2 par
     *  caractere pleine chasse. Meme valeur qu'avant (7 ideogrammes). */
    const val LARGEUR_SEGMENT = 14

    /** Separateurs apres lesquels une coupure reste typographiquement juste.
     *  Le trait d'union insecable U+2011 est volontairement ABSENT. */
    private const val COUPE_APRES = "-\u2010\u2013\u2014"
    private val CODES_DE_COUPE: Set<Int> = COUPE_APRES.map { it.code }.toSet()

    /** Ponctuation et petits kana qui ne doivent jamais ouvrir une ligne
     *  (regle japonaise de kinsoku). */
    private const val INTERDIT_EN_DEBUT =
        "、。，．・：；？！）〕］｝〉》」』】〗〙ー々ゝゞヽヾ" +
            "ぁぃぅぇぉっゃゅょゎァィゥェォッャュョヮヵヶ"

    private val CODES_INTERDITS: Set<Int> = INTERDIT_EN_DEBUT.map { it.code }.toSet()

    /** Separateur insecable (espace fine insecable incluse). */
    private const val ESPACE_INSECABLE = '\u00A0'

    // ------------------------------------------------------------------
    // Segmentation d'affichage
    // ------------------------------------------------------------------

    /**
     * Decoupe [texte] en morceaux affichables successifs.
     *
     * Regles :
     *  - un texte vide ou blanc ne produit aucun segment ;
     *  - un texte contenant un espace reste d'un seul bloc : le retour a la
     *    ligne est l'affaire d'OverlayTextLayout.splitLines (comportement
     *    inchange depuis D42.3) ;
     *  - un texte sans espace n'est coupe QUE sur une position valide
     *    (bord d'un caractere pleine chasse, apres un tiret, jamais au milieu
     *    d'une grappe de graphemes) ;
     *  - un mot latin sans position valide reste ENTIER, quelle que soit sa
     *    longueur : c'est le rendu qui reduit la taille pour le faire tenir.
     */
    fun segmenter(texte: String, largeurMax: Int = LARGEUR_SEGMENT): List<String> {
        if (texte.isBlank()) return emptyList()
        if (contientSeparateur(texte)) return listOf(texte)
        val coupes = positionsDeCoupe(texte)
        if (coupes.isEmpty()) return listOf(texte)
        // La fin de chaine est une borne legitime : elle evite tout cas limite
        // ou aucun candidat ne tient dans le budget.
        return decouper(texte, coupes + texte.length, largeurMax)
    }

    /** Vrai si le texte contient une separation : il reste alors d'un seul bloc
     *  et le retour a la ligne est l'affaire de `OverlayTextLayout.splitLines`. */
    private fun contientSeparateur(texte: String): Boolean =
        texte.any { it.isWhitespace() } || texte.any { it == ESPACE_INSECABLE }

    /** Applique les coupures retenues jusqu'a epuisement du texte. */
    private fun decouper(texte: String, bornes: List<Int>, largeurMax: Int): List<String> {
        val morceaux = mutableListOf<String>()
        var debut = 0
        while (debut < texte.length) {
            val fin = prochaineCoupe(texte, debut, bornes, largeurMax)
            morceaux += texte.substring(debut, fin)
            debut = fin
        }
        return morceaux
    }

    /**
     * Choix de la coupure suivante : la borne la plus lointaine qui tient dans
     * le budget, sauf si une frontiere FORTE (changement d'ecriture) remplit au
     * moins 60 % de la ligne — un changement kanji -> kana -> latin est une
     * coupure plus lisible qu'une coupe au milieu d'un mot japonais.
     */
    private fun prochaineCoupe(texte: String, debut: Int, bornes: List<Int>, largeurMax: Int): Int {
        val candidat = meilleurCandidat(texte, debut, bornes, largeurMax)
        if (candidat.derniere < 0) return bornes.first { it > debut }
        val remplitAssez = candidat.forte > debut &&
            largeurEnColonnes(texte, debut, candidat.forte) * 10 >= largeurMax * 6
        return if (remplitAssez) candidat.forte else candidat.derniere
    }

    /** Une borne de coupure et, parmi celles qui tiennent, la derniere frontiere forte. */
    private class Candidat(
        val derniere: Int,
        val forte: Int,
    )

    /** Parcourt les bornes une seule fois et retient les deux candidats utiles. */
    private fun meilleurCandidat(
        texte: String,
        debut: Int,
        bornes: List<Int>,
        largeurMax: Int
    ): Candidat {
        var derniere = -1
        var forte = -1
        for (p in bornes) {
            if (p <= debut) continue
            if (largeurEnColonnes(texte, debut, p) > largeurMax) break
            derniere = p
            if (estFrontiereForte(texte, p)) forte = p
        }
        return Candidat(derniere, forte)
    }

    /**
     * Positions de coupure acceptables, strictement croissantes, dans
     * `]0, texte.length[`, toutes sur une frontiere de grapheme.
     */
    fun positionsDeCoupe(texte: String): List<Int> {
        val out = mutableListOf<Int>()
        for (i in 1 until texte.length) {
            if (!estFrontiereDeGrapheme(texte, i)) continue
            val avant = codePointAvant(texte, i)
            val apres = codePointA(texte, i)
            if (apres in CODES_INTERDITS) continue // jamais en debut de ligne
            if (estPleineChasse(avant) || estPleineChasse(apres)) {
                out += i // le CJK se coupe entre caracteres : c'est sa regle
            } else if (avant in CODES_DE_COUPE) {
                out += i // apres un tiret ou un tiret cadratin
            }
        }
        return out
    }

    /** Largeur en colonnes de `texte[debut until fin]`. */
    fun largeurEnColonnes(texte: String, debut: Int = 0, fin: Int = texte.length): Int {
        var largeur = 0
        var i = debut
        while (i < fin) {
            val cp = codePointA(texte, i)
            largeur += if (estPleineChasse(cp)) 2 else 1
            i += charCount(cp)
        }
        return largeur
    }

    /** Caractere pleine chasse : CJK, kana, hangul, pleine chasse ASCII, emoji. */
    fun estPleineChasse(codePoint: Int): Boolean =
        codePoint in 0x1100..0x115F ||
            codePoint in 0x2E80..0xA4CF ||
            codePoint in 0xA960..0xA97F ||
            codePoint in 0xAC00..0xD7A3 ||
            codePoint in 0xF900..0xFAFF ||
            codePoint in 0xFE10..0xFE19 ||
            codePoint in 0xFE30..0xFE6F ||
            codePoint in 0xFF00..0xFF60 ||
            codePoint in 0xFFE0..0xFFE6 ||
            codePoint in 0x1F300..0x1F64F ||
            codePoint in 0x1F900..0x1F9FF ||
            codePoint in 0x1FA70..0x1FAFF ||
            codePoint in 0x20000..0x3FFFD

    /**
     * Vrai si [i] se trouve sur une frontiere de grapheme (au sens « ne coupe
     * ni une paire de substitution, ni un caractere combinant, ni une
     * sequence ZWJ / selecteur de variante / modificateur de carnation /
     * drapeau »).
     */
    fun estFrontiereDeGrapheme(texte: String, i: Int): Boolean {
        if (i <= 0 || i >= texte.length) return true
        if (coupeUnePaireDeSubstitution(texte, i)) return false
        val courant = codePointA(texte, i)
        if (estExtensionDeGrapheme(courant)) return false
        if (estJointParZWJ(texte, i, courant)) return false
        if (estSecondeMoitieDeDrapeau(texte, i, courant)) return false
        return true
    }

    /** Couper entre le demi-codet haut et le demi-codet bas romprait le caractere. */
    private fun coupeUnePaireDeSubstitution(texte: String, i: Int): Boolean =
        texte[i - 1].isHighSurrogate() && texte[i].isLowSurrogate()

    /** Code point qui prolonge le precedent au lieu de commencer un grapheme :
     *  marque combinante, selecteur de variante, carnation, etiquette emoji. */
    private fun estExtensionDeGrapheme(codePoint: Int): Boolean =
        estMarque(codePoint) ||
            estSelecteurDeVariante(codePoint) ||
            codePoint in 0x1F3FB..0x1F3FF ||
            codePoint in 0xE0020..0xE007F

    /** Sequence ZWJ : aucune coupure de part et d'autre du liant. */
    private fun estJointParZWJ(texte: String, i: Int, courant: Int): Boolean =
        texte[i - 1] == '\u200D' || courant == 0x200D

    /** Deux indicateurs regionaux forment un drapeau : on ne coupe jamais entre eux. */
    private fun estSecondeMoitieDeDrapeau(texte: String, i: Int, courant: Int): Boolean {
        if (!estIndicateurRegional(courant)) return false
        return nombreDIndicateursPrecedents(texte, i) % 2 == 1
    }

    /** Compte les indicateurs regionaux consecutifs qui precedent la position [i]. */
    private fun nombreDIndicateursPrecedents(texte: String, i: Int): Int {
        var nombre = 0
        var j = i
        while (j > 0) {
            val avant = codePointAvant(texte, j)
            if (!estIndicateurRegional(avant)) break
            nombre++
            j -= charCount(avant)
        }
        return nombre
    }

    /** Vrai si [codePoint] est une marque combinante (Mn, Me, Mc). */
    fun estMarque(codePoint: Int): Boolean {
        if (codePoint > 0xFFFF) return false // marques combinantes astrales : hors corpus
        return when (codePoint.toChar().category) {
            CharCategory.NON_SPACING_MARK,
            CharCategory.ENCLOSING_MARK,
            CharCategory.COMBINING_SPACING_MARK -> true
            else -> false
        }
    }

    /** Classe d'ecriture d'un point de code : 0 latin/chiffres, 1 hiragana,
     *  2 katakana, 3 ideogrammes, 4 autre (ponctuation, emoji…). */
    private fun classeEcriture(codePoint: Int): Int = when {
        codePoint < 0x0300 -> 0
        codePoint in 0x3040..0x309F -> 1
        codePoint in 0x30A0..0x30FF || codePoint in 0xFF66..0xFF9D -> 2
        codePoint in 0x3400..0x4DBF || codePoint in 0x4E00..0x9FFF -> 3
        codePoint in 0xF900..0xFAFF -> 3
        else -> 4
    }

    /** Coupure qui separe deux ecritures differentes : la plus lisible. */
    fun estFrontiereForte(texte: String, i: Int): Boolean {
        if (i <= 0 || i >= texte.length) return false
        return classeEcriture(codePointAvant(texte, i)) != classeEcriture(codePointA(texte, i))
    }

    /** Vrai si [codePoint] ne peut pas ouvrir une ligne (kinsoku japonais). */
    fun estInterditEnDebut(codePoint: Int): Boolean = codePoint in CODES_INTERDITS

    private fun estSelecteurDeVariante(codePoint: Int): Boolean =
        codePoint in 0xFE00..0xFE0F || codePoint in 0xE0100..0xE01EF

    private fun estIndicateurRegional(codePoint: Int): Boolean =
        codePoint in 0x1F1E6..0x1F1FF

    /** Point de code a la position [i] (paires de substitution recomposees). */
    fun codePointA(texte: String, i: Int): Int {
        if (i < 0 || i >= texte.length) return -1
        val c = texte[i]
        if (c.isHighSurrogate() && i + 1 < texte.length && texte[i + 1].isLowSurrogate()) {
            return 0x10000 + ((c.code - 0xD800) shl 10) + (texte[i + 1].code - 0xDC00)
        }
        return c.code
    }

    /** Point de code qui se termine juste avant la position [i]. */
    fun codePointAvant(texte: String, i: Int): Int {
        if (i <= 0 || i > texte.length) return -1
        val c = texte[i - 1]
        if (c.isLowSurrogate() && i >= 2 && texte[i - 2].isHighSurrogate()) {
            return 0x10000 + ((texte[i - 2].code - 0xD800) shl 10) + (c.code - 0xDC00)
        }
        return c.code
    }

    private fun charCount(codePoint: Int): Int = if (codePoint > 0xFFFF) 2 else 1

    // ------------------------------------------------------------------
    // Formatage du prix
    // ------------------------------------------------------------------

    /**
     * Groupe les milliers par une espace (convention XOF) : « 25000 » ->
     * « 25 000 ». Ne touche jamais a la devise : le FCFA reste FCFA quelle
     * que soit la langue demandee.
     *
     * Une valeur deja formatee (espaces, virgules, points) est rendue telle
     * quelle pour ne jamais doubler les separateurs.
     */
    fun grouperMilliers(valeur: String): String {
        val chiffres = valeur.trim()
        if (chiffres.length < 4 || !chiffres.all { it.isDigit() }) return valeur
        val sb = StringBuilder()
        var compte = 0
        for (i in chiffres.indices.reversed()) {
            if (compte > 0 && compte % 3 == 0) sb.append(' ')
            sb.append(chiffres[i])
            compte++
        }
        return sb.reverse().toString()
    }
}
