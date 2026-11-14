package video.vitrine.feature.brief

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
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
import video.vitrine.core.designsystem.BleuNuit
import video.vitrine.core.designsystem.BleuVoile
import video.vitrine.core.designsystem.GrisLiserai
import video.vitrine.core.designsystem.OrangeStore
import video.vitrine.core.designsystem.OrangeVoile
import video.vitrine.core.model.BriefField
import video.vitrine.core.model.BriefSection
import video.vitrine.core.model.GabaritBrief

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
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(10.dp)
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
                .padding(horizontal = 16.dp, vertical = 10.dp)
        ) {
            Button(
                onClick = onContinue,
                modifier = Modifier
                    .fillMaxWidth()
                    .heightIn(min = 52.dp),
                enabled = enabled
            ) { Text(stringResource(R.string.brief_g_continue)) }
        }
    }
}

@Composable
private fun BriefHeader(brief: GabaritBrief, filled: Int, requiredCount: Int) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column {
            Text(stringResource(R.string.brief_g_my_video), style = MaterialTheme.typography.headlineSmall)
            Text(
                brief.sectorLabel + " · " + brief.formatLabel,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
        Box(
            modifier = Modifier
                .background(BleuVoile, RoundedCornerShape(8.dp))
                .padding(horizontal = 12.dp, vertical = 6.dp)
        ) {
            Text(
                stringResource(R.string.brief_g_step_badge, 1, 4),
                color = BleuNuit,
                style = MaterialTheme.typography.titleSmall
            )
        }
    }
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .height(6.dp)
            .background(GrisLiserai, RoundedCornerShape(3.dp))
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth(if (requiredCount == 0) 0f else filled.toFloat() / requiredCount)
                .height(6.dp)
                .background(OrangeStore, RoundedCornerShape(3.dp))
        )
    }
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
                .background(OrangeVoile, RoundedCornerShape(8.dp))
        ) {
            TextButton(onClick = onToggle) {
                Text(section.title, color = OrangeStore, style = MaterialTheme.typography.titleSmall)
            }
        }
    } else {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(BleuVoile, RoundedCornerShape(8.dp))
                .padding(horizontal = 12.dp, vertical = 10.dp)
        ) {
            Text(section.title, color = BleuNuit, style = MaterialTheme.typography.titleSmall)
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
                Text(field.label, style = MaterialTheme.typography.titleSmall)
                Text(
                    field.help,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
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
        Text(field.label + if (field.required) " *" else "", style = MaterialTheme.typography.titleSmall, color = BleuNuit)
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
            ChampTexteSimple(
                field = field,
                value = value,
                enErreur = fieldError(field, value) != null,
                onValue = onValue,
            )
        }
        ZoneErreurEtAide(field, value)
    }
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
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.error
            )
        }
    }
    if (field.type != "telephone") {
        Text(
            field.help,
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}


/** Champ texte / texte_long standard (tout sauf téléphone et nombre). */
@Composable
private fun ChampTexteSimple(
    field: BriefField,
    value: String,
    enErreur: Boolean,
    onValue: (String, String) -> Unit,
) {
    val saisieIci = stringResource(R.string.brief_g_type_here)
    // D42.32 (Lot 8) : touche « Suivant » du clavier (Gboard) — avant, la
    // touche d'action était un retour ligne muet sur un champ singleLine.
    val focusManager = LocalFocusManager.current
    val uneLigne = field.type != "texte_long"
    OutlinedTextField(
        value = value,
        onValueChange = { onValue(field.id, it) },
        placeholder = { Text(field.example.ifBlank { saisieIci }) },
        modifier = Modifier.fillMaxWidth(),
        singleLine = uneLigne,
        isError = enErreur,
        keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
            keyboardType = androidx.compose.ui.text.input.KeyboardType.Text,
            imeAction = if (uneLigne) ImeAction.Next else ImeAction.Default
        ),
        keyboardActions = androidx.compose.foundation.text.KeyboardActions(
            onNext = { focusManager.moveFocus(FocusDirection.Down) }
        )
    )
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
                    RoundedCornerShape(8.dp)
                )
            ) {
                Text(
                    choiceLabel(option),
                    color = if (selected) OrangeStore else BleuNuit,
                    style = MaterialTheme.typography.labelMedium
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
        placeholder = { Text(exemple.ifBlank { saisieIci }) },
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
