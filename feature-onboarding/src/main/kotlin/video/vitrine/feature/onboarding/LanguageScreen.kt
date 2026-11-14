package video.vitrine.feature.onboarding

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.Bg
import video.vitrine.core.designsystem.Blanc
import video.vitrine.core.designsystem.FormeCarte
import video.vitrine.core.designsystem.FormeIcone
import video.vitrine.core.designsystem.IconeVitrine
import video.vitrine.core.designsystem.Jakarta
import video.vitrine.core.designsystem.Line
import video.vitrine.core.designsystem.Muted
import video.vitrine.core.designsystem.Navy
import video.vitrine.core.designsystem.OrangeStore
import video.vitrine.core.designsystem.OrangeVoile
import video.vitrine.core.designsystem.VitrineText
import video.vitrine.core.designsystem.VitrineTheme
import video.vitrine.core.designsystem.ombreSm

/**
 * Première ouverture : choix de la langue (famille B « choix simple », spec
 * §8) — une question en H2, cartes-options pleine largeur. FR/EN uniquement
 * (décision fondatrice D42.30). Le choix est immédiat et réversible (réglages).
 * D42.33 : les drapeaux emoji (interdits §6) deviennent des pastilles
 * typographiques « FR » / « EN » sur voile orange.
 */
@Composable
fun LanguageScreen(onPick: (String) -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Bg)
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 20.dp)
            .padding(top = 8.dp, bottom = 26.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(
            stringResource(R.string.lang_title),
            style = VitrineText.H2,
            color = Navy,
            modifier = Modifier.padding(top = 20.dp)
        )
        CarteLangue(code = "FR", nom = "Français", onPick = { onPick("fr") })
        CarteLangue(code = "EN", nom = "English", onPick = { onPick("en") })
        Text(
            stringResource(R.string.lang_change_later),
            style = VitrineText.Tiny,
            color = Muted
        )
    }
}

/** Carte-option langue (§8-B) : pastille code, nom, flèche. Choix immédiat. */
@Composable
private fun CarteLangue(code: String, nom: String, onPick: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .heightIn(min = 72.dp)
            .clip(FormeCarte)
            .background(Blanc)
            .ombreSm(FormeCarte)
            .clickable(onClick = onPick)
            .padding(14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(48.dp)
                .clip(FormeIcone)
                .background(OrangeVoile),
            contentAlignment = Alignment.Center
        ) {
            Text(
                code,
                style = VitrineText.H3.copy(fontFamily = Jakarta, fontWeight = FontWeight.W800),
                color = OrangeStore
            )
        }
        Spacer(Modifier.width(14.dp))
        Text(nom, style = VitrineText.H3, color = Navy, modifier = Modifier.weight(1f))
        IconeVitrine(
            icone = painterResource(video.vitrine.core.designsystem.R.drawable.ic_chevron_right),
            taille = 20.dp,
            teinte = Muted
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun LanguagePreview() {
    VitrineTheme { LanguageScreen { } }
}
