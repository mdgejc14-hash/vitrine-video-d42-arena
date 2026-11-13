package video.vitrine.feature.catalog

import android.os.Bundle
import video.vitrine.core.designsystem.VitrineActivity
import androidx.activity.compose.setContent
import video.vitrine.core.designsystem.VitrineTheme
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import video.vitrine.core.model.CatalogManifest
import video.vitrine.core.model.GabaritSummary
import video.vitrine.core.model.Sector
import video.vitrine.core.model.Skin
import video.vitrine.data.audio.BgmStore
import video.vitrine.data.gabarits.GabaritRepository
import video.vitrine.data.local.VitrineLocalDatabase

/**
 * Ecran 5 (catalogue lazy B2, 180 skins sans recompiler). Canal canary :
 * intent extra "canary" (testeurs internes) ; flags serveur branches en P6.
 */
class CatalogActivity : VitrineActivity() {

    /** Cache definitif BGM : prefetch au choix du gabarit, jamais bloquant (D19/D22). */
    private val bgmStore by lazy { BgmStore(this, BuildConfig.API_BASE_URL) }
    private var firebaseToken: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        firebaseToken = intent.getStringExtra("firebase_token")
        val repository = CatalogRepository(this, BuildConfig.API_BASE_URL)
        val gabaritRepository = GabaritRepository(this, VitrineLocalDatabase.get(this).gabarits())
        val canary = intent.getBooleanExtra("canary", false)
        val initialSector = Sector.fromCodeOrNull(intent.getStringExtra("sector"))
        setContent {
            VitrineTheme {
                var manifest by remember { mutableStateOf<CatalogManifest?>(null) }
                var offline by remember { mutableStateOf(false) }
                var failed by remember { mutableStateOf(false) }
                var gabarits by remember { mutableStateOf<List<GabaritSummary>>(emptyList()) }
                LaunchedEffect(Unit) {
                    // D42.32 (Lot 4) : catalogue en EN si langue choisie
                    // (JSON canonique FR intact, traduction à la lecture).
                    val langue = video.vitrine.core.designsystem.VitrineLocale.saved(this@CatalogActivity)
                    gabarits = runCatching {
                        gabaritRepository.summaries().map { g ->
                            video.vitrine.data.i18n.GabaritUiL10n.traduireSummary(
                                g,
                                video.vitrine.data.i18n.GabaritUiL10n.traductions(
                                    this@CatalogActivity, langue, g.id
                                )
                            )
                        }
                    }.getOrDefault(emptyList())
                }
                LaunchedEffect(canary) {
                    runCatching { repository.load(canary) }
                        .onSuccess { (loaded, fromCache) ->
                            manifest = loaded
                            offline = fromCache
                        }
                        .onFailure { failed = true }
                }
                // Audit D40 (B6) : l'echec du manifeste skins (reseau OU 404
                // serveur) ne masque PLUS les 30 gabarits universels — ils sont
                // 100 % locaux (Room/assets) et restent le catalogue principal.
                // Bandeau honnete au lieu d'un ecran blocant (D19).
                Column {
                    if (failed) {
                        // D41 (F44) : bandeau traduit x4 (FR en dur avant).
                        Text(
                            stringResource(R.string.catalog_skins_unavailable),
                            modifier = Modifier.padding(12.dp),
                        )
                    }
                    CatalogScreen(
                        manifest,
                        offline || failed,
                        initialSector,
                        onSkinClick = { skin -> pick(skin) },
                        gabarits = gabarits,
                        onGabaritClick = { g -> pickGabarit(g) },
                    )
                }
            }
        }
    }

    private fun pickGabarit(gabarit: GabaritSummary) {
        // Le gabarit choisi determine la musique de fond (Phase C) : prefetch
        // DEFINITIF (files/bgm), silencieux hors-ligne, navigation non bloquee.
        bgmStore.prefetchForGabarit(gabarit.id, firebaseToken)
        setResult(
            RESULT_OK,
            android.content.Intent()
                .putExtra("gabarit_id", gabarit.id)
                .putExtra("gabarit_name", gabarit.nomFormatAffiche)
                .putExtra("skin_id", gabarit.id)
                .putExtra("skin_name", gabarit.nomFormatAffiche)
        )
        finish()
    }

    private fun pick(skin: Skin) {
        setResult(
            RESULT_OK,
            android.content.Intent()
                .putExtra("skin_id", skin.id)
                .putExtra("skin_name", skin.name)
        )
        finish()
    }
}
