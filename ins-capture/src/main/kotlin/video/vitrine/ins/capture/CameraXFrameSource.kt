package video.vitrine.ins.capture

import android.os.SystemClock

/**
 * Source de production : delegue au binder CameraX existant (Preview +
 * VideoCapture<Recorder> inchanges). Cette classe n'interpose rien entre
 * CameraX et l'encodeur : elle expose seulement l'horloge et l'etat du flux
 * pour l'oracle QA. Le Recorder CameraX reste LE chemin d'enregistrement reel.
 */
class CameraXFrameSource(
    private val binder: InsCameraBinder,
    private val useCases: InsCameraBinder.InsUseCases,
) : VideoFrameSource {

    override val width: Int = 1280
    override val height: Int = 720

    override fun clockMs(): Long = SystemClock.elapsedRealtime()

    /** Pas de trame applicative : l'encodeur est pilote par CameraX lui-meme. */
    override fun nextFrame(): VideoFrameSource.Frame? = null

    override fun lifecycle(): VideoFrameSource.LifecycleSignal =
        VideoFrameSource.LifecycleSignal.OK

    override fun release() = Unit

    fun binderRef(): InsCameraBinder = binder
    fun useCasesRef(): InsCameraBinder.InsUseCases = useCases
}
