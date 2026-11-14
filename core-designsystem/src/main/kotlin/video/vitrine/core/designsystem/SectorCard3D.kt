package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.foundation.Image
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

/**
 * D42.33 — Carte secteur (famille B « choix simple ») : Blanc, rayon 22,
 * sélection = filet 2 dp OrangeStore + coche (§8-B). Règle §7.4 : jamais
 * bordure ET ombre — la carte sélectionnée perd l'ombre.
 * Le paramètre `icon` (emoji historique D42.31) n'est plus rendu : §6
 * interdit les icônes emoji-style. Fallback sans illustration = pastille
 * typographique sur voile orange.
 */
@Composable
fun SectorCard3D(
    label: String,
    @Suppress("UNUSED_PARAMETER") icon: String,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    illustrationRes: Int? = null
) {
    val forme = FormeCarte
    Column(
        modifier = modifier
            .fillMaxWidth()
            .clip(forme)
            .background(Blanc)
            .let { if (selected) it.border(2.dp, OrangeStore, forme) else it.ombreSm(forme) }
            .clickable(onClick = onClick)
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Box(modifier = Modifier.fillMaxWidth()) {
            if (illustrationRes != null) {
                Image(
                    painter = painterResource(illustrationRes),
                    contentDescription = label,
                    // D42.13 : ratio 4:3 conservé (le carré poussait le bouton
                    // hors écran sur 360 dp — 3 rangées = 588 dp).
                    modifier = Modifier
                        .fillMaxWidth()
                        .aspectRatio(4f / 3f),
                    contentScale = ContentScale.Fit
                )
            } else {
                Box(
                    modifier = Modifier
                        .size(56.dp)
                        .clip(FormeIcone)
                        .background(OrangeVoile),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        label.take(2).uppercase(),
                        style = VitrineText.H3.copy(
                            fontFamily = Jakarta,
                            fontWeight = androidx.compose.ui.text.font.FontWeight.W800
                        ),
                        color = OrangeStore
                    )
                }
            }
            if (selected) {
                CocheSelection(modifier = Modifier.align(Alignment.TopEnd))
            }
        }
        Text(
            label,
            style = VitrineText.BodyStrong,
            color = if (selected) OrangeDeep else Navy,
            maxLines = 2
        )
    }
}

/** Coche de sélection (§8-B) — pastille ronde orange + check blanc. */
@Composable
private fun CocheSelection(modifier: Modifier = Modifier) {
    Box(
        modifier = modifier
            .size(22.dp)
            .clip(FormePill)
            .background(OrangeStore),
        contentAlignment = Alignment.Center
    ) {
        IconeVitrine(
            icone = painterResource(R.drawable.ic_check),
            taille = 14.dp,
            teinte = Blanc
        )
    }
}

/** Illustration sectorielle officielle (WebP 480px, dossier secteurs_3d). */
fun sectorIllustration(code: String): Int? = when (code) {
    "mode" -> R.drawable.sector_vetements_mode
    "coiffure" -> R.drawable.sector_coiffure_beaute
    "restauration" -> R.drawable.sector_restaurants_maquis
    "btp" -> R.drawable.sector_batiment_travaux
    "immo_auto" -> R.drawable.sector_immo_auto
    "commerce" -> R.drawable.sector_shops_small_business
    else -> null
}

/**
 * Icône sectorielle historique (emoji D42.31) — conservée pour compatibilité
 * d'appel mais PLUS JAMAIS rendue (§6 : aucune icône emoji-style).
 */
@Deprecated("D42.33 : §6 interdit les emojis — utiliser sectorIllustration", level = DeprecationLevel.WARNING)
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
            SectorCard3D("Vêtements & Mode", "", selected = true, onClick = { })
            SectorCard3D("Coiffure & Beauté", "", selected = false, onClick = { })
        }
    }
}
