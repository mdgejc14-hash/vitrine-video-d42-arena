package video.vitrine.feature.onboarding.auth

/**
 * Capture du code parrainage (R8) : deep-link https://vitrine.video/r/CODE
 * ou saisie manuelle a l'onboarding. Pur Kotlin, testable JVM.
 */
object RefCodeParser {
    private val PATTERN = Regex("^[A-Z]{3,10}-[0-9]{3}$")

    fun fromDeepLink(uri: String?): String? {
        if (uri.isNullOrBlank()) return null
        val marker = "/r/"
        val idx = uri.indexOf(marker)
        if (idx < 0) return null
        val raw = uri.substring(idx + marker.length).substringBefore('/').substringBefore('?')
        return normalize(raw)
    }

    fun fromManualEntry(raw: String?): String? = normalize(raw)

    private fun normalize(raw: String?): String? {
        val code = raw?.trim()?.uppercase()?.takeIf { PATTERN.matches(it) }
        return code
    }
}
