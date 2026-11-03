package video.vitrine.feature.onboarding

import android.content.Context
import video.vitrine.core.model.billing.DeviceFingerprint
import video.vitrine.data.api.ApiClient
import java.io.File

/**
 * Generosite d'accueil (9.1) : POST /me/welcome-grant avec l'empreinte appareil.
 * Hors-ligne : etat local en cache, rattrapage au prochain connexion (R3).
 */
class WelcomeRepository(private val context: Context, private val api: ApiClient) {

    data class GrantState(val granted: Boolean, val creditsTotal: Int, val offline: Boolean)

    fun deviceFingerprint(): String =
        DeviceFingerprint.of(
            android.provider.Settings.Secure.getString(
                context.contentResolver,
                android.provider.Settings.Secure.ANDROID_ID
            ) ?: "inconnu",
            android.os.Build.FINGERPRINT
        )

    suspend fun requestGrant(token: String): GrantState {
        val fingerprint = deviceFingerprint()
        val reply = api.post("/api/v1/me/welcome-grant", token, """{"fingerprint":"$fingerprint"}""")
        if (reply != null && reply.status == 200) {
            val granted = reply.body.contains("\"granted\":true")
            val credits = Regex("\"credits_total\":(\\d+)").find(reply.body)?.groupValues?.get(1)?.toIntOrNull()
                ?: Regex("\"credits_left\":(\\d+)").find(reply.body)?.groupValues?.get(1)?.toIntOrNull()
                ?: 0
            cache().writeText("$granted|$credits")
            return GrantState(granted, credits, offline = false)
        }
        val cached = cache().takeIf { it.exists() }?.readText()?.split("|")
        if (cached != null) {
            return GrantState(cached[0] == "true", cached[1].toIntOrNull() ?: 0, offline = true)
        }
        // D41 (F30) : premiere ouverture hors-ligne — afficher le seed LOCAL
        // honnete (la porte d'export CreditPolicy accorde 3 credits hors-ligne ;
        // afficher 0 contredisait le comportement reel). Le rattrapage serveur
        // (welcome-grant) est rejoue par BackendSync.flushPending a la reconnexion.
        return GrantState(false, video.vitrine.core.guard.CreditPolicy.WELCOME_TOTAL, offline = true)
    }

    private fun cache(): File = File(context.cacheDir, "welcome-grant.state")
}
