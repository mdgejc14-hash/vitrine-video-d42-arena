package video.vitrine.d42

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.test.core.app.ActivityScenario
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import java.io.File
import java.util.concurrent.TimeUnit
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import video.vitrine.data.gabarits.GabaritJson
import video.vitrine.data.local.EntitlementsCache
import video.vitrine.data.local.VitrineLocalDatabase
import video.vitrine.feature.export.ExportActivity
import video.vitrine.feature.export.ExportWorker

/**
 * D42 — RENDUS DE PRODUCTION SUR ÉMULATEUR.
 *
 * Ce test n'implémente AUCUN moteur : il pilote l'application réelle.
 *
 *   ExportActivity (vraie) → gateThen + reservation credit (ExportGate/CreditPolicy)
 *     → prepareGabaritPipeline (GabaritRepository → GabaritBeatSheet + BgmStore)
 *     → WorkManager → ExportWorker (vrai)
 *       → RushSlots.resolve → MotionComposition → KineticTypography
 *       → BgmSfxAudioMixer (BGM + 9 SFX) → Transformer Media3 → ExportVerifier
 *     → fichier MP4 réel
 *
 * Les fixtures (rushs, BGM) sont des ENTRÉES déterministes copiées dans les
 * répertoires que l'application utilise en production (filesDir/d42/rushes,
 * filesDir/bgm). Aucune sortie n'est préfabriquée : si le moteur échoue, le
 * test échoue et aucun MP4 n'existe.
 *
 * Arguments d'instrumentation :
 *   d42_mode       = smoke | matrix
 *   d42_lang       = fr | en | es | ja
 *   d42_templates  = all | T1,T2 (CSV)
 *   d42_badge      = none | stock_limite | places_limitees | qualite_garantie
 *   d42_timeout_s  = délai max par rendu (défaut 900)
 */
@RunWith(AndroidJUnit4::class)
class ProductionRenderInstrumentedTest {

    private val instrumentation = InstrumentationRegistry.getInstrumentation()
    private val target: Context = instrumentation.targetContext
    private val args = InstrumentationRegistry.getArguments()

    private val mode = args.getString("d42_mode") ?: "smoke"
    private val lang = args.getString("d42_lang") ?: "fr"
    private val templatesArg = args.getString("d42_templates") ?: "all"
    private val badge = args.getString("d42_badge") ?: "none"
    private val timeoutS = (args.getString("d42_timeout_s") ?: "900").toLong()
    // D42-P1 : profil de rendu. "validation" = 540x960 sur la MEME chaine
    // (moteur, composition, audio, effets) ; "production" = 1080x1920 inchange.
    private val profil = args.getString("d42_profile") ?: "production"
    private val dimensionValidation = 540 to 960
    // D42-P1 : plafond de rendus par job (0 = pas de plafond). Sert a MESURER
    // le cout reel d'un rendu avant d'engager la matrice complete.
    private val limite = (args.getString("d42_limite") ?: "0").toInt()

    private val outDir: File by lazy {
        File(target.getExternalFilesDir(null), "d42/$lang").apply { mkdirs() }
    }

    // ------------------------------------------------------------------ entrées

    /** Textes d'échantillon par langue (le brief marchand est localisé, §4.3). */
    private data class Echantillon(
        val commerce: String,
        val offre: String,
        val quartier: String,
        val devise: String,
        val prix: String,
    )

    private val echantillons = mapOf(
        // D42.2 — donnees commerciales de la porte A (synthetiques, aucun
        // commercant reel, numero fictif). Le rendu doit les montrer TELLES
        // QUELLES dans les frames extraites du MP4.
        "fr" to Echantillon("Chez D42 Test", "OFFRE D42 DIAGNOSTIC", "COTONOU", "FCFA", "25000"),
        "en" to Echantillon("Chantal's Kitchen", "Daily special", "Akpakpa", "FCFA", "5000"),
        "es" to Echantillon("Cocina de Chantal", "Menú del día", "Akpakpa", "FCFA", "5000"),
        "ja" to Echantillon("シャンタル食堂", "本日の特別メニュー", "アキャクパ", "FCFA", "5000"),
    )

    private fun echantillon(): Echantillon = echantillons[lang] ?: echantillons.getValue("fr")

    /** Valeurs de brief pour un gabarit : champs RÉELS issus de parseBrief. */
    private fun valeursPour(raw: String): Map<String, String> {
        val e = echantillon()
        val fields = GabaritJson.parseBrief(raw).fields
        val values = mutableMapOf<String, String>()
        fields.forEach { champ ->
            values[champ.id] = when {
                champ.id == "badge_engagement_actif" -> badge
                // D42.6 : sans ancien prix SUPERIEUR au prix, le gabarit n'a aucune
                // reduction a afficher et « -{pourcentage}% » tombait sur « -% ».
                // L'ancien prix synthetique est donc prix + 25 % (reduction 20 %),
                // le prix courant reste celui du brief.
                champ.id == "ancien_prix" ->
                    ((e.prix.toIntOrNull() ?: 0) * 5 / 4).toString()
                champ.type == "nombre" -> e.prix
                champ.type == "telephone" || champ.validation == "format_international" ->
                    "+22997000000"
                champ.id == "devise" -> e.devise
                champ.id == "nom_commerce" -> e.commerce
                champ.id == "nom_offre" -> e.offre
                champ.id == "quartier_ville" -> e.quartier
                champ.choices.isNotEmpty() -> champ.choices.first()
                else -> e.commerce
            }
        }
        // Le badge peut ne pas etre declare dans parseBrief (case_a_cocher filtre
        // par parseCheckRows) : on l'injecte explicitement, c'est le champ E5 reel.
        if (badge != "none") values["badge_engagement_actif"] = badge
        return values
    }

    // ------------------------------------------------------------------ fixtures

    private fun copierFixtures() {
        val assets = instrumentation.context.assets
        // D42-P5 : le profil de validation utilise des rushs a 15 images/s
        // (meme duree, meme orientation, meme codec). Le cout du moteur est
        // domine par un cout FIXE par image (≈ 217 ms mesure) : la cadence des
        // sources divise donc le temps sans toucher a la composition. Les
        // rushs de PRODUCTION (30 im/s) restent servis au profil production.
        val source = if (profil == "validation") "d42/rushes15" else "d42/rushes"
        val rushesDir = File(target.filesDir, "d42/rushes").apply { mkdirs() }
        assets.list(source).orEmpty().forEach { nom ->
            val dest = File(rushesDir, nom)
            assets.open("$source/$nom").use { entree ->
                dest.outputStream().use { entree.copyTo(it) }
            }
        }
        // BGM : BgmStore lit filesDir/bgm/<categorie>.m4a (chemin de production).
        val bgmDir = File(target.filesDir, "bgm").apply { mkdirs() }
        assets.list("d42/bgm").orEmpty().forEach { nom ->
            val secteur = nom.removePrefix("bgm_").removeSuffix(".m4a")
            val octets = assets.open("d42/bgm/$nom").use { it.readBytes() }
            File(bgmDir, "bgm_$secteur.m4a").writeBytes(octets)
        }
        assertTrue("fixtures rushs absentes", rushesDir.listFiles()?.size ?: 0 >= 3)
        assertTrue("fixtures BGM absentes", bgmDir.listFiles()?.size ?: 0 >= 6)
    }

    /** Cache BGM sous le nom EXACT attendu par le gabarit (categorie_audio). */
    private fun preparerBgm(categorie: String?, secteur: String) {
        if (categorie.isNullOrBlank()) return
        val bgmDir = File(target.filesDir, "bgm").apply { mkdirs() }
        val source = File(bgmDir, "bgm_$secteur.m4a")
        if (!source.isFile) return
        val cible = File(bgmDir, "$categorie.m4a")
        if (!cible.isFile) source.copyTo(cible, overwrite = true)
    }

    /**
     * Compte de test : crédits d'un compte marchand de recette. Ce n'est PAS un
     * contournement de la porte — ExportGate décide toujours (et débite), on
     * s'assure seulement que le compte possède de quoi enchaîner 30 rendus.
     */
    private fun alimenterCompteTest() {
        val db = VitrineLocalDatabase.get(target)
        kotlinx.coroutines.runBlocking {
            val uid = "demo"
            val existant = db.entitlements().byMerchant(uid)
            db.entitlements().upsert(
                EntitlementsCache(
                    merchantId = uid,
                    watermark = existant?.watermark ?: true,
                    endcardMention = existant?.endcardMention ?: true,
                    maxRes = existant?.maxRes ?: "1080p",
                    exportsLimit = existant?.exportsLimit ?: 99,
                    fairUse = existant?.fairUse,
                    cloudRenders = existant?.cloudRenders ?: 0,
                    brandKit = existant?.brandKit ?: false,
                    cacheDays = existant?.cacheDays ?: 30,
                    welcomeCreditsLeft = 5,
                    welcomeCloudLeft = existant?.welcomeCloudLeft ?: 0,
                    fetchedAt = System.currentTimeMillis(),
                )
            )
        }
    }

    // ------------------------------------------------------------------ rendu

    private data class Resultat(
        val gabarit: String,
        val langue: String,
        val badge: String,
        val ok: Boolean,
        val mp4: File?,
        val octets: Long,
        val sha256: String?,
        val dureeMs: Long,
        val workerState: String,
        val erreur: String?,
        /** D42-P12 : taille du beat sheet reellement transmis au moteur. */
        val motsBeatSheet: Int,
        val plansBeatSheet: Int,
    )

    /**
     * D42-P12 : le beat sheet effectivement construit par ExportActivity est
     * mesure en rejouant la meme chaine (GabaritBeatSheet.build) avec les memes
     * valeurs. Il ne remplace aucune preuve de rendu : il dit seulement si le
     * moteur a recu des textes (mots > 0) ou non, ce qui discrimine « aucun
     * overlay a dessiner » de « overlays dessines mais invisibles ».
     */
    private fun mesurerBeatSheet(raw: String, valeurs: Map<String, String>): Pair<Int, Int> {
        val doc = runCatching {
            video.vitrine.data.gabarits.GabaritBeatSheet.build(
                raw, valeurs, null, localiser = { cle -> cle }
            )
        }.getOrNull() ?: return 0 to 0
        val racine = runCatching { JSONObject(doc.beatSheetJson) }.getOrNull() ?: return 0 to 0
        val mots = racine.optJSONArray("words")?.length() ?: 0
        val plans = racine.optJSONArray("plans")?.length() ?: 0
        return mots to plans
    }

    private fun rendre(gabaritId: String, secteur: String, tpl: String): Resultat {
        val debut = System.currentTimeMillis()
        val raw = target.assets.open("gabarits/$secteur/$tpl.json")
            .bufferedReader().use { it.readText() }
        val (mots, plans) = mesurerBeatSheet(raw, valeursPour(raw))
        val categorie = runCatching {
            JSONObject(raw).optJSONObject("audio")?.optJSONObject("musique")
                ?.optString("categorie_audio")
        }.getOrNull()
        preparerBgm(categorie, secteur)
        alimenterCompteTest()

        val rushes = File(target.filesDir, "d42/rushes").listFiles()
            ?.sortedBy { it.name }?.map { it.absolutePath } ?: emptyList()
        val values = valeursPour(raw)

        // D42-P3 : ExportActivity enfile un travail UNIQUE ("vv-export",
        // ExistingWorkPolicy.KEEP). Sans purge, le 2e rendu d'un meme job etait
        // silencieusement JETE et le harnais relisait le SUCCEEDED du precedent,
        // dont le fichier avait deja ete deplace : « ok=false etat=SUCCEEDED
        // 1494 ms » au run 41616715692. Chaque rendu repart d'un work neuf.
        val anterieurs = purgerWork()

        val intent = Intent(target, ExportActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            putExtra("gabarit_id", gabaritId)
            putExtra("input", rushes.first())
            // D42-F13 : ExportActivity lit getStringArrayExtra : une ArrayList
            // leve ClassCastException (Parcel$LazyValue) et rend la liste NULLE.
            // Les points d'entree cumulaient alors au-dela des 12 s du rush et
            // le rendu s'arretait a 7,04 s (mesure sur cache-export-1.mp4).
            putExtra("client_rushes", rushes.toTypedArray())
            putExtra("class_rank", 3)          // classe D : geometrie 720/1080 selon saison
            // D42-P1 : le profil de validation ne reduit QUE la geometrie de
            // sortie. Scenes, transitions, overlays, prix, badge, musique, SFX,
            // ducking et effets passent par le meme chemin de composition.
            if (profil == "validation") {
                putExtra("output_w", dimensionValidation.first)
                putExtra("output_h", dimensionValidation.second)
            }
            values.forEach { (k, v) -> putExtra("brief_$k", v) }
            // D42-F14 : ExportActivity lit getStringArrayExtra("brief_keys").
            // Une ArrayList rendait la liste nulle -> AUCUN champ du brief ->
            // {prix}, {devise}, {nom_commerce} restaient litteraux a l'ecran.
            putExtra("brief_keys", values.keys.toTypedArray())
            putExtra("duration_s", 30)
            // Écran d'aperçu E7 sauté : il est testé par le robot UI (Phase 6).
            // Aucune étape du moteur n'est contournée (porte + worker réels).
            putExtra("d42_skip_preview", true)
        }

        var scenario: ActivityScenario<ExportActivity>? = null
        return try {
            scenario = ActivityScenario.launch(intent)
            scenario.onActivity { activity ->
                val bouton = activity.findViewById<android.widget.Button>(
                    video.vitrine.feature.export.R.id.export_start
                )
                Log.i(TAG, "  bouton_export=${bouton != null} actif=${bouton?.isEnabled}")
                bouton?.performClick()
                // Message de la porte (credit/integrite) : visible dans export_status.
                Log.i(
                    TAG,
                    "  statut_ecran=" + activity.findViewById<android.widget.TextView>(
                        video.vitrine.feature.export.R.id.export_status
                    )?.text,
                )
            }
            val wm = androidx.work.WorkManager.getInstance(target)
            val limite = System.currentTimeMillis() + TimeUnit.SECONDS.toMillis(timeoutS)
            var etat = "EN_ATTENTE"
            var chemin: String? = null
            var cloudFallback = false
            while (System.currentTimeMillis() < limite) {
                val infos = kotlinx.coroutines.runBlocking {
                    wm.getWorkInfosForUniqueWork(ExportWorker.UNIQUE_NAME).get()
                }
                // Un work ANTERIEUR (meme fini) ne prouve rien : on n'accepte
                // qu'un identifiant absent de la purge initiale.
                val info = infos.lastOrNull { it.id !in anterieurs }
                if (info != null && info.state.isFinished) {
                    etat = info.state.name
                    chemin = info.outputData.getString(ExportWorker.KEY_OUTPUT)
                    cloudFallback = info.outputData.getBoolean(ExportWorker.KEY_CLOUD_FALLBACK, false)
                    Log.i(TAG, "  worker=${info.state} outputData=${info.outputData.keyValueMap}")
                    break
                }
                // Suivi de progression : le worker écrit cacheDir/export-<n>.mp4.
                val partiel = File(target.cacheDir, "export-1.mp4")
                Log.i(
                    TAG,
                    "  +${(System.currentTimeMillis() - debut) / 1000}s etat=" +
                        "${info?.state ?: "aucun work"} sortie_partielle=" +
                        "${if (partiel.isFile) partiel.length() else 0} octets",
                )
                Thread.sleep(5_000)
            }
            if (etat == "EN_ATTENTE") etat = "TIMEOUT"
            var mp4: File? = null
            val source = chemin?.let { File(it) }
            var octets = 0L
            var empreinte: String? = null
            if (etat == "SUCCEEDED" && source != null && source.isFile && source.length() > 0) {
                // D42-P9 : le nom portait seulement le format (T1_fr.mp4). Les six
                // secteurs ecrivaient donc le MEME fichier : 15 rendus par lot ne
                // laissaient que 5 fichiers, et le manifeste — qui calculait
                // taille et SHA en fin de test — attribuait a trois secteurs le
                // MP4 du dernier ecrit. Une preuve qui ment est pire qu'une
                // preuve absente : nom complet + empreinte mesuree ICI.
                val nom = "${gabaritId}_${lang}${if (badge == "none") "" else "_$badge"}.mp4"
                val cible = File(outDir, nom)
                check(!cible.exists()) { "collision de nom de rendu : $nom" }
                source.copyTo(cible, overwrite = false)
                mp4 = cible
                octets = cible.length()
                empreinte = sha256(cible)
                // Le worker ecrit dans cacheDir : la preuve est deplacee, pas copiee.
                source.delete()
            }
            Resultat(
                gabarit = gabaritId,
                langue = lang,
                badge = badge,
                ok = mp4 != null,
                mp4 = mp4,
                octets = octets,
                sha256 = empreinte,
                dureeMs = System.currentTimeMillis() - debut,
                workerState = if (cloudFallback) "$etat/CLOUD" else etat,
                erreur = if (mp4 == null) "worker=$etat sortie=${chemin ?: "nulle"}" else null,
                motsBeatSheet = mots,
                plansBeatSheet = plans,
            )
        } catch (erreur: Throwable) {
            Log.e(TAG, "rendu $gabaritId/$tpl en echec", erreur)
            Resultat(
                gabarit = gabaritId, langue = lang, badge = badge, ok = false, mp4 = null,
                octets = 0L, sha256 = null,
                dureeMs = System.currentTimeMillis() - debut, workerState = "EXCEPTION",
                erreur = "${erreur.javaClass.simpleName}: ${erreur.message}",
                motsBeatSheet = 0, plansBeatSheet = 0,
            )
        } finally {
            runCatching { scenario?.close() }
        }
    }

    /**
     * D42-P3 : vide la file WorkManager et attend la disparition des travaux
     * termines. Retourne les identifiants deja connus, pour n'accepter ensuite
     * qu'un travail REELLEMENT nouveau.
     */
    private fun purgerWork(): Set<java.util.UUID> {
        val wm = androidx.work.WorkManager.getInstance(target)
        val connus = kotlinx.coroutines.runBlocking {
            wm.getWorkInfosForUniqueWork(ExportWorker.UNIQUE_NAME).get()
        }.map { it.id }.toSet()
        wm.cancelUniqueWork(ExportWorker.UNIQUE_NAME)
        wm.pruneWork()
        val fin = System.currentTimeMillis() + 30_000
        while (System.currentTimeMillis() < fin) {
            val restants = kotlinx.coroutines.runBlocking {
                wm.getWorkInfosForUniqueWork(ExportWorker.UNIQUE_NAME).get()
            }.filter { !it.state.isFinished }
            if (restants.isEmpty()) break
            Thread.sleep(250)
        }
        return connus
    }

    // ------------------------------------------------------------------ test

    /** Indice du lot, 1-based (vide = pas de découpage). */
    private val shardArg = args.getString("d42_shard") ?: ""

    /** Nombre total de lots (vide = pas de découpage). */
    private val shardsTotalArg = args.getString("d42_shards") ?: ""

    /**
     * D42.3 — sélection des gabarits.
     *
     * Le défaut corrigé : le workflow passait « shard:1/8 » DANS l'argument des
     * gabarits. Le motif shard l'emportait, la liste restait les 30 gabarits, et
     * `limite` ne gardait que le premier venu — un rendu était donc produit,
     * vert, mais pour `batiment_travaux_T1` au lieu du gabarit demandé.
     *
     * Désormais trois notions distinctes :
     *   - FILTRE  (`d42_templates`) : all | ref | T1 | id1,id2 | restaurants_maquis_T1 ;
     *   - LOT     (`d42_shard` / `d42_shards`) : découpage appliqué APRÈS le filtre ;
     *   - PLAFOND (`d42_limite`) : appliqué en dernier, par l'appelant.
     */
    private fun cibles(): List<Triple<String, String, String>> {
        val tous = mutableListOf<Triple<String, String, String>>()
        target.assets.list("gabarits").orEmpty().sorted().forEach { secteur ->
            target.assets.list("gabarits/$secteur").orEmpty()
                .filter { it.endsWith(".json") }
                .sortedBy { it }
                .forEach { fichier ->
                    val tpl = fichier.removeSuffix(".json")
                    tous += Triple("${secteur}_$tpl", secteur, tpl)
                }
        }

        val filtre = templatesArg.trim()
        val demandes = when {
            filtre.isEmpty() || filtre == "all" || filtre == "ref" -> emptyList()
            else -> filtre.split(',').map { it.trim() }.filter { it.isNotEmpty() }
        }
        val selection = when {
            filtre.isEmpty() || filtre == "all" -> tous
            filtre == "ref" -> tous.filter { (id, _, _) -> id in reference() }
            else -> tous.filter { (id, _, tpl) -> demandes.any { d -> d == tpl || d == id } }
        }

        // Contrôle explicite : un gabarit demandé doit être servi, ou le test
        // échoue immédiatement — plus de sélection silencieuse du premier venu.
        if (demandes.isNotEmpty()) {
            val manquants = demandes.filter { d -> selection.none { it.first == d || it.third == d } }
            assertTrue(
                "GABARIT DEMANDE INTROUVABLE : $manquants (demande=${demandes.joinToString()})",
                manquants.isEmpty(),
            )
            assertEquals(
                "GABARIT DEMANDE=${demandes.joinToString()} mais selection=" +
                    selection.joinToString { it.first },
                demandes.size,
                selection.size,
            )
        }

        // Découpage en lots : appliqué à la sélection FILTRÉE, jamais à la liste
        // complète — sinon un filtre d'un seul gabarit retomberait sur 30 cibles.
        val (index, total) = decoupage()
        val lot = if (total > 0) {
            selection.filterIndexed { i, _ -> i % total == index }
        } else {
            selection
        }
        Log.i(
            TAG,
            "D42-SELECTION filtre=$filtre demandes=${demandes.size} " +
                "selectionnes=${lot.size} ids=${lot.joinToString { it.first }} " +
                "lots=$total indice=${index + 1}",
        )
        return lot
    }

    /** (indice 0-based, total) du découpage ; (0, 0) si aucun lot demandé. */
    private fun decoupage(): Pair<Int, Int> {
        if (shardArg.isNotBlank() && shardsTotalArg.isNotBlank()) {
            val index = shardArg.toIntOrNull()?.coerceAtLeast(1) ?: 1
            val total = shardsTotalArg.toIntOrNull()?.coerceAtLeast(1) ?: 1
            return (index - 1) to total
        }
        // Compatibilité : ancien format « shard:3/8 » encore accepté.
        val ancien = Regex("^shard:(\\d+)/(\\d+)$").find(templatesArg.trim())
        if (ancien != null) {
            val index = ancien.groupValues[1].toInt().coerceAtLeast(1)
            val total = ancien.groupValues[2].toInt().coerceAtLeast(1)
            return (index - 1) to total
        }
        return 0 to 0
    }

    private fun reference(): Set<String> = when (lang) {
        "fr" -> setOf("restaurants_maquis_T1", "vetements_mode_T3", "batiment_travaux_T2")
        "ja" -> setOf("restaurants_maquis_T4", "vetements_mode_T5", "batiment_travaux_T3")
        "en" -> setOf("coiffure_beaute_T4", "immo_auto_T4", "shops_small_business_T4")
        "es" -> setOf("coiffure_beaute_T2", "immo_auto_T1", "shops_small_business_T1")
        else -> emptySet()
    }

    /**
     * Langue de l'interface ET des contenus commerciaux : VitrineLocale lit
     * `vv_locale/lang` dans attachBaseContext. On ecrit les memes preferences
     * que l'app (aucune dependance de compilation vers :core-designsystem).
     */
    private fun appliquerLangue() {
        target.getSharedPreferences("vv_locale", Context.MODE_PRIVATE)
            .edit().putString("lang", lang).commit()
        Log.i(TAG, "langue appliquee: $lang")
    }

    @Test
    fun rendusDeProduction() {
        appliquerLangue()
        copierFixtures()
        val toutes = cibles()
        val cibles = if (limite > 0) toutes.take(limite) else toutes
        assertTrue("aucune cible de rendu", cibles.isNotEmpty())
        Log.i(TAG, "D42 mode=$mode lang=$lang badge=$badge cibles=${cibles.size}")

        val resultats = mutableListOf<Resultat>()
        cibles.forEachIndexed { index, (id, secteur, tpl) ->
            Log.i(TAG, "[${index + 1}/${cibles.size}] rendu $id ($lang, badge=$badge)")
            resultats += rendre(id, secteur, tpl)
            val r = resultats.last()
            Log.i(
                TAG,
                "  → ok=${r.ok} etat=${r.workerState} ${r.dureeMs}ms " +
                    "taille=${r.mp4?.length() ?: 0} ${r.erreur ?: ""}"
            )
        }

        ecrireManifeste(resultats)
        val echecs = resultats.filter { !it.ok }
        assertTrue(
            "RENDUS EN ECHEC ${echecs.size}/${resultats.size} : " +
                echecs.joinToString(" | ") { "${it.gabarit}=${it.workerState} ${it.erreur}" },
            echecs.isEmpty(),
        )
    }

    private fun ecrireManifeste(resultats: List<Resultat>) {
        val manifeste = File(outDir, "manifest.jsonl")
        manifeste.printWriter().use { sortie ->
            resultats.forEach { r ->
                sortie.println(
                    JSONObject()
                        .put("gabarit", r.gabarit)
                        .put("langue", r.langue)
                        .put("badge", r.badge)
                        .put("profil", profil)
                        .put("mots_beat_sheet", r.motsBeatSheet)
                        .put("plans_beat_sheet", r.plansBeatSheet)
                        .put("ok", r.ok)
                        .put("mp4", r.mp4?.name ?: JSONObject.NULL)
                        .put("octets", r.octets)
                        .put("sha256", r.sha256 ?: JSONObject.NULL)
                        .put("duree_rendu_ms", r.dureeMs)
                        .put("worker_state", r.workerState)
                        .put("erreur", r.erreur ?: JSONObject.NULL)
                        .toString()
                )
            }
        }
        File(outDir, "environment.txt").writeText(
            buildString {
                appendLine("mode=$mode")
                appendLine("langue=$lang")
                appendLine("badge=$badge")
                appendLine("profil=$profil")
                appendLine(
                    "geometrie=" + if (profil == "validation") {
                        "${dimensionValidation.first}x${dimensionValidation.second}"
                    } else "1080x1920"
                )
                appendLine("sdk=${android.os.Build.VERSION.SDK_INT}")
                appendLine("device=${android.os.Build.MODEL}")
                appendLine("abi=${android.os.Build.SUPPORTED_ABIS.joinToString(",")}")
                val apk = target.packageManager
                    .getPackageInfo(target.packageName, 0).applicationInfo!!.sourceDir
                appendLine("apk_sha256=${sha256(File(apk))}")
            }
        )
    }

    private fun sha256(fichier: File): String =
        runCatching {
            val digest = java.security.MessageDigest.getInstance("SHA-256")
            fichier.inputStream().use { flux ->
                val tampon = ByteArray(1 shl 16)
                while (true) {
                    val lus = flux.read(tampon)
                    if (lus <= 0) break
                    digest.update(tampon, 0, lus)
                }
            }
            digest.digest().joinToString("") { "%02x".format(it) }
        }.getOrDefault("")

    private companion object {
        const val TAG = "D42-RENDER"
    }
}
