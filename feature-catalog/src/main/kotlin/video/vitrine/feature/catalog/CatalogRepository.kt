package video.vitrine.feature.catalog

import android.content.Context
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import video.vitrine.core.model.CatalogManifest
import java.io.File
import java.net.HttpURLConnection
import java.net.URL

/**
 * Catalogue lazy B2 : manifeste telecharge puis mis en cache disque (data couteuse,
 * Afrique de l'Ouest). Hors-ligne : le cache est servi, jamais de blocage reseau.
 * Zero dependance externe : HttpURLConnection + fichier cacheDir.
 */
class CatalogRepository(private val context: Context, private val baseUrl: String) {

    /** Rend (manifeste, horsLigne). Echoue seulement si ni reseau ni cache. */
    suspend fun load(canary: Boolean): Pair<CatalogManifest, Boolean> = withContext(Dispatchers.IO) {
        val file = cacheFile(canary)
        val fresh = runCatching { fetch(canary) }.getOrNull()
        if (fresh != null) {
            runCatching { file.writeText(fresh) }
            CatalogManifestParser.parse(fresh, canary) to false
        } else if (file.exists()) {
            CatalogManifestParser.parse(file.readText(), canary) to true
        } else {
            error("catalog_unavailable_offline")
        }
    }

    private fun fetch(canary: Boolean): String {
        val path = if (canary) "templates/canary/manifest.json" else "templates/manifest.json"
        val connection = URL("$baseUrl/api/v1/$path").openConnection() as HttpURLConnection
        connection.connectTimeout = TIMEOUT_MS
        connection.readTimeout = TIMEOUT_MS
        try {
            if (connection.responseCode != HttpURLConnection.HTTP_OK) error("http_${connection.responseCode}")
            return connection.inputStream.bufferedReader().use { it.readText() }
        } finally {
            connection.disconnect()
        }
    }

    private fun cacheFile(canary: Boolean): File =
        File(context.cacheDir, if (canary) "catalog-canary.json" else "catalog.json")

    private companion object {
        const val TIMEOUT_MS = 8_000
    }
}
