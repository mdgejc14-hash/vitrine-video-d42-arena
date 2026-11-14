package video.vitrine.core.designsystem

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/**
 * D42.33 — §7.8 Barre de progression : hauteur 4, rayon pill, piste
 * #EDEFF5, remplissage OrangeStore (VertSucces si terminé).
 */
@Composable
fun BarreProgression(
    progression: Float,
    modifier: Modifier = Modifier,
    terminee: Boolean = false
) {
    val p = progression.coerceIn(0f, 1f)
    Box(
        modifier = modifier
            .fillMaxWidth()
            .height(Dims.Progression)
            .clip(FormePill)
            .background(GrisDesactive)
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth(p)
                .height(Dims.Progression)
                .clip(FormePill)
                .background(if (terminee) VertSucces else OrangeStore)
        )
    }
}

/**
 * D42.33 — §7.8 Stepper 4 scènes : 4 segments séparés de 4 dp, l'actif en
 * orange, les validés en navy, les suivants en piste. Au-dessus : Label +
 * « 2 / 4 » en Tiny (fournis par l'appelant, jamais inventés).
 */
@Composable
fun StepperScenes(
    actif: Int,
    total: Int,
    label: String,
    compteur: String,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(label, style = VitrineText.Label)
            Text(compteur, style = VitrineText.Tiny, color = Muted)
        }
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 8.dp),
            horizontalArrangement = Arrangement.spacedBy(Dims.SegmentEcart)
        ) {
            repeat(total) { index ->
                val couleur = when {
                    index < actif -> Navy
                    index == actif -> OrangeStore
                    else -> GrisDesactive
                }
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .height(Dims.Progression)
                        .clip(FormePill)
                        .background(couleur)
                )
            }
        }
    }
}

/**
 * D42.33 — §7.11 Anneau de progression : épaisseur 6, piste #EDEFF5, arc
 * dégradé orange, centre paramétrable (Num 84 pour un compte à rebours, ou
 * pourcentage 22/800). Toujours accompagné d'un libellé en clair SOUS
 * l'anneau (paramètre [libelle], spec : jamais une animation muette).
 */
@Composable
fun AnneauProgression(
    progression: Float,
    taille: Dp,
    centre: @Composable () -> Unit,
    libelle: String,
    modifier: Modifier = Modifier
) {
    val animee by animateFloatAsState(
        targetValue = progression.coerceIn(0f, 1f),
        label = "anneau-progression"
    )
    Column(modifier = modifier, horizontalAlignment = Alignment.CenterHorizontally) {
        Box(contentAlignment = Alignment.Center) {
            Canvas(modifier = Modifier.size(taille)) {
                val epaisseur = Dims.Anneau.toPx()
                val r = (size.minDimension - epaisseur) / 2f
                val coin = Offset(size.width / 2f, size.height / 2f)
                drawCircle(
                    color = GrisDesactive,
                    radius = r,
                    center = coin,
                    style = Stroke(epaisseur)
                )
                val balayage = 360f * animee
                drawArc(
                    brush = Brush.sweepGradient(listOf(OrangeHi, OrangeStore, OrangeHi)),
                    startAngle = -90f,
                    sweepAngle = balayage,
                    useCenter = false,
                    style = Stroke(epaisseur, cap = StrokeCap.Round)
                )
            }
            centre()
        }
        Text(
            libelle,
            style = VitrineText.Tiny,
            color = Muted,
            modifier = Modifier.padding(top = 8.dp)
        )
    }
}

/** Piste des tuiles de progression (usage interne caméra/montage). */
internal fun pisteArc(taille: Size): Float = taille.minDimension / 2f

/** Couleur de secours si un arc sans brush est demandé (usage interne). */
internal val couleurArc: Color = OrangeStore
