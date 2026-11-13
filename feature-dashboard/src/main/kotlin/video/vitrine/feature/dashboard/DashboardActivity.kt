package video.vitrine.feature.dashboard

import android.app.AlertDialog
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import video.vitrine.core.designsystem.VitrineActivity
import androidx.activity.compose.setContent
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import video.vitrine.core.designsystem.VitrineLocale
import video.vitrine.core.designsystem.sectorLabelRes
import video.vitrine.core.model.Sector
import video.vitrine.data.api.BackendSync
import video.vitrine.data.local.VitrineLocalDatabase
import java.io.File

/**
 * Hub des ecrans 9/10/12 : dashboard, paywall, parrainage, reglages.
 * Lecture locale Room d'abord (hors-ligne), rafraichissement serveur opportuniste.
 *
 * Audit D41 :
 * - F1 (P1) : le paywall affichait ui(0, 0) EN DUR — il consomme desormais le
 *   miroir Room (autorite serveur via flushPending/syncEntitlements).
 * - F2 (P1) : la jauge de parrainage affichait 0 et un code invente — GET
 *   /api/v1/me/referral (serveur) avec repli sur le miroir Room hors-ligne.
 * - F5 (P1) : « Se deconnecter » fermait juste l'ecran (session Firebase et prefs
 *   intactes = fausse deconnexion) — signOut reel + purge session + retour accueil.
 * - F6 (P1) : les 4 boutons Reglages (langue, secteur, accords, espace) etaient
 *   morts — comportement reel pour chacun (zero bouton mort, exigence D19).
 * - F10 (P1) : checkout cree cote SERVEUR (POST /billing/checkout, cle CinetPay
 *   secrete) ; le client ouvre le payment_url heberge. Jamais de faux succes :
 *   501 = fournisseur non configure, message honnete.
 */
class DashboardActivity : VitrineActivity() {

    private var view = "dashboard"
    private var cachedRow: video.vitrine.data.local.EntitlementsCache? = null
    private var synced = false
    private var gaugeUi: ReferralGaugeUi? = null
    private var storageLabel: String? = null
    private var sectorOverride: String? = null
    private var merchantId = "local"

    /** D42.32 (Lot 5) : etat de sync honnete affiche par la carte credits. */
    private var syncEtat: SyncState = SyncState.EN_COURS

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        view = intent.getStringExtra("view") ?: "dashboard"
        val session = getSharedPreferences("vv_session", MODE_PRIVATE)
        merchantId = intent.getStringExtra("merchant_id")
            ?: session.getString("uid", null)
            ?: "local"
        render()
        synchroniser()
    }

    /**
     * D42.32 (Lot 5) : sync serveur unique, reutilisee par « Reessayer ».
     * Etat honnete : SYNCHRONISE seulement si flushPending reussit (preuve
     * d'un aller-retour serveur), HORS_CONNEXION sinon.
     */
    private fun synchroniser() {
        val session = getSharedPreferences("vv_session", MODE_PRIVATE)
        lifecycleScope.launch {
            withContext(Dispatchers.IO) {
                val db = VitrineLocalDatabase.get(this@DashboardActivity)
                cachedRow = runCatching { db.entitlements().byMerchant(merchantId) }.getOrNull()
                val token = session.getString("token", null)
                if (!synced) {
                    synced = true
                    val flushOk = runCatching {
                        BackendSync.flushPending(
                            this@DashboardActivity, db, BuildConfig.API_BASE_URL, token, merchantId
                        )
                    }.isSuccess
                    syncEtat = if (flushOk) SyncState.SYNCHRONISE else SyncState.HORS_CONNEXION
                    cachedRow = runCatching { db.entitlements().byMerchant(merchantId) }.getOrNull()
                }
                chargerParrainage(db, token)
            }
            storageLabel = espaceUtilise()
            render()
        }
    }

    /** Bouton « Reessayer » : force un nouveau cycle de sync complet. */
    private fun relancerSync() {
        synced = false
        syncEtat = SyncState.EN_COURS
        render()
        synchroniser()
    }

    /** D42.32 (Lot 6) : « Copier mon code » copie REELLEMENT au presse-papiers. */
    private fun copierCode() {
        val code = gaugeUi?.code ?: intent.getStringExtra("code")
        if (code.isNullOrBlank()) {
            message(R.string.ref_share_no_code)
            return
        }
        val pressePapiers = getSystemService(CLIPBOARD_SERVICE) as android.content.ClipboardManager
        pressePapiers.setPrimaryClip(
            android.content.ClipData.newPlainText("code parrain", code)
        )
        message(R.string.ref_code_copied)
    }

    /** Serveur d'abord (autorite), miroir Room en repli hors-ligne (D41 F2). */
    private suspend fun chargerParrainage(
        db: VitrineLocalDatabase,
        token: String?
    ) {
        val info = if (!token.isNullOrBlank()) {
            runCatching { BackendSync.fetchReferral(BuildConfig.API_BASE_URL, token) }.getOrNull()
        } else {
            null
        }
        if (info != null && info.code.isNotBlank()) {
            BackendSync.persistReferral(this, merchantId, info)
            gaugeUi = ReferralGauge.ui(
                code = info.code,
                converted = info.converted,
                rewards = info.rewards,
                entries = info.historyStatuses.take(20).map {
                    ReferralEntry(it, it == "converted")
                }
            )
            return
        }
        val miroir = runCatching { db.referrals().byMerchant(merchantId) }.getOrNull()
        if (miroir != null && !miroir.referralCode.isNullOrBlank()) {
            val convertis = miroir.referredConverted
            val total = maxOf(miroir.referredTotal, convertis)
            gaugeUi = ReferralGauge.ui(
                code = miroir.referralCode ?: "",
                converted = convertis,
                rewards = 0,
                entries = List(convertis) { ReferralEntry("converted", true) } +
                    List(total - convertis) { ReferralEntry("pending", false) }
            )
        }
    }

    // D41 (detekt CyclomaticComplexMethod) : chaque branche de navigation est
    // extraite dans sa propre composable — render() ne fait plus que router.
    private fun render() {
        setContent {
            video.vitrine.core.designsystem.VitrineTheme {
                when (view) {
                    "paywall" -> PaywallView()
                    "referral" -> ReferralView()
                    "settings" -> SettingsView()
                    else -> DashboardView()
                }
            }
        }
    }

    @androidx.compose.runtime.Composable
    private fun PaywallView() {
        PaywallScreen(
            PaywallMapper.ui(
                cachedRow?.welcomeCreditsLeft ?: 0,
                cachedRow?.exportsLimit ?: 0
            )
        ) { plan -> startCheckout(plan) }
    }

    @androidx.compose.runtime.Composable
    private fun ReferralView() {
        ReferralScreen(
            gaugeUi ?: ReferralGauge.ui(
                intent.getStringExtra("code") ?: "",
                0,
                0
            ),
            onShare = { share() }
        )
    }

    @androidx.compose.runtime.Composable
    private fun DashboardView() {
        DashboardScreen(
            cachedRow,
            cachedRow?.welcomeCreditsLeft ?: 0,
            { view = "paywall"; render() },
            { view = "referral"; render() },
            onSettings = { view = "settings"; render() },
            merchantName = intent.getStringExtra("merchant_name") ?: "",
            sectorLabel = sectorOverride ?: intent.getStringExtra("sector_label") ?: "",
            referralCode = gaugeUi?.code ?: intent.getStringExtra("code") ?: "",
            referralGauge = gaugeUi,
            syncState = syncEtat,
            onRetrySync = { relancerSync() },
            onCreateVideo = { finishWithCreate() },
            onCopyCode = { copierCode() },
            onShareWhatsApp = { share() },
            onViewFilleuls = { view = "referral"; render() }
        )
    }

    @androidx.compose.runtime.Composable
    private fun SettingsView() {
        SettingsScreen(
            accountEmail = intent.getStringExtra("email") ?: "—",
            languageLabel = when (VitrineLocale.saved(this)) {
                "en" -> "English"
                else -> "Français"
            },
            referralCode = gaugeUi?.code ?: intent.getStringExtra("code") ?: "—",
            sectorLabel = sectorOverride ?: intent.getStringExtra("sector_label") ?: "—",
            consentsCount = intent.getIntExtra("consents", 0),
            storageUsedLabel = storageLabel
                ?: intent.getStringExtra("storage")
                ?: getString(R.string.set_storage_default),
            // D41 (F6) : plus AUCUN bouton mort — chaque carte a un comportement reel.
            onChangeLanguage = { montrerDialogLangue() },
            onViewReferral = { view = "referral"; render() },
            onChangeSector = { montrerDialogSecteur() },
            onViewConsents = { montrerDialogAccords() },
            onClearRawTakes = { confirmerNettoyageEspace() },
            onLogout = { confirmerDeconnexion() }
        )
    }

    private fun montrerDialogLangue() {
        // D42.30 : FR/EN uniquement.
        val codes = arrayOf("fr", "en")
        val libelles = arrayOf("Français", "English")
        val actuel = codes.indexOf(VitrineLocale.saved(this) ?: "fr").coerceAtLeast(0)
        AlertDialog.Builder(this)
            .setTitle(R.string.set_lang_dialog_title)
            .setSingleChoiceItems(libelles, actuel) { dialog, which ->
                VitrineLocale.save(this, codes[which])
                dialog.dismiss()
                intent.putExtra("view", view)
                recreate()
            }
            .setNegativeButton(R.string.dialog_cancel) { dialog, _ -> dialog.dismiss() }
            .show()
    }

    private fun montrerDialogSecteur() {
        val secteurs = Sector.entries
        // D41 : dialog non composable — getString(sectorLabelRes(...)) au lieu de
        // sectorLabel (@Composable, stringResource) qui ne compile pas ici.
        val libelles = secteurs.map { getString(sectorLabelRes(it)) }.toTypedArray()
        AlertDialog.Builder(this)
            .setTitle(R.string.set_sector_dialog_title)
            .setItems(libelles) { _, which ->
                val choisi = secteurs[which]
                getSharedPreferences("vv_session", MODE_PRIVATE)
                    .edit().putString("sector", choisi.code).apply()
                sectorOverride = getString(sectorLabelRes(choisi))
                render()
            }
            .setNegativeButton(R.string.dialog_cancel) { dialog, _ -> dialog.dismiss() }
            .show()
    }

    private fun montrerDialogAccords() {
        AlertDialog.Builder(this)
            .setTitle(R.string.set_consents_dialog_title)
            .setMessage(getString(R.string.set_consents_dialog_body, intent.getIntExtra("consents", 0)))
            .setPositiveButton(android.R.string.ok) { dialog, _ -> dialog.dismiss() }
            .show()
    }

    private fun confirmerNettoyageEspace() {
        AlertDialog.Builder(this)
            .setMessage(R.string.set_clear_takes_confirm)
            .setPositiveButton(R.string.dialog_confirm) { _, _ ->
                lifecycleScope.launch {
                    withContext(Dispatchers.IO) {
                        runCatching {
                            File(filesDir, "rushes").listFiles()?.forEach { it.delete() }
                            cacheDir.listFiles { f ->
                                f.name.startsWith("export-") && f.name.endsWith(".mp4")
                            }?.forEach { it.delete() }
                        }
                        storageLabel = espaceUtilise()
                    }
                    AlertDialog.Builder(this@DashboardActivity)
                        .setMessage(R.string.set_clear_takes_done)
                        .setPositiveButton(android.R.string.ok) { d, _ -> d.dismiss() }
                        .show()
                    render()
                }
            }
            .setNegativeButton(R.string.dialog_cancel) { dialog, _ -> dialog.dismiss() }
            .show()
    }

    /** D41 (F5) : deconnexion REELLE — signOut Firebase + purge session, puis
     *  retour a l'accueil. La locale et les gabarits (donnees app, pas session)
     *  sont conserves ; le miroir Room est cle par uid (isolation comptes). */
    private fun confirmerDeconnexion() {
        AlertDialog.Builder(this)
            .setTitle(R.string.set_logout_confirm_title)
            .setMessage(R.string.set_logout_confirm_body)
            .setPositiveButton(R.string.dialog_confirm) { _, _ ->
                lifecycleScope.launch {
                    withContext(Dispatchers.IO) {
                        runCatching {
                            com.google.firebase.auth.FirebaseAuth.getInstance().signOut()
                        }
                        getSharedPreferences("vv_session", MODE_PRIVATE)
                            .edit().clear().apply()
                    }
                    runCatching {
                        startActivity(
                            Intent().setClassName(packageName, "video.vitrine.app.MainActivity")
                                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                        )
                    }
                    finishAffinity()
                }
            }
            .setNegativeButton(R.string.dialog_cancel) { dialog, _ -> dialog.dismiss() }
            .show()
    }

    /** Taille cumulee filesDir + cacheDir (Mo, arrondi) — libelle reel, plus de
     *  valeur figee transmise par intent. */
    private fun espaceUtilise(): String {
        fun taille(f: File?): Long {
            if (f == null) return 0L
            if (f.isFile) return f.length()
            return f.listFiles()?.sumOf { taille(it) } ?: 0L
        }
        val mo = (taille(filesDir) + taille(cacheDir)) / (1024L * 1024L)
        return getString(R.string.storage_mb_value, mo.toInt())
    }

    private fun finishWithCreate() {
        setResult(RESULT_OK, Intent().putExtra("create_video", true))
        finish()
    }

    /**
     * D41 (F10, P1) : checkout cote SERVEUR. POST /api/v1/billing/checkout cree la
     * commande (cle CinetPay secrete cote worker) et renvoie le payment_url heberge
     * que le client ouvre dans le navigateur. Reponses honnetes :
     * 501 = fournisseur non configure, 401 = compte requis, 0 = hors-ligne.
     * AUCUN faux succes, AUCUNE URL inventee cote client.
     */
    private fun startCheckout(planCode: String) {
        val token = getSharedPreferences("vv_session", MODE_PRIVATE).getString("token", null)
        lifecycleScope.launch {
            val (checkout, status) = withContext(Dispatchers.IO) {
                BackendSync.createCheckout(BuildConfig.API_BASE_URL, token ?: "", planCode)
            }
            if (checkout != null &&
                video.vitrine.core.model.billing.BillingCheckout.isValidRef(checkout.ref)
            ) {
                setResult(
                    RESULT_OK,
                    Intent().putExtra("plan", planCode).putExtra("checkout_ref", checkout.ref)
                )
                val ouvert = runCatching {
                    startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(checkout.paymentUrl)))
                }.isSuccess
                if (ouvert) {
                    finish()
                } else {
                    message(R.string.billing_no_browser)
                }
            } else {
                message(
                    when (status) {
                        501 -> R.string.checkout_not_configured
                        401, 403 -> R.string.billing_need_account
                        0 -> R.string.billing_network_error
                        else -> R.string.billing_error_generic
                    }
                )
            }
        }
    }

    private fun message(res: Int) {
        AlertDialog.Builder(this)
            .setMessage(res)
            .setPositiveButton(android.R.string.ok) { d, _ -> d.dismiss() }
            .show()
    }

    private fun share() {
        val code = gaugeUi?.code ?: intent.getStringExtra("code")
        if (code.isNullOrBlank()) {
            message(R.string.ref_share_no_code)
            return
        }
        val send = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, getString(R.string.referral_share_message, code))
        }
        runCatching {
            startActivity(Intent.createChooser(send, getString(R.string.referral_share_chooser)))
        }
    }
}
