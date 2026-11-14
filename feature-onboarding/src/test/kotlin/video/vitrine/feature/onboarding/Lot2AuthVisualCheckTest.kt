package video.vitrine.feature.onboarding

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.view.View
import android.widget.TextView
import androidx.test.core.app.ActivityScenario
import androidx.test.core.app.ApplicationProvider
import java.io.File
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import video.vitrine.feature.onboarding.auth.AuthActivity

/**
 * Lot 2 D42.33 v2 — écran de connexion (AuthActivity, layout XML repeint).
 * Capture de la vue DÉCOR réelle : measure + layout + draw (Robolectric ne
 * déclenche pas le layout automatiquement). État au repos authentique —
 * aucune vue modifiée par le test.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class Lot2AuthVisualCheckTest {

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    /** Rend la hiérarchie réelle de l'activité dans un PNG (écran complet). */
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

    // ---- P01-05 (+ P01-07 : repli hors-ligne TOUJOURS visible à l'écran) ----
    @Test
    fun connexion_fr() {
        ActivityScenario.launch(AuthActivity::class.java).use { sc ->
            sc.onActivity { a ->
                check(a.findViewById<TextView>(R.id.auth_status).text.isNotEmpty())
                capturerEcran(a, "P01-05_connexion-fr_APRES.png")
            }
        }
    }

    // ---- P01-06 : connexion EN ----
    @Test
    @Config(sdk = [34], qualifiers = "en-w360dp-h820dp")
    fun connexion_en() {
        ActivityScenario.launch(AuthActivity::class.java).use { sc ->
            sc.onActivity { a ->
                check(a.findViewById<TextView>(R.id.auth_status).text.isNotEmpty())
                capturerEcran(a, "P01-06_connexion-en_APRES.png")
            }
        }
    }

    // ---- P01-08 : code parrain DÉTECTÉ (deep-link /r/CODE → statut dédié) ----
    @Test
    fun connexion_code_parrain_detecte() {
        val intent = Intent(ctx(), AuthActivity::class.java)
            .putExtra("ref_code", "SHALOM-842")
        ActivityScenario.launch<AuthActivity>(intent).use { sc ->
            sc.onActivity { a ->
                check(
                    a.findViewById<TextView>(R.id.auth_status).text
                        .toString().contains("SHALOM-842")
                )
                capturerEcran(a, "P01-08_connexion-code-parrain-detected_APRES.png")
            }
        }
    }
}
