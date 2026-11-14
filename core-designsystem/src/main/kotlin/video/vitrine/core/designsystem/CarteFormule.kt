package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp

/**
 * D42.33 — Carte formule (§9.3 dashboard / écran Formules, note PDF §8) :
 * cartes de la grille tarifaire OFFICIELLE (Pass 24 h · Pro 30 j · Boutique).
 * Variante recommandée : fond navy + badge. Le montant est répété dans le
 * bouton (« Choisir Pro · 3 000 FCFA » — chaînes du dépôt). Le CTA reste
 * HONNÊTE : inactif tant que le paiement n'est pas branché (CinetPay
 * reporté) — aucun achat simulé.
 */
@Composable
fun CarteFormule(
    titre: String,
    prix: String,
    avantages: List<String>,
    libelleBouton: String,
    surChoix: () -> Unit,
    recommandee: Boolean = false,
    libelleBadge: String? = null,
    boutonActif: Boolean = false,
    testTag: String? = null,
    modifier: Modifier = Modifier
) {
    val forme = FormeCarte
    Column(
        modifier = modifier
            .fillMaxWidth()
            .let { m -> testTag?.let { m.testTag(it) } ?: m }
            .clip(forme)
            .background(if (recommandee) Navy else Blanc)
            .let { if (recommandee) it.haloSombre() else it.ombreSm(forme) }
            .padding(Dims.CartePadding)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                titre,
                style = VitrineText.H3,
                color = if (recommandee) Blanc else Navy,
                modifier = Modifier.weight(1f)
            )
            if (recommandee && libelleBadge != null) {
                BadgeVitrine(texte = libelleBadge, teinte = TeinteBadge.Sombre)
            }
        }
        Text(
            prix,
            style = VitrineText.Num,
            color = if (recommandee) Blanc else Navy,
            modifier = Modifier.padding(top = 4.dp)
        )
        AvantagesFormule(avantages = avantages, recommandee = recommandee)
        Spacer(Modifier.height(14.dp))
        BoutonFormule(
            libelleBouton = libelleBouton,
            surChoix = surChoix,
            recommandee = recommandee,
            boutonActif = boutonActif,
            testTag = testTag
        )
    }
}

/** Ligne d'avantages (chaînes du dépôt, grille tarifaire officielle). */
@Composable
private fun AvantagesFormule(avantages: List<String>, recommandee: Boolean) {
    Column(
        modifier = Modifier.padding(top = 10.dp),
        verticalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        avantages.forEach { avantage ->
            Row(verticalAlignment = Alignment.CenterVertically) {
                IconeVitrine(
                    icone = painterResource(R.drawable.ic_check),
                    taille = 16.dp,
                    teinte = VertSucces
                )
                Spacer(Modifier.width(8.dp))
                Text(
                    avantage,
                    style = VitrineText.Sub,
                    color = if (recommandee) Blanc80 else NavySoft
                )
            }
        }
    }
}

/** CTA de la formule — honnête : inactif tant que le paiement n'est pas branché. */
@Composable
private fun BoutonFormule(
    libelleBouton: String,
    surChoix: () -> Unit,
    recommandee: Boolean,
    boutonActif: Boolean,
    testTag: String?
) {
    if (recommandee) {
        BoutonPrimaire(
            libelle = libelleBouton,
            onClick = surChoix,
            enabled = boutonActif,
            testTag = testTag?.let { "$it-btn" }
        )
    } else {
        BoutonSecondaire(
            libelle = libelleBouton,
            onClick = surChoix,
            enabled = boutonActif,
            pleineLargeur = true,
            testTag = testTag?.let { "$it-btn" }
        )
    }
}
