package video.vitrine.ins.effects

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.media3.common.util.UnstableApi
import androidx.media3.effect.BaseGlShaderProgram
import androidx.media3.common.util.Size
import android.opengl.GLES30
import android.opengl.GLUtils
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer

/** Utilitaires GL bruts (GLES30) : compilation, quad plein cadre, textures. */
@UnstableApi
internal object InsGl {

    private val QUAD_POSITIONS = floatArrayOf(-1f, -1f, 1f, -1f, -1f, 1f, 1f, 1f)
    private val QUAD_TEXCOORDS = floatArrayOf(0f, 0f, 1f, 0f, 0f, 1f, 1f, 1f)

    fun buffer(values: FloatArray): FloatBuffer =
        ByteBuffer.allocateDirect(values.size * 4).order(ByteOrder.nativeOrder())
            .asFloatBuffer().apply { put(values); position(0) }

    fun compileShader(type: Int, source: String): Int {
        val shader = GLES30.glCreateShader(type)
        GLES30.glShaderSource(shader, source)
        GLES30.glCompileShader(shader)
        return shader
    }

    fun linkProgram(vertexSource: String, fragmentSource: String): Int {
        val program = GLES30.glCreateProgram()
        GLES30.glAttachShader(program, compileShader(GLES30.GL_VERTEX_SHADER, vertexSource))
        GLES30.glAttachShader(program, compileShader(GLES30.GL_FRAGMENT_SHADER, fragmentSource))
        GLES30.glLinkProgram(program)
        return program
    }

    fun bindTexture(unit: Int, textureId: Int) {
        GLES30.glActiveTexture(GLES30.GL_TEXTURE0 + unit)
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, textureId)
    }

    fun uploadBitmap(bitmap: Bitmap): Int {
        val textures = IntArray(1)
        GLES30.glGenTextures(1, textures, 0)
        bindTexture(0, textures[0])
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_MIN_FILTER, GLES30.GL_LINEAR)
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_MAG_FILTER, GLES30.GL_LINEAR)
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_WRAP_S, GLES30.GL_CLAMP_TO_EDGE)
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_WRAP_T, GLES30.GL_CLAMP_TO_EDGE)
        GLUtils.texImage2D(GLES30.GL_TEXTURE_2D, 0, bitmap, 0)
        return textures[0]
    }

    /** LUT identite 33x33x33 en bande 1089x33 : repli quand aucun asset LUT fourni. */
    fun identityLutBitmap(): Bitmap {
        val size = 33
        val bitmap = Bitmap.createBitmap(size * size, size, Bitmap.Config.ARGB_8888)
        for (b in 0 until size) {
            for (g in 0 until size) {
                for (r in 0 until size) {
                    bitmap.setPixel(
                        b * size + r,
                        g,
                        android.graphics.Color.rgb(r * 255 / 32, g * 255 / 32, b * 255 / 32)
                    )
                }
            }
        }
        return bitmap
    }

    fun drawQuad(program: Int) {
        val position = GLES30.glGetAttribLocation(program, "aPosition")
        val texCoords = GLES30.glGetAttribLocation(program, "aTexCoords")
        GLES30.glEnableVertexAttribArray(position)
        GLES30.glVertexAttribPointer(position, 2, GLES30.GL_FLOAT, false, 0, buffer(QUAD_POSITIONS))
        GLES30.glEnableVertexAttribArray(texCoords)
        GLES30.glVertexAttribPointer(texCoords, 2, GLES30.GL_FLOAT, false, 0, buffer(QUAD_TEXCOORDS))
        GLES30.glDrawArrays(GLES30.GL_TRIANGLE_STRIP, 0, 4)
    }

    fun assetText(context: Context, path: String): String =
        context.assets.open(path).bufferedReader().use { it.readText() }
}

/** Passe unique fusionnee INS-SMARTLOCK (R&D v2 5.2 : LUT + Theoremes 1/2 + masque peau). */
@UnstableApi
class InsSmartLockShaderProgram(
    context: Context,
    useHdr: Boolean,
    private val lutBitmap: Bitmap?,
    private val exposureGain: Float,
    private val wbAnchor: FloatArray,
    private val productHue: FloatArray,
    private val productToleranceDeg: Float,
    private val chromaSmooth: Float
) : BaseGlShaderProgram(useHdr, TEXTURE_POOL_CAPACITY) {

    private val program = InsGl.linkProgram(
        InsGl.assetText(context, "shaders/ins_smartlock.vert"),
        InsGl.assetText(context, "shaders/ins_smartlock.frag")
    )
    private val lutTexture = InsGl.uploadBitmap(lutBitmap ?: InsGl.identityLutBitmap())
    private val maskTexture = InsGl.uploadBitmap(neutralMask())

    /** Masque neutre 64x64 (alpha 0) : le lissage peau est nul tant que ML Kit n'a pas masque. */
    private fun neutralMask(): Bitmap =
        Bitmap.createBitmap(64, 64, Bitmap.Config.ARGB_8888)

    override fun configure(inputWidth: Int, inputHeight: Int): Size =
        Size(inputWidth, inputHeight)

    override fun drawFrame(inputTexId: Int, presentationTimeUs: Long) {
        GLES30.glUseProgram(program)
        InsGl.bindTexture(0, inputTexId)
        GLES30.glUniform1i(GLES30.glGetUniformLocation(program, "uTexSampler"), 0)
        InsGl.bindTexture(1, lutTexture)
        GLES30.glUniform1i(GLES30.glGetUniformLocation(program, "uLutSampler"), 1)
        InsGl.bindTexture(2, maskTexture)
        GLES30.glUniform1i(GLES30.glGetUniformLocation(program, "uSkinMask"), 2)
        GLES30.glUniform1f(GLES30.glGetUniformLocation(program, "uExposureGain"), exposureGain)
        GLES30.glUniform3f(GLES30.glGetUniformLocation(program, "uWbAnchor"), wbAnchor[0], wbAnchor[1], wbAnchor[2])
        GLES30.glUniform3f(GLES30.glGetUniformLocation(program, "uProductHue"), productHue[0], productHue[1], productHue[2])
        GLES30.glUniform1f(GLES30.glGetUniformLocation(program, "uProductTolerance"), productToleranceDeg)
        GLES30.glUniform1f(GLES30.glGetUniformLocation(program, "uChromaSmooth"), chromaSmooth)
        GLES30.glUniform2f(GLES30.glGetUniformLocation(program, "uTexelSize"), 1f / 1080f, 1f / 1920f)
        InsGl.drawQuad(program)
    }

    override fun release() {
        GLES30.glDeleteProgram(program)
        GLES30.glDeleteTextures(1, intArrayOf(lutTexture), 0)
        GLES30.glDeleteTextures(1, intArrayOf(maskTexture), 0)
        super.release()
    }

    private companion object {
        const val TEXTURE_POOL_CAPACITY = 5
    }
}
