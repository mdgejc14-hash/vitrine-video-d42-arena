package video.vitrine.core.designsystem

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.unit.dp

/**
 * D42.33 — §7.1 Bouton primaire : pilule 56 dp pleine largeur (marge 20),
 * dégradé OrangeHi → OrangeStore (180°), texte blanc 16/700 Jakarta, icône 19
 * à gauche (gap 9), shOrange. Appui : échelle 0,98 + ombre réduite.
 * Désactivé : #EDEFF5 + texte #9AA7BE, SANS ombre. Chargement : spinner 18
 * blanc à la place de l'icône, libellé conservé.
 */
@Composable
fun BoutonPrimaire(
    libelle: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    icone: Painter? = null,
    enabled: Boolean = true,
    chargement: Boolean = false,
    testTag: String? = null
) {
    val interaction = remember { MutableInteractionSource() }
    val presse by interaction.collectIsPressedAsState()
    val echelle by animateFloatAsState(
        targetValue = if (presse && enabled) 0.98f else 1f,
        label = "cta-echelle"
    )
    val fond: Brush = if (enabled) {
        Brush.verticalGradient(listOf(OrangeHi, OrangeStore))
    } else {
        Brush.verticalGradient(listOf(GrisDesactive, GrisDesactive))
    }
    val forme = FormePill
    Box(
        modifier = modifier
            .fillMaxWidth()
            .heightIn(min = Dims.Cta)
            .let { m -> testTag?.let { m.testTag(it) } ?: m }
            .graphicsLayer { scaleX = echelle; scaleY = echelle }
            .clip(forme)
            .background(fond)
            .let { if (enabled && !chargement) it.ombreOrange(forme) else it }
            .clickable(interactionSource = interaction, indication = null, enabled = enabled && !chargement, onClick = onClick),
        contentAlignment = Alignment.Center
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(9.dp)
        ) {
            if (chargement) {
                CircularProgressIndicator(
                    modifier = Modifier.size(18.dp),
                    strokeWidth = 2.dp,
                    color = Blanc
                )
            } else {
                icone?.let {
                    IconeVitrine(it, taille = 19.dp, teinte = Blanc)
                }
            }
            Text(libelle, style = VitrineText.Button, color = if (enabled) Blanc else GrisDesactiveTexte)
        }
    }
}

/**
 * D42.33 — §7.2 Bouton secondaire : pilule 46 dp, Surface, filet 1 dp Line,
 * texte Navy 14.5/600. Variante « douce » : fond OrangeVoile, texte
 * OrangeDeep, sans filet ni ombre.
 */
@Composable
fun BoutonSecondaire(
    libelle: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    icone: Painter? = null,
    doux: Boolean = false,
    enabled: Boolean = true,
    pleineLargeur: Boolean = false,
    testTag: String? = null
) {
    val forme = FormePill
    Box(
        modifier = modifier
            .let { if (pleineLargeur) it.fillMaxWidth() else it }
            .heightIn(min = Dims.CtaSecondaire)
            .let { m -> testTag?.let { m.testTag(it) } ?: m }
            .clip(forme)
            .background(if (doux) OrangeVoile else Blanc)
            .let { if (!doux) it.border(1.dp, Line, forme) else it }
            .clickable(enabled = enabled, onClick = onClick),
        contentAlignment = Alignment.Center
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            icone?.let { IconeVitrine(it, taille = 18.dp, teinte = if (doux) OrangeDeep else Navy) }
            Text(
                libelle,
                style = VitrineText.Sub.copy(fontWeight = androidx.compose.ui.text.font.FontWeight.W600),
                color = when {
                    !enabled -> GrisDesactiveTexte
                    doux -> OrangeDeep
                    else -> Navy
                }
            )
        }
    }
}

/** Variantes du bouton icône (§7.3). */
enum class VarianteIcone { Clair, Voile, Verre }

/**
 * D42.33 — §7.3 Bouton icône : 40 × 40 dp, rayon 14, Surface + shSm, glyphe
 * 20 Navy. Variantes : [VarianteIcone.Voile] (fond OrangeVoile, glyphe
 * orange), [VarianteIcone.Verre] (blanc 18 %, glyphe blanc — fond coloré
 * uniquement ; le flou réel exige API 31+, translucence garantie partout).
 * Cible tactile 48 dp assurée par padding invisible.
 */
@Composable
fun BoutonIcone(
    icone: Painter,
    contenuDescription: String?,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    variante: VarianteIcone = VarianteIcone.Clair,
    tailleGlyph: androidx.compose.ui.unit.Dp = Dims.IconeBouton,
    testTag: String? = null
) {
    val interaction = remember { MutableInteractionSource() }
    val presse by interaction.collectIsPressedAsState()
    val (fond, teinte) = parametresVariante(variante)
    Box(
        modifier = modifier
            .size(Dims.CibleTactile)
            .let { m -> testTag?.let { m.testTag(it) } ?: m }
            .clickable(interactionSource = interaction, indication = null, onClick = onClick),
        contentAlignment = Alignment.Center
    ) {
        val forme = FormeIcone
        Box(
            modifier = Modifier
                .size(Dims.BoutonIcone)
                .clip(forme)
                .background(fond)
                .let { if (variante == VarianteIcone.Clair && !presse) it.ombreSm(forme) else it }
                .let { if (presse) it.border(1.dp, Line, forme) else it },
            contentAlignment = Alignment.Center
        ) {
            IconeVitrine(icone, taille = tailleGlyph, teinte = teinte)
        }
    }
}

/** Résolution fond/teinte du bouton icône (§7.3) — extraite (detekt D42.33). */
private fun parametresVariante(variante: VarianteIcone): Pair<Color, Color> = when (variante) {
    VarianteIcone.Clair -> Blanc to Navy
    VarianteIcone.Voile -> OrangeVoile to OrangeStore
    VarianteIcone.Verre -> BlancVoile to Blanc
}

/** Rendu d'icône unifié du design system (teinte + taille, null → rien). */
@Composable
fun IconeVitrine(
    icone: Painter,
    taille: androidx.compose.ui.unit.Dp,
    teinte: Color,
    contenuDescription: String? = null,
    modifier: Modifier = Modifier
) {
    androidx.compose.foundation.Image(
        painter = icone,
        contentDescription = contenuDescription,
        modifier = modifier.size(taille),
        colorFilter = androidx.compose.ui.graphics.ColorFilter.tint(teinte)
    )
}

/** Surcharge ImageVector (icônes programmatiques éventuelles). */
@Composable
fun IconeVitrine(
    icone: ImageVector,
    taille: androidx.compose.ui.unit.Dp,
    teinte: Color,
    contenuDescription: String? = null,
    modifier: Modifier = Modifier
) {
    androidx.compose.foundation.Image(
        imageVector = icone,
        contentDescription = contenuDescription,
        modifier = modifier.size(taille),
        colorFilter = androidx.compose.ui.graphics.ColorFilter.tint(teinte)
    )
}

/** Pastille blanche 44 dp pour logos tiers officiels (§6) — jamais recolorés. */
@Composable
fun PastilleLogoTiers(
    logo: Painter,
    contenuDescription: String?,
    modifier: Modifier = Modifier,
    tailleLogo: androidx.compose.ui.unit.Dp = 22.dp
) {
    Box(
        modifier = modifier
            .size(Dims.PastilleLogo)
            .clip(CircleShape)
            .background(Blanc)
            .border(1.dp, Line, CircleShape),
        contentAlignment = Alignment.Center
    ) {
        androidx.compose.foundation.Image(
            painter = logo,
            contentDescription = contenuDescription,
            modifier = Modifier.size(tailleLogo)
        )
    }
}
