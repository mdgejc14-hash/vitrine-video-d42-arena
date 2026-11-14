package video.vitrine.feature.export

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import video.vitrine.core.designsystem.OrangeStore

/**
 * Panneau de previsualisation export : typographie cinetique du script voix
 * (mot-cle chiffre ou plus long mis en avant, comme au montage) + recapitulatif
 * duree / rushs. Composable pur : capturable sous Robolectric.
 */
@Composable
fun ExportPreviewPanel(
    script: String,
    durationS: Int,
    clientRushCount: Int,
    cameraRushCount: Int,
    modifier: Modifier = Modifier,
) {
    val words = script.split(Regex("\\s+")).filter { it.isNotBlank() }
    val keyword = words.maxByOrNull { w -> w.count { c -> c.isDigit() } * 10 + w.length }
    Column(
        modifier = modifier.fillMaxWidth().padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        Text(stringResource(R.string.export_preview_title), style = MaterialTheme.typography.titleLarge)
        Text(
            stringResource(R.string.export_preview_meta, durationS, clientRushCount, cameraRushCount),
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        Text(
            stringResource(R.string.export_preview_typo),
            style = MaterialTheme.typography.labelLarge,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        words.chunked(4).forEach { line ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
            ) {
                line.forEach { word ->
                    Text(
                        text = word,
                        fontSize = if (word == keyword) 26.sp else 18.sp,
                        fontWeight = if (word == keyword) FontWeight.ExtraBold else FontWeight.Normal,
                        color = if (word == keyword) {
                            OrangeStore
                        } else {
                            MaterialTheme.colorScheme.onSurface
                        },
                        textAlign = TextAlign.Start,
                    )
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun ExportPreviewPanelPreview() {
    video.vitrine.core.designsystem.VitrineTheme {
        ExportPreviewPanel(
            script = "Nouvel arrivage chez Awa Boutique : 3 robes coupees main a moins de 15 000 francs",
            durationS = 30,
            clientRushCount = 4,
            cameraRushCount = 5,
        )
    }
}
