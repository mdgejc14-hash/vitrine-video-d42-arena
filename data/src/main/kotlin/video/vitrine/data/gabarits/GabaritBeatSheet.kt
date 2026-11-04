package video.vitrine.data.gabarits

import org.json.JSONArray
import org.json.JSONObject
import kotlin.math.ceil

/**
 * TRADUCTEUR gabarit V2.0 -> beat sheet du moteur (audit D40, reconnectage A5/A6).
 *
 * Avant ce fichier, les 30 gabarits JSON (scenes, courbe_rythme, transitions,
 * effets, decoupage_prises, cartes generees, audio.sfx_scenes, audio.musique)
 * n'etaient JAMAIS transmis au moteur : l'export retombait sur un beat sheet
 * generique de script. Ici, la structure de montage du gabarit devient le
 * beat sheet MotionJson du pipeline (schema identique a MotionJson.parse) :
 *
 *  - scenes -> plans : chaque scene est subdivisee en plans <= 1,5 s
 *    (protocole de montage D23 ; moyenne <= 1,5 s et max <= 3 s = portes
 *    WordClock.validate respectees par construction) ;
 *  - decoupage_prises -> rushIndex (prise_N -> N-1) ; les entrees carte:
 *    deviennent des plans kind="card" (image du rush precedent + texte plein
 *    cadre : signature, prix geant, WhatsApp finale) ;
 *  - texte_ecran -> words (variables {champ} substituees depuis le brief) ;
 *    mots contenant des chiffres = keywords (surlignes couleur store) ;
 *  - transitions/effets du gabarit -> vocabulaire moteur (matrice assumee :
 *    swipe_gauche/split_screen_glissant/wipe_rideau_vertical -> swipe ;
 *    fondu_enchaine/zoom_through/cut_sec -> cut ; recadrage_macro_160 ->
 *    zoom 1,6 ; punch_in_progressif -> 1,0..1,25 ; ralenti_* -> shake 0,35 +
 *    zoom leger (le ralentissement temporel desynchroniserait la timeline —
 *    ecart documente) ; freeze_* -> zoom statique (approximation documentee)) ;
 *  - audio.sfx_scenes -> marqueurs SFX (µs, categorie) pour BgmSfxAudioMixer ;
 *  - audio.musique.categorie_audio -> piste BGM (BgmStore/Worker).
 *
 * Pur (org.json, aucune dependance Android) : teste JVM sur les fixtures des
 * gabarits reels. Echec de parsing -> null (l'appelant retombe sur le beat
 * sheet de script historique : jamais de blocage).
 */
object GabaritBeatSheet {

    /** Repere SFX : instant composition (microsecondes) + categorie maître. */
    data class SfxEvent(val atUs: Long, val categorie: String)

    data class Document(
        val beatSheetJson: String,
        val sfxEvents: List<SfxEvent>,
        val sfxEventsJson: String,
        val bgmCategorie: String?,
        val duckingDb: Double,
        val totalDurationS: Double
    )

    private const val PLAN_TARGET_S = 1.5

    fun build(
        rawGabaritJson: String,
        values: Map<String, String>,
        rushDurationsS: List<Double>? = null,
        // D42 : couche i18n (contenus commerciaux) + badge E5. Valeurs par
        // defaut = comportement historique exact (aucune traduction, aucun
        // badge) : les appelants existants et les tests JVM ne changent pas.
        localiser: (String) -> String = { it },
        badgeTexte: String? = null
    ): Document? = runCatching {
        val root = JSONObject(rawGabaritJson)
        val scenes = root.optJSONArray("scenes") ?: return null
        if (scenes.length() == 0) return null
        val axes = root.optJSONObject("axes_signature") ?: JSONObject()
        val decoupage = axes.optJSONArray("decoupage_prises")
        val audio = root.optJSONObject("audio")

        val starts = DoubleArray(scenes.length())
        var cursor = 0.0
        for (i in 0 until scenes.length()) {
            starts[i] = cursor
            cursor += scenes.getJSONObject(i).optDouble("duree_secondes", 0.0)
        }
        if (cursor <= 0.0) return null

        val builder = SheetBuilder(values, rushDurationsS, localiser, badgeTexte, ciblesBadge(root))
        for (i in 0 until scenes.length()) {
            builder.addScene(i, scenes.getJSONObject(i), starts[i], decoupage?.optString(i).orEmpty())
        }
        if (builder.plans.length() == 0) return null

        val sheet = JSONObject()
            .put("plans", builder.plans)
            .put("words", builder.words)
            .put("keywords", JSONArray(builder.keywords.toList()))

        val sfx = sfxEvents(scenes, starts, audio)
        val sfxJson = JSONArray()
        sfx.forEach { e ->
            sfxJson.put(JSONObject().put("at_us", e.atUs).put("categorie", e.categorie))
        }

        Document(
            beatSheetJson = sheet.toString(),
            sfxEvents = sfx,
            sfxEventsJson = sfxJson.toString(),
            bgmCategorie = bgmCategorie(root, audio),
            duckingDb = audio?.optJSONObject("mix")?.optDouble("ducking_musique_sous_voix_db", -14.0) ?: -14.0,
            totalDurationS = cursor
        )
    }.getOrNull()

    /** Construction plan par plan (extrait de build pour detekt LongMethod). */
    private class SheetBuilder(
        private val values: Map<String, String>,
        private val rushDurationsS: List<Double>?,
        private val localiser: (String) -> String = { it },
        private val badgeTexte: String? = null,
        private val scenesBadge: Set<Int> = emptySet()
    ) {
        val plans = JSONArray()
        val words = JSONArray()
        val keywords = mutableSetOf<String>()
        private val consumedByRush = mutableMapOf<Int, Double>()
        private var lastClipRush = 0

        init {
            values.forEach { (_, v) -> if (v.any(Char::isDigit)) keywords += v.trim() }
        }

        fun addScene(index: Int, scene: JSONObject, start: Double, entree: String) {
            val duree = scene.optDouble("duree_secondes", 0.0)
            if (duree <= 0.0) return
            // D42 (F69) : le badge E5 occupe le DEBUT de sa scene ; le texte de
            // la scene est decale apres lui. Sans ce decalage, deux overlays
            // partageraient le meme ancrage (BASE_NDC_Y) et se recouvriraient —
            // l'exigence « aucun chevauchement prix/titre » serait violee.
            val numero = scene.optInt("numero", index + 1)
            val avecBadge = badgeTexte != null && scenesBadge.contains(numero)
            val finBadge = if (avecBadge) start + minOf(BADGE_DUREE_S, duree * BADGE_FRACTION) else start
            val isCard = entree.startsWith("carte:")
            val rushIndex = if (isCard) {
                lastClipRush
            } else {
                val prise = entree.removePrefix("prise_").toIntOrNull()
                ((prise?.minus(1)) ?: index).coerceAtLeast(0).also { lastClipRush = it }
            }
            val inT = inPointFor(rushIndex, duree, isCard)
            val z = zoomFor(scene.optString("effet"), entree)
            val tr = transitionFor(scene.optString("transition_sortie"))
            val shake = if (scene.optString("effet").startsWith("ralenti")) 0.35 else 0.0

            val subdivisions = ceil(duree / PLAN_TARGET_S).toInt().coerceAtLeast(1)
            val pas = duree / subdivisions
            var t = start
            for (s in 0 until subdivisions) {
                val t1 = if (s == subdivisions - 1) start + duree else t + pas
                plans.put(
                    JSONObject()
                        .put("t0", round3(t))
                        .put("t1", round3(t1))
                        .put("kind", if (isCard) "card" else "clip")
                        .put("in_t", round3(inT + s * pas))
                        .put("fx", 0.5)
                        .put("fy", 0.5)
                        .put("z", JSONArray().put(z.first).put(z.second))
                        .put("tr", tr)
                        .put("shake", shake)
                        .put("rid", rushIndex)
                )
                t = t1
            }
            addSceneText(scene, start, duree, finBadge)
            if (avecBadge && badgeTexte != null) {
                val debutBadge = start + BADGE_DELAI_S
                val fin = finBadge.coerceAtLeast(debutBadge + 0.4)
                words.put(JSONArray().put(badgeTexte).put(round3(debutBadge)).put(round3(fin)))
            }
        }

        private fun addSceneText(
            scene: JSONObject,
            start: Double,
            duree: Double,
            debutImpose: Double = start
        ) {
            val texte = scene.optJSONObject("texte_ecran") ?: return
            val contenu = texte.optString("contenu").orEmpty()
            if (contenu.isBlank()) return
            // D42 : traduction d'abord (la cle du dictionnaire est le texte
            // canonique, variables incluses), substitution ensuite.
            val substitue = substitute(localiser(contenu), values)
            // D42.6 : apres substitution, un texte qui ne contient plus ni lettre
            // ni chiffre n'est PLUS DESSINE. Mesure sur les 120 rendus : la scene
            // « -{pourcentage}% » des six gabarits T4 s'affichait « -% » quand le
            // commercant ne saisit pas d'ancien prix (aucune reduction a calculer).
            if (substitue.none { it.isLetterOrDigit() }) return
            val apparition = texte.optDouble("apparition_s", 0.0).coerceIn(0.0, duree)
            val disparition = texte.optDouble("disparition_s", duree).coerceIn(apparition, duree)
            val debut = (start + apparition).coerceAtLeast(debutImpose)
            val fin = start + disparition
            if (debut >= fin) return
            // D42 (CJK) : le japonais n'a pas d'espaces. Un texte sans espace est
            // decoupe en segments courts, sinon KineticTypography le retrecirait
            // jusqu'a devenir illisible pour le faire tenir sur une ligne.
            val segments = segmenter(substitue)
            if (segments.isEmpty()) return
            val tranche = (fin - debut) / segments.size
            segments.forEachIndexed { i, segment ->
                val d = debut + i * tranche
                words.put(JSONArray().put(segment).put(round3(d)).put(round3(d + tranche)))
            }
            substitue.split(Regex("\\s+")).forEach { mot ->
                if (mot.any(Char::isDigit)) keywords += mot
            }
        }

        /**
         * Segmentation d'affichage. D42.4 : la logique vit dans
         * [TexteCommerce.segmenter] (proprietes Unicode, aucun reecriture du
         * texte source). Les langues a espaces restent d'un bloc ; une chaine
         * SANS espace n'est coupee que sur une position typographique valide.
         */
        private fun segmenter(texte: String): List<String> = TexteCommerce.segmenter(texte)

        /** Point d'entree : consommation sequentielle du rush avec repli cyclique
         *  (jamais de debord de clipping) ; sans durees connues -> 0.0 (historique). */
        private fun inPointFor(rushIndex: Int, planDurationS: Double, isCard: Boolean): Double {
            val dureeRush = rushDurationsS?.getOrNull(rushIndex) ?: 0.0
            val deja = consumedByRush[rushIndex] ?: 0.0
            if (!isCard) consumedByRush[rushIndex] = deja + planDurationS
            if (dureeRush <= 0.0) return if (isCard) 0.0 else deja
            if (isCard) return (dureeRush - planDurationS).coerceAtLeast(0.0)   // fin de rush = carte
            val fenetre = (dureeRush - planDurationS).coerceAtLeast(0.5)
            return deja % fenetre
        }
    }

    /** Champ de saisie du badge E5 et scenes qu'il declare dans le gabarit. */
    private const val CHAMP_BADGE = "badge_engagement_actif"

    /**
     * Scenes (1-based) declarees par l'element de `champs_saisie` dont l'id
     * vaut badge_engagement_actif, champ scenes.
     * Valeurs observees sur les 30 gabarits : T1->15, T2->13, T3->14, T4->17, T5->1
     * (identiques sur les 6 secteurs) — d'ou F69 : le badge n'etait jamais rendu.
     */
    private fun ciblesBadge(root: JSONObject): Set<Int> {
        val champs = root.optJSONArray("champs_saisie") ?: return emptySet()
        for (i in 0 until champs.length()) {
            val champ = champs.optJSONObject(i) ?: continue
            if (champ.optString("id") != CHAMP_BADGE) continue
            val scenes = champ.optJSONArray("scenes") ?: return emptySet()
            return (0 until scenes.length())
                .map { scenes.optInt(it) }
                .filter { it > 0 }
                .toSet()
        }
        return emptySet()
    }

    /** Fenetre du badge : debut de scene, duree bornee pour laisser le texte respirer. */
    private const val BADGE_DUREE_S = 1.8
    private const val BADGE_FRACTION = 0.45
    private const val BADGE_DELAI_S = 0.15

    /** Longueur maximale d'un segment sans espaces (japonais). */

    /** Repere SFX : audio.sfx_scenes (source indexee, cf. SceneIndexCoverageTest),
     *  repli scenes[].sfx. Instant = debut de la scene concernee. */
    private fun sfxEvents(scenes: JSONArray, starts: DoubleArray, audio: JSONObject?): List<SfxEvent> {
        val out = mutableListOf<SfxEvent>()
        val declares = audio?.optJSONArray("sfx_scenes")
        if (declares != null && declares.length() > 0) {
            for (i in 0 until declares.length()) {
                val e = declares.optJSONObject(i) ?: continue
                val numero = e.optInt("scene", 0)
                val categorie = e.optString("categorie")
                if (numero in 1..scenes.length() && categorie.isNotBlank()) {
                    out += SfxEvent((starts[numero - 1] * 1_000_000).toLong(), categorie)
                }
            }
            return out
        }
        for (i in 0 until scenes.length()) {
            val categorie = scenes.getJSONObject(i).optString("sfx")
            if (categorie.isNotBlank()) {
                out += SfxEvent((starts[i] * 1_000_000).toLong(), categorie)
            }
        }
        return out
    }

    private fun bgmCategorie(root: JSONObject, audio: JSONObject?): String? {
        audio?.optJSONObject("musique")?.optString("categorie_audio")?.takeIf { it.isNotBlank() }
            ?.let { return it }
        val secteur = root.optString("secteur").takeIf { it.isNotBlank() } ?: return null
        val t = root.optString("format").substringBefore("_").takeIf { it.isNotBlank() } ?: return null
        return "musique_${t.lowercase()}_$secteur"
    }

    /** Matrice effets gabarit -> zoom moteur (zStart, zEnd). */
    private fun zoomFor(effet: String, decoupage: String): Pair<Double, Double> = when {
        decoupage.startsWith("carte:") -> 1.0 to 1.0
        effet == "recadrage_macro_160" -> 1.6 to 1.6
        effet == "punch_in_progressif" -> 1.0 to 1.25
        effet.startsWith("ralenti") -> 1.05 to 1.12
        effet.startsWith("freeze") -> 1.02 to 1.02
        else -> 1.0 to 1.03
    }

    /** Matrice transitions gabarit -> vocabulaire moteur (cut/swipe/flash/glitch). */
    private fun transitionFor(transition: String): String = when (transition) {
        "swipe_gauche", "split_screen_glissant", "wipe_rideau_vertical" -> "swipe"
        else -> "cut"
    }

    /**
     * Substitution des variables du brief.
     *
     * D42.3 : `{prix}` etait substitue BRUT, si bien qu'un prix saisi « 25000 »
     * s'affichait « 25000 FCFA » dans le MP4. Un commercant lit « 25 000 FCFA ».
     * Le groupement reprend exactement la regle du paywall (espace simple
     * U+0020, cf. PaywallMapper.groupThousands) : une seule convention dans
     * toute l'application.
     */
    private fun substitute(text: String, values: Map<String, String>): String {
        // D42.6 : `{pourcentage}` etait declare dans `variables_calculees` mais
        // jamais calcule -> le MP4 affichait « -% » (6 gabarits T4, scene 6/7).
        val calculees = mutableMapOf<String, String>()
        TexteCommerce.pourcentageReduction(values["ancien_prix"], values["prix"])
            ?.let { calculees["pourcentage"] = it.toString() }
        return Regex("\\{(\\w+)\\}").replace(text) { m ->
            val cle = m.groupValues[1]
            val valeur = calculees[cle] ?: values[cle].orEmpty()
            if (cle == "prix") grouperMilliers(valeur) else valeur
        }
    }

    /** « 25000 » -> « 25 000 » ; toute autre valeur est rendue telle quelle.
     *  D42.4 : implementation unique dans [TexteCommerce] (testee a part,
     *  sans dependance Android). */
    private fun grouperMilliers(valeur: String): String = TexteCommerce.grouperMilliers(valeur)

    private fun round3(v: Double): Double = Math.round(v * 1000.0) / 1000.0
}
