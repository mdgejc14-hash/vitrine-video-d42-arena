package video.vitrine.feature.dashboard

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import video.vitrine.core.model.billing.BillingCheckout
import video.vitrine.core.model.billing.BillingProvider
import video.vitrine.core.model.billing.DeviceFingerprint
import video.vitrine.core.model.billing.Plan

class P8LogicTest {

    @Test
    fun `grille finale stricte 500-3000-7500`() {
        assertEquals(500, Plan.PASS_24H.priceFcfa)
        assertEquals(3000, Plan.PRO.priceFcfa)
        assertEquals(7500, Plan.BOUTIQUE.priceFcfa)
        assertEquals(3, Plan.entries.size)
        assertEquals(2, BillingProvider.entries.size)
    }

    @Test
    fun `checkout ref idempotente valide`() {
        // D41 (F10) : plus d'URL sandbox construite cote client (hote inexistant) —
        // le checkout est cree par le worker ; le client ne valide que la ref.
        val ref = BillingCheckout.newRef("VV")
        assertTrue(BillingCheckout.isValidRef(ref))
        assertTrue(ref.startsWith("VV-"))
        assertFalse(BillingCheckout.isValidRef("invente"))
        assertFalse(BillingCheckout.isValidRef(""))
    }

    @Test
    fun `empreinte appareil stable et valide`() {
        val a = DeviceFingerprint.of("android-123", "Unisoc/T606/2026")
        val b = DeviceFingerprint.of("android-123", "Unisoc/T606/2026")
        val c = DeviceFingerprint.of("android-999", "Unisoc/T606/2026")
        assertEquals(a, b)
        assertFalse(a == c)
        assertEquals(64, a.length)
        assertTrue(DeviceFingerprint.isValid(a))
        assertFalse(DeviceFingerprint.isValid("court"))
    }

    @Test
    fun `paywall seulement a epuisement et 3 cartes`() {
        val locked = PaywallMapper.ui(welcomeCreditsLeft = 0, exportsLimit = 0)
        assertTrue(locked.locked)
        assertEquals(3, locked.cards.size)
        val open = PaywallMapper.ui(welcomeCreditsLeft = 2, exportsLimit = 0)
        assertFalse(open.locked)
        assertEquals(2, open.bannerCreditsLeft)
    }

    @Test
    fun `E9A UEMOA libelles FCFA exacts maquette`() {
        val ui = PaywallMapper.ui(0, 0, PaywallZone.UEMOA)
        // D41 (F8/F33) : libelles via ressources (x4 langues), DEVISE = zone.
        assertEquals("500 FCFA", ui.cards[0].priceValue)
        assertNull(ui.cards[0].periodRes)
        assertEquals("3 000 FCFA", ui.cards[1].priceValue)
        assertEquals(R.string.period_30d, ui.cards[1].periodRes)
        assertEquals("7 500 FCFA", ui.cards[2].priceValue)
        assertEquals(R.string.period_30d, ui.cards[2].periodRes)
        assertFalse(ui.footnoteBceao)
    }

    @Test
    fun `E9B E9C equivalents EUR parite BCEAO 655,957`() {
        assertEquals("0,76 €", PaywallMapper.eurLabel(500))
        assertEquals("4,57 €", PaywallMapper.eurLabel(3000))
        assertEquals("11,43 €", PaywallMapper.eurLabel(7500))
        val ui = PaywallMapper.ui(0, 0, PaywallZone.AFRIQUE_HORS_UEMOA)
        assertEquals("≈ 0,76 €", ui.cards[0].priceValue)
        assertEquals("≈ 4,57 €", ui.cards[1].priceValue)
        assertEquals("≈ 11,43 €", ui.cards[2].priceValue)
        assertTrue(ui.footnoteBceao)
        val monde = PaywallMapper.ui(0, 0, PaywallZone.MONDE)
        assertTrue(monde.footnoteBceao)
        // Devise independante de la langue d'affichage : le format EUR reste
        // decimal FR (contrat maquette) quelle que soit la locale.
        assertEquals("≈ 0,76 €", monde.cards[0].priceValue)
    }

    @Test
    fun `E11 historique serveur anonymise et jauge conforme`() {
        // D41 (F2) : entrees = statuts SERVEUR (pas de noms inventes cote client).
        val entries = listOf(
            ReferralEntry("converted", true),
            ReferralEntry("pending", false)
        )
        val g = ReferralGauge.ui("SHALOM-842", converted = 3, rewards = 0, entries = entries)
        assertEquals(3, g.within)
        assertEquals(5, g.target)
        assertEquals(0.6f, g.progress, 0.0001f)
        assertEquals(2, g.entries.size)
        assertTrue(g.entries[0].converted)
        assertTrue(!g.entries[1].converted)
    }

    @Test
    fun `jauge R8 paliers de 5`() {
        val g = ReferralGauge.ui("SHALOM-842", converted = 7, rewards = 1)
        assertEquals(2, g.within)
        assertEquals(0.4f, g.progress, 0.0001f)
        assertEquals(1, g.rewards)
        assertEquals(7, g.converted)
    }
}
