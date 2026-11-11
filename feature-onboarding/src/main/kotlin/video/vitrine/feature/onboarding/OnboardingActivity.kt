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
                // D42.30 : statut typé (attente/ok/solde_zero/horsligne/refuse)
                // + dernier refus serveur (statut HTTP + code) — fin du
                // « connexion perdue » affiché à tort pour tout échec.
                var statutCredits by rememberSaveable {
                    mutableStateOf(if (isDemo) "ok" else "attente")
                }
                var refusCredits by rememberSaveable { mutableStateOf(0) }
                var codeRefusCredits by rememberSaveable { mutableStateOf("") }
                var demarrageLance by remember { mutableStateOf(false) }

                val sector = sectorCode?.let { code ->
                    Sector.entries.firstOrNull { it.code == code }
                }

                if (refStepDone && !isDemo && statutCredits == "attente" && !demarrageLance) {
                    // D42.9 : un seul demarrage, meme si la composition est
                    // reevaluee plusieurs fois (avant : un appel par reclic).
                    demarrageLance = true
                    LaunchedEffect(Unit) {
                        when (val etat = demarrageServeur(uid, token, refCode, repository)) {
                            is EtatCredits.Confirme -> {
                                credits = etat.credits
                                statutCredits = if (etat.credits > 0) "ok" else "solde_zero"
                            }
                            is EtatCredits.HorsLigne -> {
                                credits = etat.credits
                                statutCredits = "horsligne"
                            }
                            is EtatCredits.Refuse -> {
                                refusCredits = etat.statut
                                codeRefusCredits = etat.code
                                statutCredits = "refuse"
                            }
                        }
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
                        statut = statutCredits,
                        refusStatut = refusCredits,
                        refusCode = codeRefusCredits,
                        onContinue = {
                            finishWith(sector, credits.takeIf { it > 0 }, refCode)
                        }
                    )
                }
            }
        }
    }

    /**
     * D42.30 — état typé du démarrage serveur des crédits (taxonomie exacte,
     * fin du tout-« connexion perdue » du retour terrain RC14).
     */
    private sealed class EtatCredits {
        data class Confirme(val credits: Int) : EtatCredits()
        data class HorsLigne(val credits: Int) : EtatCredits()
        data class Refuse(val statut: Int, val code: String) : EtatCredits()
    }

    /**
     * Démarrage serveur du compte (D41 → D42.30) : enchaînement CONTRÔLÉ —
     * 1) vérification du jeton + bootstrap du profil (le résultat est EXIGÉ :
     * avant, l'échec était ignoré et le grant était tenté sur un profil
     * inexistant → message « connexion » mensonger) ;
     * 2) claim du parrainage UNIQUEMENT si un code est présent (facultatif) ;
     * 3) welcome-grant typé (Accorde / HorsLigne / Refuse) ;
     * 4) miroir local + confirmation du solde serveur (me/entitlements).
     */
    private suspend fun demarrageServeur(
        uid: String,
        token: String?,
        refCode: String?,
        repository: WelcomeRepository,
    ): EtatCredits {
        val sync = video.vitrine.data.api.BackendSync
        // 1) bootstrap : sans réponse = réseau/délai ; statut non-2xx = refus
        // serveur — dans les DEUX cas on ne tente PAS le grant (mission D42.30).
        val boot = runCatching {
            sync.bootstrapDetaille(BuildConfig.API_BASE_URL, token ?: "")
        }.getOrNull()
        if (boot == null) {
            android.util.Log.w("VV-ONB", "bootstrap sans réponse (réseau/délai) — rattrapage au retour réseau")
            return EtatCredits.HorsLigne(soldeLocalAffichable())
        }
        if (boot.status !in 200..299) {
            android.util.Log.w("VV-ONB", "bootstrap refusé : HTTP ${boot.status} ${boot.body.take(120)}")
            return EtatCredits.Refuse(boot.status, codeErreurServeur(boot.body))
        }
        // 2) parrainage facultatif — jamais bloquant pour les crédits
        if (!token.isNullOrBlank() && !refCode.isNullOrBlank()) {
            val claimed = runCatching {
                sync.claimReferral(this, BuildConfig.API_BASE_URL, token, refCode)
            }.getOrDefault(false)
            if (claimed) sync.recordReferralClaimed(this, uid, refCode)
        }
        // 3) welcome-grant typé
        return when (val grant = repository.demanderGrant(token ?: "")) {
            is WelcomeRepository.ResultatGrant.Accorde -> {
                // 4) miroir local + confirmation du solde serveur (best effort)
                sync.persistWelcomeGrant(this, uid, grant.creditsTotal)
                runCatching {
                    sync.syncEntitlements(
                        video.vitrine.data.local.VitrineLocalDatabase.get(this),
                        BuildConfig.API_BASE_URL,
                        token ?: "",
                        uid
                    )
                }
                EtatCredits.Confirme(grant.creditsTotal)
            }
            is WelcomeRepository.ResultatGrant.HorsLigne ->
                EtatCredits.HorsLigne(grant.creditsAffiches)
            is WelcomeRepository.ResultatGrant.Refuse ->
                EtatCredits.Refuse(grant.statut, grant.code)
        }
    }

    /** Solde affichable hors-ligne : le seed local honnête de la politique
     *  crédit (la valeur réelle est TOUJOURS décidée serveur et confirmée au
     *  retour réseau — jamais fabriquée par le client). */
    private fun soldeLocalAffichable(): Int = video.vitrine.core.guard.CreditPolicy.WELCOME_TOTAL

    private fun codeErreurServeur(corps: String): String =
        Regex("\"error\"\\s*:\\s*\"([a-z_]+)\"").find(corps)?.groupValues?.get(1) ?: ""

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
