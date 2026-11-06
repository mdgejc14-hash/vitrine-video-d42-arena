package video.vitrine.feature.onboarding.auth

import android.util.Log
import com.google.firebase.auth.FirebaseAuthException
import video.vitrine.feature.onboarding.R
import java.io.IOException

/**
 * D42.9 — traduction des echecs de connexion en messages ACTIONNABLES.
 *
 * Defaut corrige : l'ecran affichait `error.javaClass.simpleName`. Sous R8 full
 * (obfuscation integrale, D36), ce nom est renomme — d'ou « dq1 » a l'ecran.
 * Le commercant lisait donc un identifiant interne, accompagne de « verifie ton
 * reseau » qui est faux pour une erreur de configuration. Deux fautes :
 *  1. on exposait un detail technique a quelqu'un qui ne peut rien en faire ;
 *  2. on lui donnait un conseil errone, donc il ne pouvait pas s'en sortir.
 *
 * Regle : l'ecran dit ce qui s'est passe ET ce que le client peut faire.
 * Le detail technique part dans logcat (tag VV-AUTH), resolu par mapping.txt.
 *
 * Classification volontairement fondee sur des signaux qui SURVIVENT a R8 :
 *  - `FirebaseAuthException.errorCode` : chaine de caracteres, jamais renommee ;
 *  - les familles d'IOException du framework ;
 *  - le texte du message, donnee d'execution.
 * On ne teste PAS `javaClass.simpleName` : c'est precisement ce qui a produit dq1.
 */
object AuthDiagnostics {

    private const val TAG = "VV-AUTH"

    /** Message a afficher au commercant. */
    fun messageRes(error: Throwable): Int {
        val message = error.message.orEmpty().lowercase()
        return when {
            error is FirebaseAuthException -> firebaseMessage(error)
            error is IOException -> R.string.auth_error_network
            // Credential Manager : refus/annulation de l'utilisateur.
            message.contains("cancel") || message.contains("annul") ->
                R.string.auth_error_cancelled
            // Aucun compte Google sur l'appareil : le client peut corriger seul.
            message.contains("no credential") || message.contains("no google account") ->
                R.string.auth_error_no_google_account
            // DEVELOPER_ERROR (statut 10) : configuration OAuth incomplete. Le
            // client ne peut PAS la corriger — inutile de l'accuser.
            message.contains("developer_error") || message.contains("10:") ->
                R.string.auth_error_unavailable
            message.contains("network") || message.contains("timeout") ||
                message.contains("unable to resolve host") || message.contains("socket") ->
                R.string.auth_error_network
            else -> R.string.auth_error_generic
        }
    }

    private fun firebaseMessage(error: FirebaseAuthException): Int = when (error.errorCode) {
        "ERROR_NETWORK_REQUEST_FAILED" -> R.string.auth_error_network
        "ERROR_INVALID_CREDENTIAL", "ERROR_INVALID_IDP_RESPONSE",
        "ERROR_CREDENTIAL_ALREADY_IN_USE",
        "ERROR_OPERATION_NOT_ALLOWED", "ERROR_INVALID_API_KEY" -> R.string.auth_error_unavailable
        "ERROR_USER_DISABLED", "ERROR_USER_TOKEN_EXPIRED" -> R.string.auth_error_service
        "ERROR_WEB_CONTEXT_CANCELED", "ERROR_WEB_CONTEXT_ALREADY_PRESENTED" ->
            R.string.auth_error_cancelled
        else -> R.string.auth_error_generic
    }

    /**
     * Detail technique : uniquement dans logcat. Contient la pile complete, que
     * `mapping.txt` (publie avec chaque Release) permet de retracer.
     * Aucune donnee personnelle, aucun jeton.
     */
    fun log(error: Throwable, etape: String) {
        val code = (error as? FirebaseAuthException)?.errorCode ?: "-"
        Log.e(TAG, "echec[$etape] code=$code type=${error.javaClass.name}", error)
    }
}
