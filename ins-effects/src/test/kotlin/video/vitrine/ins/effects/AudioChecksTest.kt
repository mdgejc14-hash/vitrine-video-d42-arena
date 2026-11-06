package video.vitrine.ins.effects

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/** D42.8 — politique des controles audio de l'export. */
class AudioChecksTest {

    @Test
    fun `gabarit avec audio - piste manquante est un echec`() {
        val r = AudioChecks.judge(
            audioAttendu = true, hasAudioTrack = false, audioDurationMs = 0,
            videoDurationMs = 33_000, framesNonSilencieuses = 0, mesureNiveauDisponible = false
        )
        assertFalse(r.passed)
        assertFalse(r.audioPresent)
    }

    @Test
    fun `gabarit avec audio - piste presente et duree coherente passe`() {
        val r = AudioChecks.judge(
            audioAttendu = true, hasAudioTrack = true, audioDurationMs = 33_010,
            videoDurationMs = 33_000, framesNonSilencieuses = 0, mesureNiveauDisponible = false
        )
        assertTrue(r.passed)
    }

    @Test
    fun `piste tronquee par rapport a la video est refusee`() {
        val r = AudioChecks.judge(
            audioAttendu = true, hasAudioTrack = true, audioDurationMs = 12_000,
            videoDurationMs = 33_000, framesNonSilencieuses = 0, mesureNiveauDisponible = false
        )
        assertFalse(r.passed)
        assertFalse(r.dureeCoherente)
    }

    @Test
    fun `silence integral mesure est refuse`() {
        val r = AudioChecks.judge(
            audioAttendu = true, hasAudioTrack = true, audioDurationMs = 33_000,
            videoDurationMs = 33_000, framesNonSilencieuses = 0, mesureNiveauDisponible = true
        )
        assertFalse(r.passed)
        assertTrue(r.silenceInexplique)
    }

    @Test
    fun `video muette prevue par le gabarit n est pas un defaut`() {
        val r = AudioChecks.judge(
            audioAttendu = false, hasAudioTrack = false, audioDurationMs = 0,
            videoDurationMs = 33_000, framesNonSilencieuses = 0, mesureNiveauDisponible = false
        )
        assertTrue(r.passed)
    }
}
