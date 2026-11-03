package video.vitrine.ins.effects

/**
 * Beat-grid d'un gabarit EDL 1.2.0 : instants de decoupe ecrits au design (drop_at_s).
 * Pur Kotlin, zero dependance Android : testable en JVM (contrat V7-FINAL 6.3 / 9.7).
 * La musique est substituable (role musical), la beat-grid ne l'est pas : les cuts
 * restent calés sur le tempo meme si le catalogue est vide ou silencieux.
 */
data class BeatGrid(val dropAtSeconds: List<Double>) {
    init {
        require(dropAtSeconds.all { it.isFinite() && it >= 0.0 }) { "beat-grid : instants negatifs ou non finis" }
        require(dropAtSeconds.zipWithNext { a, b -> a < b }.all { it }) { "beat-grid : instants non strictement croissants" }
    }

    val size: Int get() = dropAtSeconds.size

    /** Index du cut actif a t (secondes) : dernier beat <= t, -1 avant le premier. */
    fun beatIndexAt(tSeconds: Double): Int {
        var lo = 0
        var hi = dropAtSeconds.size - 1
        var ans = -1
        while (lo <= hi) {
            val mid = (lo + hi) / 2
            if (dropAtSeconds[mid] <= tSeconds) { ans = mid; lo = mid + 1 } else hi = mid - 1
        }
        return ans
    }

    /** Duree de la scene demarrant au beat i (ou fin theorique [endSeconds]). */
    fun sceneDuration(i: Int, endSeconds: Double): Double {
        require(i in -1..dropAtSeconds.size) { "beat inexistant : $i" }
        val start = if (i < 0) 0.0 else dropAtSeconds[i]
        val end = if (i + 1 < dropAtSeconds.size) dropAtSeconds[i + 1] else endSeconds
        return (end - start).coerceAtLeast(0.0)
    }

    companion object {
        fun fromEdl(values: List<Double>): BeatGrid = BeatGrid(values.sorted())
    }
}
