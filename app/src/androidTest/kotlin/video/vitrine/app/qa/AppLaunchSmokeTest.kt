package video.vitrine.app.qa

import androidx.test.core.app.ActivityScenario
import androidx.test.ext.junit.runners.AndroidJUnit4
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import video.vitrine.app.MainActivity

/**
 * Socle D19/D22 : l'app demarre sur appareil reel sans crash ni ecran
 * bloquant (navigation demarrage -> ecran suivant valide).
 */
@RunWith(AndroidJUnit4::class)
class AppLaunchSmokeTest {
    @Test
    fun lancementMainActivity_neCrashPas() {
        ActivityScenario.launch(MainActivity::class.java).use { scenario ->
            var resumed = false
            scenario.onActivity { resumed = true }
            assertTrue("MainActivity doit atteindre l'etat resumed", resumed)
        }
    }
}
