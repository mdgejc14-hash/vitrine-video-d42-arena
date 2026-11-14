package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/**
 * D42.33 — §7.7 Ligne de liste : hauteur min 72, padding 14, rayon 22,
 * Blanc, shSm. Vignette 48 rayon 14 (ou tuile d'icône voilée). Titre 15/700
 * (1 ligne), méta 12.5 Muted (1 ligne), barre de progression 4 dp optionnelle.
 * À droite : action texte 13/700 OrangeDeep ou chevron 20.
 */
@Composable
fun LigneListe(
    titre: String,
    meta: String?,
    onClick: () -> Unit,
    vignette: (@Composable () -> Unit)? = null,
    progression: Float? = null,
    action: String? = null,
    chevron: Boolean = true,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .heightIn(min = Dims.LigneListe)
            .clip(FormeCarte)
            .background(Blanc)
            .ombreSm(FormeCarte)
            .clickable(onClick = onClick)
            .padding(14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        vignette?.invoke()
        if (vignette != null) Spacer(Modifier.width(12.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(titre, style = VitrineText.BodyStrong, color = Navy, maxLines = 1)
            if (meta != null) {
                Text(
                    meta,
                    style = VitrineText.Tiny,
                    color = Muted,
                    maxLines = 1,
                    modifier = Modifier.padding(top = 2.dp)
                )
            }
            if (progression != null) {
                BarreProgression(
                    progression = progression,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(top = 8.dp)
                )
            }
        }
        if (action != null) {
            Spacer(Modifier.width(8.dp))
            Text(action, style = VitrineText.Tiny.copy(fontSize = 13.sp), color = OrangeDeep)
        } else if (chevron) {
            IconeVitrine(
                icone = painterResource(R.drawable.ic_chevron_right),
                taille = 20.dp,
                teinte = Muted
            )
        }
    }
}

/**
 * D42.33 — §7.7 tuile d'icône 48 dp avec fond voilé (variante de vignette).
 */
@Composable
fun TuileIcone(icone: Painter, fond: Color, modifier: Modifier = Modifier) {
    Box(
        modifier = modifier
            .size(Dims.Vignette)
            .clip(FormeIcone)
            .background(fond),
        contentAlignment = Alignment.Center
    ) {
        IconeVitrine(icone, taille = 22.dp, teinte = Navy)
    }
}
