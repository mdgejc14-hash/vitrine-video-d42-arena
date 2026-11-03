package video.vitrine.feature.onboarding.auth

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class DemoSessionTest {
    @Test
    fun `session demo stable et explicite`() {
        assertEquals("user_demo_123", DemoSession.UID)
        assertTrue(DemoSession.TOKEN.isNotBlank())
        assertTrue(DemoSession.TOKEN.startsWith("demo-"))
    }
}
