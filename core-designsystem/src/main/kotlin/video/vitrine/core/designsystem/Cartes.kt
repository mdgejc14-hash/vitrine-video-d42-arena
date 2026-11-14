package video.vitrine.core.designsystem

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Paint
import androidx.compose.ui.graphics.PaintingStyle
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/**
 * D42.33 — §7.4 Carte : Blanc, rayon 22, padding 18, shSm. Carte héro :
 * rayon 26, padding 20, shMd. Règle §7.4 : jamais de bordure sur une carte
 * qui a une ombre (carte plate → filet ; carte soulevée → ombre).
 */
@Composable
fun CarteVitrine(
    modifier: Modifier = Modifier,
    hero: Boolean = false,
    plate: Boolean = false,
    contenu: @Composable () -> Unit
) {
    val forme = if (hero) FormeHero else FormeCarte
    val interieur = if (hero) Dims.HeroPadding else Dims.CartePadding
    val m = modifier
        .clip(forme)
        .background(Blanc)
        .let {
            when {
                plate -> it.border(1.dp, Line, forme)
                hero -> it.ombreMd(forme)
                else -> it.ombreSm(forme)
            }
        }
        .padding(interieur)
    Box(modifier = m) { contenu() }
}

/**
 * D42.33 — §5 halos des blocs sombres : cercle flouté orange en haut à
 * droite (rgba(249,92,15,.30)), bleu navy en bas à gauche (rgba(35,70,127,.55)).
 * Les blocs sombres n'ont PAS d'ombre : ils ont un halo.
 */
fun Modifier.haloSombre(): Modifier = drawBehind {
    val paint = Paint()
    drawIntoCanvas { canvas ->
        paint.style = PaintingStyle.Fill
        paint.color = Color(0x4DF95C0F)
        canvas.drawCircle(Offset(size.width * 0.94f, size.height * 0.04f), size.width * 0.38f, paint)
        paint.color = Color(0x8C23467F)
        canvas.drawCircle(Offset(size.width * 0.02f, size.height * 1.02f), size.width * 0.5f, paint)
    }
}

/**
 * D42.33 — §7.5 Carte héro sombre (crédits / solde) : fond Navy + 2 halos,
 * rayon 26, padding 20. Ligne 1 : Label blanc 60 % + pastille de statut ;
 * Ligne 2 : Num 40 blanc + unité Body 13 blanc 70 % ; Ligne 3 : rangée de
 * badges sur fond blanc 10 % ; Décor : anneau orange 56 dp à droite.
 * Le contenu (chiffres, libellés) vient de l'appelant — rien d'inventé ici.
 */
@Composable
fun CarteHeroSombre(
    label: String,
    chiffre: String,
    unite: String,
    icone: Painter,
    statut: (@Composable () -> Unit)?,
    badges: @Composable () -> Unit,
    modifier: Modifier = Modifier,
    testTag: String? = null
) {
    val m = modifier
        .fillMaxWidth()
        .let { base -> testTag?.let { base.testTag(it) } ?: base }
        .clip(FormeHero)
        .background(Navy)
        .haloSombre()
        .padding(Dims.HeroPadding)
    Box(modifier = m) {
        Column {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    label,
                    style = VitrineText.Label,
                    color = Blanc60,
                    modifier = Modifier.weight(1f)
                )
                statut?.invoke()
            }
            Row(
                verticalAlignment = Alignment.Bottom,
                modifier = Modifier.padding(top = 6.dp)
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(chiffre, style = VitrineText.Num, color = Blanc)
                    Text(unite, style = VitrineText.Body.copy(fontSize = 13.sp), color = Blanc70)
                }
                DecorAnneau(icone)
            }
            Box(
                modifier = Modifier
                    .padding(top = 14.dp)
                    .fillMaxWidth()
                    .clip(FormeTuile)
                    .background(Blanc10)
                    .padding(horizontal = 12.dp, vertical = 10.dp)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) { badges() }
            }
        }
    }
}

/**
 * D42.33 — §7.5 décor : anneau orange 56 dp, 2 cercles concentriques
 * (opacité 22 % et 100 %), tuile 34 dp avec l'icône video.
 */
@Composable
private fun DecorAnneau(icone: Painter) {
    Box(modifier = Modifier.size(56.dp), contentAlignment = Alignment.Center) {
        Canvas(modifier = Modifier.size(56.dp)) {
            val r = size.minDimension / 2f
            drawCircle(
                color = OrangeStore.copy(alpha = 0.22f),
                radius = r,
                style = Stroke(width = 2.dp.toPx())
            )
            drawCircle(
                color = OrangeStore,
                radius = r - 4.dp.toPx(),
                style = Stroke(width = 2.dp.toPx())
            )
        }
        Box(
            modifier = Modifier
                .size(34.dp)
                .clip(FormeTuile)
                .background(OrangeStore.copy(alpha = 0.18f)),
            contentAlignment = Alignment.Center
        ) {
            IconeVitrine(icone, taille = 20.dp, teinte = OrangeStore)
        }
    }
}
