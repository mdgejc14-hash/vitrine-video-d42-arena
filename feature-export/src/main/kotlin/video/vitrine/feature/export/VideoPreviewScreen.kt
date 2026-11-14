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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.BleuVoile
import androidx.compose.ui.draw.clip
import video.vitrine.core.designsystem.FormeCarte
import video.vitrine.core.designsystem.FormePill
import video.vitrine.core.designsystem.ombreSm

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
            .padding(horizontal = 20.dp)
            .padding(top = 12.dp, bottom = 20.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        PreviewHeader(sectorLabel, formatLabel)
        PreviewThumb(previewTexts)
        PreviewCheckCard(checkRows, values)
        Text(
            stringResource(R.string.e7_footnote),
            style = video.vitrine.core.designsystem.VitrineText.Tiny,
            color = video.vitrine.core.designsystem.Muted
        )
        // D42 : testTag stable pour le robot UI — porté par BoutonPrimaire.
        video.vitrine.core.designsystem.BoutonPrimaire(
            libelle = stringResource(R.string.e7_create),
            onClick = onCreate,
            modifier = Modifier.fillMaxWidth().testTag("preview_create")
        )
    }
}

@Composable
private fun PreviewHeader(sectorLabel: String, formatLabel: String) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                stringResource(R.string.e7_title),
                style = video.vitrine.core.designsystem.VitrineText.H2,
                color = video.vitrine.core.designsystem.Navy
            )
            Text(
                sectorLabel + " · " + formatLabel,
                style = video.vitrine.core.designsystem.VitrineText.Sub,
                color = video.vitrine.core.designsystem.Muted
            )
        }
        Box(
            modifier = Modifier
                .background(BleuVoile, FormePill)
                .padding(horizontal = 12.dp, vertical = 6.dp)
        ) {
            Text(
                stringResource(R.string.e7_badge),
                color = video.vitrine.core.designsystem.Navy,
                style = video.vitrine.core.designsystem.VitrineText.Label
            )
        }
    }
}

/**
 * Vignette d'aperçu 9:16 (§8-D) : fond navy, texte du gabarit en bannière
 * basse — HONNÊTE : plus de glyph « ▶ » non cliquable (interdiction de faux
 * bouton lecture) ; le badge « APERÇU » du header signale l'état.
 */
@Composable
private fun PreviewThumb(previewTexts: List<String>) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .aspectRatio(9f / 16f)
            .background(video.vitrine.core.designsystem.Navy, RoundedCornerShape(26.dp))
    ) {
        if (previewTexts.isNotEmpty()) {
            Column(
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .fillMaxWidth()
                    .padding(12.dp)
                    .background(Color(0xCC022358), RoundedCornerShape(14.dp))
                    .padding(12.dp),
                verticalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                previewTexts.take(3).forEach { line ->
                    Text(
                        line,
                        color = Color.White,
                        style = video.vitrine.core.designsystem.VitrineText.Sub,
                        textAlign = TextAlign.Start
                    )
                }
            }
        }
    }
}

@Composable
private fun PreviewCheckCard(checkRows: List<Pair<String, String>>, values: Map<String, String>) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(FormeCarte)
            .background(video.vitrine.core.designsystem.Blanc)
            .ombreSm(FormeCarte)
    ) {
        Column(modifier = Modifier.padding(18.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Text(
                stringResource(R.string.e7_check),
                style = video.vitrine.core.designsystem.VitrineText.H3,
                color = video.vitrine.core.designsystem.Navy
            )
            checkRows.forEach { (id, label) ->
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(
                        label,
                        style = video.vitrine.core.designsystem.VitrineText.Sub,
                        color = video.vitrine.core.designsystem.Muted,
                        modifier = Modifier.weight(1f)
                    )
                    Text(
                        values[id].orEmpty(),
                        style = video.vitrine.core.designsystem.VitrineText.Body.copy(
                            fontWeight = androidx.compose.ui.text.font.FontWeight.W600
                        ),
                        color = video.vitrine.core.designsystem.Navy,
                        modifier = Modifier.weight(1f)
                    )
                }
            }
        }
    }
}
