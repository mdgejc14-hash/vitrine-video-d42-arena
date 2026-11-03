package video.vitrine.ins.effects

import kotlin.math.ceil

/**
 * Mise en page PURE de la typographie cinematique (audit D41, F62) — testable JVM.
 *
 * Preuve du defaut corrige : Media3 1.11.1 TextOverlay.java:80 dessine a
 * TEXT_SIZE_PIXELS=100 fixe avec une largeur de layout = largeur mesuree du texte
 * (getSpannedTextWidth) : AUCUN retour a la ligne possible, un mot long (ou un
 * mot japonais sans espace, glyphes pleine chasse) deborde du cadre. Le moteur
 * n'utilise plus TextOverlay : il rend des BitmapOverlay dimensionnes ici.
 *
 * Les largeurs par classe de caracteres sont des HEURISTIQUES deterministes
 * (les metriques reelles sont mesurees par StaticLayout au rendu) ; elles ne
 * servent qu'a decider taille/cassure/ancrage de facon reproductible.
 */
object OverlayTextLayout {

    /** Taille de base = 7,8 % de la largeur de sortie (1080 -> 84 px, 720 -> 56 px). */
    const val WIDTH_FRACTION = 0.078

    /** Une ligne ne depasse jamais 90 % de la largeur de sortie. */
    const val MAX_WIDTH_FRACTION = 0.90

    const val MIN_SIZE_PX = 24
    const val BASE_NDC_Y = -0.35f
    const val LINE_SPACING = 1.25f

    /** Caractere pleine chasse (CJK, kana, hangul, pleine chasse ASCII). */
    fun isWide(c: Char): Boolean {
        val code = c.code
        return code in 0x1100..0x11FF ||
            code in 0x2E80..0xA4CF ||
            code in 0xAC00..0xD7A3 ||
            code in 0xF900..0xFAFF ||
            code in 0xFE30..0xFE4F ||
            code in 0xFF00..0xFF60 ||
            code in 0xFFE0..0xFFE6
    }

    fun charWidthPx(c: Char, sizePx: Int): Double = when {
        isWide(c) -> sizePx.toDouble()
        c.isDigit() || c.isUpperCase() -> sizePx * 0.62
        c.isLetter() -> sizePx * 0.52
        else -> sizePx * 0.55
    }

    fun estimateWidthPx(text: String, sizePx: Int): Int =
        ceil(text.sumOf { charWidthPx(it, sizePx) }).toInt()

    fun baseSizePx(outputWidthPx: Int): Int = (outputWidthPx * WIDTH_FRACTION).toInt()

    /** Retrecit la taille pour faire tenir le mot sur UNE ligne quand c'est possible. */
    fun sizeForWidth(word: String, basePx: Int, maxWidthPx: Int): Int {
        val mesure = estimateWidthPx(word, basePx)
        if (mesure <= maxWidthPx || mesure <= 0) return basePx
        return ((basePx.toLong() * maxWidthPx) / mesure).toInt().coerceAtLeast(MIN_SIZE_PX)
    }

    /**
     * Cassage greedy : un mot plus long que la largeur max (meme retreci au
     * plancher MIN_SIZE_PX) est coupe en lignes — le japonais (aucun espace)
     * ne deborde plus jamais du cadre.
     */
    /**
     * Cassage greedy, avec deux garde-fous ajoutes en D42.3.
     *
     * Constat sur le MP4 `restaurants_maquis_T1_fr_stock_limite` : la ligne de
     * contact « Chez D42 Test · COTONOU · +22997000000 » etait coupee au milieu
     * du numero, donnant « …+2299700 » puis « 0000 ». Un numero de telephone
     * coupe en deux est illisible, donc inutilisable pour un commercant.
     *
     *  1. on ne coupe JAMAIS a l'interieur d'une suite de chiffres ;
     *  2. on prefere couper sur un separateur (« · », virgule, barre oblique)
     *     quand il en existe un dans la ligne.
     */
    fun splitLines(word: String, sizePx: Int, maxWidthPx: Int): List<String> {
        if (word.isEmpty()) return listOf(word)
        val lignes = mutableListOf<String>()
        val courant = StringBuilder()
        var largeur = 0.0
        val caracteres = word.toCharArray()
        for ((i, c) in caracteres.withIndex()) {
            val w = charWidthPx(c, sizePx)
            if (courant.isNotEmpty() && largeur + w > maxWidthPx) {
                val coupe = positionDeCoupe(courant, caracteres, i)
                if (coupe in 1 until courant.length) {
                    lignes += courant.substring(0, coupe).trimEnd()
                    val reste = courant.substring(coupe).trimStart()
                    courant.setLength(0)
                    courant.append(reste)
                    largeur = reste.sumOf { charWidthPx(it, sizePx) }
                } else {
                    lignes += courant.toString()
                    courant.setLength(0)
                    largeur = 0.0
                }
            }
            courant.append(c)
            largeur += w
        }
        if (courant.isNotEmpty()) lignes += courant.toString()
        return lignes
    }

    /** Caracteres de coupure preferes : ils separent des champs, pas des mots. */
    private const val SEPARATEURS = "\u00B7,/|"

    /** Derniere position de coupure acceptable dans [courant], ou -1. */
    private fun positionDeCoupe(courant: StringBuilder, source: CharArray, i: Int): Int {
        // 1. jamais au milieu d'une suite de chiffres (numero de telephone),
        //    et le « + » international reste colle a ses chiffres.
        if (i > 0 && source[i].isDigit() &&
            (source[i - 1].isDigit() || source[i - 1] == '+')
        ) {
            var k = courant.length
            while (k > 0 && (courant[k - 1].isDigit() || courant[k - 1] == '+')) k--
            return if (k > 0) k else -1
        }
        // 2. de preference apres un separateur de champs.
        for (k in courant.length - 1 downTo 1) {
            if (courant[k - 1] in SEPARATEURS) return k
        }
        return -1
    }

    /** Y (NDC, + vers le haut) de la ligne i (0 = haut), bloc centre sur BASE_NDC_Y. */
    fun lineAnchorY(index: Int, lineCount: Int, sizePx: Int, outputHeightPx: Int): Float {
        val hauteurLigneNdc = sizePx * LINE_SPACING / outputHeightPx * 2f
        val depart = BASE_NDC_Y + (lineCount - 1) / 2f * hauteurLigneNdc
        return depart - index * hauteurLigneNdc
    }

    /**
     * Part de la hauteur de sortie occupee par une ligne de texte.
     * Sert de garde-fou de lisibilite : un texte commercial doit rester gros
     * sur un telephone, quelle que soit la geometrie de sortie.
     */
    fun fractionHauteurTexte(sizePx: Int, outputHeightPx: Int): Float =
        if (outputHeightPx <= 0) 0f else sizePx.toFloat() / outputHeightPx

    /**
     * Ordonnee EN PIXELS (depuis le haut) du haut de la ligne [index].
     * Convertit l'ancrage NDC de [lineAnchorY] en pixels sans dupliquer
     * la logique de disposition.
     */
    fun lineAnchorYPx(index: Int, lineCount: Int, sizePx: Int, outputHeightPx: Int): Float {
        if (outputHeightPx <= 0) return 0f
        return (1f - lineAnchorY(index, lineCount, sizePx, outputHeightPx)) / 2f * outputHeightPx
    }

    /**
     * Taille de base tenant compte de la HAUTEUR de sortie.
     *
     * Correction D42.2 : [baseSizePx] ne depend que de la largeur. En portrait
     * 9:16 — le format commercial (story, reel) — 84 px sur 1920 ne font que
     * 4,37 % de la hauteur : le « timbre-poste » constate sur d42_art7. En
     * carre, les memes 84 px font 7,78 % et le defaut ne se voit pas.
     *
     * On retient la plus grande des deux contraintes : la largeur garantit
     * qu'un mot reste dans le cadre, la hauteur garantit qu'il reste lisible.
     * Pour 1080x1920 : max(84, 105,6) = 105 px, soit 5,47 % de la hauteur.
     */
    fun baseSizePxFor(outputWidthPx: Int, outputHeightPx: Int): Int {
        require(outputHeightPx > 0) { "hauteur de sortie invalide : $outputHeightPx" }
        val parLargeur = outputWidthPx * WIDTH_FRACTION
        val parHauteur = outputHeightPx * HEIGHT_FRACTION
        return maxOf(parLargeur, parHauteur).toInt().coerceAtLeast(MIN_SIZE_PX)
    }

    /** Fraction minimale de la hauteur de sortie exigee pour un texte lisible. */
    const val FRACTION_MIN_LISIBLE = 0.05f

    /**
     * Part de la hauteur occupee par le texte. Type Double comme
     * [WIDTH_FRACTION] : `maxOf` n'accepte pas des operandes de types
     * differents (erreur de compilation constatee au run 41702332080).
     */
    const val HEIGHT_FRACTION = 0.055
}
