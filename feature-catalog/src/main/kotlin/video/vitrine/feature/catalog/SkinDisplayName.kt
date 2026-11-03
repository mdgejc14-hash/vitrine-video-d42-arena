package video.vitrine.feature.catalog

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import video.vitrine.core.designsystem.sectorLabel
import video.vitrine.core.model.Skin

/** Etiquette commerciale d'un gabarit : jamais de code technique visible. */
object SkinDisplayName {

    private val KNOWN = mapOf(
        "F001" to R.string.skin_new_arrival,
        "F002" to R.string.skin_before_after,
        "F003" to R.string.skin_quick_presentation,
        "F004" to R.string.skin_flash_promo,
        "F005" to R.string.skin_customer_review
    )

    private val CODE_LIKE = Regex("^[a-z0-9_\\-]+$", RegexOption.IGNORE_CASE)

    @Composable
    fun label(skin: Skin): String {
        val known = KNOWN[skin.id.take(4).uppercase()]
        if (known != null) return stringResource(known)
        return if (CODE_LIKE.matches(skin.name)) {
            "${sectorLabel(skin.sector)} · ${skin.name.filter { it.isDigit() }.padStart(2, '0')}"
        } else {
            skin.name
        }
    }
}
