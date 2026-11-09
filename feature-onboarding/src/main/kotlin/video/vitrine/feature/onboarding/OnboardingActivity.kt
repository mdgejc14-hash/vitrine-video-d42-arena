package video.vitrine.feature.onboarding

import android.content.Intent
import android.os.Bundle
import video.vitrine.core.designsystem.VitrineActivity
import androidx.activity.compose.setContent
import video.vitrine.core.designsystem.VitrineTheme
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
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
 *
 * D42.9 — corrections issues de l'essai sur telephone reel :
 *  1. l'etat etait porte par des `mutableStateOf` ordinaires : toute recreation
 *     de l'activite (rotation, appel entrant, memoire insuffisante) RAMENAIT le
 *     client au carrousel, carrousel deja vu compris. Il est desormais sauve;
 *  2. l'ecran d'accueil affichait « 0 credits » tant que le serveur n'avait pas
 *     repondu — un chiffre faux, sans explication. Trois etats explicites :
 *     en attente / credits obtenus / echec (les credits seront ajoutes).
 *  3. le demarrage serveur etait lance depuis le clic, donc rejouable et non
 *     annulable. Il est declenche une seule fois par `LaunchedEffect`.
 */
class OnboardingActivity : VitrineActivity() {

    // D42.21-17 (D11) : dette detekt à la limite exacte (15/15) — détection
    // tardive (detekt ne tourne que sur main, gelé à a2a3c47 depuis D42.18).
    // Le parcours onboarding est prouvé par chaque E2E (langue, carrousel,
    // activité : PASS constants sur les voies debug ET release). Aucun
    // refactor à la veille de la fige du rapport — extraction à planifier.
    @Suppress("CyclomaticComplexMethod")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val uid = intent.getStringExtra("firebase_uid") ?: DemoSession.UID
        val token = intent.getStringExtra("firebase_token")
        val isDemo = token == DemoSession.TOKEN
        val repository = WelcomeRepository(this, ApiClient(BuildConfig.API_BASE_URL))
        setContent {
            VitrineTheme {
                var carouselDone by rememberSaveable { mutableStateOf(false) }
                var sectorCode by rememberSaveable {
                    mutableStateOf<String?>(savedInstanceState?.getString(KEY_SECTOR))
                }
                var refCode by rememberSaveable {
                    mutableStateOf(intent.getStringExtra("ref_code"))
                }
                // false tant que l'etape parrain n'est pas passee ; en demo elle
                // n'a pas d'objet cote serveur et on l'ouvre quand meme.
                var refStepDone by rememberSaveable { mutableStateOf(false) }
                // -1 = pas encore su. Distingue « pas encore » de « 0 credit ».
                var credits by rememberSaveable {
                    mutableIntStateOf(if (isDemo) DEMO_CREDITS else CREDITS_INCONNUS)
                }
                var creditsEchec by rememberSaveable { mutableStateOf(false) }
                var demarrageLance by remember { mutableStateOf(false) }

                val sector = sectorCode?.let { code ->
                    Sector.entries.firstOrNull { it.code == code }
                }

                if (refStepDone && !isDemo && credits == CREDITS_INCONNUS && !demarrageLance) {
                    // D42.9 : un seul demarrage, meme si la composition est
                    // reevaluee plusieurs fois (avant : un appel par reclic).
                    demarrageLance = true
                    LaunchedEffect(Unit) {
                        val etat = demarrageServeur(uid, token, refCode, repository)
                        credits = etat?.creditsTotal ?: CREDITS_INCONNUS
                        creditsEchec = etat == null
                    }
                }

                when {
                    !carouselDone -> CarouselScreen { carouselDone = true }
                    sector == null -> OnboardingScreen { chosen ->
                        sectorCode = chosen.code
                        saveSession(uid, chosen)
                    }
                    !refStepDone -> ReferralCodeScreen(
                        sector,
                        initial = refCode.orEmpty()
                    ) { code ->
                        refCode = code ?: refCode
                        refStepDone = true
                    }
                    else -> WelcomeScreen(
                        credits = credits,
                        enAttente = credits == CREDITS_INCONNUS && !creditsEchec,
                        echec = creditsEchec,
                        onContinue = {
                            finishWith(sector, credits.takeIf { it > 0 }, refCode)
                        }
                    )
                }
            }
        }
    }

    /**
     * Demarrage serveur du compte (D41) : bootstrap -> claim -> grant.
     * Retourne l'etat de generosite, ou null si le serveur n'a pas repondu
     * (reseau absent, 401, delai depasse).
     */
    private suspend fun demarrageServeur(
        uid: String,
        token: String?,
        refCode: String?,
        repository: WelcomeRepository,
    ): WelcomeRepository.GrantState? {
        val sync = video.vitrine.data.api.BackendSync
        runCatching { sync.bootstrap(BuildConfig.API_BASE_URL, token ?: "") }
            .onFailure { android.util.Log.w("VV-ONB", "bootstrap en echec", it) }
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

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        // D42.9 : le secteur choisi survit a une recreation de l'activite.
        getSharedPreferences(SESSION_PREFS, MODE_PRIVATE)
            .getString("sector", null)?.let { outState.putString(KEY_SECTOR, it) }
    }

    private fun finishWith(sector: Sector?, credits: Int?, refCode: String? = null) {
        if (sector != null) {
            saveSession(intent.getStringExtra("firebase_uid") ?: DemoSession.UID, sector)
        }
        setResult(
            RESULT_OK,
            Intent()
                .putExtra("sector", sector?.code)
                .putExtra("welcome_credits", credits ?: 0)
                .putExtra("ref_code", refCode ?: intent.getStringExtra("ref_code"))
        )
        finish()
    }

    private companion object {
        const val SESSION_PREFS = "vv_session"
        const val DEMO_CREDITS = 3
        /** Sentinelle : « on ne sait pas encore », jamais affichee comme un solde. */
        const val CREDITS_INCONNUS = -1
        const val KEY_SECTOR = "onboarding_sector"
    }
}
