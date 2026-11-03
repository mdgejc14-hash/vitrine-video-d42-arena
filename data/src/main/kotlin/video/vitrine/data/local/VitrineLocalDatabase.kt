package video.vitrine.data.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase

@Database(
    entities = [
        TemplateVersionCache::class,
        EntitlementsCache::class,
        TelemetryOutbox::class,
        ReferralLocal::class,
        GabaritCache::class,
        ExportJournal::class
    ],
    version = 3,
    exportSchema = false
)
abstract class VitrineLocalDatabase : RoomDatabase() {
    abstract fun templateVersions(): TemplateVersionDao
    abstract fun entitlements(): EntitlementsDao
    abstract fun telemetry(): TelemetryDao
    abstract fun referrals(): ReferralDao
    abstract fun gabarits(): GabaritDao
    abstract fun journal(): ExportJournalDao

    companion object {
        /** v1 -> v2 : table additive gabarits_cache (30 gabarits V2.0, seed assets). */
        /** v2 -> v3 : table additive export_journal (reservation/confirmation/compensation). */
        val MIGRATION_2_3 = object : Migration(2, 3) {
            override fun migrate(db: SupportSQLiteDatabase) {
                db.execSQL(
                    "CREATE TABLE IF NOT EXISTS `export_journal` (" +
                        "`exportId` TEXT NOT NULL, " +
                        "`merchantId` TEXT NOT NULL, " +
                        "`state` TEXT NOT NULL, " +
                        "`balanceAfter` INTEGER NOT NULL, " +
                        "`ts` INTEGER NOT NULL, " +
                        "PRIMARY KEY(`exportId`))"
                )
            }
        }

        val MIGRATION_1_2 = object : Migration(1, 2) {
            override fun migrate(db: SupportSQLiteDatabase) {
                db.execSQL(
                    "CREATE TABLE IF NOT EXISTS `gabarits_cache` (" +
                        "`gabaritId` TEXT NOT NULL, " +
                        "`secteur` TEXT NOT NULL, " +
                        "`sectorCode` TEXT NOT NULL, " +
                        "`format` TEXT NOT NULL, " +
                        "`nomFormatAffiche` TEXT NOT NULL, " +
                        "`secteurLibelle` TEXT NOT NULL, " +
                        "`dureeTotaleS` INTEGER NOT NULL, " +
                        "`nombreScenes` INTEGER NOT NULL, " +
                        "`nombrePrises` INTEGER NOT NULL, " +
                        "`ratio` TEXT NOT NULL, " +
                        "`phraseCourte` TEXT NOT NULL, " +
                        "`promesse` TEXT NOT NULL, " +
                        "`rawJson` TEXT NOT NULL, " +
                        "`seededAt` INTEGER NOT NULL, " +
                        "PRIMARY KEY(`gabaritId`))"
                )
            }
        }

        @Volatile
        private var instance: VitrineLocalDatabase? = null

        fun get(context: Context): VitrineLocalDatabase =
            instance ?: synchronized(this) {
                instance ?: Room.databaseBuilder(
                    context.applicationContext,
                    VitrineLocalDatabase::class.java,
                    "vitrine-local.db"
                )
                    .addMigrations(MIGRATION_1_2, MIGRATION_2_3)
                    .build().also { instance = it }
            }
    }
}
