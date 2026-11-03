package video.vitrine.core.model.billing

/**
 * Grille tarifaire FINALE validee le 23/10/2026 (contrat 9.1) : 3 forfaits stricts,
 * aucun autre plan n'existe. Mobile Money via FedaPay/CinetPay.
 */
enum class Plan(val code: String, val priceFcfa: Int, val renewDays: Int?) {
    PASS_24H("pass24h", 500, null),
    PRO("pro", 3000, 30),
    BOUTIQUE("boutique", 7500, 30);

    companion object {
        /** Credits de bienvenue spec 9.1 : attribues une fois, sans expiration. */
        const val WELCOME_CREDITS = 3
    }
}

enum class BillingProvider(val code: String) {
    FEDAPAY("fedapay"),
    CINETPAY("cinetpay")
}

/**
 * Audit D41 (F10, P1) : l'ancienne « construction d'URL sandbox cote client »
 * (sandbox-checkout.cinetpay.com) pointait vers un hote INEXISTANT — la vraie
 * API CinetPay (api-checkout.cinetpay.com/v2/payment) exige la cle SECRETE,
 * interdite cote client. Le checkout est desormais cree par le worker
 * (POST /api/v1/billing/checkout) qui renvoie le payment_url heberge a ouvrir.
 * Il reste ici que les helpers de reference (validation de la ref renvoyee).
 */
object BillingCheckout {

    fun newRef(prefix: String): String =
        prefix + "-" + java.util.UUID.randomUUID().toString().take(13)

    fun isValidRef(ref: String): Boolean =
        Regex("^[A-Z]{2,6}-[0-9a-f-]{6,36}$").matches(ref)
}
