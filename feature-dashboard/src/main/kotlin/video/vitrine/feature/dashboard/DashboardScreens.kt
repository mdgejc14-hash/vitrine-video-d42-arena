package video.vitrine.feature.dashboard

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.ui.Alignment
import video.vitrine.core.designsystem.BleuNuit
import video.vitrine.core.designsystem.BleuVoile
import video.vitrine.core.designsystem.OrangeStore
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.ui.res.stringResource
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import video.vitrine.data.local.EntitlementsCache

/** Ecran 10 (dashboard, maquette E10_Dashboard) : bonjour, videos restantes, creer, parrainage. */
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
        DashboardHeader(merchantName, sectorLabel)
        DashboardVideosCard(entitlements, welcomeCreditsLeft, onBuy)
        DashboardCreateCard(onCreateVideo)
        Text(stringResource(R.string.dash_referral_gifts), style = MaterialTheme.typography.titleLarge, color = BleuNuit)
        DashboardReferralCard(referralCode, onCopyCode, onShareWhatsApp)
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            OutlinedButton(onClick = onReferral, modifier = Modifier.weight(1f)) { Text(stringResource(R.string.dash_referral)) }
            OutlinedButton(onClick = onSettings, modifier = Modifier.weight(1f)) { Text(stringResource(R.string.dash_settings)) }
        }
        Button(onClick = onViewFilleuls, modifier = Modifier.fillMaxWidth()) { Text(stringResource(R.string.dash_view_filleuls)) }
    }
}

@Composable
private fun DashboardHeader(merchantName: String, sectorLabel: String) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column {
            Text(stringResource(R.string.dash_hello, merchantName.ifBlank { "—" }), style = MaterialTheme.typography.headlineSmall)
            Text(
                sectorLabel.ifBlank { stringResource(R.string.dash_rights_default) },
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
        Box(
            modifier = Modifier
                .background(BleuVoile, RoundedCornerShape(8.dp))
                .padding(horizontal = 12.dp, vertical = 6.dp)
        ) {
            Text(stringResource(R.string.dash_compte), color = BleuNuit, style = MaterialTheme.typography.titleSmall)
        }
    }
}

@Composable
private fun DashboardVideosCard(entitlements: EntitlementsCache?, welcomeCreditsLeft: Int, onBuy: () -> Unit) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(stringResource(R.string.dash_tes_videos), color = OrangeStore, style = MaterialTheme.typography.labelLarge)
                Text(
                    stringResource(R.string.dash_videos_left, welcomeCreditsLeft),
                    style = MaterialTheme.typography.titleLarge,
                    color = BleuNuit
                )
                val e = entitlements
                if (e != null) {
                    Text(
                        stringResource(R.string.dash_entitlements_line, e.maxRes, e.cloudRenders, e.cacheDays),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
            OutlinedButton(onClick = onBuy) { Text(stringResource(R.string.dash_buy)) }
        }
    }
}

@Composable
private fun DashboardCreateCard(onCreateVideo: () -> Unit) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(stringResource(R.string.dash_create_title), color = BleuNuit, style = MaterialTheme.typography.labelLarge)
                Text(
                    stringResource(R.string.dash_create_body),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            Button(onClick = onCreateVideo) { Text(stringResource(R.string.dash_create)) }
        }
    }
}

@Composable
private fun DashboardReferralCard(referralCode: String, onCopyCode: () -> Unit, onShare: () -> Unit) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Text(
                stringResource(R.string.ref_intro),
                style = MaterialTheme.typography.bodyMedium
            )
            listOf(5, 10, 15, 20, 25).forEachIndexed { i, n ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(BleuVoile, RoundedCornerShape(6.dp))
                        .padding(horizontal = 12.dp, vertical = 8.dp),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(stringResource(R.string.ref_invites_pro, n), color = BleuNuit, style = MaterialTheme.typography.titleSmall)
                    Text(stringResource(R.string.ref_months_pro, i + 1), color = OrangeStore, style = MaterialTheme.typography.titleSmall)
                }
            }
            Text(stringResource(R.string.ref_your_code), style = MaterialTheme.typography.titleSmall, color = BleuNuit)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(referralCode.ifBlank { "—" }, style = MaterialTheme.typography.titleMedium)
                Button(onClick = onCopyCode) { Text(stringResource(R.string.ref_copy)) }
            }
            OutlinedButton(onClick = onShare, modifier = Modifier.fillMaxWidth()) {
                Text(stringResource(R.string.ref_share_whatsapp))
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
                    Row(modifier = Modifier.fillMaxWidth()) {
                        Text(stringResource(card.titleRes), style = MaterialTheme.typography.titleMedium)
                        Text(
                            "  ·  " + card.priceValue +
                                (card.periodRes?.let { " / " + stringResource(it) } ?: ""),
                            color = Color.Gray,
                            modifier = Modifier.testTag("price_" + card.plan.code)
                        )
                    }
                    card.featureRes.forEach { Text("• " + stringResource(it), style = MaterialTheme.typography.bodySmall) }
                    Button(
                    onClick = { onChoose(card.plan.code) },
                    modifier = Modifier.testTag("paywall_" + card.plan.code)
                ) { Text(stringResource(R.string.paywall_pay)) }
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
        ReferralHistorique(gauge.entries)
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
