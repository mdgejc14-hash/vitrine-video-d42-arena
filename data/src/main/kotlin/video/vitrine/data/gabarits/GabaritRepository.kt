package video.vitrine.data.gabarits

import android.content.Context
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import video.vitrine.core.model.GabaritSummary
import video.vitrine.core.model.Sector
import video.vitrine.core.model.sectorFromGabaritCode
import video.vitrine.data.local.GabaritCache
import video.vitrine.data.local.GabaritDao

/**
 * Depot des 30 gabarits universels V2.0 : seed unique depuis les assets
 * embarques (data/src/main/assets/gabarits, copies conformes de l'archive
 * Drive), puis lectures 100 % Room = hors-ligne integral (contexte Afrique
 * de l'Ouest : zero requete reseau pour le catalogue).
 */
class GabaritRepository(
    private val context: Context,
    private val dao: GabaritDao
) {

    suspend fun summaries(): List<GabaritSummary> = withContext(Dispatchers.IO) {
        seedIfEmpty()
        dao.all().map { it.toSummary() }
    }

    suspend fun bySector(sector: Sector): List<GabaritSummary> = withContext(Dispatchers.IO) {
        seedIfEmpty()
        if (sector == Sector.TOUS) {
            dao.all().map { it.toSummary() }
        } else {
            dao.bySectorCode(sector.code).map { it.toSummary() }
        }
    }

    /** JSON source integral (D13 : §3.7 tel quel) pour brief/editeur/moteur. */
    suspend fun rawJson(gabaritId: String): String? = withContext(Dispatchers.IO) {
        seedIfEmpty()
        dao.byId(gabaritId)?.rawJson
    }

    private suspend fun seedIfEmpty() {
        // Audit D41 (F48) : le seed ne tournait QUE sur base vide — apres une mise
        // a jour de l'app modifiant les JSON embarques, les anciennes lignes
        // restaient servies indefiniment (gabarits perimes). Re-seed integral a
        // chaque changement de versionCode ; les assets restent la seule verite.
        val version = runCatching {
            val info = context.packageManager.getPackageInfo(context.packageName, 0)
            if (android.os.Build.VERSION.SDK_INT >= 28) info.longVersionCode else @Suppress("DEPRECATION") info.versionCode.toLong()
        }.getOrDefault(0L)
        val prefs = context.getSharedPreferences(SEED_PREFS, Context.MODE_PRIVATE)
        if (dao.count() > 0 && prefs.getLong(KEY_SEED_VERSION, -1L) == version) return
        val now = System.currentTimeMillis()
        val rows = mutableListOf<GabaritCache>()
        val secteurs = context.assets.list(ASSETS_ROOT).orEmpty()
        secteurs.forEach { secteur ->
            context.assets.list("$ASSETS_ROOT/$secteur").orEmpty()
                .filter { it.endsWith(".json") }
                .forEach { file ->
                    runCatching {
                        val raw = context.assets.open("$ASSETS_ROOT/$secteur/$file")
                            .use { it.readBytes() }
                            .decodeToString()
                        GabaritJson.parse(raw).toCache(raw, now)
                    }.onSuccess { rows += it }
                }
        }
        if (rows.isNotEmpty()) {
            dao.clearAll()
            dao.upsertAll(rows)
            prefs.edit().putLong(KEY_SEED_VERSION, version).apply()
        }
    }

    private fun GabaritSummary.toCache(raw: String, seededAt: Long) = GabaritCache(
        gabaritId = id,
        secteur = secteur,
        sectorCode = sectorFromGabaritCode(secteur)?.code ?: secteur,
        format = format,
        nomFormatAffiche = nomFormatAffiche,
        secteurLibelle = secteurLibelle,
        dureeTotaleS = dureeTotaleS,
        nombreScenes = nombreScenes,
        nombrePrises = nombrePrises,
        ratio = ratio,
        phraseCourte = phraseCourte,
        promesse = promesse,
        rawJson = raw,
        seededAt = seededAt
    )

    private fun GabaritCache.toSummary() = GabaritSummary(
        id = gabaritId,
        secteur = secteur,
        secteurLibelle = secteurLibelle,
        format = format,
        nomFormatAffiche = nomFormatAffiche,
        dureeTotaleS = dureeTotaleS,
        nombreScenes = nombreScenes,
        nombrePrises = nombrePrises,
        ratio = ratio,
        phraseCourte = phraseCourte,
        promesse = promesse
    )

    companion object {
        const val ASSETS_ROOT = "gabarits"
        private const val SEED_PREFS = "vv_gabarits"
        private const val KEY_SEED_VERSION = "seed_version"
    }
}
