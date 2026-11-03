package video.vitrine.ins.effects

import androidx.media3.common.C
import androidx.media3.common.audio.AudioProcessor.AudioFormat
import androidx.media3.common.util.UnstableApi
import androidx.media3.transformer.AudioMixer
import androidx.media3.transformer.DefaultAudioMixer
import java.nio.ByteBuffer
import java.nio.ByteOrder

/**
 * Mixeur audio du rendu marchand (audit D40 — reconnectage A4/A5 du contrat
 * AudioChain dans le pipeline Media3 on-device) :
 *
 *  - voix du rush = source du Transformer (inchangee, prioritaire) ;
 *  - BGM = source ajoutee au demarrage, volume = MixPlan.musicBaseGain()
 *    (-20 dB, plage contrat -18/-22) modulee par le ducking sidechain
 *    (seuil 0,045, attaque 12 ms, relache 260 ms, profondeur -14 dB du bloc
 *    audio.mix des gabarits V2.0) ;
 *  - SFX = sources ponctuelles programmees sur les reperes audio.sfx_scenes
 *    des gabarits, volume -25 dB (banc ffmpeg), jamais en echec bloquant.
 *
 * Regle d'or de robustesse : TOUTE anomalie du chemin musique/SFX bascule le
 * mixeur en pass-through voix seule (drapeau [degraded]) — l'export reussit
 * toujours, la telemetrie declare bgm_mixe=0 (jamais de video faussement
 * declaree complete). Files d'alimentation bornees, memoire < 20 Mo.
 */
@UnstableApi
class BgmSfxAudioMixer(
    private val delegate: AudioMixer,
    music: BgmDecoder.Pcm?,
    sfxCues: List<SfxCue>,
    /** Profondeur de ducking du gabarit (audio.mix.ducking_musique_sous_voix_db, D41 F59). */
    private val duckDepthDb: Double = MixPlan.DUCK_DEPTH_DB_DEFAULT,
    /** Duree de la composition (µs) : pilote le fade-out musique (D41 F60). 0 = inconnue. */
    private val compositionDurationUs: Long = 0L
) : AudioMixer {

    /** Repere SFX : instant composition (µs) + PCM maître (48 kHz mono attendu). */
    data class SfxCue(val atUs: Long, val pcm: BgmDecoder.Pcm)

    var degraded: Boolean = false
        private set

    private var outputFormat: AudioFormat = AudioFormat.NOT_SET
    private var mixerStartTimeUs: Long = 0L

    /** Canaux de la sortie (2 par defaut) : pilote l'adaptation PCM et le scratch. */
    private val outputChannels: Int
        get() = if (outputFormat.channelCount > 0) outputFormat.channelCount else 2

    private var voiceSourceId: Int = C.INDEX_UNSET
    private var voiceFormat: AudioFormat = AudioFormat.NOT_SET
    private var voicePositionUs: Long = 0L
    private var duckEnvelope: Float = 1.0f

    /** Audit D41 (F58, P1) : musique/SFX enregistres UNE SEULE FOIS. Avant ce
     *  correctif, chaque removeSource(voix) suivi d'un addSource (composition
     *  multi-rushs : le Transformer ajoute/retire une source PAR ITEM — prouvé
     *  dans AudioGraph.java de media3-transformer 1.11.1) re-declenchait
     *  registerMusicAndSfx : BGM et SFX DOUBLES des la 3e prise (+6 dB, reperes
     *  SFX rejoues en rafale). La voix suivie est desormais le DERNIER input
     *  ajoute (les items sont sequentiels), donc le ducking reste actif sur
     *  toutes les prises. */
    private var musicRegistered = false

    private var musicSourceId: Int = C.INDEX_UNSET
    private var musicPcm: ShortArray? = null          // stereo, cadence de sortie
    private var musicFedFrames: Long = 0L

    private data class SfxFeed(val sourceId: Int, val pcm: ShortArray, val atUs: Long)
    private val sfxFeeds = mutableListOf<SfxFeed>()

    private var endTimeUs: Long = C.TIME_UNSET
    private val scratch: ByteBuffer =
        ByteBuffer.allocateDirect(SCRATCH_BYTES).order(ByteOrder.nativeOrder())

    /** Fabrique : musique decodee + cues SFX prepares AVANT le rendu (ExportWorker). */
    class Factory(
        private val music: BgmDecoder.Pcm?,
        private val sfxCues: List<SfxCue>,
        private val duckDepthDb: Double = MixPlan.DUCK_DEPTH_DB_DEFAULT,
        private val compositionDurationUs: Long = 0L
    ) : AudioMixer.Factory {
        override fun create(): AudioMixer =
            BgmSfxAudioMixer(
                DefaultAudioMixer.Factory().create(),
                music,
                sfxCues,
                duckDepthDb,
                compositionDurationUs
            )
    }

    override fun configure(outputAudioFormat: AudioFormat, bufferSizeMs: Int, startTimeUs: Long) {
        delegate.configure(outputAudioFormat, bufferSizeMs, startTimeUs)
        outputFormat = outputAudioFormat
        mixerStartTimeUs = startTimeUs
    }

    override fun setEndTimeUs(endTimeUs: Long) {
        this.endTimeUs = endTimeUs
        runSafe {
            // Alimente le reliquat musique/SFX jusqu'a la fin de composition,
            // puis cloture les sources ajoutees (le delegate sort tout ce qui
            // est deja en file — contrat removeSource).
            drainFeeds(full = true)
            if (musicSourceId != C.INDEX_UNSET) {
                delegate.removeSource(musicSourceId)
                musicSourceId = C.INDEX_UNSET
            }
            sfxFeeds.forEach { delegate.removeSource(it.sourceId) }
            sfxFeeds.clear()
        }
        delegate.setEndTimeUs(endTimeUs)
    }

    override fun supportsSourceAudioFormat(sourceFormat: AudioFormat): Boolean =
        delegate.supportsSourceAudioFormat(sourceFormat)

    override fun addSource(sourceFormat: AudioFormat, startTimeUs: Long): Int {
        val id = delegate.addSource(sourceFormat, startTimeUs)
        // Le Transformer alimente les items un par un : la source voix COURANTE
        // est le dernier input ajoute (D41 F58).
        voiceSourceId = id
        voiceFormat = sourceFormat
        if (!musicRegistered) {
            musicRegistered = true
            registerMusicAndSfx(startTimeUs)
        }
        return id
    }

    override fun hasSource(sourceId: Int): Boolean = delegate.hasSource(sourceId)

    override fun setSourceVolume(sourceId: Int, volume: Float) {
        delegate.setSourceVolume(sourceId, volume)
    }

    override fun removeSource(sourceId: Int) {
        if (sourceId == voiceSourceId) voiceSourceId = C.INDEX_UNSET
        delegate.removeSource(sourceId)
    }

    override fun queueInput(sourceId: Int, sourceBuffer: ByteBuffer) {
        if (sourceId != voiceSourceId) {
            delegate.queueInput(sourceId, sourceBuffer)
            return
        }
        val avant = sourceBuffer.remaining()
        runSafe {
            val rms = rmsOf(sourceBuffer)
            val dtMs = bytesToMs(avant)
            val target = MixPlan.duckTargetGain(rms, duckDepthDb)
            duckEnvelope = MixPlan.approachGain(duckEnvelope, target, dtMs)
            if (musicSourceId != C.INDEX_UNSET) {
                delegate.setSourceVolume(musicSourceId, MixPlan.musicVolume(duckEnvelope))
            }
        }
        delegate.queueInput(sourceId, sourceBuffer)
        // La position voix n'avance que des octets REELLEMENT consommes
        // (le delegue peut n'en accepter qu'une partie par appel).
        runSafe { voicePositionUs += bytesToUs(avant - sourceBuffer.remaining()) }
        drainFeeds(full = false)
    }

    override fun getOutput(): ByteBuffer {
        drainFeeds(full = false)
        return delegate.getOutput()
    }

    override fun isEnded(): Boolean = delegate.isEnded()

    override fun reset() {
        delegate.reset()
        voiceSourceId = C.INDEX_UNSET
        voiceFormat = AudioFormat.NOT_SET
        voicePositionUs = 0L
        musicSourceId = C.INDEX_UNSET
        musicFedFrames = 0L
        musicRegistered = false
        sfxFeeds.clear()
        fedBySource.clear()
        duckEnvelope = 1.0f
        endTimeUs = C.TIME_UNSET
    }

    // ------------------------------------------------------------------ interne

    private fun registerMusicAndSfx(voiceStartTimeUs: Long) {
        if (outputFormat.channelCount > 2) {
            // Sortie multicanal non prevue au contrat (9:16 stereo) : pass-through.
            degraded = true
            return
        }
        runSafe {
            val musicIn = musicInput ?: return@runSafe
            val adapted = adaptToOutput(musicIn)
            val id = delegate.addSource(outputPcmFormat(), voiceStartTimeUs)
            musicSourceId = id
            musicPcm = adapted
            delegate.setSourceVolume(id, MixPlan.musicBaseGain())
        }
        runSafe {
            pendingSfx.forEach { cue ->
                val adapted = adaptToOutput(cue.pcm)
                val id = delegate.addSource(outputPcmFormat(), mixerStartTimeUs + cue.atUs)
                delegate.setSourceVolume(id, MixPlan.sfxGain())
                sfxFeeds += SfxFeed(id, adapted, cue.atUs)
            }
        }
    }

    private var musicInput: BgmDecoder.Pcm? = null
    private var pendingSfx: List<SfxCue> = emptyList()

    init {
        musicInput = music
        pendingSfx = sfxCues
    }

    private fun outputPcmFormat(): AudioFormat =
        AudioFormat(outputFormat.sampleRate, outputFormat.channelCount, C.ENCODING_PCM_16BIT)

    /** PCM source -> PCM 16 bits a la cadence ET au nombre de canaux de sortie. */
    private fun adaptToOutput(pcm: BgmDecoder.Pcm): ShortArray {
        // 1) ramener a un seul flux par canal source
        val srcChannels = maxOf(1, pcm.channels)
        val srcFrames = pcm.samples.size / srcChannels
        var perChannel = List(srcChannels) { c ->
            ShortArray(srcFrames) { f -> pcm.samples[f * srcChannels + c] }
        }
        // 2) resampling si cadences differentes
        if (pcm.sampleRate != outputFormat.sampleRate && outputFormat.sampleRate > 0) {
            perChannel = perChannel.map {
                MixPlan.resampleLinear(it, pcm.sampleRate, outputFormat.sampleRate)
            }
        }
        val frames = perChannel[0].size
        // 3) adaptation du nombre de canaux (downmix moyen / duplication)
        val outChannels = outputChannels
        val out = ShortArray(frames * outChannels)
        for (f in 0 until frames) {
            if (outChannels == 1) {
                var sum = 0
                perChannel.forEach { sum += it[f] }
                out[f] = (sum / srcChannels).toShort()
            } else {
                for (c in 0 until outChannels) {
                    val src = perChannel.getOrElse(c) { perChannel[c % srcChannels] }
                    out[f * outChannels + c] = if (srcChannels == 1) perChannel[0][f] else src[f]
                }
            }
        }
        return out
    }

    /** Alimentation bornee musique + SFX ; [full] = drain complet (fin de rendu). */
    private fun drainFeeds(full: Boolean) {
        var guard = if (full) FULL_DRAIN_GUARD else FEED_GUARD
        runSafe {
            val channels = outputChannels
            val music = musicPcm
            if (music != null && musicSourceId != C.INDEX_UNSET && guard > 0) {
                // D41 (F60) : fade-in/fade-out contrat AudioChain (0,45 s / 0,75 s)
                // appliques a l'alimentation musique — avant, la BGM demarrait au
                // volume cible et se faisait couper net a la fin de composition.
                val rate = if (outputFormat.sampleRate > 0) outputFormat.sampleRate else 48000
                guard = feedPcm(musicSourceId, music, musicFedFrames, guard, channels, musicEnvelope(rate)) { fed ->
                    musicFedFrames = fed
                }
            }
            val iterator = sfxFeeds.iterator()
            while (iterator.hasNext() && guard > 0) {
                val feed = iterator.next()
                if (voicePositionUs < feed.atUs && !full) continue
                var fedFrames = fedBySource[feed.sourceId] ?: 0L
                guard = feedPcm(feed.sourceId, feed.pcm, fedFrames, guard, channels, null) { fed ->
                    fedFrames = fed
                    fedBySource[feed.sourceId] = fed
                }
                if (fedFrames * channels >= feed.pcm.size) {
                    delegate.removeSource(feed.sourceId)
                    iterator.remove()
                }
            }
        }
    }

    /** Enveloppe musique : rampe d'entree (AudioChain.MUSIC_FADE_IN_S) puis rampe
     *  de sortie avant la fin de composition (MUSIC_FADE_OUT_S). null si sans objet. */
    private fun musicEnvelope(sampleRate: Int): ((Long) -> Float)? {
        val fadeInFrames = (AudioChain.MUSIC_FADE_IN_S * sampleRate).toLong()
        val endFrames = if (compositionDurationUs > 0L) {
            compositionDurationUs * sampleRate / 1_000_000L
        } else {
            0L
        }
        val fadeOutStart = if (endFrames > 0L) endFrames - (AudioChain.MUSIC_FADE_OUT_S * sampleRate).toLong() else Long.MAX_VALUE
        return { frame ->
            val entree = if (fadeInFrames > 0L && frame < fadeInFrames) {
                frame.toFloat() / fadeInFrames.toFloat()
            } else {
                1f
            }
            val sortie = if (endFrames > 0L && frame >= fadeOutStart) {
                ((endFrames - frame).toFloat() / (endFrames - fadeOutStart).toFloat()).coerceIn(0f, 1f)
            } else {
                1f
            }
            entree * sortie
        }
    }

    private val fedBySource = mutableMapOf<Int, Long>()

    /** Pousse le PCM par blocs ; retourne le garde restant. Position maj via callback.
     *  [envelope] : gain par frame (fade musique, D41 F60), null = copie brute. */
    private fun feedPcm(
        sourceId: Int,
        pcm: ShortArray,
        fedFrames: Long,
        guard: Int,
        channels: Int,
        envelope: ((Long) -> Float)?,
        onFed: (Long) -> Unit
    ): Int {
        var remainingGuard = guard
        var fed = fedFrames
        val bytesPerFrame = channels * 2
        val totalFrames = pcm.size / channels
        while (fed < totalFrames && remainingGuard > 0) {
            val frames = minOf(
                (SCRATCH_BYTES / bytesPerFrame).toLong(),
                totalFrames - fed
            ).toInt()
            scratch.clear()
            for (i in 0 until frames * channels) {
                val e = envelope?.invoke(fed + i / channels) ?: 1f
                val v = if (e == 1f) {
                    pcm[(fed.toInt() * channels) + i]
                } else {
                    (pcm[(fed.toInt() * channels) + i] * e).toInt()
                        .coerceIn(-32768, 32767).toShort()
                }
                scratch.putShort(v)
            }
            scratch.flip()
            val before = scratch.remaining()
            delegate.queueInput(sourceId, scratch)
            val consumed = before - scratch.remaining()
            if (consumed <= 0) break                    // limite d'entree du delegue : on retentera
            fed += consumed / bytesPerFrame
            remainingGuard--
        }
        onFed(fed)
        return remainingGuard
    }

    /** RMS sans vues alignees (asShortBuffer/asFloatBuffer exigent un alignement
     *  que les tampons du Transformer ne garantissent pas) : lecture relative. */
    private fun rmsOf(buffer: ByteBuffer): Float {
        val duplicate = buffer.duplicate().order(ByteOrder.LITTLE_ENDIAN)
        val count = duplicate.remaining()
        return if (voiceFormat.encoding == C.ENCODING_PCM_FLOAT && count >= 4) {
            val floats = FloatArray(count / 4)
            for (i in floats.indices) floats[i] = duplicate.float
            MixPlan.rmsPcmFloat(floats, 0, floats.size)
        } else if (count >= 2) {
            val shorts = ShortArray(count / 2)
            for (i in shorts.indices) shorts[i] = duplicate.short
            MixPlan.rmsPcm16(shorts, 0, shorts.size)
        } else {
            0f
        }
    }

    private fun bytesPerFrame(): Int =
        maxOf(1, voiceFormat.channelCount) *
            if (voiceFormat.encoding == C.ENCODING_PCM_FLOAT) 4 else 2

    private fun bytesToUs(bytes: Int): Long {
        if (bytes <= 0) return 0L
        val frames = bytes.toLong() / bytesPerFrame()
        val rate = if (voiceFormat.sampleRate > 0) voiceFormat.sampleRate else 48000
        return frames * 1_000_000L / rate
    }

    private fun bytesToMs(bytes: Int): Float = bytesToUs(bytes) / 1000f

    /** Toute erreur du chemin ajoutee -> pass-through voix seule, export sauf. */
    private inline fun runSafe(block: () -> Unit) {
        if (degraded) return
        try {
            block()
        } catch (error: Throwable) {
            degraded = true
            runCatching {
                if (musicSourceId != C.INDEX_UNSET) delegate.removeSource(musicSourceId)
                musicSourceId = C.INDEX_UNSET
                musicPcm = null
                sfxFeeds.forEach { delegate.removeSource(it.sourceId) }
                sfxFeeds.clear()
            }
        }
    }

    private companion object {
        const val SCRATCH_BYTES = 2048 * 2 * 2          // 2048 frames stereo 16 bits
        const val FEED_GUARD = 8
        const val FULL_DRAIN_GUARD = 4096
    }
}
