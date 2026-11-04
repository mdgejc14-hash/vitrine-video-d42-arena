package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

/**
 * D42-F15 — REGRESSION : horodatages negatifs vers TimestampWrapper.
 *
 * Constate sur emulateur (run 41591615084) :
 *   IllegalArgumentException: startTimeUs and endTimeUs must be non-negative
 *     at TimestampWrapper.<init>
 *     at KineticTypography.wordOverlays
 *     at MotionComposition.fromClientRushes
 *
 * Cause : un texte a cheval sur deux plans etait rebase sur le plan courant,
 * ce qui rendait son debut NEGATIF. Consequence : aucun gabarit ne pouvait
 * produire de video a partir des rushs CLIENT (D20bis), alors que la CI D41
 * etait verte — le chemin n'avait jamais ete execute jusqu'au bout.
 */
// D42.5 : KineticTypography initialise android.graphics (Paint, StaticLayout).
// Sans runtime Android, la classe echouait a l'initialisation et les 4 tests
// n'ont JAMAIS tourne (la CI s'arretait avant, faute de keystore). Robolectric
// fournit ce runtime : la correction temporelle D42-F15 est enfin verifiee.
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class TimestampOverlapTest {

    private fun overlays(words: List<WordStamp>) =
        KineticTypography.wordOverlays(
            words = words,
            keywords = emptySet(),
            outputWidthPx = 720,
            outputHeightPx = 1280
        )

    @Test
    fun unMotARebasageNegatifNeFaitPlusEchouerLeRendu() {
        // Sans le garde-fou, ce seul appel levait IllegalArgumentException.
        val effets = overlays(listOf(WordStamp("texte a cheval", -2.0, 0.5)))
        assertTrue("le texte doit rester visible, borne a zero", effets.isNotEmpty())
    }

    @Test
    fun unMotDeDureeNulleOuInverseeNeProduitRien() {
        assertTrue(overlays(listOf(WordStamp("instantane", 1.0, 1.0))).isEmpty())
        assertTrue(overlays(listOf(WordStamp("inverse", 2.0, 1.0))).isEmpty())
        assertTrue(overlays(listOf(WordStamp("", 0.0, 1.0))).isEmpty())
    }

    @Test
    fun unMotValideProduitUnSeulOverlay() {
        val effets = overlays(listOf(WordStamp("BONJOUR", 0.5, 1.5)))
        assertEquals(1, effets.size)
    }

    @Test
    fun lesMotsInvalidesNePolluentPasLesMotsValides() {
        val seul = overlays(listOf(WordStamp("BONJOUR", 0.5, 1.5))).size
        val melange = overlays(
            listOf(
                WordStamp("instantane", 1.0, 1.0),
                WordStamp("BONJOUR", 0.5, 1.5),
                WordStamp("inverse", 2.0, 1.0)
            )
        ).size
        assertEquals(seul, melange)
    }
}
