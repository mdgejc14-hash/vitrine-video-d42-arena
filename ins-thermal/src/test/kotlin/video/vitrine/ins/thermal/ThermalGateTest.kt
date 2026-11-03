package video.vitrine.ins.thermal

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ThermalGateTest {

    @Test
    fun `decision selon marge predite avec garde NaN`() {
        assertEquals(ThermalLevel.OK, ThermalGate.decide(0.5f))
        assertEquals(ThermalLevel.DEGRADE, ThermalGate.decide(0.71f))
        assertEquals(ThermalLevel.STOP, ThermalGate.decide(1.2f))
        assertEquals(ThermalLevel.STOP, ThermalGate.decide(Float.NaN, ThermalLevel.STOP))
        assertEquals(ThermalLevel.OK, ThermalGate.decide(Float.NaN, ThermalLevel.OK))
    }

    @Test
    fun `physique - t_max coherent avec tau`() {
        val tau = ThermalGate.tauSeconds()
        assertTrue(tau > 0f)
        val t = ThermalGate.maxSustainedSeconds(powerW = 2.05f, deltaTAllowedK = 0.3f)
        assertTrue(t > 0f)
        assertEquals(0f, ThermalGate.maxSustainedSeconds(2.05f, 100f), 0.0001f)
        val t2 = ThermalGate.maxSustainedSeconds(powerW = 2.05f, deltaTAllowedK = 0.5f)
        assertTrue("plus de dT autorise => duree plus longue", t2 > t)
    }
}
