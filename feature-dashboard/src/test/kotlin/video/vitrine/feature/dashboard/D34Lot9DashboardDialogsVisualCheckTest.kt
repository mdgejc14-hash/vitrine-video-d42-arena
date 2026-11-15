package video.vitrine.feature.dashboard

import android.app.AlertDialog
import android.graphics.Bitmap
import android.graphics.Canvas
import android.view.View
import android.widget.TextView
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performScrollTo
import java.io.File
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import org.robolectric.shadows.ShadowAlertDialog

/**
 * D42.34 P3 (Lot 9) — preuves de rendu des dialogues RÉELS du dashboard
 * (VR-074→077) : changement de langue, changement de secteur, accords de
 * diffusion, nettoyage de l'espace.
 *
 * Chemin utilisateur complet, rien d'invoqué directement : la VRAIE
 * DashboardActivity est lancée, l'icône réglages (testTag dash_settings_icon)
 * est cliquée, puis la ligne-tuile correspondante (clic réel) déclenche le
 *AlertDialog.Builder authentique de l'activité. Le dialogue rendu est capturé
 * depuis SA fenêtre (decorView du dialog, measure+layout+draw NATIF 360×820).
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class D34Lot9DashboardDialogsVisualCheckTest {

    @get:Rule
    val compose = createAndroidComposeRule<DashboardActivity>()

    /** Ouvre Réglages via l'icône réelle du header dashboard. */
    private fun ouvrirReglages() {
        compose.onNodeWithTag("dash_settings_icon").performClick()
        compose.waitForIdle()
    }

    /** Capture le DERNIER AlertDialog affiché, après vérification. */
    private fun capturerDialogue(nom: String, titreAttendu: String?) {
        compose.runOnIdle {
            val dialog: AlertDialog =
                ShadowAlertDialog.getLatestAlertDialog()
                    ?: error("aucun AlertDialog affiché pour $nom")
            if (titreAttendu != null) {
                val idTitre = dialog.context.resources
                    .getIdentifier("alertTitle", "id", "android")
                val titre = if (idTitre != 0) {
                    dialog.findViewById<TextView>(idTitre)?.text
                } else {
                    null
                }
                check(titre == titreAttendu) {
                    "titre attendu \"$titreAttendu\", affiché \"$titre\""
                }
            }
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
            File(dir, nom).outputStream().use {
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, it)
            }
        }
    }

    @Test
    fun dialogue_changement_langue() {
        ouvrirReglages()
        compose.onNodeWithText(
            compose.activity.getString(R.string.set_language),
        ).performClick()
        capturerDialogue(
            "D34-23_dialogue-langue_APRES.png",
            compose.activity.getString(R.string.set_lang_dialog_title),
        )
    }

    @Test
    fun dialogue_changement_secteur() {
        ouvrirReglages()
        compose.onNodeWithText(
            compose.activity.getString(R.string.set_sector),
        ).performClick()
        capturerDialogue(
            "D34-24_dialogue-secteur_APRES.png",
            compose.activity.getString(R.string.set_sector_dialog_title),
        )
    }

    @Test
    fun dialogue_accords_diffusion() {
        ouvrirReglages()
        compose.onNodeWithText(
            compose.activity.getString(R.string.set_consents),
        ).performClick()
        capturerDialogue(
            "D34-25_dialogue-accords_APRES.png",
            compose.activity.getString(R.string.set_consents_dialog_title),
        )
    }

    @Test
    fun dialogue_nettoyage_espace() {
        ouvrirReglages()
        compose.onNodeWithText(
            compose.activity.getString(R.string.set_storage),
        ).performScrollTo().performClick()
        capturerDialogue(
            "D34-26_dialogue-nettoyage_APRES.png",
            titreAttendu = null, // dialogue de confirmation : message sans titre
        )
    }
}
