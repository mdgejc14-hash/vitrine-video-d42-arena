package video.vitrine.feature.catalog

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.unit.dp
import video.vitrine.core.model.Sector

/**
 * D42.30 (retour terrain : « catalogue peu pro ») — vignette sectorielle
 * DESSINÉE pour chaque carte gabarit. Contractuelle : jamais une icône
 * générique ni un faux aperçu vidéo — un visuel de marque honnête qui
 * parle le langage métier (cadrage caméra, pellicule des scènes, durée).
 * Zéro dépendance (Compose Canvas pur), marche hors-ligne.
 */
@Composable
internal fun VignetteSecteur(
    secteur: Sector,
    dureeS: Int?,
    scenes: Int?,
    modifier: Modifier = Modifier,
) {
    val (teinteHaute, teinteBasse) = paletteSecteur(secteur)
    Box(
        modifier = modifier
            .aspectRatio(16f / 9f)
            .clip(RoundedCornerShape(10.dp))
            .background(Brush.verticalGradient(listOf(teinteHaute, teinteBasse)))
    ) {
        Canvas(modifier = Modifier.matchParentSize()) {
            dessinerDecorVignette(scenes)
        }
        // icône métier du secteur (haut-gauche)
        Canvas(
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(10.dp)
                .size(22.dp)
        ) {
            dessinerIconeSecteur(secteur, Color.White.copy(alpha = 0.92f))
        }
        // badge durée (haut-droite) — info réelle
        if (dureeS != null) {
            Box(
                modifier = Modifier
                    .align(Alignment.TopEnd)
                    .padding(8.dp)
                    .background(Color.Black.copy(alpha = 0.35f), RoundedCornerShape(6.dp))
                    .padding(horizontal = 7.dp, vertical = 2.dp)
            ) {
                Text(
                    "${dureeS}s",
                    color = Color.White,
                    style = MaterialTheme.typography.labelSmall,
                )
            }
        }
    }
}

/** Vignette + libellé secteur dessous (carte Skin sans miniature réseau). */
@Composable
internal fun VignetteSecteurAvecLibelle(
    secteur: Sector,
    libelle: String,
    dureeS: Int?,
    scenes: Int?,
    modifier: Modifier = Modifier,
) {
    Column(modifier = modifier) {
        VignetteSecteur(secteur, dureeS, scenes, Modifier.fillMaxWidth())
        Row(
            modifier = Modifier.padding(top = 4.dp),
            horizontalArrangement = Arrangement.spacedBy(6.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Box(
                modifier = Modifier
                    .size(8.dp)
                    .background(paletteSecteur(secteur).first, RoundedCornerShape(4.dp))
            ) {}
            Text(
                libelle,
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}


/** Décor dessiné de la vignette : viseur caméra, pastille lecture, pellicule. */
private fun DrawScope.dessinerDecorVignette(scenes: Int?) {
    val w = size.width
    val h = size.height
    val encrage = Color.White.copy(alpha = 0.5f)
    val coin = w * 0.05f
    val marge = w * 0.045f
    // 1) quatre coins de viseur — langage caméra
    drawLine(encrage, Offset(marge, marge), Offset(marge + coin, marge), 3f)
    drawLine(encrage, Offset(marge, marge), Offset(marge, marge + coin), 3f)
    drawLine(encrage, Offset(w - marge, marge), Offset(w - marge - coin, marge), 3f)
    drawLine(encrage, Offset(w - marge, marge), Offset(w - marge, marge + coin), 3f)
    drawLine(encrage, Offset(marge, h - marge), Offset(marge + coin, h - marge), 3f)
    drawLine(encrage, Offset(marge, h - marge), Offset(marge, h - marge - coin), 3f)
    drawLine(encrage, Offset(w - marge, h - marge), Offset(w - marge - coin, h - marge), 3f)
    drawLine(encrage, Offset(w - marge, h - marge), Offset(w - marge, h - marge - coin), 3f)
    // 2) D42.32 (Lot 2) : PLUS de pastille LECTURE centrale — un bouton Play
    // sans prévisualisation réelle est un faux lecteur vidéo (exigence
    // fondateur). Le visuel reste honnête : cadrage caméra + pellicule des
    // scènes (info réelle) + icône métier + badge durée.
    // 3) pellicule bas : une cellule par scène (info réelle du gabarit)
    val nScenes = (scenes ?: 0).coerceIn(0, 12)
    if (nScenes > 0) {
        val cellW = w * 0.052f
        val pas = cellW * 1.45f
        var x = (w - (nScenes * cellW + (nScenes - 1) * (pas - cellW))) / 2f
        val y = h * 0.86f
        val cellH = h * 0.065f
        repeat(nScenes) {
            drawRoundRect(
                Color.White.copy(alpha = 0.7f),
                topLeft = Offset(x, y),
                size = Size(cellW, cellH),
                cornerRadius = CornerRadius(2f, 2f),
            )
            x += pas
        }
    }
}

/** Palette par secteur — chaque métier a sa teinte profonde, jamais du gris. */
internal fun paletteSecteur(secteur: Sector): Pair<Color, Color> = when (secteur) {
    Sector.MODE -> Color(0xFF4A3160) to Color(0xFF241536)
    Sector.COIFFURE -> Color(0xFF6A2E55) to Color(0xFF301029)
    Sector.RESTAURATION -> Color(0xFF84422A) to Color(0xFF3A1B11)
    Sector.BTP -> Color(0xFF2F5468) to Color(0xFF122833)
    Sector.IMMO_AUTO -> Color(0xFF25543C) to Color(0xFF0D281A)
    Sector.COMMERCE -> Color(0xFF0F3566) to Color(0xFF041A38)
    Sector.TOUS -> Color(0xFF24365E) to Color(0xFF0A1430)
}

/** Iconographie métier minimale, dessinée (pas d'emoji, pas de drawable externe). */
private fun DrawScope.dessinerIconeSecteur(secteur: Sector, couleur: Color) {
    val s = kotlin.math.min(size.width, size.height)
    fun x(f: Float) = f * s
    fun y(f: Float) = f * s
    val trait = s * 0.07f
    when (secteur) {
        Sector.MODE -> { // t-shirt
            val p = Path().apply {
                moveTo(x(0.22f), y(0.30f)); lineTo(x(0.38f), y(0.14f)); lineTo(x(0.50f), y(0.21f))
                lineTo(x(0.62f), y(0.14f)); lineTo(x(0.78f), y(0.30f)); lineTo(x(0.68f), y(0.43f))
                lineTo(x(0.64f), y(0.41f)); lineTo(x(0.64f), y(0.88f)); lineTo(x(0.36f), y(0.88f))
                lineTo(x(0.36f), y(0.41f)); lineTo(x(0.32f), y(0.43f)); close()
            }
            drawPath(p, couleur)
        }
        Sector.COIFFURE -> { // ciseaux
            drawCircle(couleur, radius = s * 0.10f, center = Offset(x(0.24f), y(0.26f)), style = Stroke(trait))
            drawCircle(couleur, radius = s * 0.10f, center = Offset(x(0.24f), y(0.74f)), style = Stroke(trait))
            drawLine(couleur, Offset(x(0.33f), y(0.33f)), Offset(x(0.86f), y(0.72f)), trait)
            drawLine(couleur, Offset(x(0.33f), y(0.67f)), Offset(x(0.86f), y(0.28f)), trait)
        }
        Sector.RESTAURATION -> { // fourchette
            drawLine(couleur, Offset(x(0.30f), y(0.12f)), Offset(x(0.30f), y(0.40f)), trait)
            drawLine(couleur, Offset(x(0.50f), y(0.12f)), Offset(x(0.50f), y(0.40f)), trait)
            drawLine(couleur, Offset(x(0.70f), y(0.12f)), Offset(x(0.70f), y(0.40f)), trait)
            drawLine(couleur, Offset(x(0.30f), y(0.40f)), Offset(x(0.70f), y(0.40f)), trait)
            drawLine(couleur, Offset(x(0.50f), y(0.40f)), Offset(x(0.50f), y(0.90f)), trait)
        }
        Sector.BTP -> { // marteau
            drawRoundRect(
                couleur,
                topLeft = Offset(x(0.20f), y(0.14f)),
                size = Size(x(0.60f), y(0.22f)),
                cornerRadius = CornerRadius(s * 0.03f, s * 0.03f),
            )
            drawLine(couleur, Offset(x(0.50f), y(0.36f)), Offset(x(0.50f), y(0.90f)), s * 0.11f)
        }
        Sector.IMMO_AUTO -> { // maison
            val p = Path().apply {
                moveTo(x(0.50f), y(0.10f)); lineTo(x(0.90f), y(0.46f)); lineTo(x(0.78f), y(0.46f))
                lineTo(x(0.78f), y(0.90f)); lineTo(x(0.22f), y(0.90f)); lineTo(x(0.22f), y(0.46f))
                lineTo(x(0.10f), y(0.46f)); close()
            }
            drawPath(p, couleur)
        }
        Sector.COMMERCE -> { // auvent de boutique
            val p = Path().apply {
                moveTo(x(0.10f), y(0.40f)); lineTo(x(0.90f), y(0.40f)); lineTo(x(0.82f), y(0.20f))
                lineTo(x(0.18f), y(0.20f)); close()
            }
            drawPath(p, couleur)
            drawRoundRect(
                couleur,
                topLeft = Offset(x(0.24f), y(0.48f)),
                size = Size(x(0.52f), y(0.38f)),
                cornerRadius = CornerRadius(s * 0.02f, s * 0.02f),
            )
        }
        Sector.TOUS -> { // éclair (tous secteurs)
            val p = Path().apply {
                moveTo(x(0.55f), y(0.08f)); lineTo(x(0.25f), y(0.55f)); lineTo(x(0.47f), y(0.55f))
                lineTo(x(0.38f), y(0.92f)); lineTo(x(0.75f), y(0.42f)); lineTo(x(0.52f), y(0.42f)); close()
            }
            drawPath(p, couleur)
        }
    }
}
