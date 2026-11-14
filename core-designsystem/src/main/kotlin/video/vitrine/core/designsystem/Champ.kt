package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/**
 * D42.33 — §7.9 Champ de formulaire : hauteur 56, rayon 18, Blanc, filet
 * Line (focus : filet 2 dp OrangeStore + fond OrangeVoile). Label Tiny 600
 * navy AU-DESSUS, jamais en placeholder seul. Aide sous le champ en Tiny.
 * Erreur : filet AmbreAlerte + texte AmbreAlerte. Compteur « 124 / 280 » à
 * droite, ambre à 90 % de la limite. Multiligne : min 96 dp, croît.
 */
@Composable
fun ChampFormulaire(
    valeur: String,
    surChangement: (String) -> Unit,
    label: String,
    modifier: Modifier = Modifier,
    aide: String? = null,
    erreur: String? = null,
    placeholder: String? = null,
    multiligne: Boolean = false,
    compteurMax: Int? = null,
    typeClavier: KeyboardType = KeyboardType.Text,
    testTag: String? = null
) {
    var focus by remember { mutableStateOf(false) }
    Column(modifier = modifier.fillMaxWidth()) {
        Text(
            label,
            style = VitrineText.Tiny.copy(fontWeight = FontWeight.W600),
            color = Navy
        )
        SaisieChamp(
            valeur = valeur,
            surChangement = surChangement,
            surFocusChange = { f -> focus = f },
            erreur = erreur,
            placeholder = placeholder,
            multiligne = multiligne,
            typeClavier = typeClavier,
            testTag = testTag
        )
        MessagesChamp(erreur = erreur, aide = aide, valeur = valeur, compteurMax = compteurMax)
    }
}

/** Saisie (hauteur 56 ou multiligne 96+, filet focus/erreur §7.9). */
@Composable
private fun SaisieChamp(
    valeur: String,
    surChangement: (String) -> Unit,
    surFocusChange: (Boolean) -> Unit,
    erreur: String?,
    placeholder: String?,
    multiligne: Boolean,
    typeClavier: KeyboardType,
    testTag: String?
) {
    val forme = FormeTuile
    val actif = focus && erreur == null
    val couleurFilet = if (erreur != null) AmbreAlerte else if (actif) OrangeStore else Line
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(top = 6.dp)
            .let { m -> testTag?.let { m.testTag(it) } ?: m }
            .heightIn(min = if (multiligne) 96.dp else Dims.Champ)
            .clip(forme)
            .background(if (actif) OrangeVoile else Blanc)
            .border(if (actif) 2.dp else 1.dp, couleurFilet, forme)
            .padding(horizontal = 16.dp, vertical = 14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        BasicTextField(
            value = valeur,
            onValueChange = surChangement,
            textStyle = TextStyle(fontFamily = Inter, fontSize = 15.sp, color = Navy),
            cursorBrush = SolidColor(OrangeStore),
            singleLine = !multiligne,
            keyboardOptions = KeyboardOptions(keyboardType = typeClavier),
            modifier = Modifier
                .fillMaxWidth()
                .onFocusChanged { f -> surFocusChange(f.isFocused) },
            decorationBox = { champ ->
                if (valeur.isEmpty() && placeholder != null) {
                    Box(modifier = Modifier.fillMaxWidth()) {
                        Text(placeholder, style = VitrineText.Body, color = Muted)
                        champ()
                    }
                } else {
                    champ()
                }
            }
        )
    }
}

/** Aide/erreur + compteur « 124 / 280 » (ambre à 90 % de la limite, §7.9). */
@Composable
private fun MessagesChamp(erreur: String?, aide: String?, valeur: String, compteurMax: Int?) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(top = 6.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        val message = erreur ?: aide
        if (message != null) {
            Text(
                message,
                style = VitrineText.Tiny,
                color = if (erreur != null) AmbreAlerte else Muted,
                modifier = Modifier.weight(1f)
            )
        } else {
            Box(Modifier.weight(1f))
        }
        if (compteurMax != null) {
            Text(
                "${valeur.length} / $compteurMax",
                style = VitrineText.Tiny,
                color = if (valeur.length >= compteurMax * 9 / 10) AmbreAlerte else Muted
            )
        }
    }
}
