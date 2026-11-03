package video.vitrine.core.guard

/**
 * Ancre temporelle monotone (spec V2.0 s18) : toute reculade d'horloge est
 * detectee et refusee. Pure : testable JVM, persistee par Room/_prefs cote app.
 */
object MonotonicAnchor {

    data class Result(val anchorMs: Long, val rollbackDetected: Boolean)

    /** Nouvelle ancre = max(persistee, horloge courante) ; recul = horloge < persistee. */
    fun advance(persistedMs: Long, nowElapsedMs: Long): Result =
        Result(
            anchorMs = maxOf(persistedMs, nowElapsedMs),
            rollbackDetected = nowElapsedMs < persistedMs,
        )

    /**
     * Ancre V2 (audit D40, bug B2) : l'horloge murale est la reference persistee.
     *
     * Defaut corrige : [advance] comparait elapsedRealtime() (remis a zero a
     * chaque redemarrage) a une valeur persistee -> apres CHAQUE reboot de
     * l'appareil, rollbackDetected=true et l'export etait refuse (DENY_ROLLBACK)
     * jusqu'a ce que l'uptime depasse l'ancre precedente (plusieurs jours).
     *
     * Semantique V2 :
     *  - premiere pose (persistedWallMs <= 0) : jamais de rollback ;
     *  - recul d'horloge = nowWall < persistedWall - [graceMs] (grace 120 s :
     *    derives NTP/fuseau legítimes tolerees, recul volontaire detecte) ;
     *  - avance : ancre remonte a max(persistee, courante), jamais descendue.
     */
    data class ResultV2(val anchorWallMs: Long, val rollbackDetected: Boolean)

    const val ROLLBACK_GRACE_MS = 120_000L

    fun advanceV2(persistedWallMs: Long, nowWallMs: Long, graceMs: Long = ROLLBACK_GRACE_MS): ResultV2 =
        ResultV2(
            anchorWallMs = maxOf(persistedWallMs, nowWallMs),
            rollbackDetected = persistedWallMs > 0L && nowWallMs < persistedWallMs - graceMs,
        )
}
