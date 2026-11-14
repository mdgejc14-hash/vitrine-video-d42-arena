package video.vitrine.core.designsystem

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/**
 * D42.33 (§5 étape 4, §7.2/§9.2/§9.4) — marque « tuile » : insigne dans une
 * tuile blanche arrondie. Source UNIQUE (avant : 3 copies privées dans
 * carrousel / bienvenue / catalogue). Sur fond sombre OU clair.
 */
@Composable
fun MarqueVitrine(
    taille: Dp = 44.dp,
    logo: Dp = 30.dp,
    rayon: Dp = 14.dp,
    modifier: Modifier = Modifier,
) {
    Box(
        modifier = modifier
            .size(taille)
            .clip(RoundedCornerShape(rayon))
            .background(Color.White),
        contentAlignment = Alignment.Center
    ) {
        Image(
            painter = painterResource(R.drawable.vitrine_logo),
            contentDescription = null, // marque décorative (le titre porte l'information)
            modifier = Modifier.size(logo)
        )
    }
}
