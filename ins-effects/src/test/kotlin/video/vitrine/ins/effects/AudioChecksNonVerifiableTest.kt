package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * D42.8.2 — un controle obligatoire sans mesure exploitable n'est pas un succes.
 *
 * Defaut corrige : `AudioChecks.judge` validait la coherence de duree des que
 * `audioDurationMs` valait 0 (`audioDurationMs <= 0L || ...`). Autrement dit,
 * une duree ILLISIBLE etait traitee comme une duree COHERENTE : plus l'appareil
 * echouait a mesurer, plus le controle passait. Un export dont on ne savait rien
 * sortait avec la mention « verifie ».
 *
 * Ce que ces tests verrouillent :
 *  - duree audio illisible  -> NON_VERIFIABLE (ni succes, ni echec) ;
 *  - duree mesuree conforme -> verdict explicite, et jamais REUSSI quand le
 *    niveau n'est pas decode (VERIFIE_PARTIELLEMENT) ;
 *  - video muette VOULUE    -> NON_REQUIS, jamais bloquee.
 */
class AudioChecksNonVerifiableTest {

    private fun verdict(
        audioAttendu: Boolean = true,
        hasAudioTrack: Boolean = true,
        audioDurationMs: Long = 33_000,
        videoDurationMs: Long = 33_000,
        framesNonSilencieuses: Int = 120,
        mesureNiveauDisponible: Boolean = true
    ) = AudioChecks.judge(
        audioAttendu = audioAttendu,
        hasAudioTrack = hasAudioTrack,
        audioDurationMs = audioDurationMs,
        videoDurationMs = videoDurationMs,
        framesNonSilencieuses = framesNonSilencieuses,
        mesureNiveauDisponible = mesureNiveauDisponible
    )

    // ---------- le defaut corrige ----------

    @Test
    fun `duree audio illisible - non verifiable, pas un succes`() {
        val r = verdict(audioDurationMs = 0, mesureNiveauDisponible = false)
        assertEquals(AudioChecks.Verdict.NON_VERIFIABLE, r.verdict)
        assertTrue("le verdict doit etre signalable a l'appelant", r.nonVerifiable)
        assertFalse("une absence de mesure ne vaut pas succes", r.passed)
    }

    @Test
    fun `duree video illisible - non verifiable`() {
        // 0 des deux cotes : l'ecart vaut 0, donc l'ancienne formule concluait
        // « coherent ». C'est le cas le plus pervers du defaut.
        val r = verdict(audioDurationMs = 0, videoDurationMs = 0)
        assertEquals(AudioChecks.Verdict.NON_VERIFIABLE, r.verdict)
        assertFalse(r.passed)
    }

    @Test
    fun `duree audio illisible mais niveau mesure - reste non verifiable`() {
        // Entendre du son ne prouve pas que la piste couvre toute la video.
        val r = verdict(audioDurationMs = 0, framesNonSilencieuses = 300,
            mesureNiveauDisponible = true)
        assertEquals(AudioChecks.Verdict.NON_VERIFIABLE, r.verdict)
        assertFalse(r.passed)
    }

    // ---------- verdicts explicites ----------

    @Test
    fun `duree mesuree et coherente sans niveau - verifie partiellement`() {
        val r = verdict(audioDurationMs = 33_010, mesureNiveauDisponible = false)
        assertEquals(AudioChecks.Verdict.VERIFIE_PARTIELLEMENT, r.verdict)
        assertTrue("la verification partielle ne bloque pas la sortie", r.passed)
        assertFalse("elle ne doit pas etre presentee comme complete", r.verdict ==
            AudioChecks.Verdict.REUSSI)
    }

    @Test
    fun `tout mesure et conforme - reussi`() {
        val r = verdict(audioDurationMs = 33_000, mesureNiveauDisponible = true,
            framesNonSilencieuses = 120)
        assertEquals(AudioChecks.Verdict.REUSSI, r.verdict)
        assertTrue(r.passed)
    }

    @Test
    fun `piste tronquee - echec prouve`() {
        val r = verdict(audioDurationMs = 12_000)
        assertEquals(AudioChecks.Verdict.ECHEC, r.verdict)
        assertFalse(r.passed)
    }

    @Test
    fun `silence integral mesure - echec prouve`() {
        val r = verdict(framesNonSilencieuses = 0, mesureNiveauDisponible = true)
        assertEquals(AudioChecks.Verdict.ECHEC, r.verdict)
    }

    @Test
    fun `piste absente alors qu elle est attendue - echec`() {
        val r = verdict(hasAudioTrack = false, audioDurationMs = 0)
        assertEquals(AudioChecks.Verdict.ECHEC, r.verdict)
        assertFalse(r.audioPresent)
    }

    // ---------- les videos volontairement silencieuses ne cassent pas ----------

    @Test
    fun `video muette voulue - non requis meme sans aucune mesure`() {
        val r = verdict(audioAttendu = false, hasAudioTrack = false,
            audioDurationMs = 0, videoDurationMs = 0, mesureNiveauDisponible = false)
        assertEquals(AudioChecks.Verdict.NON_REQUIS, r.verdict)
        assertTrue("un gabarit sans audio ne doit jamais etre bloque", r.passed)
    }

    @Test
    fun `video muette voulue mais piste presente - non requis, pas de blocage`() {
        val r = verdict(audioAttendu = false, hasAudioTrack = true, audioDurationMs = 0)
        assertEquals(AudioChecks.Verdict.NON_REQUIS, r.verdict)
        assertTrue(r.passed)
    }

    // ---------- integration : le verdict traverse Checks et passe ----------

    @Test
    fun `verdict non verifiable retire le caractere conforme du Checks complet`() {
        // Tous les autres criteres sont parfaits : seule l'absence de mesure
        // audio doit empecher l'export d'etre declare conforme.
        val checks = VerifierPolicy.Checks(
            durationOk = true, resolutionOk = true, bitrateOk = true,
            nonBlackFrames = 3, audioVerdict = AudioChecks.Verdict.NON_VERIFIABLE
        )
        assertTrue(checks.audioNonVerifiable)
        assertFalse(checks.audioOk)
        assertFalse(checks.passed)
    }

    @Test
    fun `verdict partiel laisse le Checks conforme`() {
        val checks = VerifierPolicy.Checks(
            durationOk = true, resolutionOk = true, bitrateOk = true,
            nonBlackFrames = 3, audioVerdict = AudioChecks.Verdict.VERIFIE_PARTIELLEMENT
        )
        assertTrue(checks.audioOk)
        assertTrue(checks.passed)
    }

    @Test
    fun `verdict muet voulu laisse le Checks conforme`() {
        val checks = VerifierPolicy.Checks(
            durationOk = true, resolutionOk = true, bitrateOk = true,
            nonBlackFrames = 3, audioVerdict = AudioChecks.Verdict.NON_REQUIS
        )
        assertTrue(checks.passed)
    }
}
