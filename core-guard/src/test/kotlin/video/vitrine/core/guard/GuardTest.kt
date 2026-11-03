package video.vitrine.core.guard

import java.security.KeyPairGenerator
import java.security.SecureRandom
import java.security.interfaces.ECPublicKey
import java.security.spec.ECGenParameterSpec
import javax.crypto.spec.SecretKeySpec
import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class GuardTest {

    @Test
    fun ancre_monotone_detecte_recul() {
        val ok = MonotonicAnchor.advance(persistedMs = 500, nowElapsedMs = 900)
        assertEquals(900L, ok.anchorMs)
        assertFalse(ok.rollbackDetected)
        val ko = MonotonicAnchor.advance(persistedMs = 500, nowElapsedMs = 400)
        assertEquals(500L, ko.anchorMs)
        assertTrue(ko.rollbackDetected)
    }

    @Test
    fun recu_ecdsa_verifie_et_falsification_rejetee() {
        val kpg = KeyPairGenerator.getInstance("EC")
        kpg.initialize(ECGenParameterSpec("secp256r1"))
        val pair = kpg.generateKeyPair()
        val canonical = Receipt.canonicalize(
            mapOf(
                "order" to "VV-1",
                "credits" to "1",
                "anchor_ms" to "900",
                "algo" to "ECDSA-P256-SHA256",
            )
        )
        val sig = Receipt.sign(canonical, pair)
        assertTrue(Receipt.verify(canonical, sig, pair.public as ECPublicKey))
        assertFalse(Receipt.verify(canonical.replace("VV-1", "VV-2"), sig, pair.public as ECPublicKey))
    }

    @Test
    fun vvsh1_aller_retour_et_tag_corrompu() {
        val key = SecretKeySpec(ByteArray(32) { it.toByte() }, "AES")
        val nonce = ByteArray(12)
        SecureRandom().nextBytes(nonce)
        val aad = "{\"abi\":\"arm64-v8a\",\"payload_id\":\"p1\",\"schema\":\"VVSH1\"}"
        val blob = Vvsh1.encrypt(key, nonce, "mp4-permit".toByteArray(), aad)
        assertArrayEquals("mp4-permit".toByteArray(), Vvsh1.decrypt(key, blob, aad))
        assertNull(Vvsh1.decrypt(key, blob, aad + "x"))
        val corrupted = blob.copyOf()
        corrupted[10] = (corrupted[10].toInt() xor 0xFF).toByte()
        assertNull(Vvsh1.decrypt(key, corrupted, aad))
        assertNotNull(Vvsh1.unpack(blob))
    }

    @Test
    fun gate_matrice_decisions() {
        assertEquals(ExportGate.Decision.ALLOW, ExportGate.decide(3, false, true))
        assertEquals(ExportGate.Decision.DENY_NO_CREDIT, ExportGate.decide(0, false, true))
        assertEquals(ExportGate.Decision.DENY_ROLLBACK, ExportGate.decide(3, true, true))
        assertEquals(ExportGate.Decision.DENY_INTEGRITY, ExportGate.decide(3, false, false))
    }
}

/** Scenarios C01-C12 cote politique pure (VV Remote QA s6). */
class CreditPolicyTest {

    @Test
    fun `C01 seed bienvenue une seule fois`() {
        assertEquals(3, CreditPolicy.seedDecision(null, false, false))
        assertEquals(2, CreditPolicy.seedDecision(2, false, false))
        assertEquals(0, CreditPolicy.seedDecision(null, true, false))
        assertEquals(0, CreditPolicy.seedDecision(null, false, true))
    }

    @Test
    fun `C02 a C04 sequence de debit 3 vers 0`() {
        var balance = 3
        val seen = mutableListOf<Int>()
        repeat(3) {
            balance = CreditPolicy.debit(balance)!!
            seen += balance
        }
        assertEquals(listOf(2, 1, 0), seen)
        assertNull(CreditPolicy.debit(balance))
    }

    @Test
    fun `C05 et C06 aucun export a zero quel que soit le chemin`() {
        assertFalse(CreditPolicy.exportAllowed(0, true))
        assertFalse(CreditPolicy.exportAllowed(1, false))
        assertTrue(CreditPolicy.exportAllowed(1, true))
    }

    @Test
    fun `C07 concurrence solde 1 jamais negatif`() {
        val (allowed, rest) = CreditPolicy.concurrentDebits(1, 2)
        assertEquals(1, allowed)
        assertEquals(0, rest)
        val (a2, r2) = CreditPolicy.concurrentDebits(0, 5)
        assertEquals(0, a2)
        assertEquals(0, r2)
    }

    @Test
    fun `C08 compensation idempotente`() {
        assertEquals(1, CreditPolicy.compensate(0, false))
        assertEquals(0, CreditPolicy.compensate(0, true))
    }

    @Test
    fun `C09 horloge reculee refuse`() {
        assertTrue(CreditPolicy.clockRollbackDenies(true))
        assertFalse(CreditPolicy.clockRollbackDenies(false))
    }
}
