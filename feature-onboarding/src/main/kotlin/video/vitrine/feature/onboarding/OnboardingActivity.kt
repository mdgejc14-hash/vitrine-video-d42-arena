package video.vitrine.feature.onboarding

import android.content.Intent
import android.os.Bundle
import video.vitrine.core.designsystem.VitrineActivity
import androidx.activity.compose.setContent
import video.vitrine.core.designsystem.VitrineTheme
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import video.vitrine.core.model.Sector
import video.vitrine.data.api.ApiClient
import video.vitrine.feature.onboarding.auth.DemoSession

/**
 * Parcours ecrans 3 puis 4 : secteur metier (persiste en preferences locales avec
 * l'uid de session, demo comprise), code parrain FACULTATIF, puis generosite
 * d'accueil. En mode demo : aucun appel reseau, grant local immediat, navigation
 * jamais bloquante.
 *
 * Audit D41 (F41/F42/F30) : ordre serveur corrige — bootstrap du profil
 * (POST /me/bootstrap, sans lequel TOUTES les routes /me/... repondent 404
 * profile_notinitialized), puis claim du parrain (le serveur octroie 5 credits
 * au filleul DEJA parraine au moment du grant — l'ordre inverse ne donnait que
 * 3), puis welcome-grant. Hors-ligne : le grant affiche le seed local honnete
 * (3, politique CreditPolicy) et tout est rejoue au retour reseau (BackendSync).
 */
class OnboardingActivity : VitrineActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val uid = intent.getStringExtra("firebase_uid") ?: DemoSession.UID
        val token = intent.getStringExtra("firebase_token")
        val isDemo = token == DemoSession.TOKEN
        val repository = WelcomeRepository(this, ApiClient(BuildConfig.API_BASE_URL))
        setContent {
            VitrineTheme {
                var sector by mutableStateOf<Sector?>(null)
                var refCode by mutableStateOf<String?>(intent.getStringExtra("ref_code"))
                var refStepDone by mutableStateOf(false)
                var carouselDone by mutableStateOf(false)
                var grant by mutableStateOf<WelcomeRepository.GrantState?>(
                    if (isDemo) {
                        WelcomeRepository.GrantState(granted = true, creditsTotal = DEMO_CREDITS, offline = true)
                    } else {
                        null
                    }
                )
                if (!carouselDone) {
                    CarouselScreen { carouselDone = true }
                } else if (sector == null) {
                    OnboardingScreen { chosen ->
                        sector = chosen
                        saveSession(uid, chosen)
                    }
                } else {
                    val chosen = sector
                    if (!refStepDone && chosen != null) {
                        ReferralCodeScreen(chosen) { code ->
                            refCode = code ?: refCode
                            refStepDone = true
                            if (!isDemo) {
                                lifecycleScope.launch {
                                    grant = demarrageServeur(uid, token, refCode, repository)
                                }
                            }
                        }
                    } else {
                        WelcomeScreen(grant) { finishWith(sector, grant, refCode) }
                    }
                }
            }
        }
    }

    /**
     * Demarrage serveur du compte (D41) : bootstrap -> claim -> grant.
     * Retourne l'etat de generosite affiche a l'ecran d'accueil ; hors-ligne,
     * repli sur le cache local ou le seed honnete CreditPolicy.WELCOME_TOTAL.
     */
    private suspend fun demarrageServeur(
        uid: String,
        token: String?,
        refCode: String?,
        repository: WelcomeRepository,
    ): WelcomeRepository.GrantState? {
        val sync = video.vitrine.data.api.BackendSync
        runCatching { sync.bootstrap(BuildConfig.API_BASE_URL, token ?: "") }
        if (!token.isNullOrBlank() && !refCode.isNullOrBlank()) {
            val claimed = runCatching {
                sync.claimReferral(this, BuildConfig.API_BASE_URL, token, refCode)
            }.getOrDefault(false)
            if (claimed) sync.recordReferralClaimed(this, uid, refCode)
        }
        val etat = runCatching { repository.requestGrant(token ?: "") }.getOrNull()
        if (etat != null && !etat.offline) {
            sync.persistWelcomeGrant(this, uid, etat.creditsTotal)
        }
        return etat
    }

    private fun saveSession(uid: String, sector: Sector) {
        getSharedPreferences(SESSION_PREFS, MODE_PRIVATE)
            .edit()
            .putString("uid", uid)
            .putString("sector", sector.code)
            .apply()
    }

    private fun finishWith(sector: Sector?, grant: WelcomeRepository.GrantState?, refCode: String? = null) {
        if (sector != null) {
            saveSession(intent.getStringExtra("firebase_uid") ?: DemoSession.UID, sector)
        }
        setResult(
            RESULT_OK,
            Intent()
                .putExtra("sector", sector?.code)
                .putExtra("welcome_credits", grant?.creditsTotal ?: 0)
                .putExtra("ref_code", refCode ?: intent.getStringExtra("ref_code"))
        )
        finish()
    }

    private companion object {
        const val SESSION_PREFS = "vv_session"
        const val DEMO_CREDITS = 3
    }
}
