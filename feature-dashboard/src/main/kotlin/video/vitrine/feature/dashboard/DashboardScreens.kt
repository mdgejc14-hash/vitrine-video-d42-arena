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
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
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
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import video.vitrine.core.designsystem.R as Rds
import video.vitrine.core.designsystem.AmbreAlerte
import video.vitrine.core.designsystem.Inter
import video.vitrine.core.designsystem.Bg
import video.vitrine.core.designsystem.BarreOnglets
import video.vitrine.core.designsystem.BarreProgression
import video.vitrine.core.designsystem.BoutonPrimaire
import video.vitrine.core.designsystem.BoutonSecondaire
import video.vitrine.core.designsystem.EntreeOnglet
import video.vitrine.core.designsystem.IconeVitrine
import video.vitrine.core.designsystem.LigneListe
import video.vitrine.core.designsystem.Line
import video.vitrine.core.designsystem.Blanc
import video.vitrine.core.designsystem.Blanc70
import video.vitrine.core.designsystem.Blanc80
import video.vitrine.core.designsystem.BleuVoile
import video.vitrine.core.designsystem.Muted
import video.vitrine.core.designsystem.Navy
import video.vitrine.core.designsystem.OrangeDeep
import video.vitrine.core.designsystem.OrangeStore
import video.vitrine.core.designsystem.OrangeVoile
import video.vitrine.core.designsystem.VertSucces
import video.vitrine.core.designsystem.VitrineText
import video.vitrine.core.model.billing.Plan
import video.vitrine.data.local.EntitlementsCache

/**
 * D42.32 (Lot 5) : etat de synchronisation HONNETE du miroir d'autorisations.
 * « Synchronise » n'est affiche qu'apres un aller-retour serveur reussi
 * (flushPending) — jamais sans preuve. HORS_CONNEXION propose « Reessayer ».
 */
enum class SyncState { EN_COURS, SYNCHRONISE, HORS_CONNEXION }

/** Ecran 10 (dashboard) — D42.33 §9.3 : ordre vertical impose :
 *  header (Bonjour + reglages) -> carte heros navy (exports restants en Num +
 *  anneau decoratif + badges) -> CTA « Creer une video » soude a la heros ->
 *  Reprendre (brouillon REEL) -> parrainage (code reel copiable) -> derniers
 *  exports (comptage REEL du journal) -> tab bar avec action centrale.
 *  Interdits respectes : aucun nom invente (« Bonjour » seul si absence),
 *  aucune fausse notification, aucun faux indicateur ; un seul CTA orange
 *  plein (« Creer une video ») — la copie du code est un secondaire doux.
 */
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
    onViewFilleuls: () -> Unit = {},
    ongletActif: Int = 0,
    surOnglet: (Int) -> Unit = {},
    draftSkinName: String? = null,
    draftEtape: String? = null,
    onReprendre: () -> Unit = {},
    exportsReussis: Int = 0,
    dernierExportTs: Long = 0L
) {
    Column(modifier = Modifier.fillMaxWidth()) {
        Column(
            modifier = Modifier
                .weight(1f)
                .background(Bg)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 20.dp)
                .padding(top = 12.dp, bottom = 16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            DashboardHeader(merchantName, sectorLabel, onSettings)
            BlocHeroEtCta(
                entitlements, welcomeCreditsLeft, planExportsLimit,
                syncState, onRetrySync, onBuy, onCreateVideo
            )
            if (draftSkinName != null) {
                LigneReprendre(draftSkinName, draftEtape, onReprendre)
            }
            DashboardReferralCard(
                referralCode, referralGauge, onCopyCode, onShareWhatsApp, onViewFilleuls
            )
            if (exportsReussis > 0) {
                LigneDerniersExports(exportsReussis, dernierExportTs)
            }
        }
        TabBarDashboard(ongletActif, surOnglet, onCreateVideo)
    }
}

/** §9.3.6 : tab bar — 4 onglets réels + action centrale « Créer ». */
@Composable
private fun TabBarDashboard(
    ongletActif: Int,
    surOnglet: (Int) -> Unit,
    onCreateVideo: () -> Unit
) {
    BarreOnglets(
        entrees = listOf(
            EntreeOnglet(
                icone = painterResource(Rds.drawable.ic_film),
                libelle = stringResource(R.string.dash_tab_home),
                actif = ongletActif == 0
            ),
            EntreeOnglet(
                icone = painterResource(Rds.drawable.ic_target),
                libelle = stringResource(R.string.dash_tab_plans),
                actif = ongletActif == 1
            ),
            EntreeOnglet(
                icone = painterResource(Rds.drawable.ic_gift),
                libelle = stringResource(R.string.dash_referral),
                actif = ongletActif == 2
            ),
            EntreeOnglet(
                icone = painterResource(Rds.drawable.ic_info),
                libelle = stringResource(R.string.dash_settings),
                actif = ongletActif == 3
            ),
        ),
        iconeCentrale = painterResource(Rds.drawable.ic_plus),
        libelleCentrale = stringResource(R.string.dash_tab_create),
        surOnglet = surOnglet,
        surCentrale = onCreateVideo
    )
}

/**
 * §9.3.1 : header — avatar (initiale reelle ou insigne), « Bonjour » Tiny +
 * prenom BodyStrong (JAMAIS « — » : sans nom reel, « Bonjour » seul),
 * secteur, reglages 44 dp (testTag dash_settings_icon intouchable).
 * Ecart documente : pas d'icone notifications — aucun systeme reel, un point
 * orange serait un faux indicateur (mission §8).
 */
@Composable
private fun DashboardHeader(merchantName: String, sectorLabel: String, onSettings: () -> Unit) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        AvatarMarchand(merchantName)
        Column(modifier = Modifier.weight(1f)) {
            TexteBonjour(merchantName)
            if (sectorLabel.isNotBlank()) {
                Text(
                    sectorLabel,
                    style = VitrineText.Tiny,
                    color = Muted
                )
            }
        }
        Box(
            modifier = Modifier
                .size(44.dp)
                .background(BleuVoile, CircleShape)
                .clickable(onClick = onSettings)
                .testTag("dash_settings_icon"),
            contentAlignment = Alignment.Center
        ) {
            Canvas(modifier = Modifier.size(22.dp)) {
                dessinerEngrenage(Navy)
            }
        }
    }
}

/** §9.3.1 : avatar 40 dp — initiale REELLE du nom, sinon l'insigne (jamais un nom invente). */
@Composable
private fun AvatarMarchand(merchantName: String) {
    Box(
        modifier = Modifier
            .size(40.dp)
            .background(BleuVoile, CircleShape),
        contentAlignment = Alignment.Center
    ) {
        val initiale = merchantName.trim().firstOrNull()?.uppercase()
        if (initiale != null) {
            Text(
                initiale.toString(),
                style = VitrineText.H3,
                color = Navy
            )
        } else {
            Image(
                painter = painterResource(Rds.drawable.vitrine_logo),
                contentDescription = null,
                modifier = Modifier.size(24.dp)
            )
        }
    }
}

/**
 * §9.3.1 : « Bonjour » Tiny + prénom BodyStrong en DEUX TONS mais UN seul
 * nœud texte (sémantique « Bonjour, Prénom » préservée pour les tests).
 * Sans nom réel : « Bonjour » seul — JAMAIS « — » ni un prénom inventé.
 */
@Composable
private fun TexteBonjour(merchantName: String) {
    val bonjourSeul = stringResource(R.string.dash_hello_sans_nom)
    Text(
        buildAnnotatedString {
            withStyle(
                SpanStyle(
                    fontFamily = Inter,
                    fontWeight = FontWeight.W400,
                    fontSize = 12.5.sp,
                    color = Muted
                )
            ) {
                append(
                    bonjourSeul + if (merchantName.isNotBlank()) ", " else ""
                )
            }
            if (merchantName.isNotBlank()) {
                withStyle(
                    SpanStyle(
                        fontFamily = Inter,
                        fontWeight = FontWeight.W600,
                        fontSize = 15.sp,
                        color = Navy
                    )
                ) { append(merchantName) }
            }
        }
    )
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
 * §9.3.2-3 : carte heros NAVY rayon 26 (Label EXPORTS RESTANTS + Num + « offerts »
 * + anneau orange decoratif + badges reels) et CTA orange 56 SOUDE a la heros
 * (8 dp) + micro-copie existante — un seul bloc visuel.
 */
@Composable
private fun BlocHeroEtCta(
    entitlements: EntitlementsCache?,
    welcomeCreditsLeft: Int,
    planExportsLimit: Int,
    syncState: SyncState,
    onRetrySync: () -> Unit,
    onBuy: () -> Unit,
    onCreateVideo: () -> Unit
) {
    Column(modifier = Modifier.fillMaxWidth()) {
        CarteSoldeHeros(
            entitlements, welcomeCreditsLeft, planExportsLimit,
            syncState, onRetrySync, onBuy
        )
        // §9.3.3 : panneau d'action sous la hero (8 dp) — CTA + micro-copie.
        PanneauCta(onCreateVideo)
    }
}

/** §9.3.2 : carte heros NAVY r26 — solde réel, anneau décoratif, badges honnêtes. */
@Composable
private fun CarteSoldeHeros(
    entitlements: EntitlementsCache?,
    welcomeCreditsLeft: Int,
    planExportsLimit: Int,
    syncState: SyncState,
    onRetrySync: () -> Unit,
    onBuy: () -> Unit
) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .background(
                Navy,
                RoundedCornerShape(topStart = 26.dp, topEnd = 26.dp)
            )
    ) {
        // Anneau décoratif (§9.3.2) — a droite, hors zone de texte.
        Canvas(
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(16.dp)
                .size(84.dp)
        ) {
            drawArc(
                color = OrangeStore.copy(alpha = 0.55f),
                startAngle = -90f,
                sweepAngle = 300f,
                useCenter = false,
                style = Stroke(10f, cap = StrokeCap.Round)
            )
        }
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            Text(
                stringResource(R.string.dash_exports_left_label),
                style = VitrineText.Label,
                color = Blanc70
            )
            if (welcomeCreditsLeft > 0 || planExportsLimit <= 0) {
                Row(verticalAlignment = Alignment.Bottom) {
                    Text(
                        stringResource(R.string.dash_exports_count, welcomeCreditsLeft),
                        style = VitrineText.Num,
                        color = Color.White
                    )
                    if (welcomeCreditsLeft > 0) {
                        Text(
                            " " + stringResource(R.string.dash_offerts),
                            style = VitrineText.Sub,
                            color = Blanc80,
                            modifier = Modifier.padding(bottom = 6.dp)
                        )
                    }
                }
            } else {
                // D42.32 (Lot 7) préservé : formule active (limite serveur > 0,
                // crédits épuisés) — PAS de « 0 » trompeur ni de plafond technique.
                Text(
                    stringResource(R.string.dash_plan_active),
                    style = VitrineText.Sub,
                    color = Blanc80
                )
            }
            DetailsEntitlements(entitlements)
            RangeeBadgesHeros(syncState, onRetrySync, welcomeCreditsLeft, planExportsLimit, onBuy)
        }
    }
}

/** Détails réels du miroir d'autorisations (rendus cloud, qualité, watermark). */
@Composable
private fun DetailsEntitlements(e: EntitlementsCache?) {
    if (e != null) {
        Text(
            stringResource(R.string.dash_cloud_renders, e.cloudRenders),
            style = VitrineText.Tiny,
            color = Blanc70
        )
        Text(
            stringResource(
                if (e.watermark) R.string.dash_quality_wm else R.string.dash_quality_no_wm,
                e.maxRes
            ),
            style = VitrineText.Tiny,
            color = Blanc70
        )
    }
}

/** Sync honnête + badge Essai + pastille Formules (testTag dash_see_plans). */
@Composable
private fun RangeeBadgesHeros(
    syncState: SyncState,
    onRetrySync: () -> Unit,
    welcomeCreditsLeft: Int,
    planExportsLimit: Int,
    onBuy: () -> Unit
) {
    Row(
        modifier = Modifier.padding(top = 4.dp),
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        LigneSync(syncState, onRetrySync)
        if (welcomeCreditsLeft > 0 && planExportsLimit <= 0) {
            BadgeHeros(stringResource(R.string.dash_badge_essai))
        }
        Box(
            modifier = Modifier
                .background(Color(0x1FFFFFFF), RoundedCornerShape(50))
                .clickable(onClick = onBuy)
                .testTag("dash_see_plans")
                .padding(horizontal = 10.dp, vertical = 4.dp)
        ) {
            Text(
                stringResource(R.string.dash_badge_formules),
                style = VitrineText.Label,
                color = Color.White
            )
        }
    }
}

/** §9.3.3 : panneau blanc du CTA — un seul bouton orange plein (Créer une vidéo). */
@Composable
private fun PanneauCta(onCreateVideo: () -> Unit) {
    Box(
        modifier = Modifier
            .padding(top = 8.dp)
            .background(
                Blanc,
                RoundedCornerShape(bottomStart = 26.dp, bottomEnd = 26.dp)
            )
            .padding(horizontal = 12.dp, vertical = 4.dp)
    ) {
        Column {
            BoutonPrimaire(
                libelle = stringResource(R.string.dash_create_video),
                onClick = onCreateVideo,
                modifier = Modifier.fillMaxWidth(),
                testTag = "dash_create_video"
            )
            Text(
                stringResource(R.string.dash_create_body),
                style = VitrineText.Tiny,
                color = Muted,
                textAlign = TextAlign.Center,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 8.dp)
            )
        }
    }
}

/** Badge sur heros navy : pilule blanc 12 %, texte blanc. */
@Composable
private fun BadgeHeros(texte: String) {
    Box(
        modifier = Modifier
            .background(Color(0x1FFFFFFF), RoundedCornerShape(50))
            .padding(horizontal = 10.dp, vertical = 4.dp)
    ) {
        Text(
            texte,
            style = VitrineText.Label,
            color = Color.White
        )
    }
}

/**
 * §9.3.4 : « Reprendre » — n'est affichee QUE si un brouillon REEL existe
 * (DraftStore). Progression honnete : etape reelle (Brief/Tournage), jamais
 * de numero de scene invente. L'action relance le dialogue D42.27 valide.
 */
@Composable
private fun LigneReprendre(skinName: String, etape: String?, onReprendre: () -> Unit) {
    Column(modifier = Modifier.fillMaxWidth()) {
        Text(
            stringResource(R.string.dash_reprendre),
            style = VitrineText.Label,
            color = Muted
        )
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 6.dp)
                .background(Blanc, RoundedCornerShape(18.dp))
                .clickable(onClick = onReprendre)
                .padding(14.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            IconeVitrine(
                icone = painterResource(Rds.drawable.ic_video),
                taille = 22.dp,
                teinte = OrangeStore
            )
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    skinName,
                    style = VitrineText.BodyStrong,
                    color = Navy,
                    maxLines = 1
                )
                Text(
                    stringResource(
                        if (etape == "CAMERA") R.string.dash_reprendre_camera
                        else R.string.dash_reprendre_brief
                    ),
                    style = VitrineText.Tiny,
                    color = Muted
                )
            }
            IconeVitrine(
                icone = painterResource(Rds.drawable.ic_chevron_right),
                taille = 18.dp,
                teinte = Muted
            )
        }
    }
}

/**
 * §9.3.5 : « Derniers exports » — comptage REEL du journal Room (etats
 * SUCCEEDED) + date du dernier. Aucune miniature inventee : les metadonnees
 * fichiers ne sont pas journalisees, on affiche la verite comptable.
 */
@Composable
private fun LigneDerniersExports(nombre: Int, dernierTs: Long) {
    Column(modifier = Modifier.fillMaxWidth()) {
        Text(
            stringResource(R.string.dash_exports_recents),
            style = VitrineText.Label,
            color = Muted
        )
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 6.dp)
                .background(Blanc, RoundedCornerShape(18.dp))
                .padding(14.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            IconeVitrine(
                icone = painterResource(Rds.drawable.ic_film),
                taille = 22.dp,
                teinte = Navy
            )
            Column {
                Text(
                    stringResource(R.string.dash_exports_n, nombre),
                    style = VitrineText.BodyStrong,
                    color = Navy
                )
                if (dernierTs > 0) {
                    val date = java.text.DateFormat.getDateInstance(java.text.DateFormat.MEDIUM)
                        .format(java.util.Date(dernierTs))
                    Text(
                        stringResource(R.string.dash_exports_derniere, date),
                        style = VitrineText.Tiny,
                        color = Muted
                    )
                }
            }
        }
    }
}

/** Sync honnete : pastille verte (preuve serveur) / spinner / hors ligne + Reessayer. */
@Composable
private fun LigneSync(syncState: SyncState, onRetry: () -> Unit) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        when (syncState) {
            SyncState.SYNCHRONISE ->
                Box(
                    modifier = Modifier
                        .size(8.dp)
                        .background(VertSucces, CircleShape)
                )
            SyncState.EN_COURS ->
                CircularProgressIndicator(
                    modifier = Modifier.size(12.dp),
                    strokeWidth = 2.dp,
                    color = Color.White
                )
            SyncState.HORS_CONNEXION ->
                Box(
                    modifier = Modifier
                        .size(8.dp)
                        .background(Color(0x99FFFFFF), CircleShape)
                )
        }
        Text(
            stringResource(
                when (syncState) {
                    SyncState.SYNCHRONISE -> R.string.sync_synced
                    SyncState.EN_COURS -> R.string.sync_in_progress
                    SyncState.HORS_CONNEXION -> R.string.sync_offline
                }
            ),
            style = VitrineText.Label,
            color = Blanc80
        )
        if (syncState == SyncState.HORS_CONNEXION) {
            Text(
                stringResource(R.string.sync_retry),
                style = VitrineText.Label,
                color = Color.White,
                modifier = Modifier
                    .clickable(onClick = onRetry)
                    .padding(start = 4.dp)
            )
        }
    }
}

/**
 * D42.32 (Lot 6) : parrainage — ordre impose : titre, phrase, code personnel
 * VISIBLE SANS DEFILEMENT, « Copier mon code », « Partager sur WhatsApp »,
 * progression vers le palier suivant, acces historique. D42.33 : tuile
 * blanche r22 + ombre douce, code OrangeDeep sur OrangeVoile, jauge 4 dp
 * pill (testTags dash_referral_code / dash_referral_gauge intacts).
 */
@Composable
private fun DashboardReferralCard(
    referralCode: String,
    gauge: ReferralGaugeUi?,
    onCopyCode: () -> Unit,
    onShare: () -> Unit,
    onViewFilleuls: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .background(Blanc, RoundedCornerShape(22.dp))
            .padding(18.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Text(
            stringResource(R.string.dash_referral_gifts),
            style = VitrineText.H3,
            color = Navy
        )
        Text(
            stringResource(R.string.ref_intro),
            style = VitrineText.Sub,
            color = Muted
        )
        BlocCodeParrain(referralCode, onCopyCode, onShare)
        if (gauge != null) {
            BarreProgression(
                progression = gauge.progress,
                modifier = Modifier.testTag("dash_referral_gauge")
            )
            Text(
                stringResource(
                    R.string.ref2_sub_label,
                    gauge.within,
                    gauge.target,
                    maxOf(0, gauge.target - gauge.within)
                ),
                style = VitrineText.Tiny,
                color = Muted
            )
        }
        Text(
            stringResource(R.string.dash_view_filleuls),
            style = VitrineText.Tiny.copy(fontWeight = FontWeight.W600),
            color = OrangeDeep,
            modifier = Modifier
                .clickable(onClick = onViewFilleuls)
                .padding(vertical = 6.dp)
        )
    }
}

/** Code visible sans défilement + copie (doux) + partage WhatsApp (filet). */
@Composable
private fun BlocCodeParrain(
    referralCode: String,
    onCopyCode: () -> Unit,
    onShare: () -> Unit
) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text(
            stringResource(R.string.ref_your_code),
            style = VitrineText.Label,
            color = Muted
        )
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(OrangeVoile, RoundedCornerShape(14.dp))
                .padding(vertical = 12.dp),
            contentAlignment = Alignment.Center
        ) {
            Text(
                referralCode.ifBlank { stringResource(R.string.ref_code_pending) },
                style = VitrineText.Num.copy(fontSize = 28.sp),
                color = OrangeDeep,
                modifier = Modifier.testTag("dash_referral_code")
            )
        }
        BoutonSecondaire(
            libelle = stringResource(R.string.ref_copy_mine),
            onClick = onCopyCode,
            doux = true,
            pleineLargeur = true
        )
        OutlinedButton(
            onClick = onShare,
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(50),
            colors = ButtonDefaults.outlinedButtonColors(contentColor = Navy),
            border = androidx.compose.foundation.BorderStroke(1.dp, Line)
        ) {
            Text(stringResource(R.string.ref_share_whatsapp))
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
                color = AmbreAlerte
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
            .background(Bg)
            .padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(
            stringResource(R.string.ref2_title),
            style = VitrineText.H2,
            color = Navy
        )
        Text(
            stringResource(R.string.ref2_invites),
            style = VitrineText.Sub,
            color = Muted
        )
        CarteCodeParrainage(gauge.code)
        CarteJaugeParrainage(gauge)
        ReferralHistoriqueRepliable(gauge.entries)
        CarteRecompenseParrainage()
        // CTA unique de l'écran : partage WhatsApp (réel).
        BoutonPrimaire(
            libelle = stringResource(R.string.ref_share_whatsapp),
            onClick = onShare,
            modifier = Modifier.fillMaxWidth()
        )
    }
}

/** Carte code personnel — même traitement que le dashboard (cohérence). */
@Composable
private fun CarteCodeParrainage(code: String) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .background(Blanc, RoundedCornerShape(22.dp))
            .padding(18.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Text(
            stringResource(R.string.ref2_your_code),
            style = VitrineText.Label,
            color = Muted
        )
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(OrangeVoile, RoundedCornerShape(14.dp))
                .padding(vertical = 12.dp),
            contentAlignment = Alignment.Center
        ) {
            Text(
                code,
                style = VitrineText.Num.copy(fontSize = 28.sp),
                color = OrangeDeep
            )
        }
    }
}

/** Carte progression — jauge serveur R8 (testTag ref2_gauge intouchable). */
@Composable
private fun CarteJaugeParrainage(gauge: ReferralGaugeUi) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .background(Blanc, RoundedCornerShape(22.dp))
            .padding(18.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Text(
            stringResource(R.string.ref2_progress),
            style = VitrineText.Label,
            color = Muted
        )
        // D41 (F2) : jauge R8 — valeurs SERVEUR (converted/rewards), paliers de 5.
        BarreProgression(
            progression = gauge.progress,
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
            style = VitrineText.BodyStrong,
            color = Navy
        )
        Text(
            stringResource(
                R.string.ref2_sub_label,
                gauge.within,
                gauge.target,
                maxOf(0, gauge.target - gauge.within)
            ),
            style = VitrineText.Tiny,
            color = Muted
        )
    }
}

/** Carte récompense du parrainage (paliers serveur). */
@Composable
private fun CarteRecompenseParrainage() {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .background(Blanc, RoundedCornerShape(22.dp))
            .padding(18.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Text(
            stringResource(R.string.ref2_reward_title),
            style = VitrineText.H3,
            color = Navy
        )
        Text(
            stringResource(R.string.ref2_reward_body),
            style = VitrineText.Sub,
            color = Muted
        )
    }
}

/**
 * D42.32 (Lot 6) : historique REPLIABLE — ouvert par defaut, pliable.
 * (Extraction D42.32 : detekt LongMethod sur ReferralScreen.)
 */
@Composable
private fun ReferralHistoriqueRepliable(entries: List<ReferralEntry>) {
    var historiqueReplie by remember { mutableStateOf(false) }
    Text(
        stringResource(
            if (historiqueReplie) R.string.ref2_history_show
            else R.string.ref2_history_hide,
            entries.size
        ),
        style = VitrineText.Tiny.copy(
            fontWeight = FontWeight.W600
        ),
        color = OrangeDeep,
        modifier = Modifier
            .clickable { historiqueReplie = !historiqueReplie }
            .padding(vertical = 6.dp)
    )
    if (!historiqueReplie) {
        ReferralHistorique(entries)
    }
}

/** D41 (detekt LongMethod) : historique des filleuls extrait de ReferralScreen. */
@Composable
private fun ReferralHistorique(entries: List<ReferralEntry>) {
    entries.forEachIndexed { index, entry ->
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .background(Blanc, RoundedCornerShape(18.dp))
                .padding(14.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            // D41 (F2) : historique serveur ANONYMISE — plus de noms inventes
            // cote client (privacy : le serveur n'expose pas l'identite des filleuls).
            IconeVitrine(
                icone = painterResource(
                    if (entry.converted) Rds.drawable.ic_check
                    else Rds.drawable.ic_clock
                ),
                taille = 18.dp,
                teinte = if (entry.converted) VertSucces
                else Muted
            )
            Text(
                stringResource(R.string.ref2_filleul_n, index + 1) + " · " +
                    stringResource(
                        if (entry.converted) R.string.ref2_status_converted
                        else R.string.ref2_status_pending
                    ),
                style = VitrineText.Body,
                color = Navy
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
            .background(Bg)
            .padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Text(
            stringResource(R.string.set_title),
            style = VitrineText.H2,
            color = Navy
        )
        Text(
            stringResource(R.string.set_subtitle),
            style = VitrineText.Sub,
            color = Muted
        )
        // D42.33 : lignes-tuiles du design system (r22, ombre douce, chevron) —
        // comportements réels D41 (F6) inchangés.
        // Compte : ligne informative (aucune navigation — chevron masqué).
        LigneListe(
            titre = stringResource(R.string.set_account),
            meta = accountEmail,
            onClick = {},
            chevron = false
        )
        LigneListe(
            titre = stringResource(R.string.set_language),
            meta = stringResource(R.string.set_language_value, languageLabel),
            onClick = onChangeLanguage
        )
        LigneListe(
            titre = stringResource(R.string.set_referral),
            meta = stringResource(R.string.set_referral_value, referralCode),
            onClick = onViewReferral
        )
        LigneListe(
            titre = stringResource(R.string.set_sector),
            meta = stringResource(R.string.set_sector_value, sectorLabel),
            onClick = onChangeSector
        )
        LigneListe(
            titre = stringResource(R.string.set_consents),
            meta = stringResource(R.string.set_consents_value, consentsCount),
            onClick = onViewConsents
        )
        LigneListe(
            titre = stringResource(R.string.set_storage),
            meta = stringResource(R.string.set_storage_value, storageUsedLabel),
            onClick = onClearRawTakes
        )
        LigneListe(
            titre = stringResource(R.string.set_logout),
            meta = stringResource(R.string.set_logout_value),
            onClick = onLogout
        )
    }
}
