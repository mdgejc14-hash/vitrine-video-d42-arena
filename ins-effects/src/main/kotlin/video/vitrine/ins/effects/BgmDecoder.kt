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

    private const val TAG = "D42-BGM"

    /** PCM decode : echantillons 16 bits + cadence + canaux (avant adaptation mixeur). */
    data class Pcm(val samples: ShortArray, val sampleRate: Int, val channels: Int) {
        val frameCount: Int get() = if (channels > 0) samples.size / channels else 0
    }

    private const val TIMEOUT_US = 10_000L

    fun decodeMusic(file: File): Pcm? {
        // D42.29 (P2, étage 1) : ce décodeur a été la cause racine du défaut
        // post-RC13 (start sans configure -> IllegalStateException avalée SANS
        // aucune trace). Toute issue — succès comme échec — est désormais
        // journalisée : le banc distingue « musique décodée à X dB » (chaîne
        // audio saine) de « décodage en échec » (défaut produit) sans attendre
        // l'analyse du MP4 final.
        val debut = System.currentTimeMillis()
        android.util.Log.i(
            TAG,
            "décodage BGM : ${file.name} (${file.length()} octets)"
        )
        return runCatching {
        if (!file.isFile || file.length() <= 0L) {
            android.util.Log.w(TAG, "BGM NON décodée : fichier absent ou vide (${file.absolutePath})")
            return null
        }
        val extractor = MediaExtractor()
        try {
            extractor.setDataSource(file.absolutePath)
            val trackIndex = selectAudioTrack(extractor)
            if (trackIndex == null) {
                android.util.Log.w(TAG, "BGM NON décodée : aucune piste audio dans ${file.name}")
                return null
            }
            extractor.selectTrack(trackIndex)
            val format = extractor.getTrackFormat(trackIndex)
            val mime = format.getString(MediaFormat.KEY_MIME)
            if (mime == null) {
                android.util.Log.w(TAG, "BGM NON décodée : MIME absent dans ${file.name}")
                return null
            }
            val sampleRate = format.getInteger(MediaFormat.KEY_SAMPLE_RATE)
            val channels = format.getInteger(MediaFormat.KEY_CHANNEL_COUNT)
            val codec = MediaCodec.createDecoderByType(mime)
            val out = ArrayList<Short>(sampleRate * channels * 2)
            try {
                // D42.28-26 (bug racine banc A v3.3/v3.4) : configure() est
                // OBLIGATOIRE avant start(). Sans lui, start() leve
                // IllegalStateException, avalee par le runCatching ci-dessous :
                // decodeMusic rendait null en ~5 ms et l'export sortait en SFX
                // seuls (RMS -53,26 dB) alors que le BGM cache etait valide,
                // trouve et reconnu (audio/mpeg 44100 Hz stereo dans les logs
                // CCodec). run 42786468288, lab banc A v3.4.
                codec.configure(format, null, null, 0)
                codec.start()
                decodeLoop(extractor, codec, out)
            } finally {
                runCatching { codec.stop() }
                codec.release()
            }
            if (out.isEmpty()) {
                android.util.Log.w(TAG, "BGM NON décodée : drain sans aucun PCM (${file.name})")
                return null
            }
            val echantillons = out.toShortArray()
            android.util.Log.i(
                TAG,
                "BGM DÉCODÉE : ${echantillons.size} éch. ${sampleRate} Hz ${channels} can. " +
                    "en ${System.currentTimeMillis() - debut} ms — RMS ${rmsDb(echantillons)} dB, " +
                    "crête ${peakDb(echantillons)} dB"
            )
            Pcm(echantillons, sampleRate, channels)
        } finally {
            extractor.release()
        }
        }.onFailure {
            android.util.Log.w(
                TAG,
                "BGM NON décodée (exception, ${file.name}) : " +
                    "${it.javaClass.simpleName}: ${it.message}"
            )
        }.getOrNull()
    }

    /** RMS dBFS du PCM 16 bits (diagnostic banc D42.29 — aucune décision produit). */
    private fun rmsDb(samples: ShortArray): String {
        var somme = 0.0
        for (s in samples) {
            val v = s.toDouble()
            somme += v * v
        }
        if (samples.isEmpty()) return "n/a"
        val rms = kotlin.math.sqrt(somme / samples.size)
        return if (rms < 1.0) "-inf" else String.format(java.util.Locale.US, "%.1f", 20 * kotlin.math.log10(rms / 32768.0))
    }

    /** Crête dBFS du PCM 16 bits (diagnostic banc D42.29). */
    private fun peakDb(samples: ShortArray): String {
        var max = 1
        for (s in samples) max = maxOf(max, kotlin.math.abs(s.toInt()))
        return String.format(java.util.Locale.US, "%.1f", 20 * kotlin.math.log10(max / 32768.0))
    }

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
        val info = MediaCodec.BufferInfo()
        // D42.28-26 : patience bornee. L'ancienne heuristique d'abandon
        // (TRY_AGAIN + entree epuisee + rien produit) coupait un decodage
        // sain si le codec logiciel livre son premier PCM seulement apres
        // l'EOS d'entree (mise en tampon C2). On n'abandonne plus qu'apres
        // 300 attentes vides consecutives (3 s) une fois l'entree epuisee ;
        // INFO_OUTPUT_FORMAT_CHANGED est attendu avant le premier buffer
        // utile et ne compte pas comme un echec. Borne globale de 20 000
        // tours contre toute boucle infinie theorique.
        var attentesVides = 0
        var tours = 0
        while (attentesVides < 300 && tours < 20_000) {
            tours++
            if (!inputDone) inputDone = feedDecoder(extractor, codec)
            when (val outIndex = codec.dequeueOutputBuffer(info, TIMEOUT_US)) {
                MediaCodec.INFO_TRY_AGAIN_LATER -> if (inputDone) attentesVides++
                MediaCodec.INFO_OUTPUT_FORMAT_CHANGED -> Unit
                else -> if (outIndex >= 0) {
                    attentesVides = 0
                    val buffer = codec.getOutputBuffer(outIndex)
                    if (buffer != null && info.size > 0) {
                        appendPcm16(buffer, info.size, out)
                    }
                    val finFlux =
                        info.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM != 0
                    codec.releaseOutputBuffer(outIndex, false)
                    if (finFlux) return
                }
            }
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
