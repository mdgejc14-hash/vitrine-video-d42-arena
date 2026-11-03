package video.vitrine.data.audio

import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import java.io.File
import java.security.MessageDigest

/**
 * Contrat banque SFX locale (sfx_local_v1_3.schema.json) : les 9 catégories du
 * contrat doivent être EMBARQUÉES physiquement dans les assets du module data
 * (usage 100 % hors-ligne, 280 événements des gabarits), en WAV PCM 48 kHz
 * mono 16 bits, durées exactes, sha256 du manifeste conformes.
 *
 * La banque est générée de façon déterministe par
 * scripts/audio/generate_sfx_bank.py (licence CC0-1.0 : synthèse propre,
 * aucune œuvre tierce). revision_humaine_approuvee passe à true après écoute
 * (procédure : docs/AUDIO_BGM_TELEVERSEMENT.md §SFX).
 */
class SfxBankContractTest {

    private val categories = listOf(
        "amb_chantier", "caisse_enregistreuse", "clic_appareil", "impact_drop",
        "pop_badge", "sizzle_grill", "vapeur_plat", "whoosh_fast", "whoosh_soft"
    )

    private fun sfxDir(): File {
        // Gradle exécute les tests unitaires avec cwd = répertoire du module.
        val direct = File("src/main/assets/audio/sfx")
        if (direct.isDirectory) return direct
        val parent = File("../data/src/main/assets/audio/sfx")
        assertTrue("dossier SFX introuvable (cwd=${File(".").absolutePath})", parent.isDirectory)
        return parent
    }

    private fun sha256(bytes: ByteArray): String =
        MessageDigest.getInstance("SHA-256").digest(bytes)
            .joinToString("") { "%02x".format(it) }

    private fun manifest(): JSONObject {
        val file = File(sfxDir(), "manifest_sfx_v1_3.json")
        assertTrue("manifeste absent", file.isFile)
        return JSONObject(file.readText())
    }

    @Test
    fun `les 9 categories sont embarquees physiquement`() {
        categories.forEach { cat ->
            val wav = File(sfxDir(), "$cat.wav")
            assertTrue("SFX manquant : $cat.wav", wav.isFile)
            assertTrue("SFX vide : $cat.wav", wav.length() > 44)
        }
    }

    @Test
    fun `entetes WAV conformes au contrat 48 kHz mono 16 bits`() {
        categories.forEach { cat ->
            val b = File(sfxDir(), "$cat.wav").readBytes()
            assertEquals("RIFF", String(b, 0, 4, Charsets.US_ASCII))
            assertEquals("WAVE", String(b, 8, 4, Charsets.US_ASCII))
            assertEquals("fmt ", String(b, 12, 4, Charsets.US_ASCII))
            val fmtPcm = (b[20].toInt() and 0xFF) or (b[21].toInt() shl 8)
            assertEquals("$cat : PCM attendu", 1, fmtPcm)
            val channels = (b[22].toInt() and 0xFF) or (b[23].toInt() shl 8)
            assertEquals("$cat : mono attendu", 1, channels)
            val rate = (b[24].toInt() and 0xFF) or ((b[25].toInt() and 0xFF) shl 8) or
                ((b[26].toInt() and 0xFF) shl 16) or ((b[27].toInt() and 0xFF) shl 24)
            assertEquals("$cat : 48 kHz attendu", 48000, rate)
            val bits = (b[34].toInt() and 0xFF) or (b[35].toInt() shl 8)
            assertEquals("$cat : 16 bits attendu", 16, bits)
        }
    }

    @Test
    fun `manifeste v1_3 coherent avec les fichiers embarques`() {
        val m = manifest()
        val entrees = m.getJSONArray("entrees")
        assertEquals(9, entrees.length())
        var approuves = 0
        for (i in 0 until entrees.length()) {
            val e = entrees.getJSONObject(i)
            val cat = e.getString("categorie_json")
            assertTrue("catégorie hors contrat : $cat", cat in categories)
            assertEquals("1.3", e.getString("schema_version"))
            assertEquals(48000, e.getInt("audio_hz"))
            assertEquals("assets/audio/sfx/$cat.wav", e.getString("chemin_logique"))
            assertTrue(
                "licence hors contrat : ${e.getString("licence_code")}",
                e.getString("licence_code") == "CC0-1.0" ||
                    e.getString("licence_code") == "DOMAINE_PUBLIC_VERIFIE"
            )
            val wav = File(sfxDir(), "$cat.wav")
            val raw = wav.readBytes()
            assertEquals("$cat : taille manifeste ≠ fichier", e.getInt("taille_octets"), raw.size)
            assertEquals("$cat : sha256 manifeste ≠ fichier", e.getString("sha256"), sha256(raw))
            // data chunk = duree_samples * 2 octets (mono 16 bits) ; entête canonique 44
            assertEquals(
                "$cat : durée échantillons ≠ taille data",
                e.getInt("duree_samples"), (raw.size - 44) / 2
            )
            val impact = e.getInt("sample_impact_fichier")
            assertTrue("$cat : sample de choc hors durée", impact in 0 until e.getInt("duree_samples"))
            if (e.getBoolean("revision_humaine_approuvee")) approuves++
        }
        // Cohérence du statut global avec les approbations unitaires.
        val statut = m.getString("statut_global")
        if (approuves == 9) {
            assertEquals("APPROUVEE_HUMAINE", statut)
        } else {
            assertEquals("EN_ATTENTE_REVISION_HUMAINE", statut)
        }
    }
}
