package video.vitrine.core.designsystem

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable

/**
 * D42.33 — Refonte du thème : deux fonds seulement (spec §2) :
 *  - parcours applicatif clair : background = Bg #F7F8FC, cartes = Blanc ;
 *  - écrans d'émotion et caméra : navy + halos (portés par les écrans).
 *
 * Correction D42.33 des inversions D42.31 : background était BlancPur et
 * surface GrisDoux — désormais background = Bg, surface = Blanc.
 */
private val LightScheme = lightColorScheme(
    primary = OrangeStore,
    onPrimary = Blanc,
    primaryContainer = OrangeVoile,
    onPrimaryContainer = OrangeDeep,
    secondary = Navy,
    onSecondary = Blanc,
    secondaryContainer = BleuVoile,
    onSecondaryContainer = Navy,
    tertiary = VertSucces,
    onTertiary = Blanc,
    tertiaryContainer = VertVoile,
    onTertiaryContainer = VertTexte,
    background = Bg,
    onBackground = Navy,
    surface = Blanc,
    onSurface = Navy,
    surfaceVariant = Line,
    onSurfaceVariant = NavySoft,
    outline = Line,
    outlineVariant = Line,
    error = RougeBloquant,
    onError = Blanc,
    errorContainer = OrangeVoile,
    onErrorContainer = AmbreAlerte
)

/** Fond des écrans d'émotion et caméra (navy, halos portés par les écrans). */
private val DarkScheme = darkColorScheme(
    primary = OrangeStore,
    onPrimary = Blanc,
    primaryContainer = OrangeStore,
    onPrimaryContainer = Blanc,
    secondary = NavySoft,
    onSecondary = Blanc,
    background = Navy,
    onBackground = Blanc,
    surface = Navy,
    onSurface = Blanc,
    surfaceVariant = NavySoft,
    onSurfaceVariant = Blanc80,
    error = RougeBloquant,
    onError = Blanc
)

/** Thème officiel : clair pour le parcours applicatif (vitrine lumineuse). */
@Composable
fun VitrineTheme(darkTheme: Boolean = false, content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = if (darkTheme) DarkScheme else LightScheme,
        typography = VitrineTypography,
        shapes = FormesVitrine,
        content = content
    )
}
