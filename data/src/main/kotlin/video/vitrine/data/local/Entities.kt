package video.vitrine.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey

/** Cache local des versions de gabarits (miroir de template_versions, migration 0004). */
@Entity(tableName = "template_versions_cache")
data class TemplateVersionCache(
    @PrimaryKey val id: String,
    val latestVersion: String,
    val minAppVersion: String,
    val sha256: String,
    val publishedAt: String,
    val fetchedAt: Long
)

/** Cache local des droits (miroir de entitlements + welcome_grants, migration 0005). */
@Entity(tableName = "entitlements_cache")
data class EntitlementsCache(
    @PrimaryKey val merchantId: String,
    val watermark: Boolean,
    val endcardMention: Boolean,
    val maxRes: String,
    val exportsLimit: Int,
    val fairUse: Int?,
    val cloudRenders: Int,
    val brandKit: Boolean,
    val cacheDays: Int,
    val welcomeCreditsLeft: Int,
    val welcomeCloudLeft: Int,
    val fetchedAt: Long
)

/** File d'envoi telemetrie hors-ligne (miroir de telemetry_events, batch <= 200). */
@Entity(tableName = "telemetry_outbox")
data class TelemetryOutbox(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val event: String,
    val gabaritId: String?,
    val ok: Boolean,
    val durationMs: Long,
    val ctaClicks: Int,
    val ts: String,
    val uploaded: Boolean = false
)

/** Etat parrainage R8 local (miroir de referrals, migration 0007). */
@Entity(tableName = "referral_local")
data class ReferralLocal(
    @PrimaryKey val merchantId: String,
    val referralCode: String?,
    val referredTotal: Int,
    val referredConverted: Int,
    val updatedAt: Long
)

/** Cache local des 30 gabarits universels V2.0 (seed assets, source Drive content/gabarits_v2). */
@Entity(tableName = "gabarits_cache")
data class GabaritCache(
    @PrimaryKey val gabaritId: String,
    val secteur: String,
    val sectorCode: String,
    val format: String,
    val nomFormatAffiche: String,
    val secteurLibelle: String,
    val dureeTotaleS: Int,
    val nombreScenes: Int,
    val nombrePrises: Int,
    val ratio: String,
    val phraseCourte: String,
    val promesse: String,
    val rawJson: String,
    val seededAt: Long
)

/** Journal transactionnel des exports locaux (VV Remote QA s6) : reservation,
 *  confirmation, compensation idempotente par export_id. */
@Entity(tableName = "export_journal")
data class ExportJournal(
    @PrimaryKey val exportId: String,
    val merchantId: String,
    val state: String,
    val balanceAfter: Int,
    val ts: Long
)

/**
 * D42.27 (§7) — BROUILLON de projet inter-sessions (offline-first).
 * UN seul brouillon actif (id=1) : le parcours courant gagne (documenté —
 * le dialogue de reprise tranche au démarrage avant tout nouveau parcours).
 * etape = BRIEF (saisie en cours) puis CAMERA (brief validé + prises).
 * Les rushs référencés vivent déjà dans filesDir/rushes (persistants, D41/F50) :
 * le brouillon n'est QUE l'index du projet, jamais une copie des fichiers.
 */
@Entity(tableName = "project_draft")
data class DraftEntity(
    @PrimaryKey val id: Int = 1,
    val etape: String,
    val gabaritId: String,
    val skinId: String? = null,
    val skinName: String? = null,
    val briefValuesJson: String = "{}",
    val script: String? = null,
    val durationS: Int = 0,
    val objective: String? = null,
    val scenes: String? = null,
    val clientRushesJson: String? = null,
    val priseFilesJson: String? = null,
    val priseIdx: Int = 0,
    val createdAt: Long = 0,
    val updatedAt: Long = 0
)
