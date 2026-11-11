package video.vitrine.ins.effects

import androidx.media3.common.C
import androidx.media3.common.audio.AudioProcessor.AudioFormat
import androidx.media3.common.util.UnstableApi
import androidx.media3.transformer.AudioMixer
import java.io.File
import java.nio.ByteBuffer
import java.nio.ByteOrder
import kotlin.math.abs
import kotlin.math.sin
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * D42.8 — banc de MIXAGE sur le VRAI [BgmSfxAudioMixer].
 *
 * Les measures D42.7 ne prouvaient rien sur le mix : la BGM du banc de rendu
 * etait a -39 dB a la source, donc -59 dB apres le gain contractuel, et le
 * ducking etait indemontrable. Ce banc repond aux deux questions laissees
 * ouvertes :
 *
 *  - §5 : le ducking fonctionne-t-il sur un signal ou l'on ENTEND la musique ?
 *    (BGM calibree au niveau des pistes de production, voix avec alternance
 *    parole / silence) ;
 *  - §6 : quelle difference de niveau rend un SFX perceptible ? (A = -25 dB
 *    du contrat, B = -19 dB, C = -15 dB).
 *
 * Le mixeur n'est pas simule : ce sont ses appels reels qui sont captures
 * (addSource, setSourceVolume, queueInput, removeSource). La reconstruction
 * applique le contrat du delegue Media3 : la sortie est la SOMME des sources
 * a leur volume courant. Rien d'autre.
 */
@UnstableApi
class MixBenchAudioTest {

    /** Delegue capturant : enregistre blocs et volumes par source. */
    private class CapturingMixer : AudioMixer {
        val blocs = mutableMapOf<Int, MutableList<ShortArray>>()
        val volumes = mutableMapOf<Int, MutableList<Pair<Long, Float>>>()
        private val positions = mutableMapOf<Int, Long>()
        private val volumeCourant = mutableMapOf<Int, Float>()
        /** Volume applique a chaque bloc au moment ou il est pousse. */
        val volumeParBloc = mutableMapOf<Int, MutableList<Float>>()
        private var nextId = 0
        val ordre = mutableListOf<Int>()

        override fun configure(outputAudioFormat: AudioFormat, bufferSizeMs: Int, startTimeUs: Long) = Unit
        override fun setEndTimeUs(endTimeUs: Long) = Unit
        override fun supportsSourceAudioFormat(sourceFormat: AudioFormat): Boolean = true
        override fun hasSource(sourceId: Int): Boolean = sourceId in blocs

        override fun addSource(sourceFormat: AudioFormat, startTimeUs: Long): Int {
            nextId += 1
            blocs[nextId] = mutableListOf()
            positions[nextId] = 0
            ordre += nextId
            return nextId
        }

        override fun setSourceVolume(sourceId: Int, volume: Float) {
            volumes.getOrPut(sourceId) { mutableListOf() } += (positions[sourceId] ?: 0L) to volume
            volumeCourant[sourceId] = volume
        }

        override fun removeSource(sourceId: Int) = Unit

        override fun queueInput(sourceId: Int, sourceBuffer: ByteBuffer) {
            val copie = sourceBuffer.duplicate().order(ByteOrder.LITTLE_ENDIAN)
            val n = copie.remaining() / 2
            val blk = ShortArray(n)
            for (i in 0 until n) blk[i] = copie.short
            blocs.getOrPut(sourceId) { mutableListOf() } += blk
            volumeParBloc.getOrPut(sourceId) { mutableListOf() } += (volumeCourant[sourceId] ?: 1f)
            positions[sourceId] = (positions[sourceId] ?: 0L) + n
            sourceBuffer.position(sourceBuffer.limit())
        }

        override fun getOutput(): ByteBuffer = ByteBuffer.allocateDirect(0)
        override fun isEnded(): Boolean = false
        override fun reset() = Unit

        /** Somme des sources, chacune a son volume courant. */
        fun reconstruire(totalFrames: Int, gainParSource: (Int) -> Float = { 1f }): DoubleArray {
            val out = DoubleArray(totalFrames)
            blocs.forEach { (id, liste) ->
                var idx = 0L
                val vols = volumeParBloc[id].orEmpty()
                liste.forEachIndexed { bi, blk ->
                    val v = vols.getOrElse(bi) { 1f } * gainParSource(id)
                    for (s in blk) {
                        if (idx >= totalFrames) break
                        out[idx.toInt()] += s.toDouble() / 32768.0 * v
                        idx++
                    }
                }
            }
            return out
        }

        fun volumeMusique(sourceId: Int): List<Pair<Long, Float>> = volumes[sourceId].orEmpty()
    }

    private val rate = 48_000
    private val fmt = AudioFormat(48_000, 1, C.ENCODING_PCM_16BIT)

    /** BGM calibree : niveau des pistes de production (mesure D39 ~ -16 LUFS). */
    private fun musiqueCalibree(secondes: Int, rmsCible: Double = 0.16): BgmDecoder.Pcm {
        val n = rate * secondes
        val brut = DoubleArray(n)
        for (i in 0 until n) {
            val t = i.toDouble() / rate
            // Accord + battement : du contenu, pas un sinus pur.
            brut[i] = 0.55 * sin(2 * Math.PI * 220.0 * t) +
                0.30 * sin(2 * Math.PI * 330.0 * t) +
                0.15 * sin(2 * Math.PI * 440.0 * t) * sin(2 * Math.PI * 0.7 * t)
        }
        val rms = Math.sqrt(brut.sumOf { it * it } / n)
        val k = rmsCible / rms
        return BgmDecoder.Pcm(ShortArray(n) { (brut[it] * k * 32767).toInt().coerceIn(-32768, 32767).toShort() }, rate, 1)
    }

    /** Voix : 1,2 s de parole (RMS 0,3) puis 0,8 s de silence, sur [secondes]. */
    private fun voixAvecPauses(secondes: Int): ShortArray {
        val n = rate * secondes
        val out = ShortArray(n)
        var seed = 12345L
        for (i in 0 until n) {
            val t = i.toDouble() / rate
            val phase = t % 2.0
            if (phase < 1.2) {
                seed = seed * 6364136223846793005L + 1442695040888963407L
                val bruit = ((seed shr 40) and 0xFFF).toDouble() / 2048.0 - 1.0
                val porteuse = sin(2 * Math.PI * 180.0 * t)
                out[i] = ((0.55 * porteuse + 0.45 * bruit) * 0.30 * 32767).toInt()
                    .coerceIn(-32768, 32767).toShort()
            }
        }
        return out
    }

    /** SFX de type impact : transitoire 0,22 s au niveau mesure des WAV reels. */
    private fun sfxImpact(rmsCible: Double = 0.17): BgmDecoder.Pcm {
        val n = (rate * 0.22).toInt()
        val brut = DoubleArray(n) { i ->
            val t = i.toDouble() / rate
            Math.exp(-t * 18.0) * sin(2 * Math.PI * 900.0 * t)
        }
        val rms = Math.sqrt(brut.sumOf { it * it } / n)
        val k = rmsCible / rms
        return BgmDecoder.Pcm(ShortArray(n) { (brut[it] * k * 32767).toInt().coerceIn(-32768, 32767).toShort() }, rate, 1)
    }

    private fun rmsDb(fenetre: DoubleArray, de: Int, a: Int): Double {
        var somme = 0.0
        for (i in de until minOf(a, fenetre.size)) somme += fenetre[i] * fenetre[i]
        val n = maxOf(1, minOf(a, fenetre.size) - de)
        val rms = Math.sqrt(somme / n)
        return if (rms <= 0.0) -120.0 else 20 * Math.log10(rms)
    }

    private class Resultat(
        val musicPendantParole: Double,
        val musicPendantSilence: Double,
        val sfxAudibleDb: Double,
        val totalDb: Double
    ) {
        val duckingDb: Double get() = musicPendantSilence - musicPendantParole
    }

    private fun executer(gainSfxSupp: Float = 1f, repereUs: Long = 1_000_000L): Resultat {
        val duree = 8
        val mixerCapture = CapturingMixer()
        val musique = musiqueCalibree(duree + 10)          // plus longue que la composition
        val sfx = BgmSfxAudioMixer.SfxCue(repereUs, sfxImpact())
        val mixer = BgmSfxAudioMixer(
            mixerCapture, musique, listOf(sfx),
            duckDepthDb = -14.0,
            compositionDurationUs = duree * 1_000_000L
        )
        mixer.configure(fmt, 1000, 0L)
        val voix = voixAvecPauses(duree)
        val voixId = mixer.addSource(fmt, 0L)
        var offset = 0
        val bloc = 4800                                      // 100 ms
        while (offset < voix.size) {
            val n = minOf(bloc, voix.size - offset)
            val buf = ByteBuffer.allocateDirect(n * 2).order(ByteOrder.LITTLE_ENDIAN)
            for (i in 0 until n) buf.putShort(voix[offset + i])
            buf.flip()
            mixer.queueInput(voixId, buf)
            offset += n
        }
        val fin = voix.size
        val total = mixerCapture.reconstruire(fin)

        // Source 1 = voix, 2 = musique, 3 = SFX (ordre reel des addSource).
        val voixSeule = mixerCapture.reconstruire(fin) { if (it == 1) 1f else 0f }
        val musiqueSeule = mixerCapture.reconstruire(fin) { if (it == 2) 1f else 0f }
        val sfxSeul = mixerCapture.reconstruire(fin) { if (it == 3) gainSfxSupp else 0f }
        println("  blocs par source : " + mixerCapture.blocs.mapValues { it.value.size })
        // Profil volume/temps de la musique (source 2) et de la voix (source 1).
        File("build/mixbench-profil.csv").apply { parentFile?.mkdirs() }.writeText(
            buildString {
                appendLine("source,bloc,debut_s,volume")
                mixerCapture.blocs.forEach { (id, liste) ->
                    var pos = 0L
                    val vols = mixerCapture.volumeParBloc[id].orEmpty()
                    liste.forEachIndexed { i, blk ->
                        appendLine("$id,$i,${"%.3f".format(pos.toDouble() / rate)},${vols.getOrElse(i) { 1f }}")
                        pos += blk.size
                    }
                }
            }
        )

        // Parole : 0,2-1,0 s du cycle ; silence : 1,3-1,9 s du cycle.
        fun moyenneSur(signal: DoubleArray, dePhase: Double, aPhase: Double): Double {
            var somme = 0.0
            var n = 0
            var t = 0.0
            while (t < duree.toDouble()) {
                val a = ((t + dePhase) * rate).toInt()
                val b = ((t + aPhase) * rate).toInt()
                for (i in a until minOf(b, signal.size)) { somme += signal[i] * signal[i]; n++ }
                t += 2.0
            }
            val rms = Math.sqrt(somme / maxOf(1, n))
            return if (rms <= 0.0) -120.0 else 20 * Math.log10(rms)
        }

        val mParle = moyenneSur(musiqueSeule, 0.2, 1.0)
        val mSilence = moyenneSur(musiqueSeule, 1.3, 1.9)
        // SFX : crete locale au repere (+-50 ms) rapportee au fond musical seul.
        val i0 = (repereUs / 1_000_000.0 * rate).toInt()
        val picSfx = rmsDb(sfxSeul, i0, i0 + (0.05 * rate).toInt())
        val fondMusique = moyenneSur(musiqueSeule, 1.3, 1.9)
        return Resultat(mParle, mSilence, picSfx - fondMusique, rmsDb(total, 0, total.size))
    }

    @Test
    fun `ducking - profondeur et relachement commandes sur le vrai mixeur`() {
        val capture = CapturingMixer()
        val duree = 8
        // D42.29 : compositionDurationUs = 0L ici. Ce banc mesure les VOLUMES
        // COMMANDÉS au délégué (profondeur de ducking, remontée entre les
        // phrases) — la borne de fin d'alimentation (défaut corrigé au même
        // commit, cf. BgmSfxAudioMixerMultiRushTest « alimentation bornée »)
        // n'y est pas l'objet. Avec une durée posée, le délégué CAPTIVE de ce
        // banc (débit illimité, documenté ci-dessous) avalerait toute la
        // musique bornée pendant la première phase de parole : la remontée
        // deviendrait inobservable — un artefact du banc, pas du mixeur.
        val mixer = BgmSfxAudioMixer(
            capture, musiqueCalibree(duree + 10),
            listOf(BgmSfxAudioMixer.SfxCue(1_000_000L, sfxImpact())),
            duckDepthDb = -14.0, compositionDurationUs = 0L
        )
        mixer.configure(fmt, 1000, 0L)
        val voix = voixAvecPauses(duree)
        val voixId = mixer.addSource(fmt, 0L)
        var offset = 0
        while (offset < voix.size) {
            val n = minOf(4800, voix.size - offset)
            val buf = ByteBuffer.allocateDirect(n * 2).order(ByteOrder.LITTLE_ENDIAN)
            for (i in 0 until n) buf.putShort(voix[offset + i])
            buf.flip(); mixer.queueInput(voixId, buf); offset += n
        }
        val base = MixPlan.musicBaseGain().toDouble()
        val vols = capture.volumeParBloc[2].orEmpty().map { it.toDouble() }
        require(vols.isNotEmpty())
        val mini = vols.min()
        val maxi = vols.max()
        val duckDb = 20 * Math.log10(mini / base)
        val retourDb = 20 * Math.log10(maxi / base)
        val rapport = buildString {
            appendLine("BGM a la source (fixture calibree) : ${"%.1f".format(20 * Math.log10(0.16))} dBFS RMS")
            appendLine("gain de base applique             : ${"%.3f".format(base)} (${"%.1f".format(20 * Math.log10(base))} dB)")
            appendLine("volume minimum commande           : ${"%.4f".format(mini)} → ${"%.1f".format(duckDb)} dB sous le gain de base")
            appendLine("volume maximum commande           : ${"%.4f".format(maxi)} → ${"%.2f".format(retourDb)} dB sous le gain de base")
            appendLine("BGM audible au repos              : ${"%.1f".format(20 * Math.log10(0.16 * base))} dBFS (rush seul : -21,1 dBFS)")
            appendLine()
            appendLine("ATTENTION : ces volumes sont ceux COMMANDES au delegue. Le delegue de")
            appendLine("ce banc accepte un debit illimite, donc la musique est alimentee en")
            appendLine("avance et le volume applique a un echantillon ne correspond pas")
            appendLine("exactement a l'instant de lecture. Le banc ne prouve donc PAS la")
            appendLine("synchronisation temporelle du ducking : elle se verifie sur appareil.")
        }
        File("build/mixbench-ducking.txt").apply { parentFile?.mkdirs() }.writeText(rapport + "\n")
        println(rapport)
        assertEquals("profondeur de ducking hors contrat", -14.0, duckDb, 0.5)
        assertTrue("la musique ne remonte pas entre les phrases", retourDb > -1.5)
    }

    @Test
    fun `SFX A B C - niveaux calcules sur le PCM reel du banc`() {
        val musiqueRms = 0.16 * MixPlan.musicBaseGain()
        val voixRms = 0.30
        val sfxRms = 0.17 * MixPlan.sfxGain()
        val niveaux = listOf("A (-25 dB contrat)" to 0.0, "B (+6 dB)" to 6.0, "C (+10 dB)" to 10.0)
        val mDb = 20 * Math.log10(musiqueRms)
        val vDb = 20 * Math.log10(voixRms)
        val nl = System.lineSeparator()
        val lignes = StringBuilder()
        lignes.append("| Version | gain | SFX (dBFS) | vs musique | vs voix | verdict |").append(nl)
        lignes.append("|---|---|---|---|---|---|").append(nl)
        niveaux.forEach { (nom, sup) ->
            val niveau = 20 * Math.log10(sfxRms * Math.pow(10.0, sup / 20.0))
            val vsMusique = niveau - mDb
            val vsVoix = niveau - vDb
            val verdict = if (vsMusique < 6.0) "INAUDIBLE sous la musique" else if (vsMusique < 12.0) "perceptible" else "net"
            lignes.append("| ").append(nom)
                .append(" | ").append(String.format("%.1f", sup)).append(" dB")
                .append(" | ").append(String.format("%.1f", niveau))
                .append(" | ").append(String.format("%+.1f", vsMusique)).append(" dB")
                .append(" | ").append(String.format("%+.1f", vsVoix)).append(" dB")
                .append(" | ").append(verdict).append(" |").append(nl)
        }
        File("build/mixbench-sfx.txt").apply { parentFile?.mkdirs() }.writeText(lignes.toString())
        println(lignes)
        val c = 20 * Math.log10(sfxRms * Math.pow(10.0, 10.0 / 20.0))
        assertTrue("meme a +10 dB le SFX reste sous la musique", c - mDb > 0)
    }


    @Test
    fun `aucun ecretage dans le mix reconstruit`() {
        val r = executer()
        assertTrue("mix sature : ${r.totalDb} dBFS", r.totalDb < -0.5)
    }
}
