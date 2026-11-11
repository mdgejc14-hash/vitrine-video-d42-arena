package video.vitrine.feature.onboarding

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.VitrineLogoHeader
import video.vitrine.core.designsystem.VitrineTheme

/** Premiere ouverture : choix de la langue, persistee en preferences locales. */
@Composable
fun LanguageScreen(onPick: (String) -> Unit) {
    // D42.13 : en PAYSAGE (2340x1080), la colonne depassait l'ecran et les deux
    // dernieres langues (Español, 日本語) devenaient inatteignables — constate
    // sur emulateur, run 42182985228. Le contenu defile desormais.
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(24.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        VitrineLogoHeader()
        Text(stringResource(R.string.lang_title), style = MaterialTheme.typography.headlineSmall)
        // D42.30 : FR/EN uniquement (décision fondatrice D42.30).
        LanguageCard("🇫🇷", "Français") { onPick("fr") }
        LanguageCard("🇬🇧", "English") { onPick("en") }
        Text(
            stringResource(R.string.lang_change_later),
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
private fun LanguageCard(flag: String, nativeName: String, onPick: () -> Unit) {
    Card(onClick = onPick, modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(18.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            Text(flag, style = MaterialTheme.typography.headlineMedium)
            Text(nativeName, style = MaterialTheme.typography.titleMedium)
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun LanguagePreview() {
    VitrineTheme { LanguageScreen { } }
}
