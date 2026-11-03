package video.vitrine.ins.effects

import android.content.Context
import android.graphics.Bitmap
import androidx.media3.common.util.UnstableApi
import androidx.media3.effect.GlEffect
import androidx.media3.effect.GlShaderProgram
import androidx.media3.effect.BaseGlShaderProgram
import androidx.media3.common.util.Size
import android.opengl.GLES30

private const val TEXTURE_POOL_CAPACITY = 5

/** Effet INS-SMARTLOCK : passe unique fusionnee (LUT 333 + Theoremes 1/2 + peau). */
@UnstableApi
class InsSmartLockEffect(
    private val lutBitmap: Bitmap? = null,
    private val exposureGain: Float = 1f,
    private val wbAnchor: FloatArray = floatArrayOf(1f, 1f, 1f),
    private val productHue: FloatArray = floatArrayOf(0f, 0f, 0f),
    private val productToleranceDeg: Float = 20f,
    private val chromaSmooth: Float = 0f
) : GlEffect {
    override fun toGlShaderProgram(context: Context, useHdr: Boolean): GlShaderProgram =
        InsSmartLockShaderProgram(
            context, useHdr, lutBitmap, exposureGain, wbAnchor,
            productHue, productToleranceDeg, chromaSmooth
        )
}

/** Effet INS-Grain : grain module par la luminance, semence par image (R&D effet 6). */
@UnstableApi
class InsGrainEffect(private val amount: Float = 0.02f) : GlEffect {
    override fun toGlShaderProgram(context: Context, useHdr: Boolean): GlShaderProgram =
        object : BaseGlShaderProgram(useHdr, TEXTURE_POOL_CAPACITY) {
            private val program = InsGl.linkProgram(
                InsGl.assetText(context, "shaders/ins_smartlock.vert"),
                InsGl.assetText(context, "shaders/ins_grain.frag")
            )

            override fun configure(inputWidth: Int, inputHeight: Int): Size =
                Size(inputWidth, inputHeight)

            override fun drawFrame(inputTexId: Int, presentationTimeUs: Long) {
                GLES30.glUseProgram(program)
                InsGl.bindTexture(0, inputTexId)
                GLES30.glUniform1i(GLES30.glGetUniformLocation(program, "uTexSampler"), 0)
                GLES30.glUniform1f(GLES30.glGetUniformLocation(program, "uGrainAmount"), amount)
                // semence = temps de presentation : change a chaque image, jamais figee
                GLES30.glUniform1f(GLES30.glGetUniformLocation(program, "uTimeSeed"), presentationTimeUs % 9973f)
                InsGl.drawQuad(program)
            }

            override fun release() {
                GLES30.glDeleteProgram(program)
                super.release()
            }
        }
}

/** Effet INS-ChromaSmooth : lissage chroma 5x5, luma intacte (regle C1, pilote ISO). */
@UnstableApi
class InsChromaSmoothEffect(private val strength: Float = 0f) : GlEffect {
    override fun toGlShaderProgram(context: Context, useHdr: Boolean): GlShaderProgram =
        object : BaseGlShaderProgram(useHdr, TEXTURE_POOL_CAPACITY) {
            private val program = InsGl.linkProgram(
                InsGl.assetText(context, "shaders/ins_smartlock.vert"),
                InsGl.assetText(context, "shaders/ins_chroma_smooth.frag")
            )

            override fun configure(inputWidth: Int, inputHeight: Int): Size =
                Size(inputWidth, inputHeight)

            override fun drawFrame(inputTexId: Int, presentationTimeUs: Long) {
                GLES30.glUseProgram(program)
                InsGl.bindTexture(0, inputTexId)
                GLES30.glUniform1i(GLES30.glGetUniformLocation(program, "uTexSampler"), 0)
                GLES30.glUniform1f(GLES30.glGetUniformLocation(program, "uStrength"), strength)
                GLES30.glUniform2f(GLES30.glGetUniformLocation(program, "uTexelSize"), 1f / 1080f, 1f / 1920f)
                InsGl.drawQuad(program)
            }

            override fun release() {
                GLES30.glDeleteProgram(program)
                super.release()
            }
        }
}
