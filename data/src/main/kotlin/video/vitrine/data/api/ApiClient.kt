package video.vitrine.data.api

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.net.HttpURLConnection
import java.net.URL

/**
 * Client HTTP minimal (zero dependance) : JSON + Bearer JWT Firebase.
 * Timeouts courts (data couteuse), aucun retry automatique (rejeu offline via Room/outbox).
 */
class ApiClient(private val baseUrl: String) {

    data class Reply(val status: Int, val body: String)

    suspend fun get(path: String, token: String?): Reply? = withContext(Dispatchers.IO) {
        request("GET", path, token, null)
    }

    suspend fun post(path: String, token: String?, jsonBody: String): Reply? = withContext(Dispatchers.IO) {
        request("POST", path, token, jsonBody)
    }

    private fun request(method: String, path: String, token: String?, jsonBody: String?): Reply? =
        runCatching {
            val connection = URL(baseUrl + path).openConnection() as HttpURLConnection
            connection.requestMethod = method
            connection.connectTimeout = TIMEOUT_MS
            connection.readTimeout = TIMEOUT_MS
            connection.setRequestProperty("Accept", "application/json")
            if (token != null) connection.setRequestProperty("Authorization", "Bearer $token")
            if (jsonBody != null) {
                connection.setRequestProperty("Content-Type", "application/json")
                connection.doOutput = true
                connection.outputStream.use { it.write(jsonBody.toByteArray(Charsets.UTF_8)) }
            }
            val status = connection.responseCode
            val stream = if (status in 200..299) connection.inputStream else connection.errorStream
            val body = stream?.bufferedReader()?.use { it.readText() } ?: ""
            connection.disconnect()
            Reply(status, body)
        }.getOrNull()

    private companion object {
        const val TIMEOUT_MS = 8_000
    }
}
