package video.vitrine.ins.effects

import android.net.Uri
import androidx.media3.common.Effect
import androidx.media3.common.MediaItem
import androidx.media3.common.util.UnstableApi
import androidx.media3.transformer.Composition
import androidx.media3.transformer.EditedMediaItem
import androidx.media3.transformer.EditedMediaItemSequence
import androidx.media3.transformer.Effects
import com.google.common.collect.ImmutableList

/**
 * Assemblage deterministe multi-rushs : le client fournit ses rushes, le beat sheet
 * (timecodes Whisper) dicte l'ordre, les bornes, la cinematique et la typographie.
 * Un plan = un EditedMediaItem clippe sur [in_t, in_t + duree] dans le rush rid,
 * le tout concatene dans une EditedMediaItemSequence (Media3 1.11).
 * Meme beat sheet + memes rushes = meme film (rendu reproductible).
 */
@UnstableApi
object MotionComposition {

    private const val MILLI = 1000.0

    fun fromClientRushes(
        rushUris: List<Uri>,
        sheet: MotionJson.BeatSheet,
        globalVideoEffects: List<Effect> = emptyList(),
        geometry: ExportSpec.ExportGeometry = ExportSpec.ExportGeometry(1080, 1920)
    ): Composition {
        require(rushUris.isNotEmpty()) { "motion : aucun rush client" }
        val items = sheet.plans.mapIndexed { index, plan ->
            val rushIndex =
                if (plan.rushIndex >= 0) plan.rushIndex % rushUris.size else index % rushUris.size
            val clipping = MediaItem.ClippingConfiguration.Builder()
                .setStartPositionMs((plan.inT * MILLI).toLong())
                .setEndPositionMs(((plan.inT + (plan.t1 - plan.t0)) * MILLI).toLong())
                .build()
            val mediaItem = MediaItem.Builder()
                .setUri(rushUris[rushIndex])
                .setClippingConfiguration(clipping)
                .build()
            val dureePlan = (plan.t1 - plan.t0).coerceAtLeast(0.0)
            val localWords = sheet.words
                .filter { it.endS > plan.t0 && it.startS < plan.t1 }
                // D42-F15 : un texte qui COMMENCE avant le plan (ou finit apres)
                // donnait un horodatage NEGATIF apres rebasage -> TimestampWrapper
                // levait « startTimeUs and endTimeUs must be non-negative » et
                // TOUT rendu multi-rush echouait (constate au run 41591615084).
                // On borne au plan : jamais negatif, jamais au-dela de sa duree.
                .map {
                    val debut = (it.startS - plan.t0).coerceIn(0.0, dureePlan)
                    val fin = (it.endS - plan.t0).coerceIn(debut, dureePlan)
                    it.copy(startS = debut, endS = fin)
                }
                .filter { it.endS > it.startS + 1e-3 }
            // Audit D40 (B4) : les effets Media3 d'un EditedMediaItem recoivent des
            // horodatages RELATIFS a l'item — le plan est rebasé avant CameraMoves
            // (sinon zoom figé et transitions jamais fenêtrées au-delà du plan 0).
            val localPlan = plan.copy(t0 = 0.0, t1 = plan.t1 - plan.t0)
            val videoEffects = ImmutableList.builder<Effect>()
                .addAll(globalVideoEffects)
                .addAll(CameraMoves.effectsFor(localPlan))
                .addAll(
                    KineticTypography.wordOverlays(
                        localWords, sheet.keywords, geometry.width, geometry.height
                    )
                )
                .build()
            EditedMediaItem.Builder(mediaItem)
                .setEffects(Effects(ImmutableList.of(), videoEffects))
                .build()
        }
        val sequence = EditedMediaItemSequence.Builder().addItems(items).build()
        return Composition.Builder(listOf(sequence)).build()
    }
}
