package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp

/** États d'une tuile de prise (§7.12). */
enum class EtatPrise { Vide, Validee, ARefaire }

/** Contour pointillé 1 dp Line (tuile vide, §7.12). */
private fun Modifier.pointille(): Modifier = drawBehind {
    drawRoundRect(
        color = Line,
        style = Stroke(
            width = 1.dp.toPx(),
            pathEffect = PathEffect.dashPathEffect(floatArrayOf(6.dp.toPx(), 5.dp.toPx()))
        ),
        cornerRadius = CornerRadius(18.dp.toPx())
    )
}

/**
 * D42.33 — §7.12 Tuile de prise (vidéo) : format 16:9, rayon 18, fond navy
 * 8 %. Badge durée en bas à droite : pilule noire 60 % + texte blanc 11/700
 * (durée RÉELLE passée par l'appelant). États :
 *  - Vide : contour pointillé 1 dp Line + icône plus + « Scène 2 » ;
 *  - Validée : vignette + coche verte 20 dans une pastille blanche ;
 *  - À refaire : vignette voilée + badge ambre « À refaire ».
 */
@Composable
fun TuilePrise(
    etat: EtatPrise,
    modifier: Modifier = Modifier,
    duree: String? = null,
    libelleVide: String? = null,
    libelleARefaire: String? = null,
    miniature: (@Composable () -> Unit)? = null,
    onClick: (() -> Unit)? = null
) {
    val m = modifier
        .fillMaxWidth()
        .aspectRatio(16f / 9f)
        .clip(FormeTuile)
        .let { base -> onClick?.let { base.clickable(onClick = it) } ?: base }
    Box(modifier = m.background(Navy.copy(alpha = 0.08f))) {
        when (etat) {
            EtatPrise.Vide -> {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .pointille(),
                    contentAlignment = Alignment.Center
                ) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        IconeVitrine(
                            icone = painterResource(R.drawable.ic_plus),
                            taille = 24.dp,
                            teinte = Muted
                        )
                        if (libelleVide != null) {
                            Text(
                                libelleVide,
                                style = VitrineText.Tiny,
                                color = Muted,
                                modifier = Modifier.padding(top = 4.dp)
                            )
                        }
                    }
                }
            }
            EtatPrise.Validee -> {
                miniature?.invoke()
                Box(
                    modifier = Modifier
                        .padding(8.dp)
                        .size(28.dp)
                        .clip(FormePill)
                        .background(Blanc)
                        .align(Alignment.TopEnd),
                    contentAlignment = Alignment.Center
                ) {
                    IconeVitrine(
                        icone = painterResource(R.drawable.ic_check),
                        taille = 18.dp,
                        teinte = VertSucces
                    )
                }
            }
            EtatPrise.ARefaire -> {
                miniature?.invoke()
                Box(modifier = Modifier.fillMaxSize().background(Navy.copy(alpha = 0.35f)))
                libelleARefaire?.let { libelle ->
                    Box(modifier = Modifier.align(Alignment.BottomStart).padding(8.dp)) {
                        BadgeVitrine(texte = libelle, teinte = TeinteBadge.Orange)
                    }
                }
            }
        }
        if (duree != null && etat != EtatPrise.Vide) {
            Box(
                modifier = Modifier
                    .align(Alignment.BottomEnd)
                    .padding(8.dp)
                    .clip(FormePill)
                    .background(Color(0x99000000))
                    .padding(horizontal = 8.dp, vertical = 3.dp)
            ) {
                Text(duree, style = VitrineText.Badge, color = Blanc)
            }
        }
    }
}
