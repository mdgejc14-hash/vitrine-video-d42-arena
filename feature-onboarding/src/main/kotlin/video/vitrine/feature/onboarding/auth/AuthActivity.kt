package video.vitrine.feature.onboarding.auth

import video.vitrine.core.designsystem.VitrineActivity
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.ProgressBar
import android.widget.TextView
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import video.vitrine.feature.onboarding.R

/**
 * Ecran auth (JSON ecrans 3.7) : bouton unique « Continuer avec mon compte
 * Google » (1-tap), capture du deep-link de parrainage ?ref= / r/CODE transmise
 * a l'onboarding sectoriel.
 *
 * D42.9 — corrections issues de l'essai sur telephone reel :
 *  1. l'echec affichait `error.javaClass.simpleName`, donc un nom RENOMME par R8
 *     (« dq1 ») suivi de « verifie ton reseau », faux dans la majorite des cas.
 *     Desormais : message actionnable (AuthDiagnostics) + detail dans logcat ;
 *  2. le bouton restait actif pendant la connexion : un second appui lancait un
 *     second flux Credential Manager (fenetres empilees, etat incoherent). Il est
 *     verrouille tant que l'operation n'est pas terminee ;
 *  3. en cas d'echec, l'ecran laissait le client sans issue : les boutons sont
 *     remis en etat et le message indique quoi faire.
 */
class AuthActivity : VitrineActivity() {

    // Couleurs en dur : aucune dependance a une ressource systeme dont la
    // disponibilite varie selon la version d'Android.
    private val COULEUR_NEUTRE = android.graphics.Color.parseColor("#23467F")
    private val COULEUR_ERREUR = android.graphics.Color.parseColor("#B3261E")

    /** Verrou anti double-soumission : un seul flux a la fois. */
    private var connexionEnCours = false

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
            demarrerConnexion(refCode)
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

    /** Point d'entree du bouton : verrouille, affiche l'attente, puis travaille. */
    private fun demarrerConnexion(refCode: String?) {
        if (connexionEnCours) return
        connexionEnCours = true
        afficherAttente()
        lifecycleScope.launch { executerConnexion(refCode) }
    }

    private suspend fun executerConnexion(refCode: String?) {
        val resultat = runCatching {
            val idToken = GoogleSsoClient(this).fetchGoogleIdToken()
            FirebaseAuthGateway(this).signInWithGoogleIdToken(idToken)
        }
        resultat.fold(
            onSuccess = { (uid, firebaseToken) -> reussir(uid, firebaseToken, refCode) },
            onFailure = { erreur -> echouer(erreur) }
        )
    }

    private suspend fun reussir(uid: String, firebaseToken: String, refCode: String?) {
        // Audit D40 (A9) : le jeton court (1 h) est garde en prefs pour la
        // synchronisation best-effort des droits (Dashboard) ; jamais de
        // secret long dans le stockage local.
        getSharedPreferences("vv_session", MODE_PRIVATE)
            .edit().putString("token", firebaseToken).apply()
        // Audit D41 (F42, P0) : bootstrap IMMEDIAT du profil serveur — sans la
        // ligne users, welcome-grant/quota/referral/entitlements/audio repondent
        // tous 404 profile_not_initialized. Idempotent.
        // D42.9 : un echec ici n'empeche PAS d'entrer (l'onboarding reessaie),
        // mais il est journalise — avant, il etait avale en silence.
        runCatching {
            video.vitrine.data.api.BackendSync.bootstrap(
                video.vitrine.feature.onboarding.BuildConfig.API_BASE_URL,
                firebaseToken
            )
        }.onFailure { AuthDiagnostics.log(it, "bootstrap") }
        val data = Intent()
            .putExtra("firebase_uid", uid)
            .putExtra("firebase_token", firebaseToken)
            .putExtra("ref_code", refCode)
        setResult(RESULT_OK, data)
        finish()
    }

    private fun afficherAttente() {
        findViewById<Button>(R.id.auth_google_button).isEnabled = false
        findViewById<Button>(R.id.auth_offline_button).isEnabled = false
        findViewById<ProgressBar>(R.id.auth_progress).visibility = View.VISIBLE
        findViewById<TextView>(R.id.auth_preparing).visibility = View.VISIBLE
        findViewById<TextView>(R.id.auth_preparing_sub).visibility = View.VISIBLE
        findViewById<TextView>(R.id.auth_status).apply {
            setText(R.string.auth_loading)
            // D42.9 : le message d'erreur precedent ne doit pas rester affiche.
            setTextColor(COULEUR_NEUTRE)
        }
    }

    /**
     * Echec : message comprehensible + sortie de secours. Le client sait quoi
     * faire et peut reessayer ; il ne reste jamais bloque sur un ecran inerte.
     */
    private fun echouer(erreur: Throwable) {
        connexionEnCours = false
        AuthDiagnostics.log(erreur, "signIn")
        findViewById<ProgressBar>(R.id.auth_progress).visibility = View.GONE
        findViewById<TextView>(R.id.auth_preparing).visibility = View.GONE
        findViewById<TextView>(R.id.auth_preparing_sub).visibility = View.GONE
        findViewById<Button>(R.id.auth_google_button).apply {
            isEnabled = true
            setText(R.string.auth_retry)
        }
        findViewById<Button>(R.id.auth_offline_button).isEnabled = true
        findViewById<TextView>(R.id.auth_status).apply {
            setText(AuthDiagnostics.messageRes(erreur))
            setTextColor(COULEUR_ERREUR)
        }
    }
}
