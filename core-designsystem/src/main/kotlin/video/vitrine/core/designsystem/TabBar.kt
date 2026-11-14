package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.clickable
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/** Une entrée de la barre d'onglets (§7.13). */
data class EntreeOnglet(
    val icone: Painter,
    val libelle: String,
    val actif: Boolean
)

/**
 * D42.33 — §7.13 Tab bar : hauteur 74 + 26 safe, fond Blanc, filet
 * supérieur 1 dp Line, 4 entrées à libellé 10.5/600 (actif : Navy + glyphe
 * plein ; inactif : Muted). Action centrale : cercle 56 dp orange, icône
 * plus blanche 26, shLg, décalée de −18 dp au-dessus de la barre, libellé
 * « Créer » sous le cercle. La navigation réelle reste portée par
 * l'appelant (onOnglet / onCentrale).
 */
@Composable
fun BarreOnglets(
    entrees: List<EntreeOnglet>,
    iconeCentrale: Painter,
    libelleCentrale: String,
    surOnglet: (Int) -> Unit,
    surCentrale: () -> Unit,
    modifier: Modifier = Modifier
) {
    Box(modifier = modifier.fillMaxWidth()) {
        Column {
            Box(modifier = Modifier.fillMaxWidth().height(1.dp).background(Line))
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .heightIn(min = Dims.TabBar)
                    .background(Blanc),
                verticalAlignment = Alignment.CenterVertically
            ) {
                entrees.forEachIndexed { index, entree ->
                    if (index == entrees.size / 2) {
                        // Slot central réservé à l'action flottante (§7.13).
                        Box(modifier = Modifier.weight(1f))
                    }
                    Box(
                        modifier = Modifier
                            .weight(1f)
                            .clickable { surOnglet(index) }
                            .padding(vertical = 10.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            IconeVitrine(
                                icone = entree.icone,
                                taille = Dims.IconeTabBar,
                                teinte = if (entree.actif) Navy else Muted
                            )
                            Text(
                                entree.libelle,
                                style = androidx.compose.ui.text.TextStyle(
                                    fontFamily = Inter,
                                    fontWeight = FontWeight.W600,
                                    fontSize = 10.5.sp
                                ),
                                color = if (entree.actif) Navy else Muted,
                                maxLines = 1,
                                modifier = Modifier.padding(top = 3.dp)
                            )
                        }
                    }
                }
            }
        }
        // Action centrale flottante : décalée de −18 dp, cercle 56 orange.
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier
                .align(Alignment.TopCenter)
                .offset(y = -Dims.TabBarCentreDecalage)
        ) {
            Box(
                modifier = Modifier
                    .size(Dims.Cta)
                    .clip(FormePill)
                    .background(
                        androidx.compose.ui.graphics.Brush.verticalGradient(
                            listOf(OrangeHi, OrangeStore)
                        )
                    )
                    .ombreLg(FormePill)
                    .clickable(onClick = surCentrale),
                contentAlignment = Alignment.Center
            ) {
                IconeVitrine(iconeCentrale, taille = Dims.IconeCentrale, teinte = Blanc)
            }
            Text(
                libelleCentrale,
                style = androidx.compose.ui.text.TextStyle(
                    fontFamily = Inter,
                    fontWeight = FontWeight.W600,
                    fontSize = 10.5.sp
                ),
                color = Navy,
                modifier = Modifier.padding(top = 3.dp)
            )
        }
    }
}
