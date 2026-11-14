package video.vitrine.feature.onboarding

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import video.vitrine.core.designsystem.BoutonPrimaire
import video.vitrine.core.designsystem.Blanc80
import video.vitrine.core.designsystem.Navy
import video.vitrine.core.designsystem.OrangeStore
import video.vitrine.core.designsystem.VitrineTheme
import video.vitrine.core.designsystem.haloSombre

/**
 * Carrousel d'accueil (spec §9.2, famille A — écran d'émotion) :
 * photo plein cadre, voile navy 45 % en bas, marque en haut (tuile blanche),
 * pagination (actif = pilule 18 dp orange, inactifs = 6 dp blanc 45 %),
 * H1 29 blanc, Sub blanc 80 % sur 2 lignes, CTA orange + lien « Passer ».
 * Une idée par slide : ce que l'app fait → comment on est guidé → le résultat.
 */
@Composable
fun CarouselScreen(onDone: () -> Unit) {
    val pager = rememberPagerState(pageCount = { 3 })
    val scope = rememberCoroutineScope()
    Box(modifier = Modifier.fillMaxSize().background(Navy)) {
        HorizontalPager(state = pager, modifier = Modifier.fillMaxSize()) { page ->
            val photo = when (page) {
                0 -> R.drawable.carrousel_1_boutique
                1 -> R.drawable.carrousel_2_tournage
                else -> R.drawable.carrousel_3_resultat
            }
            Image(
                painter = painterResource(photo),
                contentDescription = null, // décorative : le titre porte l'information (WCAG 1.1.1)
                contentScale = ContentScale.Crop,
                modifier = Modifier.fillMaxSize()
            )
        }
        // Voile navy 45 % pour garantir le contraste du texte (§9.2 + §12.5).
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(
                    Brush.verticalGradient(
                        0f to Color(0x38022358),
                        0.35f to Color(0x73022358),
                        1f to Color(0xF0022358)
                    )
                )
        )
        Column(
            modifier = Modifier
                .fillMaxSize()
                .haloSombre()
                .padding(horizontal = 20.dp)
                .padding(top = 46.dp, bottom = 26.dp)
        ) {
            MarqueCarrousel()
            Spacer(Modifier.weight(1f))
            val (titre, sousTitre) = when (pager.currentPage) {
                0 -> stringResource(R.string.slide1_slogan) to stringResource(R.string.slide1_sub)
                1 -> stringResource(R.string.slide2_title) to stringResource(R.string.slide2_sub)
                else -> stringResource(R.string.slide3_slogan) to stringResource(R.string.slide3_sub)
            }
            Text(
                titre,
                style = video.vitrine.core.designsystem.VitrineText.H1,
                color = Color.White,
                maxLines = 2
            )
            Text(
                sousTitre,
                style = video.vitrine.core.designsystem.VitrineText.Sub,
                color = Blanc80,
                maxLines = 2,
                modifier = Modifier.padding(top = 8.dp)
            )
            PaginationCarrousel(
                actif = pager.currentPage,
                modifier = Modifier.padding(top = 20.dp)
            )
            BoutonPrimaire(
                libelle = if (pager.currentPage < 2) {
                    stringResource(R.string.carousel_next)
                } else {
                    stringResource(R.string.carousel_start)
                },
                onClick = {
                    if (pager.currentPage < 2) {
                        scope.launch { pager.animateScrollToPage(pager.currentPage + 1) }
                    } else {
                        onDone()
                    }
                },
                modifier = Modifier.padding(top = 18.dp),
                testTag = "carousel_cta"
            )
            Text(
                stringResource(R.string.carousel_skip),
                style = video.vitrine.core.designsystem.VitrineText.Tiny.copy(
                    fontWeight = androidx.compose.ui.text.font.FontWeight.W600
                ),
                color = Blanc80,
                modifier = Modifier
                    .align(Alignment.CenterHorizontally)
                    .padding(top = 10.dp, bottom = 6.dp)
                    .clip(RoundedCornerShape(50))
                    .clickable { onDone() }
                    .padding(horizontal = 16.dp, vertical = 8.dp)
            )
        }
    }
}

/** Marque en haut : insigne dans une tuile blanche rayon 26 (§9.1/§9.2). */
@Composable
private fun MarqueCarrousel() {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Box(
            modifier = Modifier
                .size(44.dp)
                .clip(RoundedCornerShape(14.dp))
                .background(Color.White),
            contentAlignment = Alignment.Center
        ) {
            Image(
                painter = painterResource(video.vitrine.core.designsystem.R.drawable.vitrine_logo),
                contentDescription = null,
                modifier = Modifier.size(30.dp)
            )
        }
    }
}

/** Pagination : actif = pilule 18 dp orange, inactifs = 6 dp blanc 45 %. */
@Composable
private fun PaginationCarrousel(actif: Int, modifier: Modifier = Modifier) {
    Row(modifier = modifier, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
        repeat(3) { index ->
            if (index == actif) {
                Box(
                    modifier = Modifier
                        .width(18.dp)
                        .height(6.dp)
                        .clip(RoundedCornerShape(50))
                        .background(OrangeStore)
                )
            } else {
                Box(
                    modifier = Modifier
                        .size(6.dp)
                        .clip(RoundedCornerShape(50))
                        .background(Color(0x73FFFFFF))
                )
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun CarouselPreview() {
    VitrineTheme { CarouselScreen { } }
}
