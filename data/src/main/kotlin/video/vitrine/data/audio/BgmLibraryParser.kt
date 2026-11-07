package video.vitrine.data.audio

import org.json.JSONObject

/**
 * Parseur pur de la réponse GET /api/v1/audio/library?secteur=&format= (D42.21).
 *
 * Le Worker sert les 20 variations du gabarit demandé (filtre secteur+format) :
 * piste_id, variation, sha256, taille, durée, statut. Sans Context ni réseau :
 * testable en JVM (module data). Toute entrée invalide est ignorée, jamais
 * d'exception remontée — un échec de liste ne doit jamais casser un export
 * (repli : chemin titulaire historique).
 */
object BgmLibraryParser {

    /** Une variation du gabarit, telle que servie par bgm_library (D1). */
    data class Variation(
        val pisteId: String,
        val categorieAudio: String,
        val gabaritId: String,
        val variation: Int,
        val sha256: String,
        val tailleOctets: Long,
        val dureeS: Double,
        val statut: String
    )

    fun parse(json: String?): List<Variation> {
        if (json.isNullOrBlank()) return emptyList()
        return runCatching {
            val array = JSONObject(json).optJSONArray("pistes") ?: return emptyList()
            (0 until array.length()).mapNotNull { index ->
                val objet = array.optJSONObject(index) ?: return@mapNotNull null
                val pisteId = objet.optString("piste_id")
                val categorie = objet.optString("categorie_audio")
                val gabarit = objet.optString("gabarit_id")
                val sha = objet.optString("sha256")
                if (pisteId.isBlank() || categorie.isBlank() || gabarit.isBlank() || sha.isBlank()) {
                    return@mapNotNull null
                }
                Variation(
                    pisteId = pisteId,
                    categorieAudio = categorie,
                    gabaritId = gabarit,
                    variation = objet.optInt("variation", 0),
                    sha256 = sha,
                    tailleOctets = objet.optLong("taille_octets", 0L),
                    dureeS = objet.optDouble("duree_s", 0.0),
                    statut = objet.optString("statut", "")
                )
            }
        }.getOrDefault(emptyList())
    }
}
