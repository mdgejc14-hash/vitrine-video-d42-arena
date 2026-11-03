package video.vitrine.feature.dashboard

import video.vitrine.core.model.billing.Plan
import java.util.Locale

/**
 * E9 Paywall — grille tarifaire finale D34.1 (500 / 3 000 / 7 500 FCFA,
 * parite BCEAO fixe 1 EUR = 655,957 FCFA). Logique pure (testee JVM).
 *
 * Audit D41 (F8/F33/F38) : les libelles etaient des chaines FRANCAISES en dur
 * dans le mapper (langue figee quels que soient les parametres regionaux).
 * Le mapper renvoie desormais des id de ressources (traduits FR/EN/ES/JA) ;
 * la DEVISE reste decouplee de la langue : elle depend de la ZONE (FCFA/€),
 * pas de la locale d'affichage — regle d'or « monnaies ≠ langues ».
 */
enum class PaywallZone { UEMOA, AFRIQUE_HORS_UEMOA, MONDE }

data class PlanCard(
    val plan: Plan,
    val titleRes: Int,
    /** Montant formate dans la devise de ZONE (invariant de langue). */
    val priceValue: String,
    /** Libelle de periode (R.string.period_30d) pour les formules mensuelles. */
    val periodRes: Int?,
    val featureRes: List<Int>
)

data class PaywallUi(
    val locked: Boolean,
    val bannerCreditsLeft: Int?,
    val cards: List<PlanCard>,
    /** Zone hors UEMOA : equivalence indicative BCEAO affichee. */
    val footnoteBceao: Boolean
)

object PaywallMapper {

    private val TITLES = mapOf(
        Plan.PASS_24H to R.string.plan_pass24h_title,
        Plan.PRO to R.string.plan_pro_title,
        Plan.BOUTIQUE to R.string.plan_boutique_title
    )

    private val FEATURES = mapOf(
        Plan.PASS_24H to listOf(
            R.string.feat_pass24h_1, R.string.feat_pass24h_2, R.string.feat_pass24h_3
        ),
        Plan.PRO to listOf(
            R.string.feat_pro_1, R.string.feat_pro_2, R.string.feat_pro_3, R.string.feat_pro_4
        ),
        Plan.BOUTIQUE to listOf(
            R.string.feat_boutique_1, R.string.feat_boutique_2,
            R.string.feat_boutique_3, R.string.feat_boutique_4
        )
    )

    /**
     * Groupement par milliers — espace SIMPLE (U+0020), conforme aux libelles
     * EXACTS de la maquette E9A (tests golden P8LogicTest/PaywallUiCheckTest).
     * D41 : la reecriture F8 avait introduit U+202F — ecart non demande par
     * aucun finding, corrige a la racine (fidelite maquette = regle d'or).
     */
    fun groupThousands(value: Int): String {
        val s = value.toString()
        val sb = StringBuilder()
        var count = 0
        for (i in s.indices.reversed()) {
            if (count > 0 && count % 3 == 0) sb.append(' ')
            sb.append(s[i])
            count++
        }
        return sb.reverse().toString()
    }

    /** Parite BCEAO fixe : 1 EUR = 655,957 FCFA (separateur decimal FR). */
    fun eurLabel(amountFcfa: Int): String {
        val euros = amountFcfa / 655.957
        val rounded = String.format(Locale.FRANCE, "%.2f", euros)
        return "$rounded €"
    }

    /**
     * @param welcomeCreditsLeft credits restants (source Room, autorite serveur).
     * @param exportsLimit limite cumulative export (0 = non initialise cote serveur).
     * @param zone zone tarifaire (devise) — INDEPENDANTE de la langue d'affichage.
     */
    fun ui(
        welcomeCreditsLeft: Int,
        exportsLimit: Int = 0,
        zone: PaywallZone = PaywallZone.UEMOA
    ): PaywallUi {
        val locked = welcomeCreditsLeft <= 0 && exportsLimit <= 0
        val cards = Plan.entries.map { plan ->
            val price = plan.priceFcfa
            val isUemoa = zone == PaywallZone.UEMOA
            val priceValue = if (isUemoa) {
                "${groupThousands(price)} FCFA"
            } else {
                "≈ ${eurLabel(price)}"
            }
            PlanCard(
                plan = plan,
                titleRes = TITLES.getValue(plan),
                priceValue = priceValue,
                periodRes = if (plan.renewDays != null) R.string.period_30d else null,
                featureRes = FEATURES.getValue(plan)
            )
        }
        return PaywallUi(
            locked = locked,
            bannerCreditsLeft = if (locked) null else welcomeCreditsLeft,
            cards = cards,
            footnoteBceao = zone != PaywallZone.UEMOA
        )
    }
}
