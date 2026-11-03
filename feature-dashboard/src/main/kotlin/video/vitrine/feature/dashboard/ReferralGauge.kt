package video.vitrine.feature.dashboard



/**
 * E11 Parrainage — logique pure de la jauge R8 (testee JVM).
 * Audit D41 (F2/F33) : entrees = HISTORIQUE SERVEUR (statuts anonymises, pas de
 * noms inventes cote client) ; les libelles (FR en dur avant) sont desormais des
 * ressources composees a l'ecran ; les VALEURS viennent de GET /me/referral
 * (autorite serveur) avec repli sur le miroir Room hors-ligne.
 */
data class ReferralEntry(val status: String, val converted: Boolean)

data class ReferralGaugeUi(
    val code: String,
    val converted: Int,
    val target: Int,
    val rewards: Int,
    /** Progression 0f..1f vers le prochain palier (cycle de 5). */
    val progress: Float,
    /** Position dans le palier courant (ex. 7 -> 2/5). */
    val within: Int,
    val entries: List<ReferralEntry>
)

object ReferralGauge {

    /** Palier contractuel : 5 filleuls convertis = 1 mois Pro offert. */
    const val TARGET = 5

    /**
     * @param converted total cumule de filleuls convertis (source serveur).
     * @param rewards mois Pro deja offerts (source serveur).
     */
    fun ui(
        code: String,
        converted: Int,
        rewards: Int,
        entries: List<ReferralEntry> = emptyList(),
        target: Int = TARGET
    ): ReferralGaugeUi {
        val within = if (converted <= 0) 0 else ((converted - 1) % target) + 1
        val progress = within.toFloat() / target.toFloat()
        return ReferralGaugeUi(
            code = code,
            converted = converted,
            target = target,
            rewards = rewards,
            progress = progress,
            within = within,
            entries = entries
        )
    }
}
