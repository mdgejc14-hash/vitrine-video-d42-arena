package video.vitrine.data.audio

import org.json.JSONObject

/**
 * Parseur pur de la réponse GET /api/v1/audio/catalog (Phase C).
 * Sans Context ni réseau : testable en JVM (module data).
 * Toute entrée invalide est ignorée, jamais d'exception remontée.
 */
object BgmCatalogParser {

    data class Piste(
        val categorieAudio: String,
        val gabaritId: String,
        val secteur: String,
        val format: String,
        val genre: String,
        val bpmMin: Int,
        val bpmMax: Int,
        val dureeGabaritS: Double,
        val disponible: Boolean
    )

    fun parse(json: String?): List<Piste> {
        if (json.isNullOrBlank()) return emptyList()
        return runCatching {
            val array = JSONObject(json).optJSONArray("pistes") ?: return emptyList()
            (0 until array.length()).mapNotNull { index ->
                val objet = array.optJSONObject(index) ?: return@mapNotNull null
                val categorie = objet.optString("categorie_audio")
                val gabarit = objet.optString("gabarit_id")
                if (categorie.isBlank() || gabarit.isBlank()) return@mapNotNull null
                Piste(
                    categorieAudio = categorie,
                    gabaritId = gabarit,
                    secteur = objet.optString("secteur"),
                    format = objet.optString("format"),
                    genre = objet.optString("genre"),
                    bpmMin = objet.optInt("bpm_min"),
                    bpmMax = objet.optInt("bpm_max"),
                    dureeGabaritS = objet.optDouble("duree_gabarit_s", 0.0),
                    disponible = objet.optBoolean("disponible", false)
                )
            }
        }.getOrDefault(emptyList())
    }
}
