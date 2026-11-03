package video.vitrine.core.designsystem

import android.content.Context
import androidx.activity.ComponentActivity

/** Activite de base : applique la langue persistee avant tout gonflage de vue. */
abstract class VitrineActivity : ComponentActivity() {

    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(VitrineLocale.wrap(newBase))
    }
}
