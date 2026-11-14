package video.vitrine.core.designsystem

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.em
import androidx.compose.ui.unit.sp

/**
 * D42.33 — Typographie de la refonte (spec §4).
 *
 * Deux familles, jamais plus :
 *  - Plus Jakarta Sans (700/800) — titres, chiffres clés, labels de bouton, marque ;
 *  - Inter (400/500/600) — texte courant, méta, champs.
 *
 * Polices LOCALES (res/font, licences OFL dans core-designsystem/licenses/) :
 * aucun téléchargement au runtime. Fichiers statiques (minSdk 24 : les axes
 * variables ne s'appliquent qu'à partir d'API 26 — le rendu 700/800 doit être
 * garanti sur les appareils économiques API 24-25).
 *
 * Stratégie de propagation : la [Typography] Material3 est mappée sur l'échelle
 * spec (les 134 usages `MaterialTheme.typography.*` héritent de l'échelle sans
 * modification des écrans). Les styles nommés ([VitrineText]) servent aux
 * composants du design system et aux retouches ciblées.
 */

/** Plus Jakarta Sans (700/800) — titres, chiffres, boutons, marque. */
val Jakarta = FontFamily(
    Font(R.font.plus_jakarta_sans_bold, FontWeight.W700),
    Font(R.font.plus_jakarta_sans_extrabold, FontWeight.W800)
)

/** Inter (400/500/600) — corps, méta, champs. */
val Inter = FontFamily(
    Font(R.font.inter_regular, FontWeight.W400),
    Font(R.font.inter_medium, FontWeight.W500),
    Font(R.font.inter_semibold, FontWeight.W600)
)

/** Interlettrage négatif « moderne » (spec §4), en em (relatif à la taille). */
private val lsH1 = (-0.035).em
private val lsH2 = (-0.03).em
private val lsH3 = (-0.02).em
private val lsNum = (-0.045).em
private val lsBouton = (-0.01).em
private val lsLabel = 0.09.em
private val lsBadge = 0.02.em

/**
 * Styles nommés de la spec §4. Couleur neutre par défaut (portée par l'écran)
 * sauf [VitrineText.Label] où Muted fait partie du token (spec : « Label…
 * Muted »). Aucun style ne force l'italique ni le soulignement.
 */
object VitrineText {
    /** Titre d'écran émotionnel — un seul H1 par écran (§4). */
    val H1 = TextStyle(
        fontFamily = Jakarta,
        fontWeight = FontWeight.W800,
        fontSize = 29.sp,
        lineHeight = 33.sp,
        letterSpacing = lsH1
    )

    /** Titre de section forte. */
    val H2 = TextStyle(
        fontFamily = Jakarta,
        fontWeight = FontWeight.W800,
        fontSize = 21.sp,
        lineHeight = 25.6.sp,
        letterSpacing = lsH2
    )

    /** Titre de carte / de section. */
    val H3 = TextStyle(
        fontFamily = Jakarta,
        fontWeight = FontWeight.W700,
        fontSize = 16.5.sp,
        lineHeight = 21.5.sp,
        letterSpacing = lsH3
    )

    /** Texte courant. */
    val Body = TextStyle(
        fontFamily = Inter,
        fontWeight = FontWeight.W400,
        fontSize = 15.sp,
        lineHeight = 21.75.sp
    )

    /** Nom de fichier, titre de ligne. */
    val BodyStrong = TextStyle(
        fontFamily = Inter,
        fontWeight = FontWeight.W600,
        fontSize = 15.sp,
        lineHeight = 21.75.sp
    )

    /** Sous-titre, description (couleur Muted conseillée à l'usage). */
    val Sub = TextStyle(
        fontFamily = Inter,
        fontWeight = FontWeight.W400,
        fontSize = 14.5.sp,
        lineHeight = 21.75.sp
    )

    /** Méta, micro-copie, mentions (couleur Muted conseillée à l'usage). */
    val Tiny = TextStyle(
        fontFamily = Inter,
        fontWeight = FontWeight.W400,
        fontSize = 12.5.sp,
        lineHeight = 18.sp
    )

    /** « EXPORTS RESTANTS » — capitales autorisées UNIQUEMENT ici (§4). */
    val Label = TextStyle(
        fontFamily = Inter,
        fontWeight = FontWeight.W700,
        fontSize = 11.sp,
        letterSpacing = lsLabel,
        color = Muted
    )

    /** Chiffre héros (crédits). 40 sp ; 44 admis sur les écrans très aérés. */
    val Num = TextStyle(
        fontFamily = Jakarta,
        fontWeight = FontWeight.W800,
        fontSize = 40.sp,
        letterSpacing = lsNum
    )

    /** Libellé de CTA (§7.1). */
    val Button = TextStyle(
        fontFamily = Jakarta,
        fontWeight = FontWeight.W700,
        fontSize = 16.sp,
        letterSpacing = lsBouton
    )

    /** Chip de filtre (§7.6). */
    val Chip = TextStyle(
        fontFamily = Inter,
        fontWeight = FontWeight.W600,
        fontSize = 12.8.sp
    )

    /** Badge (§7.6). */
    val Badge = TextStyle(
        fontFamily = Inter,
        fontWeight = FontWeight.W700,
        fontSize = 11.sp,
        letterSpacing = lsBadge
    )
}

/**
 * Mapping Material3 → échelle spec (propagation sans toucher les écrans).
 * Règles §4 respectées : jamais de capitales au-delà de Label, interlignage
 * serré sur les titres Jakarta.
 */
val VitrineTypography = Typography(
    // Num (chiffres héros) — display
    displayLarge = VitrineText.Num.copy(fontSize = 44.sp, lineHeight = 48.sp),
    displayMedium = VitrineText.Num.copy(fontSize = 42.sp, lineHeight = 46.sp),
    displaySmall = VitrineText.Num,
    // H1 (un seul par écran, émotionnel)
    headlineLarge = VitrineText.H1,
    // H2
    headlineMedium = VitrineText.H2,
    // H3
    headlineSmall = VitrineText.H3,
    // H2 (titre de section en contexte large)
    titleLarge = VitrineText.H2,
    // H3 (titre de carte)
    titleMedium = VitrineText.H3,
    // BodyStrong (titre de ligne)
    titleSmall = VitrineText.BodyStrong,
    // Body
    bodyLarge = VitrineText.Body,
    // Sub
    bodyMedium = VitrineText.Sub,
    // Tiny
    bodySmall = VitrineText.Tiny,
    // Button (§7.1)
    labelLarge = VitrineText.Button,
    // Chip (§7.6)
    labelMedium = VitrineText.Chip,
    // Label — capitales à la charge du call site (texte existant jamais modifié)
    labelSmall = VitrineText.Label.copy(color = androidx.compose.ui.graphics.Color.Unspecified)
)
