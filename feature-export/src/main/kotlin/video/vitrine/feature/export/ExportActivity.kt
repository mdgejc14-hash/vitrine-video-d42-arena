package video.vitrine.feature.export

import android.os.Bundle
import android.widget.Button
import android.widget.ProgressBar
import android.widget.TextView
import androidx.activity.compose.setContent
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import video.vitrine.core.guard.ExportGate
import video.vitrine.core.guard.MonotonicAnchor
import video.vitrine.data.local.VitrineLocalDatabase
import video.vitrine.data.gabarits.GabaritJson
import video.vitrine.data.gabarits.GabaritRepository
import androidx.compose.ui.platform.ComposeView
import video.vitrine.core.designsystem.VitrineActivity
import video.vitrine.core.designsystem.VitrineTheme
import androidx.media3.common.util.UnstableApi
import androidx.work.Constraints
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager

/**
 * Ecran 8 (export) : progression + rappel T1 "vous pouvez eteindre l'ecran".
 * Contraintes WorkManager : aucune (export local), batterie faible evitee.
 */
@UnstableApi
class ExportActivity : VitrineActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // P2 anti-capture (audit 2026-10-31) : preview et export portent
        // l'actif video marchand -> screenshots, screen-record et vignette
        // Recents bloques (FLAG_SECURE). Limite assumee : camera physique.
        window.setFlags(
            android.view.WindowManager.LayoutParams.FLAG_SECURE,
            android.view.WindowManager.LayoutParams.FLAG_SECURE,
        )
        val gabaritId = intent.getStringExtra("gabarit_id")
        // D42 : paramètre de TEST contrôlé (défaut false = comportement production
        // inchangé). Il ne saute que l'ÉCRAN d'aperçu E7, jamais une étape du
        // moteur : la porte d'export, le débit, le worker et le rendu restent
        // identiques. Utilisé par les rendus instrumentés (120 MP4) et par le
        // robot UI qui teste l'aperçu séparément.
        val skipPreview = intent.getBooleanExtra("d42_skip_preview", false)
        if (gabaritId != null && !skipPreview) {
            showPreview(gabaritId)
            return
        }
        initExportUi()
    }

    /** E7 : apercu plein ecran pilote gabarit ; "Creer ma video" bascule vers E8. */
    private fun showPreview(gabaritId: String) {
        val composeView = ComposeView(this)
        setContentView(composeView)
        lifecycleScope.launch {
            val repo = GabaritRepository(this@ExportActivity, VitrineLocalDatabase.get(this@ExportActivity).gabarits())
            val raw = runCatching { repo.rawJson(gabaritId) }.getOrNull()
            val summary = raw?.let { runCatching { GabaritJson.parse(it) }.getOrNull() }
            val rows = raw?.let {
                runCatching { GabaritJson.parseCheckRows(it) }.getOrDefault(emptyList())
            }.orEmpty()
            val values = mutableMapOf<String, String>()
            rows.forEach { (id, _) ->
                intent.getStringExtra("brief_$id")?.let { v -> values[id] = v }
            }
            val texts = raw?.let {
                runCatching { GabaritJson.parsePreviewTexts(it, values) }.getOrDefault(emptyList())
            }.orEmpty()
            composeView.setContent {
                VitrineTheme {
                    VideoPreviewScreen(
                        sectorLabel = summary?.secteurLibelle.orEmpty(),
                        formatLabel = summary?.nomFormatAffiche.orEmpty(),
                        previewTexts = texts,
                        checkRows = rows,
                        values = values,
                        onCreate = { initExportUi() },
                    )
                }
            }
        }
    }

    private fun initExportUi() {
        setContentView(R.layout.activity_export)
        findViewById<TextView>(R.id.export_status).setText(R.string.export_t1)
        findViewById<Button>(R.id.export_start).setOnClickListener { enqueue() }

        val script = intent.getStringExtra("script").orEmpty()
        val durationS = intent.getIntExtra("duration_s", 30)
        val clientRushes = intent.getStringArrayExtra("client_rushes")?.size ?: 0
        findViewById<ComposeView>(R.id.export_preview_panel).setContent {
            VitrineTheme {
                ExportPreviewPanel(
                    script = script,
                    durationS = durationS,
                    clientRushCount = clientRushes,
                    cameraRushCount = 0,
                )
            }
        }
        reconcileOrphelines()
    }

    /**
     * Audit D41 (F14, P1) : reservations orphelines. Un process tue entre le
     * debit local (gateThen) et l'enqueue WorkManager laissait une ligne
     * RESERVED jamais confirmee ni compensee = credit perdu. Au demarrage de
     * l'ecran, toute reservation RESERVED sans travail export actif est
     * compensee (idempotent : le worker exige RESERVED et ne tourne pas).
     */
    private fun reconcileOrphelines() {
        lifecycleScope.launch(kotlinx.coroutines.Dispatchers.IO) {
            runCatching {
                val enCours = WorkManager.getInstance(this@ExportActivity)
                    .getWorkInfosForUniqueWork(ExportWorker.UNIQUE_NAME).get()
                    .any { !it.state.isFinished }
                if (enCours) return@runCatching
                val db = VitrineLocalDatabase.get(this@ExportActivity)
                val cutoff = System.currentTimeMillis() - ORPHELINE_AGE_MS
                db.journal().reservedBefore(cutoff).forEach { entree ->
                    db.entitlements().atomicCompensate(
                        entree.merchantId,
                        video.vitrine.core.guard.CreditPolicy.WELCOME_TOTAL
                    )
                    db.journal().setState(entree.exportId, "COMPENSATED", System.currentTimeMillis())
                }
            }
        }
    }

    /* ----- Audit D40 : preparation gabarit -> moteur (A4/A5/B3/B9) ----- */

    private var pendingBeatSheet: String? = null
    private var pendingSfxJson: String? = null
    private var pendingBgmPath: String? = null
    private var pendingHotSeason: Boolean = false
    private var pendingRank: Int = 3
    private var pendingDuckDb: Double? = null

    /** Audit D41 (F14) : garde anti-reentrance du debit (double-tap Exporter). */
    private var gateInFlight = false

    private fun inputPairs(input: String): Array<Pair<String, Any>> {
        val pairs = mutableListOf<Pair<String, Any>>(
            ExportWorker.KEY_INPUT to input,
            ExportWorker.KEY_EXPORT_ID to (pendingExportId ?: "sans-reservation"),
            ExportWorker.KEY_ROTATION to intent.getFloatExtra("rotation", 0f),
            ExportWorker.KEY_CLASS_RANK to intent.getIntExtra("class_rank", pendingRank),
            ExportWorker.KEY_HOT_SEASON to pendingHotSeason
        )
        intent.getStringArrayExtra("client_rushes")
            ?.takeIf { it.isNotEmpty() }
            ?.let { pairs += ExportWorker.KEY_CLIENT_RUSHES to it }
        // D42-P1 : profil de validation (geometrie imposee). Absent en production.
        val largeur = intent.getIntExtra(ExportWorker.KEY_OUTPUT_W, 0)
        val hauteur = intent.getIntExtra(ExportWorker.KEY_OUTPUT_H, 0)
        if (largeur > 0 && hauteur > 0) {
            pairs += ExportWorker.KEY_OUTPUT_W to largeur
            pairs += ExportWorker.KEY_OUTPUT_H to hauteur
        }
        intent.getStringExtra("script")?.let { pairs += ExportWorker.KEY_SCRIPT to it }
        val duration = intent.getIntExtra("duration_s", 0)
        if (duration > 0) pairs += ExportWorker.KEY_DURATION_S to duration
        pendingBeatSheet?.let { pairs += ExportWorker.KEY_BEAT_SHEET to it }
        pendingSfxJson?.let { pairs += ExportWorker.KEY_SFX_EVENTS to it }
        pendingBgmPath?.let { pairs += ExportWorker.KEY_BGM_PATH to it }
        intent.getStringExtra("gabarit_id")?.let { pairs += ExportWorker.KEY_GABARIT_ID to it }
        intent.getStringExtra("firebase_token")?.let { pairs += ExportWorker.KEY_FIREBASE_TOKEN to it }
        pendingDuckDb?.let { pairs += ExportWorker.KEY_DUCK_DB to it }
        return pairs.toTypedArray()
    }

    /**
     * Construit le beat sheet depuis le gabarit V2.0 (scenes, decoupage_prises,
     * textes, SFX) et reserve la BGM du cache definitif (BgmStore). Tout echec
     * reste silencieux : l'export retombe sur le chemin historique (script).
     */
    private suspend fun prepareGabaritPipeline() {
        pendingHotSeason = hotSeasonNow()
        pendingRank = intent.getIntExtra("class_rank", deviceRank())
        val gabaritId = intent.getStringExtra("gabarit_id") ?: return
        val repo = GabaritRepository(this, VitrineLocalDatabase.get(this).gabarits())
        val raw = runCatching { repo.rawJson(gabaritId) }.getOrNull() ?: return
        val values = mutableMapOf<String, String>()
        intent.getStringArrayExtra("brief_keys")?.forEach { k ->
            intent.getStringExtra("brief_$k")?.let { values[k] = it }
        }
        val rushes = intent.getStringArrayExtra("client_rushes")?.toList().orEmpty()
        // D42 — contexte marchand : langue courante (VitrineLocale est appliquee
        // dans attachBaseContext) + dictionnaire embarque des contenus
        // commerciaux. Aucune modification des JSON canoniques.
        val langue = video.vitrine.core.designsystem.VitrineLocale.saved(this) ?: "fr"
        val l10n = runCatching {
            assets.open(I18N_ASSET).bufferedReader().use { it.readText() }
        }.mapCatching { video.vitrine.data.i18n.GabaritL10n.parse(it) }.getOrNull()
        // E5 : le badge n'est rendu QUE s'il est reellement selectionne.
        val badgeCode = values[CHAMP_BADGE]?.takeIf { it.isNotBlank() && it != "false" }
        val doc = runCatching {
            video.vitrine.data.gabarits.GabaritBeatSheet.build(
                raw,
                values,
                measureDurations(rushes).takeIf { it.isNotEmpty() },
                localiser = { l10n?.resolve(it, langue) ?: it },
                badgeTexte = l10n?.badge(badgeCode, langue)
            )
        }.getOrNull() ?: return
        pendingBeatSheet = doc.beatSheetJson
        pendingSfxJson = doc.sfxEventsJson.takeIf { doc.sfxEvents.isNotEmpty() }
        // D41 (F59) : profondeur de ducking lue dans audio.mix du gabarit.
        pendingDuckDb = doc.duckingDb
        val store = video.vitrine.data.audio.BgmStore(this, BuildConfig.API_BASE_URL)
        val token = intent.getStringExtra("firebase_token")
        pendingBgmPath = runCatching {
            (doc.bgmCategorie?.let { store.localFile(it) }
                ?: (token?.let { store.ensureGabaritCached(gabaritId, it) }))?.absolutePath
        }.getOrNull()
    }

    /** Classe appareil MESUREE (DeviceProfiler) : A=0 .. D=3 (B9). */
    private fun deviceRank(): Int = runCatching {
        val profiler = video.vitrine.ins.capture.DeviceProfiler(this)
        video.vitrine.ins.capture.DeviceProfiler.provisionalClass(profiler.profile()).ordinal
    }.getOrDefault(3)

    /** Saison chaude = marge thermique predite > 0,70 (ThermalGate, API 29+). */
    private fun hotSeasonNow(): Boolean = runCatching {
        if (android.os.Build.VERSION.SDK_INT < 29) return false
        val power = getSystemService(android.content.Context.POWER_SERVICE) as android.os.PowerManager
        video.vitrine.ins.thermal.ThermalGate.decide(power.getThermalHeadroom(30)) !=
            video.vitrine.ins.thermal.ThermalLevel.OK
    }.getOrDefault(false)

    /** Durees reelles des rushs (MediaMetadataRetriever) ; 0.0 si illisible. */
    private fun measureDurations(paths: List<String>): List<Double> = paths.map { path ->
        val retriever = android.media.MediaMetadataRetriever()
        try {
            if (path.startsWith("content://")) {
                retriever.setDataSource(this, android.net.Uri.parse(path))
            } else {
                retriever.setDataSource(path)
            }
            (retriever.extractMetadata(android.media.MediaMetadataRetriever.METADATA_KEY_DURATION)
                ?.toLongOrNull() ?: 0L) / 1000.0
        } catch (erreur: Exception) {
            0.0
        } finally {
            retriever.release()
        }
    }

    /**
     * Porte V2.0 : credits locaux Room (miroir offline), ancre monotone,
     * integrite APK. 0 credit = aucun enqueue WorkManager, message paywall.
     */
    private var pendingExportId: String? = null

    private fun gateThen(block: suspend () -> Unit) {
        lifecycleScope.launch {
            // D41 (F14, P1) : double-tap = double debit local, le 2e travail etant
            // jete par ExistingWorkPolicy.KEEP -> credit perdu. Garde stricte :
            // un seul debit en vol, bouton desactive jusqu'au verdict de la porte.
            if (gateInFlight) return@launch
            gateInFlight = true
            findViewById<Button>(R.id.export_start).isEnabled = false
            val anchor = avancerAncreMurale()
            val db = VitrineLocalDatabase.get(this@ExportActivity)
            val uid = getSharedPreferences("vv_session", MODE_PRIVATE)
                .getString("uid", "demo") ?: "demo"
            val reservation = reserverCredit(db, uid)
            val integrityOk = IntegrityGuard.isOk(this@ExportActivity, BuildConfig.VV_APK_SHA256)
            when (
                ExportGate.decide(reservation.credits, anchor.rollbackDetected, integrityOk)
            ) {
                ExportGate.Decision.ALLOW -> {
                    pendingExportId = reservation.exportId
                    block()
                }
                ExportGate.Decision.DENY_NO_CREDIT -> {
                    deny(R.string.export_gate_no_credit)
                    // D13 : paywall a epuisement — le debit bloque ouvre l'ecran des
                    // forfaits (intent implicite interne, graphe module respecte).
                    runCatching {
                        startActivity(
                            android.content.Intent("video.vitrine.action.VIEW_PAYWALL")
                                .setPackage(packageName)
                                .putExtra("view", "paywall")
                        )
                    }
                }
                // D41 (F14) : la porte decide rollback/integrite AVANT les credits —
                // si le debit local avait reussi, le refus doit le compenser
                // (jamais de credit consomme sans export possible).
                ExportGate.Decision.DENY_ROLLBACK -> {
                    if (reservation.credits == 1) compenserReservation(db, reservation.exportId)
                    deny(R.string.export_gate_rollback)
                }
                ExportGate.Decision.DENY_INTEGRITY -> {
                    if (reservation.credits == 1) compenserReservation(db, reservation.exportId)
                    deny(R.string.export_gate_integrity)
                }
            }
        }
    }

    /** Ancre MURALE v2 (audit D40 B2) : elapsedRealtime() remis a zero a chaque
     *  reboot provoquait un faux DENY_ROLLBACK bloquant l'export. */
    private fun avancerAncreMurale(): video.vitrine.core.guard.MonotonicAnchor.ResultV2 {
        val prefs = getSharedPreferences("vv_guard", MODE_PRIVATE)
        val anchor = MonotonicAnchor.advanceV2(
            prefs.getLong("anchor_wall_ms", 0L),
            System.currentTimeMillis(),
        )
        prefs.edit().putLong("anchor_wall_ms", anchor.anchorWallMs).apply()
        return anchor
    }

    /** Reservation locale : seed eventuel du miroir, debit atomique, journal. */
    private data class Reservation(val credits: Int, val exportId: String)

    private suspend fun reserverCredit(
        db: VitrineLocalDatabase,
        uid: String
    ): Reservation {
        val journalDao = db.journal()
        val existing = db.entitlements().byMerchant(uid)
        val grantCached = java.io.File(cacheDir, "welcome-grant.state").exists()
        val seeded = video.vitrine.core.guard.CreditPolicy.seedDecision(
            existingRow = existing?.welcomeCreditsLeft,
            serverGrantCached = grantCached,
            fingerprintKnown = grantCached,
        )
        if (existing == null) {
            db.entitlements().upsert(
                video.vitrine.data.local.EntitlementsCache(
                    merchantId = uid,
                    watermark = true,
                    endcardMention = true,
                    maxRes = "720p",
                    exportsLimit = 1,
                    fairUse = null,
                    cloudRenders = 0,
                    brandKit = false,
                    cacheDays = 30,
                    welcomeCreditsLeft = seeded,
                    welcomeCloudLeft = 0,
                    fetchedAt = System.currentTimeMillis(),
                )
            )
        }
        val exportId = java.util.UUID.randomUUID().toString()
        val debited = db.entitlements().atomicDebit(uid)
        val credits = if (debited == 1) {
            journalDao.insert(
                video.vitrine.data.local.ExportJournal(
                    exportId = exportId,
                    merchantId = uid,
                    state = "RESERVED",
                    balanceAfter = (db.entitlements().byMerchant(uid)?.welcomeCreditsLeft) ?: 0,
                    ts = System.currentTimeMillis(),
                )
            )
            1
        } else {
            0
        }
        return Reservation(credits, exportId)
    }

    private fun deny(messageRes: Int) {
        findViewById<ProgressBar>(R.id.export_progress).visibility = android.view.View.GONE
        findViewById<TextView>(R.id.export_status).setText(messageRes)
        // D41 : refus de la porte = bouton rendu a l'utilisateur (etat honnete).
        gateInFlight = false
        findViewById<Button>(R.id.export_start).isEnabled = true
    }

    private fun enqueue() {
        gateThen {
            prepareGabaritPipeline()
            enqueueNow()
        }
    }

    private fun enqueueNow() {
        val input = intent.getStringExtra("input")
        val dejaEnCours = runCatching {
            WorkManager.getInstance(this)
                .getWorkInfosForUniqueWork(ExportWorker.UNIQUE_NAME).get()
                .any { !it.state.isFinished }
        }.getOrDefault(false)
        if (input == null || dejaEnCours) {
            // D41 (F14) : le debit a eu lieu — si rien ne peut etre enqueued,
            // compensation IMMEDIATE (jamais de credit consomme sans export).
            lifecycleScope.launch(kotlinx.coroutines.Dispatchers.IO) {
                compenserReservation(
                    VitrineLocalDatabase.get(this@ExportActivity),
                    pendingExportId
                )
            }
            if (input == null) {
                deny(R.string.export_input_missing)
            } else {
                findViewById<TextView>(R.id.export_status).setText(R.string.export_running)
                observeExport()
            }
            return
        }
        val request = OneTimeWorkRequestBuilder<ExportWorker>()
            .setInputData(androidx.work.workDataOf(*inputPairs(input)))
            .setConstraints(Constraints.Builder().setRequiresBatteryNotLow(true).build())
            .build()
        WorkManager.getInstance(this)
            .enqueueUniqueWork(ExportWorker.UNIQUE_NAME, androidx.work.ExistingWorkPolicy.KEEP, request)
        findViewById<ProgressBar>(R.id.export_progress).isIndeterminate = true
        findViewById<TextView>(R.id.export_status).setText(R.string.export_running)
        observeExport()
    }

    /** Compensation idempotente d'une reservation (etat REQUIRE = RESERVED). */
    private suspend fun compenserReservation(
        db: VitrineLocalDatabase,
        exportId: String?
    ) {
        if (exportId == null) return
        val entree = runCatching { db.journal().byId(exportId) }.getOrNull() ?: return
        if (entree.state != "RESERVED") return
        db.entitlements().atomicCompensate(
            entree.merchantId,
            video.vitrine.core.guard.CreditPolicy.WELCOME_TOTAL
        )
        db.journal().setState(exportId, "COMPENSATED", System.currentTimeMillis())
    }

    /**
     * C16 (audit final) : suivi reel du travail — avant ce correctif, l'ecran
     * restait sur « export en cours » pour toujours (aucun retour succes/echec,
     * aucun partage). D19 : parcours complet validable, aucun cul-de-sac.
     */
    private fun observeExport() {
        WorkManager.getInstance(this)
            .getWorkInfosForUniqueWorkLiveData(ExportWorker.UNIQUE_NAME)
            .observe(this) { infos ->
                val info = infos.lastOrNull() ?: return@observe
                when {
                    info.state.isFinished && info.state == androidx.work.WorkInfo.State.SUCCEEDED -> {
                        val path = info.outputData.getString(ExportWorker.KEY_OUTPUT)
                        findViewById<ProgressBar>(R.id.export_progress).visibility = android.view.View.GONE
                        findViewById<TextView>(R.id.export_status).setText(R.string.export_done)
                        findViewById<Button>(R.id.export_start).visibility = android.view.View.GONE
                        val share = findViewById<Button>(R.id.export_share)
                        share.visibility = android.view.View.VISIBLE
                        share.setOnClickListener { path?.let { p -> shareVideo(p) } }
                        val space = findViewById<Button>(R.id.export_space)
                        space.visibility = android.view.View.VISIBLE
                        space.setOnClickListener { openSpace() }
                    }
                    info.state.isFinished -> {
                        findViewById<ProgressBar>(R.id.export_progress).visibility = android.view.View.GONE
                        findViewById<TextView>(R.id.export_status).setText(R.string.export_failed_ui)
                        // D41 : echec = credit compense par le worker ; l'utilisateur
                        // peut relancer (bouton rendu, garde liberee).
                        gateInFlight = false
                        findViewById<Button>(R.id.export_start).isEnabled = true
                    }
                    else -> Unit
                }
            }
    }

    private fun shareVideo(path: String) {
        val file = java.io.File(path)
        if (!file.exists()) return
        val uri = androidx.core.content.FileProvider.getUriForFile(
            this,
            "$packageName.fileprovider",
            file
        )
        val send = android.content.Intent(android.content.Intent.ACTION_SEND).apply {
            type = "video/mp4"
            putExtra(android.content.Intent.EXTRA_STREAM, uri)
            addFlags(android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        startActivity(android.content.Intent.createChooser(send, getString(R.string.export_share)))
    }

    private fun openSpace() {
        runCatching {
            startActivity(
                android.content.Intent("video.vitrine.action.VIEW_DASHBOARD")
                    .setPackage(packageName)
            )
        }
    }

    private companion object {
        /** Age au-dela duquel une reservation RESERVED sans travail actif est
         *  consideree orpheline (process tue) — jamais une reservation fraiche. */
        const val ORPHELINE_AGE_MS = 120_000L

        /** D42 : dictionnaire des contenus commerciaux (assets merges de :data). */
        const val I18N_ASSET = "i18n/gabarit_l10n_v1.json"

        /** E5 : champ de saisie du badge d'engagement. */
        const val CHAMP_BADGE = "badge_engagement_actif"
    }
}
