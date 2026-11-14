package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.unit.dp

/**
 * D42.33 — §10 état Vide : carte rayon 22, icône 28 dans une tuile
 * OrangeVoile, titre H3, une phrase, un CTA. Jamais d'illustration
 * « cartoon ». Les textes et l'action viennent de l'appelant.
 */
@Composable
fun CarteVide(
    icone: Painter,
    titre: String,
    phrase: String,
    cta: (@Composable () -> Unit)? = null,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .clip(FormeCarte)
            .background(Blanc)
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Box(
            modifier = Modifier
                .size(56.dp)
                .clip(FormeTuile)
                .background(OrangeVoile),
            contentAlignment = Alignment.Center
        ) {
            IconeVitrine(icone, taille = Dims.IconeEtat, teinte = OrangeStore)
        }
        Text(
            titre,
            style = VitrineText.H3,
            color = Navy,
            modifier = Modifier.padding(top = 12.dp)
        )
        Text(
            phrase,
            style = VitrineText.Sub,
            color = Muted,
            modifier = Modifier.padding(top = 4.dp)
        )
        cta?.let {
            Box(modifier = Modifier.padding(top = 14.dp)) { it() }
        }
    }
}
