package video.vitrine.feature.catalog

import org.json.JSONObject
import video.vitrine.core.model.Sector

/**
 * Gabarit = EDL JSON 1.2.0, pas du code (6.1). Parseur + regles skincheck-lite :
 * sector_category dans l'enum, CTA WhatsApp present, durees bornees, version 1.2.0.
 */
data class EdlTemplate(
    val id: String,
    val name: String,
    val sector: Sector,
    val totalSeconds: Int,
    val sceneCount: Int,
    val hasWhatsAppCta: Boolean,
    val lut: String
)

object EdlParser {

    fun parse(raw: String): EdlTemplate {
        val root = JSONObject(raw)
        val identity = root.getJSONObject("identity")
        require(identity.optString("edl_version") == "1.2.0") { "edl_version != 1.2.0" }
        val sectorCode = root.getString("sector_category")
        val sector = Sector.entries.firstOrNull { it.code == sectorCode }
            ?: throw IllegalArgumentException("sector_category hors enum : $sectorCode")
        val timeline = root.getJSONObject("timeline")
        val scenes = timeline.getJSONArray("scenes")
        val durations = root.getJSONObject("durations")
        val total = durations.getInt("total_s")
        require(total in 10..90) { "duree totale hors bornes" }
        var cta = false
        for (i in 0 until scenes.length()) {
            val scene = scenes.getJSONObject(i)
            if (scene.has("cta") && scene.getJSONObject("cta").optString("type") == "whatsapp") cta = true
            val span = scene.getInt("end_s") - scene.getInt("start_s")
            require(span in durations.getInt("scene_min_s")..durations.getInt("scene_max_s")) {
                "scene hors bornes"
            }
        }
        return EdlTemplate(
            id = identity.getString("id"),
            name = identity.getString("name"),
            sector = sector,
            totalSeconds = total,
            sceneCount = scenes.length(),
            hasWhatsAppCta = cta,
            lut = root.getJSONObject("parameters").optString("lut", "ins_neutral@1.0.0")
        )
    }
}
