package video.vitrine.feature.brief

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Checkbox
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusDirection
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.BleuVoile
import video.vitrine.core.designsystem.AmbreAlerte
import video.vitrine.core.designsystem.Blanc
import video.vitrine.core.designsystem.ChampFormulaire
import video.vitrine.core.designsystem.FormePill
import video.vitrine.core.designsystem.FormeTuile
import video.vitrine.core.designsystem.Line
import video.vitrine.core.designsystem.Muted
import video.vitrine.core.designsystem.Navy
import video.vitrine.core.designsystem.OrangeDeep
import video.vitrine.core.designsystem.GrisLiserai
import video.vitrine.core.designsystem.VertTexte
import video.vitrine.core.designsystem.OrangeStore
import video.vitrine.core.designsystem.OrangeVoile
import video.vitrine.core.model.BriefField
import video.vitrine.core.model.BriefSection
import video.vitrine.core.model.GabaritBrief
import video.vitrine.core.model.PriseGuide

/**
 * Ecran E5 (maquettes E5_*_Brief) : formulaire 100 % pilote par le gabarit JSON
 * (sections, champs, aides, devise), libelles deja tutoyes cote parseur.
 * Bandeau section = BleuVoile, options repliees = OrangeVoile (pixels maquette).
 */
@Composable
fun GabaritBriefScreen(
    brief: GabaritBrief,
    // D42.27 (§7) : pré-remplissage depuis le brouillon (reprise de saisie)
    // et callback à CHAQUE champ (persistance de la saisie en cours).
    initialValues: Map<String, String> = emptyMap(),
    onValuesChange: (Map<String, String>) -> Unit = {},
    // D42.34 (CR-2, P0 ④) : import de rushs existants — proposé UNIQUEMENT
    // pour les gabarits qui le demandent (T5 témoignage client). Liste non
    // vide = section affichée ; 1 prise = 1 média (contrat slots explicite,
    // jamais de concaténation aveugle côté moteur).
    prisesPourImport: List<PriseGuide> = emptyList(),
    rushSlots: List<String> = emptyList(),
    onImportRush: () -> Unit = {},
    onClearRush: (Int) -> Unit = {},
    onSubmit: (Map<String, String>) -> Unit
) {
    // Audit D40 (B10) : defauts du JSON pre-remplis (FCFA « deja choisi »),
    // choix de badge collectes, validations type/contrat appliquees.
    // D42.27 : les valeurs RESTAURÉES du brouillon priment sur les défauts.
    var values by remember {
        mutableStateOf(
            brief.fields
                .filter { it.defaultValue.isNotBlank() && it.defaultValue != "false" && it.defaultValue != "true" }
                .associate { it.id to it.defaultValue } + initialValues
        )
    }
    var checks by remember {
        mutableStateOf(
            brief.fields
                .associate { it.id to (it.defaultValue == "true") }
                .filterValues { it }
        )
    }
    var choiceByField by remember { mutableStateOf(emptyMap<String, String>()) }
    var optionsOpen by remember { mutableStateOf(false) }
    val requiredIds = brief.fields.filter { it.required }.map { it.id }
    val filled = requiredIds.count { (values[it] ?: "").isNotBlank() }
    val invalid = brief.fields.any { fieldError(it, values[it.id] ?: "") != null }
    // D42.30 (défaut terrain n°5 « boutons hors écran » + preuves p1/camerap
    // runs 5082856/67f6421) : bouton Continuer ÉPINGLÉ hors du scroll —
    // TOUJOURS visible sans défiler, au-dessus du clavier (imePadding) et de
    // la barre de navigation (navigationBarsPadding). Avant : bouton en fin
    // de scroll collé au bord de fenêtre, texte à 1 px de haut dans la zone
    // de gestes système → taps perdus. Le formulaire défile SOUS le bouton.
    Column(
        modifier = Modifier
            .fillMaxSize()
            .navigationBarsPadding()
            .imePadding()
    ) {
        Column(
            modifier = Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 20.dp)
                .padding(top = 8.dp, bottom = 12.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            BriefHeader(brief, filled, requiredIds.size)
            brief.sections.forEach { section ->
                BriefSectionBlock(
                    section = section,
                    brief = brief,
                    open = !section.optional || optionsOpen,
                    values = values,
                    checks = checks,
                    onToggle = { optionsOpen = !optionsOpen },
                    onValue = { id, v ->
                        values = values + (id to v)
                        // D42.27 (§7) : persistance de la saisie (étape BRIEF).
                        onValuesChange(values)
                    },
                    onCheck = { id, c -> checks = checks + (id to c) },
                    choice = { id -> choiceByField[id] },
                    onChoice = { id, c -> choiceByField = choiceByField + (id to c) }
                )
            }
            // D42.34 (CR-2) : section import rushs — uniquement si le gabarit
            // le demande (T5 témoignage : le client existe souvent déjà en
            // vidéo/photo). Facultatif : filmer au guide reste possible.
            if (prisesPourImport.isNotEmpty()) {
                SectionRushsImport(
                    prises = prisesPourImport,
                    slots = rushSlots,
                    onImport = onImportRush,
                    onClear = onClearRush,
                )
            }
        }
        val reponse = values + checks.mapValues { (id, checked) ->
            if (!checked) "false" else (choiceByField[id] ?: "true")
        }
        PiedContinuer(
            enabled = filled == requiredIds.size && !invalid,
            onContinue = { onSubmit(reponse) },
        )
    }
}

/** D42.30 : bouton Continuer ÉPINGLÉ (pied fixe hors scroll, cf. GabaritBriefScreen).
 *  D42.32 (Lot 10, design system §6) : aligné sur la barre d'action standard des
 *  écrans à étapes — Surface tonalElevation 3 + bouton plein 52 dp (écran dense
 *  de formulaire ; reste confortable police 130 %). Hauteur minimale PORTÉE PAR
 *  LE BOUTON, padding par le conteneur (leçon D42.13 : jamais heightIn après
 *  padding — le minimum s'appliquerait à la boîte paddée et écraserait le bouton). */
@Composable
private fun PiedContinuer(enabled: Boolean, onContinue: () -> Unit) {
    Surface(
        tonalElevation = 3.dp,
        color = MaterialTheme.colorScheme.surface
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 20.dp, vertical = 12.dp)
        ) {
            video.vitrine.core.designsystem.BoutonPrimaire(
                libelle = stringResource(R.string.brief_g_continue),
                onClick = onContinue,
                enabled = enabled,
                testTag = "brief_continue"
            )
        }
    }
}

/**
 * D42.34 (CR-2, P0 ④) : section « Vidéos du client » — une ligne par PRISE
 * du gabarit (contrat slots : 1 prise = 1 média, index aligné sur
 * decoupage_prises du moteur). Facultative et honnête : le marchand peut
 * tout filmer au guide caméra à la place.
 */
@Composable
private fun SectionRushsImport(
    prises: List<PriseGuide>,
    slots: List<String>,
    onImport: () -> Unit,
    onClear: (Int) -> Unit,
) {
    val remplis = slots.count { it.isNotBlank() }
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .background(BleuVoile, RoundedCornerShape(14.dp))
            .padding(14.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Text(
            stringResource(R.string.brief_import_titre),
            style = video.vitrine.core.designsystem.VitrineText.H3,
            color = Navy,
        )
        Text(
            stringResource(R.string.brief_import_note),
            style = video.vitrine.core.designsystem.VitrineText.Sub,
            color = Muted,
        )
        prises.forEachIndexed { index, prise ->
            LignePriseImport(
                numero = index + 1,
                libelle = prise.label,
                media = slots.getOrNull(index).orEmpty(),
                onChoose = onImport,
                onClear = { onClear(index) },
            )
        }
        if (remplis < prises.size) {
            video.vitrine.core.designsystem.BoutonSecondaire(
                libelle = stringResource(R.string.brief_import_choisir),
                onClick = onImport,
                testTag = "brief_import_choisir",
            )
        }
        Text(
            stringResource(R.string.brief_import_ou_filmer),
            style = video.vitrine.core.designsystem.VitrineText.Sub,
            color = Muted,
        )
    }
}

/** Une ligne de prise : « Prise N · libellé » + média choisi ou bouton local. */
@Composable
private fun LignePriseImport(
    numero: Int,
    libelle: String,
    media: String,
    onChoose: () -> Unit,
    onClear: () -> Unit,
) {
    Surface(
        color = Blanc,
        shape = RoundedCornerShape(10.dp),
        border = androidx.compose.foundation.BorderStroke(1.dp, Line),
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 12.dp, vertical = 8.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    stringResource(R.string.brief_import_prise, numero, libelle),
                    style = video.vitrine.core.designsystem.VitrineText.Sub,
                    color = Navy,
                )
                if (media.isNotBlank()) {
                    Text(
                        nomCourt(media),
                        style = video.vitrine.core.designsystem.VitrineText.Tiny,
                        color = VertTexte,
                    )
                }
            }
            if (media.isBlank()) {
                Text(
                    stringResource(R.string.brief_import_vide),
                    style = video.vitrine.core.designsystem.VitrineText.Tiny,
                    color = OrangeDeep,
                    modifier = Modifier
                        .clickable { onChoose() }
                        .padding(6.dp),
                )
            } else {
                Text(
                    stringResource(R.string.brief_import_retirer),
                    style = video.vitrine.core.designsystem.VitrineText.Tiny,
                    color = OrangeDeep,
                    modifier = Modifier
                        .clickable { onClear() }
                        .padding(6.dp),
                )
            }
        }
    }
}

/** Nom court honnête du média choisi (dernier segment de l'URI, borné). */
private fun nomCourt(uri: String): String {
    val brut = uri.substringAfterLast('/').ifBlank { uri }
    return if (brut.length > 28) brut.take(25) + "…" else brut
}

@Composable
private fun BriefHeader(brief: GabaritBrief, filled: Int, requiredCount: Int) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                stringResource(R.string.brief_g_my_video),
                style = video.vitrine.core.designsystem.VitrineText.H2,
                color = Navy
            )
            Text(
                brief.sectorLabel + " · " + brief.formatLabel,
                style = video.vitrine.core.designsystem.VitrineText.Sub,
                color = Muted
            )
        }
        Box(
            modifier = Modifier
                .background(BleuVoile, FormePill)
                .padding(horizontal = 12.dp, vertical = 6.dp)
        ) {
            Text(
                stringResource(R.string.brief_g_step_badge, 1, 4),
                color = Navy,
                style = video.vitrine.core.designsystem.VitrineText.Label
            )
        }
    }
    // D42.33 §7.8 : barre de progression du design system (4 dp, pill).
    video.vitrine.core.designsystem.BarreProgression(
        progression = if (requiredCount == 0) 0f else filled.toFloat() / requiredCount
    )
}

/**
 * Validation E5 (audit D40, B10) : regles lues dans le gabarit JSON —
 * type nombre = chiffres seuls ; validation format_international = +indicatif
 * puis >= 8 chiffres. Audit D41 (F68, P2) : retourne un id de RESSOURCE (traduit
 * FR/EN/ES/JA) au lieu du message francais en dur, ou null si conforme.
 */
internal fun fieldError(field: BriefField, value: String): Int? {
    if (value.isBlank()) return null
    if (field.type == "nombre" && !value.all { it.isDigit() || it.isWhitespace() }) {
        return R.string.brief_err_number
    }
    if (field.validation == "format_international" || field.type == "telephone") {
        // D42.30 : règles RÉELLES par pays (libphonenumber) — fin du « + puis
        // 8 chiffres » qui acceptait des numéros invalides et refusait des
        // numéros valides. La valeur est valide si elle est un E.164 complet.
        if (!TelephoneValidator.estValide(value)) {
            return R.string.brief_err_phone
        }
    }
    return null
}

@Composable
private fun BriefSectionBlock(
    section: BriefSection,
    brief: GabaritBrief,
    open: Boolean,
    values: Map<String, String>,
    checks: Map<String, Boolean>,
    onToggle: () -> Unit,
    onValue: (String, String) -> Unit,
    onCheck: (String, Boolean) -> Unit,
    choice: (String) -> String?,
    onChoice: (String, String) -> Unit
) {
    if (section.optional) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(OrangeVoile, FormeTuile)
        ) {
            TextButton(onClick = onToggle) {
                Text(
                    section.title,
                    color = OrangeDeep,
                    style = video.vitrine.core.designsystem.VitrineText.Label
                )
            }
        }
    } else {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(BleuVoile, FormeTuile)
                .padding(horizontal = 14.dp, vertical = 10.dp)
        ) {
            Text(
                section.title,
                color = Navy,
                style = video.vitrine.core.designsystem.VitrineText.Label
            )
        }
    }
    if (open) {
        section.fieldIds.forEach { id ->
            val field = brief.fields.firstOrNull { it.id == id } ?: return@forEach
            BriefFieldInput(field, values[id] ?: "", checks[id] == true, onValue, onCheck, choice(id), onChoice)
        }
    }
}

@Composable
private fun BriefFieldInput(
    field: BriefField,
    value: String,
    checked: Boolean,
    onValue: (String, String) -> Unit,
    onCheck: (String, Boolean) -> Unit,
    choice: String?,
    onChoice: (String, String) -> Unit
) {
    if (field.type == "case_a_cocher") {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Checkbox(checked = checked, onCheckedChange = { onCheck(field.id, it) })
            Column {
                Text(
                    field.label,
                    style = video.vitrine.core.designsystem.VitrineText.Body,
                    color = Navy
                )
                Text(
                    field.help,
                    style = video.vitrine.core.designsystem.VitrineText.Tiny,
                    color = Muted
                )
            }
        }
        // Audit D40 (B10) : les choix du badge (stock_limite, places_limitees,
        // qualite_garantie) sont enfin proposes — avant, seul un booleen etait
        // collecte et le moteur ne pouvait pas savoir QUEL message afficher.
        if (checked && field.choices.isNotEmpty()) {
            BadgeChoiceRow(field.choices, choice) { onChoice(field.id, it) }
        }
    } else {
        ChampStandardGabarit(field, value, onValue)
    }
}

/**
 * D42.33 (detekt LongMethod) : champ standard du brief, extrait de
 * BriefFieldInput — ChampFormulaire §7.9 pour les textes ; champs
 * spécialisés D42.30 (téléphone international / prix stable) inchangés.
 */
@Composable
private fun ChampStandardGabarit(
    field: BriefField,
    value: String,
    onValue: (String, String) -> Unit,
) {
    if (field.type == "telephone" || field.type == "nombre") {
        Text(
            field.label + if (field.required) " *" else "",
            style = video.vitrine.core.designsystem.VitrineText.Tiny.copy(
                fontWeight = androidx.compose.ui.text.font.FontWeight.W600
            ),
            color = Navy
        )
    }
    if (field.type == "telephone") {
        // D42.30 : WhatsApp international — sélecteur de pays recherchable,
        // saisie nationale, collage E.164, validation libphonenumber.
        TelephoneField(
            initialE164 = value,
            onValue = { onValue(field.id, it) }
        )
    } else if (field.type == "nombre") {
        // D42.30 (retour terrain : le prix « secouait » pendant la saisie) :
        // valeur BRUTE pendant l'édition (le curseur ne saute JAMAIS),
        // formatage visuel par groupes SEULEMENT à la sortie du champ,
        // suffixe FCFA, emplacement d'erreur RÉSERVÉ (plus de saut de layout).
        ChampPrix(
            valeur = value,
            exemple = field.example,
            enErreur = fieldError(field, value) != null,
            onValue = { onValue(field.id, it) }
        )
    } else {
        // D42.33 §7.9 : champ texte = ChampFormulaire du design system
        // (label au-dessus, filet focus, erreur/aide à hauteur réservée,
        // touche Suivant du clavier — comportement D42.32 Lot 8 conservé).
        val focusManager = LocalFocusManager.current
        val erreur = fieldError(field, value)?.let { stringResource(it) }
        ChampFormulaire(
            valeur = value,
            surChangement = { onValue(field.id, it) },
            label = field.label + if (field.required) " *" else "",
            aide = field.help,
            erreur = erreur,
            placeholder = field.example,
            multiligne = field.type == "texte_long",
            actionClavier = if (field.type == "texte_long") {
                androidx.compose.ui.text.input.ImeAction.Default
            } else {
                androidx.compose.ui.text.input.ImeAction.Next
            },
            surSuivant = { focusManager.moveFocus(FocusDirection.Down) },
            testTag = "brief_" + field.id
        )
        return
    }
    ZoneErreurEtAide(field, value)
}

/**
 * D42.30 : emplacement d'erreur RÉSERVÉ (hauteur fixe) — l'apparition ou la
 * disparition du message ne déplace PLUS aucun élément du formulaire. L'aide
 * du champ suit (masquée pour téléphone : aides contextuelles dédiées).
 */
@Composable
private fun ZoneErreurEtAide(field: BriefField, value: String) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            // D42.32 (Lot 8) : minimum réservé (pas de saut à taille normale),
            // mais la zone S'AGRANDIT si le message dépasse (police 130 %,
            // écran étroit) au lieu de rogner le texte d'erreur.
            .heightIn(min = 20.dp)
    ) {
        fieldError(field, value)?.let { erreur ->
            Text(
                stringResource(erreur),
                style = video.vitrine.core.designsystem.VitrineText.Tiny,
                color = AmbreAlerte
            )
        }
    }
    if (field.type != "telephone") {
        Text(
            field.help,
            style = video.vitrine.core.designsystem.VitrineText.Tiny,
            color = Muted
        )
    }
}


@Composable
private fun BadgeChoiceRow(choices: List<String>, choice: String?, onChoice: (String) -> Unit) {
    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
        choices.forEach { option ->
            val selected = choice == option
            TextButton(
                onClick = { onChoice(option) },
                modifier = Modifier.background(
                    if (selected) OrangeVoile else GrisLiserai,
                    FormePill
                )
            ) {
                Text(
                    choiceLabel(option),
                    color = if (selected) OrangeDeep else Navy,
                    style = video.vitrine.core.designsystem.VitrineText.Label
                )
            }
        }
    }
}

/** Libelle marchand des badges (JSON : codes techniques) — D41 (F68) :
 *  libelles traduits x4 ; un code inconnu reste affiche tel quel (honnête). */
@Composable
private fun choiceLabel(option: String): String = when (option) {
    "stock_limite" -> stringResource(R.string.brief_badge_stock_limite)
    "places_limitees" -> stringResource(R.string.brief_badge_places_limitees)
    "qualite_garantie" -> stringResource(R.string.brief_badge_qualite_garantie)
    else -> option
}


/**
 * D42.30 — champ PRIX stable (retour terrain RC14 : « le formulaire tremble
 * pendant la saisie »).
 * - pendant l'édition : valeur brute (chiffres) — AUCUN reformatage à la
 *   frappe, le curseur ne bouge jamais ;
 * - à la sortie du champ : affichage groupé (1 500) — visuel seulement, la
 *   valeur stockée reste la valeur brute ;
 * - suffixe FCFA (monnaie par défaut du marché) ;
 * - erreur à hauteur réservée par l'appelant (plus de saut de layout).
 */
@Composable
private fun ChampPrix(
    valeur: String,
    exemple: String,
    enErreur: Boolean,
    onValue: (String) -> Unit
) {
    var focusActif by remember { mutableStateOf(false) }
    val saisieIci = stringResource(R.string.brief_g_type_here)
    val affichage = if (focusActif) {
        valeur
    } else {
        valeur.filter { it.isDigit() }.reversed().chunked(3).joinToString(" ").reversed()
    }
    val focusManager = LocalFocusManager.current
    OutlinedTextField(
        value = affichage,
        onValueChange = { brut ->
            val chiffres = brut.filter { it.isDigit() }.take(9)
            onValue(chiffres)
        },
        placeholder = { Text(exemple.ifBlank { saisieIci }, color = Muted) },
        shape = FormeTuile,
        colors = androidx.compose.material3.OutlinedTextFieldDefaults.colors(
            focusedBorderColor = OrangeStore,
            unfocusedBorderColor = Line,
            focusedContainerColor = OrangeVoile,
            unfocusedContainerColor = Blanc,
            focusedTextColor = Navy,
            unfocusedTextColor = Navy,
            errorBorderColor = AmbreAlerte
        ),
        modifier = Modifier
            .fillMaxWidth()
            .onFocusChanged { focusActif = it.isFocused },
        singleLine = true,
        isError = enErreur,
        suffix = { Text("FCFA", style = MaterialTheme.typography.bodySmall) },
        keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
            keyboardType = androidx.compose.ui.text.input.KeyboardType.Number,
            // D42.32 (Lot 8) : « Suivant » pour passer au champ suivant.
            imeAction = ImeAction.Next
        ),
        keyboardActions = androidx.compose.foundation.text.KeyboardActions(
            onNext = { focusManager.moveFocus(FocusDirection.Down) }
        )
    )
}
