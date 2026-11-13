package video.vitrine.core.model

/**
 * Resume d'un gabarit universel V2.0 (30 gabarits = 6 secteurs x T1-T5,
 * source Drive content/gabarits_v2, JSON source inchanges). Modele pur,
 * sans dependance Android ; le parseur vit dans :data (org.json).
 */
data class GabaritSummary(
    val id: String,
    val secteur: String,
    val secteurLibelle: String,
    val format: String,
    val nomFormatAffiche: String,
    val dureeTotaleS: Int,
    val nombreScenes: Int,
    val nombrePrises: Int,
    val ratio: String,
    val phraseCourte: String,
    val promesse: String
)

/** Correspondance secteur gabarit JSON -> Sector enum existant (additif, zero breaking). */
fun sectorFromGabaritCode(code: String?): Sector? = when (code) {
    "batiment_travaux" -> Sector.BTP
    "coiffure_beaute" -> Sector.COIFFURE
    "immo_auto" -> Sector.IMMO_AUTO
    "restaurants_maquis" -> Sector.RESTAURATION
    "shops_small_business" -> Sector.COMMERCE
    "vetements_mode" -> Sector.MODE
    else -> null
}

/** Champ du formulaire brief E5 (source : champs_saisie du gabarit JSON). */
data class BriefField(
    val id: String,
    val label: String,
    val required: Boolean,
    val type: String,
    val help: String,
    val example: String,
    val group: String,
    // Audit D40 (B10) : le parseur jetait validation/defaut/choix du JSON —
    // WhatsApp « format_international » et prix « nombre » n'etaient jamais
    // verifies, FCFA jamais prerempli, le message du badge jamais choisi.
    val validation: String = "",
    val defaultValue: String = "",
    val choices: List<String> = emptyList(),
)

/** Section du formulaire brief E5 (source : formulaire_ui.sections_principales). */
data class BriefSection(
    val id: String,
    val title: String,
    val order: Int,
    val fieldIds: List<String>,
    val optional: Boolean
)

/** Formulaire brief E5 complet, pilote par le gabarit (maquette E5_*_Brief). */
data class GabaritBrief(
    val sectorLabel: String,
    val formatLabel: String,
    val fields: List<BriefField>,
    val sections: List<BriefSection>,
    val defaultCurrency: String
)

/**
 * Adaptation d'interface des libelles source (vouvoiement) vers le tutoiement
 * des maquettes V2.0 (recap_maquettes.md : textes visibles adaptes, JSON intacts).
 */
private val EXACT_INTERFACE_V2 = mapOf(
    "votre commerce et votre WhatsApp" to "Ton commerce et ton WhatsApp",
    "Ce que vous proposez" to "Ce que tu proposes",
    "Où vous trouver" to "Où te trouver",
    "votre numéro WhatsApp" to "Ton numéro whatsapp",
    // D42.32 (Lot 8) : « vous » PRONOM OBJET après un verbe — le remplacement
    // mécanique vous->tu produisait « les clients peuvent tu écrire ».
    // Forme correcte figée une fois pour toutes (aucune retouche du JSON source).
    "Choisissez votre pays, puis écrivez le numéro sur lequel les clients peuvent vous écrire."
        to "Choisis ton pays, puis écris le numéro sur lequel les clients peuvent t’écrire."
)

/**
 * D42.32 (Lot 8, RCA) : verbes que EZ_REGEX ne conjugue PAS correctement —
 * soit radical trop court (< 5 lettres : « pouvez » restait « pouvez » ->
 * « Tu pouvez laisser vide », défaut exact cité par l'audit fondateur ;
 * « avez » -> « tu avez préparé » ; « rangez » -> « tu rangez »), soit
 * conjugaison réelle en -s et non en -e (« choisissez » -> « choisis »,
 * pas « choisisse » ; « emballez » -> « emballes »).
 * Application par FRONTIÈRE DE MOT (jamais par sous-chaîne).
 */
private val VERB_EXCEPTIONS_V2 = mapOf(
    "Tenez" to "Tiens",
    "tenez" to "tiens",
    "Soyez" to "Sois",
    "soyez" to "sois",
    "Choisissez" to "Choisis",
    "choisissez" to "choisis",
    "Pouvez" to "Peux",
    "pouvez" to "peux",
    "Avez" to "As",
    "avez" to "as",
    "Rangez" to "Ranges",
    "rangez" to "ranges",
    "Emballez" to "Emballes",
    "emballez" to "emballes",
    "Écrivez" to "Écris",
    "écrivez" to "écris",
    // D42.32 (Lot 8) : impératifs pluriels restés en forme « vous » une fois
    // le reste de la phrase tutoyé (« Dites ce que tu as préparé »).
    "Dites" to "Dis",
    "dites" to "dis",
    "Faites" to "Fais",
    "faites" to "fais",
    // D42.32 (Lot 8) : indicatifs « tu » réguliers en -es (EZ_REGEX produit -e
    // ou ne matche pas) — « tu dresses le plat », « tu en parles ».
    "Proposez" to "Proposes",
    "proposez" to "proposes",
    "Dressez" to "Dresses",
    "dressez" to "dresses",
    "Parlez" to "Parles",
    "parlez" to "parles",
    // D42.32 (Lot 8) : impératifs à radical trop court pour EZ_REGEX
    // ( « Film+ez », « Gard+ez », « Pos+ez » ) — 80 occurrences réelles.
    "Filmez" to "Filme",
    "filmez" to "filme",
    "Gardez" to "Garde",
    "gardez" to "garde",
    "Posez" to "Pose",
    "posez" to "pose"
)

/** Verbes reguliers -ez -> -e (assez/chez/nez preserves par longueur de radical). */
private val EZ_REGEX = Regex("\\b([A-Za-z\u00C0-\u00FF]{4,}[bcdfghklmnprstv])ez\\b")

fun toInterfaceFrench(source: String): String {
    EXACT_INTERFACE_V2[source]?.let { return it }
    var seeded = source
    // D42.32 (Lot 8) : frontières de mot — « avez » ne touchera jamais « engravez ».
    VERB_EXCEPTIONS_V2.forEach { (k, v) ->
        seeded = Regex("\\b" + Regex.escape(k) + "\\b").replace(seeded, v)
    }
    seeded = seeded
        .replace("Ajoutez", "Ajoute")
        .replace("Changez", "Change")
    val replaced = EZ_REGEX.replace(seeded) { m -> m.groupValues[1] + "e" }
        // D42.32 (Lot 8) : « vous » PRONOM OBJET après un verbe pluriel
        // (« les gens peuvent vous joindre ») — « t’ » devant voyelle,
        // « te » devant consonne ; jamais « tu » (« peuvent tu joindre »).
        .replace(Regex("\\bpeuvent vous ([aeiouyàâéèêëîïôûh])")) { "peuvent t’" + it.groupValues[1] }
        .replace(Regex("\\bpeuvent vous ([bcdfgjklmnpqrstvwxz])")) { "peuvent te " + it.groupValues[1] }
        .replace("votre", "ton")
        .replace("Vos", "Tes")
        .replace("vos", "tes")
        .replace("Vous", "Tu")
        .replace("vous", "tu")
    return replaced.replaceFirstChar { it.uppercaseChar() }
}

/** Segment de guide parole d'une prise (source : segments_guide_parole du JSON). */
data class ParoleSegment(
    val scene: Int,
    val show: String,
    val tell: String,
    val example: String,
    val advisedS: Double
)

/** Une prise du guide tournage E6 (source : prises[] du gabarit JSON). */
data class PriseGuide(
    val id: String,
    val label: String,
    val targetS: Int,
    val cameraInstruction: String,
    val segments: List<ParoleSegment>
)
