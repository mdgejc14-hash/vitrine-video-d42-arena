package video.vitrine.feature.brief

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Checkbox
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
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
    Column(
        modifier = Modifier
            .fillMaxSize()
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
        Button(
            onClick = {
                onSubmit(
                    values + checks.mapValues { (id, checked) ->
                        if (!checked) "false" else (choiceByField[id] ?: "true")
                    }
                )
            },
            modifier = Modifier.fillMaxWidth(),
            enabled = filled == requiredIds.size && !invalid
        ) { Text(stringResource(R.string.brief_g_continue)) }
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
    if (field.validation == "format_international") {
        val cleaned = value.filter { !it.isWhitespace() }
        if (!cleaned.startsWith("+") || cleaned.count { it.isDigit() } < 8) {
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
        val saisieIci = stringResource(R.string.brief_g_type_here)
        OutlinedTextField(
            value = value,
            onValueChange = { onValue(field.id, it) },
            placeholder = { Text(field.example.ifBlank { saisieIci }) },
            modifier = Modifier.fillMaxWidth(),
            singleLine = field.type != "texte_long",
            isError = fieldError(field, value) != null,
            keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                keyboardType = when (field.type) {
                    "nombre" -> androidx.compose.ui.text.input.KeyboardType.Number
                    "telephone" -> androidx.compose.ui.text.input.KeyboardType.Phone
                    else -> androidx.compose.ui.text.input.KeyboardType.Text
                }
            )
        )
        fieldError(field, value)?.let { erreur ->
            Text(
                stringResource(erreur),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.error
            )
        }
        Text(
            field.help,
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
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
