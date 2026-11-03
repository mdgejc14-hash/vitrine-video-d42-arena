package video.vitrine.app.qa

import androidx.test.platform.app.InstrumentationRegistry
import java.net.HttpURLConnection
import java.net.URL
import org.json.JSONObject

/**
 * VV Remote QA (s2/s6) : acces au mock staging local.
 * Base par defaut = emulateur Android (10.0.2.2 -> hote). Sur appareil physique :
 * -Pandroid.testInstrumentationRunnerArguments.mockBaseUrl=http://IP_LAN:3200
 * Le mock n'existe QUE pour les variantes qa ; jamais de production ici.
 */
internal object MockEndpoint {
    val baseUrl: String by lazy {
        InstrumentationRegistry.getArguments().getString("mockBaseUrl") ?: "http://10.0.2.2:3200"
    }

    data class Response(val code: Int, val body: JSONObject)

    private fun call(method: String, path: String, payload: JSONObject?): Response {
        val conn = URL(baseUrl + path).openConnection() as HttpURLConnection
        conn.requestMethod = method
        conn.connectTimeout = 5_000
        conn.readTimeout = 5_000
        if (payload != null) {
            conn.doOutput = true
            conn.setRequestProperty("Content-Type", "application/json")
            conn.outputStream.use { it.write(payload.toString().toByteArray()) }
        }
        val code = conn.responseCode
        val stream = if (code in 200..299) conn.inputStream else conn.errorStream
        val text = stream?.bufferedReader()?.use { it.readText() } ?: "{}"
        conn.disconnect()
        return Response(code, JSONObject(text))
    }

    fun get(path: String): Response = call("GET", path, null)
    fun post(path: String, payload: JSONObject): Response = call("POST", path, payload)
}
