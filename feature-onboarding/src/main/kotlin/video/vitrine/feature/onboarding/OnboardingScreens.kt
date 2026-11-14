package video.vitrine.feature.onboarding

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.border
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.unit.sp
import video.vitrine.core.designsystem.BlancPur
import video.vitrine.core.designsystem.OrangeHi
import video.vitrine.core.designsystem.OrangeStore
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Surface
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.foundation.Image
import androidx.compose.ui.Alignment
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.ui.res.painterResource
import video.vitrine.core.designsystem.BleuNuit
import video.vitrine.core.designsystem.OrangeVoile
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.SectorCard3D
import video.vitrine.core.designsystem.VitrineTheme
import video.vitrine.core.designsystem.VitrineLogoHeader
import video.vitrine.core.designsystem.sectorIcon
import video.vitrine.core.designsystem.sectorIllustration
import video.vitrine.core.designsystem.sectorLabel
import video.vitrine.core.model.Sector

/**
 * Ecran secteurs : libelles terre-a-terre, un choix pre-selectionne, jamais bloquant.
 *
 * D42.12 — DEFAUT P1 CORRIGE : « bouton Continuer invisible ».
 *
 * Mesure du defaut : chaque carte contient une illustration carree
 * (`aspectRatio(1f)`) ; sur un ecran de 360 dp de large, une carte mesure ~188 dp.
 * Trois rangees + en-tete + titres + bouton = ~800 dp de contenu. Or la colonne
 * n'avait NI hauteur contrainte NI defilement : sur un telephone de ~600 dp
 * utiles (courant en Afrique de l'Ouest), le bouton etait rendu SOUS la zone
 * visible et devenait inatteignable — l'ecran etait une impasse.
 *
 * Correction (patron Android standard « action bar fixe ») :
 *  - la grille defile dans une zone `weight(1f)` + `verticalScroll` ;
 *  - le bouton est EPINGLE hors de la zone de defilement : il est visible en
 *    permanence, quelle que soit la taille d'ecran et la taille de police ;
 *  - insets systeme respectes (barre de navigation gestuelle incluse).
 *
 * Theorie Nielsen : #1 visibilite de l'etat (etape « 1 / 3 »), #4 coherence
 * (meme barre d'action partout), #5 prevention d'erreur (choix pre-selectionne,
 * aucun etat vide possible), #7 efficacite (pas besoin de defiler pour agir).
 */
@Composable
fun OnboardingScreen(onDone: (Sector) -> Unit) {
    // D42.12 : rememberSaveable — un changement de configuration ne perd plus
    // la selection. (Sector est un enum : Serializable, donc stockable.)
    var selected by rememberSaveable { mutableStateOf(Sector.MODE) }
    val secteurs = Sector.entries.filter { it != Sector.TOUS }
    Column(
        modifier = Modifier
            .fillMaxSize()
            .windowInsetsPadding(WindowInsets.safeDrawing)
    ) {
        // ---- zone defilante : elle ne peut jamais pousser le bouton dehors ----
        Column(
            modifier = Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp)
                .padding(top = 8.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // D42.13 : VitrineLogoHeader impose fillMaxWidth() : il écrasait
                // le badge « 1 / 3 » qui s'affichait à la verticale, coupé au bord
                // droit (constaté sur émulateur, run 42179104681). weight(1f) rend
                // au badge sa place.
                VitrineLogoHeader(modifier = Modifier.weight(1f))
                EtapeBadge(etape = 1, total = 3)
            }
            Text(
                stringResource(R.string.sector_title),
                style = video.vitrine.core.designsystem.VitrineText.H2,
                color = BleuNuit
            )
            Text(
                stringResource(R.string.sector_hint),
                style = video.vitrine.core.designsystem.VitrineText.Sub,
                color = video.vitrine.core.designsystem.Muted
            )
            secteurs.chunked(2).forEach { ligne ->
                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    ligne.forEach { secteur ->
                        SectorCard3D(
                            label = sectorLabel(secteur),
                            icon = sectorIcon(secteur.code),
                            selected = selected == secteur,
                            onClick = { selected = secteur },
                            illustrationRes = sectorIllustration(secteur.code),
                            modifier = Modifier.weight(1f)
                        )
                    }
                    // garde la derniere carte a la largeur des autres (ligne impaire)
                    if (ligne.size == 1) Box(modifier = Modifier.weight(1f))
                }
            }
            // marge de respiration : le dernier rang ne colle pas a la barre d'action
            Box(modifier = Modifier.padding(bottom = 4.dp))
        }

        // ---- barre d'action EPINGLEE : toujours visible ----
        //
        // D42.13 — deuxieme defaut mesure SUR EMULATEUR : le bouton etait ecrase
        // a 6 px de haut. Cause : `padding(...).heightIn(min = 48.dp)` inverse
        // l'ordre des contraintes — le minimum s'appliquait a la boite PADDEE,
        // donc le bouton lui-meme recevait 48 - 26 = 22 dp, et la barre se
        // reduisait a la hauteur de ce contenu tronque (68 px sur 2072).
        // Correctif : padding porte par un conteneur, hauteur minimale portee
        // DIRECTEMENT par le bouton, et 56 dp (au-dela des 48 dp WCAG) pour
        // rester confortable avec une police a 130 %.
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
                    libelle = stringResource(R.string.action_continue),
                    onClick = { onDone(selected) },
                    testTag = "sector_continue"
                )
            }
        }
    }
}

/** Indicateur de progression : le client sait ou il en est (Nielsen #1). */
@Composable
private fun EtapeBadge(etape: Int, total: Int) {
    Box(
        modifier = Modifier
            .background(OrangeVoile, RoundedCornerShape(8.dp))
            .padding(horizontal = 10.dp, vertical = 4.dp)
    ) {
        Text(
            "$etape / $total",
            color = BleuNuit,
            style = MaterialTheme.typography.labelMedium
        )
    }
}

/**
 * D42.33 — §9.4 Bienvenue / crédits offerts (écran signature, famille A) :
 * fond navy + halo orange, marque + badge, tuile cadeau, H1 « Félicitations ! »
 * (titre générique — JAMAIS de prénom inventé), carte de solde avec 3 tuiles
 * quand le solde confirmé est 3, réassurances, CTA pilule + « Plus tard ».
 * Les 4 états honnêtes D42.30 (attente / ok / hors ligne / refus serveur)
 * sont conservés À L'IDENTIQUE — seule la peinture change.
 */
@Composable
fun WelcomeScreen(
    credits: Int,
    statut: String,
    refusStatut: Int,
    refusCode: String,
    onContinue: () -> Unit,
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(BleuNuit)
            .androidxHaloAccueil()
    ) {
        Column(
            modifier = Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 20.dp)
                .padding(top = 46.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                MarqueBienvenue()
                BadgeCompteCree()
            }
            Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                TuileCadeau()
            }
            Text(
                stringResource(R.string.welcome_title),
                style = video.vitrine.core.designsystem.VitrineText.H1,
                color = BlancPur,
                modifier = Modifier.padding(top = 6.dp)
            )
            if (statut == "ok" && credits > 0) {
                Text(
                    stringResource(R.string.welcome_sub_gift, credits, credits),
                    style = video.vitrine.core.designsystem.VitrineText.Sub,
                    color = video.vitrine.core.designsystem.Blanc70
                )
            }
            ContenuCredits(credits, statut, refusStatut, refusCode)
            ReassurancesBienvenue()
            Box(modifier = Modifier.padding(bottom = 4.dp))
        }
        // Barre d'action épinglée (56 dp, police 130 %).
        Surface(color = Color.Transparent, tonalElevation = 0.dp) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 12.dp)
            ) {
                video.vitrine.core.designsystem.BoutonPrimaire(
                    libelle = stringResource(R.string.welcome_cta),
                    onClick = onContinue,
                    testTag = "welcome_cta"
                )
                Text(
                    stringResource(R.string.welcome_plus_tard),
                    style = video.vitrine.core.designsystem.VitrineText.Tiny.copy(
                        fontWeight = androidx.compose.ui.text.font.FontWeight.W600
                    ),
                    color = video.vitrine.core.designsystem.Blanc70,
                    modifier = Modifier
                        .align(Alignment.CenterHorizontally)
                        .padding(top = 6.dp, bottom = 2.dp)
                        .clip(RoundedCornerShape(50))
                        .clickable { onContinue() }
                        .padding(horizontal = 16.dp, vertical = 8.dp)
                )
            }
        }
    }
}

/** Halo d'accueil (§5) : orange en haut à droite, navy doux en bas à gauche. */
private fun Modifier.androidxHaloAccueil(): Modifier = this.then(
    Modifier.drawBehind {
        drawCircle(
            color = Color(0x4DF95C0F),
            radius = size.width * 0.55f,
            center = Offset(size.width * 1.05f, size.height * 0.02f)
        )
        drawCircle(
            color = Color(0x6623467F),
            radius = size.width * 0.65f,
            center = Offset(-size.width * 0.05f, size.height * 1.05f)
        )
    }
)

/** Marque : insigne dans une tuile blanche rayon 14 (§9.4). */
@Composable
private fun MarqueBienvenue() {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Box(
            modifier = Modifier
                .size(44.dp)
                .clip(RoundedCornerShape(14.dp))
                .background(Color.White),
            contentAlignment = Alignment.Center
        ) {
            Image(
                painter = painterResource(video.vitrine.core.designsystem.R.drawable.vitrine_logo),
                contentDescription = null,
                modifier = Modifier.size(30.dp)
            )
        }
    }
}

/** Badge « Compte créé » (blanc 18 %, §7.6 sur sombre). */
@Composable
private fun BadgeCompteCree() {
    Box(
        modifier = Modifier
            .clip(RoundedCornerShape(50))
            .background(Color(0x2EFFFFFF))
            .padding(horizontal = 12.dp, vertical = 5.dp)
    ) {
        Text(
            stringResource(R.string.welcome_badge_compte),
            style = video.vitrine.core.designsystem.VitrineText.Badge,
            color = Color.White
        )
    }
}

/** Tuile cadeau 96 dp : orange, rayon 30, double anneau (§9.4). */
@Composable
private fun TuileCadeau() {
    Box(modifier = Modifier.size(116.dp), contentAlignment = Alignment.Center) {
        Canvas(modifier = Modifier.size(116.dp)) {
            val r = size.minDimension / 2f
            drawCircle(
                color = OrangeStore.copy(alpha = 0.22f),
                radius = r,
                style = Stroke(width = 2.dp.toPx())
            )
            drawCircle(
                color = OrangeStore.copy(alpha = 0.45f),
                radius = r - 6.dp.toPx(),
                style = Stroke(width = 2.dp.toPx())
            )
        }
        Box(
            modifier = Modifier
                .size(96.dp)
                .clip(RoundedCornerShape(30.dp))
                .background(
                    Brush.verticalGradient(listOf(OrangeHi, OrangeStore))
                ),
            contentAlignment = Alignment.Center
        ) {
            video.vitrine.core.designsystem.IconeVitrine(
                icone = painterResource(video.vitrine.core.designsystem.R.drawable.ic_gift),
                taille = 42.dp,
                teinte = Color.White
            )
        }
    }
}

/**
 * D42.30/D42.32 : état des crédits de bienvenue — les 4 cas typés, extraits
 * (detekt LongMethod). D42.33 : rendus sur fond navy (famille A).
 */
@Composable
private fun ContenuCredits(
    credits: Int,
    statut: String,
    refusStatut: Int,
    refusCode: String
) {
    when (statut) {
        "attente" -> AttenteCredits()
        "ok" -> {
            if (credits > 0) {
                CarteSoldeBienvenue(credits)
            } else {
                Text(
                    stringResource(R.string.welcome_credits_zero, credits),
                    style = video.vitrine.core.designsystem.VitrineText.Body,
                    color = video.vitrine.core.designsystem.Blanc80
                )
            }
        }
        "horsligne" -> Text(
            stringResource(R.string.welcome_offline),
            style = video.vitrine.core.designsystem.VitrineText.Body,
            color = video.vitrine.core.designsystem.Blanc80
        )
        "refuse" -> Text(
            messageRefus(refusStatut, refusCode),
            style = video.vitrine.core.designsystem.VitrineText.Body,
            color = video.vitrine.core.designsystem.Blanc80
        )
        else -> AttenteCredits()
    }
}

/** Attente serveur — spinner + message, jamais bloquant (D42.9). */
@Composable
private fun AttenteCredits() {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        CircularProgressIndicator(
            modifier = Modifier.size(20.dp),
            strokeWidth = 2.dp,
            color = OrangeStore
        )
        Text(
            stringResource(R.string.welcome_credits_pending),
            style = video.vitrine.core.designsystem.VitrineText.Body,
            color = video.vitrine.core.designsystem.Blanc80
        )
    }
}

/**
 * §9.4 carte de solde : fond blanc 6 %, rayon 26, titre « Ton solde de
 * bienvenue », badge Confirmé (preuve serveur), et le solde MAtérialisé :
 * 3 tuiles « Vidéo 1 / 2 / 3 » quand le solde confirmé est 3 ; sinon le
 * chiffre réel en Num (jamais un chiffre inventé).
 */
@Composable
private fun CarteSoldeBienvenue(credits: Int) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(26.dp))
            .background(Color(0x0FFFFFFF))
            .border(1.dp, Color(0x14FFFFFF), RoundedCornerShape(26.dp))
            .padding(20.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                stringResource(R.string.welcome_solde_titre),
                style = video.vitrine.core.designsystem.VitrineText.H3,
                color = BlancPur
            )
            video.vitrine.core.designsystem.BadgeVitrine(
                texte = stringResource(R.string.welcome_badge_confirme),
                teinte = video.vitrine.core.designsystem.TeinteBadge.Succes
            )
        }
        if (credits == 3) {
            // Le chiffre 3 est matérialisé physiquement en 3 objets (§9.4).
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 14.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                repeat(credits) { index ->
                    TuileVideoBienvenue(numero = index + 1, modifier = Modifier.weight(1f))
                }
            }
        } else {
            Row(
                verticalAlignment = Alignment.Bottom,
                modifier = Modifier.padding(top = 10.dp)
            ) {
                Text(
                    credits.toString(),
                    style = video.vitrine.core.designsystem.VitrineText.Num,
                    color = BlancPur
                )
                Text(
                    stringResource(R.string.welcome_credits, credits),
                    style = video.vitrine.core.designsystem.VitrineText.Body.copy(fontSize = 13.sp),
                    color = video.vitrine.core.designsystem.Blanc70,
                    modifier = Modifier.padding(start = 8.dp, bottom = 4.dp)
                )
            }
        }
    }
}

/** Tuile « Vidéo n » : rayon 18, filet blanc 8 %, icône video orange (§9.4). */
@Composable
private fun TuileVideoBienvenue(numero: Int, modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .clip(RoundedCornerShape(18.dp))
            .border(1.dp, Color(0x14FFFFFF), RoundedCornerShape(18.dp))
            .padding(vertical = 14.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        video.vitrine.core.designsystem.IconeVitrine(
            icone = painterResource(video.vitrine.core.designsystem.R.drawable.ic_video),
            taille = 20.dp,
            teinte = OrangeStore
        )
        Text(
            stringResource(R.string.welcome_video_n, numero),
            style = video.vitrine.core.designsystem.VitrineText.Tiny,
            color = video.vitrine.core.designsystem.Blanc80,
            modifier = Modifier.padding(top = 6.dp)
        )
    }
}

/** Réassurances réelles du produit (§9.4) : 1080p · sans filigrane · sans limite. */
@Composable
private fun ReassurancesBienvenue() {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Reassurance(stringResource(R.string.welcome_reassur_1))
        Reassurance(stringResource(R.string.welcome_reassur_2))
        Reassurance(stringResource(R.string.welcome_reassur_3))
    }
}

@Composable
private fun Reassurance(texte: String) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        video.vitrine.core.designsystem.IconeVitrine(
            icone = painterResource(video.vitrine.core.designsystem.R.drawable.ic_check),
            taille = 14.dp,
            teinte = video.vitrine.core.designsystem.VertSucces
        )
        Text(
            texte,
            style = video.vitrine.core.designsystem.VitrineText.Tiny,
            color = video.vitrine.core.designsystem.Blanc80,
            modifier = Modifier.padding(start = 4.dp)
        )
    }
}

/**
 * Ecran E3b (maquette E3b_Code_Parrain) : code parrain FACULTATIF,
 * badge etape 2/3, recap secteur illustre, lien pour passer sans code.
 * Jamais bloquant (D19) : onDone(null) = parcours normal.
 */
@Composable
fun ReferralCodeScreen(
    sector: Sector,
    // D42.27-08 : code parrain DÉTECTÉ par le deep-link (affiché à l'auth,
    // transmis jusqu'ici) — pré-remplissage du champ pour ne pas faire
    // retaper un code que l'app connaît déjà. Vide = comportement inchangé.
    initial: String = "",
    onDone: (String?) -> Unit
) {
    // D42.33 : famille B repeinte (marge 20, badge étape, champ §7.9,
    // CTA pilule) — logique de validation D41 inchangée.
    var code by remember { mutableStateOf(initial) }
    var invalid by remember { mutableStateOf(false) }
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 20.dp)
            .padding(top = 16.dp, bottom = 26.dp),
        verticalArrangement = Arrangement.spacedBy(14.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    stringResource(R.string.refcode_title),
                    style = video.vitrine.core.designsystem.VitrineText.H2,
                    color = BleuNuit
                )
                Text(
                    stringResource(R.string.refcode_subtitle),
                    style = video.vitrine.core.designsystem.VitrineText.Sub,
                    color = video.vitrine.core.designsystem.Muted
                )
            }
            Box(
                modifier = Modifier
                    .background(OrangeVoile, RoundedCornerShape(8.dp))
                    .padding(horizontal = 12.dp, vertical = 6.dp)
            ) {
                Text("2 / 3", color = BleuNuit, style = MaterialTheme.typography.titleSmall)
            }
        }
        SecteurChoisiCard(sector)
        video.vitrine.core.designsystem.ChampFormulaire(
            valeur = code,
            surChangement = { code = it; invalid = false },
            label = stringResource(R.string.refcode_label),
            placeholder = stringResource(R.string.refcode_hint),
            erreur = if (invalid) stringResource(R.string.refcode_invalid) else null,
            testTag = "refcode_field"
        )
        video.vitrine.core.designsystem.BoutonPrimaire(
            libelle = stringResource(R.string.refcode_continue),
            onClick = {
                val normalise = video.vitrine.feature.onboarding.auth.RefCodeParser.fromManualEntry(code)
                if (code.isNotBlank() && normalise == null) {
                    invalid = true
                } else {
                    onDone(normalise)
                }
            },
            testTag = "refcode_continue"
        )
        Text(
            stringResource(R.string.refcode_skip),
            style = video.vitrine.core.designsystem.VitrineText.Tiny.copy(
                fontWeight = androidx.compose.ui.text.font.FontWeight.W600
            ),
            color = video.vitrine.core.designsystem.Muted,
            modifier = Modifier
                .align(Alignment.CenterHorizontally)
                .clip(RoundedCornerShape(50))
                .clickable { onDone(null) }
                .padding(horizontal = 16.dp, vertical = 10.dp)
        )
    }
}

/** D41 (detekt LongMethod) : carte recap du secteur choisi, extraite de ReferralCodeScreen. */
@Composable
private fun SecteurChoisiCard(sector: Sector) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(14.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            sectorIllustration(sector.code)?.let { res ->
                Image(
                    painter = painterResource(res),
                    contentDescription = sectorLabel(sector),
                    modifier = Modifier.size(56.dp)
                )
            }
            Column {
                Text(
                    stringResource(R.string.refcode_chosen),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Text(sectorLabel(sector), style = MaterialTheme.typography.titleMedium, color = BleuNuit)
            }
        }
    }
}

/** Message EXACT par cause de refus (mission D42.30 : jamais « connexion
 *  perdue » quand le serveur a répondu non). */
@Composable
private fun messageRefus(statut: Int, code: String): String = when {
    statut == 401 -> stringResource(R.string.welcome_err_session)
    statut == 403 || code == "account_inactive" ->
        stringResource(R.string.welcome_err_inactive)
    statut == 404 || code == "profile_not_initialized" ->
        stringResource(R.string.welcome_err_profil)
    statut >= 500 || code == "database_unavailable" ->
        stringResource(R.string.welcome_err_serveur)
    else -> stringResource(R.string.welcome_err_autre, statut)
}

@Preview(showBackground = true)
@Composable
private fun SectorPreview() {
    VitrineTheme { OnboardingScreen { } }
}
