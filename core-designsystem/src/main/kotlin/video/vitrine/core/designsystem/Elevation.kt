package video.vitrine.core.designsystem

import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/**
 * D42.33 — Ombres de la refonte (spec §5).
 *
 * La spec définit des ombres multi-couches (box-shadow CSS) ; Compose
 * `Modifier.shadow` n'expose qu'une couche (spot + ambient). Traduction
 * retenue, documentée ici une fois pour toutes :
 *  - shSm : élévation 2 dp, teinte navy — carte au repos ;
 *  - shMd : élévation 8 dp, teinte navy — carte héro, élément soulevé ;
 *  - shLg : élévation 18 dp, teinte navy — feuille, action centrale ;
 *  - shOrange : élévation 10 dp, teinte orange — RÉSERVÉE au CTA (§13 :
 *    « une ombre colorée en dehors du CTA orange » = interdit).
 *
 * Règles : une seule ombre par élément ; pas d'ombre à l'intérieur d'une
 * carte ; les blocs sombres n'ont pas d'ombre mais un halo (voir
 * [decorHalo] dans les composants). Teintes spot/ambient : API 28+ ;
 * en dessous, ombre standard neutre (dégradation silencieuse acceptée).
 */
object Ombres {
    val Sm: Dp = 2.dp
    val Md: Dp = 8.dp
    val Lg: Dp = 18.dp
    val Orange: Dp = 10.dp
    /** Teinte navy des ombres (rgba(2,35,88,…) spec). */
    val TeinteNavy: Color = Color(0xFF022358)
    /** Teinte orange — CTA uniquement. */
    val TeinteOrange: Color = Color(0xFFF95C0F)
}

/** Carte au repos (shSm). */
fun Modifier.ombreSm(forme: Shape): Modifier = shadow(
    elevation = Ombres.Sm,
    shape = forme,
    ambientColor = Ombres.TeinteNavy,
    spotColor = Ombres.TeinteNavy
)

/** Carte héro, élément soulevé (shMd). */
fun Modifier.ombreMd(forme: Shape): Modifier = shadow(
    elevation = Ombres.Md,
    shape = forme,
    ambientColor = Ombres.TeinteNavy,
    spotColor = Ombres.TeinteNavy
)

/** Feuille, action centrale de tab bar (shLg). */
fun Modifier.ombreLg(forme: Shape): Modifier = shadow(
    elevation = Ombres.Lg,
    shape = forme,
    ambientColor = Ombres.TeinteNavy,
    spotColor = Ombres.TeinteNavy
)

/** Ombre orange — RÉSERVÉE au CTA primaire (§7.1/§13). */
fun Modifier.ombreOrange(forme: Shape): Modifier = shadow(
    elevation = Ombres.Orange,
    shape = forme,
    ambientColor = Ombres.TeinteOrange,
    spotColor = Ombres.TeinteOrange
)
