package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Audit D41 (F62) : mise en page pure de la typographie — taille proportionnee
 * a la sortie, cassure des mots trop longs (japonais sans espace), ancrage des
 * lignes. Bornes et valeurs limites testees (methode combinatoire).
 */
class OverlayTextLayoutTest {

    @Test
    fun `largeur CJK pleine chasse superieure au latin`() {
        val cjk = OverlayTextLayout.estimateWidthPx("株式会社", 56)
        val latin = OverlayTextLayout.estimateWidthPx("abcd", 56)
        assertTrue("CJK doit occuper plus de place", cjk > latin)
        assertEquals(56 * 4, cjk)
    }

    @Test
    fun `taille de base proportionnelle a la largeur de sortie`() {
        assertEquals(84, OverlayTextLayout.baseSizePx(1080))
        assertEquals(56, OverlayTextLayout.baseSizePx(720))
    }

    @Test
    fun `mot court conserve la taille de base`() {
        assertEquals(84, OverlayTextLayout.sizeForWidth("Promo", 84, 972))
    }

    @Test
    fun `mot long retreci sans passer sous le plancher`() {
        val mot = "ExtraordinairementSupercalifragilistic".repeat(3)
        val reduit = OverlayTextLayout.sizeForWidth(mot, 84, 972)
        assertTrue("taille reduite attendue", reduit < 84)
        assertTrue("plancher respecte", reduit >= OverlayTextLayout.MIN_SIZE_PX)
        val ultraLong = "x".repeat(20_000)
        assertEquals(
            OverlayTextLayout.MIN_SIZE_PX,
            OverlayTextLayout.sizeForWidth(ultraLong, 84, 972)
        )
    }

    @Test
    fun `mot japonais trop long casse en lignes qui tiennent`() {
        // 60 caracteres pleine chasse a 56 px = 3360 px pour 972 px dispo.
        val mot = "video".repeat(12).map { '店' }.joinToString("")
        val lignes = OverlayTextLayout.splitLines(mot, 56, 972)
        assertTrue("cassure attendue", lignes.size > 1)
        lignes.forEach {
            assertTrue(
                "ligne trop large : ${it.length}",
                OverlayTextLayout.estimateWidthPx(it, 56) <= 972
            )
        }
        assertEquals(mot, lignes.joinToString(""))
    }

    @Test
    fun `mot vide et bornes degeneres sans plantage`() {
        assertEquals(listOf(""), OverlayTextLayout.splitLines("", 56, 972))
        assertEquals(84, OverlayTextLayout.sizeForWidth("", 84, 972))
        assertEquals(0, OverlayTextLayout.estimateWidthPx("", 84))
    }

    @Test
    fun `ancrage des lignes empile de haut en bas autour de la base`() {
        val y0 = OverlayTextLayout.lineAnchorY(0, 3, 84, 1920)
        val y1 = OverlayTextLayout.lineAnchorY(1, 3, 84, 1920)
        val y2 = OverlayTextLayout.lineAnchorY(2, 3, 84, 1920)
        assertTrue("ligne 0 au-dessus de la 1", y0 > y1)
        assertTrue("ligne 1 au-dessus de la 2", y1 > y2)
        // Bloc centre sur BASE_NDC_Y : la ligne du milieu est la reference.
        assertEquals(OverlayTextLayout.BASE_NDC_Y, y1, 0.0001f)
        // Une seule ligne = exactement la base.
        assertEquals(OverlayTextLayout.BASE_NDC_Y, OverlayTextLayout.lineAnchorY(0, 1, 84, 1920), 0.0001f)
    }

    // ------------------------------------------------------------------
    // D42.2 : le texte commercial doit rester LISIBLE, pas seulement present.
    // Ces deux premiers tests DOIVENT echouer avant correction (texte a 4,37 %
    // de la hauteur de sortie, soit la regression « timbre-poste » constatee
    // sur d42_art7 et l'absence de texte sur les 40 rendus de validation).
    // ------------------------------------------------------------------

    @Test
    fun `le texte occupe au moins 5 pour cent de la hauteur en 1080x1920`() {
        val size = OverlayTextLayout.baseSizePxFor(1080, 1920)
        val fraction = OverlayTextLayout.fractionHauteurTexte(size, 1920)
        assertTrue(
            "texte trop petit : ${(fraction * 1000).toInt() / 10f} % de la hauteur",
            fraction >= OverlayTextLayout.FRACTION_MIN_LISIBLE
        )
    }

    @Test
    fun `le texte occupe au moins 5 pour cent de la hauteur en 540x960`() {
        val size = OverlayTextLayout.baseSizePxFor(540, 960)
        val fraction = OverlayTextLayout.fractionHauteurTexte(size, 960)
        assertTrue(
            "profil de validation illisible : ${(fraction * 1000).toInt() / 10f} %",
            fraction >= OverlayTextLayout.FRACTION_MIN_LISIBLE
        )
    }

    @Test
    fun `la hauteur de sortie influence la taille du texte`() {
        val carre = OverlayTextLayout.baseSizePxFor(1080, 1080)
        val portrait = OverlayTextLayout.baseSizePxFor(1080, 1920)
        assertTrue("un cadre plus haut exige un texte plus grand", portrait > carre)
    }

    @Test
    fun `la ligne reste ancree dans le cadre`() {
        for (index in 0 until 3) {
            val y = OverlayTextLayout.lineAnchorYPx(index, 3, 105, 1920)
            assertTrue("ligne $index hors cadre (y=$y)", y >= 0f && y <= 1920f)
        }
        val haut = OverlayTextLayout.lineAnchorYPx(0, 3, 105, 1920)
        val bas = OverlayTextLayout.lineAnchorYPx(2, 3, 105, 1920)
        assertTrue("ordre des lignes inverse", haut < bas)
    }

    @Test
    fun `le japonais sans espace est segmente dans la largeur`() {
        val size = OverlayTextLayout.baseSizePxFor(1080, 1920)
        val maxWidth = (1080 * OverlayTextLayout.MAX_WIDTH_FRACTION).toInt()
        val lignes = OverlayTextLayout.splitLines("シャンタル食堂へようこそ", size, maxWidth)
        assertTrue("japonais non segmente", lignes.isNotEmpty())
        assertTrue(
            "ligne japonaise hors largeur",
            lignes.all { OverlayTextLayout.estimateWidthPx(it, size) <= maxWidth }
        )
    }

    @Test
    fun `une hauteur nulle est refusee`() {
        var levee = false
        try {
            OverlayTextLayout.baseSizePxFor(1080, 0)
        } catch (e: IllegalArgumentException) {
            levee = true
        }
        assertTrue("hauteur nulle acceptee a tort", levee)
    }

    @Test
    fun `un numero de telephone n_est jamais coupe en deux`() {
        val ligne = "Chez D42 Test · COTONOU · +22997000000"
        val maxWidth = (540 * OverlayTextLayout.MAX_WIDTH_FRACTION).toInt()
        val lignes = OverlayTextLayout.splitLines(ligne, 24, maxWidth)
        assertEquals("le numero doit rester sur une seule ligne", 1,
            lignes.count { it.contains("+22997000000") })
        lignes.forEach { l ->
            assertTrue("fragment de numero isole dans « $l »", !l.trim().matches(Regex("^\\d+$")))
        }
    }

    @Test
    fun `la coupure prefere un separateur de champs`() {
        val maxWidth = (540 * OverlayTextLayout.MAX_WIDTH_FRACTION).toInt()
        val lignes = OverlayTextLayout.splitLines("Chez D42 Test · COTONOU · +22997000000", 24, maxWidth)
        assertTrue("au moins deux lignes attendues", lignes.size >= 2)
        assertTrue("coupure hors separateur : $lignes", lignes.first().endsWith("·") || !lignes.first().last().isDigit())
    }

    @Test
    fun `le plus international reste avec les chiffres`() {
        val maxWidth = (540 * OverlayTextLayout.MAX_WIDTH_FRACTION).toInt()
        val lignes = OverlayTextLayout.splitLines("Chez D42 Test · COTONOU · +22997000000", 24, maxWidth)
        assertTrue("le « + » est reste seul en fin de ligne : $lignes", lignes.none { it.trim().endsWith("+") })
        assertTrue("numero introuvable : $lignes", lignes.any { it.contains("+22997000000") })
    }
}
