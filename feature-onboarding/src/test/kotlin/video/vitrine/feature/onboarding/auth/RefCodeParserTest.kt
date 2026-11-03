package video.vitrine.feature.onboarding.auth

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class RefCodeParserTest {
    @Test
    fun `deep-link et saisie manuelle`() {
        assertEquals("SHALOM-842", RefCodeParser.fromDeepLink("https://vitrine.video/r/SHALOM-842"))
        assertEquals("SHALOM-842", RefCodeParser.fromDeepLink("https://vitrine.video/r/shalom-842?x=1"))
        assertEquals("AKWABA-100", RefCodeParser.fromManualEntry(" akwaba-100 "))
        assertNull(RefCodeParser.fromDeepLink("https://vitrine.video/catalog"))
        assertNull(RefCodeParser.fromManualEntry("BAD"))
        assertNull(RefCodeParser.fromDeepLink(null))
    }
}
