package video.vitrine.app

import video.vitrine.core.designsystem.VitrineActivity
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import android.content.Intent
import android.os.Bundle
import android.os.SystemClock
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import video.vitrine.core.designsystem.VitrineLocale
import video.vitrine.feature.catalog.CatalogActivity
import video.vitrine.feature.onboarding.LanguageActivity
import video.vitrine.feature.onboarding.OnboardingActivity
import video.vitrine.feature.onboarding.auth.AuthActivity

/**
 * Navigateur du parcours demo (JSON ecrans 3.7) :
 * 1 auth -> 2 onboarding -> 3 catalogue -> 4 brief -> 5 camera guidee -> 6 export.
 * Orchestration centrale : la regle de graphe interdit feature -> feature (checkModuleGraph).
 * Chaque ecran rend un resultat ; aucun bouton sans listener, aucun ecran bloquant.
 */
class MainActivity : VitrineActivity() {

    private var briefScript: String? = null
    private var briefDuration: Int = 30
    private var briefRushs: Array<String>? = null
    private var authToken: String? = null
    private var authUid: String? = null
    private var refCode: String? = null
    private var sectorCode: String? = null
    private var welcomeCredits: Int = 0
    private var gabaritId: String? = null

    // D42.14 : anti double-lancement. Mesuré au run 42241430727 (P1) : chaque
    // ecran d'orchestration etait demarre DEUX fois (Language a 637 ms,
    // Auth a 32 ms, Onboarding a 12 ms d'intervalle — recréation/course au
    // lancement). L'instance périmée laissée sur la pile faisait réapparaître
    // un carrousel vierge après le finish() de l'instance pilotée, et le
    // catalogue n'était plus jamais atteint (1 run sur 3). Le run P0 réussi
    // du même commit n'avait qu'UN démarrage par écran : c'est bien le
    // doublon, et lui seul, qui casse le parcours.
    private var dernierLancementMs: Long = 0L

    private fun lancerUneSeuleFois(intent: Intent, requestCode: Int) {
        val maintenant = SystemClock.uptimeMillis()
        if (dernierLancementMs != 0L && maintenant - dernierLancementMs < 1_000) {
            return  // second déclenchement d'un même événement : ignoré
        }
        dernierLancementMs = maintenant
        startActivityForResult(intent, requestCode)
    }
    private val briefValues = mutableMapOf<String, String>()
    private var skinId: String? = null
    private var skinName: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()
        super.onCreate(savedInstanceState)
        restaurerEtat(savedInstanceState)
        // Audit D41 (F34/F63) : le deep-link de parrainage https://vitrine.video/r/CODE
        // arrive ICI (seule activite exportee) ; le code est transmis a l'auth puis
        // a l'onboarding. Avant, le filtre etait sur AuthActivity (exportee) : le
        // jeton Firebase etait recuperable par n'importe quelle app lancante et le
        // parcours s'arretait au retour navigateur.
        intent?.data?.let { uri ->
            video.vitrine.feature.onboarding.auth.RefCodeParser.fromDeepLink(uri.toString())
                ?.let { refCode = it }
        }
        nettoyageFichiersPerimes()
        restaurerSession()
        // D42.14 : lors d'une recréation (changement de configuration au
        // démarrage, mesuré : LanguageActivity demarree deux fois a 637 ms
        // d'intervalle), l'ecran deja a l'ecran ne doit pas etre relance :
        // l'instance en double restait sur la pile et cassait la navigation.
        if (savedInstanceState == null) {
            if (VitrineLocale.saved(this) == null) {
                lancerUneSeuleFois(Intent(this, LanguageActivity::class.java), REQ_LANGUAGE)
            } else {
                lancerUneSeuleFois(authIntent(), REQ_AUTH)
            }
        }
    }

    /**
     * D42.9 : le jeton vivait uniquement en memoire. Apres une mort de process
     * (memoire insuffisante, changement de configuration, appel entrant) le
     * parcours repartait de zero et les ecrans suivants recevaient un jeton nul.
     * On relit la session courte (1 h) deja deposee par AuthActivity.
     */
    private fun restaurerSession() {
        val prefs = getSharedPreferences("vv_session", MODE_PRIVATE)
        authToken = prefs.getString("token", null)
        authUid = prefs.getString("uid", null)
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        // D42.9 : l'etape courante survit a une recreation d'activite.
        outState.putString(KEY_SECTOR, sectorCode)
        outState.putString(KEY_GABARIT, gabaritId)
        outState.putString(KEY_SKIN_NAME, skinName)
        outState.putInt(KEY_CREDITS, welcomeCredits)
    }

    private fun restaurerEtat(saved: Bundle?) {
        if (saved == null) return
        sectorCode = saved.getString(KEY_SECTOR)
        gabaritId = saved.getString(KEY_GABARIT)
        skinName = saved.getString(KEY_SKIN_NAME)
        welcomeCredits = saved.getInt(KEY_CREDITS, 0)
    }

    private fun authIntent(): Intent =
        Intent(this, AuthActivity::class.java).putExtra("ref_code", refCode)

    /**
     * Audit D41 (F51) : les rushs (filesDir/rushes) et exports (cacheDir/export-*.mp4)
     * n'etaient JAMAIS purges — remplissage progressif du stockage commerçant
     * (contexte : telephones a petit stockage). Purge au lancement des fichiers de
     * plus de 24 h (un export partage reste valide pendant toute la session).
     */
    private fun nettoyageFichiersPerimes() {
        val cutoff = System.currentTimeMillis() - PERIME_AGE_MS
        Thread {
            runCatching {
                java.io.File(filesDir, "rushes").listFiles()?.forEach { f ->
                    if (f.lastModified() < cutoff) f.delete()
                }
                cacheDir.listFiles { file -> file.name.startsWith("export-") && file.name.endsWith(".mp4") }
                    ?.forEach { f -> if (f.lastModified() < cutoff) f.delete() }
            }
        }.start()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode != RESULT_OK) {
            stepBack(requestCode)
            return
        }
        when (requestCode) {
            REQ_LANGUAGE -> lancerUneSeuleFois(authIntent(), REQ_AUTH)
            REQ_AUTH -> {
                authToken = data?.getStringExtra("firebase_token")
                authUid = data?.getStringExtra("firebase_uid")
                refCode = data?.getStringExtra("ref_code")
                launchOnboarding()
            }
            REQ_ONBOARDING -> {
                sectorCode = data?.getStringExtra("sector")
                welcomeCredits = data?.getIntExtra("welcome_credits", 0) ?: 0
                // D42.27 (§7) : un brouillon inter-sessions existe ? Le proposer
                // AVANT le catalogue (sinon comportement inchangé — aucun parcours
                // e2e sur runner frais n'a jamais de brouillon résiduel).
                peutProposerReprise()
            }
            REQ_CATALOG -> {
                skinId = data?.getStringExtra("skin_id")
                skinName = data?.getStringExtra("skin_name")
                gabaritId = data?.getStringExtra("gabarit_id") ?: skinId
                launchBrief()
            }
            REQ_BRIEF -> {
                briefScript = data?.getStringExtra("script")
                briefDuration = data?.getIntExtra("duration_s", 30) ?: 30
                briefRushs = data?.getStringArrayExtra("client_rushes")
                collectBriefValues(data)
                // D42.27 (§7) : le brief VALIDÉ persiste (brouillon étape CAMERA)
                // — survit à la fermeture de l'app et au redémarrage du téléphone.
                lifecycleScope.launch(kotlinx.coroutines.Dispatchers.IO) {
                    runCatching {
                        video.vitrine.data.local.DraftStore.promouvoirCamera(
                            this@MainActivity,
                            gabaritId.orEmpty(),
                            skinId,
                            skinName,
                            briefScript.orEmpty(),
                            briefDuration,
                            data?.getStringExtra("objective"),
                            data?.getStringExtra("scenes"),
                            briefValues,
                            briefRushs?.toList() ?: emptyList()
                        )
                    }
                }
                startActivityForResult(
                    Intent(this, video.vitrine.feature.camera.CameraGuideActivity::class.java)
                        .putExtra("script", briefScript)
                        .putExtra("gabarit_id", gabaritId)
                        .putExtra("duration_s", briefDuration),
                    REQ_CAMERA
                )
            }
            REQ_CAMERA -> {
                val rush = data?.getStringExtra("input") ?: return
                launchExport(rush, data?.getStringArrayExtra("client_rushes"))
            }
        }
    }

    /**
     * Lancement de l'export (audit D40, A5) : les prises filmees au guide E6
     * deviennent les rushs du moteur (rushIndex du beat sheet gabarit) ; le
     * token suit pour quota/consume + BGM (routes authentifiees). Extrait
     * d'onActivityResult pour la complexite cyclomatique (detekt <= 15).
     */
    private fun launchExport(rush: String, camRushes: Array<String>?) {
        val rushes = ((briefRushs ?: emptyArray()) + (camRushes ?: emptyArray()))
            .takeIf { it.isNotEmpty() }
        startActivity(
            Intent(ACTION_EXPORT)
                .setPackage(packageName)
                .putExtra("input", rush)
                .putExtra("script", briefScript)
                .putExtra("duration_s", briefDuration)
                .putExtra("client_rushes", rushes)
                .putExtra("firebase_token", authToken)
                .putExtra("gabarit_id", gabaritId)
                .also { intent ->
                    briefValues.forEach { (k, v) -> intent.putExtra("brief_$k", v) }
                    intent.putExtra("brief_keys", briefValues.keys.toTypedArray())
                }
        )
        finish()
    }

    /**
     * Retour natif Android : revenir a l'ecran precedent pour corriger un choix,
     * sans crash ni ejection vers l'accueil. Seul le premier ecran (langue) quitte.
     */
    private fun stepBack(requestCode: Int) {
        when (requestCode) {
            REQ_LANGUAGE -> finish()
            REQ_AUTH -> startActivityForResult(
                Intent(this, LanguageActivity::class.java),
                REQ_LANGUAGE
            )
            REQ_ONBOARDING -> startActivityForResult(authIntent(), REQ_AUTH)
            REQ_CATALOG -> launchOnboarding()
            REQ_BRIEF -> launchCatalog()
            REQ_CAMERA -> launchBrief()
            else -> finish()
        }
    }

    private fun launchOnboarding() {
        lancerUneSeuleFois(
            Intent(this, OnboardingActivity::class.java)
                .putExtra("firebase_token", authToken)
                .putExtra("firebase_uid", authUid)
                .putExtra("ref_code", refCode),
            REQ_ONBOARDING
        )
    }

    private fun launchCatalog() {
        lancerUneSeuleFois(
            Intent(this, CatalogActivity::class.java)
                .putExtra("sector", sectorCode)
                .putExtra("welcome_credits", welcomeCredits)
                .putExtra("firebase_token", authToken),
            REQ_CATALOG
        )
    }

    /** Recueil des reponses brief (extras brief_*) pour apercu E7 et export. */
    private fun collectBriefValues(data: Intent?) {
        data?.getStringArrayExtra("brief_keys")?.forEach { k ->
            briefValues[k] = data.getStringExtra("brief_$k").orEmpty()
        }
    }

    /**
     * D42.27 (§7) — reprise de brouillon. Si un projet est en cours (saisie
     * brief OU tournage), l'utilisateur choisit : Reprendre (retour exact à
     * l'étape en cours, rushs restaurés) ou Nouvelle vidéo (brouillon effacé
     * — décision EXPLICITE, jamais de suppression silencieuse).
     */
    private fun peutProposerReprise() {
        lifecycleScope.launch {
            val draft = runCatching {
                video.vitrine.data.local.DraftStore.actif(this@MainActivity)
            }.getOrNull()
            if (draft == null) {
                launchCatalog()
                return@launch
            }
            gabaritId = draft.gabaritId
            skinId = draft.skinId
            skinName = draft.skinName
            android.app.AlertDialog.Builder(this@MainActivity)
                .setTitle(R.string.draft_resume_title)
                .setMessage(getString(R.string.draft_resume_body))
                .setCancelable(false)
                .setPositiveButton(R.string.draft_resume_yes) { _, _ -> reprendreDraft(draft) }
                .setNegativeButton(R.string.draft_resume_no) { _, _ ->
                    lifecycleScope.launch(kotlinx.coroutines.Dispatchers.IO) {
                        runCatching { video.vitrine.data.local.DraftStore.effacer(this@MainActivity) }
                    }
                    launchCatalog()
                }
                .show()
        }
    }

    private fun reprendreDraft(draft: video.vitrine.data.local.DraftEntity) {
        if (draft.etape == video.vitrine.data.local.DraftStore.ETAPE_CAMERA && !draft.script.isNullOrBlank()) {
            // Reprise du TOURNAGE : le guide repart à la prise sauvegardée,
            // avec les rushs existants (fichiers déjà persistants, filtrés).
            briefScript = draft.script
            briefDuration = if (draft.durationS > 0) draft.durationS else 30
            briefRushs = video.vitrine.data.local.DraftStore.jsonToList(draft.clientRushesJson)
                .toTypedArray()
            // Les réponses du brief servent aux extras brief_* de l'export
            // (aperçu E7 + rendu) : les restaurer depuis le brouillon aussi,
            // sinon l'export après reprise perdrait les textes du gabarit.
            briefValues.clear()
            briefValues.putAll(
                video.vitrine.data.local.DraftStore.jsonToMap(draft.briefValuesJson)
            )
            startActivityForResult(
                Intent(this, video.vitrine.feature.camera.CameraGuideActivity::class.java)
                    .putExtra("script", briefScript)
                    .putExtra("gabarit_id", gabaritId)
                    .putExtra("duration_s", briefDuration)
                    .putExtra(
                        "restore_prise_files",
                        video.vitrine.data.local.DraftStore.jsonToList(draft.priseFilesJson).toTypedArray()
                    )
                    .putExtra("restore_prise_idx", draft.priseIdx),
                REQ_CAMERA
            )
        } else {
            // Reprise de la SAISIE du brief (formulaire pré-rempli par BriefActivity).
            launchBrief()
        }
    }

    private fun launchBrief() {
        startActivityForResult(
            Intent(this, video.vitrine.feature.brief.BriefActivity::class.java)
                .putExtra("skin_id", skinId)
                .putExtra("skin_name", skinName)
                .putExtra("gabarit_id", gabaritId),
            REQ_BRIEF
        )
    }

    private companion object {
        const val REQ_LANGUAGE = 9
        const val REQ_AUTH = 10
        const val REQ_ONBOARDING = 11
        const val REQ_CATALOG = 12
        const val REQ_BRIEF = 13
        const val REQ_CAMERA = 14
        const val ACTION_EXPORT = "video.vitrine.action.START_EXPORT"
        const val PERIME_AGE_MS = 24L * 3600L * 1000L
        // D42.9 : etat de navigation sauve (mort de process / rotation).
        const val KEY_SECTOR = "main_sector"
        const val KEY_GABARIT = "main_gabarit"
        const val KEY_SKIN_NAME = "main_skin_name"
        const val KEY_CREDITS = "main_credits"
    }
}
