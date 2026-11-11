package video.vitrine.data.i18n

import java.io.File
import org.json.JSONArray
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test
import video.vitrine.data.gabarits.GabaritBeatSheet

/**
 * D42 — contrats de l'i18n marchande et du badge E5 (F69), SANS emulateur.
 *
 * Ces assertions tournent dans `android-ci` (testDebugUnitTest) : elles
 * protegent la couche texte/badge a chaque commit, sans consommer de minutes
 * d'emulateur. Le rendu visuel, lui, ne se prouve que par un MP4 (cf. le
 * rapport D42 : un test vert ici ne vaut pas preuve video).
 */
class GabaritL10nTest {

    private val racine: File = listOf(
        File("src/main/assets"),
        File("data/src/main/assets")
    ).firstOrNull { File(it, "i18n/gabarit_l10n_v1.json").isFile } ?: File("src/main/assets")

    private fun dictionnaire(): GabaritL10n.Donnees =
        GabaritL10n.parse(File(racine, "i18n/gabarit_l10n_v1.json").readText())

    private fun gabarits(): List<File> =
        File(racine, "gabarits").listFiles().orEmpty()
            .filter { it.isDirectory }
            .sortedBy { it.name }
            .flatMap { secteur -> secteur.listFiles().orEmpty().filter { it.name.endsWith(".json") }.sortedBy { it.name } }

    private fun textesCanoniques(): Set<String> {
        val sortie = mutableSetOf<String>()
        gabarits().forEach { fichier ->
            val scenes = JSONObject(fichier.readText()).optJSONArray("scenes") ?: JSONArray()
            for (i in 0 until scenes.length()) {
                val contenu = scenes.getJSONObject(i)
                    .optJSONObject("texte_ecran")?.optString("contenu").orEmpty()
                if (contenu.isNotBlank()) sortie += contenu
            }
        }
        return sortie
    }

    @Test
    fun lesClesCouvrentExactementLesTextesDesGabarits() {
        val donnees = dictionnaire()
        val canoniques = textesCanoniques()
        // D42.3 : 53 depuis l'ajout de deux textes de scene a
        // restaurants_maquis/T1 — « {nom_offre} » (l'offre du commercant
        // n'etait affichee par aucune scene) et « CONTACTEZ-NOUS » (appel a
        // l'action absent des 30 gabarits). Les deux sont traduits, donc
        // l'intention du test (aucune cle orpheline, aucun texte untraduit)
        // reste respectee.
        assertEquals("53 textes distincts attendus", 53, canoniques.size)
        val absentes = canoniques.filter { donnees.textes[it] == null }
        assertTrue("textes canoniques sans traduction: $absentes", absentes.isEmpty())
        val orphelines = donnees.textes.keys.filter { it !in canoniques }
        assertTrue("cles sans texte canonique (derive silencieuse): $orphelines", orphelines.isEmpty())
    }

    @Test
    fun lesDeuxLanguesSontCompletes() { // D42.30 : FR/EN uniquement
        val donnees = dictionnaire()
        GabaritL10n.LANGUES.filter { it != GabaritL10n.LANGUE_SOURCE }.forEach { langue ->
            assertEquals("textes manquants en $langue", emptyList<String>(), donnees.manquantes(langue))
            assertEquals("badges manquants en $langue", emptyList<String>(), donnees.badgesManquants(langue))
        }
    }

    @Test
    fun lesVariablesNeSontJamaisPerduesParTraduction() {
        val violations = GabaritL10n.variablesIntactes(dictionnaire())
        assertTrue("variables alterees: $violations", violations.isEmpty())
    }

    @Test
    fun lAnglaisEstReellementDeLanglais() {
        // D42.30 : ES/JA retirés du produit — la couverture vivante est EN.
        val donnees = dictionnaire()
        val badge = donnees.badge("stock_limite", "en")
        assertEquals("LIMITED STOCK", badge)
        val accroche = donnees.resolve("À DÉCOUVRIR", "en")
        assertNotEqualsFrancais(accroche)
        // Des mots anglais reels sont presents dans la couverture (pas du
        // francais recopie) : au moins une traduction contient un mot usuel.
        val anglais = donnees.textes.values.mapNotNull { it["en"] }.joinToString(" ")
        assertTrue(
            "couverture EN vide ou identique au francais",
            anglais.length > 100 && anglais.split(" ").any {
                it.lowercase() in setOf("your", "video", "with", "discover", "offer")
            },
        )
    }

    private fun assertNotEqualsFrancais(valeur: String) {
        assertFalse("traduction identique au francais: $valeur", valeur == "À DÉCOUVRIR")
    }

    @Test
    fun leRepliFrancaisEstToujoursServi() {
        val donnees = dictionnaire()
        assertEquals("À DÉCOUVRIR", donnees.resolve("À DÉCOUVRIR", "fr"))
        assertEquals("À DÉCOUVRIR", donnees.resolve("À DÉCOUVRIR", "xx"))
        assertEquals("texte inconnu", donnees.resolve("texte inconnu", "ja"))
        assertEquals(null, donnees.badge(null, "ja"))
        assertEquals(null, donnees.badge("code_inexistant", "ja"))
        assertEquals(null, donnees.badge("false", "ja"))
    }

    // ------------------------------------------------------------------ badge

    /** Gabarit T1 d'un secteur reel : le badge doit apparaitre sur les scenes declarees. */
    private fun gabarit(nom: String): String {
        val fichier = gabarits().first { it.parentFile.name + "_" + it.nameWithoutExtension == nom }
        return fichier.readText()
    }

    private fun mots(beatSheet: String): List<JSONArray> {
        val arr = JSONObject(beatSheet).optJSONArray("words") ?: JSONArray()
        return (0 until arr.length()).map { arr.getJSONArray(it) }
    }

    @Test
    fun leBadgeEstRenduUniquementSilEstSelectionne() {
        val raw = gabarit("restaurants_maquis_T1")
        val donnees = dictionnaire()
        val sans = GabaritBeatSheet.build(raw, mapOf("nom_commerce" to "Chez Chantal"))
        val avec = GabaritBeatSheet.build(
            raw,
            mapOf("nom_commerce" to "Chez Chantal"),
            localiser = { donnees.resolve(it, "fr") },
            badgeTexte = donnees.badge("stock_limite", "fr")
        )
        assertNotNull(sans)
        assertNotNull(avec)
        val motsSans = mots(sans!!.beatSheetJson).map { it.getString(0) }
        val motsAvec = mots(avec!!.beatSheetJson).map { it.getString(0) }
        assertFalse("badge present sans selection", motsSans.contains("STOCK LIMITÉ"))
        assertTrue("badge absent alors qu'il est selectionne", motsAvec.contains("STOCK LIMITÉ"))
        assertEquals("une seule insertion de badge", 1, motsAvec.count { it == "STOCK LIMITÉ" })
    }

    @Test
    fun leBadgeNeChevaucheJamaisLeTexteDeSaScene() {
        val raw = gabarit("restaurants_maquis_T1")
        val donnees = dictionnaire()
        val doc = GabaritBeatSheet.build(
            raw,
            mapOf("nom_commerce" to "Chez Chantal", "prix" to "5000", "devise" to "FCFA"),
            localiser = { donnees.resolve(it, "fr") },
            badgeTexte = donnees.badge("stock_limite", "fr")
        )!!
        val tous = mots(doc.beatSheetJson)
        val badge = tous.first { it.getString(0) == "STOCK LIMITÉ" }
        val debutBadge = badge.getDouble(1)
        val finBadge = badge.getDouble(2)
        // Aucun autre texte actif pendant la fenetre du badge.
        val collisions = tous.filter { it.getString(0) != "STOCK LIMITÉ" }
            .filter { it.getDouble(1) < finBadge - 1e-6 && it.getDouble(2) > debutBadge + 1e-6 }
        assertTrue("textes simultanes du badge: $collisions", collisions.isEmpty())
    }

    @Test
    fun chaqueGabaritRendSonBadgeDansSaPropreScene() {
        val donnees = dictionnaire()
        // Scene declaree par champs_saisie[badge_engagement_actif].scenes, pour
        // les 6 secteurs : T1->15, T2->13, T3->14, T4->17, T5->12.
        // D42 : la valeur T5 etait notee 1 par erreur de lecture (le champ est
        // un TABLEAU de champs, pas un objet) ; les 6 gabarits T5 declarent bien
        // la scene 12 sur 13. Le test verifie desormais la scene reelle.
        val attendu = mapOf("T1" to 15, "T2" to 13, "T3" to 14, "T4" to 17, "T5" to 12)
        val secteurs = File(racine, "gabarits").listFiles().orEmpty().filter { it.isDirectory }.sortedBy { it.name }
        assertEquals("6 secteurs", 6, secteurs.size)
        secteurs.forEach { secteur ->
            attendu.forEach { (tpl, numeroScene) ->
                val raw = File(secteur, "$tpl.json").readText()
                val doc = GabaritBeatSheet.build(
                    raw, emptyMap(),
                    localiser = { donnees.resolve(it, "fr") },
                    badgeTexte = donnees.badge("qualite_garantie", "fr")
                ) ?: error("build null pour ${secteur.name}/$tpl")
                val badge = mots(doc.beatSheetJson).firstOrNull { it.getString(0) == "QUALITÉ GARANTIE" }
                assertNotNull("badge absent ${secteur.name}/$tpl", badge)
                val debut = badge!!.getDouble(1)
                val scene = sceneContenant(secteur, tpl, debut)
                assertEquals("mauvaise scene ${secteur.name}/$tpl", numeroScene, scene)
            }
        }
    }

    /** Numero de scene (1-based) dont la fenetre temporelle contient [instant]. */
    private fun sceneContenant(secteur: File, tpl: String, instant: Double): Int {
        val scenes = JSONObject(File(secteur, "$tpl.json").readText()).getJSONArray("scenes")
        var curseur = 0.0
        for (i in 0 until scenes.length()) {
            val duree = scenes.getJSONObject(i).optDouble("duree_secondes", 0.0)
            if (instant >= curseur - 1e-6 && instant < curseur + duree + 1e-6) return i + 1
            curseur += duree
        }
        return -1
    }

    // -------------------------------------------------------------------- i18n

    @Test
    fun leRenduAnglaisRemplaceLeFrancaisSansPerdreLesVariables() {
        // D42.30 : ES/JA retirés — la preuve de substitution vit en EN.
        val raw = gabarit("restaurants_maquis_T1")
        val donnees = dictionnaire()
        val valeurs = mapOf("prix" to "5000", "devise" to "FCFA", "nom_commerce" to "Chantal Kitchen")
        val en = GabaritBeatSheet.build(
            raw, valeurs,
            localiser = { donnees.resolve(it, "en") },
            badgeTexte = donnees.badge("places_limitees", "en")
        )!!
        val textes = mots(en.beatSheetJson).map { it.getString(0) }
        // D42.3 : le prix est desormais groupe (« 5000 » -> « 5 000 »). L'intention
        // du test est inchangee — le prix ET sa devise sont substitues — seule la
        // forme attendue suit la convention de formatage de l'application.
        assertTrue(
            "prix non substitue : ${textes.filter { it.contains("FCFA") }}",
            textes.any { it.contains("5 000") && it.contains("FCFA") },
        )
        assertFalse("texte francais residuel", textes.contains("À DÉCOUVRIR"))
        assertTrue("badge anglais absent", textes.any { it.contains("LIMITED SEATS") })
        // Aucun texte ne doit rester sous forme de variable brute.
        assertTrue(
            "variables non substituees: ${textes.filter { it.contains('{') }}",
            textes.none { it.contains('{') && it.contains('}') }
        )
    }

}
