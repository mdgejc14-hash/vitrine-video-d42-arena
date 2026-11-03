package video.vitrine.core.model

/** Secteur onboarding V7-FINAL (3.6) : 6 secteurs + generaliste. */
enum class Sector(val code: String) {
    MODE("mode"),
    COIFFURE("coiffure"),
    RESTAURATION("restauration"),
    BTP("btp"),
    IMMO_AUTO("immo_auto"),
    COMMERCE("commerce"),
    TOUS("tous") ;

    companion object {
        /** Decodage tolerant d'un code secteur recu par intent : null si absent ou inconnu. */
        fun fromCodeOrNull(code: String?): Sector? = entries.firstOrNull { it.code == code }
    }
}

/** Un gabarit/skin du catalogue B2 (180 immediats, 3.5). Injection sans recompiler. */
data class Skin(
    val id: String,
    val name: String,
    val sector: Sector,
    val thumbnailUrl: String,
    val manifestVersion: String,
    val isCanary: Boolean = false
)

/** Manifeste catalogue complet telecharge depuis /api/v1/templates/[canary/]manifest.json. */
data class CatalogManifest(
    val version: String,
    val minAppVersion: String,
    val skins: List<Skin>
) {
    fun bySector(sector: Sector): List<Skin> =
        if (sector == Sector.TOUS) skins else skins.filter { it.sector == sector }
}
