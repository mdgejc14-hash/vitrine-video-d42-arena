package video.vitrine.core.designsystem

import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/**
 * D42.33 — Dimensions de la refonte (spec §2, gabarit 393 × 852 dp).
 *
 * Rythme : tout multiple de 2 ; les blocs se suivent par 12 ou 16.
 * Échelle d'espacement admise : 2·4·6·8·10·12·14·16·18·20·24·28·32.
 * Un écran est fini seulement si les cibles tactiles ≥ 48 dp sont tenues.
 */
object Dims {
    // ── Structure de l'écran (gabarit §2) ──────────────────────────────────
    /** Marge latérale — jamais moins (padding interne de carte : 18). */
    val Marge: Dp = 20.dp
    /** Largeur de contenu (393 − 2 × 20). */
    val LargeurContenu: Dp = 353.dp
    /** Gouttière entre cartes (grilles 2 colonnes). */
    val Gouttiere: Dp = 12.dp
    /** Gouttière des listes serrées. */
    val GouttiereSerree: Dp = 10.dp
    /** Hauteur du header (retour 40×40 · titre H3 · 1 action max). */
    val Header: Dp = 52.dp
    /** Première carte sous le header. */
    val PremierBloc: Dp = 8.dp
    /** Padding additionnel sous le dernier élément (safe area basse). */
    val SafeBas: Dp = 26.dp
    /** Barre d'onglets (§7.13) hors safe area. */
    val TabBar: Dp = 74.dp
    /** Décalage de l'action centrale au-dessus de la tab bar. */
    val TabBarCentreDecalage: Dp = 18.dp

    // ── Composants (§7) ────────────────────────────────────────────────────
    /** CTA primaire (§7.1). */
    val Cta: Dp = 56.dp
    /** CTA secondaire / lien tertiaire (§7.2). */
    val CtaSecondaire: Dp = 46.dp
    /** Cible tactile minimale — même si le visuel fait 40. */
    val CibleTactile: Dp = 48.dp
    /** Bouton icône (§7.3). */
    val BoutonIcone: Dp = 40.dp
    /** Padding interne de carte standard (§7.4). */
    val CartePadding: Dp = 18.dp
    /** Padding interne de carte héro (§7.4). */
    val HeroPadding: Dp = 20.dp
    /** Champ de formulaire (§7.9). */
    val Champ: Dp = 56.dp
    /** Hauteur minimale d'une ligne de liste (§7.7). */
    val LigneListe: Dp = 72.dp
    /** Vignette de ligne de liste (§7.7). */
    val Vignette: Dp = 48.dp
    /** Badge hauteur (§7.6). */
    val BadgeHauteur: Dp = 22.dp
    /** Chip de filtre hauteur (§7.6). */
    val ChipHauteur: Dp = 32.dp
    /** Barre de progression (§7.8). */
    val Progression: Dp = 4.dp
    /** Séparateur entre segments du stepper (§7.8). */
    val SegmentEcart: Dp = 4.dp
    /** Anneau de progression épaisseur (§7.11). */
    val Anneau: Dp = 6.dp
    /** Bouton d'arrêt caméra (§7.15). */
    val StopCamera: Dp = 64.dp
    /** Pastille blanche des logos tiers (§6). */
    val PastilleLogo: Dp = 44.dp
    /** Avatar du header dashboard (§9.3). */
    val Avatar: Dp = 40.dp
    /** Tuile cadeau bienvenue (§9.4). */
    val TuileCadeau: Dp = 96.dp
    /** Icônes : 20 bouton · 22 tab bar · 24 header · 28 tuile d'état (§6). */
    val IconeBouton: Dp = 20.dp
    val IconeTabBar: Dp = 22.dp
    val IconeHeader: Dp = 24.dp
    val IconeEtat: Dp = 28.dp
    /** Glyphe de l'action centrale de tab bar (§7.13). */
    val IconeCentrale: Dp = 26.dp

    // ── Dégradé du CTA collant (§2) ────────────────────────────────────────
    /** Padding du conteneur de CTA collant : 12 / 20 / 26. */
    val CtaCollantHaut: Dp = 12.dp
    /** Fondu du scrim sous le CTA collant. */
    val CtaCollantFondu: Dp = 26.dp
}
