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
        assertEquals("51 textes distincts attendus", 51, canoniques.size)
        val absentes = canoniques.filter { donnees.textes[it] == null }
        assertTrue("textes canoniques sans traduction: $absentes", absentes.isEmpty())
        val orphelines = donnees.textes.keys.filter { it !in canoniques }
        assertTrue("cles sans texte canonique (derive silencieuse): $orphelines", orphelines.isEmpty())
    }

    @Test
    fun lesQuatreLanguesSontCompletes() {
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
    fun leJaponaisEstReellementDuJaponais() {
        val donnees = dictionnaire()
        val badge = donnees.badge("stock_limite", "ja")
        assertEquals("在庫限定", badge)
        val accroche = donnees.resolve("À DÉCOUVRIR", "ja")
        assertNotEqualsFrancais(accroche)
        // Kanji / hiragana / katakana presents dans la couverture japonaise.
        val japonais = donnees.textes.values.mapNotNull { it["ja"] }.joinToString(" ")
        assertTrue("aucun kanji", japonais.any { it.code in 0x4E00..0x9FFF })
        assertTrue("aucun hiragana", japonais.any { it.code in 0x3040..0x309F })
        assertTrue("aucun katakana", japonais.any { it.code in 0x30A0..0x30FF })
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
        assertFalse("badge present sans selection", motsSans.contains("Stock limité"))
        assertTrue("badge absent alors qu'il est selectionne", motsAvec.contains("Stock limité"))
        assertEquals("une seule insertion de badge", 1, motsAvec.count { it == "Stock limité" })
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
        val badge = tous.first { it.getString(0) == "Stock limité" }
        val debutBadge = badge.getDouble(1)
        val finBadge = badge.getDouble(2)
        // Aucun autre texte actif pendant la fenetre du badge.
        val collisions = tous.filter { it.getString(0) != "Stock limité" }
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
                val badge = mots(doc.beatSheetJson).firstOrNull { it.getString(0) == "Qualité garantie" }
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
    fun leRenduJaponaisRemplaceLeFrancaisSansPerdreLesVariables() {
        val raw = gabarit("restaurants_maquis_T1")
        val donnees = dictionnaire()
        val valeurs = mapOf("prix" to "5000", "devise" to "FCFA", "nom_commerce" to "シャンタル食堂")
        val ja = GabaritBeatSheet.build(
            raw, valeurs,
            localiser = { donnees.resolve(it, "ja") },
            badgeTexte = donnees.badge("places_limitees", "ja")
        )!!
        val textes = mots(ja.beatSheetJson).map { it.getString(0) }
        assertTrue("prix non substitue", textes.any { it.contains("5000") && it.contains("FCFA") })
        assertFalse("texte francais residuel", textes.contains("À DÉCOUVRIR"))
        assertTrue("badge japonais absent", textes.any { it.contains("席数限定") })
        // Aucun texte ne doit rester sous forme de variable brute.
        assertTrue(
            "variables non substituees: ${textes.filter { it.contains('{') }}",
            textes.none { it.contains('{') && it.contains('}') }
        )
    }

    @Test
    fun leJaponaisEstSegmenteEnCartonsLisibles() {
        val raw = gabarit("restaurants_maquis_T1")
        val donnees = dictionnaire()
        val ja = GabaritBeatSheet.build(
            raw,
            mapOf("nom_commerce" to "シャンタル食堂", "nom_offre" to "本日の特別メニュー"),
            localiser = { donnees.resolve(it, "ja") }
        )!!
        val longs = mots(ja.beatSheetJson).map { it.getString(0) }
            .filter { it.none { c -> c == ' ' } }
            .filter { it.any { c -> c.code in 0x3040..0x9FFF } }
        assertTrue("aucun texte japonais", longs.isNotEmpty())
        assertTrue("segment trop long: ${longs.filter { it.length > 7 }}", longs.all { it.length <= 7 })
    }
}
