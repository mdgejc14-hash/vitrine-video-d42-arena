package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * D42.8.1 — raccordement REEL du controle audio au verdict d'export.
 *
 * Defaut corrige : `AudioChecks` existait et etait teste, mais aucun code de
 * production ne l'appelait. R8 le supprimait comme code mort et le controle
 * audio du contrat 5.2 n'existait pas dans le binaire livre.
 *
 * Ces tests passent par [ExportVerifier.judge], c'est-a-dire par le point
 * d'entree reellement utilise par ExportWorker — pas par AudioChecks
 * directement. Si le cablage disparait, ces tests tombent.
 */
class ExportVerifierAudioTest {

    private val geometrie = ExportSpec.ExportGeometry(960, 540)

    private fun mesure(
        dureeMs: Long = 33_000,
        audio: Boolean,
        audioDureeMs: Long = 0
    ) = ExportVerifier.Measurement(
        durationMs = dureeMs,
        width = 960,
        height = 540,
        measuredBitrateBps = 3_000_000,
        nonBlackFrames = 3,
        rotationDegrees = 0,
        hasAudioTrack = audio,
        audioDurationMs = audioDureeMs
    )

    @Test
    fun `audio attendu et piste absente - export refuse`() {
        val checks = ExportVerifier.judge(
            mesure(audio = false), geometrie, 6_000_000, 33_000, audioAttendu = true
        )
        assertFalse("le verdict ignore l'absence de piste audio", checks.passed)
        assertFalse(checks.audioOk)
    }

    @Test
    fun `audio attendu piste presente et duree coherente - export accepte`() {
        val checks = ExportVerifier.judge(
            mesure(audio = true, audioDureeMs = 33_010), geometrie, 6_000_000, 33_000, audioAttendu = true
        )
        assertTrue(checks.passed)
        assertTrue(checks.audioOk)
    }

    @Test
    fun `piste audio tronquee - export refuse`() {
        val checks = ExportVerifier.judge(
            mesure(audio = true, audioDureeMs = 12_000), geometrie, 6_000_000, 33_000, audioAttendu = true
        )
        assertFalse("une piste audio de 12 s dans une video de 33 s doit etre rejetee", checks.passed)
    }

    @Test
    fun `video muette prevue - l absence de piste n est pas un defaut`() {
        val checks = ExportVerifier.judge(
            mesure(audio = false), geometrie, 6_000_000, 33_000, audioAttendu = false
        )
        assertTrue("un gabarit sans audio ne doit jamais etre bloque", checks.passed)
    }

    @Test
    fun `mesure nulle - export refuse avec audioOk a faux`() {
        val checks = ExportVerifier.judge(null, geometrie, 6_000_000, 33_000, audioAttendu = true)
        assertFalse(checks.passed)
        assertFalse(checks.audioOk)
    }

    @Test
    fun `defaut historique - Checks sans argument audio reste conforme`() {
        // Les appelants qui ne connaissent pas l'audio (video muette voulue) ne
        // doivent pas se mettre a echouer : audioOk vaut true par defaut.
        val checks = VerifierPolicy.Checks(true, true, true, 3)
        assertTrue(checks.passed)
    }

    // ---------- D42.8.2 : la duree illisible n'est plus un succes ----------

    @Test
    fun `audio attendu mais duree de piste illisible - export refuse`() {
        // MediaExtractor a trouve une piste audio mais n'a pas su en lire la
        // duree (audioDurationMs = 0). Avant ce correctif, l'ecart nul avec la
        // duree video validait le controle : l'export sortait « verifie » sans
        // qu'aucune mesure audio n'ait ete faite.
        val checks = ExportVerifier.judge(
            mesure(audio = true, audioDureeMs = 0), geometrie, 6_000_000, 33_000,
            audioAttendu = true
        )
        assertFalse("sans mesure exploitable, l'export ne peut pas etre declare conforme",
            checks.passed)
        assertTrue(checks.audioNonVerifiable)
        assertFalse(checks.audioOk)
    }

    @Test
    fun `duree illisible sur video muette voulue - export accepte`() {
        // Le meme fichier sans audio attendu doit continuer de passer : c'est
        // le garde-fou contre une correction qui casserait les videos muettes.
        val checks = ExportVerifier.judge(
            mesure(audio = false, audioDureeMs = 0), geometrie, 6_000_000, 33_000,
            audioAttendu = false
        )
        assertTrue("une video volontairement silencieuse ne doit jamais etre bloquee",
            checks.passed)
        assertEquals(AudioChecks.Verdict.NON_REQUIS, checks.audioVerdict)
    }
}
