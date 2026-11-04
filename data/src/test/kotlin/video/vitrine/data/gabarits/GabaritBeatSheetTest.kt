package video.vitrine.data.gabarits

import org.json.JSONArray
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Audit D40 (A5/A6) : la structure des gabarits V2.0 devient le beat sheet du
 * moteur. Portes WordClock respectees par construction (moyenne <= 1,5 s,
 * max <= 3 s, bornes contigues, duree = gabarit), reperes SFX et piste BGM
 * issus du bloc audio, cartes generees presentes en kind="card".
 */
class GabaritBeatSheetTest {

    private val fixtures = listOf(
        "batiment_travaux_T1", "coiffure_beaute_T5", "vetements_mode_T4"
    )

    private fun fixture(name: String): String =
        javaClass.getResourceAsStream("/fixtures/$name.json")!!.readBytes().decodeToString()

    /** Textes affiches du beat sheet : `words` est un tableau de triplets
     *  `["texte", debut, fin]` (structure reelle produite par le moteur). */
    private fun libellesAffiches(doc: GabaritBeatSheet.Document): List<String> {
        val mots = org.json.JSONObject(doc.beatSheetJson).getJSONArray("words")
        return (0 until mots.length()).map { mots.getJSONArray(it).getString(0) }
    }

    @Test
    fun `beat sheet conforme aux portes de montage sur les 3 fixtures`() {
        fixtures.forEach { name ->
            val raw = fixture(name)
            val doc = GabaritBeatSheet.build(raw, mapOf("nom_commerce" to "Chez Awa", "prix" to "15000"))
            assertNotNull("doc $name", doc)
            val sheet = JSONObject(doc!!.beatSheetJson)
            val plans = sheet.getJSONArray("plans")
            assertTrue("plans $name", plans.length() > 0)

            var previousEnd = 0.0
            var total = 0.0
            var max = 0.0
            for (i in 0 until plans.length()) {
                val p = plans.getJSONObject(i)
                assertEquals("contigu $name", previousEnd, p.getDouble("t0"), 1e-9)
                previousEnd = p.getDouble("t1")
                val d = p.getDouble("t1") - p.getDouble("t0")
                total += d
                max = maxOf(max, d)
                assertTrue("plan <= 1,5 s $name", d <= 1.5 + 1e-9)
                assertNotNull(p.getJSONArray("z"))
                assertEquals(2, p.getJSONArray("z").length())
                assertTrue("rid $name", p.getInt("rid") >= 0)
            }
            assertTrue("max <= 3 s $name", max <= 3.0)
            assertTrue("moyenne <= 1,5 s $name", total / plans.length() <= 1.5 + 1e-9)

            val attendu = JSONObject(raw).getDouble("duree_totale_secondes")
            assertEquals("duree totale $name", attendu, total, 0.05)
        }
    }

    @Test
    fun `sfx et bgm viennent du bloc audio du gabarit`() {
        fixtures.forEach { name ->
            val raw = fixture(name)
            val audio = JSONObject(raw).getJSONObject("audio")
            val doc = GabaritBeatSheet.build(raw, emptyMap())!!
            assertEquals(
                "sfx count $name",
                audio.getJSONArray("sfx_scenes").length(),
                doc.sfxEvents.size
            )
            assertEquals(
                "bgm $name",
                audio.getJSONObject("musique").getString("categorie_audio"),
                doc.bgmCategorie
            )
            val parsed = JSONArray(doc.sfxEventsJson)
            assertEquals(doc.sfxEvents.size, parsed.length())
            assertTrue(
                "marqueurs ordonnes $name",
                doc.sfxEvents.zipWithNext { a, b -> a.atUs <= b.atUs }.all { it }
            )
        }
    }

    @Test
    fun `cartes generees deviennent des plans card et les variables sont substituees`() {
        val raw = fixture("coiffure_beaute_T5")
        val axes = JSONObject(raw).getJSONObject("axes_signature")
        val decoupage = axes.getJSONArray("decoupage_prises")
        var cartesAttendues = 0
        for (i in 0 until decoupage.length()) {
            if (decoupage.getString(i).startsWith("carte:")) cartesAttendues++
        }
        val doc = GabaritBeatSheet.build(
            raw,
            mapOf("nom_commerce" to "Salon Belle Tresse", "prix" to "25000", "devise" to "FCFA")
        )!!
        val plans = JSONObject(doc.beatSheetJson).getJSONArray("plans")
        var cartes = 0
        for (i in 0 until plans.length()) {
            if (plans.getJSONObject(i).optString("kind") == "card") cartes++
        }
        assertTrue("au moins une carte $cartesAttendues", cartesAttendues > 0)
        assertTrue("plans card presentes", cartes > 0)

        val words = JSONObject(doc.beatSheetJson).getJSONArray("words")
        var substitue = false
        for (i in 0 until words.length()) {
            val texte = words.getJSONArray(i).getString(0)
            assertTrue("aucune variable brute", !texte.contains("{"))
            if (texte.contains("Salon Belle Tresse") || texte.contains("25000")) substitue = true
        }
        assertTrue("valeur du brief presente a l'ecran", substitue)
    }

    @Test
    fun `pourcentage - jamais de tiret orphelin a l ecran`() {
        // D42.6, mesure sur les 120 rendus reels : la scene 6 des six gabarits T4
        // affiche « -{pourcentage}% ». Sans ancien prix superieur au prix, il n'y
        // a aucune reduction a calculer et le MP4 montrait « -% ».
        val base = mapOf(
            "nom_commerce" to "Chez Test", "nom_offre" to "Offre", "prix" to "25000",
            "devise" to "FCFA", "quartier_ville" to "Cotonou",
            "whatsapp" to "+22997000000"
        )
        val sansReduction = GabaritBeatSheet.build(fixture("vetements_mode_T4"), base)!!
        val motsSans = libellesAffiches(sansReduction)
        assertFalse("tiret orphelin dessine : $motsSans", motsSans.any { it.contains("%") })

        val avecReduction = GabaritBeatSheet.build(
            fixture("vetements_mode_T4"),
            base + ("ancien_prix" to "31250")
        )!!
        val motsAvec = libellesAffiches(avecReduction)
        assertTrue("reduction jamais dessinee : $motsAvec", motsAvec.any { it.contains("20") })
        assertFalse("tiret orphelin restant : $motsAvec", motsAvec.any { it.trim() == "-%" })
    }

    @Test
    fun `gabarit invalide renvoie null sans exception`() {
        assertEquals(null, GabaritBeatSheet.build("{}", emptyMap()))
        assertEquals(null, GabaritBeatSheet.build("pas-du-json", emptyMap()))
    }

    @Test
    fun `le prix est groupe par milliers dans le texte affiche`() {
        // D42.3 : « 25000 » s'affichait tel quel dans le MP4. Un commercant lit
        // « 25 000 FCFA » — meme convention que le paywall (espace U+0020).
        val doc = GabaritBeatSheet.build(
            fixture("restaurants_maquis_T1"),
            mapOf(
                "nom_commerce" to "Chez D42 Test",
                "nom_offre" to "OFFRE D42 DIAGNOSTIC",
                "prix" to "25000",
                "devise" to "FCFA",
                "quartier_ville" to "COTONOU",
                "whatsapp" to "+22997000000",
            ),
            null,
            localiser = { cle -> cle },
        ) ?: error("beat sheet null pour restaurants_maquis_T1")
        // On controle le TEXTE AFFICHE (words), pas tout le JSON : `keywords`
        // conserve volontairement le jeton brut (« 25000 ») pour l'indexation,
        // ce n'est pas de l'affichage.
        val affiches = libellesAffiches(doc)
        assertTrue(
            "prix non groupe dans le texte affiche : $affiches",
            affiches.any { it.contains("25 000 FCFA") },
        )
        assertTrue(
            "prix brut encore affiche : $affiches",
            affiches.none { it.contains("25000") },
        )
    }

    @Test
    fun `un libelle latin sans espace reste entier`() {
        // D42.3 : la segmentation par longueur (CJK) coupait « CONTACTEZ-NOUS »
        // en « CONTACT » / « EZ-NOUS » dans le MP4.
        val doc = GabaritBeatSheet.build(
            fixture("restaurants_maquis_T1"),
            mapOf(
                "nom_commerce" to "Chez D42 Test",
                "nom_offre" to "OFFRE D42 DIAGNOSTIC",
                "prix" to "25000", "devise" to "FCFA",
                "quartier_ville" to "COTONOU", "whatsapp" to "+22997000000",
            ),
            null,
            localiser = { cle -> cle },
        ) ?: error("beat sheet null pour restaurants_maquis_T1")
        val libelles = libellesAffiches(doc)
        assertTrue("CTA coupe en morceaux : $libelles", libelles.contains("CONTACTEZ-NOUS"))
        assertTrue("offre absente : $libelles", libelles.contains("OFFRE D42 DIAGNOSTIC"))
    }
}
