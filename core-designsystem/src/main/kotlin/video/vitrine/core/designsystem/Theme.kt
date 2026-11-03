package video.vitrine.core.designsystem

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable

private val LightScheme = lightColorScheme(
    primary = OrangeStore,
    onPrimary = BlancPur,
    primaryContainer = OrangeStoreDeep,
    onPrimaryContainer = BlancPur,
    secondary = BleuNuit,
    onSecondary = BlancPur,
    secondaryContainer = BleuNuitSoft,
    onSecondaryContainer = BlancPur,
    background = BlancPur,
    onBackground = BleuNuit,
    surface = GrisDoux,
    onSurface = BleuNuit,
    surfaceVariant = GrisLiserai,
    onSurfaceVariant = BleuNuitSoft
)

private val DarkScheme = darkColorScheme(
    primary = OrangeStore,
    onPrimary = BlancPur,
    secondary = OrangeStoreDeep,
    onSecondary = BlancPur,
    background = BleuNuit,
    onBackground = BlancPur,
    surface = BleuNuitSoft,
    onSurface = BlancPur
)

/** Theme officiel : clair par defond (vitrine lumineuse), sombre disponible. */
@Composable
fun VitrineTheme(darkTheme: Boolean = false, content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = if (darkTheme) DarkScheme else LightScheme,
        typography = VitrineTypography,
        content = content
    )
}
