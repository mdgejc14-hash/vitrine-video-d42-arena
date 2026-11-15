package video.vitrine.app

import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.view.View
import android.widget.TextView
import androidx.test.core.app.ActivityScenario
import androidx.test.core.app.ApplicationProvider
import kotlinx.coroutines.runBlocking
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import org.robolectric.shadows.ShadowAlertDialog
import android.os.Looper
import java.io.File

/**
 * D42.34 P3 (Lot 11) — preuve de rendu du dialogue de reprise de brouillon
 * (VR-062, D42.27).
 *
 * Chemin réel : un brouillon VRAI est persisté via l'API réelle du DraftStore
 * (sauverBrief, étape BRIEF), puis la VRAIE MainActivity est lancée avec
 * l'entrée explicite « Reprendre » du dashboard (extra vv_reprise, D42.33
 * §9.3). peutProposerReprise() lit le brouillon actif et montre le dialogue
 * authentique : « Reprendre ta vidéo ? » + corps + Reprendre/Nouvelle vidéo.
 *
 * Capture : fenêtre du dialogue (decorView, measure+layout+draw NATIF 360×820)
 * après vérification du titre réel.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class D34Lot11RepriseDialogVisualCheckTest {

    @Test
    fun dialogue_reprise_brouillon() {
        val context: Context = ApplicationProvider.getApplicationContext()
        // Brouillon RÉEL via l'API du DraftStore (étape BRIEF, gabarit shops T1)
        runBlocking {
            video.vitrine.data.local.DraftStore.sauverBrief(
                context,
                "shops_small_business_t1",
                null,
                "Boutique",
                mapOf("offre_prix" to "5000"),
            )
        }
        val intent = Intent(context, MainActivity::class.java)
            .putExtra("vv_reprise", true)
        ActivityScenario.launch<MainActivity>(intent).use {
            val looper = shadowOf(Looper.getMainLooper())
            var dialog: AlertDialog? = null
            val deadline = System.currentTimeMillis() + 30_000
            while (System.currentTimeMillis() < deadline) {
                looper.idle()
                dialog = ShadowAlertDialog.getLatestAlertDialog()
                if (dialog != null && dialog.isShowing) break
                Thread.sleep(100)
            }
            check(dialog != null && dialog.isShowing) {
                "dialogue de reprise jamais affiché (VR-062)"
            }
            // titre réel du dialogue
            val idTitre = dialog.context.resources
                .getIdentifier("alertTitle", "id", "android")
            val titre = if (idTitre != 0) {
                dialog.findViewById<TextView>(idTitre)?.text
            } else {
                null
            }
            check(titre == context.getString(R.string.draft_resume_title)) {
                "titre attendu \"${context.getString(R.string.draft_resume_title)}\", " +
                    "affiché \"$titre\""
            }
            // rendu réel de la fenêtre dialogue
            val decor = dialog.window!!.decorView
            val dm = dialog.context.resources.displayMetrics
            decor.measure(
                View.MeasureSpec.makeMeasureSpec(dm.widthPixels, View.MeasureSpec.EXACTLY),
                View.MeasureSpec.makeMeasureSpec(dm.heightPixels, View.MeasureSpec.EXACTLY),
            )
            decor.layout(0, 0, dm.widthPixels, dm.heightPixels)
            val bitmap = Bitmap.createBitmap(decor.width, decor.height, Bitmap.Config.ARGB_8888)
            decor.draw(Canvas(bitmap))
            val dir = File("build/visual-check")
            dir.mkdirs()
            File(dir, "D34-28_dialogue-reprise_APRES.png").outputStream().use {
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, it)
            }
        }
    }
}
