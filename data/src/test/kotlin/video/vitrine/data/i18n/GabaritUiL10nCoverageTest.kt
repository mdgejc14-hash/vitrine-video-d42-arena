package video.vitrine.data.i18n

import java.io.File
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * D42.32 (Lot 4) — CONTRÔLE AUTOMATIQUE des traductions EN manquantes de la
 * surface marchande (catalogue / brief / guide caméra / récap export).
 *
 * Pour CHACUN des 30 gabarits embarqués, l'overlay
 * assets/i18n/gabarits_ui_l10n_v1.json doit contenir, clé par IDENTIFIANT
 * TECHNIQUE STABLE :
 *  - nom_format, phrase_courte, secteur_libelle non vides ET différents du FR ;
 *  - chaque champ de champs_saisie : label, aide, exemple non vides ;
 *  - chaque section de formulaire_ui (principales + options) : titre non vide ;
 *  - chaque prise : libelle + consigne non vides ; chaque segment :
 *    show, tell, exemple non vides ;
 *  - les variables {…} préservées à l'identique entre FR et EN.
 *
 * Un seul manque = test ROUGE : plus jamais d'écran mi-FR mi-EN.
 * Test JVM pur (lecture des assets du repo, comme GabaritL10nTest).
 */
class GabaritUiL10nCoverageTest {

    private val racine: File = listOf(
        File("src/main/assets"),
        File("data/src/main/assets")
    ).firstOrNull { File(it, "i18n/gabarits_ui_l10n_v1.json").isFile } ?: File("src/main/assets")

    private fun gabarits(): List<File> =
        File(racine, "gabarits").listFiles().orEmpty()
            .filter { it.isDirectory }
            .sortedBy { it.name }
            .flatMap { secteur ->
                secteur.listFiles().orEmpty().filter { it.name.endsWith(".json") }.sortedBy { it.name }
            }

    private fun overlay(): JSONObject =
        JSONObject(File(racine, "i18n/gabarits_ui_l10n_v1.json").readText())

    private fun variables(texte: String): Set<String> =
        Regex("\\{\\w+}").findAll(texte).map { it.value }.toSet()

    /** Paires (gabarit FR, overlay EN) — les absents sont consignés dans [problemes]. */
    private fun paires(problemes: MutableList<String>): List<Pair<JSONObject, JSONObject>> {
        val ov = overlay()
        return gabarits().mapNotNull { fichier ->
            val g = JSONObject(fichier.readText())
            val t = ov.optJSONObject(g.getString("id"))
            if (t == null) {
                problemes += "${g.getString("id")} : entrée absente"
                null
            } else {
                g to t
            }
        }
    }

    private fun verifier(problemes: List<String>) {
        assertTrue(
            "Traductions EN manquantes (${problemes.size}) :\n" + problemes.joinToString("\n"),
            problemes.isEmpty()
        )
    }

    @Test
    fun `les 30 gabarits ont une entrée d'overlay`() {
        val overlay = overlay()
        val fichiers = gabarits()
        assertEquals("30 gabarits embarqués attendus", 30, fichiers.size)
        fichiers.forEach { fichier ->
            val gabarit = JSONObject(fichier.readText())
            val id = gabarit.getString("id")
            assertNotNull(
                "overlay EN manquant pour $id (${fichier.name})",
                overlay.optJSONObject(id)
            )
        }
    }

    @Test
    fun `identité du gabarit traduite`() {
        val problemes = mutableListOf<String>()
        paires(problemes).forEach { (g, t) ->
            val id = g.getString("id")
            listOf("nom_format", "phrase_courte", "secteur_libelle").forEach { cle ->
                if (t.optString(cle).isBlank()) problemes += "$id.$cle : traduction vide"
            }
            if (t.optString("nom_format") == g.optString("nom_format_affiche")) {
                problemes += "$id.nom_format : identique au FR (non traduit)"
            }
        }
        verifier(problemes)
    }

    @Test
    fun `champs du brief couverts`() {
        val problemes = mutableListOf<String>()
        paires(problemes).forEach { (g, t) ->
            val id = g.getString("id")
            val tChamps = t.optJSONObject("champs") ?: JSONObject()
            g.optJSONArray("champs_saisie")?.let { arr ->
                for (i in 0 until arr.length()) {
                    val cid = arr.getJSONObject(i).getString("id")
                    val tc = tChamps.optJSONObject(cid)
                    if (tc == null) {
                        problemes += "$id.champs.$cid : absent de l'overlay"
                    } else {
                        listOf("label", "aide", "exemple").forEach { cle ->
                            if (tc.optString(cle).isBlank()) {
                                problemes += "$id.champs.$cid.$cle : vide"
                            }
                        }
                    }
                }
            }
        }
        verifier(problemes)
    }

    @Test
    fun `sections du formulaire couvertes`() {
        val problemes = mutableListOf<String>()
        paires(problemes).forEach { (g, t) ->
            val id = g.getString("id")
            val tSections = t.optJSONObject("sections") ?: JSONObject()
            val form = g.optJSONObject("formulaire_ui")
            form?.optJSONArray("sections_principales")?.let { arr ->
                for (i in 0 until arr.length()) {
                    val sid = arr.getJSONObject(i).getString("id")
                    if (tSections.optString(sid).isBlank()) {
                        problemes += "$id.sections.$sid : titre non traduit"
                    }
                }
            }
            form?.optJSONObject("options_facultatives_repliees")?.let { opt ->
                if (tSections.optString(opt.getString("id")).isBlank()) {
                    problemes += "$id.sections.${opt.getString("id")} : options non traduites"
                }
            }
        }
        verifier(problemes)
    }

    @Test
    fun `prises et segments couverts`() {
        val problemes = mutableListOf<String>()
        paires(problemes).forEach { (g, t) ->
            val id = g.getString("id")
            val tPrises = t.optJSONObject("prises") ?: JSONObject()
            g.optJSONArray("prises")?.let { arr ->
                for (i in 0 until arr.length()) {
                    val p = arr.getJSONObject(i)
                    val pid = p.getString("id")
                    val tp = tPrises.optJSONObject(pid)
                    if (tp == null) {
                        problemes += "$id.prises.$pid : absente de l'overlay"
                        continue
                    }
                    if (tp.optString("libelle").isBlank()) {
                        problemes += "$id.prises.$pid.libelle : vide"
                    }
                    if (tp.optString("consigne").isBlank()) {
                        problemes += "$id.prises.$pid.consigne : vide"
                    }
                    verifierSegmentsCouverts(id, pid, p, tp, problemes)
                }
            }
        }
        verifier(problemes)
    }

    private fun verifierSegmentsCouverts(
        id: String,
        pid: String,
        p: JSONObject,
        tp: JSONObject,
        problemes: MutableList<String>
    ) {
        p.optJSONArray("segments_guide_parole")?.let { sa ->
            for (j in 0 until sa.length()) {
                val ts = tp.optJSONObject("segments")?.optJSONObject(j.toString())
                if (ts == null) {
                    problemes += "$id.prises.$pid.segments[$j] : absent"
                    continue
                }
                listOf("show", "tell", "exemple").forEach { cle ->
                    if (ts.optString(cle).isBlank()) {
                        problemes += "$id.prises.$pid.segments[$j].$cle : vide"
                    }
                }
            }
        }
    }

    @Test
    fun `variables interpolées préservées`() {
        val problemes = mutableListOf<String>()
        paires(problemes).forEach { (g, t) ->
            val id = g.getString("id")
            val tPrises = t.optJSONObject("prises") ?: JSONObject()
            g.optJSONArray("prises")?.let { arr ->
                for (i in 0 until arr.length()) {
                    val p = arr.getJSONObject(i)
                    val pid = p.getString("id")
                    val tp = tPrises.optJSONObject(pid) ?: continue
                    p.optJSONArray("segments_guide_parole")?.let { sa ->
                        for (j in 0 until sa.length()) {
                            verifierVariablesSegment(id, pid, sa.getJSONObject(j), tp, j, problemes)
                        }
                    }
                }
            }
        }
        verifier(problemes)
    }

    private fun verifierVariablesSegment(
        id: String,
        pid: String,
        sg: JSONObject,
        tp: JSONObject,
        j: Int,
        problemes: MutableList<String>
    ) {
        val ts = tp.optJSONObject("segments")?.optJSONObject(j.toString()) ?: return
        // variables {…} préservées (contrat GabaritL10n étendu à l'UI)
        listOf(
            "quoi_montrer" to "show",
            "quoi_raconter" to "tell",
            "exemple" to "exemple"
        ).forEach { (fr, en) ->
            if (variables(sg.optString(fr)) != variables(ts.optString(en))) {
                problemes += "$id.prises.$pid.segments[$j].$en : variables {…} altérées"
            }
        }
    }
}
