package video.vitrine.ins.effects

import androidx.media3.common.C
import androidx.media3.common.audio.AudioProcessor.AudioFormat
import androidx.media3.common.util.UnstableApi
import androidx.media3.transformer.AudioMixer
import java.nio.ByteBuffer
import java.nio.ByteOrder
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Audit D41 (F58/F59/F60) — regression MULTI-RUSHS du mixeur BGM/SFX.
 *
 * Preuve du defaut (media3-transformer 1.11.1, AudioGraph.java l.315/l.359) :
 * le Transformer appelle addSource/removeSource PAR ITEM de la sequence — en
 * composition multi-rushs, chaque prise re-declenchait l'enregistrement de la
 * musique et des SFX (BGM/SFX DOUBLES des la 3e prise, +6 dB) et le ducking
 * suivait une source voix retiree (mort des la prise 2).
 *
 * Le faux delegue enregistre les appels reels du mixeur (addSource, volumes,
 * amplitudes PCM fed) : le comportement est observe, pas simule.
 */
@UnstableApi
class BgmSfxAudioMixerMultiRushTest {

    private class FakeMixer : AudioMixer {
        var totalAdds = 0
            private set
        val liveSources = mutableListOf<Int>()
        val volumesBySource = mutableMapOf<Int, MutableList<Float>>()
        val maxAbsBySource = mutableMapOf<Int, MutableList<Int>>()
        val framesBySource = mutableMapOf<Int, Long>()
        private var nextId = 0
        var configured = false
        var finDemandeeUs: Long = C.TIME_UNSET

        override fun configure(outputAudioFormat: AudioFormat, bufferSizeMs: Int, startTimeUs: Long) {
            configured = true
        }

        override fun setEndTimeUs(endTimeUs: Long) {
            finDemandeeUs = endTimeUs
        }

        override fun supportsSourceAudioFormat(sourceFormat: AudioFormat): Boolean = true

        override fun addSource(sourceFormat: AudioFormat, startTimeUs: Long): Int {
            nextId += 1
            totalAdds += 1
            liveSources += nextId
            return nextId
        }

        override fun hasSource(sourceId: Int): Boolean = sourceId in liveSources

        override fun setSourceVolume(sourceId: Int, volume: Float) {
            volumesBySource.getOrPut(sourceId) { mutableListOf() } += volume
        }

        override fun removeSource(sourceId: Int) {
            liveSources.remove(sourceId)
        }

        override fun queueInput(sourceId: Int, sourceBuffer: ByteBuffer) {
            var maxAbs = 0
            // D42.29 : trames stéréo réellement muxées par source (borne de fin).
            framesBySource[sourceId] = (framesBySource[sourceId] ?: 0L) +
                sourceBuffer.remaining() / 4
            // Le scratch du mixeur est en ordre NATIF (little-endian sur CI) :
            // une lecture big-endian par defaut produisait des amplitudes fausses
            // (0x8000 lus sur des valeurs minuscules) — faux negatif du test F60.
            val lecture = sourceBuffer.duplicate().order(ByteOrder.LITTLE_ENDIAN)
            while (lecture.remaining() >= 2) {
                val valeur = kotlin.math.abs(lecture.short.toInt())
                if (valeur > maxAbs) maxAbs = valeur
            }
            maxAbsBySource.getOrPut(sourceId) { mutableListOf() } += maxAbs
            sourceBuffer.position(sourceBuffer.limit())
        }

        override fun getOutput(): ByteBuffer = ByteBuffer.allocateDirect(0)

        override fun isEnded(): Boolean = false

        override fun reset() {
            totalAdds = 0
            nextId = 0
            liveSources.clear()
            volumesBySource.clear()
            maxAbsBySource.clear()
            framesBySource.clear()
            finDemandeeUs = C.TIME_UNSET
        }
    }

    private val format = AudioFormat(48000, 2, C.ENCODING_PCM_16BIT)

    /** 10 ms de voix stereo 16 bits, amplitude alternée (RMS proche du pic). */
    private fun voiceBuffer(amplitude: Int): ByteBuffer {
        val buffer = ByteBuffer.allocateDirect(1920)
        var signe = 1
        while (buffer.remaining() >= 2) {
            buffer.putShort((amplitude * signe).toShort())
            signe = -signe
        }
        buffer.flip()
        return buffer
    }

    private fun newMixer(fake: FakeMixer, durationUs: Long = 0L): BgmSfxAudioMixer {
        val musique = BgmDecoder.Pcm(ShortArray(48000 * 3) { 8000 }, 48000, 1)
        val sfx = BgmSfxAudioMixer.SfxCue(0L, BgmDecoder.Pcm(ShortArray(4800) { 12000 }, 48000, 1))
        val mixer = BgmSfxAudioMixer(fake, musique, listOf(sfx), compositionDurationUs = durationUs)
        mixer.configure(format, 1000, 0L)
        return mixer
    }

    @Test
    fun `quatre prises une seule musique un seul SFX (F58)`() {
        val fake = FakeMixer()
        val mixer = newMixer(fake)
        repeat(4) { prise ->
            val id = mixer.addSource(format, prise * 1_000_000L)
            mixer.queueInput(id, voiceBuffer(20000))
            mixer.removeSource(id)
        }
        // 4 voix + 1 musique + 1 SFX = 6 enregistrements (AVANT correctif : 12 —
        // musique et SFX re-enregistrés à chaque prise, donc doublés au mix).
        assertEquals(6, fake.totalAdds)
        assertFalse("mixeur dégradé sans raison", mixer.degraded)
    }

    @Test
    fun `ducking actif sur toutes les prises via la derniere voix (F58 F59)`() {
        val fake = FakeMixer()
        val mixer = newMixer(fake)
        repeat(4) { prise ->
            val id = mixer.addSource(format, prise * 1_000_000L)
            mixer.queueInput(id, voiceBuffer(20000))
            mixer.removeSource(id)
        }
        // Ids déterministes du faux délégue : voix1=1, musique=2 (enregistrée
        // pendant le premier addSource), SFX=3, voix2=4, voix3=5, voix4=6.
        val volumesMusique = fake.volumesBySource[2].orEmpty()
        assertTrue("aucun volume musique posé", volumesMusique.size >= 4)
        val base = MixPlan.musicBaseGain()
        assertEquals("volume de base -20 dB attendu à l'enregistrement", base, volumesMusique.first(), 0.0001f)
        assertTrue(
            "ducking jamais appliqué sur les prises suivantes : $volumesMusique",
            volumesMusique.last() < base * 0.5f
        )
    }

    @Test
    fun `profondeur de ducking du gabarit transmise (F59)`() {
        val fake = FakeMixer()
        val musique = BgmDecoder.Pcm(ShortArray(48000 * 3) { 8000 }, 48000, 1)
        val mixer = BgmSfxAudioMixer(fake, musique, emptyList(), duckDepthDb = -6.0)
        mixer.configure(format, 1000, 0L)
        val id = mixer.addSource(format, 0L)
        repeat(6) { mixer.queueInput(id, voiceBuffer(20000)) }
        val volumes = fake.volumesBySource[2].orEmpty()
        val cible = MixPlan.musicBaseGain() * MixPlan.duckTargetGain(20000f / 32768f, -6.0)
        assertTrue("volume jamais posé", volumes.isNotEmpty())
        // Profondeur -6 dB (gabarit) : le volume ducké reste nettement AU-DESSUS
        // du -14 dB par défaut (sinon la profondeur du gabarit serait ignorée).
        assertTrue(
            "profondeur gabarit ignorée : ${volumes.last()} vs cible $cible",
            volumes.last() > MixPlan.musicBaseGain() * 0.35f
        )
    }

    @Test
    fun `les SFX sont alimentes meme si la BGM n est jamais epuisee`() {
        // D42.6 : defaut mesure sur le MP4 rendu (immo_auto_T4 en) — 15 reperes
        // SFX planifies, seuls les 4 derniers audibles. Cause : la boucle SFX
        // partageait le garde d'alimentation consomme par la musique. Une BGM
        // de 45 s pour une composition de 33 s ne s'epuise jamais : elle
        // prenait les 8 blocs a chaque appel et `guard == 0` a l'entree de la
        // boucle SFX, qui ne tournait donc jamais.
        val fake = FakeMixer()
        val musique = BgmDecoder.Pcm(ShortArray(48000 * 45) { 8000 }, 48000, 1)
        val cue = BgmSfxAudioMixer.SfxCue(100_000L, BgmDecoder.Pcm(ShortArray(4800) { 12000 }, 48000, 1))
        val mixer = BgmSfxAudioMixer(fake, musique, listOf(cue), compositionDurationUs = 33_000_000L)
        mixer.configure(format, 1000, 0L)
        val voix = mixer.addSource(format, 0L)
        repeat(20) { mixer.queueInput(voix, voiceBuffer(20000)) } // 200 ms de voix
        // Ids deterministes du faux delegue : voix=1, musique=2, SFX=3.
        assertTrue("musique plus alimentee", fake.maxAbsBySource[2].orEmpty().isNotEmpty())
        assertTrue(
            "SFX jamais alimente a sa date (BGM plus longue que la composition)",
            fake.maxAbsBySource[3].orEmpty().isNotEmpty()
        )
    }

    @Test
    fun `fade-in musique appliqué à l alimentation (F60)`() {
        val fake = FakeMixer()
        val mixer = newMixer(fake)
        val id = mixer.addSource(format, 0L)
        repeat(4) { mixer.queueInput(id, voiceBuffer(20000)) }
        val amplitudes = fake.maxAbsBySource[2].orEmpty()
        assertTrue("musique jamais fed", amplitudes.size >= 2)
        assertTrue(
            "fade-in absent (premier bloc ${amplitudes.first()}, dernier ${amplitudes.last()})",
            amplitudes.last() > amplitudes.first() * 2
        )
    }

    @Test
    fun `fade-out musique avant la fin de composition (F60)`() {
        val fake = FakeMixer()
        val mixer = newMixer(fake, durationUs = 2_000_000L)
        val id = mixer.addSource(format, 0L)
        mixer.queueInput(id, voiceBuffer(20000))
        mixer.setEndTimeUs(2_000_000L)          // drain complet du reliquat
        val amplitudes = fake.maxAbsBySource[2].orEmpty()
        assertTrue("musique jamais fed", amplitudes.size >= 10)
        val milieu = amplitudes[amplitudes.size / 3]
        assertTrue("corps de la musique effacé à tort : $milieu", milieu > 4000)
        // D42.29 : l'alimentation est BORNÉE à la fin de composition — le
        // dernier bloc muxé s'arrête exactement à la fin (plus de queue
        // silencieuse au-delà), le fade-out l'amène près de zéro.
        assertTrue(
            "queue de musique non atténuée : ${amplitudes.takeLast(3)}",
            amplitudes.last() < milieu / 8
        )
    }

    @Test
    fun `musique plus longue que la composition - alimentation bornee (D42 29)`() {
        // Pilot 42975000342 (musique/titulaires, 540x960) : le titulaire de
        // 38,1 s était muxé ENTIÈREMENT pour une composition de 35 s — 3 s de
        // silence en queue de piste audio (mesure ffprobe : audio 38,044 s /
        // vidéo 34,989 s), rejetées par AudioChecks du vérificateur (tolérance
        // 250 ms) → repli CLOUD_MODAL. Tout export musical réel aurait été
        // rejeté, y compris sur appareil physique. L'alimentation est désormais
        // bornée : plus AUCUN échantillon muxé au-delà de la composition.
        val fake = FakeMixer()
        val musique = BgmDecoder.Pcm(ShortArray(48000 * 45) { 8000 }, 48000, 1)
        val mixer = BgmSfxAudioMixer(fake, musique, emptyList(), compositionDurationUs = 33_000_000L)
        mixer.configure(format, 1000, 0L)
        val voix = mixer.addSource(format, 0L)
        repeat(10) { mixer.queueInput(voix, voiceBuffer(20000)) }
        mixer.setEndTimeUs(33_000_000L)         // drain complet du reliquat
        val framesMusique = fake.framesBySource[2] ?: 0L
        val cap = 33_000_000L * 48000 / 1_000_000L
        assertTrue("musique jamais alimentée", framesMusique > 0)
        assertTrue(
            "musique muxée au-delà de la composition : $framesMusique trames > cap $cap",
            framesMusique <= cap
        )
        assertTrue(
            "musique amputée avant la fin de composition : $framesMusique trames sur $cap",
            framesMusique >= cap - 48000
        )
    }

    @Test
    fun `reset rearme l enregistrement musique (contrat AudioMixer)`() {
        val fake = FakeMixer()
        val mixer = newMixer(fake)
        val id = mixer.addSource(format, 0L)
        mixer.queueInput(id, voiceBuffer(20000))
        mixer.reset()
        fake.reset()
        val id2 = mixer.addSource(format, 0L)
        mixer.queueInput(id2, voiceBuffer(20000))
        // Après reset, la musique doit être ré-enregistrée (nouveau rendu).
        assertEquals(3, fake.totalAdds)          // voix + musique + SFX
    }
}
