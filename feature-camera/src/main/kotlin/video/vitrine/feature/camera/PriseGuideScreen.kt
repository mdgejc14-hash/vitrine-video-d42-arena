package video.vitrine.feature.camera

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxScope
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.blur
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import video.vitrine.core.model.PriseGuide

/**
 * D42.30 — HUD de tournage niveau PRISE, reconçu d'après le retour terrain RC14.
 *
 * AVANT (défauts constatés sur téléphone réel) : PriseViewfinder() était une
 * MAQUETTE — cadre + silhouette + cercle « 3 » statique présentés comme un
 * viseur (noir derrière, le PreviewView n'étant jamais branché) — et les
 * commandes Compose (Refaire/Tourner/Suivant) dupliquaient la barre XML.
 *
 * APRÈS : le HUD est purement INFORMATIF et TRANSPARENT — la vraie prévisuali-
 * sation CameraX (PreviewView du layout) est visible derrière. Il porte :
 *  - le compteur PRISE X/Y (cohérent avec le gabarit réellement sélectionné) ;
 *  - l'état RÉEL du flux (STREAMING = « Caméra prête », sinon « Démarrage… ») ;
 *  - le compte à rebours 3-2-1 VÉRITABLE (le recorder démarre après lui) ;
 *  - le badge REC quand le recorder est actif ;
 *  - l'instruction de cadrage + la prise de parole (repliable) ;
 *  - la confirmation « ✓ Prise N enregistrée » après Finalize réussi.
 * AUCUNE commande ici : la rangée Refaire/Enregistrer/Suivant vit dans la
 * barre XML unique (ids stables pour le harnais E2E).
 */
@Composable
fun PriseGuideScreen(
    prises: List<PriseGuide>,
    priseIdx: Int,
    sectorLabel: String,
    formatLabel: String,
    streaming: Boolean?,
    recording: Boolean,
    countdown: Int?,
    priseValidee: Int?,
    modifier: Modifier = Modifier,
) {
    val prise = prises.getOrNull(priseIdx) ?: return
    Box(modifier = modifier.fillMaxSize()) {
        // D42.33 §7.15 : viseur du design system (coins blancs 2 dp 70 %,
        // rayon 18, grille des tiers 30 %) borné à la zone utile au-dessus
        // de la barre de commandes — le flux CameraX reste visible dessous.
        video.vitrine.core.designsystem.OverlayViseur(
            fractionCadre = 0.82f,
            modifier = Modifier
                .fillMaxSize()
                .padding(top = 96.dp, bottom = 200.dp)
        )
        PriseTopHud(priseIdx, prises.size, sectorLabel, formatLabel, streaming)
        if (recording) BadgeRec()
        // D42.33 (mission §7.7) : plus AUCUN label technique « visages
        // détectés / porte R4 » — la porte de consentement R4 reste ce
        // qu'elle était (dialogue réel, moteur inchangé), le badge
        // d'information technique est retiré de l'interface.
        PriseInstructionBottom(prise, bottomPadding = 196.dp)
        if (countdown != null) CompteARebours(countdown)
        if (priseValidee != null) ConfirmationPrise(priseValidee)
    }
}

@Composable
private fun BoxScope.PriseTopHud(
    priseIdx: Int,
    total: Int,
    sectorLabel: String,
    formatLabel: String,
    streaming: Boolean?,
) {
    Column(
        modifier = Modifier
            .align(Alignment.TopCenter)
            .fillMaxWidth()
            // D42.33 §7.15 : bandeaux caméra = navy translucide (plus de noir).
            .background(Color(0x8C022358))
            .padding(horizontal = 20.dp, vertical = 10.dp),
        verticalArrangement = Arrangement.spacedBy(4.dp),
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            // D42.30 : titre en nœud SÉPARÉ « Filme ta prise » (le harnais
            // camerap attend ce libellé EXACT après « OK, je commence ») ;
            // le badge de prise et l'état du flux sont leurs propres nœuds.
            Text(
                stringResource(R.string.e6_title),
                color = Color.White,
                style = video.vitrine.core.designsystem.VitrineText.H3,
            )
            Text(
                "PRISE ${priseIdx + 1}/$total",
                color = Color.White,
                style = video.vitrine.core.designsystem.VitrineText.Label,
                modifier = Modifier
                    .background(Color(0x33FFFFFF), RoundedCornerShape(50))
                    .padding(horizontal = 8.dp, vertical = 3.dp),
            )
            Spacer(Modifier.weight(1f))
            EtatFlux(streaming)
        }
        if (sectorLabel.isNotBlank() || formatLabel.isNotBlank()) {
            Text(
                listOf(sectorLabel, formatLabel).filter { it.isNotBlank() }.joinToString(" · "),
                color = video.vitrine.core.designsystem.Blanc80,
                style = video.vitrine.core.designsystem.VitrineText.Tiny,
            )
        }
    }
}

/** Chip d'état du flux : « Caméra prête » (STREAMING) vs « Démarrage… » (IDLE). */
@Composable
private fun EtatFlux(streaming: Boolean?) {
    val (libelle, fond) = when (streaming) {
        true -> stringResource(R.string.camera_stream_ready) to video.vitrine.core.designsystem.VertSucces
        else -> stringResource(R.string.camera_stream_starting) to video.vitrine.core.designsystem.AmbreAlerte
    }
    Box(
        modifier = Modifier
            .background(fond, RoundedCornerShape(50))
            .padding(horizontal = 10.dp, vertical = 4.dp)
    ) {
        Text(
            libelle,
            color = Color.White,
            style = video.vitrine.core.designsystem.VitrineText.Label
        )
    }
}

/** Badge REC pulsé — lié à l'état RÉEL du recorder (recording != null). */
@Composable
private fun BoxScope.BadgeRec() {
    val transition = rememberInfiniteTransition(label = "rec")
    val opacite by transition.animateFloat(
        initialValue = 1f,
        targetValue = 0.25f,
        animationSpec = infiniteRepeatable(tween(650), RepeatMode.Reverse),
        label = "rec-opacite",
    )
    Row(
        modifier = Modifier
            .align(Alignment.TopEnd)
            .padding(top = 92.dp, end = 16.dp)
            .background(Color(0x8C022358), RoundedCornerShape(50))
            .padding(horizontal = 12.dp, vertical = 5.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Box(
            modifier = Modifier
                .size(12.dp)
                .alpha(opacite)
                .background(video.vitrine.core.designsystem.RougeBloquant, CircleShape)
        )
        Spacer(Modifier.width(7.dp))
        Text(
            stringResource(R.string.camera_rec_badge),
            color = Color.White,
            style = video.vitrine.core.designsystem.VitrineText.Label,
        )
    }
}

/**
 * Carte de consigne ancrée au-dessus de la barre de commandes — D42.33 §7.15 :
 * bandeau rgba(2,35,88,.55) + flou, textes blancs (avant : carte blanche).
 * Contenu et repli des segments D42.30 inchangés.
 */
@Composable
private fun BoxScope.PriseInstructionBottom(prise: PriseGuide, bottomPadding: Dp) {
    var replie by remember { mutableStateOf(true) }
    Column(
        modifier = Modifier
            .align(Alignment.BottomCenter)
            .padding(start = 12.dp, end = 12.dp, bottom = bottomPadding)
            .fillMaxWidth()
            .background(Color(0x8C022358), RoundedCornerShape(22.dp))
            // Flou du bandeau (§7.15) — no-op avant API 31, dégradé propre.
            .blur(20.dp)
            .padding(horizontal = 16.dp, vertical = 12.dp)
            .heightIn(max = 230.dp)
            .verticalScroll(rememberScrollState()),
        verticalArrangement = Arrangement.spacedBy(5.dp),
    ) {
        Text(
            stringResource(R.string.e6_to_film),
            color = video.vitrine.core.designsystem.OrangeHi,
            style = video.vitrine.core.designsystem.VitrineText.Label,
        )
        Text(
            prise.label,
            style = video.vitrine.core.designsystem.VitrineText.H3,
            color = Color.White,
        )
        Text(
            prise.cameraInstruction,
            style = video.vitrine.core.designsystem.VitrineText.Body,
            color = video.vitrine.core.designsystem.Blanc80,
        )
        Text(
            stringResource(R.string.e6_about, prise.targetS),
            style = video.vitrine.core.designsystem.VitrineText.Tiny,
            color = video.vitrine.core.designsystem.Blanc80,
        )
        if (prise.segments.isNotEmpty()) {
            Text(
                stringResource(R.string.e6_parole_n, prise.segments.size) +
                    if (replie) "  ▾" else "  ▴",
                color = Color.White,
                style = video.vitrine.core.designsystem.VitrineText.Label,
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { replie = !replie }
                    .padding(top = 4.dp),
            )
            AnimatedVisibility(visible = !replie) {
                Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                    prise.segments.forEach { seg ->
                        Text(
                            stringResource(R.string.e6_show) + " : " + seg.show,
                            style = video.vitrine.core.designsystem.VitrineText.Tiny,
                            color = video.vitrine.core.designsystem.Blanc80,
                        )
                        Text(
                            stringResource(R.string.e6_tell) + " : " + seg.tell,
                            style = video.vitrine.core.designsystem.VitrineText.Tiny,
                            color = video.vitrine.core.designsystem.Blanc80,
                        )
                        Text(
                            "« " + seg.example + " »",
                            style = video.vitrine.core.designsystem.VitrineText.Tiny,
                            color = Color.White,
                            modifier = Modifier
                                .background(Color(0x1AFFFFFF), RoundedCornerShape(10.dp))
                                .padding(horizontal = 8.dp, vertical = 4.dp),
                        )
                    }
                }
            }
        }
    }
}

/** Compte à rebours 3-2-1 VÉRITABLE : affiché pendant le décompte, le recorder
 *  ne démarre qu'à sa fin (CameraGuideActivity.lancerCompteARebours). */
@Composable
private fun BoxScope.CompteARebours(valeur: Int) {
    Box(
        modifier = Modifier
            .align(Alignment.Center)
            .size(140.dp)
            .background(Color(0x99022358), CircleShape),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            valeur.toString(),
            color = Color.White,
            fontSize = 84.sp,
            textAlign = TextAlign.Center,
        )
    }
}

/** Confirmation transitoire après Finalize réussi — preuve visible de la prise. */
@Composable
private fun BoxScope.ConfirmationPrise(numero: Int) {
    Box(
        modifier = Modifier
            .align(Alignment.Center)
            .background(video.vitrine.core.designsystem.VertSucces.copy(alpha = 0.8f), RoundedCornerShape(14.dp))
            .padding(horizontal = 22.dp, vertical = 12.dp),
    ) {
        Text(
            stringResource(R.string.camera_take_validated, numero),
            color = Color.White,
            style = video.vitrine.core.designsystem.VitrineText.H3,
        )
    }
}
