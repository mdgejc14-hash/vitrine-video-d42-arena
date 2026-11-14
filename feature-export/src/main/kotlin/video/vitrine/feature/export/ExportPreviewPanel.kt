package video.vitrine.feature.export

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

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
        modifier = modifier.fillMaxWidth().padding(horizontal = 20.dp, vertical = 4.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        Text(
            stringResource(R.string.export_preview_title),
            style = video.vitrine.core.designsystem.VitrineText.H3,
            color = video.vitrine.core.designsystem.Navy
        )
        Text(
            stringResource(R.string.export_preview_meta, durationS, clientRushCount, cameraRushCount),
            style = video.vitrine.core.designsystem.VitrineText.Tiny,
            color = video.vitrine.core.designsystem.Muted,
        )
        Text(
            stringResource(R.string.export_preview_typo),
            style = video.vitrine.core.designsystem.VitrineText.Label,
            color = video.vitrine.core.designsystem.Muted,
        )
        words.chunked(4).forEach { line ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
            ) {
                line.forEach { word ->
                    Text(
                        text = word,
                        style = if (word == keyword) {
                            // D42.33 : chiffre/mot-clé en Jakarta ExtraBold
                            // OrangeDeep (AA sur fond clair §3).
                            androidx.compose.ui.text.TextStyle(
                                fontFamily = video.vitrine.core.designsystem.Jakarta,
                                fontSize = 26.sp,
                                fontWeight = FontWeight.ExtraBold,
                                color = video.vitrine.core.designsystem.OrangeDeep,
                            )
                        } else {
                            androidx.compose.ui.text.TextStyle(
                                fontFamily = video.vitrine.core.designsystem.Inter,
                                fontSize = 17.sp,
                                color = video.vitrine.core.designsystem.Navy,
                            )
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
