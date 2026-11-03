package video.vitrine.core.guard

/**
 * Porte d'export (spec V2.0 : aucune generation de MP4 a 0 credit) :
 * decision pure, testable JVM, appelee AVANT tout enqueue WorkManager.
 */
object ExportGate {

    enum class Decision { ALLOW, DENY_NO_CREDIT, DENY_ROLLBACK, DENY_INTEGRITY }

    fun decide(credits: Int, rollbackDetected: Boolean, integrityOk: Boolean): Decision = when {
        !integrityOk -> Decision.DENY_INTEGRITY
        rollbackDetected -> Decision.DENY_ROLLBACK
        credits <= 0 -> Decision.DENY_NO_CREDIT
        else -> Decision.ALLOW
    }
}
