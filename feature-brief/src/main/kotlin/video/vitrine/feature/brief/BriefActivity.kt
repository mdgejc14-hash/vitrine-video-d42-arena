package video.vitrine.feature.brief

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.lifecycle.lifecycleScope
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import kotlinx.coroutines.launch
import video.vitrine.data.gabarits.GabaritRepository
import video.vitrine.data.gabarits.GabaritJson
import video.vitrine.data.local.VitrineLocalDatabase
import video.vitrine.core.model.GabaritBrief
import video.vitrine.core.designsystem.VitrineActivity
import video.vitrine.core.designsystem.VitrineTheme

/**
 * Ecran 6 : brief script-first ; le JSON du brief part au worker (ko, regle d'or).
 * Les rushs video du client sont choisis ici (documents persistants) : c'est eux
 * que le moteur motion assemblera selon le beat sheet.
 */
class BriefActivity : VitrineActivity() {

    private val rushs = mutableListOf<Uri>()

    private val pickRushs = registerForActivityResult(
        ActivityResultContracts.OpenMultipleDocuments()
    ) { uris ->
        uris.forEach { uri ->
            runCatching {
                contentResolver.takePersistableUriPermission(
                    uri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION
                )
            }
            rushs += uri
        }
        refresh()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val gabaritId = intent.getStringExtra("gabarit_id")
        if (gabaritId != null) {
            val repo = GabaritRepository(this, VitrineLocalDatabase.get(this).gabarits())
            lifecycleScope.launch {
                val raw = runCatching { repo.rawJson(gabaritId) }.getOrNull()
                val brief = raw?.let { runCatching { GabaritJson.parseBrief(it) }.getOrNull() }
                if (brief != null) renderGabarit(brief, raw.orEmpty()) else refresh()
            }
        } else {
            refresh()
        }
    }

    /** E5 V2.0 : formulaire pilote gabarit ; reponses renvoyees en extras cles/valeurs. */
    /** E5 puis E4b : formulaire gabarit, recapitulatif de verification, puis extras. */
    private fun renderGabarit(brief: GabaritBrief, raw: String) {
        val summary = runCatching { GabaritJson.parse(raw) }.getOrNull()
        val prisesCount = runCatching { GabaritJson.parsePrises(raw) }
            .getOrDefault(emptyList()).size
        setContent {
            VitrineTheme {
                var ready by remember { mutableStateOf(false) }
                var answers by remember { mutableStateOf<Map<String, String>>(emptyMap()) }
                if (!ready) {
                    GabaritBriefScreen(brief) { values ->
                        answers = values
                        ready = true
                    }
                } else {
                    ReadyCheckScreen(
                        sectorLabel = summary?.secteurLibelle.orEmpty(),
                        formatLabel = summary?.nomFormatAffiche.orEmpty(),
                        prisesCount = prisesCount,
                        infos = answers.values.filter { it.isNotBlank() }.take(3).joinToString(" · "),
                        onOk = {
                            val intent = Intent()
                            answers.forEach { (k, v) -> intent.putExtra("brief_$k", v) }
                            intent.putExtra("brief_keys", answers.keys.toTypedArray())
                            setResult(RESULT_OK, intent)
                            finish()
                        },
                    )
                }
            }
        }
    }

    private fun refresh() {
        setContent {
            VitrineTheme {
                BriefScreen(
                    rushCount = rushs.size,
                    onAddRushs = { pickRushs.launch(arrayOf("video/*")) }
                ) { script, duration, objective ->
                    val scenes = BriefValidator.splitScenes(script).joinToString(SEP)
                    setResult(
                        RESULT_OK,
                        Intent()
                            .putExtra("script", script)
                            .putExtra("duration_s", duration)
                            .putExtra("objective", objective)
                            .putExtra("scenes", scenes)
                            .putExtra("client_rushes", rushs.map(Uri::toString).toTypedArray())
                    )
                    finish()
                }
            }
        }
    }

    private companion object {
        const val SEP = " | "
    }
}
