package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Audit D40 : contrat de mixage reconnecté au rendu on-device (A4).
 * Chiffres = AudioChain (livré) : musique -20 dB, SFX -25 dB, ducking
 * seuil 0,045 / attaque 12 ms / relâche 260 ms, profondeur gabarit -14 dB.
 */
class MixPlanTest {

    @Test
    fun `gains lineaires conformes au contrat dB`() {
        assertEquals(0.1f, MixPlan.musicBaseGain(), 0.001f)      // -20 dB
        assertEquals(0.0562f, MixPlan.sfxGain(), 0.001f)         // -25 dB
        assertEquals(0.1995f, MixPlan.dbToLinear(-14.0), 0.001f) // ducking gabarit
    }

    @Test
    fun `ducking bascule au seuil AudioChain`() {
        assertEquals(1.0f, MixPlan.duckTargetGain(0.04f), 0.0001f)
        assertEquals(MixPlan.dbToLinear(-14.0), MixPlan.duckTargetGain(0.2f), 0.0001f)
    }

    @Test
    fun `lissage attaque rapide relache lente`() {
        val down = MixPlan.approachGain(1.0f, 0.2f, 12f)   // une constante d'attaque
        val up = MixPlan.approachGain(0.2f, 1.0f, 12f)     // 12 ms dans la relâche
        assertTrue("attaque : ~63 % du chemin", down < 0.75f && down > 0.2f)
        assertTrue("relâche : petit pas", up > 0.2f && up < 0.35f)
        assertEquals(0.2f, MixPlan.approachGain(0.2f, 0.2f, 50f), 0.0001f)
    }

    @Test
    fun `rms pcm borne et silencieux nul`() {
        assertEquals(0f, MixPlan.rmsPcm16(ShortArray(64), 0, 64), 0.0001f)
        val loud = ShortArray(64) { 16384 }
        assertEquals(0.5f, MixPlan.rmsPcm16(loud, 0, 64), 0.001f)
        assertEquals(0.5f, MixPlan.rmsPcmFloat(FloatArray(32) { 0.5f }, 0, 32), 0.001f)
    }

    @Test
    fun `resampling lineaire 44100 vers 48000 conserve la longueur`() {
        val input = ShortArray(4410) { (it % 1000).toShort() }
        val output = MixPlan.resampleLinear(input, 44100, 48000)
        assertEquals(4800, output.size)
        assertEquals(input[0], output[0])
        val same = MixPlan.resampleLinear(input, 48000, 48000)
        assertTrue(same === input)
    }

    @Test
    fun `mono vers stereo duplique sans decalage`() {
        val stereo = MixPlan.monoToStereo(shortArrayOf(1, 2, 3))
        assertEquals(6, stereo.size)
        assertEquals(1, stereo[0].toInt())   // Short vs Int : comparaison objets sinon
        assertEquals(1, stereo[1].toInt())
        assertEquals(3, stereo[4].toInt())
        assertEquals(3, stereo[5].toInt())
    }

    @Test
    fun `volume musique final dans la plage contrat -18-22 dB au repos`() {
        val v = MixPlan.musicVolume(1.0f)
        val db = 20 * Math.log10(v.toDouble())
        assertTrue("musique au repos dans -18/-22 dB : $db", db in -22.0..-18.0)
    }

    @Test
    fun `D42_21 gain solo - musique pleine quand la voix est absente`() {
        // Mode solo (aucune voix dans les rushs) : 0 dB = 1.0 — les fichiers BGM
        // sont déjà calibrés -16 LUFS / -1 dBTP, les atténuer les rendrait inaudibles.
        assertEquals(0.0, MixPlan.MUSIC_SOLO_GAIN_DB, 0.0001)
        assertEquals(1.0f, MixPlan.musicBaseGainDb(MixPlan.MUSIC_SOLO_GAIN_DB), 0.0001f)
        // Le volume ducking reste applicable mais ne réduit pas la base solo.
        assertEquals(1.0f, MixPlan.musicVolume(1.0f, MixPlan.MUSIC_SOLO_GAIN_DB), 0.0001f)
        // Historique inchangé : base -20 dB avec envelope unitaire.
        assertEquals(0.1f, MixPlan.musicVolume(1.0f), 0.001f)
    }
}
