package video.vitrine.core.designsystem

import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Shapes
import androidx.compose.ui.unit.dp

/**
 * D42.33 — Rayons de la refonte (spec §5). Échelle fermée :
 * 14 (icône) · 18 (tuile/champ) · 22 (carte) · 26 (héro) · 30 (feuille) ·
 * 999 (pilule). Tout RoundedCornerShape à la main dans les écrans est un
 * écart à corriger au fil des familles.
 */

/** Boutons, chips, badges, onglet actif. */
val FormePill = RoundedCornerShape(999.dp)

/** Feuille modale — coins hauts seuls (§7.10). */
val FormeFeuille = RoundedCornerShape(topStart = 30.dp, topEnd = 30.dp)

/** Carte héro (bloc navy des crédits). */
val FormeHero = RoundedCornerShape(26.dp)

/** Carte standard, ligne de liste. */
val FormeCarte = RoundedCornerShape(22.dp)

/** Tuile, vignette, champ de formulaire. */
val FormeTuile = RoundedCornerShape(18.dp)

/** Bouton icône 40 dp, vignette 40-48 dp. */
val FormeIcone = RoundedCornerShape(14.dp)

/** Registre Material3 mappé sur l'échelle spec. */
val FormesVitrine = Shapes(
    extraSmall = FormeIcone,
    small = FormeTuile,
    medium = FormeCarte,
    large = FormeHero,
    extraLarge = FormeFeuille
)
