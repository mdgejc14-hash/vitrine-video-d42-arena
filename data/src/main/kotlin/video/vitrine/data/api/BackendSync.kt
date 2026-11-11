package video.vitrine.data.api

import android.content.Context
import android.util.Log
import org.json.JSONArray
import org.json.JSONObject
import video.vitrine.core.model.billing.DeviceFingerprint
import video.vitrine.data.local.EntitlementsCache
import video.vitrine.data.local.ReferralLocal
import video.vitrine.data.local.TelemetryOutbox
import video.vitrine.data.local.VitrineLocalDatabase

/**
 * Synchronisation backend unique (audit D40 : A3/A7/A8/A9 — avant ce fichier,
 * quota/consume, telemetry, referral/claim et me/entitlements n'etaient JAMAIS
 * appeles par l'app : credits serveur jamais decrementes = fuite metier,
 * telemetrie morte, parrainage coupe, droits jamais synchronises).
 *
 * Principes : offline-first (Room d'abord, reseau ensuite), idempotence
 * serveur (eventId), retries via files locales, jamais d'exception remontee.
 */
object BackendSync {

    private const val PREFS = "vv_sync"
    private const val PENDING_QUOTA = "pending_quota"
    private const val PENDING_CLAIM = "pending_claim"
    private const val MAX_PENDING = 50

    /**
     * Audit D41 (F42, P0) : POST /api/v1/me/bootstrap cree la ligne `users`
     * SANS laquelle TOUTES les routes /me/..., /quota/consume et /audio/...
     * repondent 404 profile_not_initialized (requireUser). Idempotent serveur
     * (ON CONFLICT firebase_uid). A appeler des l'obtention du jeton Firebase.
     */
    suspend fun bootstrap(baseUrl: String, token: String): Boolean {
        if (token.isBlank()) return false
        val reply = runCatching { ApiClient(baseUrl).post("/api/v1/me/bootstrap", token, "{}") }.getOrNull()
        return reply != null && reply.status in 200..299
    }

    /**
     * D42.30 (retour terrain) : réponse BRUTE du bootstrap — le parcours
     * d'inscription doit distinguer réseau perdu (null), 401 (jeton), 403
     * (compte inactif), 404/5xx (serveur) au lieu de tout fusionner en
     * « connexion perdue ». bootstrap() reste le résumé booléen historique.
     */
    suspend fun bootstrapDetaille(baseUrl: String, token: String): ApiClient.Reply? {
        if (token.isBlank()) return null
        return runCatching { ApiClient(baseUrl).post("/api/v1/me/bootstrap", token, "{}") }.getOrNull()
    }

    /** ISO-8601 UTC sans java.time (minSdk 24, pas de desugaring). */
    private fun isoNow(): String {
        val format = java.text.SimpleDateFormat(
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", java.util.Locale.US
        )
        format.timeZone = java.util.TimeZone.getTimeZone("UTC")
        return format.format(java.util.Date())
    }

    /** Empreinte appareil du contrat welcome-grant/quota (D13). */
    fun fingerprint(context: Context): String = DeviceFingerprint.of(
        android.provider.Settings.Secure.getString(
            context.contentResolver,
            android.provider.Settings.Secure.ANDROID_ID
        ) ?: "inconnu",
        android.os.Build.FINGERPRINT
    )

    /**
     * Trace un export : telemetrie locale (outbox Room) + consommation quota
     * serveur si l'export est CONFIRME (source=welcome, kind=export).
     */
    suspend fun recordExport(
        context: Context,
        db: VitrineLocalDatabase,
        baseUrl: String,
        eventId: String,
        gabaritId: String?,
        ok: Boolean,
        bgmMixed: Boolean,
        token: String?
    ) {
        runCatching {
            db.telemetry().insert(
                TelemetryOutbox(
                    event = when {
                        !ok -> "export_failed"
                        bgmMixed -> "export_confirmed_bgm"
                        else -> "export_confirmed"
                    },
                    gabaritId = gabaritId,
                    ok = ok,
                    durationMs = 0L,
                    ctaClicks = 0,
                    ts = isoNow()
                )
            )
        }
        if (ok) postQuotaOrQueue(context, baseUrl, eventId, token)
    }

    /** POST quota/consume ; echec/hors-ligne -> file locale (rejouee au flush).
     *  Audit D41 (F38) : jeton non-JWT (session demo) = jamais envoye ni mis en
     *  file (il ne deviendra jamais valide et polluerait le quota d'un futur
     *  compte reel) ; 400/403/404 = refus DEFINITIF, pas de rejeu eternel.
     *  401 (jeton expire) RESTE rejouable : le flush apres reconnexion utilise
     *  le jeton frais des prefs. */
    suspend fun postQuotaOrQueue(context: Context, baseUrl: String, eventId: String, token: String?) {
        if (token.isNullOrBlank() || token.count { it == '.' } != 2) return
        val reply = runCatching { ApiClient(baseUrl).post("/api/v1/quota/consume", token, quotaBody(context, eventId)) }.getOrNull()
        if (reply == null) {
            queuePendingQuota(context, eventId)
        } else if (reply.status !in 200..299 && !isNonRetryable(reply.status)) {
            queuePendingQuota(context, eventId)
        }
    }

    private fun quotaBody(context: Context, eventId: String): String = JSONObject()
        .put("eventId", eventId)
        .put("fingerprint", fingerprint(context))
        .put("source", "welcome")
        .put("kind", "export")
        .toString()

    /** 4xx d'autorite (hors 401 renouvelable et 429 temporaire) = refus definitif. */
    private fun isNonRetryable(status: Int): Boolean =
        status == 400 || status == 403 || status == 404

    private fun queuePendingQuota(context: Context, eventId: String) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        // Audit D41 : l'entree porte l'uid proprietaire (« uid|eventId ») — un
        // changement de compte sur l'appareil ne doit jamais consommer le quota
        // d'un autre marchand (isolation stricte des donnees par compte).
        val uid = context.getSharedPreferences("vv_session", Context.MODE_PRIVATE)
            .getString("uid", null).orEmpty()
        val pending = LinkedHashSet(prefs.getString(PENDING_QUOTA, "").orEmpty().split(",").filter { it.isNotBlank() })
        pending += "$uid|$eventId"
        val trimmed = pending.toList().takeLast(MAX_PENDING)
        prefs.edit().putString(PENDING_QUOTA, trimmed.joinToString(",")).apply()
    }

    /**
     * Flush complet quand le reseau revient : telemetrie (batch <= 200, route
     * publique) + quota en attente (token requis, uid proprietaire exige) +
     * claim de parrainage en attente (D41 F27) + welcome-grant jamais obtenu
     * (D41 F30) + droits synchronises.
     */
    suspend fun flushPending(context: Context, db: VitrineLocalDatabase, baseUrl: String, token: String?, uid: String?) {
        Log.i("D42-SYNC", "flushPending declenche (retour reseau / dashboard)")
        flushTelemetry(db, baseUrl)
        val jwt = token?.takeIf { it.count { c -> c == '.' } == 2 }
        if (jwt != null) {
            replayPendingQuota(context, baseUrl, jwt, uid.orEmpty())
            replayPendingClaim(context, baseUrl, jwt)
            replayWelcomeGrant(context, baseUrl, jwt, uid)
        }
        if (!jwt.isNullOrBlank() && !uid.isNullOrBlank()) {
            syncEntitlements(db, baseUrl, jwt, uid)
        }
    }

    private suspend fun replayPendingQuota(context: Context, baseUrl: String, token: String, uid: String) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val pending = prefs.getString(PENDING_QUOTA, "").orEmpty().split(",").filter { it.isNotBlank() }
        val restants = mutableListOf<String>()
        pending.forEach { entree ->
            // Format historique sans uid = anterieur a D41 : attribue a l'uid courant.
            val (owner, eventId) = if (entree.contains('|')) {
                entree.substringBefore('|') to entree.substringAfter('|')
            } else {
                "" to entree
            }
            if (owner.isNotEmpty() && owner != uid) {
                restants += entree          // autre compte : conserve, jamais rejoue ailleurs
                return@forEach
            }
            val reply = runCatching { ApiClient(baseUrl).post("/api/v1/quota/consume", token, quotaBody(context, eventId)) }.getOrNull()
            val rejouable = reply == null || (reply.status !in 200..299 && !isNonRetryable(reply.status))
            if (rejouable) restants += entree
        }
        prefs.edit().putString(PENDING_QUOTA, restants.joinToString(",")).apply()
    }

    /** Claim de parrainage en attente (code saisi hors-ligne) : rejeu idempotent serveur. */
    fun queuePendingClaim(context: Context, code: String) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit().putString(PENDING_CLAIM, code).apply()
    }

    private suspend fun replayPendingClaim(context: Context, baseUrl: String, token: String) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val code = prefs.getString(PENDING_CLAIM, null)?.takeIf { it.isNotBlank() } ?: return
        val reply = runCatching {
            ApiClient(baseUrl).post(
                "/api/v1/me/referral/claim",
                token,
                JSONObject().put("code", code).put("fingerprint", fingerprint(context)).toString()
            )
        }.getOrNull()
        // 2xx = attribue ; 404 (code inconnu) / 409 (meme appareil) = definitifs,
        // on arrete d'insister. Reseau/5xx/401 = conserve pour le prochain flush.
        val solde = reply != null && (reply.status in 200..299 || isNonRetryable(reply.status))
        if (solde) prefs.edit().remove(PENDING_CLAIM).apply()
    }

    /** Welcome-grant jamais obtenu (onboarding hors-ligne) : redemande au flush. */
    private suspend fun replayWelcomeGrant(context: Context, baseUrl: String, token: String, uid: String?) {
        if (java.io.File(context.cacheDir, "welcome-grant.state").exists()) return
        val resultat = requestWelcomeGrant(context, baseUrl, token) ?: return
        if (uid != null) persistWelcomeGrant(context, uid, resultat.second)
    }

    private suspend fun flushTelemetry(db: VitrineLocalDatabase, baseUrl: String) {
        val rows = runCatching { db.telemetry().pending(200) }.getOrDefault(emptyList())
        if (rows.isEmpty()) return
        val events = JSONArray()
        rows.forEach { row ->
            events.put(
                JSONObject()
                    .put("v", "")
                    .put("dc", "")
                    .put("e", row.event)
                    .put("g", row.gabaritId ?: "")
                    .put("ok", row.ok)
                    .put("ms", row.durationMs)
                    .put("cta", row.ctaClicks)
                    .put("co", "")
                    .put("ts", row.ts)
            )
        }
        val body = JSONObject().put("events", events).toString()
        Log.i("D42-SYNC", "flush telemetry : ${rows.size} evenement(s) en attente, POST $baseUrl/api/v1/telemetry")
        val reply = runCatching { ApiClient(baseUrl).post("/api/v1/telemetry", null, body) }.getOrNull()
        Log.i("D42-SYNC", "flush telemetry : HTTP ${reply?.status ?: "reseau indisponible"}")
        if (reply != null && reply.status in 200..299) {
            runCatching { db.telemetry().markUploaded(rows.map { it.id }) }
        }
    }

    /** GET me/entitlements -> miroir Room (le serveur fait foi, R1/R3). */
    suspend fun syncEntitlements(db: VitrineLocalDatabase, baseUrl: String, token: String, uid: String) {
        val reply = runCatching { ApiClient(baseUrl).get("/api/v1/me/entitlements", token) }.getOrNull()
        if (reply == null || reply.status != 200) return
        runCatching {
            val json = JSONObject(reply.body)
            val existing = db.entitlements().byMerchant(uid)
            db.entitlements().upsert(
                EntitlementsCache(
                    merchantId = uid,
                    watermark = json.optInt("watermark", existing?.let { if (it.watermark) 1 else 0 } ?: 1) == 1,
                    endcardMention = json.optInt("endcard_mention", 1) == 1,
                    maxRes = json.optString("max_res", existing?.maxRes ?: "720p"),
                    exportsLimit = json.optInt("exports_limit", existing?.exportsLimit ?: 0),
                    fairUse = if (json.isNull("fair_use")) null else json.optInt("fair_use"),
                    cloudRenders = json.optInt("cloud_renders", 0),
                    brandKit = json.optInt("brand_kit", 0) == 1,
                    cacheDays = json.optInt("cache_days", existing?.cacheDays ?: 30),
                    welcomeCreditsLeft = json.optInt("welcome_credits_left", existing?.welcomeCreditsLeft ?: 0),
                    welcomeCloudLeft = json.optInt("welcome_cloud_left", 0),
                    fetchedAt = System.currentTimeMillis()
                )
            )
        }
    }

    /**
     * Grant serveur -> miroir Room (audit D40, A3) : API :data pour que les
     * features n'aient pas Room dans leur classpath de compilation.
     */
    suspend fun persistWelcomeGrant(context: Context, uid: String, credits: Int) {
        val db = VitrineLocalDatabase.get(context)
        runCatching {
            val existing = db.entitlements().byMerchant(uid)
            db.entitlements().upsert(
                (
                    existing ?: EntitlementsCache(
                        merchantId = uid,
                        watermark = true,
                        endcardMention = true,
                        maxRes = "720p",
                        exportsLimit = 0,
                        fairUse = null,
                        cloudRenders = 0,
                        brandKit = false,
                        cacheDays = 30,
                        welcomeCreditsLeft = 0,
                        welcomeCloudLeft = 0,
                        fetchedAt = System.currentTimeMillis(),
                    )
                    ).copy(
                    welcomeCreditsLeft = credits,
                    fetchedAt = System.currentTimeMillis(),
                )
            )
        }
    }

    /** Miroir local du claim de parrainage accepte (audit D40, A8). */
    suspend fun recordReferralClaimed(context: Context, uid: String, refCode: String) {
        runCatching {
            VitrineLocalDatabase.get(context).referrals().upsert(
                ReferralLocal(
                    merchantId = uid,
                    referralCode = refCode,
                    referredTotal = 0,
                    referredConverted = 0,
                    updatedAt = System.currentTimeMillis(),
                )
            )
        }
    }

    /** POST me/referral/claim { code, fingerprint } (R8 — anti auto-parrainage serveur).
     *  Audit D41 (F27) : echec reseau/5xx/401 -> code mis en file (rejoue au flush) ;
     *  404/409 = refus definitif serveur, pas de rejeu. Jeton non-JWT (demo) :
     *  jamais envoye (il ne deviendra jamais valide). */
    suspend fun claimReferral(context: Context, baseUrl: String, token: String, code: String): Boolean {
        if (token.count { it == '.' } != 2) return false
        val body = JSONObject()
            .put("code", code)
            .put("fingerprint", fingerprint(context))
            .toString()
        val reply = runCatching { ApiClient(baseUrl).post("/api/v1/me/referral/claim", token, body) }.getOrNull()
        if (reply == null || (reply.status !in 200..299 && !isNonRetryable(reply.status))) {
            queuePendingClaim(context, code)
        }
        return reply != null && reply.status in 200..299
    }

    /** Etat parrainage serveur (D41 F2 : la jauge E11 affichait 0 code en dur —
     *  GET /api/v1/me/referral existait cote serveur sans JAMAIS etre appele). */
    data class ReferralInfo(
        val code: String,
        val converted: Int,
        val target: Int,
        val rewards: Int,
        val historyStatuses: List<String>
    )

    suspend fun fetchReferral(baseUrl: String, token: String): ReferralInfo? {
        if (token.count { it == '.' } != 2) return null
        val reply = runCatching { ApiClient(baseUrl).get("/api/v1/me/referral", token) }.getOrNull()
        if (reply == null || reply.status != 200) return null
        return runCatching {
            val json = JSONObject(reply.body)
            val history = json.optJSONArray("history")
            val statuts = mutableListOf<String>()
            if (history != null) {
                for (i in 0 until history.length()) {
                    history.optJSONObject(i)?.optString("status")?.takeIf { it.isNotBlank() }
                        ?.let { statuts += it }
                }
            }
            ReferralInfo(
                code = json.optString("code", ""),
                converted = json.optInt("converted", 0),
                target = json.optInt("target", 5),
                rewards = json.optInt("rewards", 0),
                historyStatuses = statuts
            )
        }.getOrNull()
    }

    /** Miroir Room de l'etat parrainage (lecture hors-ligne du dashboard). */
    suspend fun persistReferral(context: Context, uid: String, info: ReferralInfo) {
        runCatching {
            VitrineLocalDatabase.get(context).referrals().upsert(
                ReferralLocal(
                    merchantId = uid,
                    referralCode = info.code,
                    referredTotal = info.historyStatuses.size,
                    referredConverted = info.converted,
                    updatedAt = System.currentTimeMillis(),
                )
            )
        }
    }

    /** Lecture du miroir Room parrainage (repli hors-ligne, D41 F2). */
    suspend fun localReferral(context: Context, uid: String): ReferralLocal? =
        runCatching { VitrineLocalDatabase.get(context).referrals().byMerchant(uid) }.getOrNull()

    /**
     * Audit D41 (F56) : les consentements R4 (camera/visage/mineur) n'etaient
     * enregistres QU'EN LOCAL (dialog camera + variables d'activite) alors que
     * la route POST /api/v1/consents existe cote serveur (batch idempotent,
     * INSERT OR IGNORE sur id). Contrat serveur reel :
     * { records: [{ id, pid, scope, faces, tv, av, did, ts }] } — id = UUID
     * client (cle d'idempotence), did = empreinte appareil, ts = ISO UTC.
     * Envoi best-effort : l'echec reseau ne bloque JAMAIS la prise (le
     * consentement local reste la porte d'entree du recorder).
     */
    data class ConsentRecord(val scope: String, val faces: Int?)

    suspend fun sendConsents(
        context: Context,
        baseUrl: String,
        token: String,
        records: List<ConsentRecord>,
    ): Boolean {
        if (token.count { it == '.' } != 2 || records.isEmpty()) return false
        val version = runCatching {
            context.packageManager.getPackageInfo(context.packageName, 0).versionName
        }.getOrNull() ?: "0"
        val ts = java.text.SimpleDateFormat(
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", java.util.Locale.US
        ).apply { timeZone = java.util.TimeZone.getTimeZone("UTC") }
            .format(java.util.Date())
        val did = fingerprint(context)
        val array = org.json.JSONArray()
        records.forEach { record ->
            array.put(
                JSONObject()
                    .put("id", java.util.UUID.randomUUID().toString())
                    .put("pid", JSONObject.NULL)
                    .put("scope", record.scope)
                    .put("faces", record.faces ?: JSONObject.NULL)
                    .put("tv", "r4-v1")
                    .put("av", version)
                    .put("did", did)
                    .put("ts", ts)
            )
        }
        val body = JSONObject().put("records", array).toString()
        val reply = runCatching { ApiClient(baseUrl).post("/api/v1/consents", token, body) }.getOrNull()
        return reply != null && reply.status in 200..299
    }

    /**
     * Checkout serveur (D41 F10, P1) : le client ne construit PLUS d'URL de
     * paiement (l'ancienne URL « sandbox-checkout.cinetpay.com » n'existe pas —
     * NXDOMAIN prouve). La commande est creee cote worker (cle CinetPay secrete),
     * qui renvoie l'URL de paiement hebergee a ouvrir. Reponse honnete si le
     * fournisseur n'est pas configure (501 billing_not_configured).
     */
    data class Checkout(val ref: String, val paymentUrl: String)

    suspend fun createCheckout(baseUrl: String, token: String, planCode: String): Pair<Checkout?, Int> {
        val body = JSONObject().put("plan", planCode).toString()
        val reply = runCatching { ApiClient(baseUrl).post("/api/v1/billing/checkout", token, body) }.getOrNull()
            ?: return null to 0
        if (reply.status !in 200..299) return null to reply.status
        val result = runCatching {
            val json = JSONObject(reply.body)
            Checkout(json.getString("ref"), json.getString("payment_url"))
        }.getOrNull()
        return result to reply.status
    }

    /** POST me/welcome-grant -> credits totaux (ou restants si deja granté). */
    suspend fun requestWelcomeGrant(context: Context, baseUrl: String, token: String): Pair<Boolean, Int>? {
        val body = JSONObject().put("fingerprint", fingerprint(context)).toString()
        val reply = runCatching { ApiClient(baseUrl).post("/api/v1/me/welcome-grant", token, body) }.getOrNull()
        if (reply == null || reply.status != 200) return null
        return runCatching {
            val json = JSONObject(reply.body)
            val granted = json.optBoolean("granted", false)
            val credits = if (granted) json.optInt("credits_total", 0) else json.optInt("credits_left", 0)
            granted to credits
        }.getOrNull()
    }
}
