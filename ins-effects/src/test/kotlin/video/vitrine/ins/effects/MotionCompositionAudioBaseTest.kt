package video.vitrine.ins.effects

import android.net.Uri
import androidx.media3.common.util.UnstableApi
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

/**
 * D42.21 — régression du défaut D42.18 : quand les rushs du client n'ont
 * AUCUNE piste audio (voix facultative) et qu'une musique est planifiée, la
 * composition doit porter une SÉQUENCE AUDIO PARALLÈLE (base silencieuse) pour
 * que le graphe audio du Transformer existe et que le mixeur BGM/SFX sorte une
 * piste audio dans le MP4. Sans base : une seule séquence (comportement
 * historique inchangé — les rushs portent l'audio).
 */
@UnstableApi
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class MotionCompositionAudioBaseTest {

    private val sheet = MotionJson.BeatSheet(
        plans = listOf(
            MotionJson.BeatSheetPlan(
                t0 = 0.0, t1 = 2.0, kind = "clip", inT = 0.0, fx = 0.5, fy = 0.5,
                zStart = 1.0, zEnd = 1.0, transition = "cut", shake = 0.0
            ),
            MotionJson.BeatSheetPlan(
                t0 = 2.0, t1 = 4.0, kind = "clip", inT = 0.0, fx = 0.5, fy = 0.5,
                zStart = 1.0, zEnd = 1.0, transition = "cut", shake = 0.0
            )
        ),
        words = emptyList(),
        keywords = emptySet()
    )

    private val rushes = listOf(Uri.parse("file:///rush/a.mp4"), Uri.parse("file:///rush/b.mp4"))

    @Test
    fun `sans base audio - comportement historique une seule sequence`() {
        val composition = MotionComposition.fromClientRushes(rushes, sheet)
        assertEquals(1, composition.sequences.size)
    }

    @Test
    fun `avec base audio - deux sequences dont une sequence audio parallele`() {
        val composition = MotionComposition.fromClientRushes(
            rushes, sheet,
            audioBaseUri = Uri.parse("file:///cache/base-silence-d4221.wav"),
            audioBaseDurationMs = 4_000L
        )
        assertEquals(2, composition.sequences.size)
        // La séquence audio ne contient qu'un item, sans effets vidéo.
        val seqAudio = composition.sequences[1]
        assertEquals(1, seqAudio.editedMediaItems.size)
        assertEquals(
            4_000L,
            seqAudio.editedMediaItems[0].mediaItem.clippingConfiguration.endPositionMs
        )
    }

    @Test
    fun `base audio ignoree si duree nulle - jamais de sequence fantome`() {
        val composition = MotionComposition.fromClientRushes(
            rushes, sheet,
            audioBaseUri = Uri.parse("file:///cache/base-silence-d4221.wav"),
            audioBaseDurationMs = 0L
        )
        assertEquals(1, composition.sequences.size)
    }
}
