package video.vitrine.app.qa

import android.content.Context
import android.media.MediaCodec
import android.media.MediaExtractor
import android.media.MediaFormat
import android.os.SystemClock
import video.vitrine.ins.capture.VideoFrameSource

/**
 * Niveau B : source deterministe issue d'un MP4 fixture (testsrc2 + bip 1 kHz,
 * genere par ffmpeg en CI, jamais commite). MediaExtractor/MediaCodec lisent la
 * fixture ; les frames alimentent la MEME chaine export (Media3) apres la
 * frontiere VideoFrameSource. Horloge monotone injectable pour rejouer les
 * incidents (frames tardives, retour arriere, interruption).
 */
class FixtureFrameSource(
    context: Context,
    private val fixturePath: String,
    private val fakeClock: (() -> Long)? = null,
) : VideoFrameSource {

    private val extractor = MediaExtractor()
    private var codec: MediaCodec? = null
    private var ended = false
    private var lastTs = -1L

    init {
        runCatching {
            extractor.setDataSource(fixturePath)
            val idx = (0 until extractor.trackCount).firstOrNull {
                extractor.getTrackFormat(it).getString(MediaFormat.KEY_MIME)?.startsWith("video/") == true
            }
            if (idx != null) {
                extractor.selectTrack(idx)
                val fmt = extractor.getTrackFormat(idx)
                codec = MediaCodec.createDecoderByType(
                    fmt.getString(MediaFormat.KEY_MIME) ?: "video/avc"
                )
            }
        }
    }

    override val width: Int = 1280
    override val height: Int = 720

    override fun clockMs(): Long = fakeClock?.invoke() ?: SystemClock.elapsedRealtime()

    override fun nextFrame(): VideoFrameSource.Frame? {
        if (ended) return null
        val sampleSize = runCatching { extractor.sampleSize }.getOrNull()
        val sampleTime = runCatching { extractor.sampleTime }.getOrNull()
        if (sampleSize == null || sampleSize < 0 || sampleTime == null) {
            ended = true
            return null
        }
        val buf = ByteArray(sampleSize.toInt())
        val read = runCatching { extractor.readSampleData(java.nio.ByteBuffer.wrap(buf), 0) }
            .getOrDefault(-1)
        if (read < 0) {
            ended = true
            return null
        }
        val tsMs = sampleTime / 1000L
        lastTs = tsMs
        runCatching { extractor.advance() }
        return VideoFrameSource.Frame(buf, tsMs, 0)
    }

    override fun lifecycle(): VideoFrameSource.LifecycleSignal = when {
        ended -> VideoFrameSource.LifecycleSignal.ENDED
        lastTs > clockMs() -> VideoFrameSource.LifecycleSignal.CLOCK_BACKWARD
        else -> VideoFrameSource.LifecycleSignal.OK
    }

    override fun release() {
        runCatching { codec?.stop() }
        runCatching { codec?.release() }
        runCatching { extractor.release() }
    }

    companion object {
        /** Chemin conventionnel de la fixture dans la variante qaDeterministic. */
        fun fixtureAsset(context: Context): String? =
            runCatching {
                val f = java.io.File(context.cacheDir, "fixture_qa.mp4")
                context.assets.open("qa_fixtures/fixture_qa.mp4").use { input ->
                    f.outputStream().use { output -> input.copyTo(output) }
                }
                f.absolutePath
            }.getOrNull()
    }
}
