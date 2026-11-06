package video.vitrine.ins.effects

import android.content.Context
import android.graphics.Bitmap
import android.media.MediaExtractor
import android.media.MediaFormat
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
        val rotationDegrees: Int = 0,
        // D42.8.1 : le verificateur ne regardait QUE l'image. Ces deux champs
        // viennent d'une lecture reelle du conteneur (METADATA_KEY_HAS_AUDIO et
        // piste audio de MediaExtractor), pas d'une simple presence de fichier.
        val hasAudioTrack: Boolean = false,
        /** Duree de la PISTE audio (us -> ms), 0 si le format ne la declare pas. */
        val audioDurationMs: Long = 0L
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
            val hasAudio = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_AUDIO)
                ?.equals("yes", ignoreCase = true) == true
            Measurement(
                durationMs = durationMs,
                width = width,
                height = height,
                measuredBitrateBps = measured,
                nonBlackFrames = countNonBlack(retriever, durationMs),
                rotationDegrees = rotation,
                hasAudioTrack = hasAudio,
                audioDurationMs = if (hasAudio) audioTrackDurationMs(output) else 0L
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

    /**
     * Duree de la PISTE audio lue dans le conteneur (MediaExtractor). La duree
     * globale de MediaMetadataRetriever ne dit rien de la piste audio : une
     * piste tronquee passerait inapercue. 0 = le format ne la declare pas
     * (AudioChecks traite alors le controle comme non concluant, pas comme un
     * echec).
     */
    private fun audioTrackDurationMs(output: File): Long {
        val extractor = MediaExtractor()
        return try {
            extractor.setDataSource(output.absolutePath)
            for (i in 0 until extractor.trackCount) {
                val format = extractor.getTrackFormat(i)
                val mime = format.getString(MediaFormat.KEY_MIME) ?: continue
                if (!mime.startsWith("audio/")) continue
                if (!format.containsKey(MediaFormat.KEY_DURATION)) return 0L
                return format.getLong(MediaFormat.KEY_DURATION) / 1000L
            }
            0L
        } catch (error: Exception) {
            0L
        } finally {
            runCatching { extractor.release() }
        }
    }

    /**
     * Verdict complet. [audioAttendu] est fourni par l'appelant : vrai lorsque le
     * rendu devait produire de l'audio (BGM ou SFX planifies). Faux = video
     * muette VOULUE, et l'absence de piste n'est alors pas un defaut.
     */
    fun judge(
        measurement: Measurement?,
        geometry: ExportSpec.ExportGeometry,
        targetBitrateBps: Int,
        expectedDurationMs: Long,
        audioAttendu: Boolean = false
    ): VerifierPolicy.Checks {
        if (measurement == null) {
            // Aucune mesure du tout : le controle audio n'est pas « reussi »,
            // il n'a pas eu lieu. Muet voulu reste neutre.
            return VerifierPolicy.Checks(
                false, false, false, 0,
                audioVerdict = if (audioAttendu) {
                    AudioChecks.Verdict.NON_VERIFIABLE
                } else {
                    AudioChecks.Verdict.NON_REQUIS
                }
            )
        }
        val durationOk = kotlin.math.abs(measurement.durationMs - expectedDurationMs) <= DURATION_TOLERANCE_MS
        val resolutionOk = measurement.width == geometry.width && measurement.height == geometry.height
        val bitrateOk = VerifierPolicy.bitrateOk(
            measurement.measuredBitrateBps, targetBitrateBps,
            measurement.width, measurement.height
        )
        // D42.8.1 : raccordement REEL de AudioChecks. Sans cet appel, R8
        // supprimait AudioChecks comme code mort et le controle audio du
        // contrat 5.2 n'existait pas dans le binaire livre.
        // Le niveau RMS reste non mesure sur appareil (mesureNiveauDisponible
        // = false) : on ne pretend pas verifier ce qu'on ne decode pas. Le
        // verdict le dit ({VERIFIE_PARTIELLEMENT}), il ne le masque pas.
        // D42.8.2 : une duree de piste illisible (audioDurationMs = 0, format
        // qui ne la declare pas) ne vaut plus « coherent » : AudioChecks rend
        // NON_VERIFIABLE et l'export n'est pas declare conforme.
        val audio = AudioChecks.judge(
            audioAttendu = audioAttendu,
            hasAudioTrack = measurement.hasAudioTrack,
            audioDurationMs = measurement.audioDurationMs,
            videoDurationMs = measurement.durationMs,
            framesNonSilencieuses = 0,
            mesureNiveauDisponible = false
        )
        return VerifierPolicy.Checks(
            durationOk, resolutionOk, bitrateOk, measurement.nonBlackFrames,
            audioVerdict = audio.verdict
        )
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
