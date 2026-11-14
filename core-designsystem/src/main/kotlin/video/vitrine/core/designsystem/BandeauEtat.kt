package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp

/** Niveaux du bandeau d'état (§7.14 + §10). */
enum class NiveauBandeau { HorsLigne, Info, Succes, ErreurDouce }

/**
 * D42.33 — §7.14 Bandeau d'état : UNE seule forme réutilisée partout.
 * Carte rayon 18, fond OrangeVoile, filet 1 dp rgba(178,106,0,.20), icône
 * 20 AmbreAlerte, titre 14/700, texte 12.5, action texte (« Réessayer » —
 * fournie par l'appelant). Placé SOUS le header, jamais en toast éphémère.
 * Hors-ligne = ambre, JAMAIS rouge (§13).
 */
@Composable
fun BandeauEtat(
    titre: String,
    texte: String?,
    icone: Int,
    action: String?,
    surAction: (() -> Unit)?,
    modifier: Modifier = Modifier,
    niveau: NiveauBandeau = NiveauBandeau.HorsLigne
) {
    val (fond, filet, encre) = when (niveau) {
        NiveauBandeau.HorsLigne -> Triple(OrangeVoile, AmbreAlerte.copy(alpha = 0.20f), AmbreAlerte)
        NiveauBandeau.Info -> Triple(BleuVoile, InfoEncre.copy(alpha = 0.20f), InfoEncre)
        NiveauBandeau.Succes -> Triple(VertVoile, VertSucces.copy(alpha = 0.20f), VertTexte)
        NiveauBandeau.ErreurDouce -> Triple(OrangeVoile, AmbreAlerte.copy(alpha = 0.20f), AmbreAlerte)
    }
    Row(
        modifier = modifier
            .fillMaxWidth()
            .clip(FormeTuile)
            .background(fond)
            .border(1.dp, filet, FormeTuile)
            .padding(horizontal = 14.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        IconeVitrine(
            icone = painterResource(icone),
            taille = 20.dp,
            teinte = encre
        )
        Spacer(Modifier.width(10.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(titre, style = VitrineText.Sub.copy(fontWeight = FontWeight.W700), color = encre)
            if (texte != null) {
                Text(
                    texte,
                    style = VitrineText.Tiny,
                    color = encre,
                    modifier = Modifier.padding(top = 1.dp)
                )
            }
        }
        if (action != null && surAction != null) {
            Spacer(Modifier.width(10.dp))
            Text(
                action,
                style = VitrineText.Tiny.copy(fontWeight = FontWeight.W700),
                color = encre,
                modifier = Modifier
                    .clip(FormePill)
                    .clickable(onClick = surAction)
                    .padding(horizontal = 8.dp, vertical = 8.dp)
            )
        }
    }
}
