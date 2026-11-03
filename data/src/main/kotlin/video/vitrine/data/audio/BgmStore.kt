package video.vitrine.data.audio

import android.content.Context
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.net.HttpURLConnection
import java.net.URL

/**
 * Cache DEFINITIF des musiques de fond (BGM) sur le téléphone.
 *
 * Contrat (docs/AUDIO_BGM_TELEVERSEMENT.md §5) : le Worker distribue chaque
 * morceau sur une URL stable `/api/v1/audio/track/{categorie_audio}` avec
 * `Cache-Control: public, max-age=2592000, immutable`. Un morceau n'est donc
 * téléchargé QU'UNE FOIS dans `files/bgm/` (pas `cacheDir` : le cache définitif
 * survit au vidage du cache système), puis servi hors-ligne pour toujours —
 * la donnée coûte cher en Afrique de l'Ouest.
 *
 * Zéro dépendance externe : HttpURLConnection + fichiers (style maison).
 * Le prefetch est fire-and-forget : JAMAIS bloquant pour la navigation (D19/D22)
 * et silencieux hors-ligne (repli : réessayé à la prochaine sélection).
 */
class BgmStore(private val context: Context, private val baseUrl: String) {

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    /** Fichier morceau déjà en cache définitif (m4a ou mp3), null sinon. */
    fun localFile(categorieAudio: String): File? =
        EXTENSIONS
            .map { File(dir(), "$categorieAudio.$it") }
            .firstOrNull { it.isFile && it.length() > 0L }

    /** Prefetch d'arrière-plan du morceau du gabarit choisi (sélection catalogue). */
    fun prefetchForGabarit(gabaritId: String, token: String?) {
        if (token.isNullOrBlank()) return
        scope.launch {
            runCatching { ensureGabaritCached(gabaritId, token) }
        }
    }

    /** Retourne le fichier local du morceau du gabarit ; le télécharge si absent. */
    suspend fun ensureGabaritCached(gabaritId: String, token: String): File? =
        withContext(Dispatchers.IO) {
            val frais = fetchCatalogJson(token)
            val pistes = BgmCatalogParser.parse(frais ?: cachedCatalogJson())
            val piste = pistes.firstOrNull { it.gabaritId == gabaritId }
                ?: return@withContext null
            localFile(piste.categorieAudio) ?: downloadTrack(piste.categorieAudio, token)
        }

    private fun dir(): File = File(context.filesDir, "bgm").apply { mkdirs() }

    private fun catalogFile(): File = File(dir(), "catalog.json")

    private fun fetchCatalogJson(token: String): String? =
        httpGet("$baseUrl/api/v1/audio/catalog", token)
            ?.also { json -> runCatching { catalogFile().writeText(json) } }

    private fun cachedCatalogJson(): String? =
        catalogFile()
            .takeIf { it.isFile }
            ?.let { runCatching { it.readText() }.getOrNull() }

    private fun downloadTrack(categorieAudio: String, token: String): File? {
        val connection = open("$baseUrl/api/v1/audio/track/$categorieAudio", token)
            ?: return null
        return try {
            if (connection.responseCode != HttpURLConnection.HTTP_OK) return null
            val extension =
                if ((connection.contentType ?: "").contains("mpeg")) "mp3" else "m4a"
            val temp = File(dir(), "$categorieAudio.part")
            temp.outputStream().use { sortie -> connection.inputStream.copyTo(sortie) }
            val attendue = connection.contentLengthLong
            val complete = temp.length() > 0L && (attendue <= 0L || temp.length() == attendue)
            if (!complete || !temp.renameTo(File(dir(), "$categorieAudio.$extension"))) {
                temp.delete()
                return null
            }
            File(dir(), "$categorieAudio.$extension")
        } catch (erreur: java.io.IOException) {
            File(dir(), "$categorieAudio.part").delete()
            null
        } finally {
            connection.disconnect()
        }
    }

    private fun httpGet(url: String, token: String): String? {
        val connection = open(url, token) ?: return null
        return try {
            if (connection.responseCode != HttpURLConnection.HTTP_OK) {
                null
            } else {
                connection.inputStream.bufferedReader().use { it.readText() }
            }
        } catch (erreur: java.io.IOException) {
            null
        } finally {
            connection.disconnect()
        }
    }

    private fun open(url: String, token: String): HttpURLConnection? =
        runCatching {
            (URL(url).openConnection() as HttpURLConnection).apply {
                connectTimeout = TIMEOUT_MS
                readTimeout = TIMEOUT_MS
                setRequestProperty("Authorization", "Bearer $token")
            }
        }.getOrNull()

    private companion object {
        const val TIMEOUT_MS = 15_000
        val EXTENSIONS = listOf("m4a", "mp3")
    }
}
