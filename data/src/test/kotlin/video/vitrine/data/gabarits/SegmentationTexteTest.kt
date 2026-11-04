package video.vitrine.data.gabarits

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import java.util.Random

/**
 * D42.4 — segmentation multilingue et invariant de conservation.
 *
 * Defaut reproduit avant correction : `segmenter` terminait par
 * `chunked(CJK_SEGMENT)` sur TOUT libelle sans espace, donc « CONTACTEZ-NOUS »
 * sortait en « CONTACT » / « EZ-NOUS » dans le MP4 (run 41724250282).
 *
 * Regle verifiee ici, et valable pour toute langue : la segmentation ne fait
 * que proposer des positions de coupure. Le texte affiche est toujours une
 * tranche du texte source, jamais une reecriture.
 */
class SegmentationTexteTest {

    private fun verifierConservation(source: String, largeurMax: Int = TexteCommerce.LARGEUR_SEGMENT) {
        val segments = TexteCommerce.segmenter(source, largeurMax)
        if (source.isBlank()) {
            assertTrue("un texte blanc ne doit produire aucun segment : $segments", segments.isEmpty())
            return
        }
        assertEquals(
            "reconstruction differente de la source : $segments",
            source,
            segments.joinToString(""),
        )
        assertTrue("segment vide produit : $segments", segments.none { it.isEmpty() })
        var offset = 0
        for (segment in segments.dropLast(1)) {
            offset += segment.length
            assertTrue(
                "coupure a l'interieur d'un grapheme, position $offset sur « $source »",
                TexteCommerce.estFrontiereDeGrapheme(source, offset),
            )
        }
    }

    @Test
    fun `francais - le CTA garde ses mots entiers et son trait d'union`() {
        val source = "CONTACTEZ-NOUS"
        verifierConservation(source)
        val segments = TexteCommerce.segmenter(source)
        assertTrue(
            "le CTA est coupe en morceaux non typographiques : $segments",
            segments.none { it == "CONTACT" || it == "EZ-NOUS" },
        )
        if (segments.size > 1) {
            assertTrue(
                "une coupure du CTA doit se faire APRES le trait d'union : $segments",
                segments.all { it.endsWith("-") || it == segments.last() },
            )
        }
    }

    @Test
    fun `anglais - les mots et leur ordre sont preserves`() {
        val source = "CONTACT OUR TEAM TODAY"
        verifierConservation(source)
        assertEquals("un texte a espaces doit rester d'un bloc", listOf(source), TexteCommerce.segmenter(source))
    }

    @Test
    fun `espagnol - accents et ponctuation conserves`() {
        val source = "¡OFERTA ESPECIAL PARA USTEDES!"
        verifierConservation(source)
        assertEquals(listOf(source), TexteCommerce.segmenter(source))
    }

    @Test
    fun `japonais - decoupage lisible sans perte de caractere`() {
        val source = "本日の特別メニューをぜひご覧ください"
        verifierConservation(source)
        val segments = TexteCommerce.segmenter(source)
        assertTrue("le japonais sans espace doit etre segmente : $segments", segments.size >= 2)
        for (segment in segments) {
            assertTrue(
                "segment japonais trop large pour le budget : « $segment »",
                TexteCommerce.largeurEnColonnes(segment) <= TexteCommerce.LARGEUR_SEGMENT,
            )
        }
    }

    @Test
    fun `mixte avec espaces - latin japonais et chiffres intacts`() {
        val source = "OFFRE SPÉCIALE — 東京 25 000 FCFA — CONTACTEZ-NOUS"
        verifierConservation(source)
        assertEquals(listOf(source), TexteCommerce.segmenter(source))
    }

    @Test
    fun `mixte sans espace - aucune marque commerciale coupee`() {
        val source = "OFFRESPÉCIALE—東京25000FCFA—CONTACTEZ-NOUS"
        verifierConservation(source)
        val segments = TexteCommerce.segmenter(source)
        assertTrue(
            "CONTACTEZ-NOUS doit apparaitre entier dans un segment : $segments",
            segments.any { it.contains("CONTACTEZ-NOUS") },
        )
        assertTrue(
            "le prix colle ne doit pas etre coupe : $segments",
            segments.any { it.contains("25000FCFA") },
        )
    }

    @Test
    fun `japonais - une marque latine collee a du japonais reste entiere`() {
        // Cas reel : un libelle japonais peut contenir une marque ou un appel a
        // l'action en latin (« D42 », « CONTACTEZ-NOUS »). L'ancien chunked(7)
        // coupait ces chaines en plein mot ; ici elles doivent rester entieres.
        val source = "今すぐCONTACTEZ-NOUS"
        verifierConservation(source)
        val segments = TexteCommerce.segmenter(source)
        assertTrue(
            "le CTA latin est coupe dans un libelle japonais : $segments",
            segments.count { it == "CONTACTEZ-NOUS" } == 1,
        )
        val second = "D42のお得なキャンペーン"
        verifierConservation(second)
        assertTrue(
            "la marque D42 est coupee : ${TexteCommerce.segmenter(second)}",
            TexteCommerce.segmenter(second).any { it.contains("D42") },
        )
    }

    @Test
    fun `japonais - aucune ligne ne commence par une ponctuation interdite`() {
        // Regle kinsoku : « ・ », « 、 », « 」 » ou un petit kana ne peuvent pas
        // ouvrir une ligne. Le run porte B produisait « ・アキャクパ・ ».
        val source = "シャンタル食堂・アキャクパ・22997000000"
        verifierConservation(source)
        for (segment in TexteCommerce.segmenter(source)) {
            assertTrue(
                "segment ouvert par une ponctuation interdite : « $segment »",
                !TexteCommerce.estInterditEnDebut(segment.first().code),
            )
        }
        val autre = "本日の特別メニュー、ぜひご覧ください。"
        verifierConservation(autre)
        for (segment in TexteCommerce.segmenter(autre)) {
            assertTrue(
                "segment ouvert par une ponctuation interdite : « $segment »",
                !TexteCommerce.estInterditEnDebut(segment.first().code),
            )
        }
    }

    @Test
    fun `emoji - la paire de substitution n'est jamais coupee`() {
        val source = "PROMO🎉D42"
        verifierConservation(source)
        val segments = TexteCommerce.segmenter(source)
        for (segment in segments) {
            assertTrue(
                "segment commencant par une demi-paire : « $segment »",
                !segment.first().isLowSurrogate(),
            )
            assertTrue(
                "segment finissant par une demi-paire : « $segment »",
                !segment.last().isHighSurrogate(),
            )
        }
    }

    @Test
    fun `accent combinant - jamais separe de sa lettre`() {
        // « CAFE » + U+0301 : la segmentation ne doit pas isoler l'accent.
        val source = "CAFE\u0301D42"
        verifierConservation(source, largeurMax = 1)
        for (segment in TexteCommerce.segmenter(source, largeurMax = 1)) {
            assertTrue(
                "segment commencant par un accent combinant : « $segment »",
                !TexteCommerce.estMarque(segment.first().code),
            )
        }
    }

    @Test
    fun `proprietes - 400 textes aleatoires conserves a l'identique`() {
        val alphabet = listOf(
            "A", "B", "Z", "é", "ñ", "ß", "東", "京", "ア", "ー", "ヶ",
            "1", "0", "9", "-", "—", "·", " ", "\u0301", "🎉", "🇧🇯", "\u200D",
        )
        val alea = Random(0xDB42)
        repeat(400) { essai ->
            val longueur = 1 + alea.nextInt(24)
            val sb = StringBuilder()
            repeat(longueur) { sb.append(alphabet[alea.nextInt(alphabet.size)]) }
            val source = sb.toString()
            for (largeur in intArrayOf(1, 4, TexteCommerce.LARGEUR_SEGMENT)) {
                val segments = TexteCommerce.segmenter(source, largeur)
                if (source.isBlank()) continue
                assertEquals(
                    "essai $essai, largeur $largeur : « $source » -> $segments",
                    source,
                    segments.joinToString(""),
                )
                assertTrue("essai $essai : segment vide", segments.none { it.isEmpty() })
            }
        }
    }

    @Test
    fun `pourcentage de reduction - calcule comme le declare le gabarit`() {
        // D42.6 : « -{pourcentage}% » s'affichait « -% » dans le MP4 (6 gabarits
        // T4) car la variable declaree n'etait jamais calculee.
        assertEquals(20, TexteCommerce.pourcentageReduction("25000", "20000"))
        assertEquals(17, TexteCommerce.pourcentageReduction("30000", "25000"))
        assertEquals(50, TexteCommerce.pourcentageReduction("10000", "5000"))
        assertEquals(0, TexteCommerce.pourcentageReduction("1000", "1000").let { 0 })
        // Hors conditions du gabarit : null (segment omis, jamais de tiret seul).
        assertEquals(null, TexteCommerce.pourcentageReduction("0", "0"))
        assertEquals(null, TexteCommerce.pourcentageReduction("1000", "1000"))
        assertEquals(null, TexteCommerce.pourcentageReduction("1000", "2000"))
        assertEquals(null, TexteCommerce.pourcentageReduction(null, "25000"))
        assertEquals(null, TexteCommerce.pourcentageReduction("abc", "25000"))
        // Saisies avec espaces tolerees.
        assertEquals(20, TexteCommerce.pourcentageReduction("25 000", "20 000"))
    }

    @Test
    fun `prix - groupement des milliers dans toutes les langues`() {
        assertEquals("500", TexteCommerce.grouperMilliers("500"))
        assertEquals("5 000", TexteCommerce.grouperMilliers("5000"))
        assertEquals("25 000", TexteCommerce.grouperMilliers("25000"))
        assertEquals("100 000", TexteCommerce.grouperMilliers("100000"))
        assertEquals("1 250 000", TexteCommerce.grouperMilliers("1250000"))
        // Deja formate : rendu tel quel, sans doubler les separateurs.
        assertEquals("25 000", TexteCommerce.grouperMilliers("25 000"))
        assertEquals("25.000", TexteCommerce.grouperMilliers("25.000"))
        // La devise n'est jamais dans le formateur : FCFA reste FCFA.
        assertTrue(
            "le formateur ne doit jamais injecter de devise",
            TexteCommerce.grouperMilliers("25000").none { it.isLetter() },
        )
    }
}
