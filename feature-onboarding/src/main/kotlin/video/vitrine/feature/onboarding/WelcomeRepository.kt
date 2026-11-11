package video.vitrine.feature.onboarding

import android.content.Context
import video.vitrine.core.model.billing.DeviceFingerprint
import video.vitrine.data.api.ApiClient
import java.io.File

/**
 * Generosite d'accueil (9.1) : POST /me/welcome-grant avec l'empreinte appareil.
 * Hors-ligne : etat local en cache, rattrapage au prochain connexion (R3).
 *
 * D42.30 (retour terrain RC14) : le resultat est desormais TYPÉ — le parcours
 * d'affichage distingue l'octroi confirmé serveur, l'indisponibilité réseau
 * (rattrapage automatique honnête) et le REFUS serveur (statut + code, jamais
 * présenté comme « connexion perdue »).
 */
class WelcomeRepository(private val context: Context, private val api: ApiClient) {

    /** Résultat typé de la demande de welcome-grant. */
    sealed class ResultatGrant {
        /** 200 : solde serveur confirmé (première attribution OU déjà attribué). */
        data class Accorde(val creditsTotal: Int) : ResultatGrant()

        /** Aucune réponse HTTP (réseau coupé / délai dépassé) : rattrapage
         *  automatique au retour réseau (BackendSync.replayWelcomeGrant). */
        data class HorsLigne(val creditsAffiches: Int) : ResultatGrant()

        /** Le serveur a répondu NON : statut HTTP + code d'erreur serveur
         *  (profile_not_initialized, account_inactive, database_unavailable…). */
        data class Refuse(val statut: Int, val code: String) : ResultatGrant()
    }

    fun deviceFingerprint(): String = DeviceFingerprint.of(
        android.provider.Settings.Secure.getString(
            context.contentResolver,
            android.provider.Settings.Secure.ANDROID_ID
        ) ?: "inconnu",
        android.os.Build.FINGERPRINT
    )

    /**
     * Chaîne D42.30 : welcome-grant avec taxonomie exacte. Le VERROU serveur par
     * empreinte (C16) renvoie 200 granted:false credits_left:N quand le téléphone
     * ou le compte a déjà été doté — c'est un SOLDE CONFIRMÉ, pas un échec.
     */
    suspend fun demanderGrant(token: String): ResultatGrant {
        val fingerprint = deviceFingerprint()
        val reply = runCatching {
            api.post("/api/v1/me/welcome-grant", token, """{"fingerprint":"$fingerprint"}""")
        }.getOrNull()
        return when {
            reply == null -> ResultatGrant.HorsLigne(creditLocalAffichable())
            reply.status == 200 -> {
                val credits = Regex("\"credits_total\":(\\d+)")
                    .find(reply.body)?.groupValues?.get(1)?.toIntOrNull()
                    ?: Regex("\"credits_left\":(\\d+)")
                        .find(reply.body)?.groupValues?.get(1)?.toIntOrNull()
                    ?: 0
                cache().writeText("true|$credits")
                ResultatGrant.Accorde(credits)
            }
            else -> ResultatGrant.Refuse(reply.status, codeErreur(reply.body))
        }
    }

    /** Solde affichable hors-ligne : dernier solde connu en cache, sinon le
     *  seed LOCAL honnête de la politique crédit (la valeur réelle est décidée
     *  serveur et confirmée au retour réseau). */
    private fun creditLocalAffichable(): Int {
        val cached = cache().takeIf { it.exists() }?.readText()?.split("|")
        return cached?.getOrNull(1)?.toIntOrNull()
            ?: video.vitrine.core.guard.CreditPolicy.WELCOME_TOTAL
    }

    /** Extrait le code d'erreur JSON serveur (ex. "account_inactive"). */
    private fun codeErreur(corps: String): String =
        Regex("\"error\"\\s*:\\s*\"([a-z_]+)\"").find(corps)?.groupValues?.get(1) ?: ""

    private fun cache(): File = File(context.cacheDir, "welcome-grant.state")
}
