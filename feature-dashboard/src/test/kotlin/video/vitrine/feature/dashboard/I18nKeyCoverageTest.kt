package video.vitrine.feature.dashboard

import java.io.File
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Audit D41 — COUVERTURE i18n 100 % (anti-regression) : chaque module qui porte
 * des chaines doit exposer EXACTEMENT le meme ensemble de cles en FR (defaut),
 * EN, ES et JA. Une cle ajoutee sans ses 3 traductions casse la promesse
 * « 4 langues reelles » (exigence mission D41 : chrome complet FR/EN/ES/JA).
 *
 * Test JVM pur (lecture des fichiers res du repo — pas de Robolectric).
 */
class I18nKeyCoverageTest {

    private val modules = listOf(
        "core-designsystem",
        "feature-brief",
        "feature-camera",
        "feature-catalog",
        "feature-dashboard",
        "feature-export",
        "feature-onboarding"
    )

    private val locales = listOf("values", "values-en", "values-es", "values-ja")

    private val motifCle = Regex("<string\\s+name=\"([^\"]+)\"")

    private fun clesDe(repertoire: File): Set<String> {
        if (!repertoire.isDirectory) return emptySet()
        return repertoire.listFiles { f -> f.name.startsWith("strings") && f.extension == "xml" }
            .orEmpty()
            .flatMap { f -> motifCle.findAll(f.readText()).map { it.groupValues[1] }.toList() }
            .toSet()
    }

    @Test
    fun `toutes les cles sont traduites dans les 4 langues`() {
        var total = 0
        modules.forEach { module ->
            val base = File("../$module/src/main/res")
            assertTrue("module introuvable : $module (${base.absolutePath})", base.isDirectory)
            val defaut = clesDe(File(base, "values"))
            assertTrue("$module : aucune cle par defaut", defaut.isNotEmpty())
            total += defaut.size
            locales.drop(1).forEach { locale ->
                val traduites = clesDe(File(base, locale))
                val manquantes = defaut - traduites
                val orphelines = traduites - defaut
                assertEquals(
                    "$module/$locale manquantes : $manquantes",
                    emptySet<String>(),
                    manquantes
                )
                assertEquals(
                    "$module/$locale orphelines (cle sans texte par defaut) : $orphelines",
                    emptySet<String>(),
                    orphelines
                )
            }
        }
        // Ordre de grandeur garde-fou : le produit porte plusieurs centaines de cles.
        assertTrue("total de cles suspectement faible : $total", total > 200)
    }
}
