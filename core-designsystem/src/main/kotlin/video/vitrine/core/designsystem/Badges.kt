package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp

/** Teintes sémantiques des badges (§7.6). */
enum class TeinteBadge { Orange, Succes, Info, Sombre }

/**
 * D42.33 — §7.6 Badge : hauteur 22, padding 9, rayon pill, 11/700.
 * Orange → fond OrangeVoile / texte OrangeDeep ; succès → vert voile /
 * #0B7A55 ; info → BleuVoile / #1B4CA1 ; sur sombre → blanc 18 % / blanc.
 */
@Composable
fun BadgeVitrine(
    texte: String,
    teinte: TeinteBadge = TeinteBadge.Orange,
    modifier: Modifier = Modifier
) {
    val (fond, encre) = when (teinte) {
        TeinteBadge.Orange -> OrangeVoile to OrangeDeep
        TeinteBadge.Succes -> VertVoile to VertTexte
        TeinteBadge.Info -> BleuVoile to InfoEncre
        TeinteBadge.Sombre -> BlancVoile to Blanc
    }
    Box(
        modifier = modifier
            .heightIn(min = Dims.BadgeHauteur)
            .clip(FormePill)
            .background(fond)
            .padding(horizontal = 9.dp, vertical = 3.dp),
        contentAlignment = Alignment.Center
    ) {
        Text(texte, style = VitrineText.Badge, color = encre)
    }
}

/**
 * D42.33 — §7.6 Chip de filtre : hauteur 32, padding 13, 12.8/600, filet
 * Line. Actif : fond Navy, texte blanc, pas de filet.
 */
@Composable
fun ChipFiltre(
    texte: String,
    actif: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .heightIn(min = Dims.ChipHauteur)
            .clip(FormePill)
            .background(if (actif) Navy else Blanc)
            .let { if (!actif) it.border(1.dp, Line, FormePill) else it }
            .clickable(onClick = onClick)
            .padding(horizontal = 13.dp, vertical = 6.dp),
        contentAlignment = Alignment.Center
    ) {
        Text(texte, style = VitrineText.Chip, color = if (actif) Blanc else Navy)
    }
}

/** États du point de synchro (§7.6 + §10). */
enum class EtatPoint { Synchro, Attente, HorsLigne }

/**
 * D42.33 — §7.6 Point de synchro : 7 dp VertSucces + halo 3 dp
 * rgba(14,159,110,.14). Variantes attente (orange) / hors-ligne (ambre).
 * Cible tactile 48 dp (padding invisible).
 */
@Composable
fun PointSynchro(
    etat: EtatPoint = EtatPoint.Synchro,
    modifier: Modifier = Modifier
) {
    val couleur = when (etat) {
        EtatPoint.Synchro -> VertSucces
        EtatPoint.Attente -> OrangeStore
        EtatPoint.HorsLigne -> AmbreAlerte
    }
    Box(modifier = modifier.size(Dims.CibleTactile), contentAlignment = Alignment.Center) {
        Box(
            modifier = Modifier
                .size(13.dp)
                .clip(CircleShape)
                .background(couleur.copy(alpha = 0.14f)),
            contentAlignment = Alignment.Center
        ) {
            Box(
                modifier = Modifier
                    .size(7.dp)
                    .clip(CircleShape)
                    .background(couleur)
            )
        }
    }
}
