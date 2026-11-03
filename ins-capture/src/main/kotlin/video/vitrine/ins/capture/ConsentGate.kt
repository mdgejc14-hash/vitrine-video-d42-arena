package video.vitrine.ins.capture

/**
 * Porte R4 (contrat 9.4) : detection ML Kit 100 % on-device. Toute detection de
 * visage/mineur sans consentement enregistre BLOQUE la capture (modale).
 * Logique pure, testee JVM ; le comptage vient de MlKitFaceCounter (appareil).
 */
object ConsentGate {

    enum class Decision { ALLOW, BLOCK_MODAL_CONSENT, BLOCK_MODAL_MINOR }

    fun decide(faceCount: Int, adultConsentRecorded: Boolean, minorConsentRecorded: Boolean, minorSuspected: Boolean): Decision =
        when {
            faceCount <= 0 -> Decision.ALLOW
            minorSuspected && !minorConsentRecorded -> Decision.BLOCK_MODAL_MINOR
            !adultConsentRecorded -> Decision.BLOCK_MODAL_CONSENT
            else -> Decision.ALLOW
        }

    /** Lissage temporel du masque/comptage : EMA alpha=0,3 (R&D ADVANCED effet 3). */
    fun smoothed(previous: Float, current: Int, alpha: Float = 0.3f): Float =
        previous + alpha * (current - previous)
}
