package video.vitrine.ins.effects

import android.graphics.Bitmap
import android.graphics.Matrix
import androidx.media3.common.Effect
import androidx.media3.common.util.UnstableApi
import androidx.media3.effect.BitmapOverlay
import androidx.media3.effect.MatrixTransformation
import androidx.media3.effect.OverlayEffect
import androidx.media3.effect.TextureOverlay
import androidx.media3.effect.TimestampWrapper
import com.google.common.collect.ImmutableList
import kotlin.math.sin

/**
 * Cinematique deterministe du beat sheet : punch-in z(t) autour du point d'interet
 * (fx, fy), tremblement sinusoïdes desynchronisees, transitions swipe/flash/glitch
 * fenetrees par TimestampWrapper. Meme entree = meme sortie.
 */
@UnstableApi
object CameraMoves {

    const val SWIPE_DURATION_S = 0.25
    const val FLASH_DURATION_S = 0.12
    private const val MICRO = 1_000_000.0

    /** Zoom punch-in lineaire zStart -> zEnd centre sur (fx, fy) + shake. */
    class PunchInZoom(private val plan: BeatSheetPlan, private val shakeBoost: Float = 1f) :
        MatrixTransformation {

        override fun getMatrix(presentationTimeUs: Long): Matrix {
            val t = presentationTimeUs / MICRO
            val progress = ((t - plan.t0) / (plan.t1 - plan.t0)).coerceIn(0.0, 1.0)
            val zoom = plan.zStart + (plan.zEnd - plan.zStart) * progress
            val centerX = plan.fx * 2.0 - 1.0
            val centerY = 1.0 - plan.fy * 2.0
            val matrix = Matrix()
            matrix.postScale(zoom.toFloat(), zoom.toFloat())
            matrix.postTranslate((centerX * (1.0 - zoom)).toFloat(), (centerY * (1.0 - zoom)).toFloat())
            val amplitude = plan.shake * shakeBoost * 0.01
            if (amplitude > 0.0) {
                val dx = amplitude * sin(2.0 * Math.PI * 13.0 * t) + 0.5 * amplitude * sin(2.0 * Math.PI * 29.0 * t + 1.7)
                val dy = amplitude * sin(2.0 * Math.PI * 11.0 * t + 0.9)
                matrix.postTranslate(dx.toFloat(), dy.toFloat())
            }
            return matrix
        }
    }

    /** Entree swipe horizontale sur [t0, t0 + 0.25 s]. */
    class SwipeIn(private val t0: Double) : MatrixTransformation {

        override fun getMatrix(presentationTimeUs: Long): Matrix {
            val t = presentationTimeUs / MICRO
            val progress = ((t - t0) / SWIPE_DURATION_S).coerceIn(0.0, 1.0)
            val matrix = Matrix()
            matrix.postTranslate((progress - 1.0).toFloat() * 2.0f, 0f)
            return matrix
        }
    }

    /** Transition du plan : cut/zoom = aucun effet supplementaire, swipe/flash/glitch fenetres. */
    fun transitionFor(plan: BeatSheetPlan): List<Effect> =
        when (plan.transition) {
            "swipe" -> listOf(
                TimestampWrapper(SwipeIn(plan.t0), us(plan.t0), us(plan.t0 + SWIPE_DURATION_S))
            )
            "flash" -> listOf(flash(plan.t0, FLASH_DURATION_S))
            "glitch" -> listOf(
                TimestampWrapper(PunchInZoom(plan, shakeBoost = 3f), us(plan.t0), us(plan.t0 + FLASH_DURATION_S)),
                flash(plan.t0, FLASH_DURATION_S)
            )
            else -> emptyList()
        }

    /** Cinematique complete d'un plan : punch-in permanent + transition d'entree. */
    fun effectsFor(plan: BeatSheetPlan): List<Effect> =
        listOf<Effect>(PunchInZoom(plan)) + transitionFor(plan)

    private fun flash(startS: Double, durationS: Double): Effect {
        val white = Bitmap.createBitmap(8, 8, Bitmap.Config.ARGB_8888)
        white.eraseColor(0xFFFFFFFF.toInt())
        return TimestampWrapper(
            OverlayEffect(listOf<TextureOverlay>(BitmapOverlay.createStaticBitmapOverlay(white))),
            us(startS),
            us(startS + durationS)
        )
    }

    private fun us(seconds: Double): Long = (seconds * MICRO).toLong()
}
