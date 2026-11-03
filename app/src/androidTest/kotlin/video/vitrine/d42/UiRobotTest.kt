package video.vitrine.d42

import android.content.Context
import android.content.Intent
import androidx.test.core.app.ActivityScenario
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.uiautomator.By
import androidx.test.uiautomator.UiDevice
import androidx.test.uiautomator.UiObject2
import org.json.JSONObject
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import java.io.File

/**
 * Robot UI D42 — exploration AUTOMATISÉE des écrans réels de l'APK.
 *
 * Pour chaque écran : ouverture, lecture de la hiérarchie d'accessibilité
 * réelle, puis clic SUR CHAQUE élément cliquable visible. Chaque clic produit
 * une ligne de matrice {écran, élément, attendu, constaté, capture, statut} :
 *
 *  - `ACTION`          l'écran résumé (activité) change ;
 *  - `EFFET_VISIBLE`   la hiérarchie change sans changer d'activité (dialogue,
 *                      changement d'état, saisie) ;
 *  - `SANS_EFFET`      rien ne bouge : candidat « bouton mort » — CONSIGNÉ,
 *                      jamais masqué ;
 *  - `CRASH`           le processus cible a disparu ou une boîte « a cessé de
 *                      fonctionner » est apparue : l'exécution échoue ;
 *  - `ECRAN_SANS_ISSUE` aucun élément cliquable : écran bloquant, l'exécution
 *                      échoue.
 *
 * Les captures sont prises APRÈS l'action, pas avant : c'est le résultat qui
 * est prouvé.
 */
@RunWith(AndroidJUnit4::class)
class UiRobotTest {

    private val instrumentation = InstrumentationRegistry.getInstrumentation()
    private val target: Context = instrumentation.targetContext
    private val device: UiDevice = UiDevice.getInstance(instrumentation)

    private val sortie: File by lazy {
        File(target.getExternalFilesDir(null), "d42/ui").apply { mkdirs() }
    }

    private data class Ligne(
        val ecran: String,
        val element: String,
        val attendu: String,
        val constate: String,
        val capture: String,
        val statut: String
    )

    private fun ecrans(): List<Pair<String, Intent>> = listOf(
        "language" to Intent(target, video.vitrine.feature.onboarding.LanguageActivity::class.java)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
        "auth" to Intent(target, video.vitrine.feature.onboarding.auth.AuthActivity::class.java)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
        "onboarding" to Intent(
            target, video.vitrine.feature.onboarding.OnboardingActivity::class.java
        ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
        "catalogue" to Intent(target, video.vitrine.feature.catalog.CatalogActivity::class.java)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
        "brief" to Intent(target, video.vitrine.feature.brief.BriefActivity::class.java)
            .putExtra("gabarit_id", "restaurants_maquis_T1")
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
        "export_sans_credit" to Intent(
            target, video.vitrine.feature.export.ExportActivity::class.java
        ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    )

    /**
     * Activité au premier plan. API 34 n'expose plus `mResumedActivity` dans
     * `dumpsys activity activities` : le premier essai (run 41652906576) rendait
     * toujours « ? », donc AUCUNE navigation n'était reconnue (`actions=0`)
     * alors que des écrans changeaient visiblement. On interroge la fenêtre
     * focus, qui donne la classe réellement affichée.
     */
    private fun activiteResumee(): String {
        val dump = runCatching {
            device.executeShellCommand("dumpsys window | grep -E 'mCurrentFocus|mFocusedApp'")
        }.getOrDefault("")
        val classe = Regex("([A-Za-z0-9_.]+)/([A-Za-z0-9_.$]+)").find(dump)
        return classe?.groupValues?.get(2)?.substringAfterLast('.') ?: "?"
    }

    private fun signature(): String = runCatching {
        device.findObjects(By.clickable(true)).take(40).joinToString("|") { o ->
            "${o.text}:${o.contentDescription}:${o.visibleBounds.flattenToString()}"
        }
    }.getOrDefault("")

    private fun vivant(): Boolean =
        runCatching { device.executeShellCommand("pidof video.vitrine.app").isNotBlank() }
            .getOrDefault(true)

    private fun libelle(obj: UiObject2): String {
        val texte = obj.text?.trim().orEmpty()
        val desc = obj.contentDescription?.trim().orEmpty()
        val res = obj.resourceName.orEmpty().substringAfterLast('/')
        val nom = when {
            texte.isNotEmpty() -> "texte=\"$texte\""
            desc.isNotEmpty() -> "desc=\"$desc\""
            res.isNotEmpty() -> "id=$res"
            else -> "bouton@${obj.visibleBounds.centerX()},${obj.visibleBounds.centerY()}"
        }
        return nom.take(80)
    }

    @Test
    fun explorationDesEcrans() {
        val lignes = mutableListOf<Ligne>()
        val sansIssue = mutableListOf<String>()
        val crashs = mutableListOf<String>()

        ecrans().forEach { (nom, intent) ->
            var scenario: ActivityScenario<*>? = null
            try {
                scenario = ActivityScenario.launch<android.app.Activity>(intent)
                Thread.sleep(1500)
                device.waitForIdle(1500)
                val cliquables: List<UiObject2> = runCatching {
                    device.findObjects(By.clickable(true))
                }.getOrDefault(emptyList())
                android.util.Log.i(TAG, "ecran=$nom cliquables=${cliquables.size}")
                if (cliquables.isEmpty()) sansIssue += nom

                cliquables.take(MAX_CLICS).forEachIndexed { index, obj ->
                    val element = runCatching { libelle(obj) }.getOrDefault("?")
                    val avantActivite = activiteResumee()
                    val avantSignature = signature()
                    val clic = runCatching { obj.click() }.isSuccess
                    Thread.sleep(900)
                    device.waitForIdle(900)
                    val apresActivite = activiteResumee()
                    val apresSignature = signature()
                    val capture = File(sortie, "${nom}_${index}.png")
                    runCatching { device.takeScreenshot(capture) }

                    val (constate, statut) = when {
                        !clic -> "clic impossible" to "SANS_EFFET"
                        !vivant() -> "processus disparu" to "CRASH"
                        device.hasObject(By.textContains("cessé de fonctionner")) ->
                            "boîte de plantage" to "CRASH"
                        apresActivite != avantActivite && apresActivite != "?" ->
                            "activité -> $apresActivite" to "ACTION"
                        apresSignature != avantSignature -> "hiérarchie modifiée" to "EFFET_VISIBLE"
                        else -> "aucun changement" to "SANS_EFFET"
                    }
                    if (statut == "CRASH") crashs += "$nom/$element"
                    lignes += Ligne(
                        nom, element, "réaction au clic", constate,
                        capture.name, statut
                    )
                    android.util.Log.i(TAG, "  $nom $element -> $statut ($constate)")
                    // Un clic peut avoir quitté l'écran : on arrête la série.
                    if (statut == "ACTION") return@forEachIndexed
                }
            } catch (erreur: Throwable) {
                android.util.Log.e(TAG, "ecran=$nom en echec", erreur)
                lignes += Ligne(nom, "-", "ouverture de l'écran", "${erreur.javaClass.simpleName}",
                    "-", "ECHEC_OUVERTURE")
            } finally {
                runCatching { scenario?.close() }
            }
        }

        val matrice = File(sortie, "matrice_ui.jsonl")
        matrice.printWriter().use { w ->
            lignes.forEach { l ->
                w.println(
                    JSONObject().put("ecran", l.ecran).put("element", l.element)
                        .put("attendu", l.attendu).put("constate", l.constate)
                        .put("capture", l.capture).put("statut", l.statut)
                )
            }
        }
        val resume = "ecrans=${ecrans().size} lignes=${lignes.size} " +
            "actions=${lignes.count { it.statut == "ACTION" }} " +
            "effets=${lignes.count { it.statut == "EFFET_VISIBLE" }} " +
            "sans_effet=${lignes.count { it.statut == "SANS_EFFET" }} " +
            "crashs=${crashs.size} sans_issue=${sansIssue.size}"
        File(sortie, "resume.txt").writeText(resume)
        android.util.Log.i(TAG, resume)

        assertTrue("CRASH détecté : $crashs", crashs.isEmpty())
        assertTrue("écrans sans aucun élément cliquable : $sansIssue", sansIssue.isEmpty())
    }

    private companion object {
        private const val TAG = "D42-UI"
        private const val MAX_CLICS = 8
    }
}
