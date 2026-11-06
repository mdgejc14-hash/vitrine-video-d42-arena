package video.vitrine.core.designsystem

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

/** Carte secteur 3D neumorphique : relief, liserai, icone metier illustree. */
@Composable
fun SectorCard3D(
    label: String,
    icon: String,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    illustrationRes: Int? = null
) {
    val shape = RoundedCornerShape(20.dp)
    val border = if (selected) OrangeStore else GrisLiserai
    Card(
        onClick = onClick,
        modifier = modifier,
        shape = shape,
        border = BorderStroke(if (selected) 2.dp else 1.dp, border),
        elevation = CardDefaults.cardElevation(defaultElevation = if (selected) 8.dp else 3.dp),
        colors = CardDefaults.cardColors(containerColor = BlancPur)
    ) {
        Column(
            modifier = Modifier
                .background(
                    Brush.verticalGradient(
                        listOf(BlancPur, if (selected) GrisDoux else GrisDoux)
                    )
                )
                .padding(18.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            if (illustrationRes != null) {
                Image(
                    painter = painterResource(illustrationRes),
                    contentDescription = label,
                    // D42.13 : le carré forcait 156 dp de haut par rangée sur un
                    // écran de 360 dp ; 3 rangées = 588 dp à elles seules, le
                    // bouton était poussé hors écran. Le ratio suit la source
                    // (4:3) : ~39 dp gagnés par rangée, sans perte lisible.
                    modifier = Modifier
                        .fillMaxWidth()
                        .aspectRatio(4f / 3f),
                    contentScale = ContentScale.Fit
                )
            } else {
                Text(icon, style = MaterialTheme.typography.displaySmall)
            }
            Text(
                label,
                style = MaterialTheme.typography.titleSmall,
                color = if (selected) OrangeStoreDeep else BleuNuit
            )
        }
    }
}

/** Illustration 3D officielle (maquettes Drive ressources/secteurs_3d, WebP 480px). */
fun sectorIllustration(code: String): Int? = when (code) {
    "mode" -> R.drawable.sector_vetements_mode
    "coiffure" -> R.drawable.sector_coiffure_beaute
    "restauration" -> R.drawable.sector_restaurants_maquis
    "btp" -> R.drawable.sector_batiment_travaux
    "immo_auto" -> R.drawable.sector_immo_auto
    "commerce" -> R.drawable.sector_shops_small_business
    else -> null
}

/** Icone sectorielle illustree (rendu 3D natif emoji, zero asset a telecharger). */
fun sectorIcon(code: String): String =
    when (code) {
        "mode" -> "👗"
        "coiffure" -> "✂️"
        "restauration" -> "🍲"
        "btp" -> "🏗️"
        "immo_auto" -> "🚗"
        "commerce" -> "🛒"
        else -> "🏪"
    }

@Preview(showBackground = true)
@Composable
private fun SectorCard3DPreview() {
    VitrineTheme {
        Column(verticalArrangement = Arrangement.spacedBy(12.dp), modifier = Modifier.padding(16.dp)) {
            SectorCard3D("Vêtements & Mode", "👗", selected = true, onClick = { })
            SectorCard3D("Coiffure & Beauté", "✂️", selected = false, onClick = { })
        }
    }
}
