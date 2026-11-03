package video.vitrine.data.i18n

import org.json.JSONObject

/**
 * D42 — INTERNATIONALISATION DES CONTENUS COMMERCIAUX.
 *
 * Les textes des 30 gabarits sont, dans les JSON canoniques, ecrits en francais.
 * Ces JSON ne sont JAMAIS modifies : ce fichier fournit une couche de
 * traduction a la frontiere de la composition.
 *
 *   JSON canonique (FR, source de verite)
 *        -> GabaritL10n.resolve(texte, langue)   <- ici
 *        -> substitution des variables {…}
 *        -> beat sheet -> KineticTypography -> MP4
 *
 * Contrat :
 *  - la cle est le TEXTE CANONIQUE EXACT (accents et apostrophes typographiques
 *    compris) : aucune retape, donc aucune derive silencieuse ;
 *  - les variables `{prix}`, `{nom_commerce}`, … sont substituees APRES la
 *    traduction, et doivent etre identiques dans toutes les langues (verifie par
 *    `variablesIntactes`) ;
 *  - langue inconnue ou texte absent -> repli sur le francais, jamais une chaine
 *    vide (une video sans texte serait pire qu'une video en francais) ;
 *  - la devise est INDEPENDANTE de la langue : `{devise}` vient du brief.
 */
object GabaritL10n {

    const val LANGUE_SOURCE = "fr"
    val LANGUES = listOf("fr", "en", "es", "ja")

    /** Donnees chargees depuis assets/i18n/gabarit_l10n_v1.json. */
    class Donnees(
        val textes: Map<String, Map<String, String>>,
        val badges: Map<String, Map<String, String>>
    ) {

        /** Texte localise ; repli FR si la langue n'a pas la cle. */
        fun resolve(texteCanonique: String, langue: String): String {
            if (langue == LANGUE_SOURCE) return texteCanonique
            val traductions = textes[texteCanonique] ?: return texteCanonique
            val valeur = traductions[langue]
            return if (valeur.isNullOrBlank()) texteCanonique else valeur
        }

        /** Message de badge E5 localise, ou null si le code n'est pas un choix valide. */
        fun badge(code: String?, langue: String): String? {
            if (code.isNullOrBlank()) return null
            val entrees = badges[code] ?: return null
            val valeur = entrees[langue] ?: entrees[LANGUE_SOURCE]
            return valeur?.takeIf { it.isNotBlank() }
        }

        /** Cles manquantes pour une langue (rapport de couverture, jamais bloquant). */
        fun manquantes(langue: String): List<String> =
            textes.filterValues { it[langue].isNullOrBlank() }.keys.sorted()

        /** Badges declarees mais sans traduction pour une langue. */
        fun badgesManquants(langue: String): List<String> =
            badges.filterValues { it[langue].isNullOrBlank() }.keys.sorted()
    }

    /** Analyse le JSON de dictionnaire. Tolerant : un fichier illisible donne un vide. */
    fun parse(raw: String): Donnees = runCatching {
        val root = JSONObject(raw)
        Donnees(
            textes = lireTable(root.optJSONObject("textes")),
            badges = lireTable(root.optJSONObject("badges"))
        )
    }.getOrDefault(Donnees(emptyMap(), emptyMap()))

    private fun lireTable(table: JSONObject?): Map<String, Map<String, String>> {
        if (table == null) return emptyMap()
        val sortie = LinkedHashMap<String, Map<String, String>>()
        val cles = table.keys()
        while (cles.hasNext()) {
            val cle = cles.next()
            val entree = table.optJSONObject(cle) ?: continue
            val langues = LinkedHashMap<String, String>()
            LANGUES.forEach { langue ->
                val valeur = entree.optString(langue, "")
                if (valeur.isNotBlank()) langues[langue] = valeur
            }
            if (langues.isNotEmpty()) sortie[cle] = langues
        }
        return sortie
    }

    /**
     * Verification de contrat : pour chaque texte, les variables `{…}` doivent
     * etre identiques entre la source et la traduction. Retourne les violations
     * (« texte :: langue :: attendu/obtenu »).
     */
    fun variablesIntactes(donnees: Donnees): List<String> {
        val violations = mutableListOf<String>()
        donnees.textes.forEach { (source, traductions) ->
            val attendues = variablesDe(source)
            traductions.forEach { (langue, valeur) ->
                if (variablesDe(valeur) != attendues) {
                    violations += "$source :: $langue :: $attendues -> ${variablesDe(valeur)}"
                }
            }
        }
        return violations.sorted()
    }

    private val VARIABLE = Regex("\\{[a-z_]+\\}")

    fun variablesDe(texte: String): List<String> = VARIABLE.findAll(texte).map { it.value }.sorted().toList()
}
