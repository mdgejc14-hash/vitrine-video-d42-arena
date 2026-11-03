package video.vitrine.ins.capture

import android.media.MediaCodec
import android.media.MediaCodecInfo
import android.media.MediaFormat
import java.nio.ByteBuffer

/**
 * EncoderProbe (contrat 4.2) : 3 images 720p encodees en H.264 PUIS relues.
 * Mesure le bitrate REEL (le bitrate demande "peut etre ignore" [V]) et verifie
 * que le portrait n'est pas noir (piege #3087). ~30 s au premier lancement.
 */
object EncoderProbe {

    data class ProbeResult(
        val measuredBitrateBps: Long,
        val decodedNonBlack: Boolean,
        val deviceClass: DeviceClass
    )

    private const val WIDTH = 1280
    private const val HEIGHT = 720
    private const val FRAMES = 3
    private const val TARGET_BITRATE = 8_000_000
    private const val BLACK_LUMA_LIMIT = 16

    /** Encode 3 trames YUV synthetiques (gradient) et mesure la sortie reelle. */
    fun probe(): ProbeResult {
        val format = MediaFormat.createVideoFormat(MediaFormat.MIMETYPE_VIDEO_AVC, WIDTH, HEIGHT).apply {
            setInteger(MediaFormat.KEY_COLOR_FORMAT, MediaCodecInfo.CodecCapabilities.COLOR_FormatYUV420SemiPlanar)
            setInteger(MediaFormat.KEY_BIT_RATE, TARGET_BITRATE)
            setInteger(MediaFormat.KEY_FRAME_RATE, 30)
            setInteger(MediaFormat.KEY_I_FRAME_INTERVAL, 1)
        }
        val codec = MediaCodec.createEncoderByType(MediaFormat.MIMETYPE_VIDEO_AVC)
        codec.configure(format, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE)
        codec.start()
        var producedBytes = 0L
        var firstSample: ByteArray? = null
        try {
            for (frame in 0 until FRAMES) {
                val inputIndex = codec.dequeueInputBuffer(TIMEOUT_US)
                if (inputIndex >= 0) {
                    val buffer = codec.getInputBuffer(inputIndex) ?: continue
                    buffer.clear()
                    buffer.put(syntheticNv21(frame))
                    codec.queueInputBuffer(inputIndex, 0, WIDTH * HEIGHT * 3 / 2, frame * FRAME_STEP_US, 0)
                }
                drain(codec) { data ->
                    producedBytes += data.size
                    if (firstSample == null) firstSample = data
                }
            }
            codec.signalEndOfInputStream()
            drain(codec) { data ->
                producedBytes += data.size
                if (firstSample == null) firstSample = data
            }
        } finally {
            codec.stop()
            codec.release()
        }
        val measured = producedBytes * 8 * 30 / FRAMES
        val nonBlack = firstSample?.let { decodeFirstLuma(it) > BLACK_LUMA_LIMIT } ?: false
        return ProbeResult(measured, nonBlack, classify(measured, nonBlack))
    }

    /** Classe mesuree : bitrate reel atteint + sortie lisible. */
    fun classify(measuredBitrateBps: Long, decodedNonBlack: Boolean): DeviceClass = when {
        !decodedNonBlack -> DeviceClass.D
        measuredBitrateBps >= 32_000_000 -> DeviceClass.A
        measuredBitrateBps >= 18_000_000 -> DeviceClass.B
        measuredBitrateBps >= 9_000_000 -> DeviceClass.C
        else -> DeviceClass.D
    }

    private fun drain(codec: MediaCodec, onSample: (ByteArray) -> Unit) {
        val info = MediaCodec.BufferInfo()
        while (true) {
            val index = codec.dequeueOutputBuffer(info, TIMEOUT_US)
            if (index < 0) return
            val buffer: ByteBuffer = codec.getOutputBuffer(index) ?: continue
            val data = ByteArray(info.size)
            buffer.position(info.offset)
            buffer.get(data, 0, info.size)
            onSample(data)
            codec.releaseOutputBuffer(index, false)
        }
    }

    private fun syntheticNv21(frame: Int): ByteArray {
        val yuv = ByteArray(WIDTH * HEIGHT * 3 / 2)
        for (i in 0 until WIDTH * HEIGHT) {
            yuv[i] = ((i % WIDTH + frame * 40) % 256).toByte()
        }
        for (i in WIDTH * HEIGHT until yuv.size) yuv[i] = 128.toByte()
        return yuv
    }

    private fun decodeFirstLuma(sample: ByteArray): Int {
        val decoder = MediaCodec.createDecoderByType(MediaFormat.MIMETYPE_VIDEO_AVC)
        return try {
            val format = MediaFormat.createVideoFormat(MediaFormat.MIMETYPE_VIDEO_AVC, WIDTH, HEIGHT)
            decoder.configure(format, null, null, 0)
            decoder.start()
            val input = decoder.dequeueInputBuffer(TIMEOUT_US)
            if (input >= 0) {
                decoder.getInputBuffer(input)?.apply { clear(); put(sample) }
                decoder.queueInputBuffer(input, 0, sample.size, 0, MediaCodec.BUFFER_FLAG_CODEC_CONFIG)
            }
            var luma = 0
            val info = MediaCodec.BufferInfo()
            val output = decoder.dequeueOutputBuffer(info, TIMEOUT_US)
            if (output >= 0) {
                decoder.getOutputBuffer(output)?.let { luma = it.get(0).toInt() and 0xFF }
                decoder.releaseOutputBuffer(output, false)
            }
            luma
        } catch (error: Exception) {
            0
        } finally {
            runCatching { decoder.stop() }
            decoder.release()
        }
    }

    private const val TIMEOUT_US = 10_000L
    private const val FRAME_STEP_US = 33_333L
}
