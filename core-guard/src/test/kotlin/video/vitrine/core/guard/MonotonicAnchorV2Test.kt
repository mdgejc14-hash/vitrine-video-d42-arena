package video.vitrine.core.guard

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Audit D40 (B2) : ancre V2 murale. Le reboot d'un appareil (elapsedRealtime
 * remis a zero) ne doit PLUS etre pris pour un recul d'horloge ; un vrai recul
 * murale au-dela de la grace doit etre refuse.
 */
class MonotonicAnchorV2Test {

    @Test
    fun `premiere pose jamais rollback`() {
        val r = MonotonicAnchor.advanceV2(persistedWallMs = 0L, nowWallMs = 1_000L)
        assertFalse(r.rollbackDetected)
        assertEquals(1_000L, r.anchorWallMs)
    }

    @Test
    fun `reboot appareil sans faux rollback`() {
        // Simulation : uptime 5 jours persiste via V1, puis reboot. La V2 ne
        // compare QUE le mur : le mur a continue d'avancer -> aucun rollback.
        val persistedWall = 1_761_000_000_000L
        val r = MonotonicAnchor.advanceV2(persistedWall, persistedWall + 60_000L)
        assertFalse(r.rollbackDetected)
        assertEquals(persistedWall + 60_000L, r.anchorWallMs)
    }

    @Test
    fun `recul murale superieur a la grace refuse`() {
        val persistedWall = 1_761_000_000_000L
        val r = MonotonicAnchor.advanceV2(persistedWall, persistedWall - 3_600_000L)
        assertTrue(r.rollbackDetected)
        assertEquals(persistedWall, r.anchorWallMs)   // l'ancre ne descend jamais
    }

    @Test
    fun `derive NTP dans la grace acceptee`() {
        val persistedWall = 1_761_000_000_000L
        val r = MonotonicAnchor.advanceV2(persistedWall, persistedWall - 30_000L)
        assertFalse(r.rollbackDetected)
    }

    @Test
    fun `porte export combinee`() {
        assertEquals(
            ExportGate.Decision.DENY_ROLLBACK,
            ExportGate.decide(credits = 2, rollbackDetected = true, integrityOk = true)
        )
        assertEquals(
            ExportGate.Decision.ALLOW,
            ExportGate.decide(credits = 2, rollbackDetected = false, integrityOk = true)
        )
    }
}
