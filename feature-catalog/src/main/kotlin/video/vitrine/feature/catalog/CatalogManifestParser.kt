package video.vitrine.feature.catalog

import org.json.JSONObject
import video.vitrine.core.model.CatalogManifest
import video.vitrine.core.model.Sector
import video.vitrine.core.model.Skin

/** Parseur du manifeste catalogue (JSON 3.7 tel quel). Pur, teste Robolectric. */
object CatalogManifestParser {

    fun parse(raw: String, canary: Boolean = false): CatalogManifest {
        val root = JSONObject(raw)
        val version = root.getString("version")
        val minApp = root.optString("min_app_version", "0.0.0")
        val array = root.getJSONArray("skins")
        val skins = (0 until array.length()).map { i ->
            val item = array.getJSONObject(i)
            Skin(
                id = item.getString("id"),
                name = item.getString("name"),
                sector = sectorOf(item.optString("sector", "tous")),
                thumbnailUrl = item.getString("thumb"),
                manifestVersion = version,
                isCanary = canary
            )
        }
        return CatalogManifest(version, minApp, skins)
    }

    private fun sectorOf(code: String): Sector =
        Sector.entries.firstOrNull { it.code == code } ?: Sector.COMMERCE
}
