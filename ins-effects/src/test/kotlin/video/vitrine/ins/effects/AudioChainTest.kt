package video.vitrine.ins.effects

import org.junit.Assert.assertTrue
import org.junit.Test

class AudioChainTest {

    @Test
    fun `cibles master conformes au pipeline livre`() {
        assertTrue(AudioChain.MASTER_LOUDNESS_I == -14.0)
        assertTrue(AudioChain.MASTER_TRUE_PEAK_DB == -1.0)
        assertTrue(AudioChain.ffmpegMasterFilter().contains("I=-14.0"))
    }

    @Test
    fun `filtre voix contient compand et loudnorm`() {
        val filter = AudioChain.ffmpegVoiceFilter()
        assertTrue(filter.contains("highpass=f=85"))
        assertTrue(filter.contains("loudnorm=I=-15.0"))
        assertTrue(AudioChain.ffmpegDuckingFilter().contains("sidechaincompress"))
    }
}
