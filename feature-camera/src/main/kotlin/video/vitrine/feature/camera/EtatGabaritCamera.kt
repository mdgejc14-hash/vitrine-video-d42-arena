package video.vitrine.feature.camera

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.BandeauEtat
import video.vitrine.core.designsystem.BoutonSecondaire
import video.vitrine.core.designsystem.NiveauBandeau
import video.vitrine.core.designsystem.Navy
import video.vitrine.core.designsystem.VitrineText

/**
 * D42.34 (CR-3, P0 ③) : états EXPLICITES du mode gabarit — le parcours
 * générique « Scène par scène » n'existe plus en mode gabarit.
 *
 * - [EcranChargementGabarit] : chargement asynchrone du JSON (honnête,
 *   aucun faux guide, aucun compteur inventé).
 * - [ErreurGabaritScreen] : JSON impossible ou gabarit sans prises —
 *   erreur RÉCUPÉRABLE : retour au brief/catalogue proposé (jamais de
 *   caméra guidée sans prises, ordre P0 ③).
 */
@Composable
fun EcranChargementGabarit(modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .background(Navy)
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(
            8.dp,
            androidx.compose.ui.Alignment.CenterVertically,
        ),
    ) {
        Text(
            stringResource(R.string.camera_gabarit_chargement),
            style = VitrineText.H3,
            color = androidx.compose.ui.graphics.Color.White,
        )
    }
}

@Composable
fun ErreurGabaritScreen(onRetour: () -> Unit, modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .background(Navy)
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(
            12.dp,
            androidx.compose.ui.Alignment.CenterVertically,
        ),
    ) {
        BandeauEtat(
            titre = stringResource(R.string.camera_gabarit_erreur_titre),
            texte = stringResource(R.string.camera_gabarit_erreur_texte),
            icone = video.vitrine.core.designsystem.R.drawable.ic_warning,
            action = null,
            surAction = null,
            modifier = Modifier.fillMaxWidth(),
            niveau = NiveauBandeau.ErreurDouce,
        )
        BoutonSecondaire(
            libelle = stringResource(R.string.camera_gabarit_erreur_retour),
            onClick = onRetour,
            testTag = "camera_gabarit_retour",
        )
    }
}
