package video.vitrine.feature.export

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.BleuNuit
import video.vitrine.core.designsystem.BleuVoile
import video.vitrine.core.designsystem.GrisLiserai
import video.vitrine.core.designsystem.OrangeStore

/**
 * Ecran E7 (maquette E7_batiment_travaux_T1_Editeur) : apercu avant generation.
 * Vignette 9:16 avec banniere sous-titres (cartes texte du gabarit), recapitulatif
 * du brief a verifier, puis bouton unique "Creer ma video" vers E8.
 */
@Composable
fun VideoPreviewScreen(
    sectorLabel: String,
    formatLabel: String,
    previewTexts: List<String>,
    checkRows: List<Pair<String, String>>,
    values: Map<String, String>,
    onCreate: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        PreviewHeader(sectorLabel, formatLabel)
        PreviewThumb(previewTexts)
        PreviewCheckCard(checkRows, values)
        Text(
            stringResource(R.string.e7_footnote),
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        // D42 : testTag stable pour le robot UI (aucun changement visuel).
        Button(
            onClick = onCreate,
            modifier = Modifier.fillMaxWidth().testTag("preview_create")
        ) {
            Text(stringResource(R.string.e7_create), modifier = Modifier.padding(vertical = 6.dp))
        }
    }
}

@Composable
private fun PreviewHeader(sectorLabel: String, formatLabel: String) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column {
            Text(stringResource(R.string.e7_title), style = MaterialTheme.typography.headlineSmall)
            Text(
                sectorLabel + " · " + formatLabel,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
        Box(
            modifier = Modifier
                .background(BleuVoile, RoundedCornerShape(8.dp))
                .padding(horizontal = 12.dp, vertical = 6.dp)
        ) { Text(stringResource(R.string.e7_badge), color = BleuNuit, style = MaterialTheme.typography.titleSmall) }
    }
}

@Composable
private fun PreviewThumb(previewTexts: List<String>) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .aspectRatio(9f / 16f)
            .background(GrisLiserai, RoundedCornerShape(12.dp))
    ) {
        Box(
            modifier = Modifier
                .align(Alignment.Center)
                .size(64.dp)
                .background(BleuNuit, CircleShape),
            contentAlignment = Alignment.Center
        ) {
            Text("▶", color = Color.White, style = MaterialTheme.typography.headlineMedium)
        }
        if (previewTexts.isNotEmpty()) {
            Column(
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .padding(12.dp)
                    .background(BleuNuit, RoundedCornerShape(10.dp))
                    .padding(12.dp)
            ) {
                previewTexts.take(3).forEach { line ->
                    Text(
                        line,
                        color = Color.White,
                        style = MaterialTheme.typography.titleSmall,
                        textAlign = TextAlign.Start
                    )
                }
            }
        }
    }
}

@Composable
private fun PreviewCheckCard(checkRows: List<Pair<String, String>>, values: Map<String, String>) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Text(stringResource(R.string.e7_check), style = MaterialTheme.typography.titleLarge, color = BleuNuit)
            checkRows.forEach { (id, label) ->
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(
                        label,
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.weight(1f)
                    )
                    Text(
                        values[id].orEmpty(),
                        style = MaterialTheme.typography.titleSmall,
                        color = BleuNuit,
                        modifier = Modifier.weight(1f)
                    )
                }
            }
        }
    }
}
