package video.vitrine.feature.onboarding.auth

import video.vitrine.core.designsystem.VitrineActivity
import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import video.vitrine.feature.onboarding.R

/**
 * Ecran auth (JSON ecrans 3.7) : bouton unique "Continuer avec Google" (1-tap),
 * capture du deep-link de parrainage ?ref= /r/CODE transmise a l'onboarding sectoriel.
 */
class AuthActivity : VitrineActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_auth)
        // D41 (F34/F63) : le deep-link /r/CODE est desormais route par MainActivity
        // (extra « ref_code ») ; le parsing direct d'intent.data reste en repli.
        val refCode = intent.getStringExtra("ref_code")
            ?: RefCodeParser.fromDeepLink(intent?.data?.toString())
        findViewById<TextView>(R.id.auth_status).text =
            if (refCode != null) {
                getString(R.string.auth_ref_detected, refCode)
            } else {
                // D41 (F33) : cle DEDIEE au statut runtime — auth_subtitle reste
                // le sous-titre de la maquette (layout), pas de collision.
                getString(R.string.auth_status_default)
            }
        findViewById<Button>(R.id.auth_google_button).setOnClickListener {
            lifecycleScope.launch { signIn(refCode) }
        }
        // D19 : aucun ecran bloquant — repli hors-connexion (session locale, aucun
        // appel reseau) pour valider le parcours complet sans compte ni reseau.
        findViewById<Button>(R.id.auth_offline_button).setOnClickListener {
            val data = Intent()
                .putExtra("firebase_uid", DemoSession.UID)
                .putExtra("firebase_token", DemoSession.TOKEN)
                .putExtra("ref_code", refCode)
            setResult(RESULT_OK, data)
            finish()
        }
    }

    private suspend fun signIn(refCode: String?) {
        val status = findViewById<TextView>(R.id.auth_status)
        status.setText(R.string.auth_loading)
        findViewById<android.widget.ProgressBar>(R.id.auth_progress).visibility = android.view.View.VISIBLE
        findViewById<TextView>(R.id.auth_preparing).visibility = android.view.View.VISIBLE
        findViewById<TextView>(R.id.auth_preparing_sub).visibility = android.view.View.VISIBLE
        val result = runCatching {
            val idToken = GoogleSsoClient(this).fetchGoogleIdToken()
            FirebaseAuthGateway(this).signInWithGoogleIdToken(idToken)
        }
        result.fold(
            onSuccess = { (uid, firebaseToken) ->
                // Audit D40 (A9) : le jeton court (1 h) est garde en prefs pour la
                // synchronisation best-effort des droits (Dashboard) ; jamais de
                // secret long dans le stockage local.
                getSharedPreferences("vv_session", MODE_PRIVATE)
                    .edit().putString("token", firebaseToken).apply()
                // Audit D41 (F42, P0) : bootstrap IMMEDIAT du profil serveur —
                // sans la ligne users, welcome-grant/quota/referral/entitlements/
                // audio repondent tous 404 profile_not_initialized. Idempotent.
                runCatching {
                    video.vitrine.data.api.BackendSync.bootstrap(
                        video.vitrine.feature.onboarding.BuildConfig.API_BASE_URL,
                        firebaseToken
                    )
                }
                val data = Intent()
                    .putExtra("firebase_uid", uid)
                    .putExtra("firebase_token", firebaseToken)
                    .putExtra("ref_code", refCode)
                setResult(RESULT_OK, data)
                finish()
            },
            onFailure = { error ->
                findViewById<android.widget.ProgressBar>(R.id.auth_progress).visibility = android.view.View.GONE
                findViewById<TextView>(R.id.auth_preparing).visibility = android.view.View.GONE
                findViewById<TextView>(R.id.auth_preparing_sub).visibility = android.view.View.GONE
                status.text = getString(R.string.auth_error, error.javaClass.simpleName)
            }
        )
    }
}
