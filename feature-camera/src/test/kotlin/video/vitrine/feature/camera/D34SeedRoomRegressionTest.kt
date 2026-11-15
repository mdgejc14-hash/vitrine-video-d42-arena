package video.vitrine.feature.camera

import android.content.Context
import androidx.test.core.app.ApplicationProvider
import kotlinx.coroutines.runBlocking
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import video.vitrine.data.gabarits.GabaritRepository
import video.vitrine.data.local.VitrineLocalDatabase

/**
 * D42.34 (CR-3, non-régression CI) : le seed Room doit fonctionner dans les
 * DEUX formes de listing d'assets — dossiers nus (appareil réel) et chemins
 * relatifs « secteur/T*.json » (Robolectric). Avant la correction, le seed
 * insérait 0 ligne en Robolectric : rawJson null → guide caméra sans prises
 * (l'ancien test d'activité passait à tort sur des boutons visibles par
 * défaut au XML).
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class D34SeedRoomRegressionTest {

    @Test
    fun seed_rawJson_disponible_en_robolectric_comme_sur_appareil() {
        val ctx: Context = ApplicationProvider.getApplicationContext()
        val repo = GabaritRepository(ctx, VitrineLocalDatabase.get(ctx).gabarits())
        val raw = runBlocking { repo.rawJson("vetements_mode_T1") }
        check(!raw.isNullOrBlank()) { "seed Room vide : listing Robolectric non couvert" }
        check(raw.contains("vetements_mode_T1")) { "rawJson ne correspond pas au gabarit demandé" }
        val resumes = runBlocking { repo.summaries() }
        check(resumes.size == 30) { "attendu 30 gabarits seedés, trouvé ${resumes.size}" }
    }
}
