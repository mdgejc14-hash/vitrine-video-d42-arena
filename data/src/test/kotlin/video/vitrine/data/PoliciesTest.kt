package video.vitrine.data

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class PoliciesTest {
    private val day = 24L * 60 * 60 * 1000

    @Test
    fun `paywall seulement a epuisement complet`() {
        assertTrue(PaywallPolicy.isExportLocked(0, 0))
        assertFalse(PaywallPolicy.isExportLocked(0, 3))
        assertFalse(PaywallPolicy.isExportLocked(30, 0))
    }

    @Test
    fun `grace hors-ligne selon cacheDays`() {
        val now = 1_000L * day
        assertTrue(PaywallPolicy.isCacheFresh(now - 2 * day, 3, now))
        assertFalse(PaywallPolicy.isCacheFresh(now - 4 * day, 3, now))
        assertTrue(PaywallPolicy.isCacheFresh(now - 13 * day, 14, now))
    }

    @Test
    fun `fair-use Pro et jauge R8`() {
        assertTrue(PaywallPolicy.isFairUseWarning(90, 90))
        assertFalse(PaywallPolicy.isFairUseWarning(89, 90))
        assertFalse(PaywallPolicy.isFairUseWarning(500, null))
        assertTrue(ReferralPolicy.isRewardDue(5))
        assertFalse(ReferralPolicy.isRewardDue(4))
        assertEquals(5, ReferralPolicy.TARGET)
    }
}
