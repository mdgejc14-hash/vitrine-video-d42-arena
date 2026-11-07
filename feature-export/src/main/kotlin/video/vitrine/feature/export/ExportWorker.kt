package video.vitrine.feature.export

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.media3.common.util.UnstableApi
import androidx.media3.common.Effect
import androidx.media3.effect.Presentation
import androidx.media3.transformer.Composition
import androidx.media3.transformer.EditedMediaItem
import androidx.media3.transformer.ExportException
import androidx.media3.transformer.ExportResult
import androidx.media3.transformer.Transformer
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import java.io.File
import kotlin.coroutines.resume
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.suspendCancellableCoroutine
import video.vitrine.ins.effects.ExportSpec
import video.vitrine.ins.effects.ExportVerifier
import video.vitrine.ins.effects.InsExportPipeline
import video.vitrine.ins.effects.CameraMoves
import video.vitrine.ins.effects.DefaultBeatSheet
import video.vitrine.ins.effects.InsSmartLockEffect
import video.vitrine.ins.effects.KineticTypography
import video.vitrine.ins.effects.MotionComposition
import video.vitrine.ins.effects.MotionJson
import video.vitrine.ins.effects.WordClock
import video.vitrine.ins.effects.VerifierPolicy

/**
 * Export H.264 100 % local en tache de fond (T1 : ecran eteint, notification).
 * Ordre impose 5.1 : geometrie -> INS-SMARTLOCK -> finition. Apres export :
 * ExportVerifier (duree/resolution/bitrate REEL/3 images) puis matrice des 3 replis.
 */
@UnstableApi
class ExportWorker(
    private val context: Context,
    params: WorkerParameters
) : CoroutineWorker(context, params) {

    /** Gate natif V2.0 : self-test croise Kotlin/natif avant tout MP4 final. */
    private fun nativeGateOk(): Boolean {
        val guard = video.vitrine.vvguard.NativeGuard
        if (!guard.loaded) return true
        val probe = "vvguard-selftest".toByteArray(Charsets.UTF_8)
        val hex = runCatching { guard.sha256Hex(probe) }.getOrNull() ?: return false
        if (hex.length != 64) return false
        val blob = video.vitrine.core.guard.Vvsh1.pack(
            nonce = ByteArray(12) { it.toByte() },
            cipherWithTag = probe + ByteArray(16),
        )
        return runCatching { guard.checkVvsh1(blob) }.getOrDefault(false)
    }

    /**
     * C06 : point faisant autorite : toute execution sans reservation RESERVED
     * (bouton + gateThen) est refusee, y compris appel direct du worker.
     * C08 : confirmation au succes, compensation idempotente a l'echec definitif,
     * reservation conservee en retry.
     */
    override suspend fun doWork(): Result {
        val exportId = inputData.getString(KEY_EXPORT_ID)
        val db = video.vitrine.data.local.VitrineLocalDatabase.get(context)
        val journal = exportId?.let { db.journal().byId(it) }
        if (exportId == null || journal == null || journal.state != "RESERVED") {
            return Result.failure()
        }
        // D42.18 : promotion en service de premier plan (type dataSync) AVANT
        // l'encodage. Défaut rc8 (run 42377890560) : sans FGS, le job
        // JobScheduler est arrêté au quota ~10 min (raison -512) et media3
        // Transformer, incapable de reprendre à mi-encode, repart de zéro —
        // boucle sans fin pour un gabarit long sur codec lent. C'est aussi la
        // promesse T1 déjà affichée à l'utilisateur (export_t1 : « éteins ton
        // écran, la notification te prévient ») jusqu'ici non tenue.
        // Repli silencieux : si le démarrage FGS est interdit (app passée en
        // arrière-plan avant le lancement du worker, Android 12+), l'export
        // continue en job classique — statu quo antérieur, jamais pire.
        runCatching { setForeground(createExportForegroundInfo(context)) }
            .onFailure {
                android.util.Log.w(
                    TAG_EXPORT,
                    "service de premier plan non démarré (repli job classique) : ${it.message}"
                )
            }
        val outcome = doWorkInner()
        return when (outcome) {
            is Result.Success -> {
                db.journal().setState(exportId, "CONFIRMED", System.currentTimeMillis())
                // Audit D40 (A3/A7) : consommation serveur idempotente (eventId =
                // exportId) + telemetrie locale — la fuite « reinstall = credits
                // infinis » venait de l'absence d'appel a /api/v1/quota/consume.
                video.vitrine.data.api.BackendSync.recordExport(
                    context = context,
                    db = db,
                    baseUrl = BuildConfig.API_BASE_URL,
                    eventId = exportId,
                    gabaritId = inputData.getString(KEY_GABARIT_ID),
                    ok = true,
                    bgmMixed = inputData.getString(KEY_BGM_PATH) != null,
                    token = inputData.getString(KEY_FIREBASE_TOKEN),
                )
                outcome
            }
            is Result.Failure -> {
                val already = db.journal().byId(exportId)?.state == "COMPENSATED"
                if (!already) {
                    db.entitlements().atomicCompensate(
                        journal.merchantId,
                        video.vitrine.core.guard.CreditPolicy.WELCOME_TOTAL
                    )
                    db.journal().setState(exportId, "COMPENSATED", System.currentTimeMillis())
                }
                video.vitrine.data.api.BackendSync.recordExport(
                    context = context,
                    db = db,
                    baseUrl = BuildConfig.API_BASE_URL,
                    eventId = exportId,
                    gabaritId = inputData.getString(KEY_GABARIT_ID),
                    ok = false,
                    bgmMixed = false,
                    token = inputData.getString(KEY_FIREBASE_TOKEN),
                )
                outcome
            }
            else -> outcome
        }
    }

    private suspend fun doWorkInner(): Result {
        if (!nativeGateOk()) return Result.failure()
        val input = inputData.getString(KEY_INPUT) ?: return Result.failure()
        val rotation = inputData.getFloat(KEY_ROTATION, 0f)
        val rank = inputData.getInt(KEY_CLASS_RANK, 3)
            .coerceIn(0, ExportSpec.ExportClass.entries.lastIndex)   // audit D40 (B5)
        val exportClass = ExportSpec.ExportClass.entries[rank]
        // Audit D40 (B9) : saison chaude REELLE (ThermalGate cote activity), plus
        // le false code en dur qui neutralisait la regle T8 (720p classes C/D).
        val hotSeason = inputData.getBoolean(KEY_HOT_SEASON, false)
        var attempt = inputData.getInt(KEY_ATTEMPT, 0)
        val sheet = parseSheet()
        // D41 (F62) : geometrie primaire connue AVANT la boucle — la typographie
        // dimensionne les overlays en pixels REELS de sortie (taille 7,8 % de la
        // largeur, césure CJK, ancrage bas). Le repli tentative 1 en 720p rend
        // la typo legerement plus grande relativement — accepte (tentative rare).
        // D42-P1 : geometrie eventuellement imposee par l'appelant (profil de
        // validation 540x960). Sans ces cles, la geometrie de PRODUCTION est
        // inchangee : la classe d'export decide seule.
        val geometry = geometryDemandee() ?: ExportSpec.geometry(exportClass, hotSeason)
        // D42-F20 : composition et motion sont desormais construites DANS la
        // boucle, avec la geometrie de la TENTATIVE. Avant, elles etaient figees
        // sur la geometrie primaire : le repli portrait 720x1280 re-encodait en
        // 1080x1920 et ne pouvait donc jamais passer le verificateur.
        // Audit D40 (B3) : duree attendue = beat sheet (composition) ou duree
        // REELLE du rush (retriever) — plus l'heuristique taille/1000.
        val expectedMs = expectedDurationMs(input, sheet)
        // Audit D40 (A4) : BGM duckee + SFX du gabarit mixees au rendu.
        // Audit D41 (F59/F60) : profondeur de ducking du GABARIT + duree de
        // composition transmises au mixeur (fade-out musique avant la fin).
        val mixerFactory = audioMixerFactory(expectedMs)

        while (attempt < MAX_ATTEMPTS) {
            val tentative = preparerTentative(sheet, geometry, exportClass, attempt)
            val output = File(context.cacheDir, "export-$attempt.mp4")
            val exported = runAttempt(
                tentative, input, rotation, output, mixerFactory
            )

            if (!exported) {
                val failure = exportFailureResult(attempt)
                if (failure != null) return failure
                attempt++
                continue
            }
            val measurement = ExportVerifier.measure(context, output, expectedMs)
            // D42.8.1 : l'audio est ATTENDU quand une BGM ou des SFX ont ete
            // planifies pour ce rendu (mixerFactory non nul). Sinon la video est
            // muette par construction et l'absence de piste n'est pas un defaut.
            // Sans ce cablage, AudioChecks n'etait appele nulle part et R8 le
            // supprimait : le controle audio du contrat 5.2 n'existait pas dans
            // le binaire livre.
            val checks = ExportVerifier.judge(
                measurement, tentative.geometry, tentative.targetBitrateBps, expectedMs,
                audioAttendu = mixerFactory != null
            )
            // D42 : le verdict doit etre lisible dans logcat. Sans cette ligne,
            // un rejet du verificateur se presentait comme « worker=FAILED »
            // muet et coutait un cycle CI complet par hypothese.
            android.util.Log.i(
                TAG_VERIF,
                "essai=$attempt ${tentative.geometry.width}x${tentative.geometry.height}" +
                    " mesure=$measurement verif=$checks cible=${tentative.targetBitrateBps}" +
                    " attendu=$expectedMs"
            )
            if (checks.passed) {
                setProgress(androidx.work.workDataOf(KEY_PROGRESS to 100))
                // D42.2 : abandonne les bitmaps plein cadre caches par la
                // typographie (jusqu'a 17 Mo en 1080p). Aucun recylage : le
                // renderer Media3 peut encore en detenir une reference.
                KineticTypography.libererCache()
                return Result.success(androidx.work.workDataOf(KEY_OUTPUT to output.absolutePath))
            }
            when (VerifierPolicy.fallbackFor(attempt)) {
                VerifierPolicy.Fallback.CLOUD_MODAL -> {
                    // repli 2 : rendu cloud de secours Modal, upload proxy 480p SEULEMENT
                    return Result.failure(androidx.work.workDataOf(KEY_CLOUD_FALLBACK to true))
                }
                VerifierPolicy.Fallback.EXHAUSTED -> return Result.failure()
                else -> attempt++
            }
        }
        return Result.failure()
    }

    /**
     * Beat sheet unique du rendu (audit D40) : priorite au JSON fourni — depuis
     * l'audit, il porte la STRUCTURE DU GABARIT V2.0 (GabaritBeatSheet : scenes,
     * prises, cartes, textes, SFX), plus seulement un beat sheet de script.
     */
    private suspend fun parseSheet(): MotionJson.BeatSheet? {
        val beatRaw = inputData.getString(KEY_BEAT_SHEET)
        val sheet = when {
            beatRaw != null -> runCatching { MotionJson.parse(beatRaw) }.getOrNull()
            else -> {
                val script = inputData.getString(KEY_SCRIPT)
                val duration = inputData.getInt(KEY_DURATION_S, 0).toDouble()
                if (script != null && duration > 0.0) {
                    DefaultBeatSheet.fromScript(script, duration, emptyList())
                } else null
            }
        }
        if (sheet == null || sheet.plans.isEmpty()) {
            // D41 (F57) : le repli silencieux « script historique » devient visible :
            // un gabarit fourni mais inutilisable est trace dans l'outbox telemetrie.
            if (beatRaw != null) recordFallback("beat_sheet_invalide")
            return null
        }
        val voice = sheet.plans.last().t1
        val problemes = WordClock.validate(sheet.plans, voice)
        if (problemes.isEmpty()) return sheet
        recordFallback("beat_sheet_rejete:" + problemes.first())
        return null
    }

    /** Trace un repli de rendu dans l'outbox (flush Dashboard, jamais bloquant). */
    private suspend fun recordFallback(reason: String) {
        runCatching {
            val db = video.vitrine.data.local.VitrineLocalDatabase.get(context)
            db.telemetry().insert(
                video.vitrine.data.local.TelemetryOutbox(
                    event = "export_fallback_script",
                    gabaritId = reason,
                    ok = true,
                    durationMs = 0L,
                    ctaClicks = 0,
                    ts = java.text.SimpleDateFormat(
                        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", java.util.Locale.US
                    ).apply { timeZone = java.util.TimeZone.getTimeZone("UTC") }
                        .format(java.util.Date())
                )
            )
        }
    }

    /** Geometrie imposee par l'appelant (profil de validation), sinon null. */
    private fun geometryDemandee(): ExportSpec.ExportGeometry? {
        val largeur = inputData.getInt(KEY_OUTPUT_W, 0)
        val hauteur = inputData.getInt(KEY_OUTPUT_H, 0)
        if (largeur <= 0 || hauteur <= 0) return null
        return ExportSpec.ExportGeometry(largeur - largeur % 2, hauteur - hauteur % 2)
    }

    /** Parametres calcules d'une tentative (D42-F18/F19/F20). */
    private data class Tentative(
        val geometry: ExportSpec.ExportGeometry,
        val composition: Composition?,
        val motion: List<Effect>,
        val targetBitrateBps: Int,
        val grain: Boolean
    )

    /**
     * D42-F20 : la geometrie, la composition et la cinematique sont figees par
     * TENTATIVE. Le repli portrait 720x1280 re-encodait auparavant en 1080x1920
     * (composition construite une fois, hors boucle) et ne pouvait jamais passer
     * le verificateur. D42-F19 : le chemin composition n'applique pas le grain
     * (finition non branchee sur ce chemin), il ne reclame donc pas le budget
     * +18 % qui compense le cout du grain a l'encodage.
     */
    private fun preparerTentative(
        sheet: MotionJson.BeatSheet?,
        primaire: ExportSpec.ExportGeometry,
        exportClass: ExportSpec.ExportClass,
        attempt: Int
    ): Tentative {
        val geometry = if (attempt == 1) ExportSpec.repli(primaire) else primaire
        val composition = buildClientComposition(sheet, geometry)
        val grain = attempt < 2 && composition == null
        return Tentative(
            geometry = geometry,
            composition = composition,
            motion = buildMotion(sheet, geometry),
            targetBitrateBps = ExportSpec.exportBitrateBps(exportClass, grainActive = grain),
            grain = grain
        )
    }

    /** Composition multi-rushs client si beat sheet fourni et valide, sinon null.
     *  D41 (F55) : les prises sautees arrivent en slots vides — RushSlots les
     *  remplace par la prise voisine AVANT l'indexation rid du beat sheet. */
    private fun buildClientComposition(
        sheet: MotionJson.BeatSheet?,
        geometry: ExportSpec.ExportGeometry
    ): Composition? {
        val rushes = inputData.getStringArray(KEY_CLIENT_RUSHES)
        // D42.2 — tracabilite : ce que le MOTEUR recoit reellement, et non ce
        // qu'un test recalcule de son cote (piege de mots_beat_sheet > 0).
        android.util.Log.i(
            "D42-TRACE",
            "6.worker mots=${sheet?.words?.size ?: -1} plans=${sheet?.plans?.size ?: -1} " +
                "rushes=${rushes?.size ?: 0}"
        )
        if (rushes.isNullOrEmpty() || sheet == null) return null
        val alignes = video.vitrine.ins.effects.RushSlots.resolve(rushes.toList())
        if (alignes.isEmpty()) return null
        // D42-F17 : la geometrie d'export etait appliquee UNIQUEMENT au chemin
        // mono-rush (InsExportPipeline.buildEffects). En composition multi-rush,
        // la sortie conservait la resolution des rushs du client : un rush 720p
        // sortait en 720p alors que la geometrie annonce 1080x1920, et le
        // verificateur invalidait l'export (run 41595149414).
        // Presentation est place EN TETE : les effets de plan (CameraMoves,
        // KineticTypography) doivent s'appliquer sur le canevas final.
        val cadrage = listOf(
            Presentation.createForWidthAndHeight(
                geometry.width, geometry.height, Presentation.LAYOUT_SCALE_TO_FIT
            ),
            InsSmartLockEffect()
        )
        return MotionComposition.fromClientRushes(
            alignes.map { android.net.Uri.parse(it) },
            sheet,
            cadrage,
            geometry
        )
    }

    /** Cinematique + typographie cinematique pour le rush unique (parcours camera). */
    private fun buildMotion(
        sheet: MotionJson.BeatSheet?,
        geometry: ExportSpec.ExportGeometry
    ): List<Effect> {
        if (sheet == null) return emptyList()
        return sheet.plans.flatMap { plan -> CameraMoves.effectsFor(plan) } +
            KineticTypography.wordOverlays(
                sheet.words, sheet.keywords, geometry.width, geometry.height
            )
    }

    /**
     * BGM + SFX du gabarit (audit D40, A4) : musique decodee depuis le cache
     * definitif BgmStore, SFX depuis les WAV maîtres des assets. null = rendu
     * historique (audio rush traverse seul) — jamais d'echec d'export a cause
     * de l'audio (BgmSfxAudioMixer retombe en pass-through).
     */
    private fun audioMixerFactory(expectedMs: Long): androidx.media3.transformer.AudioMixer.Factory? {
        val music = inputData.getString(KEY_BGM_PATH)?.let { path ->
            video.vitrine.ins.effects.BgmDecoder.decodeMusic(File(path))
        }
        val cues = loadSfxCues(inputData.getString(KEY_SFX_EVENTS))
        if (music == null && cues.isEmpty()) return null
        val duckDb = inputData.getDouble(KEY_DUCK_DB, video.vitrine.ins.effects.MixPlan.DUCK_DEPTH_DB_DEFAULT)
        return video.vitrine.ins.effects.BgmSfxAudioMixer.Factory(
            music,
            cues,
            duckDb,
            expectedMs * 1000L
        )
    }

    private fun loadSfxCues(json: String?): List<video.vitrine.ins.effects.BgmSfxAudioMixer.SfxCue> {
        if (json.isNullOrBlank()) return emptyList()
        return runCatching {
            val array = org.json.JSONArray(json)
            (0 until array.length()).mapNotNull { i ->
                val objet = array.optJSONObject(i) ?: return@mapNotNull null
                val categorie = objet.optString("categorie")
                if (categorie.isBlank()) return@mapNotNull null
                val pcm = video.vitrine.ins.effects.BgmDecoder
                    .readWavAsset(context.assets, "audio/sfx/$categorie.wav")
                    ?: return@mapNotNull null
                video.vitrine.ins.effects.BgmSfxAudioMixer.SfxCue(objet.optLong("at_us"), pcm)
            }
        }.getOrDefault(emptyList())
    }

    private suspend fun runAttempt(
        tentative: Tentative,
        input: String,
        rotation: Float,
        output: File,
        mixerFactory: androidx.media3.transformer.AudioMixer.Factory? = null
    ): Boolean {
        // D42 (D42-F09) : Media3 Transformer doit être CRÉÉ et UTILISÉ sur son
        // thread applicatif. CoroutineWorker exécute doWork sur un dispatcher
        // d'arrière-plan, d'où « Transformer is accessed on the wrong thread »
        // à chaque export — le moteur ne produisait aucun MP4 (constaté sur
        // émulateur, run 41470479121). Le rendu reste asynchrone : le main est
        // suspendu par le listener, jamais bloqué.
        return withContext(Dispatchers.Main.immediate) {
            val transformer = InsExportPipeline.transformer(
                context, mixerFactory, tentative.targetBitrateBps
            )
            if (tentative.composition != null) {
                runExport(transformer, tentative.composition, output.absolutePath)
            } else {
                val effects = InsExportPipeline.buildEffects(
                    rotationDegrees = rotation,
                    geometry = tentative.geometry,
                    smartLock = InsSmartLockEffect(),
                    grainAmount = if (tentative.grain) GRAIN_AMOUNT else 0f,
                    chromaSmoothStrength = if (tentative.grain) CHROMA_STRENGTH else 0f,
                    motion = tentative.motion
                )
                val item = InsExportPipeline.editedMediaItem(android.net.Uri.parse(input), effects)
                runExport(transformer, item, output.absolutePath)
            }
        }
    }

    private fun exportFailureResult(attempt: Int): Result? =
        when (VerifierPolicy.fallbackFor(attempt)) {
            VerifierPolicy.Fallback.CLOUD_MODAL ->
                Result.failure(androidx.work.workDataOf(KEY_CLOUD_FALLBACK to true))
            VerifierPolicy.Fallback.EXHAUSTED -> Result.failure()
            else -> null
        }

    /** Echec rapide via Transformer.Listener : pas d'attente muette en mode demo.
     *  D41 (F24b) : annulation du worker -> transformer.cancel() (avant, le rendu
     *  continuait de tourner en arriere-plan et fuitait codec/CPU). */
    private suspend fun runExport(
        transformer: Transformer,
        item: EditedMediaItem,
        path: String
    ): Boolean =
        suspendCancellableCoroutine { cont ->
            cont.invokeOnCancellation {
                // D42-F09 : cancel() est aussi soumis au contrôle de thread.
                Handler(Looper.getMainLooper()).post { runCatching { transformer.cancel() } }
            }
            transformer.addListener(object : Transformer.Listener {
                override fun onCompleted(composition: Composition, result: ExportResult) {
                    if (cont.isActive) cont.resume(true)
                }

                override fun onError(
                    composition: Composition,
                    result: ExportResult,
                    exception: ExportException
                ) {
                    if (cont.isActive) cont.resume(false)
                }
            })
            transformer.start(item, path)
        }

    private suspend fun runExport(
        transformer: Transformer,
        composition: Composition,
        path: String
    ): Boolean =
        suspendCancellableCoroutine { cont ->
            cont.invokeOnCancellation {
                // D42-F09 : cancel() est aussi soumis au contrôle de thread.
                Handler(Looper.getMainLooper()).post { runCatching { transformer.cancel() } }
            }
            transformer.addListener(object : Transformer.Listener {
                override fun onCompleted(composition: Composition, result: ExportResult) {
                    if (cont.isActive) cont.resume(true)
                }

                override fun onError(
                    composition: Composition,
                    result: ExportResult,
                    exception: ExportException
                ) {
                    if (cont.isActive) cont.resume(false)
                }
            })
            transformer.start(composition, path)
        }

    /**
     * Duree attendue du MP4 final (audit D40, B3) :
     *  1. beat sheet (composition multi-rushs OU structure gabarit) = verite du
     *     montage — tolerance ExportVerifier 500 ms ;
     *  2. sinon duree REELLE du rush d'entree (MediaMetadataRetriever) ;
     *  3. l'ancienne heuristique taille/1000 ne reste qu'un ultime repli.
     */
    private fun expectedDurationMs(path: String, sheet: MotionJson.BeatSheet?): Long {
        if (sheet != null && sheet.plans.isNotEmpty()) {
            return ((sheet.plans.last().t1 - sheet.plans.first().t0) * 1000.0).toLong()
        }
        val retriever = android.media.MediaMetadataRetriever()
        return try {
            if (path.startsWith("content://")) {
                retriever.setDataSource(context, android.net.Uri.parse(path))
            } else {
                retriever.setDataSource(path)
            }
            retriever.extractMetadata(android.media.MediaMetadataRetriever.METADATA_KEY_DURATION)
                ?.toLongOrNull() ?: (File(path).length() / 1000L)
        } catch (erreur: Exception) {
            File(path).length() / 1000L
        } finally {
            retriever.release()
        }
    }

    companion object {
        const val KEY_INPUT = "input"
        const val KEY_EXPORT_ID = "export_id"
        const val KEY_ROTATION = "rotation"
        const val KEY_CLASS_RANK = "class_rank"
        const val KEY_HOT_SEASON = "hot_season"
        const val KEY_ATTEMPT = "attempt"

        /** D42-P1 : geometrie imposee (0 = geometrie de la classe d'export). */
        const val KEY_OUTPUT_W = "output_w"
        const val KEY_OUTPUT_H = "output_h"
        const val KEY_OUTPUT = "output"
        const val KEY_PROGRESS = "progress"
        const val KEY_CLOUD_FALLBACK = "cloud_fallback"
        const val KEY_BEAT_SHEET = "beat_sheet_json"
        const val KEY_DUCK_DB = "duck_depth_db"
        const val KEY_SFX_EVENTS = "sfx_events_json"
        const val KEY_BGM_PATH = "bgm_path"
        const val KEY_GABARIT_ID = "gabarit_id"
        const val KEY_FIREBASE_TOKEN = "firebase_token"
        const val KEY_CLIENT_RUSHES = "client_rushes"
        const val KEY_SCRIPT = "script"
        const val KEY_DURATION_S = "duration_s"
        const val UNIQUE_NAME = "vv-export"
        private const val GRAIN_AMOUNT = 0.02f
        private const val CHROMA_STRENGTH = 0.3f
        private const val MAX_ATTEMPTS = 3
        private const val TAG_VERIF = "D42-VERIF"
    }
}

// ── D42.18 : service de premier plan de l'export (type dataSync) ──────────────
// Top-level et internal pour être testés unitairement sans instancier le worker.

/** Identifiant stable de la notification d'export (et du ForegroundInfo). */
internal const val EXPORT_NOTIF_ID = 4201

/** Canal unique de l'export (« l'appareil peut être verrouillé », T1). */
internal const val EXPORT_CHANNEL_ID = "vv_export"

internal const val EXPORT_CHANNEL_IMPORTANCE = android.app.NotificationManager.IMPORTANCE_LOW

private const val TAG_EXPORT = "D42-EXPORT"

/**
 * ForegroundInfo de l'export : notification ongoing « Export en cours… » sur
 * le canal vv_export, type FOREGROUND_SERVICE_TYPE_DATA_SYNC dès API 29
 * (obligatoire à déclarer sur API 34+ ; permission FOREGROUND_SERVICE_DATA_SYNC
 * posée au manifeste). En-dessous de API 29, forme sans type.
 */
internal fun createExportForegroundInfo(context: android.content.Context): androidx.work.ForegroundInfo {
    ensureExportChannel(context)
    val notification = androidx.core.app.NotificationCompat.Builder(context, EXPORT_CHANNEL_ID)
        .setSmallIcon(R.drawable.ic_stat_export)
        .setContentTitle(context.getString(R.string.export_notif_title))
        .setContentText(context.getString(R.string.export_notif_text))
        .setOngoing(true)
        // Le « % » d'encodage n'est pas encore branché (Transformer n'offre pas
        // de progression exploitable en 1.11.1 sans 2e composant modifié) :
        // barre indéterminée, honnête sur l'état.
        .setProgress(0, 0, true)
        .setOnlyAlertOnce(true)
        .build()
    return if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
        androidx.work.ForegroundInfo(
            EXPORT_NOTIF_ID,
            notification,
            android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC,
        )
    } else {
        androidx.work.ForegroundInfo(EXPORT_NOTIF_ID, notification)
    }
}

/** Crée le canal vv_export si nécessaire (idempotent, requis dès API 26). */
internal fun ensureExportChannel(context: android.content.Context) {
    if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.O) return
    val manager = context.getSystemService(android.app.NotificationManager::class.java) ?: return
    if (manager.getNotificationChannel(EXPORT_CHANNEL_ID) != null) return
    manager.createNotificationChannel(
        android.app.NotificationChannel(
            EXPORT_CHANNEL_ID,
            context.getString(R.string.export_notif_channel_name),
            EXPORT_CHANNEL_IMPORTANCE,
        )
    )
}
