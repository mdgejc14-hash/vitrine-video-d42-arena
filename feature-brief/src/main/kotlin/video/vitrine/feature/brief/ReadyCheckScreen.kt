package video.vitrine.feature.brief

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.BleuNuit
import video.vitrine.core.designsystem.BleuVoile
import video.vitrine.core.designsystem.OrangeStore

/**
 * Ecran E4b (maquette E4b_Ready) : recapitulatif avant tournage.
 * Carte "Ta video" (format, metier, prises, infos), carte reassurance
 * "Tout est clair ?", case de confirmation et bouton "OK, je commence".
 */
@Composable
fun ReadyCheckScreen(
    sectorLabel: String,
    formatLabel: String,
    prisesCount: Int,
    infos: String,
    onOk: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        ReadyHeader()
        ReadyVideoCard(sectorLabel, formatLabel, prisesCount, infos)
        ReadyClearCard()
        ReadyConfirmBox()
        Button(onClick = onOk, modifier = Modifier.fillMaxWidth()) {
            Text(stringResource(R.string.e4b_ok), modifier = Modifier.padding(vertical = 6.dp))
        }
    }
}

@Composable
private fun ReadyHeader() {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column {
            Text(stringResource(R.string.e4b_title), style = MaterialTheme.typography.headlineSmall)
            Text(
                stringResource(R.string.e4b_sub),
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
        Box(
            modifier = Modifier
                .background(BleuVoile, RoundedCornerShape(8.dp))
                .padding(horizontal = 12.dp, vertical = 6.dp)
        ) {
            Text(stringResource(R.string.e4b_badge), color = BleuNuit, style = MaterialTheme.typography.titleSmall)
        }
    }
}

@Composable
private fun ReadyVideoCard(sectorLabel: String, formatLabel: String, prisesCount: Int, infos: String) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Text(stringResource(R.string.e4b_card), color = OrangeStore, style = MaterialTheme.typography.labelLarge)
            ReadyRow(stringResource(R.string.e4b_format), formatLabel)
            ReadyRow(stringResource(R.string.e4b_job), sectorLabel)
            ReadyRow(stringResource(R.string.e4b_shots), stringResource(R.string.e4b_shots_value, prisesCount))
            ReadyRow(stringResource(R.string.e4b_infos), infos)
        }
    }
}

@Composable
private fun ReadyRow(label: String, value: String) {
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
        Text(value, style = MaterialTheme.typography.titleSmall, color = BleuNuit, modifier = Modifier.weight(1.4f))
    }
}

@Composable
private fun ReadyClearCard() {
    Card(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Text(stringResource(R.string.e4b_clear), style = MaterialTheme.typography.titleLarge, color = BleuNuit)
            Text(stringResource(R.string.e4b_clear_body), style = MaterialTheme.typography.bodyMedium)
            Text(
                stringResource(R.string.e4b_reassure),
                color = OrangeStore,
                style = MaterialTheme.typography.titleSmall
            )
        }
    }
}

@Composable
private fun ReadyConfirmBox() {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .border(1.dp, OrangeStore, RoundedCornerShape(10.dp))
            .padding(12.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Box(
            modifier = Modifier
                .size(24.dp)
                .background(OrangeStore, RoundedCornerShape(6.dp)),
            contentAlignment = Alignment.Center
        ) { Text("✓", color = androidx.compose.ui.graphics.Color.White) }
        Text(stringResource(R.string.e4b_check), style = MaterialTheme.typography.titleSmall, color = BleuNuit)
    }
}
