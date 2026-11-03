package video.vitrine.core.designsystem

import androidx.annotation.StringRes
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import video.vitrine.core.model.Sector

/**
 * Ressource du libelle commercial du secteur.
 * D41 (F6) : variante NON composable — les dialogs AlertDialog du dashboard
 * (choix du secteur) tournent hors contexte de composition et ont besoin de
 * `Context.getString(sectorLabelRes(s))` ; la duplication du mapping est
 * exclue (une seule source de verite).
 */
@StringRes
fun sectorLabelRes(sector: Sector): Int =
    when (sector) {
        Sector.MODE -> R.string.sector_mode
        Sector.COIFFURE -> R.string.sector_coiffure
        Sector.RESTAURATION -> R.string.sector_restauration
        Sector.BTP -> R.string.sector_btp
        Sector.IMMO_AUTO -> R.string.sector_immo_auto
        Sector.COMMERCE -> R.string.sector_commerce
        Sector.TOUS -> R.string.sector_all
    }

/** Libelle commercial du secteur : jamais de code technique visible. */
@Composable
fun sectorLabel(sector: Sector): String = stringResource(sectorLabelRes(sector))
