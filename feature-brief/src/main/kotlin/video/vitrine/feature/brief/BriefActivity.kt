package video.vitrine.feature.brief

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.coroutines.withContext
import androidx.compose.runtime.collectAsState
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

    /**
     * D42.27-05b : la persistance de la saisie DOIT être sérialisée — un
     * launch(IO) par frappe produisait des écritures Room DÉSORDONNÉES
     * (constat banc drafts : « BoutiqueAwa » saisi, brouillon « Boutiq »).
     * collectLatest : toute écriture obsolète est ANNULÉE dès qu'une valeur
     * plus récente arrive — la DERNIÈRE valeur gagne TOUJOURS.
     */
    private val saisieFlow = MutableStateFlow<Map<String, String>>(emptyMap())
    private val verrouSauvegarde = Mutex()

    private val rushs = mutableListOf<Uri>()

    // D42.34 (CR-2, P0 ④) : import de rushs existants dans le PARCOURS
    // GABARIT (témoignages T5 en priorité). Slots alignés sur prises[] :
    // 1 prise = 1 média, jamais de concaténation aveugle côté moteur.
    private val rushSlotsImport = MutableStateFlow<List<String>>(emptyList())
    private var prisesImport: List<video.vitrine.core.model.PriseGuide> = emptyList()

    private val pickRushsGabarit = registerForActivityResult(
        ActivityResultContracts.OpenMultipleDocuments()
    ) { uris ->
        if (uris.isNotEmpty()) {
            uris.forEach { uri ->
                runCatching {
                    contentResolver.takePersistableUriPermission(
                        uri,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION
                    )
                }
            }
            ajouterRushsImportes(uris)
        }
    }

    /** Chaque média choisi remplit le PREMIER slot libre (1 prise = 1 média). */
    private fun ajouterRushsImportes(nouveaux: List<Uri>) {
        if (prisesImport.isEmpty()) return
        val slots = rushSlotsImport.value.toMutableList()
        while (slots.size < prisesImport.size) slots.add("")
        for (uri in nouveaux) {
            val libre = slots.indexOfFirst { it.isBlank() }
            if (libre < 0) break // tous les slots sont pleins : on ignore le surplus
            slots[libre] = uri.toString()
        }
        rushSlotsImport.value = slots.take(prisesImport.size)
        persisterSlotsImport()
    }

    /** « Retirer » : vide le slot (le guide caméra pourra re-filmer la prise). */
    private fun viderSlotImport(index: Int) {
        val slots = rushSlotsImport.value.toMutableList()
        if (index in slots.indices) {
            slots[index] = ""
            rushSlotsImport.value = slots
            persisterSlotsImport()
        }
    }

    /**
     * Persistance à l'étape BRIEF via la clé réservée du brouillon existant
     * (aucune migration Room) — les slots survivent à une fermeture de l'app
     * pendant la saisie, comme les champs.
     */
    private fun persisterSlotsImport() {
        saisieFlow.value = (saisieFlow.value - video.vitrine.core.model.RushsImport.CLE_SLOTS) +
            (
                video.vitrine.core.model.RushsImport.CLE_SLOTS to
                    video.vitrine.core.model.RushsImport.serialiser(rushSlotsImport.value)
                )
    }

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
        // D42.27-05b : un SEUL collecteur sérialise toutes les sauvegardes.
        // Mutex + relecture de saisieFlow.value sous verrou : même si une
        // écriture en retard commit après une plus récente, CHAQUE écriture
        // porte la valeur la plus récente au moment où elle obtient le
        // verrou — la dernière valeur gagne TOUJOURS, sans fenêtre de course.
        lifecycleScope.launch {
            saisieFlow.collectLatest {
                verrouSauvegarde.withLock {
                    val valeurs = saisieFlow.value
                    if (valeurs.isEmpty()) return@withLock
                    withContext(Dispatchers.IO) {
                        runCatching {
                            video.vitrine.data.local.DraftStore.sauverBrief(
                                this@BriefActivity,
                                intent.getStringExtra("gabarit_id").orEmpty(),
                                intent.getStringExtra("skin_id"),
                                intent.getStringExtra("skin_name"),
                                valeurs
                            )
                        }
                    }
                }
            }
        }
        val gabaritId = intent.getStringExtra("gabarit_id")
        if (gabaritId != null) {
            val repo = GabaritRepository(this, VitrineLocalDatabase.get(this).gabarits())
            lifecycleScope.launch {
                val raw = runCatching { repo.rawJson(gabaritId) }.getOrNull()
                // D42.32 (Lot 4) : brief en EN si langue choisie (overlay stable).
                val t = video.vitrine.data.i18n.GabaritUiL10n.traductions(
                    this@BriefActivity,
                    video.vitrine.core.designsystem.VitrineLocale.saved(this@BriefActivity),
                    gabaritId
                )
                val brief = raw?.let { runCatching { GabaritJson.parseBrief(it, t) }.getOrNull() }
                // D42.27 (§7) : valeurs du brouillon de saisie pour CE gabarit
                // (pré-remplissage — reprise après fermeture pendant la rédaction).
                val restore = runCatching {
                    video.vitrine.data.local.DraftStore.valuesPourGabarit(this@BriefActivity, gabaritId)
                }.getOrDefault(emptyMap())
                if (brief != null) renderGabarit(brief, raw.orEmpty(), restore, t) else refresh()
            }
        } else {
            refresh()
        }
    }

    /** E5 V2.0 : formulaire pilote gabarit ; reponses renvoyees en extras cles/valeurs. */
    /** E5 puis E4b : formulaire gabarit, recapitulatif de verification, puis extras. */
    private fun renderGabarit(
        brief: GabaritBrief,
        raw: String,
        restore: Map<String, String> = emptyMap(),
        t: org.json.JSONObject? = null
    ) {
        val summary = runCatching { GabaritJson.parse(raw, t) }.getOrNull()
        val prises = runCatching { GabaritJson.parsePrises(raw, t) }
            .getOrDefault(emptyList())
        prisesImport = prises
        // D42.34 (CR-2) : import proposé UNIQUEMENT pour les gabarits qui le
        // demandent — témoignage client (T5, « Un client raconte », les 6
        // secteurs). Les autres formats se tournent intégralement au guide
        // (politique_saisie.mode = saisie_video).
        val importAutorise = summary?.format?.startsWith("T5_") == true && prises.isNotEmpty()
        // Restauration brouillon : slots importés persistés à l'étape BRIEF
        // (clé réservée), champs saisis — la clé ne fuit jamais dans le
        // formulaire (retirée avant affichage et avant le résultat).
        val slotsRestaures = video.vitrine.core.model.RushsImport.deserialiser(
            restore[video.vitrine.core.model.RushsImport.CLE_SLOTS],
            prises.size
        )
        if (importAutorise) rushSlotsImport.value = slotsRestaures
        val champsRestaures = restore - video.vitrine.core.model.RushsImport.CLE_SLOTS
        val prisesCount = prises.size
        setContent {
            VitrineTheme {
                val rushSlots by rushSlotsImport.collectAsState()
                var ready by remember { mutableStateOf(false) }
                var answers by remember { mutableStateOf<Map<String, String>>(emptyMap()) }
                if (!ready) {
                    // D42.27 (§7) : pré-remplissage (brouillon) + persistance de
                    // la saisie à CHAQUE champ (étape BRIEF du brouillon).
                    GabaritBriefScreen(
                        brief = brief,
                        initialValues = champsRestaures,
                        onValuesChange = { valeurs ->
                            saisieFlow.value = valeurs + (
                                video.vitrine.core.model.RushsImport.CLE_SLOTS to
                                    video.vitrine.core.model.RushsImport.serialiser(rushSlots)
                                )
                        },
                        prisesPourImport = if (importAutorise) prises else emptyList(),
                        rushSlots = rushSlots,
                        onImportRush = {
                            pickRushsGabarit.launch(arrayOf("video/*"))
                        },
                        onClearRush = { viderSlotImport(it) },
                        onSubmit = { values ->
                            answers = values
                            ready = true
                        }
                    )
                } else {
                    ReadyCheckScreen(
                        sectorLabel = summary?.secteurLibelle.orEmpty(),
                        formatLabel = summary?.nomFormatAffiche.orEmpty(),
                        prisesCount = prisesCount,
                        infos = answers.values.filter { it.isNotBlank() }.take(3).joinToString(" · "),
                        onOk = {
                            // D42.34 (CR-2) : la clé réservée des slots ne fuit
                            // jamais dans les extras brief_* du résultat.
                            val reponse = answers - video.vitrine.core.model.RushsImport.CLE_SLOTS
                            val intent = Intent()
                            reponse.forEach { (k, v) -> intent.putExtra("brief_$k", v) }
                            intent.putExtra("brief_keys", reponse.keys.toTypedArray())
                            // D42.27-05d : le parcours gabarit ne renvoyait AUCUN
                            // « script » — le brouillon promu CAMÉRA gardait un
                            // script vide et la reprise retombait en BRIEF (run
                            // 42635563154 : scriptNonVide=false priseIdx=1). Le
                            // script du brouillon = les libellés des prises du
                            // gabarit (exactement les scènes que le guide fera
                            // tourner), joints comme le parcours générique.
                            val scenesGabarit = runCatching { GabaritJson.parsePrises(raw, t) }
                                .getOrDefault(emptyList())
                            intent.putExtra("script", scenesGabarit.joinToString(" | ") { it.label })
                            intent.putExtra("duration_s", summary?.dureeTotaleS ?: 30)
                            // D42.34 (CR-2) : rushs importés ALIGNÉS PAR SLOT
                            // (taille = prises.size, "" sinon) — même contrat
                            // que le résultat caméra (finishWithPrises). La
                            // fusion filmée > importée se fait dans MainActivity.
                            if (prisesImport.isNotEmpty()) {
                                val slots = List(prisesImport.size) { i ->
                                    rushSlotsImport.value.getOrNull(i).orEmpty()
                                }
                                intent.putExtra("client_rushes", slots.toTypedArray())
                            }
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
