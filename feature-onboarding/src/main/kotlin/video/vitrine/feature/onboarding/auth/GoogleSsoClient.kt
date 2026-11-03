package video.vitrine.feature.onboarding.auth

import android.content.Context
import androidx.credentials.CredentialManager
import androidx.credentials.GetCredentialRequest
import com.google.android.libraries.identity.googleid.GetGoogleIdOption
import com.google.android.libraries.identity.googleid.GoogleIdTokenCredential
import video.vitrine.feature.onboarding.BuildConfig

/**
 * Google SSO 1-tap (Credential Manager), aucun numero de telephone (contrat V7-FINAL 3.4/9.1).
 * Rend un ID token JWT ; le serveur Phase A le verifie via son JWKS existant (authenticate()).
 */
class GoogleSsoClient(private val context: Context) {

    suspend fun fetchGoogleIdToken(): String {
        val option = GetGoogleIdOption.Builder()
            .setServerClientId(BuildConfig.GOOGLE_SERVER_CLIENT_ID)
            .setFilterByAuthorizedAccounts(false)
            .build()
        val request = GetCredentialRequest.Builder()
            .addCredentialOption(option)
            .build()
        val response = CredentialManager.create(context).getCredential(context, request)
        return GoogleIdTokenCredential.createFrom(response.credential.data).idToken
    }
}
