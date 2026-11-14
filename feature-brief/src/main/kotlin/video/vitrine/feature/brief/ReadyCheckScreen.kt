package video.vitrine.feature.brief

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.draw.clip
import video.vitrine.core.designsystem.Blanc
import video.vitrine.core.designsystem.FormeCarte
import video.vitrine.core.designsystem.FormePill
import video.vitrine.core.designsystem.FormeTuile
import video.vitrine.core.designsystem.Muted
import video.vitrine.core.designsystem.Navy
import video.vitrine.core.designsystem.NavySoft
import video.vitrine.core.designsystem.OrangeDeep
import video.vitrine.core.designsystem.ombreSm
import video.vitrine.core.designsystem.BleuVoile

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
    // D42.30 (défaut n°5) : bouton « OK, je commence » ÉPINGLÉ hors du
    // scroll — toujours visible, au-dessus du clavier et de la barre de
    // navigation (même correction que le bouton Continuer du brief).
    Column(
        modifier = modifier
            .fillMaxSize()
            .navigationBarsPadding()
            .imePadding()
    ) {
        Column(
            modifier = Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 20.dp)
                .padding(top = 8.dp, bottom = 12.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            ReadyHeader()
            ReadyVideoCard(sectorLabel, formatLabel, prisesCount, infos)
            ReadyClearCard()
            ReadyConfirmBox()
        }
        video.vitrine.core.designsystem.BoutonPrimaire(
            libelle = stringResource(R.string.e4b_ok),
            onClick = onOk,
            modifier = Modifier
                .fillMaxWidth()
                .padding(start = 20.dp, end = 20.dp, top = 6.dp, bottom = 10.dp),
            testTag = "ready_ok"
        )
    }
}

@Composable
private fun ReadyHeader() {
    // D42.30 (retour terrain : le badge « VÉRIFICATION » se coupait et se
    // superposait aux titres) : largeur mesurée — sur petit écran le badge
    // passe sur sa PROPRE ligne, jamais par-dessus le titre.
    BoxWithConstraints(modifier = Modifier.fillMaxWidth()) {
        val compacte = maxWidth < 340.dp
        if (compacte) {
            Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                Text(
                    stringResource(R.string.e4b_title),
                    style = video.vitrine.core.designsystem.VitrineText.H2,
                    color = Navy
                )
                Text(
                    stringResource(R.string.e4b_sub),
                    style = video.vitrine.core.designsystem.VitrineText.Sub,
                    color = Muted
                )
                BadgeVerification()
            }
        } else {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text(
                        stringResource(R.string.e4b_title),
                        style = video.vitrine.core.designsystem.VitrineText.H2,
                        color = Navy
                    )
                    Text(
                        stringResource(R.string.e4b_sub),
                        style = video.vitrine.core.designsystem.VitrineText.Sub,
                        color = Muted
                    )
                }
                BadgeVerification()
            }
        }
    }
}

@Composable
private fun BadgeVerification() {
    Box(
        modifier = Modifier
            .background(BleuVoile, FormePill)
            .padding(horizontal = 12.dp, vertical = 6.dp)
    ) {
        Text(
            stringResource(R.string.e4b_badge),
            color = Navy,
            style = video.vitrine.core.designsystem.VitrineText.Label
        )
    }
}

@Composable
private fun ReadyVideoCard(sectorLabel: String, formatLabel: String, prisesCount: Int, infos: String) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .androidxTuileCarte()
    ) {
        Column(modifier = Modifier.padding(18.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Text(
                stringResource(R.string.e4b_card),
                color = OrangeDeep,
                style = video.vitrine.core.designsystem.VitrineText.Label
            )
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
            style = video.vitrine.core.designsystem.VitrineText.Sub,
            color = Muted,
            modifier = Modifier.weight(1f)
        )
        Text(
            value,
            style = video.vitrine.core.designsystem.VitrineText.Body.copy(
                fontWeight = androidx.compose.ui.text.font.FontWeight.W600
            ),
            color = Navy,
            modifier = Modifier.weight(1.4f)
        )
    }
}

@Composable
private fun ReadyClearCard() {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .androidxTuileCarte()
    ) {
        Column(modifier = Modifier.padding(18.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Text(
                stringResource(R.string.e4b_clear),
                style = video.vitrine.core.designsystem.VitrineText.H3,
                color = Navy
            )
            Text(
                stringResource(R.string.e4b_clear_body),
                style = video.vitrine.core.designsystem.VitrineText.Sub,
                color = video.vitrine.core.designsystem.NavySoft
            )
            Text(
                stringResource(R.string.e4b_reassure),
                color = OrangeDeep,
                style = video.vitrine.core.designsystem.VitrineText.Sub.copy(
                    fontWeight = androidx.compose.ui.text.font.FontWeight.W600
                )
            )
        }
    }
}

/**
 * D42.30 (retour terrain) : ce bloc ressemblait à une case à cocher ACTIVE
 * alors qu'il n'est pas un contrôle — c'est un bandeau d'information NEUTRE
 * (bord discret, pas de carré rempli façon checkbox, pas de couleur d'action).
 */
@Composable
private fun ReadyConfirmBox() {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .background(BleuVoile, FormeTuile)
            .padding(14.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Text(
            stringResource(R.string.e4b_check),
            style = video.vitrine.core.designsystem.VitrineText.Body,
            color = Navy,
            modifier = Modifier.weight(1f)
        )
    }
}

/** D42.33 : tuile blanche rayon 22 + ombre douce (§7 cartes). */
private fun Modifier.androidxTuileCarte(): Modifier = this
    .clip(FormeCarte)
    .background(Blanc)
    .ombreSm(FormeCarte)
