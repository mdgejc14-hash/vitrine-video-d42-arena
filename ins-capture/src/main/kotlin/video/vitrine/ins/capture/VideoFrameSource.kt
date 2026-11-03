package video.vitrine.ins.capture

/**
 * Frontiere effective du pipeline video (VV Remote QA s4 niveau B).
 * Apres cette frontiere : MEME chaine de rendu, minuterie, encodage et muxing
 * (Media3 Transformer cote export). CameraXFrameSource = capture reelle ;
 * FixtureFrameSource (variante qaDeterministic uniquement) = MP4 connu via
 * MediaExtractor/MediaCodec. Ce niveau NE VALIDE PAS : permissions CameraX,
 * vrai Recorder VideoCapture, autofocus, microphones, pilotes OEM (niveaux A/C).
 */
interface VideoFrameSource {

    /** Largeur/hauteur attendues du flux ; un changement declenche un reset rendu. */
    val width: Int
    val height: Int

    /** Horloge monotone de la source (ms) : injectable pour tests deterministes. */
    fun clockMs(): Long

    /** Prochaine echeance de frame ; null = source terminee. */
    fun nextFrame(): Frame?

    /** Signaux de cycle de vie : erreurs source, frames tardives, retour arriere. */
    fun lifecycle(): LifecycleSignal

    fun release()

    data class Frame(val buffer: ByteArray, val timestampMs: Long, val orientationDeg: Int)

    enum class LifecycleSignal { OK, ERROR_SOURCE, SIZE_CHANGED, LATE_FRAME, CLOCK_BACKWARD, ENDED }
}
