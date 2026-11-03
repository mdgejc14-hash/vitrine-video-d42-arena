package video.vitrine.ins.effects

import android.content.res.AssetManager
import android.media.MediaCodec
import android.media.MediaExtractor
import android.media.MediaFormat
import java.io.File
import java.nio.ByteBuffer
import java.nio.ByteOrder

/**
 * Decodage PCM des ressources audio du mix (audit D40, A4) :
 * - BGM : fichier MP3/M4A telecharge par BgmStore (cache definitif files/bgm)
 *   -> PCM 16 bits via MediaExtractor/MediaCodec synchrone (44,1 ou 48 kHz) ;
 * - SFX : WAV maîtres 48 kHz mono 16 bits des assets (contrat manifest_sfx_v1_3)
 *   -> parseur RIFF strict (44+ entetes, data chunk cherche, jamais d'exception).
 * Tout echec renvoie null : l'export continue SANS musique (repli honnete,
 * jamais de video faussement declaree complete — la telemetrie porte bgm=0/1).
 */
object BgmDecoder {

    /** PCM decode : echantillons 16 bits + cadence + canaux (avant adaptation mixeur). */
    data class Pcm(val samples: ShortArray, val sampleRate: Int, val channels: Int) {
        val frameCount: Int get() = if (channels > 0) samples.size / channels else 0
    }

    private const val TIMEOUT_US = 10_000L

    fun decodeMusic(file: File): Pcm? = runCatching {
        if (!file.isFile || file.length() <= 0L) return null
        val extractor = MediaExtractor()
        try {
            extractor.setDataSource(file.absolutePath)
            val trackIndex = selectAudioTrack(extractor) ?: return null
            extractor.selectTrack(trackIndex)
            val format = extractor.getTrackFormat(trackIndex)
            val mime = format.getString(MediaFormat.KEY_MIME) ?: return null
            val sampleRate = format.getInteger(MediaFormat.KEY_SAMPLE_RATE)
            val channels = format.getInteger(MediaFormat.KEY_CHANNEL_COUNT)
            val codec = MediaCodec.createDecoderByType(mime)
            val out = ArrayList<Short>(sampleRate * channels * 2)
            try {
                codec.start()
                decodeLoop(extractor, codec, out)
            } finally {
                runCatching { codec.stop() }
                codec.release()
            }
            if (out.isEmpty()) return null
            Pcm(out.toShortArray(), sampleRate, channels)
        } finally {
            extractor.release()
        }
    }.getOrNull()

    private fun selectAudioTrack(extractor: MediaExtractor): Int? {
        for (i in 0 until extractor.trackCount) {
            val mime = extractor.getTrackFormat(i).getString(MediaFormat.KEY_MIME).orEmpty()
            if (mime.startsWith("audio/")) return i
        }
        return null
    }

    private fun decodeLoop(
        extractor: MediaExtractor,
        codec: MediaCodec,
        out: ArrayList<Short>
    ) {
        var inputDone = false
        var outputDone = false
        val info = MediaCodec.BufferInfo()
        while (!outputDone) {
            if (!inputDone) inputDone = feedDecoder(extractor, codec)
            outputDone = drainDecoder(codec, info, out, inputDone)
        }
    }

    /** Pousse un paquet du fichier au decodeur ; true quand le flux est fini. */
    private fun feedDecoder(extractor: MediaExtractor, codec: MediaCodec): Boolean {
        val inIndex = codec.dequeueInputBuffer(TIMEOUT_US)
        if (inIndex < 0) return false
        val buffer = codec.getInputBuffer(inIndex) ?: return false
        val size = extractor.readSampleData(buffer, 0)
        if (size < 0) {
            codec.queueInputBuffer(inIndex, 0, 0, 0L, MediaCodec.BUFFER_FLAG_END_OF_STREAM)
            return true
        }
        codec.queueInputBuffer(inIndex, 0, size, extractor.sampleTime, 0)
        extractor.advance()
        return false
    }

    /** Recueille le PCM produit ; true quand le drain est complet. */
    private fun drainDecoder(
        codec: MediaCodec,
        info: MediaCodec.BufferInfo,
        out: ArrayList<Short>,
        inputDone: Boolean
    ): Boolean {
        val outIndex = codec.dequeueOutputBuffer(info, TIMEOUT_US)
        if (outIndex >= 0) {
            val buffer = codec.getOutputBuffer(outIndex)
            if (buffer != null && info.size > 0) {
                appendPcm16(buffer, info.size, out)
            }
            codec.releaseOutputBuffer(outIndex, false)
            return info.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM != 0
        }
        // Certains decodeurs renvoient TRY_AGAIN avant le drain final : borne haute.
        return outIndex == MediaCodec.INFO_TRY_AGAIN_LATER && inputDone && out.isEmpty()
    }

    /** Le decodeur AAC livre du PCM 16 bits little-endian (contrat MediaCodec audio). */
    private fun appendPcm16(buffer: ByteBuffer, size: Int, out: ArrayList<Short>) {
        buffer.order(ByteOrder.LITTLE_ENDIAN)
        val start = buffer.position()
        var offset = 0
        while (offset + 1 < size) {
            out.add(buffer.getShort(start + offset))
            offset += 2
        }
    }

    /**
     * SFX maître des assets (audio/sfx/{categorie}.wav) : RIFF/PCM/16 bits attendu
     * (48 kHz mono au contrat v1.3 ; autres cadences/canaux acceptes et adaptes
     * par le mixeur). null si format inattendu — jamais d'exception remontee.
     */
    fun readWavAsset(assets: AssetManager, path: String): Pcm? = runCatching {
        val bytes = assets.open(path).use { it.readBytes() }
        val header = parseWavHeader(bytes) ?: return null
        val count = minOf(header.dataSize, bytes.size - header.dataOffset) / 2
        if (count <= 0) return null
        val samples = ShortArray(count)
        for (i in 0 until count) {
            samples[i] = leShort(bytes, header.dataOffset + i * 2)
        }
        Pcm(samples, header.sampleRate, header.channels)
    }.getOrNull()

    private data class WavHeader(
        val sampleRate: Int,
        val channels: Int,
        val dataOffset: Int,
        val dataSize: Int
    )

    /** Parse RIFF/WAVE : fmt PCM 16 bits + data ; null si format inattendu. */
    private fun parseWavHeader(bytes: ByteArray): WavHeader? {
        if (bytes.size < 44) return null
        if (String(bytes, 0, 4, Charsets.US_ASCII) != "RIFF") return null
        if (String(bytes, 8, 4, Charsets.US_ASCII) != "WAVE") return null
        var pos = 12
        var sampleRate = 0
        var channels = 0
        var bits = 0
        var dataOffset = -1
        var dataSize = 0
        while (pos + 8 <= bytes.size) {
            val id = String(bytes, pos, 4, Charsets.US_ASCII)
            val size = leInt(bytes, pos + 4)
            val body = pos + 8
            if (id == "fmt ") {
                if (leShort(bytes, body).toInt() != 1) return null   // PCM non etendu uniquement
                channels = leShort(bytes, body + 2).toInt()
                sampleRate = leInt(bytes, body + 4)
                bits = leShort(bytes, body + 14).toInt()
            } else if (id == "data") {
                dataOffset = body
                dataSize = size
            }
            pos = body + size + (size and 1)                          // padding d'alignement
        }
        if (dataOffset < 0 || bits != 16 || channels < 1 || sampleRate < 8000) return null
        return WavHeader(sampleRate, channels, dataOffset, dataSize)
    }

    private fun leShort(b: ByteArray, off: Int): Short =
        ((b[off].toInt() and 0xFF) or (b[off + 1].toInt() shl 8)).toShort()

    private fun leInt(b: ByteArray, off: Int): Int =
        (b[off].toInt() and 0xFF) or ((b[off + 1].toInt() and 0xFF) shl 8) or
            ((b[off + 2].toInt() and 0xFF) shl 16) or ((b[off + 3].toInt() and 0xFF) shl 24)
}
