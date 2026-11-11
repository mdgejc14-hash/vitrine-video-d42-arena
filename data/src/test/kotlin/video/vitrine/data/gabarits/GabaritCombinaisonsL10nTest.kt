package video.vitrine.data.gabarits

import java.io.File
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Audit D41 — validation combinatoire GABARIT x LANGUE : les 30 gabarits T1-T5
 * (6 secteurs, assets reels du repo) x 4 langues d'echantillons brief (FR, EN,
 * ES, JA dont CJK) = 120 combinaisons. Chaque combinaison doit produire un beat
 * sheet CONSTRUIT et conforme au protocole de montage (plans <= 1,5 s, D23 ;
 * timecodes coherents ; SFX dans la fenetre de composition).
 *
 * Limite honnete : ce test valide la CHAINE JSON gabarit -> valeurs brief ->
 * BeatSheet (logique pure). Le rendu MP4 physique par combinaison est NON
 * TESTABLE en sandbox (pas d'emulateur) — il est documente au rapport D41.
 */
class GabaritCombinaisonsL10nTest {

    private fun repertoireAssets(): File {
        val candidats = listOf(
            File("src/main/assets/gabarits"),
            File("data/src/main/assets/gabarits")
        )
        return candidats.firstOrNull { it.isDirectory }
            ?: throw AssertionError("assets gabarits introuvables depuis ${File(".").absolutePath}")
    }

    private fun gabaritFiles(): List<File> =
        repertoireAssets().walkTopDown().filter { it.extension == "json" }.toList().sortedBy { it.path }

    // D42.30 : FR/EN uniquement (ES/JA retirés du produit).
    private val echantillons = mapOf(
        "fr" to "Offre exceptionnelle",
        "en" to "Exceptional offer"
    )

    /** Valeurs de brief par langue, construites sur les CHAMPS REELS du gabarit. */
    private fun valeursPour(raw: String, langue: String): Map<String, String> {
        val brief = GabaritJson.parseBrief(raw)
        val texte = echantillons.getValue(langue)
        return brief.fields.associate { champ ->
            champ.id to when {
                champ.type == "nombre" -> "5000"
                // D42.30 : Bénin 10 chiffres/01 depuis le 30/11/2024.
                champ.type == "telephone" || champ.validation == "format_international" -> "+2290197000000"
                champ.choices.isNotEmpty() -> champ.choices.first()
                else -> texte
            }
        }
    }

    @Test
    fun `les 30 gabarits universels sont presents dans les assets`() {
        assertEquals(30, gabaritFiles().size)
    }

    @Test
    fun `60 combinaisons gabarit x langue construisent un beat sheet conforme`() {
        var combinaisons = 0
        gabaritFiles().forEach { fichier ->
            val raw = fichier.readText()
            echantillons.keys.forEach { langue ->
                val doc = GabaritBeatSheet.build(raw, valeursPour(raw, langue))
                assertNotNull("build nul pour ${fichier.name} en $langue", doc)
                verifierDocument(doc!!, "${fichier.name}/$langue")
                combinaisons += 1
            }
        }
        assertEquals(60, combinaisons)
    }

    private fun verifierDocument(doc: GabaritBeatSheet.Document, contexte: String) {
        val sheet = JSONObject(doc.beatSheetJson)
        val plans = sheet.getJSONArray("plans")
        assertTrue("$contexte : aucun plan", plans.length() > 0)
        for (i in 0 until plans.length()) {
            val plan = plans.getJSONObject(i)
            val t0 = plan.getDouble("t0")
            val t1 = plan.getDouble("t1")
            assertTrue("$contexte : plan $i t1 <= t0", t1 > t0)
            // Protocole de montage D23 : decoupage cible 1,5 s (marge d'arrondi).
            assertTrue("$contexte : plan $i trop long (${t1 - t0} s)", t1 - t0 <= 1.51)
            assertTrue("$contexte : plan $i in_t negatif", plan.optDouble("in_t", 0.0) >= 0.0)
        }
        val words = sheet.getJSONArray("words")
        for (i in 0 until words.length()) {
            val mot = words.getJSONArray(i)
            assertTrue(
                "$contexte : mot $i timecodes inverses",
                mot.getDouble(1) <= mot.getDouble(2)
            )
        }
        assertTrue("$contexte : duree totale nulle", doc.totalDurationS > 0.0)
        assertTrue(
            "$contexte : ducking hors contrat (${doc.duckingDb})",
            doc.duckingDb in -30.0..0.0
        )
        val finUs = (doc.totalDurationS * 1_000_000).toLong() + 500_000L
        doc.sfxEvents.forEach { evenement ->
            assertTrue("$contexte : SFX avant le debut", evenement.atUs >= 0L)
            assertTrue("$contexte : SFX apres la composition", evenement.atUs <= finUs)
        }
    }
}
