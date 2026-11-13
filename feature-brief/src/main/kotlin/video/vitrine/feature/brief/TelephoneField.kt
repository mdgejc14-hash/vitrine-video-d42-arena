package video.vitrine.feature.brief

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.background
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.BleuNuit
import video.vitrine.core.designsystem.OrangeStore

/**
 * D42.30 — champ WhatsApp INTERNATIONAL (retour terrain RC14 : exemple
 * béninois 8 chiffres obsolète, validation naïve).
 *
 * Expérience :
 *  - sélecteur de pays RECHERCHABLE (Bénin proposé par défaut — marché
 *    initial — mais jamais imposé : +33, +1, tous les indicatifs acceptés) ;
 *  - saisie NATIONALE simple (pas de « + » à deviner) ;
 *  - COLLAGE direct d'un numéro international complet (+229 01…, +33 6…) :
 *    le pays et la forme nationale sont détectés automatiquement ;
 *  - aucun reformatage agressif pendant la frappe (le curseur ne saute pas,
 *    leçon du champ prix) — l'E.164 confirmé s'affiche SOUS le champ ;
 *  - validation libphonenumber (règles du pays choisi : BJ = 10 chiffres
 *    commençant par 01) — la valeur stockée est l'E.164 quand elle est valide.
 */
@Composable
fun TelephoneField(
    initialE164: String,
    onValue: (String) -> Unit,
    langue: String = "fr",
) {
    var pays by remember { mutableStateOf(TelephoneValidator.PAYS_DEFAUT) }
    var national by remember { mutableStateOf("") }
    var dialoguePays by remember { mutableStateOf(false) }
    var paysRecherche by remember { mutableStateOf("") }

    // Valeur initiale (défaut du gabarit ou brouillon) : E.164 → pays + forme
    // nationale ; texte brut → conservé tel quel dans le champ.
    LaunchedEffect(initialE164) {
        val v = initialE164.trim()
        if (v.startsWith("+")) {
            TelephoneValidator.depuisInternational(v)?.let { (region, forme) ->
                pays = region
                national = forme
            } ?: run { national = v }
        } else if (v.isNotBlank()) {
            national = v
        }
    }

    fun publier(texteNational: String, region: String) {
        national = texteNational
        // E.164 si complet et valide pour le pays choisi ; sinon on publie le
        // texte brut — la validation (fieldError) bloque Continuer.
        onValue(TelephoneValidator.versE164(texteNational, region) ?: texteNational)
    }

    Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
        LignePaysEtNumero(
            pays = pays,
            national = national,
            onOuvrirPays = { dialoguePays = true },
            onSaisie = { brut ->
                val propre = brut.replace(Regex("[-.()]"), " ").trim()
                // collage international complet : +229 01 97… → pays détecté
                if (propre.startsWith("+")) {
                    TelephoneValidator.depuisInternational(propre)?.let { (region, forme) ->
                        pays = region
                        publier(forme, region)
                        return@LignePaysEtNumero
                    }
                }
                publier(propre, pays)
            },
        )
        AidesTelephone(pays = pays, national = national)
    }

    if (dialoguePays) {
        DialogueChoixPays(
            recherche = paysRecherche,
            onRecherche = { paysRecherche = it },
            langue = langue,
            onChoix = { region ->
                pays = region
                dialoguePays = false
                publier(national, region)
            },
            onFermer = { dialoguePays = false },
        )
    }
}

/** Bouton pays (drapeau + indicatif) + champ de saisie nationale. */
@Composable
private fun LignePaysEtNumero(
    pays: String,
    national: String,
    onOuvrirPays: () -> Unit,
    onSaisie: (String) -> Unit,
) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        OutlinedButton(
            onClick = onOuvrirPays,
            modifier = Modifier.width(132.dp)
        ) {
            Text(
                TelephoneValidator.drapeau(pays) + " " + TelephoneValidator.indicatif(pays),
                style = MaterialTheme.typography.titleMedium
            )
        }
        val focusManager = androidx.compose.ui.platform.LocalFocusManager.current
        OutlinedTextField(
            value = national,
            onValueChange = onSaisie,
            modifier = Modifier.weight(1f),
            singleLine = true,
            placeholder = { Text(stringResource(R.string.brief_phone_placeholder)) },
            keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                keyboardType = KeyboardType.Phone,
                // D42.32 (Lot 8) : « Suivant » comme les autres champs du brief.
                imeAction = androidx.compose.ui.text.input.ImeAction.Next
            ),
            keyboardActions = androidx.compose.foundation.text.KeyboardActions(
                onNext = { focusManager.moveFocus(androidx.compose.ui.focus.FocusDirection.Down) }
            ),
            isError = national.isNotBlank() && !TelephoneValidator.estValide(
                TelephoneValidator.versE164(national, pays) ?: national
            )
        )
    }
}

/** Aide contextuelle : exemple VALIDE du pays + E.164 confirmé (ou consigne). */
@Composable
private fun AidesTelephone(pays: String, national: String) {
    // Exemple généré par libphonenumber — plus jamais d'exemple codé en dur.
    TelephoneValidator.exemplePays(pays)?.let { exemple ->
        Text(
            stringResource(R.string.brief_phone_example, exemple),
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
    // E.164 confirmé (format stocké, servi au montage et à la carte de fin)
    TelephoneValidator.versE164(national, pays)?.let { e164 ->
        Text(
            stringResource(R.string.brief_phone_saved, e164),
            style = MaterialTheme.typography.bodySmall,
            color = OrangeStore
        )
    } ?: Text(
        stringResource(R.string.brief_phone_national_hint),
        style = MaterialTheme.typography.bodySmall,
        color = MaterialTheme.colorScheme.onSurfaceVariant
    )
}

/** Dialog de sélection de pays : recherche par nom, indicatif ou code. */
@Composable
private fun DialogueChoixPays(
    recherche: String,
    langue: String,
    onRecherche: (String) -> Unit,
    onChoix: (String) -> Unit,
    onFermer: () -> Unit,
) {
    androidx.compose.ui.window.Dialog(onDismissRequest = onFermer) {
        Column(
            modifier = Modifier
                .background(MaterialTheme.colorScheme.surface, RoundedCornerShape(16.dp))
                .padding(14.dp)
        ) {
            Text(
                stringResource(R.string.brief_phone_pick_country),
                style = MaterialTheme.typography.titleMedium,
                color = BleuNuit,
                modifier = Modifier.padding(bottom = 8.dp)
            )
            OutlinedTextField(
                value = recherche,
                onValueChange = onRecherche,
                singleLine = true,
                placeholder = { Text(stringResource(R.string.brief_phone_search)) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 8.dp)
            )
            val liste = filtrerPays(recherche, langue)
            LazyColumn(modifier = Modifier.height(340.dp)) {
                items(liste) { region ->
                    LignePays(region, langue, onChoix)
                }
            }
        }
    }
}

/** Filtrage recherchable : nom (insensible à la casse), indicatif, code. */
private fun filtrerPays(recherche: String, langue: String): List<String> {
    val filtre = recherche.trim().lowercase()
    if (filtre.isBlank()) return TelephoneValidator.paysTriés(langue)
    return TelephoneValidator.paysTriés(langue).filter { region ->
        TelephoneValidator.nomPays(region, langue).lowercase().contains(filtre) ||
            TelephoneValidator.indicatif(region).contains(filtre) ||
            region.lowercase() == filtre
    }
}

/** Une ligne du sélecteur : drapeau, nom, indicatif. */
@Composable
private fun LignePays(region: String, langue: String, onChoix: (String) -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onChoix(region) }
            .padding(vertical = 10.dp, horizontal = 4.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            TelephoneValidator.drapeau(region),
            style = MaterialTheme.typography.titleMedium,
            modifier = Modifier.padding(end = 10.dp)
        )
        Text(
            TelephoneValidator.nomPays(region, langue),
            modifier = Modifier.weight(1f),
            style = MaterialTheme.typography.bodyLarge
        )
        Text(
            TelephoneValidator.indicatif(region),
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}
