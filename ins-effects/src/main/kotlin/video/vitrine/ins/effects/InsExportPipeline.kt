package video.vitrine.ins.effects

import android.content.Context
import androidx.media3.common.Effect
import androidx.media3.common.MediaItem
import androidx.media3.common.util.UnstableApi
import androidx.media3.effect.DefaultVideoFrameProcessor
import androidx.media3.effect.Presentation
import androidx.media3.effect.ScaleAndRotateTransformation
import androidx.media3.transformer.DefaultEncoderFactory
import androidx.media3.transformer.EditedMediaItem
import androidx.media3.transformer.Effects
import androidx.media3.transformer.Transformer
import androidx.media3.transformer.VideoEncoderSettings
import com.google.common.collect.ImmutableList

/**
 * Pipeline Media3 1.11.1, ORDRE IMPOSE (contrat 5.1, R&D v2 5.3) :
 * 1. INS d'abord (LUT 333 electrique SMPTE 170M + verrou teinte homothetie RGB) ;
 * 2. effets metier ensuite (gabarits B3) ;
 * 3. encodage H.264 bitrate par classe, WorkManager ecran eteint (T1).
 *
 * Espace de travail : WORKING_COLOR_SPACE_DEFAULT = couleur ELECTRIQUE explicite
 * (erratum v1 6.6 : le setter est ecrit meme si c'est le defaut reel ; la javadoc
 * est perimee). 8 bits, pas de 16F (T5 : bande passante divisee par 2).
 *
 * Ecart documente : LanczosResample n'existe pas dans l'API publique Media3 1.11.1 ;
 * le downscale passe par Presentation (LAYOUT_SCALE_TO_FIT). A mesurer sur le banc.
 */
@UnstableApi
object InsExportPipeline {

    fun videoFrameProcessorFactory(): DefaultVideoFrameProcessor.Factory =
        DefaultVideoFrameProcessor.Factory.Builder()
            .setSdrWorkingColorSpace(DefaultVideoFrameProcessor.WORKING_COLOR_SPACE_DEFAULT)
            .build()

    fun buildEffects(
        rotationDegrees: Float,
        geometry: ExportSpec.ExportGeometry,
        smartLock: InsSmartLockEffect,
        grainAmount: Float,
        chromaSmoothStrength: Float,
        motion: List<Effect> = emptyList()
    ): Effects {
        val builder0 = ImmutableList.Builder<Effect>()
            // PASSE 1 - geometrie d'abord, re-echantillonnage AVANT tout traitement (B1)
            .add(ScaleAndRotateTransformation.Builder().setRotationDegrees(rotationDegrees).build())
            .add(
                Presentation.createForWidthAndHeight(
                    geometry.width, geometry.height, Presentation.LAYOUT_SCALE_TO_FIT
                )
            )
            // PASSE 2 - shader unique fusionne
            .add(smartLock)
            // PASSE 3 - finition
            .add(InsGrainEffect(grainAmount))
            .add(InsChromaSmoothEffect(chromaSmoothStrength))
        val builder = builder0
        motion.forEach { builder.add(it) }
        val videoEffects = builder.build()
        return Effects(ImmutableList.of(), videoEffects)
    }

    fun editedMediaItem(inputUri: android.net.Uri, effects: Effects): EditedMediaItem =
        EditedMediaItem.Builder(MediaItem.fromUri(inputUri))
            .setEffects(effects)
            .build()

    /**
     * Transformer du pipeline. [audioMixerFactory] (audit D40, A4) : null =
     * comportement historique (audio des rushs traverse sans mixage) ; fourni =
     * BGM duckee + SFX programmes via BgmSfxAudioMixer (repli pass-through
     * interne en cas d'anomalie — l'export n'est jamais casse par l'audio).
     */
    fun transformer(
        context: Context,
        audioMixerFactory: androidx.media3.transformer.AudioMixer.Factory? = null,
        videoBitrateBps: Int = 0
    ): Transformer {
        val builder = Transformer.Builder(context)
            .setVideoFrameProcessorFactory(videoFrameProcessorFactory())
        // D42-F18 : sans factory explicite, Transformer encode au bitrate PAR
        // DEFAUT du device. Mesure sur emulateur (run 41599099153) : 2,6 Mbps
        // pour une cible de classe B a 11,8 Mbps, soit 22 % du contrat 5.1 ->
        // ExportVerifier (>= 85 % de la cible) rejetait TOUS les exports, y
        // compris ceux de duree et de resolution conformes.
        if (videoBitrateBps > 0) {
            val reglages = VideoEncoderSettings.Builder()
                .setBitrate(videoBitrateBps)
                .build()
            builder.setEncoderFactory(
                DefaultEncoderFactory.Builder(context)
                    .setRequestedVideoEncoderSettings(reglages)
                    .build()
            )
        }
        if (audioMixerFactory != null) {
            builder.setAudioMixerFactory(audioMixerFactory)
        }
        return builder.build()
    }
}
