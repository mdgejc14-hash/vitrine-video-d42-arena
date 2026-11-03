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
            val localWords = sheet.words
                .filter { it.endS > plan.t0 && it.startS < plan.t1 }
                // D42.2 — CAUSE RACINE DE « aucun texte » : le rebasage.
                //
                // Le code rebasait chaque mot sur son plan (t0 -> 0). Or Media3
                // evalue les TimestampWrapper sur la timeline GLOBALE, pas sur
                // le temps relatif de l'item : tous les mots de tous les plans
                // tombaient donc dans la premiere seconde. Preuves visuelles :
                //  - sonde a fenetres fixes 0-10 / 10-20 / 20-30 s : les trois
                //    bandes apparaissent a 3 s, 13 s et 23 s => temps GLOBAL ;
                //  - texte rebase : visible uniquement sur les frames 0 a 1,25 s
                //    des 140 analysees (run 41711170058).
                // On conserve donc les horodatages ABSOLUS, en les bornant a
                // zero (D42-F15 : TimestampWrapper rejette les negatifs).
                .map { it.copy(startS = it.startS.coerceAtLeast(0.0)) }
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
