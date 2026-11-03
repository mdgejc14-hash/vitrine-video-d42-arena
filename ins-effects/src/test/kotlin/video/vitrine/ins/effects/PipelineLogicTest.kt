package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class PipelineLogicTest {

    @Test
    fun `VFR recale sur grille 30 FPS stricte`() {
        val vfr = listOf(0L, 40_000L, 70_000L, 100_000L, 101_000L)
        val normalized = VfrNormalizer.normalize(vfr)
        assertEquals(4, normalized.size)
        assertEquals(0L, normalized[0].second)
        assertEquals(33_333L, normalized[1].second)
        assertEquals(66_666L, normalized[2].second)
        assertEquals(99_999L, normalized[3].second)
        assertEquals(3L * 33_333L, VfrNormalizer.cfrDurationUs(3))
    }

    @Test
    fun `bitrates export par classe et boost grain`() {
        assertEquals(12_000_000, ExportSpec.exportBitrateBps(ExportSpec.ExportClass.A, grainActive = false))
        assertEquals((6_000_000 * 1.18f).toInt(), ExportSpec.exportBitrateBps(ExportSpec.ExportClass.D, grainActive = true))
        assertEquals(ExportSpec.ExportGeometry(720, 1280), ExportSpec.geometry(ExportSpec.ExportClass.D, hotSeason = true))
        assertEquals(ExportSpec.ExportGeometry(1080, 1920), ExportSpec.geometry(ExportSpec.ExportClass.B, hotSeason = true))
    }

    @Test
    fun `repli portrait suit la geometrie demandee`() {
        // Production : 2/3 de 1080x1920 = 720x1280 (regle T8 inchangee).
        assertEquals(
            ExportSpec.ExportGeometry(720, 1280),
            ExportSpec.repli(ExportSpec.ExportGeometry(1080, 1920))
        )
        // Profil de validation : 2/3 de 540x960 = 360x640.
        assertEquals(
            ExportSpec.ExportGeometry(360, 640),
            ExportSpec.repli(ExportSpec.ExportGeometry(540, 960))
        )
    }

    @Test
    fun `verificateur et matrice des 3 replis`() {
        // D42-F21 : le budget est un PLAFOND, pas un plancher.
        assertTrue(VerifierPolicy.bitrateOk(3_000_000, 6_000_000, 1080, 1920))
        assertTrue(VerifierPolicy.bitrateOk(1_490_000, 6_000_000, 720, 1280))
        // Depassement du budget de classe (marge conteneur 5 %).
        assertFalse(VerifierPolicy.bitrateOk(6_400_000, 6_000_000, 1080, 1920))
        // Fichier famine : sous 0,015 bit/pixel/image.
        assertFalse(VerifierPolicy.bitrateOk(800_000, 6_000_000, 1080, 1920))
        val checks = VerifierPolicy.Checks(true, true, true, 3)
        assertTrue(checks.passed)
        assertFalse(VerifierPolicy.Checks(true, true, true, 2).passed)
        assertEquals(VerifierPolicy.Fallback.NEXT_PORTRAIT_STRATEGY, VerifierPolicy.fallbackFor(0))
        assertEquals(VerifierPolicy.Fallback.SOFTWARE_ENCODER, VerifierPolicy.fallbackFor(1))
        assertEquals(VerifierPolicy.Fallback.CLOUD_MODAL, VerifierPolicy.fallbackFor(2))
        assertEquals(VerifierPolicy.Fallback.EXHAUSTED, VerifierPolicy.fallbackFor(3))
    }
}
