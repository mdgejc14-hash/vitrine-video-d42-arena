package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp

/**
 * D42.33 — §7.10 Feuille (bottom sheet) : coins hauts 30, poignée 40 × 4
 * Line centrée à 10 dp du bord, padding 20, shLg. Titre H3 + sous-titre Sub.
 * Actions empilées, CTA primaire en dernier (l'appelant fournit les actions
 * et le CTA — le composant ne décide rien).
 */
@Composable
fun FeuilleVitrine(
    titre: String,
    sousTitre: String?,
    modifier: Modifier = Modifier,
    contenu: @Composable () -> Unit
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .clip(FormeFeuille)
            .background(Blanc)
            .ombreLg(FormeFeuille)
            .padding(bottom = 20.dp)
    ) {
        Box(
            modifier = Modifier
                .padding(top = 10.dp)
                .height(4.dp)
                .width(40.dp)
                .clip(FormePill)
                .background(Line)
                .align(Alignment.CenterHorizontally)
        )
        Text(
            titre,
            style = VitrineText.H3,
            color = Navy,
            modifier = Modifier.padding(start = 20.dp, top = 16.dp, end = 20.dp)
        )
        if (sousTitre != null) {
            Text(
                sousTitre,
                style = VitrineText.Sub,
                color = Muted,
                modifier = Modifier.padding(start = 20.dp, top = 4.dp, end = 20.dp)
            )
        }
        Box(modifier = Modifier.padding(horizontal = 20.dp, vertical = 16.dp)) { contenu() }
    }
}
