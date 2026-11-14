package video.vitrine.feature.export

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.view.View
import android.widget.Button
import android.widget.TextView
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.test.SemanticsNodeInteraction
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onRoot
import androidx.test.core.app.ActivityScenario
import androidx.test.core.app.ApplicationProvider
import java.io.File
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.core.designsystem.VitrineTheme
import video.vitrine.data.gabarits.GabaritJson

/**
 * Lot 2 D42.33 v2 — captures APRÈS manquantes de la production.
 * E7 : VideoPreviewScreen COMPLET (récap réel du T1 : lignes de contrôle et
 * textes d'aperçu parsés du JSON — aucune donnée inventée).
 * E8 : ExportActivity réelle (layout XML repeint + panneau Compose), état
 * initial authentique « en cours » (bouton Exporter actif, aucun état forcé).
 *
 * Nuance honnête : FLAG_SECURE protège l'APERÇU VIDÉO sur appareil réel ;
 * ici aucun flux vidéo n'existe (rendu de test JVM de la vue, pas une
 * capture d'écran contournée).
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class Lot2ExportVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    private fun brutT1(): String = ctx().assets.open("gabarits/vetements_mode/T1.json")
        .use { it.readBytes().decodeToString() }

    /** Valeurs de brief = exemples réels du JSON T1. */
    private fun valeursExemples(): Map<String, String> {
        val b = GabaritJson.parseBrief(brutT1())
        return b.fields.associate { f -> f.id to f.example }
    }

    // ---- P07-01 : aperçu du montage E7 — écran COMPLET (refonte v1 = panneau seul) ----
    @Test
    fun apercu_e7_complet() {
        val raw = brutT1()
        val resume = GabaritJson.parse(raw)
        val lignes = GabaritJson.parseCheckRows(raw)
        val valeurs = valeursExemples()
        val textes = GabaritJson.parsePreviewTexts(raw, valeurs)
        compose.setContent {
            VitrineTheme {
                VideoPreviewScreen(
                    sectorLabel = resume.secteurLibelle,
                    formatLabel = resume.nomFormatAffiche,
                    previewTexts = textes,
                    checkRows = lignes,
                    values = valeurs,
                    onCreate = { },
                )
            }
        }
        check(textes.isNotEmpty()) { "textes d'aperçu vides" }
        compose.waitUntil(5_000) {
            compose.onAllNodesWithText(textes.first(), substring = true)
                .fetchSemanticsNodes().isNotEmpty()
        }
        compose.onRoot().save("P07-01_apercu-E7-complet_APRES.png")
    }

    // ---- P07-02 : montage en cours E8 — activité réelle, état initial ----
    @Test
    fun montage_e8_en_cours() {
        val raw = brutT1()
        val resume = GabaritJson.parse(raw)
        val intent = Intent(ctx(), ExportActivity::class.java)
            .putExtra("script", resume.phraseCourte)
            .putExtra("duration_s", resume.dureeTotaleS)
        ActivityScenario.launch<ExportActivity>(intent).use { sc ->
            // Laisser la composition du panneau Compose et les coroutines d'état
            // réelles s'exécuter (looper Robolectric en mode paused).
            repeat(10) {
                org.robolectric.Shadows.shadowOf(android.os.Looper.getMainLooper()).idle()
                Thread.sleep(100)
            }
            sc.onActivity { a ->
                check(a.findViewById<Button>(R.id.export_start).isEnabled)
                check(a.findViewById<TextView>(R.id.export_status).text.isNotEmpty())
                capturerEcran(a, "P07-02_montage-E8-en-cours_APRES.png")
            }
        }
    }

    /** Rend la hiérarchie réelle de l'activité (measure + layout + draw). */
    private fun capturerEcran(activity: Activity, nom: String) {
        val decor = activity.window.decorView
        val dm = activity.resources.displayMetrics
        decor.measure(
            View.MeasureSpec.makeMeasureSpec(dm.widthPixels, View.MeasureSpec.EXACTLY),
            View.MeasureSpec.makeMeasureSpec(dm.heightPixels, View.MeasureSpec.EXACTLY),
        )
        decor.layout(0, 0, dm.widthPixels, dm.heightPixels)
        val bitmap = Bitmap.createBitmap(decor.width, decor.height, Bitmap.Config.ARGB_8888)
        decor.draw(Canvas(bitmap))
        val dir = File("build/visual-check")
        dir.mkdirs()
        File(dir, nom).outputStream().use {
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, it)
        }
    }
}

private fun SemanticsNodeInteraction.save(name: String) {
    val bitmap: Bitmap = captureToImage().asAndroidBitmap()
    val dir = File("build/visual-check")
    dir.mkdirs()
    File(dir, name).outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
}
