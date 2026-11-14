package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp

/**
 * D42.33 — §7.15 Overlay caméra : cadre 2/4 superposé au retour vidéo
 * (coins 18, trait blanc 2 dp 70 %), grille des tiers à 30 %. Le retour
 * vidéo CameraX reste SOUS l'overlay — ce composant ne touche JAMAIS au
 * moteur caméra, il ne fait que dessiner par-dessus.
 */
@Composable
fun OverlayViseur(
    fractionCadre: Float = 0.78f,
    modifier: Modifier = Modifier
) {
    Box(modifier = modifier.drawBehind {
        val w = size.width * fractionCadre
        val h = size.height * fractionCadre
        val gauche = (size.width - w) / 2f
        val haut = (size.height - h) / 2f
        val trait = 2.dp.toPx()
        val blanc70 = Color(0xB3FFFFFF)
        val coin = 18.dp.toPx()
        val bras = coin * 1.4f
        // Quatre coins arrondis (§7.15)
        fun brasCoin(x: Float, y: Float, dx: Float, dy: Float) {
            drawLine(blanc70, Offset(x, y), Offset(x + dx * bras, y), trait)
            drawLine(blanc70, Offset(x, y), Offset(x, y + dy * bras), trait)
        }
        brasCoin(gauche, haut, 1f, 1f)
        brasCoin(gauche + w, haut, -1f, 1f)
        brasCoin(gauche, haut + h, 1f, -1f)
        brasCoin(gauche + w, haut + h, -1f, -1f)
        // Grille des tiers à 30 % (§7.15)
        val tiers = Color(0x4DFFFFFF)
        val epaisseurFin = (trait / 2f).coerceAtLeast(1f)
        listOf(1f / 3f, 2f / 3f).forEach { f ->
            drawLine(tiers, Offset(gauche + w * f, haut), Offset(gauche + w * f, haut + h), epaisseurFin)
            drawLine(tiers, Offset(gauche, haut + h * f), Offset(gauche + w, haut + h * f), epaisseurFin)
        }
    })
}

/**
 * D42.33 — §7.15 bandeau de consigne caméra : bandeau rgba(2,35,88,.55) +
 * texte blanc 15/600 sur 2 lignes max. La consigne ne cache jamais le sujet
 * (bandeau BAS, hauteur contrainte).
 */
@Composable
fun BandeauConsigne(
    consigne: String,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .fillMaxWidth()
            .background(Color(0x8C022358))
            .padding(horizontal = 20.dp, vertical = 12.dp)
    ) {
        Text(
            consigne,
            style = VitrineText.Body.copy(fontWeight = FontWeight.W600),
            color = Color.White,
            maxLines = 2
        )
    }
}

/**
 * D42.33 — §7.15 bouton d'arrêt caméra : carré arrondi 64 dp rouge
 * #B42318, glyphe stop blanc 22. Le rouge est RÉSERVÉ à l'arrêt/destructif —
 * jamais orange (l'orange reste l'action de progression).
 */
@Composable
fun BoutonStopCamera(
    surArret: () -> Unit,
    modifier: Modifier = Modifier
) {
    val forme = RoundedCornerShape(16.dp)
    Box(
        modifier = modifier
            .size(Dims.StopCamera)
            .clip(forme)
            .background(RougeBloquant)
            .clickable(onClick = surArret),
        contentAlignment = Alignment.Center
    ) {
        Box(
            modifier = Modifier
                .size(22.dp)
                .clip(RoundedCornerShape(5.dp))
                .background(Color.White)
        )
    }
}
