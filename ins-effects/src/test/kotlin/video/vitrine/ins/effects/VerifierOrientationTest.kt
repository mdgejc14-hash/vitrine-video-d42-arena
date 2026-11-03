package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Test

/**
 * D42-F16 — le conteneur stocke l'image dans son orientation de captation et la
 * redresse par une matrice de rotation. Constat run 41592863733 : une video
 * 720x1280 (portrait) est stockee 1280x720 + rotation -90 ; le verificateur
 * comparait la taille stockee a la geometrie portrait et rejetait un export
 * pourtant conforme (duree 35,04 s pour 35,0 s attendues), declenchant un repli
 * cloud et un echec de l'export.
 */
class VerifierOrientationTest {

    @Test
    fun uneVideoPortraitStockeeEnPaysageEstBienPortrait() {
        val (l, h) = ExportVerifier.orienter(1280, 720, 270)
        assertEquals(720, l)
        assertEquals(1280, h)
        assertEquals(Pair(720, 1280), ExportVerifier.orienter(1280, 720, 90))
    }

    @Test
    fun uneVideoSansRotationGardeSaTaille() {
        assertEquals(Pair(720, 1280), ExportVerifier.orienter(720, 1280, 0))
        assertEquals(Pair(720, 1280), ExportVerifier.orienter(720, 1280, 180))
    }

    @Test
    fun lesRotationsNegativesSontNormalisees() {
        assertEquals(Pair(720, 1280), ExportVerifier.orienter(1280, 720, -90))
        assertEquals(Pair(720, 1280), ExportVerifier.orienter(1280, 720, 450))
    }
}
