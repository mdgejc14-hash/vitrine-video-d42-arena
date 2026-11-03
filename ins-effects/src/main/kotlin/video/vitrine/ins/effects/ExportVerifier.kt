package video.vitrine.ins.effects

import android.content.Context
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import java.io.File

/**
 * ExportVerifier (contrat 5.2) : APRES chaque export, relecture duree/resolution/
 * bitrate REEL + 3 images verifiees non noires. L'application ne se fait pas confiance.
 */
object ExportVerifier {

    data class Measurement(
        val durationMs: Long,
        /** Largeur AFFICHEE (rotation appliquee), pas la largeur stockee. */
        val width: Int,
        /** Hauteur AFFICHEE (rotation appliquee). */
        val height: Int,
        val measuredBitrateBps: Long,
        val nonBlackFrames: Int,
        /** Rotation du conteneur : 0/90/180/270. */
        val rotationDegrees: Int = 0
    )

    fun measure(context: Context, output: File, expectedDurationMs: Long): Measurement? {
        if (!output.exists() || output.length() == 0L) return null
        val retriever = MediaMetadataRetriever()
        return try {
            retriever.setDataSource(context, android.net.Uri.fromFile(output))
            val durationMs = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull() ?: 0L
            val largeurStockee = retriever
                .extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH)?.toIntOrNull() ?: 0
            val hauteurStockee = retriever
                .extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT)?.toIntOrNull() ?: 0
            // D42-F16 : le conteneur stocke l'image dans son orientation de
            // captation et la redresse par une matrice de rotation. Un rush
            // 720x1280 ressort donc en 1280x720 + rotation -90. Comparer la
            // taille STOCKEE a la geometrie portrait faisait echouer TOUS les
            // exports valides (constate run 41592863733 : video de 35,04 s
            // conforme, rejetee, puis repli cloud).
            val rotation = (retriever
                .extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION)?.toIntOrNull() ?: 0)
                .let { ((it % 360) + 360) % 360 }
            val (width, height) = orienter(largeurStockee, hauteurStockee, rotation)
            val measured = if (durationMs > 0) output.length() * 8 * 1000 / durationMs else 0L
            Measurement(
                durationMs = durationMs,
                width = width,
                height = height,
                measuredBitrateBps = measured,
                nonBlackFrames = countNonBlack(retriever, durationMs),
                rotationDegrees = rotation
            )
        } catch (error: Exception) {
            null
        } finally {
            retriever.release()
        }
    }

    /**
     * D42-F16 : dimension AFFICHEE d'une video a partir de sa taille stockee et
     * de la rotation du conteneur. Isole et testable sans Android.
     */
    fun orienter(largeurStockee: Int, hauteurStockee: Int, rotation: Int): Pair<Int, Int> {
        val r = ((rotation % 360) + 360) % 360
        return if (r == 90 || r == 270) hauteurStockee to largeurStockee
        else largeurStockee to hauteurStockee
    }

    fun judge(
        measurement: Measurement?,
        geometry: ExportSpec.ExportGeometry,
        targetBitrateBps: Int,
        expectedDurationMs: Long
    ): VerifierPolicy.Checks {
        if (measurement == null) {
            return VerifierPolicy.Checks(false, false, false, 0)
        }
        val durationOk = kotlin.math.abs(measurement.durationMs - expectedDurationMs) <= DURATION_TOLERANCE_MS
        val resolutionOk = measurement.width == geometry.width && measurement.height == geometry.height
        val bitrateOk = VerifierPolicy.bitrateOk(
            measurement.measuredBitrateBps, targetBitrateBps,
            measurement.width, measurement.height
        )
        return VerifierPolicy.Checks(durationOk, resolutionOk, bitrateOk, measurement.nonBlackFrames)
    }

    private fun countNonBlack(retriever: MediaMetadataRetriever, durationMs: Long): Int {
        val fractions = doubleArrayOf(0.10, 0.50, 0.90)
        var count = 0
        for (fraction in fractions) {
            val atUs = (durationMs * fraction * 1000).toLong()
            val frame: Bitmap? = retriever.getFrameAtTime(atUs, MediaMetadataRetriever.OPTION_CLOSEST)
            if (frame != null && averageLuma(frame) > BLACK_LUMA_LIMIT) count++
            frame?.recycle()
        }
        return count
    }

    private fun averageLuma(bitmap: Bitmap): Int {
        val scaled = Bitmap.createScaledBitmap(bitmap, SAMPLE_SIZE, SAMPLE_SIZE, true)
        var sum = 0L
        for (y in 0 until SAMPLE_SIZE) {
            for (x in 0 until SAMPLE_SIZE) {
                val pixel = scaled.getPixel(x, y)
                val r = pixel shr 16 and 0xFF
                val g = pixel shr 8 and 0xFF
                val b = pixel and 0xFF
                sum += (77 * r + 150 * g + 29 * b) / 256   // luma SMPTE 170M approximee
            }
        }
        if (scaled !== bitmap) scaled.recycle()
        return (sum / (SAMPLE_SIZE * SAMPLE_SIZE)).toInt()
    }

    private const val BLACK_LUMA_LIMIT = 16
    private const val SAMPLE_SIZE = 32
    private const val DURATION_TOLERANCE_MS = 500L
}
