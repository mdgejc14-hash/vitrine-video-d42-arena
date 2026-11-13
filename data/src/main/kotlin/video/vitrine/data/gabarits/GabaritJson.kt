package video.vitrine.data.gabarits

import org.json.JSONObject
import video.vitrine.core.model.BriefField
import video.vitrine.core.model.BriefSection
import video.vitrine.core.model.GabaritBrief
import video.vitrine.core.model.ParoleSegment
import video.vitrine.core.model.PriseGuide
import video.vitrine.core.model.GabaritSummary
import video.vitrine.core.model.toInterfaceFrench

/**
 * Parseur des 30 JSON gabarits V2.0 (org.json, natif Android, zero dependance
 * ajoutee au runtime). Lecture tolerante : seuls les champs du resume sont
 * extraits ; le JSON source integral reste conserve brut cote Room (rawJson).
 */
object GabaritJson {

    /** OptString non vide (repli FR documenté). */
    private fun JSONObject?.optStr(key: String): String? =
        this?.optString(key)?.takeIf { it.isNotBlank() }

    /**
     * Formulaire brief E5 (maquettes E5_*_Brief) : sections et champs lus depuis
     * formulaire_ui + champs_saisie, libelles adaptes tutoiement cote UI seulement.
     */
    fun parseBrief(raw: String, t: org.json.JSONObject? = null): GabaritBrief {
        val root = JSONObject(raw)
        val tChamps = t?.optJSONObject("champs")
        val tSections = t?.optJSONObject("sections")
        val fields = mutableListOf<BriefField>()
        root.optJSONArray("champs_saisie")?.let { arr ->
            for (i in 0 until arr.length()) {
                val c = arr.getJSONObject(i)
                val choix = mutableListOf<String>()
                c.optJSONArray("choix")?.let { arr ->
                    for (j in 0 until arr.length()) choix += arr.getString(j)
                }
                // D42.32 (Lot 4) : overlay EN par id de champ (stable).
                val tc = tChamps?.optJSONObject(c.getString("id"))
                fields += BriefField(
                    id = c.getString("id"),
                    label = tc?.optStr("label") ?: toInterfaceFrench(c.optString("label", c.getString("id"))),
                    required = c.optBoolean("obligatoire", false),
                    type = c.optString("type", "texte"),
                    help = tc?.optStr("aide") ?: toInterfaceFrench(c.optString("aide_simple", "")),
                    example = tc?.optStr("exemple") ?: c.optString("exemple", ""),
                    group = c.optString("groupe_ui", ""),
                    validation = c.optString("validation", ""),
                    defaultValue = c.opt("defaut")?.toString().orEmpty(),
                    choices = choix
                )
            }
        }
        val sections = mutableListOf<BriefSection>()
        val form = root.optJSONObject("formulaire_ui")
        form?.optJSONArray("sections_principales")?.let { arr ->
            for (i in 0 until arr.length()) {
                val sec = arr.getJSONObject(i)
                val ids = mutableListOf<String>()
                sec.optJSONArray("champs")?.let { f ->
                    for (j in 0 until f.length()) ids += f.getString(j)
                }
                sections += BriefSection(
                    id = sec.getString("id"),
                    title = tSections?.optStr(sec.getString("id"))
                        ?: toInterfaceFrench(sec.optString("titre", sec.getString("id"))),
                    order = sec.optInt("ordre", i + 1),
                    fieldIds = ids,
                    optional = false
                )
            }
        }
        form?.optJSONObject("options_facultatives_repliees")?.let { opt ->
            val ids = mutableListOf<String>()
            opt.optJSONArray("champs")?.let { f ->
                for (j in 0 until f.length()) ids += f.getString(j)
            }
            sections += BriefSection(
                id = opt.getString("id"),
                title = tSections?.optStr(opt.getString("id"))
                    ?: toInterfaceFrench(opt.optString("titre", "Options facultatives")),
                order = sections.size + 1,
                fieldIds = ids,
                optional = true
            )
        }
        return GabaritBrief(
            sectorLabel = t?.optStr("secteur_libelle")
                ?: root.optString("secteur_libelle", root.optString("secteur", "")),
            formatLabel = t?.optStr("nom_format") ?: root.optString("nom_format_affiche", ""),
            fields = fields,
            sections = sections.sortedBy { it.order },
            defaultCurrency = form?.optString("devise_defaut", "FCFA") ?: "FCFA"
        )
    }

    /** Prises du guide tournage E6 (maquettes E6_*_prise_*) : consignes + segments parole. */
    fun parsePrises(raw: String, t: org.json.JSONObject? = null): List<PriseGuide> {
        val root = JSONObject(raw)
        val tPrises = t?.optJSONObject("prises")
        val out = mutableListOf<PriseGuide>()
        root.optJSONArray("prises")?.let { arr ->
            for (i in 0 until arr.length()) {
                val p = arr.getJSONObject(i)
                // D42.32 (Lot 4) : overlay EN par id de prise + index de segment.
                val tp = tPrises?.optJSONObject(p.getString("id"))
                val tSegs = tp?.optJSONObject("segments")
                val segments = mutableListOf<ParoleSegment>()
                p.optJSONArray("segments_guide_parole")?.let { sa ->
                    for (j in 0 until sa.length()) {
                        val sg = sa.getJSONObject(j)
                        val ts = tSegs?.optJSONObject(j.toString())
                        segments += ParoleSegment(
                            scene = sg.optInt("scene", 0),
                            show = ts?.optStr("show") ?: toInterfaceFrench(sg.optString("quoi_montrer", "")),
                            tell = ts?.optStr("tell") ?: toInterfaceFrench(sg.optString("quoi_raconter", "")),
                            example = ts?.optStr("exemple") ?: sg.optString("exemple", ""),
                            advisedS = sg.optDouble("duree_conseillee_s", 0.0)
                        )
                    }
                }
                out += PriseGuide(
                    id = p.getString("id"),
                    label = tp?.optStr("libelle") ?: p.optString("libelle", p.getString("id")),
                    targetS = p.optInt("duree_cible_s", 0),
                    cameraInstruction = tp?.optStr("consigne") ?: toInterfaceFrench(p.optString("consigne_camera", "")),
                    segments = segments
                )
            }
        }
        return out
    }

    /** Cartes texte de l'apercu E7 (scenes[].texte_ecran), variables {x} remplacees. */
    fun parsePreviewTexts(raw: String, values: Map<String, String>): List<String> {
        val scenes = JSONObject(raw).optJSONArray("scenes") ?: return emptyList()
        val out = mutableListOf<String>()
        for (i in 0 until minOf(3, scenes.length())) {
            val contenu = scenes.getJSONObject(i)
                .optJSONObject("texte_ecran")?.optString("contenu", "").orEmpty()
            if (contenu.isNotBlank()) out += substituteVars(contenu, values)
        }
        return out
    }

    private fun substituteVars(text: String, values: Map<String, String>): String =
        Regex("\\{(\\w+)\\}").replace(text) { m -> values[m.groupValues[1]].orEmpty() }

    /** Lignes de verification E7 : id champ -> libelle tutoye (cases exclues). */
    fun parseCheckRows(raw: String, t: org.json.JSONObject? = null): List<Pair<String, String>> {
        val arr = JSONObject(raw).optJSONArray("champs_saisie") ?: return emptyList()
        val tChamps = t?.optJSONObject("champs")
        val out = mutableListOf<Pair<String, String>>()
        for (i in 0 until arr.length()) {
            val c = arr.getJSONObject(i)
            if (c.optString("type") == "case_a_cocher") continue
            val label = c.optString("label", c.optString("libelle", c.getString("id")))
            out += c.getString("id") to (
                tChamps?.optJSONObject(c.getString("id"))?.optStr("label")
                    ?: toInterfaceFrench(label)
                )
        }
        return out
    }

    fun parse(raw: String, t: org.json.JSONObject? = null): GabaritSummary {
        val root = JSONObject(raw)
        val interfaceCommercant = root.optJSONObject("interface_commercant")
        // D42.32 (Lot 4) : overlay EN (clés stables) sinon FR canonique.
        return GabaritSummary(
            id = root.getString("id"),
            secteur = root.getString("secteur"),
            secteurLibelle = t?.optStr("secteur_libelle")
                ?: root.optString("secteur_libelle", root.getString("secteur")),
            format = root.optString("format", ""),
            nomFormatAffiche = t?.optStr("nom_format") ?: root.optString("nom_format_affiche", ""),
            dureeTotaleS = root.optInt("duree_totale_secondes", 0),
            nombreScenes = root.optInt("nombre_scenes", 0),
            nombrePrises = root.optJSONArray("prises")?.length() ?: 0,
            ratio = root.optString("ratio", "9:16"),
            phraseCourte = t?.optStr("phrase_courte")
                ?: interfaceCommercant?.optString("phrase_courte", "").orEmpty(),
            promesse = interfaceCommercant?.optString("promesse", "").orEmpty()
        )
    }
}
