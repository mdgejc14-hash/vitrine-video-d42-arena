package video.vitrine.feature.brief

import com.google.i18n.phonenumbers.PhoneNumberUtil

/**
 * D42.30 — validation internationale des numéros WhatsApp (retour terrain RC14 :
 * exemple béninois 8 chiffres obsolète + validation naïve « + puis 8 chiffres »).
 *
 * Règles RÉELLES par pays via Google libphonenumber 8.13.50 (la version qui
 * intègre la migration béninoise du 30/11/2024 : 10 chiffres nationaux,
 * préfixe 01, indicatif +229). Pur JVM → testé unitairement sans Android.
 *
 * Politique de valeur : le champ du brief porte TOUJOURS la forme E.164
 * (+2290197000000) quand le numéro est complet et valide ; tant qu'il ne
 * l'est pas, le texte brut saisi est conservé (la validation bloque Continuer,
 * aucun numéro invalide n'atteint le montage ou la carte de fin).
 * Un numéro syntaxiquement valide n'est PAS une preuve que le compte WhatsApp
 * existe (mission D42.30 §6) — c'est une vérification de format uniquement.
 */
object TelephoneValidator {

    private val util: PhoneNumberUtil by lazy { PhoneNumberUtil.getInstance() }

    /** Le pays du marché initial, PROPOSÉ par défaut — jamais imposé. */
    const val PAYS_DEFAUT = "BJ"

    /** Vrai ssi la valeur (forme E.164 avec « + ») est un numéro valide
     *  selon les règles du pays qu'elle désigne. */
    fun estValide(valeurE164: String): Boolean = runCatching {
        util.isValidNumber(util.parse(valeurE164, null))
    }.getOrDefault(false)

    /** Normalise une saisie (nationale ou internationale) pour un pays choisi.
     *  Retourne l'E.164 si valide pour CE pays, sinon null. */
    fun versE164(saisie: String, region: String): String? = runCatching {
        val num = util.parse(saisie, region)
        if (util.isValidNumberForRegion(num, region)) util.format(num, PhoneNumberUtil.PhoneNumberFormat.E164) else null
    }.getOrNull()

    /**
     * Détecte le pays d'un numéro COLLÉ au format international complet
     * (« +229 01 97 00 00 00 », « +33 6… ») et le renvoie avec sa forme
     * nationale formatée — sinon null (la saisie continue au clavier).
     */
    fun depuisInternational(saisie: String): Pair<String, String>? = runCatching {
        if (!saisie.trim().startsWith("+")) return null
        val num = util.parse(saisie, null)
        val region = util.getRegionCodeForCountryCode(num.countryCode)
        if (region.isNullOrEmpty() || region == "ZZ") return null
        if (!util.isValidNumber(num)) return null
        region to util.format(num, PhoneNumberUtil.PhoneNumberFormat.NATIONAL)
    }.getOrNull()

    /** Indicatif du pays (ex. « +229 »). */
    fun indicatif(region: String): String = "+" + util.getCountryCodeForRegion(region)

    /** Nom affichable du pays dans la langue du téléphone. */
    fun nomPays(region: String, langue: String): String =
        java.util.Locale(langue, region).displayCountry.ifBlank { region }

    /** Drapeau emoji du pays (indicateurs régionaux Unicode). */
    fun drapeau(region: String): String = region.uppercase().map { c ->
        Character.toChars(0x1F1E6 + (c.code - 'A'.code)).concatToString()
    }.joinToString("")

    /** Tous les pays supportés, triés par nom (le Bénin en tête : marché
     *  initial). L'ordre reste stable entre recompositions. */
    fun paysTriés(langue: String): List<String> {
        val regions = util.supportedRegions.toMutableList()
        regions.remove(PAYS_DEFAUT)
        return listOf(PAYS_DEFAUT) + regions.sortedBy { nomPays(it, langue).lowercase() }
    }

    /** Numéro E.164 → forme nationale lisible (pour ré-affichage). */
    fun formeNationale(valeurE164: String): String? = runCatching {
        util.format(util.parse(valeurE164, null), PhoneNumberUtil.PhoneNumberFormat.NATIONAL)
    }.getOrNull()

    /** Exemple de numéro VALIDE pour un pays (aide contextuelle honnête —
     *  plus jamais d'exemple codé en dur obsolète). */
    fun exemplePays(region: String): String? = runCatching {
        util.format(
            util.getExampleNumberForType(region, PhoneNumberUtil.PhoneNumberType.MOBILE),
            PhoneNumberUtil.PhoneNumberFormat.INTERNATIONAL
        )
    }.getOrNull()
}
