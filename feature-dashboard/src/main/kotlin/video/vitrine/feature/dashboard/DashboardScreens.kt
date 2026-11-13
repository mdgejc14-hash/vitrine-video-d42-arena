package video.vitrine.feature.dashboard

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.BleuNuit
import video.vitrine.core.designsystem.BleuVoile
import video.vitrine.core.designsystem.OrangeStore
import video.vitrine.core.model.billing.Plan
import video.vitrine.data.local.EntitlementsCache

/**
 * D42.32 (Lot 5) : etat de synchronisation HONNETE du miroir d'autorisations.
 * « Synchronise » n'est affiche qu'apres un aller-retour serveur reussi
 * (flushPending) — jamais sans preuve. HORS_CONNEXION propose « Reessayer ».
 */
enum class SyncState { EN_COURS, SYNCHRONISE, HORS_CONNEXION }

/** Vert de confirmation sync ; gris neutre hors connexion. */
private val SyncVert = Color(0xFF178A4B)
private val SyncGris = Color(0xFF9AA3AF)

/** Ecran 10 (dashboard) : en-tete pro, carte credits, creation, parrainage. */
@Composable
fun DashboardScreen(
    entitlements: EntitlementsCache?,
    welcomeCreditsLeft: Int,
    onBuy: () -> Unit,
    onReferral: () -> Unit,
    onSettings: () -> Unit = {},
    merchantName: String = "",
    sectorLabel: String = "",
    referralCode: String = "",
    referralGauge: ReferralGaugeUi? = null,
    syncState: SyncState = SyncState.EN_COURS,
    planExportsLimit: Int = 0,
    onRetrySync: () -> Unit = {},
    onCreateVideo: () -> Unit = {},
    onCopyCode: () -> Unit = {},
    onShareWhatsApp: () -> Unit = {},
    onViewFilleuls: () -> Unit = {}
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        // D42.32 (Lot 5) : ordre impose — en-tete pro, carte credits (exports,
        // qualite, sync honnete), action principale creation, parrainage
        // (code visible), acces secondaires.
        DashboardHeader(merchantName, sectorLabel, onSettings)
        DashboardCreditsCard(
            entitlements, welcomeCreditsLeft, planExportsLimit, syncState, onRetrySync, onBuy
        )
        DashboardCreateCard(onCreateVideo)
        DashboardReferralCard(referralCode, referralGauge, onCopyCode, onShareWhatsApp, onViewFilleuls)
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            OutlinedButton(onClick = onReferral, modifier = Modifier.weight(1f)) { Text(stringResource(R.string.dash_referral)) }
            OutlinedButton(onClick = onSettings, modifier = Modifier.weight(1f)) { Text(stringResource(R.string.dash_settings)) }
        }
    }
}

/**
 * D42.32 (Lot 5) : en-tete pro — identite de marque, bienvenue nommee,
 * secteur, icone reglages. Le badge « COMPTE » est supprime (mot empile) ;
 * le message trompeur « Droits non synchronises » disparait avec lui.
 */
@Composable
private fun DashboardHeader(merchantName: String, sectorLabel: String, onSettings: () -> Unit) {
    Column(
        modifier = Modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Image(
                    painter = painterResource(
                        id = video.vitrine.core.designsystem.R.drawable.vitrine_logo
                    ),
                    contentDescription = null,
                    modifier = Modifier.height(30.dp)
                )
                Text(
                    stringResource(R.string.dash_app_name),
                    style = MaterialTheme.typography.titleMedium,
                    color = BleuNuit,
                    fontWeight = FontWeight.SemiBold
                )
            }
            // icone compte/reglages — cible tactile 44 dp (a11y)
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .background(BleuVoile, CircleShape)
                    .clickable(onClick = onSettings)
                    .testTag("dash_settings_icon"),
                contentAlignment = Alignment.Center
            ) {
                Canvas(modifier = Modifier.size(22.dp)) { dessinerEngrenage(BleuNuit) }
            }
        }
        Text(
            stringResource(R.string.dash_hello, merchantName.ifBlank { "—" }),
            style = MaterialTheme.typography.headlineSmall,
            color = BleuNuit
        )
        if (sectorLabel.isNotBlank()) {
            Text(
                sectorLabel,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

/** Engrenage dessine (zero dependance icone externe) pour l'acces reglages. */
private fun DrawScope.dessinerEngrenage(couleur: Color) {
    val s = kotlin.math.min(size.width, size.height)
    val centre = Offset(s / 2f, s / 2f)
    val trait = s * 0.09f
    drawCircle(couleur, radius = s * 0.30f, center = centre, style = Stroke(trait))
    repeat(8) { i ->
        val a = Math.toRadians(i * 45.0)
        val cosA = kotlin.math.cos(a).toFloat()
        val sinA = kotlin.math.sin(a).toFloat()
        drawLine(
            couleur,
            Offset(centre.x + s * 0.30f * cosA, centre.y + s * 0.30f * sinA),
            Offset(centre.x + s * 0.42f * cosA, centre.y + s * 0.42f * sinA),
            trait * 1.2f,
            StrokeCap.Round
        )
    }
    drawCircle(couleur, radius = s * 0.09f, center = centre)
}

/**
 * D42.32 (Lot 5) : carte credits — exports restants en grand, rendus cloud,
 * qualite (resolution + filigrane), stockage cloud, ligne de sync honnete.
 * Remplace « TES VIDEOS · Max … cloud … cache … » (jargon, tutoiement
 * incoherent, pas d'etat de sync).
 */
@Composable
private fun DashboardCreditsCard(
    entitlements: EntitlementsCache?,
    welcomeCreditsLeft: Int,
    planExportsLimit: Int,
    syncState: SyncState,
    onRetrySync: () -> Unit,
    onBuy: () -> Unit
) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            Text(
                stringResource(R.string.dash_exports_left_label),
                color = OrangeStore,
                style = MaterialTheme.typography.labelLarge
            )
            if (welcomeCreditsLeft > 0 || planExportsLimit <= 0) {
                // credits de bienvenue (ou miroir pas encore synchronise)
                Text(
                    stringResource(R.string.dash_exports_count, welcomeCreditsLeft),
                    style = MaterialTheme.typography.headlineLarge,
                    color = BleuNuit,
                    fontWeight = FontWeight.Bold
                )
            } else {
                // D42.32 (Lot 7) : formule active — pas de compteur invente ;
                // la limite commerciale est celle de la grille (paywall).
                Text(
                    stringResource(R.string.dash_plan_active),
                    style = MaterialTheme.typography.headlineMedium,
                    color = BleuNuit,
                    fontWeight = FontWeight.Bold
                )
            }
            val e = entitlements
            if (e != null) {
                Text(
                    stringResource(R.string.dash_cloud_renders, e.cloudRenders),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Text(
                    stringResource(
                        if (e.watermark) R.string.dash_quality_wm else R.string.dash_quality_no_wm,
                        e.maxRes
                    ),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Text(
                    stringResource(R.string.dash_cache_days, e.cacheDays),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            LigneSync(syncState, onRetrySync)
            OutlinedButton(onClick = onBuy, modifier = Modifier.fillMaxWidth()) {
                Text(stringResource(R.string.dash_see_plans))
            }
        }
    }
}

/** Sync honnete : pastille verte (preuve serveur) / spinner / hors ligne + Reessayer. */
@Composable
private fun LigneSync(syncState: SyncState, onRetry: () -> Unit) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        when (syncState) {
            SyncState.SYNCHRONISE ->
                Box(modifier = Modifier.size(10.dp).background(SyncVert, CircleShape))
            SyncState.EN_COURS ->
                CircularProgressIndicator(modifier = Modifier.size(14.dp), strokeWidth = 2.dp)
            SyncState.HORS_CONNEXION ->
                Box(modifier = Modifier.size(10.dp).background(SyncGris, CircleShape))
        }
        Text(
            stringResource(
                when (syncState) {
                    SyncState.SYNCHRONISE -> R.string.sync_synced
                    SyncState.EN_COURS -> R.string.sync_in_progress
                    SyncState.HORS_CONNEXION -> R.string.sync_offline
                }
            ),
            style = MaterialTheme.typography.labelMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        if (syncState == SyncState.HORS_CONNEXION) {
            TextButton(onClick = onRetry) { Text(stringResource(R.string.sync_retry)) }
        }
    }
}

/** D42.32 (Lot 5) : action principale « Creer une video » — bouton orange plein. */
@Composable
private fun DashboardCreateCard(onCreateVideo: () -> Unit) {
    Column(
        modifier = Modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        Text(
            stringResource(R.string.dash_create_body),
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Button(
            onClick = onCreateVideo,
            modifier = Modifier
                .fillMaxWidth()
                .height(52.dp)
                .testTag("dash_create_video"),
            colors = ButtonDefaults.buttonColors(containerColor = OrangeStore)
        ) {
            Text(
                stringResource(R.string.dash_create_video),
                style = MaterialTheme.typography.titleMedium
            )
        }
    }
}

/**
 * D42.32 (Lot 6) : parrainage — ordre impose : titre, phrase, code personnel
 * VISIBLE SANS DEFILEMENT, « Copier mon code », « Partager sur WhatsApp »,
 * progression vers le palier suivant, acces historique. Les 5 lignes de
 * paliers (qui poussaient le code sous le pli) sont reportees en ecran 12.
 */
@Composable
private fun DashboardReferralCard(
    referralCode: String,
    gauge: ReferralGaugeUi?,
    onCopyCode: () -> Unit,
    onShare: () -> Unit,
    onViewFilleuls: () -> Unit
) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                stringResource(R.string.dash_referral_gifts),
                style = MaterialTheme.typography.titleMedium,
                color = BleuNuit,
                fontWeight = FontWeight.SemiBold
            )
            Text(
                stringResource(R.string.ref_intro),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Text(
                stringResource(R.string.ref_your_code),
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(BleuVoile, RoundedCornerShape(10.dp))
                    .padding(vertical = 12.dp),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    referralCode.ifBlank { stringResource(R.string.ref_code_pending) },
                    style = MaterialTheme.typography.headlineMedium,
                    color = BleuNuit,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.testTag("dash_referral_code")
                )
            }
            Button(onClick = onCopyCode, modifier = Modifier.fillMaxWidth()) {
                Text(stringResource(R.string.ref_copy_mine))
            }
            OutlinedButton(onClick = onShare, modifier = Modifier.fillMaxWidth()) {
                Text(stringResource(R.string.ref_share_whatsapp))
            }
            if (gauge != null) {
                LinearProgressIndicator(
                    progress = { gauge.progress },
                    modifier = Modifier
                        .fillMaxWidth()
                        .testTag("dash_referral_gauge")
                )
                Text(
                    stringResource(
                        R.string.ref2_sub_label,
                        gauge.within,
                        gauge.target,
                        maxOf(0, gauge.target - gauge.within)
                    ),
                    style = MaterialTheme.typography.labelMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            TextButton(onClick = onViewFilleuls) {
                Text(stringResource(R.string.dash_view_filleuls))
            }
        }
    }
}

/** Ecran 9 (paywall) : bandeau credits + 3 cartes forfaits stricts (grille 23/10/2026). */
@Composable
fun PaywallScreen(ui: PaywallUi, onChoose: (String) -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(stringResource(R.string.paywall_title), style = MaterialTheme.typography.headlineSmall)
        val banner = ui.bannerCreditsLeft
        if (banner != null && banner > 0) {
            Text(stringResource(R.string.paywall_credits_left, banner))
        } else if (ui.locked) {
            Text(
                stringResource(R.string.paywall_quota),
                color = Color(0xFFB26A00)
            )
        }
        ui.cards.forEach { card ->
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(6.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            // D42.32 (Lot 7) : hiérarchie commerciale — Pro recommandé.
                            if (card.plan == Plan.PRO) {
                                Box(
                                    modifier = Modifier
                                        .background(OrangeStore, RoundedCornerShape(6.dp))
                                        .padding(horizontal = 8.dp, vertical = 2.dp)
                                ) {
                                    Text(
                                        stringResource(R.string.plan_recommended),
                                        color = Color.White,
                                        style = MaterialTheme.typography.labelSmall
                                    )
                                }
                            }
                            Text(stringResource(card.titleRes), style = MaterialTheme.typography.titleMedium)
                        }
                        Text(
                            "  ·  " + card.priceValue +
                                (card.periodRes?.let { " / " + stringResource(it) } ?: ""),
                            color = Color.Gray,
                            modifier = Modifier.testTag("price_" + card.plan.code)
                        )
                    }
                    card.featureRes.forEach { Text("• " + stringResource(it), style = MaterialTheme.typography.bodySmall) }
                    // D42.32 (Lot 7) : CinetPay volontairement reporté — bouton
                    // INACTIF, aucun checkout, aucune fausse transaction. Le libellé
                    // dit la vérité : paiement en ligne bientôt disponible.
                    Button(
                        onClick = { onChoose(card.plan.code) },
                        enabled = false,
                        modifier = Modifier.testTag("paywall_" + card.plan.code)
                    ) {
                        Text(
                            stringResource(R.string.paywall_soon),
                            style = MaterialTheme.typography.bodyMedium
                        )
                    }
                }
            }
        }
        // D41 (F8) : equivalence BCEAO traduite (FR en dur avant) — devise = zone,
        // langue = parametres regionaux (decouplees).
        if (ui.footnoteBceao) {
            Text(
                stringResource(R.string.paywall_footnote_bceao),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

/** Ecran 12 (parrainage R8) : code serveur + jauge n/5 + historique. */
@Composable
fun ReferralScreen(gauge: ReferralGaugeUi, onShare: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(stringResource(R.string.ref2_title), style = MaterialTheme.typography.headlineSmall)
        Text(
            stringResource(R.string.ref2_invites),
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                Text(stringResource(R.string.ref2_your_code), style = MaterialTheme.typography.titleMedium)
                Text(
                    stringResource(R.string.ref2_code_copy, gauge.code),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                Text(stringResource(R.string.ref2_progress), style = MaterialTheme.typography.titleMedium)
                // D41 (F2) : jauge R8 — valeurs SERVEUR (converted/rewards), paliers
                // de 5 ; libelles traduits (FR en dur avant).
                LinearProgressIndicator(
                    progress = { gauge.progress },
                    modifier = Modifier
                        .fillMaxWidth()
                        .testTag("ref2_gauge")
                )
                Text(
                    stringResource(R.string.ref2_label_base, gauge.within, gauge.target) +
                        if (gauge.rewards > 0) {
                            " · " + stringResource(R.string.ref2_label_rewards, gauge.rewards)
                        } else {
                            ""
                        },
                    style = MaterialTheme.typography.titleSmall
                )
                Text(
                    stringResource(
                        R.string.ref2_sub_label,
                        gauge.within,
                        gauge.target,
                        maxOf(0, gauge.target - gauge.within)
                    ),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
        ReferralHistoriqueRepliable(gauge.entries)
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                Text(stringResource(R.string.ref2_reward_title), style = MaterialTheme.typography.titleMedium)
                Text(
                    stringResource(R.string.ref2_reward_body),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
        Button(onClick = onShare, modifier = Modifier.fillMaxWidth()) { Text(stringResource(R.string.ref_share_whatsapp)) }
    }
}

/**
 * D42.32 (Lot 6) : historique REPLIABLE — ouvert par defaut, pliable.
 * (Extraction D42.32 : detekt LongMethod sur ReferralScreen.)
 */
@Composable
private fun ReferralHistoriqueRepliable(entries: List<ReferralEntry>) {
    var historiqueReplie by remember { mutableStateOf(false) }
    TextButton(onClick = { historiqueReplie = !historiqueReplie }) {
        Text(
            stringResource(
                if (historiqueReplie) R.string.ref2_history_show
                else R.string.ref2_history_hide,
                entries.size
            )
        )
    }
    if (!historiqueReplie) {
        ReferralHistorique(entries)
    }
}

/** D41 (detekt LongMethod) : historique des filleuls extrait de ReferralScreen. */
@Composable
private fun ReferralHistorique(entries: List<ReferralEntry>) {
    entries.forEachIndexed { index, entry ->
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Text(if (entry.converted) "✓" else "○")
            // D41 (F2) : historique serveur ANONYMISE — plus de noms inventes
            // cote client (privacy : le serveur n'expose pas l'identite des filleuls).
            Text(
                stringResource(R.string.ref2_filleul_n, index + 1) + " · " +
                    stringResource(
                        if (entry.converted) R.string.ref2_status_converted
                        else R.string.ref2_status_pending
                    ),
                style = MaterialTheme.typography.bodyMedium
            )
        }
    }
}

/** Ecran 12 (reglages, maquette E12_Reglages) : compte, langue, parrain, secteur, accords, espace, deconnexion. */
@Composable
fun SettingsScreen(
    accountEmail: String,
    languageLabel: String,
    referralCode: String,
    sectorLabel: String,
    consentsCount: Int,
    storageUsedLabel: String,
    onChangeLanguage: () -> Unit = {},
    onViewReferral: () -> Unit = {},
    onChangeSector: () -> Unit = {},
    onViewConsents: () -> Unit = {},
    onClearRawTakes: () -> Unit = {},
    onLogout: () -> Unit = {}
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(stringResource(R.string.set_title), style = MaterialTheme.typography.headlineSmall)
        Text(
            stringResource(R.string.set_subtitle),
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        SettingsCard(stringResource(R.string.set_account), accountEmail)
        SettingsCard(stringResource(R.string.set_language), stringResource(R.string.set_language_value, languageLabel), onChangeLanguage)
        SettingsCard(stringResource(R.string.set_referral), stringResource(R.string.set_referral_value, referralCode), onViewReferral)
        SettingsCard(stringResource(R.string.set_sector), stringResource(R.string.set_sector_value, sectorLabel), onChangeSector)
        SettingsCard(stringResource(R.string.set_consents), stringResource(R.string.set_consents_value, consentsCount), onViewConsents)
        SettingsCard(stringResource(R.string.set_storage), stringResource(R.string.set_storage_value, storageUsedLabel), onClearRawTakes)
        SettingsCard(stringResource(R.string.set_logout), stringResource(R.string.set_logout_value), onLogout)
    }
}

@Composable
private fun SettingsCard(title: String, subtitle: String, onClick: () -> Unit = {}) {
    Card(onClick = onClick, modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
            Text(title, style = MaterialTheme.typography.titleMedium)
            Text(
                subtitle,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}
