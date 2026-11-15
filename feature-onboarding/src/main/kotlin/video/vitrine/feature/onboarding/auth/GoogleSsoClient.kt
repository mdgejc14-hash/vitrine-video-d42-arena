package video.vitrine.feature.onboarding.auth

import android.content.Context
import androidx.credentials.GetCredentialRequest
import androidx.credentials.CredentialManager
import com.google.android.libraries.identity.googleid.GetGoogleIdOption
import com.google.android.libraries.identity.googleid.GoogleIdTokenCredential
import video.vitrine.feature.onboarding.BuildConfig

/**
 * Client SSO Google (Credential Manager).
 *
 * D42.34 (CR-4, ordre fondateur identité) : le profil Google RÉEL
 * (displayName du credential) est maintenant remonté avec le jeton —
 * jamais de nom inventé, jamais déduit de l'email.
 */
class GoogleSsoClient(private val context: Context) {

    /** Identité Google réelle : jeton + nom d'affichage (null si absent). */
    data class IdentiteGoogle(val idToken: String, val displayName: String?)

    suspend fun fetchGoogleIdentite(): IdentiteGoogle {
        val option = GetGoogleIdOption.Builder()
            .setServerClientId(BuildConfig.GOOGLE_SERVER_CLIENT_ID)
            .setFilterByAuthorizedAccounts(false)
            .build()
        val request = GetCredentialRequest.Builder()
            .addCredentialOption(option)
            .build()
        val response = CredentialManager.create(context).getCredential(context, request)
        val credential = GoogleIdTokenCredential.createFrom(response.credential.data)
        return IdentiteGoogle(
            idToken = credential.idToken,
            displayName = credential.displayName?.takeIf { it.isNotBlank() },
        )
    }

    /** Compatibilité historique : jeton seul. */
    suspend fun fetchGoogleIdToken(): String = fetchGoogleIdentite().idToken
}
