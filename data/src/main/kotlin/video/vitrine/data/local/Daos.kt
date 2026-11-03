package video.vitrine.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Upsert

@Dao
interface TemplateVersionDao {
    @Upsert
    suspend fun upsertAll(rows: List<TemplateVersionCache>)

    @Query("SELECT * FROM template_versions_cache")
    suspend fun all(): List<TemplateVersionCache>

    @Query("DELETE FROM template_versions_cache WHERE fetchedAt < :cutoff")
    suspend fun deleteOlderThan(cutoff: Long)
}

@Dao
interface ExportJournalDao {
    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun insert(entry: ExportJournal): Long

    @Query("SELECT * FROM export_journal WHERE exportId = :id")
    suspend fun byId(id: String): ExportJournal?

    @Query("UPDATE export_journal SET state = :state, ts = :ts WHERE exportId = :id")
    suspend fun setState(id: String, state: String, ts: Long)

    /** D41 (F14) : reservations orphelines (process tue entre debit et enqueue).
     *  Le filtre ts < cutoff evite toute course avec une reservation FRAICHE
     *  (debit -> enqueue en cours sur l'ecran actif). */
    @Query("SELECT * FROM export_journal WHERE state = 'RESERVED' AND ts < :cutoff")
    suspend fun reservedBefore(cutoff: Long): List<ExportJournal>
}

@Dao
interface EntitlementsDao {
    @Upsert
    suspend fun upsert(row: EntitlementsCache)

    @Query("SELECT * FROM entitlements_cache WHERE merchantId = :merchantId")
    suspend fun byMerchant(merchantId: String): EntitlementsCache?

    /** C07 : debit conditionnel atomique ; 0 ligne = solde deja a zero. */
    @Query(
        "UPDATE entitlements_cache SET welcomeCreditsLeft = welcomeCreditsLeft - 1 " +
            "WHERE merchantId = :merchantId AND welcomeCreditsLeft > 0"
    )
    suspend fun atomicDebit(merchantId: String): Int

    /** C08 : compensation conditionnelle atomique (plafond = total seed). */
    @Query(
        "UPDATE entitlements_cache SET welcomeCreditsLeft = welcomeCreditsLeft + 1 " +
            "WHERE merchantId = :merchantId AND welcomeCreditsLeft < :cap"
    )
    suspend fun atomicCompensate(merchantId: String, cap: Int): Int
}

@Dao
interface TelemetryDao {
    @Upsert
    suspend fun insert(row: TelemetryOutbox)

    @Query("SELECT * FROM telemetry_outbox WHERE uploaded = 0 ORDER BY id LIMIT :limit")
    suspend fun pending(limit: Int): List<TelemetryOutbox>

    @Query("UPDATE telemetry_outbox SET uploaded = 1 WHERE id IN (:ids)")
    suspend fun markUploaded(ids: List<Long>)
}

@Dao
interface ReferralDao {
    @Upsert
    suspend fun upsert(row: ReferralLocal)

    @Query("SELECT * FROM referral_local WHERE merchantId = :merchantId")
    suspend fun byMerchant(merchantId: String): ReferralLocal?
}

@Dao
interface GabaritDao {
    @Upsert
    suspend fun upsertAll(rows: List<GabaritCache>)

    @Query("SELECT COUNT(*) FROM gabarits_cache")
    suspend fun count(): Int

    @Query("SELECT * FROM gabarits_cache ORDER BY secteur, format")
    suspend fun all(): List<GabaritCache>

    @Query("SELECT * FROM gabarits_cache WHERE sectorCode = :sectorCode ORDER BY format")
    suspend fun bySectorCode(sectorCode: String): List<GabaritCache>

    @Query("SELECT * FROM gabarits_cache WHERE gabaritId = :gabaritId")
    suspend fun byId(gabaritId: String): GabaritCache?

    /** D41 (F48) : re-seed integral apres mise a jour de l'app (assets = verite). */
    @Query("DELETE FROM gabarits_cache")
    suspend fun clearAll()
}
