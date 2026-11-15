package video.vitrine.feature.brief

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.view.View
import android.os.Looper
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.test.core.app.ApplicationProvider
import java.io.File
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.core.designsystem.VitrineTheme

/**
 * D42.34 P3 (Lot 10) — preuve de rendu du dialogue de choix du pays
 * (VR-078) : champ WhatsApp international D42.30.
 *
 * Chemin réel : le VRAI composable TelephoneField est rendu, le bouton pays
 * (pastille BJ + indicatif +229 — Bénin par défaut, marché initial) reçoit un
 * clic réel, le DialogueChoixPays (Compose Dialog authentique) s'ouvre avec
 * son titre, sa recherche et sa liste d'indicatifs.
 *
 * Particularité Robolectric : après le clic, le champ de recherche du dialogue
 * prend le focus et son curseur clignote (animation infinie) — Compose
 * n'atteint JAMAIS l'état idle, toute synchronisation Espresso explose
 * (AppNotIdleException). La fenêtre du dialogue est donc pollée via le main
 * looper Robolectric SANS synchronisation compose, puis rendue (measure
 * AT_MOST + layout + draw NATIF) et capturée — sur le thread du test, qui est
 * le thread d'exécution du looper sous Robolectric.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class D34Lot10BriefPaysDialogVisualCheckTest {

    @get:Rule
    val compose = createComposeRule()

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    /** Fenêtre du dialogue Compose (DialogWrapper = android.app.Dialog). */
    private fun vueDialogue(): View? {
        // piste 1 : le dernier android.app.Dialog montré (wrapper Compose)
        val dialog = runCatching {
            org.robolectric.shadows.ShadowDialog.getLatestDialog()
        }.getOrNull()
        if (dialog != null && dialog.isShowing) {
            return dialog.window?.decorView
        }
        // piste 2 : dernière vue ajoutée au WindowManager
        return runCatching {
            val cl = Class.forName("android.view.WindowManagerGlobal")
            val wmg = cl.getMethod("getInstance").invoke(null)
            @Suppress("UNCHECKED_CAST")
            val vues = cl.getMethod("getWindowViews").invoke(wmg) as List<View>
            if (vues.size < 2) null else vues.last()
        }.getOrNull()
    }

    @Test
    fun dialogue_choix_pays() {
        compose.setContent {
            VitrineTheme {
                TelephoneField(initialE164 = "", onValue = { })
            }
        }
        // Clic réel sur le bouton pays : indicatif par défaut +229 (Bénin).
        // La synchro de performClick livre le clic ; la recomposition reste
        // en attente de frames — on avance l'horloge SANS attendre l'idle
        // (le curseur du dialogue clignote indéfiniment) : recomposition →
        // Dialog.show() → fenêtre ajoutée au WindowManager.
        compose.onNodeWithText("+229").performClick()
        // Livraison du clic + ouverture du dialogue en boucle BORNÉE —
        // avancer l'horloge compose ET idler le looper, sans JAMAIS
        // exiger l'idle Espresso : dès que le dialogue s'ouvre, le curseur
        // du champ recherche clignote (animation infinie) et toute attente
        // d'idle explose (AppNotIdleException, 60 s).
        val looper = shadowOf(Looper.getMainLooper())
        var vue: View? = null
        val deadline = System.currentTimeMillis() + 30_000
        while (System.currentTimeMillis() < deadline) {
            compose.mainClock.advanceTimeBy(100)
            looper.idle()
            vue = vueDialogue()
            if (vue != null) break
            Thread.sleep(50)
        }
        check(vue != null) { "le dialogue pays ne s'est jamais ouvert" }

        // laisser la composition du contenu se terminer (quelques frames)
        repeat(5) {
            compose.mainClock.advanceTimeBy(100)
            looper.idle()
            Thread.sleep(100)
        }
        check((vue as? android.view.ViewGroup)?.childCount ?: 0 > 0) {
            "dialogue vide : composition non terminée"
        }

        // taille naturelle (wrap), comme la vraie fenêtre du dialogue
        val dm = ctx().resources.displayMetrics
        vue.measure(
            View.MeasureSpec.makeMeasureSpec(dm.widthPixels, View.MeasureSpec.AT_MOST),
            View.MeasureSpec.makeMeasureSpec(dm.heightPixels, View.MeasureSpec.AT_MOST),
        )
        vue.layout(0, 0, vue.measuredWidth, vue.measuredHeight)
        val bitmap =
            Bitmap.createBitmap(vue.measuredWidth, vue.measuredHeight, Bitmap.Config.ARGB_8888)
        vue.draw(Canvas(bitmap))
        // Vérification de contenu embarquée : le dialogue rendu n'est pas
        // vide (variance de luminance réelle sur un échantillon de pixels).
        val px = IntArray(bitmap.width * bitmap.height)
        bitmap.getPixels(px, 0, bitmap.width, 0, 0, bitmap.width, bitmap.height)
        val ech = px.filterIndexed { i, _ -> i % 97 == 0 }
        val moyenne = ech.map { (it shr 16 and 0xFF) }.average()
        val variance = ech.map { (it shr 16 and 0xFF) }.let { l ->
            l.sumOf { v -> (v - moyenne) * (v - moyenne) } / l.size
        }
        check(variance > 50.0) {
            "dialogue rendu vide ou uniforme (variance $variance) — capture non probante"
        }
        val dir = File("build/visual-check")
        dir.mkdirs()
        File(dir, "D34-27_dialogue-choix-pays_APRES.png").outputStream().use {
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, it)
        }
    }
}
