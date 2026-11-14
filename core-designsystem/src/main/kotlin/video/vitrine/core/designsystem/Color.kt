package video.vitrine.core.designsystem

import androidx.compose.ui.graphics.Color

/**
 * Charte officielle VITRINE VIDEO, alignee sur les 197 maquettes Drive
 * (reference visuelle absolue, dossier maquettes_vitrine_video/ecrans) :
 * valeurs exactes echantillonnees au pixel — navy #022358, orange #F95C0F,
 * fond #F7F8FC, voile orange #FFF1E8. Les deux variantes Deep/Soft sont
 * derivees (luminosite) des exactes, faute d'equivalent dans les maquettes.
 */
val OrangeStore = Color(0xFFF95C0F)
val OrangeStoreDeep = Color(0xFFD34905)
val BleuNuit = Color(0xFF022358)
val BleuNuitSoft = Color(0xFF23467F)
val BlancPur = Color(0xFFFFFFFF)
val GrisDoux = Color(0xFFF7F8FC)
val GrisLiserai = Color(0xFFE2E8F0)
val OrangeVoile = Color(0xFFFFF1E8)
val BleuVoile = Color(0xFFE9F0FF)

/** D42.32 (§6) : ambre d'AVERTISSEMENT (champs, avertissements quota) —
 *  volontairement distinct de l'orange d'action OrangeStore pour ne pas
 *  ressembler à un bouton ; contraste AA sur fond clair. Était dupliquée
 *  en valeur brute dans BriefScreen et DashboardScreens : token unique. */
val AmbreAlerte = Color(0xFFB26A00)
