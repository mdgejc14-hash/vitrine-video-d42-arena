package video.vitrine.feature.dashboard

import java.io.File
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * D42.32 (Lot 4) — CONTRÔLE AUTOMATIQUE « texte codé en dur » : aucun
 * libellé UI français ne doit vivre en dur dans un composable (tout passe
 * par strings.xml FR/EN, garantie I18nKeyCoverageTest). Sinon l'écran
 * affiche du FR quelle que soit la langue choisie = mélange garanti.
 *
 * Heuristique volontairement conservatrice (zéro faux positif actuel) :
 *  - Text("…") littéral contenant un accent français, OU
 *  - Text("…") littéral contenant un mot français courant (le/la/les/votre/…).
 *  - liste blanche : « — », « … », « • », nombres.
 * Test JVM pur (lecture des sources du repo, comme I18nKeyCoverageTest).
 */
class HardcodedUiTextCheckTest {

    private val modules = listOf(
        "feature-brief", "feature-camera", "feature-catalog",
        "feature-dashboard", "feature-export", "feature-onboarding"
    )

    private val autorises = setOf("—", "…", "•", "")

    private val motFrancais = Regex(
        """\b(le|la|les|des|une|est|avec|pour|votre|vos|ton|ta|tes|nous|vous|chez|sans|plus|très|déjà|pas|que|qui)\b""",
        RegexOption.IGNORE_CASE
    )

    private val accent = Regex("""[éèêëàâçîïôûùÉÈÀÇ]""")

    private val texteLitteal = Regex("""Text\(\s*"([^"]+)"\s*\)""")

    @Test
    fun `aucun libelle francais code en dur dans les composables`() {
        val problemes = mutableListOf<String>()
        modules.forEach { module ->
            val racine = File("../$module/src/main")
            if (!racine.isDirectory) return@forEach
            racine.walkTopDown()
                .filter { it.extension == "kotlin" }
                .forEach { fichier ->
                    fichier.readLines().forEachIndexed { index, ligne ->
                        texteLitteal.findAll(ligne).forEach { m ->
                            val texte = m.groupValues[1]
                            if (texte in autorises) return@forEach
                            if (texte.replace(" ", "").any { it.isDigit() } &&
                                texte.replace(" ", "").all { it.isDigit() }
                            ) return@forEach
                            if (accent.containsMatchIn(texte) || motFrancais.containsMatchIn(texte)) {
                                problemes += "${fichier.name}:${index + 1}: Text(\"$texte\")"
                            }
                        }
                    }
                }
        }
        assertTrue(
            "Libellés français codés en dur (${problemes.size}) :\n" +
                problemes.joinToString("\n"),
            problemes.isEmpty()
        )
    }
}
