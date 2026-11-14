package video.vitrine.feature.camera

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.os.Looper
import android.view.View
import android.widget.Button
import androidx.test.core.app.ActivityScenario
import androidx.test.core.app.ApplicationProvider
import java.io.File
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Shadows.shadowOf
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode

/**
 * Lot 2 D42.33 v2 — écran de tournage COMPLET (PreviewView + HUD Compose +
 * barre de commandes XML) et écran Diagnostic caméra, rendus par l'activité
 * réelle. Aucune vue modifiée par le test : lancement, attente de l'état
 * réel (prises chargées depuis le JSON), capture du décor.
 *
 * Limites honnêtes : Robolectric n'a NI caméra (PreviewView vide) NI clavier ;
 * la permission CAMÉRA n'est pas accordée (aucun bindCamera — comportement de
 * lancement réel sur appareil sans permission).
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class Lot2CameraActivityVisualCheckTest {

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

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

    /**
     * P05-09 : écran complet en mode gabarit — le HUD Compose affiche la
     * prise guide ET la barre XML porte Refaire / Tourner / Suivant (les
     * commandes avant/arrière de prise + bascule caméra).
     */
    @Test
    fun ecran_complet_commandes() {
        val intent = Intent(ctx(), CameraGuideActivity::class.java)
            .putExtra("gabarit_id", "vetements_mode_T1")
            .putExtra("duration_s", 36)
        ActivityScenario.launch<CameraGuideActivity>(intent).use { sc ->
            val fin = System.currentTimeMillis() + 30_000
            var boutonsPrets = false
            while (System.currentTimeMillis() < fin && !boutonsPrets) {
                shadowOf(Looper.getMainLooper()).idle()
                sc.onActivity { a ->
                    boutonsPrets =
                        a.findViewById<Button>(R.id.camera_redo_button).visibility == View.VISIBLE
                }
                if (!boutonsPrets) Thread.sleep(150)
            }
            check(boutonsPrets) { "prises du gabarit non chargées (seed DB absent)" }
            // Laisser la recomposition du HUD Compose se terminer.
            repeat(4) {
                shadowOf(Looper.getMainLooper()).idle()
                Thread.sleep(100)
            }
            sc.onActivity { a ->
                check(
                    a.findViewById<Button>(R.id.camera_record_button).text.isNotEmpty()
                )
                capturerEcran(a, "P05-09_ecran-complet-commandes_APRES.png")
            }
        }
    }

    /**
     * P05-10 : reprise de la scène — clic RÉEL sur « Refaire » une fois la
     * prise validée : l'activité repasse en attente d'une nouvelle prise de
     * la même scène (redoCurrentPrise, barre neutralisée pendant la prise).
     */
    @Test
    fun reprise_de_scene() {
        val intent = Intent(ctx(), CameraGuideActivity::class.java)
            .putExtra("gabarit_id", "vetements_mode_T1")
            .putExtra("duration_s", 36)
        ActivityScenario.launch<CameraGuideActivity>(intent).use { sc ->
            val fin = System.currentTimeMillis() + 30_000
            var boutonsPrets = false
            while (System.currentTimeMillis() < fin && !boutonsPrets) {
                shadowOf(Looper.getMainLooper()).idle()
                sc.onActivity { a ->
                    boutonsPrets =
                        a.findViewById<Button>(R.id.camera_redo_button).visibility == View.VISIBLE
                }
                if (!boutonsPrets) Thread.sleep(150)
            }
            check(boutonsPrets) { "prises du gabarit non chargées (seed DB absent)" }
            sc.onActivity { a ->
                a.findViewById<Button>(R.id.camera_redo_button).performClick()
            }
            repeat(6) {
                shadowOf(Looper.getMainLooper()).idle()
                Thread.sleep(100)
            }
            sc.onActivity { a ->
                check(a.findViewById<Button>(R.id.camera_record_button).isEnabled) {
                    "la prise n'est pas repassée en attente après « Refaire »"
                }
                capturerEcran(a, "P05-10_reprise-de-scene_APRES.png")
            }
        }
    }

    /**
     * P05-13 : Diagnostic caméra — état honnête « permission refusée »
     * (lancement réel sans permission accordée : la vue statut affiche le
     * message de refus, cf. CameraDiagnosticActivity.onCreate).
     */
    @Test
    fun diagnostic_permission_refusee() {
        ActivityScenario.launch(CameraDiagnosticActivity::class.java).use { sc ->
            sc.onActivity { a -> capturerEcran(a, "P05-13_diagnostic-permission-refusee_APRES.png") }
        }
    }
}
