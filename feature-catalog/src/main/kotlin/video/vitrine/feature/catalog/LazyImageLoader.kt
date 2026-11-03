package video.vitrine.feature.catalog

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.LruCache
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.net.HttpURLConnection
import java.net.URL

/**
 * Chargement paresseux des vignettes B2 : LruCache memoire + HttpURLConnection.
 * Zero dependance (pas de Coil/Glide : hors catalogue epingle du contrat).
 */
object LazyImageLoader {

    private val cache = LruCache<String, Bitmap>(MAX_BYTES)

    suspend fun load(url: String): Bitmap? = withContext(Dispatchers.IO) {
        cache.get(url)?.let { return@withContext it }
        runCatching {
            val connection = URL(url).openConnection() as HttpURLConnection
            connection.connectTimeout = TIMEOUT_MS
            connection.readTimeout = TIMEOUT_MS
            try {
                val bytes = connection.inputStream.use { it.readBytes() }
                BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
            } finally {
                connection.disconnect()
            }
        }.getOrNull()?.also { bitmap ->
            cache.put(url, bitmap)
        }
    }

    private const val MAX_BYTES = 8 * 1024 * 1024
    private const val TIMEOUT_MS = 8_000
}
