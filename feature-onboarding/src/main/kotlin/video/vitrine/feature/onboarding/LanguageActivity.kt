package video.vitrine.feature.onboarding

import android.os.Bundle
import androidx.activity.compose.setContent
import video.vitrine.core.designsystem.VitrineLocale
import video.vitrine.core.designsystem.VitrineActivity
import video.vitrine.core.designsystem.VitrineTheme

/** Premiere ouverture : selection de langue puis retour au navigateur. */
class LanguageActivity : VitrineActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            VitrineTheme {
                LanguageScreen { code ->
                    VitrineLocale.save(this, code)
                    setResult(RESULT_OK)
                    finish()
                }
            }
        }
    }
}
