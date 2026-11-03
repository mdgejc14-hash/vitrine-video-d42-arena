package video.vitrine.ins.capture

import org.junit.Assert.assertEquals
import org.junit.Test

class CaptureSpecTest {

    @Test
    fun `echelle de bitrate capture 40-30-20-14 Mbps`() {
        assertEquals(40_000_000, CaptureSpec.forClass(DeviceClass.A).captureBitrateBps)
        assertEquals(30_000_000, CaptureSpec.forClass(DeviceClass.B).captureBitrateBps)
        assertEquals(20_000_000, CaptureSpec.forClass(DeviceClass.C).captureBitrateBps)
        assertEquals(14_000_000, CaptureSpec.forClass(DeviceClass.D).captureBitrateBps)
    }

    @Test
    fun `sur-echantillonnage A-B et regle T8 saison chaude`() {
        assertEquals(2160, CaptureSpec.forClass(DeviceClass.A).captureHeight)
        assertEquals(1080, CaptureSpec.exportHeightFor(CaptureSpec.forClass(DeviceClass.A)))
        val d = CaptureSpec.forClass(DeviceClass.D, hotSeason = true)
        assertEquals(720, CaptureSpec.exportHeightFor(d))
        val b = CaptureSpec.forClass(DeviceClass.B, hotSeason = true)
        assertEquals(1080, CaptureSpec.exportHeightFor(b))
    }
}
