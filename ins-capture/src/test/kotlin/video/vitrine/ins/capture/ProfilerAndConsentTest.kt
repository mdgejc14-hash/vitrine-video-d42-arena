package video.vitrine.ins.capture

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ProfilerAndConsentTest {

    @Test
    fun `classes provisoires par seuils mesures`() {
        val a = DeviceProfiler.Profile(8_000, 8, 34, true)
        val d = DeviceProfiler.Profile(1_800, 4, 29, true)
        assertEquals(DeviceClass.A, DeviceProfiler.provisionalClass(a))
        assertEquals(DeviceClass.D, DeviceProfiler.provisionalClass(d))
        assertEquals(DeviceClass.B, EncoderProbe.classify(20_000_000, true))
        assertEquals(DeviceClass.D, EncoderProbe.classify(50_000_000, false))
    }

    @Test
    fun `porte R4 bloquante et lissage EMA`() {
        assertEquals(ConsentGate.Decision.ALLOW, ConsentGate.decide(0, false, false, false))
        assertEquals(
            ConsentGate.Decision.BLOCK_MODAL_CONSENT,
            ConsentGate.decide(1, adultConsentRecorded = false, minorConsentRecorded = false, minorSuspected = false)
        )
        assertEquals(
            ConsentGate.Decision.BLOCK_MODAL_MINOR,
            ConsentGate.decide(1, adultConsentRecorded = true, minorConsentRecorded = false, minorSuspected = true)
        )
        assertEquals(
            ConsentGate.Decision.ALLOW,
            ConsentGate.decide(2, adultConsentRecorded = true, minorConsentRecorded = true, minorSuspected = true)
        )
        val smoothed = ConsentGate.smoothed(0f, 3)
        assertTrue(smoothed > 0.8f && smoothed < 1.0f)
    }
}
