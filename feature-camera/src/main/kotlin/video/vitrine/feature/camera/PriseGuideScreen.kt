package video.vitrine.feature.camera

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.border
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
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import video.vitrine.core.designsystem.BleuNuit
import video.vitrine.core.designsystem.BleuVoile
import video.vitrine.core.designsystem.OrangeStore
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
    faceCount: Int,
    gateAllowed: Boolean,
    modifier: Modifier = Modifier,
) {
    val prise = prises.getOrNull(priseIdx) ?: return
    Box(modifier = modifier.fillMaxSize()) {
        CoinsCadrage()
        PriseTopHud(priseIdx, prises.size, sectorLabel, formatLabel, streaming)
        if (recording) BadgeRec()
        BadgeVisages(faceCount, gateAllowed)
        PriseInstructionBottom(prise, bottomPadding = 196.dp)
        if (countdown != null) CompteARebours(countdown)
        if (priseValidee != null) ConfirmationPrise(priseValidee)
    }
}

/** Quatre coins de cadrage discrets — le flux caméra reste visible (mission §2.A :
 *  une silhouette ou un cadre NE doit JAMAIS se présenter comme la prévisualisation). */
@Composable
private fun BoxScope.CoinsCadrage() {
    val coin = @Composable { mod: Modifier ->
        Box(modifier = mod.size(34.dp).border(3.dp, Color(0x99F95C0F), RoundedCornerShape(6.dp)))
    }
    coin(Modifier.align(Alignment.TopStart).padding(top = 150.dp, start = 26.dp))
    coin(Modifier.align(Alignment.TopEnd).padding(top = 150.dp, end = 26.dp))
    coin(Modifier.align(Alignment.CenterStart).padding(bottom = 212.dp, start = 26.dp))
    coin(Modifier.align(Alignment.CenterEnd).padding(bottom = 212.dp, end = 26.dp))
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
            .background(Color(0xB3000000))
            .padding(horizontal = 14.dp, vertical = 10.dp),
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
                style = MaterialTheme.typography.titleMedium,
            )
            Text(
                "PRISE ${priseIdx + 1}/$total",
                color = Color(0xCCFFFFFF),
                style = MaterialTheme.typography.labelMedium,
                modifier = Modifier
                    .background(Color(0x33FFFFFF), RoundedCornerShape(6.dp))
                    .padding(horizontal = 8.dp, vertical = 2.dp),
            )
            Spacer(Modifier.weight(1f))
            EtatFlux(streaming)
        }
        if (sectorLabel.isNotBlank() || formatLabel.isNotBlank()) {
            Text(
                listOf(sectorLabel, formatLabel).filter { it.isNotBlank() }.joinToString(" · "),
                color = Color(0xCCFFFFFF),
                style = MaterialTheme.typography.bodySmall,
            )
        }
    }
}

/** Chip d'état du flux : « Caméra prête » (STREAMING) vs « Démarrage… » (IDLE). */
@Composable
private fun EtatFlux(streaming: Boolean?) {
    val (libelle, fond) = when (streaming) {
        true -> stringResource(R.string.camera_stream_ready) to Color(0xFF2E7D32)
        else -> stringResource(R.string.camera_stream_starting) to Color(0xFF8D6E00)
    }
    Box(
        modifier = Modifier
            .background(fond, RoundedCornerShape(10.dp))
            .padding(horizontal = 10.dp, vertical = 4.dp)
    ) {
        Text(libelle, color = Color.White, style = MaterialTheme.typography.labelMedium)
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
            .background(Color(0xCC000000), RoundedCornerShape(10.dp))
            .padding(horizontal = 10.dp, vertical = 5.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Box(
            modifier = Modifier
                .size(12.dp)
                .alpha(opacite)
                .background(Color(0xFFFF3B30), CircleShape)
        )
        Spacer(Modifier.width(7.dp))
        Text(
            stringResource(R.string.camera_rec_badge),
            color = Color.White,
            style = MaterialTheme.typography.titleSmall,
        )
    }
}

@Composable
private fun BoxScope.BadgeVisages(faceCount: Int, gateAllowed: Boolean) {
    Text(
        stringResource(
            if (gateAllowed) R.string.camera_faces_ok else R.string.camera_faces_ko,
            faceCount
        ),
        color = if (gateAllowed) Color(0xFF7BD88F) else Color(0xFFFF6B6B),
        style = MaterialTheme.typography.labelMedium,
        textAlign = TextAlign.Center,
        modifier = Modifier
            .align(Alignment.TopCenter)
            .padding(top = 92.dp)
            .background(Color(0x99000000), RoundedCornerShape(8.dp))
            .padding(horizontal = 10.dp, vertical = 3.dp),
    )
}

/** Carte d'instruction ancrée au-dessus de la barre de commandes (zone claire). */
@Composable
private fun BoxScope.PriseInstructionBottom(prise: PriseGuide, bottomPadding: Dp) {
    var replie by remember { mutableStateOf(true) }
    Card(
        modifier = Modifier
            .align(Alignment.BottomCenter)
            .padding(start = 12.dp, end = 12.dp, bottom = bottomPadding)
            .fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = Color(0xF2FFFFFF)),
    ) {
        Column(
            modifier = Modifier
                .padding(horizontal = 14.dp, vertical = 10.dp)
                .heightIn(max = 230.dp)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(5.dp),
        ) {
            Text(
                stringResource(R.string.e6_to_film),
                color = OrangeStore,
                style = MaterialTheme.typography.labelLarge,
            )
            Text(
                prise.label,
                style = MaterialTheme.typography.titleMedium,
                color = BleuNuit,
            )
            Text(prise.cameraInstruction, style = MaterialTheme.typography.bodyMedium)
            Text(
                stringResource(R.string.e6_about, prise.targetS),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            if (prise.segments.isNotEmpty()) {
                Text(
                    stringResource(R.string.e6_parole_n, prise.segments.size) +
                        if (replie) "  ▾" else "  ▴",
                    color = BleuNuit,
                    style = MaterialTheme.typography.labelLarge,
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
                                style = MaterialTheme.typography.bodySmall,
                            )
                            Text(
                                stringResource(R.string.e6_tell) + " : " + seg.tell,
                                style = MaterialTheme.typography.bodySmall,
                            )
                            Text(
                                "« " + seg.example + " »",
                                style = MaterialTheme.typography.bodySmall,
                                color = BleuNuit,
                                modifier = Modifier
                                    .background(BleuVoile, RoundedCornerShape(6.dp))
                                    .padding(horizontal = 8.dp, vertical = 4.dp),
                            )
                        }
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
            .background(Color(0x99000000), CircleShape),
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
            .background(Color(0xCC2E7D32), RoundedCornerShape(14.dp))
            .padding(horizontal = 22.dp, vertical = 12.dp),
    ) {
        Text(
            stringResource(R.string.camera_take_validated, numero),
            color = Color.White,
            style = MaterialTheme.typography.titleMedium,
        )
    }
}
