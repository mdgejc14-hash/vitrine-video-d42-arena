package video.vitrine.data.api

import com.sun.net.httpserver.HttpServer
import kotlinx.coroutines.runBlocking
import org.json.JSONObject
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import java.net.InetSocketAddress
import java.net.ServerSocket

/**
 * D42.26 §3.11 — erreurs réseau / réponses invalides côté client.
 *
 * Preuve exécutée (JVM, serveur mock local) que le transport ne lève
 * JAMAIS : toute défaillance réseau → null (l'app dégrade), toute réponse
 * (même un corps non-JSON) → Reply brute sans exception. La garde de
 * parsing est chez les appelants — BackendSync applique
 * `runCatching { ApiClient(...).post/get(...) }.getOrNull()` puis
 * `runCatching { JSONObject(reply.body) }` avec `opt*` et valeurs de
 * repli : une réponse invalide n'écrase jamais le miroir Room local
 * (audit 09/11, matrice 3.11).
 */
class ApiClientInvalidReplyTest {

    private lateinit var server: HttpServer
    private var port = 0

    @Before
    fun setUp() {
        server = HttpServer.create(InetSocketAddress("127.0.0.1", 0), 0)
        // 200 dont le corps n'est PAS du JSON (réponse invalide typique :
        // page d'erreur d'une passerelle, HTML, payload tronqué…).
        server.createContext("/api/v1/me/entitlements") { ex ->
            val bytes = "<html><body>502 Bad Gateway (proxy)</body></html>".toByteArray()
            ex.sendResponseHeaders(200, bytes.size.toLong())
            ex.responseBody.use { it.write(bytes) }
        }
        server.createContext("/api/v1/quota/consume") { ex ->
            val bytes = "not json at all {{{".toByteArray()
            ex.sendResponseHeaders(200, bytes.size.toLong())
            ex.responseBody.use { it.write(bytes) }
        }
        server.createContext("/api/v1/me/bootstrap") { ex ->
            val bytes = "internal error".toByteArray()
            ex.sendResponseHeaders(500, bytes.size.toLong())
            ex.responseBody.use { it.write(bytes) }
        }
        server.executor = null
        server.start()
        port = server.address.port
    }

    @After
    fun tearDown() {
        server.stop(0)
    }

    private fun client() = ApiClient("http://127.0.0.1:$port")

    @Test
    fun `reponse 200 non-JSON → Reply brute, aucune exception, parsing avorte proprement`() {
        val reply = runBlocking { client().get("/api/v1/me/entitlements", "tok") }
        assertNotNull("une réponse HTTP doit être retournée sans exception", reply)
        assertEquals(200, reply!!.status)
        assertTrue(reply.body.startsWith("<html>"))
        // Patron produit (BackendSync.syncEntitlements) : le parsing du corps
        // invalide échoue DANS runCatching → le miroir local reste intact,
        // aucun crash ne remonte à l'UI.
        val parsed = runCatching { JSONObject(reply.body) }
        assertTrue("le corps non-JSON doit échouer proprement au parsing", parsed.isFailure)
    }

    @Test
    fun `reponse 200 corps pourri sur quota → Reply brute, aucune exception`() {
        val reply = runBlocking { client().post("/api/v1/quota/consume", "tok", "{}") }
        assertNotNull(reply)
        assertEquals(200, reply!!.status)
        assertTrue(runCatching { JSONObject(reply.body) }.isFailure)
    }

    @Test
    fun `reponse 500 → Reply(500) lue depuis errorStream, aucune exception`() {
        val reply = runBlocking { client().post("/api/v1/me/bootstrap", "tok", "{}") }
        assertNotNull(reply)
        assertEquals(500, reply!!.status)
    }

    @Test
    fun `serveur indisponible (connexion refusee) → null, aucune exception`() {
        // Un port libre : rien n'écoute → connexion impossible (§3.12, transport).
        val deadPort = ServerSocket(0).use { it.localPort }
        val reply = runBlocking { ApiClient("http://127.0.0.1:$deadPort").get("/api/v1/me/entitlements", null) }
        assertNull("connexion impossible doit se résoudre en null (dégradation, pas crash)", reply)
    }
}
