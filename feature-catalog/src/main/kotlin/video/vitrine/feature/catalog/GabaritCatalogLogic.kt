package video.vitrine.feature.catalog

import video.vitrine.core.model.GabaritSummary
import video.vitrine.core.model.Sector
import video.vitrine.core.model.sectorFromGabaritCode

/**
 * Logique pure du catalogue E4 V2.0 : les 30 gabarits universels (D24)
 * remplacent les 180 skins lorsque la source locale est disponible ;
 * le filtrage secteur reprend l'enum Sector existant (zero breaking).
 */
object GabaritCatalog {

    fun visible(gabarits: List<GabaritSummary>, sector: Sector): List<GabaritSummary> =
        if (sector == Sector.TOUS) {
            gabarits
        } else {
            gabarits.filter { sectorFromGabaritCode(it.secteur) == sector }
        }
}
