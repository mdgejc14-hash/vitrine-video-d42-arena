package video.vitrine.data.i18n

import android.content.Context
import org.json.JSONObject
import video.vitrine.core.model.GabaritSummary

/**
 * D42.32 (Lot 4) — traductions EN des chaînes marchandes AFFICHÉES dans
 * l'interface (catalogue, brief, guide caméra, récapitulatif export).
 *
 * SSOT : les JSON canoniques des 30 gabarits restent FR et ne sont JAMAIS
 * modifiés (même contrat que GabaritL10n pour les textes incrustés vidéo).
 * Cet overlay est clé par IDENTIFIANTS TECHNIQUES STABLES (id gabarit, id
 * champ, id prise, index de segment) : aucune retape, aucune dérive.
 *
 * Chargement : assets/i18n/gabarits_ui_l10n_v1.json, une fois, hors-ligne.
 * FR (défaut) ou asset absent -> null -> comportement inchangé (repli FR,
 * jamais de chaîne vide).
 */
object GabaritUiL10n {

    private const val ASSET = "i18n/gabarits_ui_l10n_v1.json"

    @Volatile
    private var overlay: JSONObject? = null

    private var charge = false

    /** Entrée EN du gabarit, ou null (langue FR, gabarit inconnu, asset absent). */
    fun traductions(context: Context, lang: String?, gabaritId: String): JSONObject? {
        if (lang != "en") return null
        if (!charge) {
            synchronized(this) {
                if (!charge) {
                    overlay = runCatching {
                        context.assets.open(ASSET).use {
                            JSONObject(it.readBytes().decodeToString())
                        }
                    }.getOrNull()
                    charge = true
                }
            }
        }
        return overlay?.optJSONObject(gabaritId)
    }

    /** Résumé du catalogue traduit — repli FR champ par champ (copie honnête). */
    fun traduireSummary(summary: GabaritSummary, t: JSONObject?): GabaritSummary =
        if (t == null) {
            summary
        } else {
            summary.copy(
                nomFormatAffiche = t.optStr("nom_format") ?: summary.nomFormatAffiche,
                phraseCourte = t.optStr("phrase_courte") ?: summary.phraseCourte,
                secteurLibelle = t.optStr("secteur_libelle") ?: summary.secteurLibelle,
            )
        }

    /** OptString non vide, sinon null (repli documenté). */
    internal fun JSONObject.optStr(key: String): String? =
        optString(key).takeIf { it.isNotBlank() }
}
