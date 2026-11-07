package video.vitrine.feature.camera

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.border
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
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.BleuNuit
import video.vitrine.core.designsystem.BleuVoile
import video.vitrine.core.designsystem.GrisLiserai
import video.vitrine.core.designsystem.OrangeStore
import video.vitrine.core.designsystem.OrangeVoile
import video.vitrine.core.model.PriseGuide

/**
 * Ecran E6 (maquettes E6_*_prise_*) : guide de prise niveau PRISE (et non scene),
 * pilote par le gabarit JSON. La zone visee est transparente : le flux CameraX
 * du layout sous-jacent reste visible derriere badges et grille (appareil reel).
 */
@Composable
fun PriseGuideScreen(
    prises: List<PriseGuide>,
    priseIdx: Int,
    sectorLabel: String,
    formatLabel: String,
    onRedo: () -> Unit,
    onRecord: () -> Unit,
    onNext: () -> Unit,
    modifier: Modifier = Modifier
) {
    val prise = prises.getOrNull(priseIdx) ?: return
    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            // D42.16 (A5, run 42292290440) : la barre d'action classique (bouton
            // « Verrouiller et enregistrer » + texte de guide) recouvre le bas de
            // cette colonne défilante — « Refaire / Tourner / Suivant » restaient
            // sous le pli, derrière la barre, inaccessibles au doigt comme au
            // harnais (tap au centre de bornes hors écran = code 0 trompeur).
            // Réserve de défilement de 180 dp : les commandes remontent au-dessus
            // de la barre sur écran standard, petit écran et paysage. Aucun bouton
            // supprimé : le cercle « Tourner » et le bouton classique partagent
            // le même onRecord() gardé contre la double capture.
            .padding(start = 16.dp, end = 16.dp, top = 16.dp, bottom = 180.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        PriseHeader(prise, priseIdx, prises.size, sectorLabel, formatLabel)
        PriseViewfinder()
        PriseInstructionCard(prise)
        if (prise.segments.isNotEmpty()) PriseParoleCard(prise)
        PriseControls(onRedo, onRecord, onNext)
    }
}

@Composable
private fun PriseHeader(
    prise: PriseGuide,
    priseIdx: Int,
    total: Int,
    sectorLabel: String,
    formatLabel: String
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column {
            Text(stringResource(R.string.e6_title), style = MaterialTheme.typography.headlineSmall)
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
        ) {
            Text(
                "PRISE ${priseIdx + 1}/$total",
                color = BleuNuit,
                style = MaterialTheme.typography.titleSmall
            )
        }
    }
    Text(prise.label, style = MaterialTheme.typography.titleLarge, color = BleuNuit)
    Text(
        stringResource(R.string.e6_about, prise.targetS),
        style = MaterialTheme.typography.bodyMedium,
        color = MaterialTheme.colorScheme.onSurfaceVariant
    )
}

@Composable
private fun PriseViewfinder() {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .aspectRatio(9f / 16f)
            .border(1.dp, GrisLiserai, RoundedCornerShape(12.dp))
    ) {
        Box(
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(8.dp)
                .background(BleuNuit, RoundedCornerShape(8.dp))
                .padding(horizontal = 10.dp, vertical = 6.dp)
        ) { Text("9:16 · HD", color = Color.White, style = MaterialTheme.typography.labelSmall) }
        Box(
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(8.dp)
                .background(Color.White, RoundedCornerShape(8.dp))
                .padding(horizontal = 10.dp, vertical = 6.dp)
        ) { Text(stringResource(R.string.e6_countdown), color = BleuNuit, style = MaterialTheme.typography.labelSmall) }
        Box(
            modifier = Modifier
                .align(Alignment.Center)
                .size(72.dp)
                .background(BleuNuit, CircleShape)
                .border(3.dp, Color.White, CircleShape),
            contentAlignment = Alignment.Center
        ) { Text("3", color = Color.White, style = MaterialTheme.typography.headlineMedium) }
    }
}

@Composable
private fun PriseInstructionCard(prise: PriseGuide) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
            Text(stringResource(R.string.e6_to_film), color = OrangeStore, style = MaterialTheme.typography.labelLarge)
            Text(prise.cameraInstruction, style = MaterialTheme.typography.bodyMedium)
        }
    }
}

@Composable
private fun PriseParoleCard(prise: PriseGuide) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Box(
                modifier = Modifier
                    .background(BleuVoile, RoundedCornerShape(8.dp))
                    .padding(horizontal = 12.dp, vertical = 6.dp)
            ) {
                Text(
                    "PAROLE 1/${prise.segments.size}",
                    color = BleuNuit,
                    style = MaterialTheme.typography.labelLarge
                )
            }
            prise.segments.forEach { seg ->
                Text(stringResource(R.string.e6_show), color = OrangeStore, style = MaterialTheme.typography.labelLarge)
                Text(seg.show, style = MaterialTheme.typography.bodyMedium)
                Text(
                    stringResource(R.string.e6_tell),
                    color = OrangeStore,
                    style = MaterialTheme.typography.labelLarge
                )
                Text(seg.tell, style = MaterialTheme.typography.bodyMedium)
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(OrangeVoile, RoundedCornerShape(8.dp))
                        .padding(12.dp)
                ) {
                    Column {
                        Text(
                            stringResource(R.string.e6_example),
                            color = OrangeStore,
                            style = MaterialTheme.typography.labelSmall
                        )
                        Text("« " + seg.example + " »", color = BleuNuit, style = MaterialTheme.typography.titleSmall)
                    }
                }
                Box(
                    modifier = Modifier
                        .align(Alignment.End)
                        .background(BleuVoile, RoundedCornerShape(8.dp))
                        .padding(horizontal = 12.dp, vertical = 6.dp)
                ) {
                    Text(
                        "≈ " + seg.advisedS.toString().replace(".", ",") + " s",
                        color = BleuNuit,
                        style = MaterialTheme.typography.titleSmall
                    )
                }
            }
            Text(
                stringResource(R.string.e6_time_hint),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Composable
private fun PriseControls(onRedo: () -> Unit, onRecord: () -> Unit, onNext: () -> Unit) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        OutlinedButton(onClick = onRedo, modifier = Modifier.weight(1f)) { Text(stringResource(R.string.e6_redo)) }
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(stringResource(R.string.e6_record), color = OrangeStore, style = MaterialTheme.typography.labelLarge)
            Box(
                modifier = Modifier
                    .size(72.dp)
                    .clickable(onClick = onRecord)
                    .border(4.dp, OrangeStore, CircleShape)
                    .padding(8.dp)
                    .background(OrangeStore, CircleShape)
            )
        }
        Button(onClick = onNext, modifier = Modifier.weight(1f)) { Text(stringResource(R.string.e6_next)) }
    }
}
