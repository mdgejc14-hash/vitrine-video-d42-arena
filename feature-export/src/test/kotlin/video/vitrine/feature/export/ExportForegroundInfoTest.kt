package video.vitrine.feature.export

import android.app.Notification
import android.app.NotificationManager
import android.content.pm.ServiceInfo
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

/**
 * D42.18 — non-régression du service de premier plan d'export.
 *
 * Défaut rc8 : le worker tournait en job JobScheduler nu, arrêté au quota
 * ~10 min (raison -512), encodage repris de zéro à chaque relance — jamais
 * de fin pour un gabarit long sur codec lent. Le correctif promeut le worker
 * en FGS dataSync (notification « Export en cours… », promesse T1).
 *
 * Ces tests verrouillent le contrat du ForegroundInfo : canal idempotent,
 * type dataSync sur API 29+, absence de type en-dessous, contenu de la
 * notification (ressources, ongoing, icône). L'exécution réelle sans
 * interruption est validée par le run de qualification CI (E2E).
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class ExportForegroundInfoTest {

    private val app: android.app.Application = RuntimeEnvironment.getApplication()

    @Test
    fun `canal cree puis idempotent`() {
        ensureExportChannel(app)
        ensureExportChannel(app) // deuxième appel : ne doit rien casser ni dupliquer
        val manager = app.getSystemService(NotificationManager::class.java)
        val canal = manager.getNotificationChannel(EXPORT_CHANNEL_ID)
        assertNotNull("le canal vv_export doit exister", canal)
        assertEquals(
            "nom du canal issu des ressources",
            app.getString(R.string.export_notif_channel_name),
            canal.name,
        )
        assertEquals(
            "importance faible (silencieux, ne pas réveiller l'utilisateur)",
            NotificationManager.IMPORTANCE_LOW,
            canal.importance,
        )
    }

    @Test
    fun `foreground info type data_sync sur api 29+`() {
        val info = createExportForegroundInfo(app)
        assertEquals(
            "type de service de premier plan exigé sur API 34+",
            ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC,
            info.foregroundServiceType,
        )
        assertEquals(
            "identifiant de notification stable",
            EXPORT_NOTIF_ID,
            info.notificationId,
        )
    }

    @Test
    fun `notification contenu ongoing et icone`() {
        val info = createExportForegroundInfo(app)
        val n: Notification = info.notification
        assertEquals(
            "titre issu des ressources",
            app.getString(R.string.export_notif_title),
            n.extras.getCharSequence(Notification.EXTRA_TITLE),
        )
        assertEquals(
            "texte issu des ressources",
            app.getString(R.string.export_notif_text),
            n.extras.getCharSequence(Notification.EXTRA_TEXT),
        )
        assertTrue(
            "notification ongoing (non balayable pendant l'export)",
            (n.flags and Notification.FLAG_ONGOING_EVENT) != 0,
        )
        assertNotNull("petite icône présente (ic_stat_export)", n.smallIcon)
    }

    /** Avant API 29, ForegroundInfo se construit sans type (garde de version). */
    @Test
    @Config(sdk = [28])
    fun `foreground info sans type avant api 29`() {
        val info = createExportForegroundInfo(app)
        assertEquals("aucun type attendu avant Q", 0, info.foregroundServiceType)
        assertEquals(EXPORT_NOTIF_ID, info.notificationId)
    }
}
