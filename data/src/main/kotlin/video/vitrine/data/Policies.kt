package video.vitrine.data

/**
 * Regles metier pures (JVM-testables) : R1 paywall a epuisement, grace hors-ligne,
 * R8 jauge n/5. Aucune dependance Android.
 */
object PaywallPolicy {

    /** Paywall quand la limite d'exports du plan est epuisee ET le quota bienvenue aussi (9.1). */
    fun isExportLocked(exportsLimit: Int, welcomeCreditsLeft: Int): Boolean =
        exportsLimit <= 0 && welcomeCreditsLeft <= 0

    /**
     * Grace hors-ligne : le cache de droits reste valable cacheDays jours (3/14/30).
     * Jamais de blocage reseau (R1/R3) : cache expire = droits par defaut gratuits, pas paywall.
     */
    fun isCacheFresh(fetchedAt: Long, cacheDays: Int, now: Long): Boolean =
        now - fetchedAt < cacheDays.toLong() * MILLIS_PER_DAY

    /** Avertissement fair-use Pro a partir du seuil (90 par defaut). */
    fun isFairUseWarning(usage: Int, fairUseThreshold: Int?): Boolean =
        fairUseThreshold != null && usage >= fairUseThreshold

    private const val MILLIS_PER_DAY = 24L * 60 * 60 * 1000
}

object ReferralPolicy {
    /** Jauge R8 : 5 filleuls = 1 mois Pro offert (9.8). */
    const val TARGET = 5

    fun isRewardDue(referredConverted: Int): Boolean = referredConverted >= TARGET
}
