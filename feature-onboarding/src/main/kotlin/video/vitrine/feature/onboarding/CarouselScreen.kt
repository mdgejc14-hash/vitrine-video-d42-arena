package video.vitrine.feature.onboarding

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import video.vitrine.core.designsystem.BlancPur
import video.vitrine.core.designsystem.OrangeStore
import video.vitrine.core.designsystem.VitrineLogoHeader
import video.vitrine.core.designsystem.VitrineTheme

/** Carrousel d'accueil officiel : 3 glissades, slogan et promesse metier. */
@Composable
fun CarouselScreen(onDone: () -> Unit) {
    val pager = rememberPagerState(pageCount = { 3 })
    val scope = rememberCoroutineScope()
    Column(modifier = Modifier.fillMaxSize(), horizontalAlignment = Alignment.CenterHorizontally) {
        VitrineLogoHeader()
        HorizontalPager(state = pager, modifier = Modifier.weight(1f)) { page ->
            when (page) {
                0 -> Slide(
                    stringResource(R.string.slide1_slogan),
                    stringResource(R.string.slide1_sub),
                    R.drawable.illu_carousel_1_filme_vends
                )
                1 -> Slide(
                    stringResource(R.string.slide2_title),
                    stringResource(R.string.slide2_sub),
                    R.drawable.illu_carousel_2_tournage_guide
                )
                else -> Slide(
                    stringResource(R.string.slide3_slogan),
                    stringResource(R.string.slide3_sub),
                    R.drawable.illu_carousel_3_video_prete
                )
            }
        }
        Dots(pager.currentPage)
        Button(
            onClick = {
                if (pager.currentPage < 2) {
                    scope.launch { pager.animateScrollToPage(pager.currentPage + 1) }
                } else {
                    onDone()
                }
            },
            modifier = Modifier.fillMaxWidth().padding(24.dp)
        ) {
            Text(
                if (pager.currentPage < 2) {
                    stringResource(R.string.carousel_next)
                } else {
                    stringResource(R.string.carousel_start)
                }
            )
        }
    }
}

/**
 * D42.13 : illustration ORIGINALE par ecran (ressource locale, aucun reseau).
 *
 * `contentDescription = null` : l'image est DECORATIVE — le slogan et le
 * sous-titre portent l'information. Declarer une description redondante
 * ferait lire deux fois la meme chose a TalkBack (WCAG 1.1.1).
 *
 * `weight(1f, fill = false)` + `ContentScale.Fit` : l'image prend la place
 * disponible sans jamais deborder, y compris sur un ecran de 480x800 ou avec
 * une police agrandie a 130 %.
 */
@Composable
private fun Slide(title: String, subtitle: String, illustration: Int) {
    Column(
        modifier = Modifier.fillMaxSize().padding(24.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Image(
            painter = painterResource(illustration),
            contentDescription = null,
            contentScale = ContentScale.Fit,
            modifier = Modifier.fillMaxWidth().weight(1f, fill = false)
        )
        Text(
            title,
            style = MaterialTheme.typography.headlineMedium,
            modifier = Modifier.padding(top = 16.dp)
        )
        Text(
            subtitle,
            style = MaterialTheme.typography.bodyLarge,
            modifier = Modifier.padding(top = 8.dp)
        )
    }
}

@Composable
private fun Dots(current: Int) {
    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
        repeat(3) { index ->
            Box(
                modifier = Modifier
                    .size(10.dp)
                    .clip(CircleShape)
                    .background(if (index == current) OrangeStore else BlancPur)
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun CarouselPreview() {
    VitrineTheme { CarouselScreen { } }
}
