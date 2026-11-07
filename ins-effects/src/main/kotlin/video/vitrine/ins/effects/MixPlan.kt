package video.vitrine.ins.effects

import kotlin.math.exp
import kotlin.math.sqrt

/**
 * Plan de mixage PUR (audit D40, reconnectage A4) : niveaux musicaux et SFX du
 * contrat AudioChain appliques ENFIN dans le rendu on-device via BgmSfxAudioMixer.
 *
 * Chiffres issus du contrat livré (AudioChain.kt) et du bloc `audio.mix` des
 * gabarits V2.0 : musique -20 dB (plage -18/-22), ducking sous la voix
 * (profondeur gabarit, defaut -14 dB), SFX -25 dB, seuil/ratio/attaque/relache
 * du sidechain = constantes AudioChain. Logique pure, testee JVM (MixPlanTest).
 */
object MixPlan {

    /** Gain lineaire musique au repos : MUSIC_VOLUME_DB = -20 dB -> 0,1. */
    fun musicBaseGain(): Float = dbToLinear(AudioChain.MUSIC_VOLUME_DB)

    /**
     * D42.21 — gain musique en mode SOLO (aucune voix dans les rushs) : la
     * musique porte seule la vidéo. 0 dB : les fichiers BGM sont déjà calibrés
     * à −16 LUFS intégré / −1 dBTP (BS.1770-4, mesuré après encodage par le
     * générateur v2) — les atténuer les rendrait inaudibles.
     */
    const val MUSIC_SOLO_GAIN_DB = 0.0

    fun musicBaseGainDb(db: Double): Float = dbToLinear(db)

    /** Gain lineaire SFX : -25 dB (banc ffmpeg) -> ~0,0562. */
    const val SFX_GAIN_DB = -25.0
    fun sfxGain(): Float = dbToLinear(SFX_GAIN_DB)

    /** Profondeur de ducking par defaut (audio.mix.ducking_musique_sous_voix_db). */
    const val DUCK_DEPTH_DB_DEFAULT = -14.0

    fun dbToLinear(db: Double): Float = Math.pow(10.0, db / 20.0).toFloat()

    /** RMS d'un bloc PCM 16 bits (echantillons interleaves), normalise 0..1. */
    fun rmsPcm16(samples: ShortArray, offset: Int, length: Int): Float {
        if (length <= 0) return 0f
        var sum = 0.0
        var i = offset
        val end = minOf(offset + length, samples.size)
        while (i < end) {
            val v = samples[i].toDouble() / 32768.0
            sum += v * v
            i++
        }
        return sqrt(sum / (end - offset)).toFloat()
    }

    /** RMS d'un bloc PCM float 32 bits, normalise 0..1. */
    fun rmsPcmFloat(samples: FloatArray, offset: Int, length: Int): Float {
        if (length <= 0) return 0f
        var sum = 0.0
        var i = offset
        val end = minOf(offset + length, samples.size)
        while (i < end) {
            val v = samples[i].toDouble()
            sum += v * v
            i++
        }
        return sqrt(sum / (end - offset)).toFloat()
    }

    /**
     * Cible de ducking : voix au-dessus du seuil -> musique baissee de
     * duckDepthDb ; sinon retour au repos. Semantique sidechain AudioChain
     * (threshold 0,045, ratio 4) approximee par un seuil franc + profondeur
     * mesuree au banc : le resultat audible est la pompe musique/voix du contrat.
     */
    fun duckTargetGain(voiceRms: Float, duckDepthDb: Double = DUCK_DEPTH_DB_DEFAULT): Float =
        if (voiceRms > AudioChain.DUCK_THRESHOLD) dbToLinear(duckDepthDb) else 1.0f

    /**
     * Lissage attaque/relache (one-pole, constantes AudioChain : 12 ms / 260 ms).
     * [dtMs] = duree du bloc voix analyse. Retourne le gain musique applique.
     */
    fun approachGain(current: Float, target: Float, dtMs: Float): Float {
        val tauMs = if (target < current) AudioChain.DUCK_ATTACK_MS else AudioChain.DUCK_RELEASE_MS
        if (tauMs <= 0f) return target
        val coeff = 1f - exp(-dtMs / tauMs)
        return current + (target - current) * coeff
    }

    /** Volume final musique = base (-20 dB) x envelope ducking. */
    fun musicVolume(duckEnvelope: Float): Float = musicBaseGain() * duckEnvelope

    /** Volume final musique avec base paramétrable (D42.21 : mode solo). */
    fun musicVolume(duckEnvelope: Float, baseDb: Double): Float =
        musicBaseGainDb(baseDb) * duckEnvelope

    /** Resampling lineaire PCM 16 bits mono->mono (44,1k -> 48k etc.). */
    fun resampleLinear(input: ShortArray, fromRate: Int, toRate: Int): ShortArray {
        if (fromRate == toRate || input.isEmpty()) return input
        val outLength = (input.size.toLong() * toRate / fromRate).toInt()
        val out = ShortArray(outLength)
        val ratio = fromRate.toDouble() / toRate
        for (i in 0 until outLength) {
            val srcPos = i * ratio
            val i0 = srcPos.toInt()
            val frac = (srcPos - i0).toFloat()
            val a = input[i0]
            val b = if (i0 + 1 < input.size) input[i0 + 1] else a
            out[i] = (a + (b - a) * frac).toInt().coerceIn(-32768, 32767).toShort()
        }
        return out
    }

    /** Mono 16 bits -> stereo interleave (duplication, phase preservee). */
    fun monoToStereo(mono: ShortArray): ShortArray {
        val out = ShortArray(mono.size * 2)
        for (i in mono.indices) {
            out[i * 2] = mono[i]
            out[i * 2 + 1] = mono[i]
        }
        return out
    }
}
