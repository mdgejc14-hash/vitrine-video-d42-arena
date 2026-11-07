package video.vitrine.data.audio

import android.content.Context
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.io.File
import java.net.HttpURLConnection
import java.net.URL
import java.security.MessageDigest

/**
 * Cache DEFINITIF des musiques de fond (BGM) sur le téléphone.
 *
 * Contrat (docs/AUDIO_BGM_TELEVERSEMENT.md §5) : le Worker distribue chaque
 * morceau sur une URL stable `/api/v1/audio/track/{categorie_audio}` avec
 * `Cache-Control: public, max-age=2592000, immutable`. Un morceau n'est donc
 * téléchargé QU'UNE FOIS dans `files/bgm/` (pas `cacheDir` : le cache définitif
 * survit au vidage du cache système), puis servi hors-ligne pour toujours —
 * la donnée coûte cher en Afrique de l'Ouest.
 *
 * D42.21 — sélection parmi les 20 VARIATIONS du gabarit (spec fondateur) :
 *  1. catalogue → catégorie/secteur/format du gabarit choisi ;
 *  2. bibliothèque filtrée (secteur+format) → les 20 références EN_LIGNE ;
 *  3. BgmSelection (anti-répétition, uniforme, Random injectable) ;
 *  4. téléchargement `/api/v1/audio/track/{categorie}?v={n}` + VÉRIFICATION
 *     sha256 (bgm_library) — un fichier legacy dont le sha correspond est
 *     adopté plutôt que re-téléchargé ;
 *  5. cache `files/bgm/{piste_id}.mp3` + historique par gabarit.
 *
 * Chaîne de replis (jamais d'échec d'export dû à la musique) : variation
 * choisie indisponible → autre variation ; bibliothèque injoignable → chemin
 * titulaire historique (track sans ?v). Zéro dépendance externe : HttpURLConnection.
 */
class BgmStore(
    private val context: Context,
    private val baseUrl: String,
    /** Aléa de sélection : SecureRandom en production, seedé dans les tests. */
    private val random: kotlin.random.Random = kotlin.random.Random.Default
) {

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    /** Fichier morceau déjà en cache définitif (m4a ou mp3), null sinon. */
    fun localFile(categorieAudio: String): File? =
        EXTENSIONS
            .map { File(dir(), "$categorieAudio.$it") }
            .firstOrNull { it.isFile && it.length() > 0L }

    /** Prefetch d'arrière-plan du morceau du gabarit choisi (sélection catalogue). */
    fun prefetchForGabarit(gabaritId: String, token: String?) {
        if (token.isNullOrBlank()) return
        scope.launch {
            runCatching { ensureGabaritCached(gabaritId, token) }
        }
    }

    /**
     * Retourne le fichier local d'UNE DES 20 musiques du gabarit (D42.21) ;
     * télécharge la variation sélectionnée si absente. Repli complet sur le
     * chemin historique (titulaire) si la bibliothèque est indisponible.
     */
    suspend fun ensureGabaritCached(gabaritId: String, token: String): File? =
        withContext(Dispatchers.IO) {
            val frais = fetchCatalogJson(token)
            val pistes = BgmCatalogParser.parse(frais ?: cachedCatalogJson())
            val piste = pistes.firstOrNull { it.gabaritId == gabaritId }
                ?: return@withContext null
            // D42.21 : chemin variations (20 par gabarit). En cas d'indisponibilité
            // d'une piste, on essaie une AUTRE variation du MÊME gabarit (jamais
            // une piste étrangère) avant de replier sur le titulaire.
            val variations = variationsDuGabarit(piste, token)
            if (variations.isNotEmpty()) {
                val dejaEssayees = mutableSetOf<String>()
                val dejaUtilisees = historique(gabaritId)
                while (dejaEssayees.size < variations.size) {
                    val choisie = BgmSelection.choisir(
                        variations.filter { it.pisteId !in dejaEssayees },
                        gabaritId,
                        dejaUtilisees,
                        random
                    ) ?: break
                    dejaEssayees += choisie.pisteId
                    val fichier = fichierVariation(choisie, piste.categorieAudio, token)
                    if (fichier != null) {
                        enregistrerHistorique(gabaritId, choisie.pisteId)
                        Log.i(
                            TAG,
                            "bgm sélectionnée : ${choisie.pisteId} (variation ${choisie.variation}/20 du gabarit $gabaritId)"
                        )
                        return@withContext fichier
                    }
                    Log.w(TAG, "bgm indisponible, autre variation essayée : ${choisie.pisteId}")
                }
            }
            // Repli : cache legacy (fichier catégorie) puis titulaire historique.
            localFile(piste.categorieAudio)
                ?: downloadTrack(piste.categorieAudio, token)
        }

    /** Liste des variations EN_LIGNE du gabarit, depuis le cache ou le réseau. */
    private fun variationsDuGabarit(
        piste: BgmCatalogParser.Piste,
        token: String
    ): List<BgmLibraryParser.Variation> {
        if (piste.secteur.isBlank() || piste.format.isBlank()) return emptyList()
        val cacheListe = File(dir(), "library_${piste.secteur}_${piste.format}.json")
        val json = httpGet(
            "$baseUrl/api/v1/audio/library?secteur=${piste.secteur}&format=${piste.format}&limit=200",
            token
        )?.also { frais -> runCatching { cacheListe.writeText(frais) } }
            ?: runCatching { cacheListe.takeIf { it.isFile }?.readText() }.getOrNull()
            ?: return emptyList()
        val variations = BgmLibraryParser.parse(json)
        // Revérification défensive : uniquement les pistes du gabarit demandé.
        return variations.filter { it.gabaritId == piste.gabaritId }
    }

    /** Cache local `{piste_id}.mp3` sinon téléchargement vérifié sha256. */
    private fun fichierVariation(
        variation: BgmLibraryParser.Variation,
        categorieAudio: String,
        token: String
    ): File? {
        val local = File(dir(), "${variation.pisteId}.mp3")
        if (local.isFile && local.length() > 0L) return local
        // Adoption d'un fichier legacy (époque variation-1) si le sha correspond.
        val legacy = localFile(categorieAudio)
        if (legacy != null && sha256(legacy) == variation.sha256) {
            if (legacy.renameTo(local)) return local
        }
        val telecharge = downloadTrack("${categorieAudio}?v=${variation.variation}", token)
            ?: return null
        // D42.21 : intégrité — sha256 du fichier téléchargé vs bgm_library.
        if (variation.sha256.isNotBlank() && sha256(telecharge) != variation.sha256) {
            Log.w(TAG, "sha256 divergent pour ${variation.pisteId} — fichier rejeté")
            telecharge.delete()
            return null
        }
        val cible = File(dir(), "${variation.pisteId}.mp3")
        if (telecharge.absolutePath == cible.absolutePath) return telecharge
        return if (telecharge.renameTo(cible)) cible else telecharge
    }

    /** Historique anti-répétition du gabarit (fichiers/bgm/historique.json). */
    private fun historique(gabaritId: String): List<String> = runCatching {
        val fichier = File(dir(), "historique.json")
        if (!fichier.isFile) return emptyList()
        val objet = JSONObject(fichier.readText())
        val arr = objet.optJSONArray(gabaritId) ?: return emptyList()
        (0 until arr.length()).mapNotNull { i -> arr.optString(i).takeIf { it.isNotBlank() } }
    }.getOrDefault(emptyList())

    private fun enregistrerHistorique(gabaritId: String, pisteId: String) {
        runCatching {
            val fichier = File(dir(), "historique.json")
            val objet = if (fichier.isFile) JSONObject(fichier.readText()) else JSONObject()
            val liste = BgmSelection.pousserHistorique(historique(gabaritId), pisteId)
            objet.put(gabaritId, org.json.JSONArray(liste))
            fichier.writeText(objet.toString())
        }
    }

    private fun dir(): File = File(context.filesDir, "bgm").apply { mkdirs() }

    private fun catalogFile(): File = File(dir(), "catalog.json")

    private fun fetchCatalogJson(token: String): String? =
        httpGet("$baseUrl/api/v1/audio/catalog", token)
            ?.also { json -> runCatching { catalogFile().writeText(json) } }

    private fun cachedCatalogJson(): String? =
        catalogFile()
            .takeIf { it.isFile }
            ?.let { runCatching { it.readText() }.getOrNull() }

    /**
     * Télécharge un morceau. [cle] est soit une catégorie (`musique_t1_x`) soit
     * une catégorie+variation (`musique_t1_x?v=7`, D42.21). Le fichier est
     * nommé d'après [cle] (caractères interdits neutralisés) puis renommé par
     * l'appelant si nécessaire.
     */
    private fun downloadTrack(cle: String, token: String): File? {
        val nomBase = cle.replace(Regex("[^A-Za-z0-9_.-]"), "_")
        val connection = open("$baseUrl/api/v1/audio/track/$cle", token)
            ?: return null
        return try {
            if (connection.responseCode != HttpURLConnection.HTTP_OK) return null
            val extension =
                if ((connection.contentType ?: "").contains("mpeg")) "mp3" else "m4a"
            val temp = File(dir(), "$nomBase.part")
            temp.outputStream().use { sortie -> connection.inputStream.copyTo(sortie) }
            val attendue = connection.contentLengthLong
            val complete = temp.length() > 0L && (attendue <= 0L || temp.length() == attendue)
            if (!complete || !temp.renameTo(File(dir(), "$nomBase.$extension"))) {
                temp.delete()
                return null
            }
            File(dir(), "$nomBase.$extension")
        } catch (erreur: java.io.IOException) {
            File(dir(), "$nomBase.part").delete()
            null
        } finally {
            connection.disconnect()
        }
    }

    private fun httpGet(url: String, token: String): String? {
        val connection = open(url, token) ?: return null
        return try {
            if (connection.responseCode != HttpURLConnection.HTTP_OK) {
                null
            } else {
                connection.inputStream.bufferedReader().use { it.readText() }
            }
        } catch (erreur: java.io.IOException) {
            null
        } finally {
            connection.disconnect()
        }
    }

    private fun open(url: String, token: String): HttpURLConnection? = runCatching {
        (URL(url).openConnection() as HttpURLConnection).apply {
            connectTimeout = TIMEOUT_MS
            readTimeout = TIMEOUT_MS
            setRequestProperty("Authorization", "Bearer $token")
        }
    }.getOrNull()

    private companion object {
        const val TAG = "BgmStore"
        const val TIMEOUT_MS = 15_000
        val EXTENSIONS = listOf("m4a", "mp3")
    }
}

/** sha256 d'un fichier (flux, aucune bibliothèque externe). */
internal fun sha256(fichier: File): String? = runCatching {
    val resume = MessageDigest.getInstance("SHA-256")
    fichier.inputStream().use { flux ->
        val tampon = ByteArray(64 * 1024)
        while (true) {
            val lu = flux.read(tampon)
            if (lu < 0) break
            resume.update(tampon, 0, lu)
        }
    }
    resume.digest().joinToString("") { "%02x".format(it) }
}.getOrNull()
