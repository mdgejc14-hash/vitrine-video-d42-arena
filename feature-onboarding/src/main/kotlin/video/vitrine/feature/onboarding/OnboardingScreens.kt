package video.vitrine.feature.onboarding

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Surface
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.foundation.Image
import androidx.compose.ui.Alignment
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.heightIn
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

/**
 * Ecran secteurs : libelles terre-a-terre, un choix pre-selectionne, jamais bloquant.
 *
 * D42.12 — DEFAUT P1 CORRIGE : « bouton Continuer invisible ».
 *
 * Mesure du defaut : chaque carte contient une illustration carree
 * (`aspectRatio(1f)`) ; sur un ecran de 360 dp de large, une carte mesure ~188 dp.
 * Trois rangees + en-tete + titres + bouton = ~800 dp de contenu. Or la colonne
 * n'avait NI hauteur contrainte NI defilement : sur un telephone de ~600 dp
 * utiles (courant en Afrique de l'Ouest), le bouton etait rendu SOUS la zone
 * visible et devenait inatteignable — l'ecran etait une impasse.
 *
 * Correction (patron Android standard « action bar fixe ») :
 *  - la grille defile dans une zone `weight(1f)` + `verticalScroll` ;
 *  - le bouton est EPINGLE hors de la zone de defilement : il est visible en
 *    permanence, quelle que soit la taille d'ecran et la taille de police ;
 *  - insets systeme respectes (barre de navigation gestuelle incluse).
 *
 * Theorie Nielsen : #1 visibilite de l'etat (etape « 1 / 3 »), #4 coherence
 * (meme barre d'action partout), #5 prevention d'erreur (choix pre-selectionne,
 * aucun etat vide possible), #7 efficacite (pas besoin de defiler pour agir).
 */
@Composable
fun OnboardingScreen(onDone: (Sector) -> Unit) {
    // D42.12 : rememberSaveable — un changement de configuration ne perd plus
    // la selection. (Sector est un enum : Serializable, donc stockable.)
    var selected by rememberSaveable { mutableStateOf(Sector.MODE) }
    val secteurs = Sector.entries.filter { it != Sector.TOUS }
    Column(
        modifier = Modifier
            .fillMaxSize()
            .windowInsetsPadding(WindowInsets.safeDrawing)
    ) {
        // ---- zone defilante : elle ne peut jamais pousser le bouton dehors ----
        Column(
            modifier = Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp)
                .padding(top = 8.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                VitrineLogoHeader()
                EtapeBadge(etape = 1, total = 3)
            }
            Text(
                stringResource(R.string.sector_title),
                style = MaterialTheme.typography.headlineSmall
            )
            Text(
                stringResource(R.string.sector_hint),
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            secteurs.chunked(2).forEach { ligne ->
                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    ligne.forEach { secteur ->
                        SectorCard3D(
                            label = sectorLabel(secteur),
                            icon = sectorIcon(secteur.code),
                            selected = selected == secteur,
                            onClick = { selected = secteur },
                            illustrationRes = sectorIllustration(secteur.code),
                            modifier = Modifier.weight(1f)
                        )
                    }
                    // garde la derniere carte a la largeur des autres (ligne impaire)
                    if (ligne.size == 1) Box(modifier = Modifier.weight(1f))
                }
            }
            // marge de respiration : le dernier rang ne colle pas a la barre d'action
            Box(modifier = Modifier.padding(bottom = 4.dp))
        }

        // ---- barre d'action EPINGLEE : toujours visible ----
        Surface(
            tonalElevation = 3.dp,
            color = MaterialTheme.colorScheme.surface
        ) {
            Button(
                onClick = { onDone(selected) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 12.dp)
                    // plancher tactile WCAG 2.2 / Material : 48 dp minimum
                    .heightIn(min = 48.dp)
            ) {
                Text(stringResource(R.string.action_continue))
            }
        }
    }
}

/** Indicateur de progression : le client sait ou il en est (Nielsen #1). */
@Composable
private fun EtapeBadge(etape: Int, total: Int) {
    Box(
        modifier = Modifier
            .background(OrangeVoile, RoundedCornerShape(8.dp))
            .padding(horizontal = 10.dp, vertical = 4.dp)
    ) {
        Text(
            "$etape / $total",
            color = BleuNuit,
            style = MaterialTheme.typography.labelMedium
        )
    }
}

/**
 * Ecran accueil : generosite d'accueil verrouillee par empreinte appareil.
 *
 * D42.9 : trois etats explicites. Auparavant, un `GrantState` nul — serveur pas
 * encore repondu, ou en echec — s'affichait « Nous vous offrons 0 credits ».
 * Le client lisait donc un solde FAUX, sans savoir s'il devait attendre. Il est
 * toujours possible de continuer : l'absence de reponse serveur ne bloque pas
 * l'acces a l'application, et les credits sont credites des le retour du reseau.
 */
@Composable
fun WelcomeScreen(
    credits: Int,
    enAttente: Boolean,
    echec: Boolean,
    onContinue: () -> Unit,
) {
    Column(
        modifier = Modifier.fillMaxWidth().padding(24.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(stringResource(R.string.welcome_title), style = MaterialTheme.typography.headlineSmall)
        when {
            enAttente -> {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    CircularProgressIndicator(modifier = Modifier.size(20.dp))
                    Text(stringResource(R.string.welcome_credits_pending))
                }
            }
            echec || credits <= 0 -> Text(stringResource(R.string.welcome_error))
            else -> Text(stringResource(R.string.welcome_credits, credits))
        }
        // Jamais bloquant : le client entre dans l'application dans tous les cas.
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
