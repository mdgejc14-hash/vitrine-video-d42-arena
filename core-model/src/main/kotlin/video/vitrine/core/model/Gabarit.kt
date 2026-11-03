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
    "votre numéro WhatsApp" to "Ton numéro whatsapp"
)

private val VERB_EXCEPTIONS_V2 = mapOf(
    "Tenez" to "Tiens",
    "tenez" to "tiens",
    "Soyez" to "Sois",
    "soyez" to "sois"
)

/** Verbes reguliers -ez -> -e (assez/chez/nez preserves par longueur de radical). */
private val EZ_REGEX = Regex("\\b([A-Za-z\u00C0-\u00FF]{4,}[bcdfghklmnprstv])ez\\b")

fun toInterfaceFrench(source: String): String {
    EXACT_INTERFACE_V2[source]?.let { return it }
    var seeded = source
    VERB_EXCEPTIONS_V2.forEach { (k, v) -> seeded = seeded.replace(k, v) }
    seeded = seeded
        .replace("Écrivez", "Écris")
        .replace("Ajoutez", "Ajoute")
        .replace("Changez", "Change")
    val replaced = EZ_REGEX.replace(seeded) { m -> m.groupValues[1] + "e" }
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
