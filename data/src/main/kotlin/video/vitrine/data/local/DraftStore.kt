package video.vitrine.data.local

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

/**
 * D42.27 (§7) — facade du BROUILLON de projet inter-sessions.
 *
 * Cycle (offline-first, aucune dépendance réseau, aucune écriture serveur —
 * la cohérence locale/serveur reste régie par les mécanismes existants :
 * quota/entitlements côté Worker, export_journal, jamais de double débit) :
 *
 *  1. saisie du brief   → sauverBrief() à CHAQUE champ (étape BRIEF) ;
 *  2. brief validé       → promouvoirCamera() (étape CAMERA, script/scènes) ;
 *  3. chaque prise       → majPrises() (fichiers rush + index) ;
 *  4. export RÉUSSI      → effacer() (projet terminé, consommé) ;
 *  5. démarrage          → actif() ; si présent, l'app propose « Reprendre ».
 *
 * Règles absolues :
 *  - AUCUNE perte silencieuse : tant que l'export n'a pas réussi, le brouillon
 *    et les rushs (filesDir/rushes, déjà persistants) survivent à la fermeture
 *    de l'app, au redémarrage du téléphone et à la perte réseau ;
 *  - UN seul brouillon actif (id=1) : le dialogue de reprise tranche AVANT
 *    tout nouveau parcours (le dernier parcours engagé gagne — documenté) ;
 *  - la restauration FILTRE les fichiers rushs disparus (robustesse) : un
 *    chemin inexistant ne bloque jamais la reprise.
 */
object DraftStore {

    const val ETAPE_BRIEF = "BRIEF"
    const val ETAPE_CAMERA = "CAMERA"

    // ------------------------------------------------------------------ API

    suspend fun actif(context: Context): DraftEntity? =
        VitrineLocalDatabase.get(context).drafts().active()

    /** Étape BRIEF : persiste la saisie en cours (appelé à chaque champ). */
    suspend fun sauverBrief(
        context: Context,
        gabaritId: String,
        skinId: String?,
        skinName: String?,
        values: Map<String, String>
    ) {
        val db = VitrineLocalDatabase.get(context)
        val existant = db.drafts().active()
        val maintenant = System.currentTimeMillis()
        db.drafts().upsert(
            DraftEntity(
                id = 1,
                etape = ETAPE_BRIEF,
                gabaritId = gabaritId,
                skinId = skinId,
                skinName = skinName,
                briefValuesJson = mapToJson(values),
                createdAt = existant?.createdAt?.takeIf { it > 0 } ?: maintenant,
                updatedAt = maintenant
            )
        )
    }

    /** Étape CAMERA : le brief est VALIDÉ — script/scènes/rushs client figés. */
    suspend fun promouvoirCamera(
        context: Context,
        gabaritId: String,
        skinId: String?,
        skinName: String?,
        script: String,
        durationS: Int,
        objective: String?,
        scenes: String?,
        briefValues: Map<String, String>,
        clientRushes: List<String>
    ) {
        val db = VitrineLocalDatabase.get(context)
        val existant = db.drafts().active()
        val maintenant = System.currentTimeMillis()
        db.drafts().upsert(
            DraftEntity(
                id = 1,
                etape = ETAPE_CAMERA,
                gabaritId = gabaritId,
                skinId = skinId,
                skinName = skinName,
                briefValuesJson = mapToJson(briefValues),
                script = script,
                durationS = durationS,
                objective = objective,
                scenes = scenes,
                clientRushesJson = listToJson(clientRushes),
                priseFilesJson = existant?.priseFilesJson,
                priseIdx = existant?.priseIdx ?: 0,
                createdAt = existant?.createdAt?.takeIf { it > 0 } ?: maintenant,
                updatedAt = maintenant
            )
        )
    }

    /** Mise à jour des prises (à chaque Finalize réussi) — ne touche QUE le
     *  brouillon CAMERA du MÊME gabarit (garde-fou anti-désynchronisation). */
    suspend fun majPrises(
        context: Context,
        gabaritId: String,
        priseFiles: List<String>,
        priseIdx: Int
    ) {
        val db = VitrineLocalDatabase.get(context)
        val existant = db.drafts().active() ?: return
        if (existant.etape != ETAPE_CAMERA || existant.gabaritId != gabaritId) return
        db.drafts().upsert(
            existant.copy(
                priseFilesJson = listToJson(priseFiles),
                priseIdx = priseIdx,
                updatedAt = System.currentTimeMillis()
            )
        )
    }

    /** Projet terminé (export réussi) ou abandon explicite. */
    suspend fun effacer(context: Context) {
        VitrineLocalDatabase.get(context).drafts().clear()
    }

    /** Valeurs de saisie enregistrées pour CE gabarit (pré-remplissage). */
    suspend fun valuesPourGabarit(context: Context, gabaritId: String): Map<String, String> {
        val actif = VitrineLocalDatabase.get(context).drafts().active() ?: return emptyMap()
        if (actif.gabaritId != gabaritId || actif.etape != ETAPE_BRIEF) return emptyMap()
        return jsonToMap(actif.briefValuesJson)
    }

    // ------------------------------------------------- sérialisation pure
    // (publiques pour test JVM — aucune dépendance Android)

    fun mapToJson(valeurs: Map<String, String>): String {
        val o = JSONObject()
        valeurs.forEach { (k, v) -> o.put(k, v) }
        return o.toString()
    }

    fun jsonToMap(json: String?): Map<String, String> {
        if (json.isNullOrBlank()) return emptyMap()
        return runCatching {
            val o = JSONObject(json)
            buildMap { o.keys().forEach { k -> put(k, o.optString(k, "")) } }
        }.getOrDefault(emptyMap())
    }

    fun listToJson(liste: List<String>): String {
        val a = JSONArray()
        liste.forEach { a.put(it) }
        return a.toString()
    }

    fun jsonToList(json: String?): List<String> {
        if (json.isNullOrBlank()) return emptyList()
        return runCatching {
            val a = JSONArray(json)
            buildList { for (i in 0 until a.length()) add(a.optString(i, "")) }
        }.getOrDefault(emptyList())
    }
}
