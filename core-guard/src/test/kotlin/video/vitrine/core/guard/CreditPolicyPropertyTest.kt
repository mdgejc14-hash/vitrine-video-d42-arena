package video.vitrine.core.guard

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Audit D41 — test PROPERTY-BASED de la politique de credits (graine fixee,
 * 10 000 tirages) : les invariants transactionnels C01-C12 doivent tenir pour
 * TOUT solde/tirage, pas seulement les exemples des cas nominaux.
 */
class CreditPolicyPropertyTest {

    private val rng = java.util.Random(987654321L)

    @Test
    fun `seed jamais negatif et borne par WELCOME_TOTAL`() {
        repeat(10_000) {
            val ligne = if (rng.nextBoolean()) rng.nextInt(12) - 3 else null
            val seed = CreditPolicy.seedDecision(
                existingRow = ligne,
                serverGrantCached = rng.nextBoolean(),
                fingerprintKnown = rng.nextBoolean()
            )
            if (ligne != null) {
                assertEquals("le seed suit la ligne existante", ligne, seed)
            } else {
                assertTrue("seed dans 0..WELCOME_TOTAL : $seed", seed in 0..CreditPolicy.WELCOME_TOTAL)
            }
        }
    }

    @Test
    fun `debit refuse a zero et ne descend jamais sous zero`() {
        repeat(10_000) {
            val solde = rng.nextInt(20) - 5
            val apres = CreditPolicy.debit(solde)
            if (solde > 0) {
                assertEquals(solde - 1, apres)
            } else {
                assertNull("debit refuse a solde <= 0", apres)
            }
        }
    }

    @Test
    fun `debits concurrents conservent la masse monetaire`() {
        repeat(10_000) {
            val solde = rng.nextInt(15) - 3
            val requetes = rng.nextInt(10)
            val (autorises, reste) = CreditPolicy.concurrentDebits(solde, requetes)
            assertTrue("jamais plus que le solde disponible", autorises <= maxOf(0, solde))
            assertTrue("jamais plus que les requetes", autorises <= requetes)
            assertEquals("masse conservee", solde, autorises + reste)
            assertTrue("le reste ne croit jamais", reste <= solde)
        }
    }

    @Test
    fun `compensation idempotente ne cree jamais de credit ex nihilo au-dela du du`() {
        repeat(10_000) {
            val solde = rng.nextInt(10)
            val dejaCompense = rng.nextBoolean()
            val apres = CreditPolicy.compensate(solde, dejaCompense)
            if (dejaCompense) {
                assertEquals(solde, apres)
            } else {
                assertEquals(solde + 1, apres)
            }
        }
    }

    @Test
    fun `export exige solde ET reservation journal`() {
        repeat(10_000) {
            val solde = rng.nextInt(8) - 2
            val reserve = rng.nextBoolean()
            assertEquals(
                solde > 0 && reserve,
                CreditPolicy.exportAllowed(solde, reserve)
            )
        }
    }

    @Test
    fun `porte rollback alignee sur la detection`() {
        assertTrue(CreditPolicy.clockRollbackDenies(true))
        assertFalse(CreditPolicy.clockRollbackDenies(false))
    }

    @Test
    fun ` ExportGate ALLOW si et seulement si credits et horloge et integrite`() {
        repeat(10_000) {
            val credits = rng.nextInt(6) - 1
            val rollback = rng.nextBoolean()
            val integrite = rng.nextBoolean()
            val decision = ExportGate.decide(credits, rollback, integrite)
            if (decision == ExportGate.Decision.ALLOW) {
                assertTrue(credits > 0 && !rollback && integrite)
            } else {
                assertFalse(credits > 0 && !rollback && integrite)
            }
            // Priorite de refus : integrite avant rollback avant credits.
            if (!integrite) assertEquals(ExportGate.Decision.DENY_INTEGRITY, decision)
            else if (rollback) assertEquals(ExportGate.Decision.DENY_ROLLBACK, decision)
            else if (credits <= 0) assertEquals(ExportGate.Decision.DENY_NO_CREDIT, decision)
        }
    }
}
