package video.vitrine.feature.onboarding

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
                    stringResource(R.string.slide1_sub)
                )
                1 -> Slide(
                    stringResource(R.string.slide2_title),
                    stringResource(R.string.slide2_sub)
                )
                else -> Slide(
                    stringResource(R.string.slide3_slogan),
                    stringResource(R.string.slide3_sub)
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

@Composable
private fun Slide(title: String, subtitle: String) {
    Column(
        modifier = Modifier.fillMaxSize().padding(32.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(title, style = MaterialTheme.typography.headlineMedium)
        Text(
            subtitle,
            style = MaterialTheme.typography.bodyLarge,
            modifier = Modifier.padding(top = 16.dp)
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
