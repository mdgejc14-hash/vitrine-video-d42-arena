package video.vitrine.feature.onboarding.auth

import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider
import android.content.Context
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine
import video.vitrine.feature.onboarding.BuildConfig

/**
 * Passerelle Firebase Auth : initialisation MANUELLE (FirebaseOptions), donc aucune
 * dependance a google-services.json : les vraies cles Firebase sont une injection
 * documentee (METHODE 24h V2 7). Le JWT emis est verifie cote worker par le JWKS Phase A.
 */
class FirebaseAuthGateway(private val context: Context) {

    fun auth(): FirebaseAuth {
        if (FirebaseApp.getApps(context).isEmpty()) {
            val options = FirebaseOptions.Builder()
                .setApiKey(BuildConfig.FIREBASE_API_KEY)
                .setProjectId("vitrine-video")
                .setApplicationId(BuildConfig.FIREBASE_APP_ID)
                .build()
            FirebaseApp.initializeApp(context, options)
        }
        return FirebaseAuth.getInstance()
    }

    /**
     * Renvoie (uid, ID token Firebase) : le token est OBLIGATOIRE cote worker
     * (JWKS securetoken, issuer + audience verifies). Bug corrige (audit final) :
     * sans lui, welcome-grant partait avec un Bearer vide = 401 = credits jamais
     * attribues en production.
     */
    suspend fun signInWithGoogleIdToken(idToken: String): Pair<String, String> = suspendCoroutine { cont ->
        val credential = GoogleAuthProvider.getCredential(idToken, null)
        auth().signInWithCredential(credential)
            .addOnCompleteListener { task ->
                val user = task.result?.user
                if (task.isSuccessful && user != null) {
                    user.getIdToken(false).addOnCompleteListener { tokenTask ->
                        val firebaseToken = tokenTask.result?.token
                        if (tokenTask.isSuccessful && firebaseToken != null) {
                            cont.resume(user.uid to firebaseToken)
                        } else {
                            cont.resumeWithException(
                                tokenTask.exception ?: IllegalStateException("token_failed")
                            )
                        }
                    }
                } else {
                    cont.resumeWithException(task.exception ?: IllegalStateException("signin_failed"))
                }
            }
    }
}
