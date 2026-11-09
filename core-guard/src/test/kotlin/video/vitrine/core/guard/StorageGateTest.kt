package video.vitrine.core.guard

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * D42.27 (§8/5.7) — contrôle préventif du stockage : logique pure.
 */
class StorageGateTest {

    @Test
    fun `seuil par défaut = 64 Mo, refus sous le seuil, accord au-dessus`() {
        assertEquals(64L * 1024 * 1024, StorageGate.SEUIL_PRISE_OCTETS)
        assertFalse(StorageGate.espaceSuffisant(63L * 1024 * 1024))
        assertTrue(StorageGate.espaceSuffisant(64L * 1024 * 1024))
        assertTrue(StorageGate.espaceSuffisant(10L * 1024 * 1024 * 1024))
    }

    @Test
    fun `espace négatif ou nul = refus (disque plein)`() {
        assertFalse(StorageGate.espaceSuffisant(0))
        assertFalse(StorageGate.espaceSuffisant(-1))
    }

    @Test
    fun `requis dynamique - plancher 64 Mo même pour un faible bitrate`() {
        assertEquals(64L * 1024 * 1024, StorageGate.requisPourPrise(12, 1_000_000))
    }

    @Test
    fun `requis dynamique - bitrate élevé → marge 3x au-dessus du plancher`() {
        val attendu = 15L * (24_000_000 / 8) * 3
        assertEquals(attendu, StorageGate.requisPourPrise(15, 24_000_000))
        assertTrue(attendu > StorageGate.SEUIL_PRISE_OCTETS)
    }

    @Test
    fun `seuils export (300 Mo) et téléchargement (32 Mo) distincts de la prise`() {
        assertTrue(StorageGate.SEUIL_EXPORT_OCTETS > StorageGate.SEUIL_PRISE_OCTETS)
        assertTrue(StorageGate.SEUIL_TELECHARGEMENT_OCTETS < StorageGate.SEUIL_PRISE_OCTETS)
    }
}
