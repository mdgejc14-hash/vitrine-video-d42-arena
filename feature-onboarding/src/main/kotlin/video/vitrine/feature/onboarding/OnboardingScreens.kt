package video.vitrine.feature.onboarding

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.foundation.Image
import androidx.compose.ui.Alignment
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.TextButton
import androidx.compose.ui.res.painterResource
import video.vitrine.core.designsystem.BleuNuit
import video.vitrine.core.designsystem.OrangeVoile
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.SectorCard3D
import video.vitrine.core.designsystem.VitrineLogoHeader
import video.vitrine.core.designsystem.VitrineTheme
import video.vitrine.core.designsystem.sectorIcon
import video.vitrine.core.designsystem.sectorIllustration
import video.vitrine.core.designsystem.sectorLabel
import video.vitrine.core.model.Sector

/** Ecran secteurs : libelles terre-a-terre, un choix pre-selectionne, jamais bloquant. */
@Composable
fun OnboardingScreen(onDone: (Sector) -> Unit) {
    var selected by remember { mutableStateOf(Sector.MODE) }
    Column(
        modifier = Modifier.fillMaxWidth().padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        VitrineLogoHeader()
        Text(stringResource(R.string.sector_title), style = MaterialTheme.typography.headlineSmall)
        Text(stringResource(R.string.sector_hint))
        val sectors = Sector.entries.filter { it != Sector.TOUS }
        sectors.chunked(2).forEach { row ->
            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                row.forEach { sector ->
                    SectorCard3D(
                        label = sectorLabel(sector),
                        icon = sectorIcon(sector.code),
                        selected = selected == sector,
                        onClick = { selected = sector },
                        illustrationRes = sectorIllustration(sector.code),
                        modifier = Modifier.weight(1f)
                    )
                }
            }
        }
        Button(onClick = { onDone(selected) }, modifier = Modifier.fillMaxWidth()) {
            Text(stringResource(R.string.action_continue))
        }
    }
}

/** Ecran accueil : generosite d'accueil verrouillee par empreinte appareil. */
@Composable
fun WelcomeScreen(state: WelcomeRepository.GrantState?, onContinue: () -> Unit) {
    Column(
        modifier = Modifier.fillMaxWidth().padding(24.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(stringResource(R.string.welcome_title), style = MaterialTheme.typography.headlineSmall)
        Text(
            stringResource(
                R.string.welcome_credits,
                state?.creditsTotal ?: 0
            )
        )
        Button(onClick = onContinue, modifier = Modifier.fillMaxWidth()) {
            Text(stringResource(R.string.action_continue))
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun SectorPreview() {
    VitrineTheme { OnboardingScreen { } }
}

/**
 * Ecran E3b (maquette E3b_Code_Parrain) : code parrain FACULTATIF,
 * badge etape 2/3, recap secteur illustre, lien pour passer sans code.
 * Jamais bloquant (D19) : onDone(null) = parcours normal.
 */
@Composable
fun ReferralCodeScreen(
    sector: Sector,
    onDone: (String?) -> Unit
) {
    var code by remember { mutableStateOf("") }
    var invalid by remember { mutableStateOf(false) }
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(stringResource(R.string.refcode_title), style = MaterialTheme.typography.headlineSmall)
                Text(
                    stringResource(R.string.refcode_subtitle),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            Box(
                modifier = Modifier
                    .background(OrangeVoile, RoundedCornerShape(8.dp))
                    .padding(horizontal = 12.dp, vertical = 6.dp)
            ) {
                Text("2 / 3", color = BleuNuit, style = MaterialTheme.typography.titleSmall)
            }
        }
        SecteurChoisiCard(sector)
        Text(stringResource(R.string.refcode_label), style = MaterialTheme.typography.titleSmall, color = BleuNuit)
        OutlinedTextField(
            value = code,
            onValueChange = { code = it; invalid = false },
            placeholder = { Text(stringResource(R.string.refcode_hint)) },
            modifier = Modifier.fillMaxWidth(),
            isError = invalid,
            singleLine = true
        )
        // D41 : format du code verifie cote client (MOTIF-123) — avant, un code
        // mal saisi partait au serveur et echouait EN SILENCE (l'utilisateur
        // croyait son parrain enregistre).
        if (invalid) {
            Text(
                stringResource(R.string.refcode_invalid),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.error
            )
        }
        Button(
            onClick = {
                val normalise = video.vitrine.feature.onboarding.auth.RefCodeParser.fromManualEntry(code)
                if (code.isNotBlank() && normalise == null) {
                    invalid = true
                } else {
                    onDone(normalise)
                }
            },
            modifier = Modifier.fillMaxWidth()
        ) { Text(stringResource(R.string.refcode_continue)) }
        TextButton(onClick = { onDone(null) }) { Text(stringResource(R.string.refcode_skip)) }
    }
}

/** D41 (detekt LongMethod) : carte recap du secteur choisi, extraite de ReferralCodeScreen. */
@Composable
private fun SecteurChoisiCard(sector: Sector) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(14.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            sectorIllustration(sector.code)?.let { res ->
                Image(
                    painter = painterResource(res),
                    contentDescription = sectorLabel(sector),
                    modifier = Modifier.size(56.dp)
                )
            }
            Column {
                Text(
                    stringResource(R.string.refcode_chosen),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Text(sectorLabel(sector), style = MaterialTheme.typography.titleMedium, color = BleuNuit)
            }
        }
    }
}
