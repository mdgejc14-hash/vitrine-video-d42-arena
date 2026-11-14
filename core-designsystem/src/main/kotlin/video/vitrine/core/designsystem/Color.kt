package video.vitrine.core.designsystem

import androidx.compose.ui.graphics.Color

/**
 * D42.33 — Tokens couleur de la refonte visuelle premium.
 * Source : SOURCES/spec/05_Spec_design_a_transmettre.md §3 (valeurs exactes,
 * intangibles). Les noms canoniques sont ceux de la spécification ; les
 * anciens noms FR (D42.31/32) sont conservés en alias pour ne casser aucun
 * import — une seule valeur par couleur, jamais deux sources.
 *
 * Identité intangible : orange #F95C0F + blanc, navy #022358 en encre.
 */
// ── Marque (intangibles) ────────────────────────────────────────────────────
/** Action, accent, insigne. Texte blanc uniquement (taille ≥ 15 sp). */
val OrangeStore = Color(0xFFF95C0F)
/** Haut du dégradé de bouton primaire (OrangeHi → OrangeStore, 180°). */
val OrangeHi = Color(0xFFFF6E22)
/** Texte orange sur fond clair — contraste AA (OrangeDeep). */
val OrangeDeep = Color(0xFFD34905)
/** Encre : titres, fonds sombres (Navy). */
val Navy = Color(0xFF022358)
/** Texte secondaire sur fond clair (NavySoft). */
val NavySoft = Color(0xFF23467F)

// ── Surfaces ────────────────────────────────────────────────────────────────
/** Fond applicatif clair (Bg) — le seul fond de parcours, avec Blanc. */
val Bg = Color(0xFFF7F8FC)
/** Cartes, feuilles (Surface). NB : nom « Blanc » pour éviter la collision
 *  d'import avec androidx.compose.material3.Surface. */
val Blanc = Color(0xFFFFFFFF)
/** Filet 1 dp, séparateurs (Line). */
val Line = Color(0xFFE2E8F0)
/** Texte tertiaire, méta (Muted). */
val Muted = Color(0xFF6C7C99)

// ── Voiles (remplacent les aplats saturés) ──────────────────────────────────
/** Badge/chip orange, bouton « doux ». */
val OrangeVoile = Color(0xFFFFF1E8)
/** Badge informatif. */
val BleuVoile = Color(0xFFE9F0FF)
/** Badge succès (rgba(14,159,110,.12) spec §7.6). */
val VertVoile = Color(0x1F0E9F6E)

// ── États (sémantique stricte) ──────────────────────────────────────────────
/** Point de synchro, coche validée. */
val VertSucces = Color(0xFF0E9F6E)
/** Texte de badge succès. */
val VertTexte = Color(0xFF0B7A55)
/** Avertissement, hors-ligne, erreur douce. */
val AmbreAlerte = Color(0xFFB26A00)
/** Uniquement erreur bloquante / consentement manquant. */
val RougeBloquant = Color(0xFFB42318)

// ── Utilitaires spec ────────────────────────────────────────────────────────
/** Texte sur badge info (BleuVoile). */
val InfoEncre = Color(0xFF1B4CA1)
/** Fond de CTA désactivé et piste de progression. */
val GrisDesactive = Color(0xFFEDEFF5)
/** Texte de CTA désactivé. */
val GrisDesactiveTexte = Color(0xFF9AA7BE)
/** Pastille « sur sombre » (blanc 18 %). */
val BlancVoile = Color(0x2EFFFFFF)
/** Rangée de badges de la carte héro (blanc 10 %, §7.5). */
val Blanc10 = Color(0x1AFFFFFF)
/** Badge sur fond sombre (blanc 18 %, alias sémantique). */
val BadgeSurSombre = BlancVoile
/** Scrim navy 45 % du carrousel et bandeau consigne caméra 55 %. */
val NavyScrim = Color(0x73022358)
/** Blanc 60 % (labels sur navy). */
val Blanc60 = Color(0x99FFFFFF)
/** Blanc 70 % (sous-titres sur navy). */
val Blanc70 = Color(0xB3FFFFFF)
/** Blanc 80 % (texte secondaire sur navy). */
val Blanc80 = Color(0xCCFFFFFF)

// ── Alias historiques D42.31/32 (dépréciés, à migrer au fil des familles) ───
@Deprecated("D42.33 : utiliser OrangeDeep (nom spec)", ReplaceWith("OrangeDeep"))
val OrangeStoreDeep = OrangeDeep
@Deprecated("D42.33 : utiliser Navy (nom spec)", ReplaceWith("Navy"))
val BleuNuit = Navy
@Deprecated("D42.33 : utiliser NavySoft (nom spec)", ReplaceWith("NavySoft"))
val BleuNuitSoft = NavySoft
@Deprecated("D42.33 : utiliser Blanc (nom spec)", ReplaceWith("Blanc"))
val BlancPur = Blanc
@Deprecated("D42.33 : utiliser Bg (nom spec)", ReplaceWith("Bg"))
val GrisDoux = Bg
@Deprecated("D42.33 : utiliser Line (nom spec)", ReplaceWith("Line"))
val GrisLiserai = Line

// ── Alias historiques Dashboard D42.32 (sync honnête) ───────────────────────
/** D42.32 : vert de confirmation sync — D42.33 : unifie sur VertSucces. */
@Deprecated("D42.33 : utiliser VertSucces (token unique spec)", ReplaceWith("VertSucces"))
val SyncVert = VertSucces
/** D42.32 : gris neutre hors connexion — D42.33 : Muted (sémantique §3). */
@Deprecated("D42.33 : utiliser Muted (sémantique spec §3)", ReplaceWith("Muted"))
val SyncGris = Muted
