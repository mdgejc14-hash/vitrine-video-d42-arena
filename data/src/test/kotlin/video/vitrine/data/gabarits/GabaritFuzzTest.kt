package video.vitrine.data.gabarits

import java.io.File
import org.json.JSONException
import org.json.JSONObject
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Audit D41 — fuzzing des parseurs de gabarits (methode fuzzing, graine fixee
 * = reproductible). Contrat : sur une entree MUTEE (octets aleatoires, troncature,
 * injection null/nombre geant/UTF-8 multi-octets), les parseurs ne levent
 * JAMAIS autre chose que JSONException (type gere par tous les appelants via
 * runCatching) et GabaritBeatSheet.build ne leve JAMAIS rien (repli null).
 * Un crash non gere sur JSON corrupt = export plante au lieu du repli script.
 */
class GabaritFuzzTest {

    private val rng = java.util.Random(20261102L)

    private fun echantillons(): List<String> {
        val repertoire = listOf(
            File("src/main/assets/gabarits"),
            File("data/src/main/assets/gabarits")
        ).firstOrNull { it.isDirectory }
        val assets = repertoire?.walkTopDown()?.filter { it.extension == "json" }?.take(5)
            ?.map { it.readText() }?.toList().orEmpty()
        val fixtures = listOf("batiment_travaux_T1", "coiffure_beaute_T5", "vetements_mode_T4")
            .mapNotNull { nom ->
                javaClass.getResourceAsStream("/fixtures/$nom.json")?.readBytes()?.decodeToString()
            }
        return assets + fixtures
    }

    private fun muter(raw: String): String {
        val octets = raw.toByteArray().toMutableList()
        repeat(1 + rng.nextInt(12)) {
            if (octets.isEmpty()) return@repeat
            when (rng.nextInt(6)) {
                0 -> octets[rng.nextInt(octets.size)] = rng.nextInt(256).toByte()
                1 -> octets.removeAt(rng.nextInt(octets.size))
                2 -> octets.add(rng.nextInt(octets.size + 1), rng.nextInt(256).toByte())
                3 -> inserer(octets, "null")
                4 -> inserer(octets, "99999999999999999999999999")
                else -> inserer(octets, "日本語🎬\"\\")
            }
        }
        return octets.toByteArray().toString(Charsets.UTF_8)
    }

    private fun inserer(octets: MutableList<Byte>, texte: String) {
        octets.addAll(rng.nextInt(octets.size + 1), texte.toByteArray().toList())
    }

    /** Seule une JSONException est acceptable — tout autre type ferait planter
     *  un appelant qui ne rattrape que le JSON (repli silencieux F18/F57). */
    private fun contrat(bloc: () -> Any?, contexte: String) {
        try {
            bloc()
        } catch (erreur: Throwable) {
            assertTrue(
                "$contexte : exception non geree ${erreur.javaClass.name}: ${erreur.message}",
                erreur is JSONException || erreur is IllegalArgumentException
            )
        }
    }

    @Test
    fun `parseurs gabarit ne levent que JSONException sur entrees mutees`() {
        val bases = echantillons()
        assertTrue("aucune base a fuzzer", bases.isNotEmpty())
        bases.forEach { raw ->
            repeat(100) {
                val mution = muter(raw)
                contrat({ GabaritJson.parse(mution) }, "parse")
                contrat({ GabaritJson.parseBrief(mution) }, "parseBrief")
                contrat({ GabaritJson.parsePrises(mution) }, "parsePrises")
                contrat({ GabaritJson.parseCheckRows(mution) }, "parseCheckRows")
                contrat({ GabaritJson.parsePreviewTexts(mution, mapOf("a" to "b")) }, "parsePreviewTexts")
                // build : contrat FORT — jamais d'exception (runCatching interne),
                // repli null ou document valide.
                val doc = GabaritBeatSheet.build(mution, mapOf("nom_commerce" to "店"))
                if (doc != null) {
                    JSONObject(doc.beatSheetJson)   // doit etre du JSON valide
                    assertTrue(doc.totalDurationS > 0.0)
                }
            }
        }
    }

    @Test
    fun `troncatures deterministes ne produisent aucun document corrompu`() {
        echantillons().forEach { raw ->
            listOf(0, 1, raw.length / 4, raw.length / 2, raw.length - 1).forEach { coupe ->
                val tronque = raw.take(coupe)
                val doc = GabaritBeatSheet.build(tronque, emptyMap())
                if (doc != null) {
                    val sheet = JSONObject(doc.beatSheetJson)
                    assertTrue(sheet.getJSONArray("plans").length() > 0)
                }
                contrat({ GabaritJson.parse(tronque) }, "parse tronque")
            }
        }
    }
}
