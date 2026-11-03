package video.vitrine.ins.effects

/** Mot horodate par Whisper (16 kHz mono) : la voix est le metronome du montage. */
data class WordStamp(val word: String, val startS: Double, val endS: Double)

/**
 * Plan du beat sheet (pipeline reproductible) : bornescalees sur des timecodes de
 * mots, point d'interet (fx, fy) pour le recadrage 9:16, zoom punch-in z(t),
 * transition et intensite de tremblement.
 */
data class BeatSheetPlan(
    val t0: Double,
    val t1: Double,
    val kind: String,
    val inT: Double,
    val fx: Double,
    val fy: Double,
    val zStart: Double,
    val zEnd: Double,
    val transition: String,
    val shake: Double,
    val rushIndex: Int = -1
)

/** Horloge voix off : decoupage et portes de controle du contrat qualite. */
object WordClock {

    const val AVG_PLAN_MAX_S = 1.5
    const val PLAN_MAX_S = 3.0
    const val DURATION_TOLERANCE_S = 0.05

    /** [planCount] bornes de plans, chacune callee sur un timecode de mot. */
    fun boundariesOnWords(words: List<WordStamp>, planCount: Int): List<Double> {
        require(words.isNotEmpty()) { "horloge : aucun mot" }
        require(planCount in 1..words.size) { "horloge : plus de plans que de mots" }
        val step = words.size.toDouble() / planCount
        return (0 until planCount).map { i -> words[(i * step).toInt()].startS } + words.last().endS
    }

    /** Portes de controle : aucun plan > 3 s, moyenne <= 1,5 s, duree = voix. */
    fun validate(plans: List<BeatSheetPlan>, voiceDurationS: Double): List<String> {
        val problems = mutableListOf<String>()
        if (plans.isEmpty()) return listOf("beat sheet vide")
        val durations = plans.map { it.t1 - it.t0 }
        if (durations.average() > AVG_PLAN_MAX_S) problems += "plan moyen > 1,5 s"
        if (durations.max() > PLAN_MAX_S) problems += "plan > 3 s"
        val total = plans.last().t1 - plans.first().t0
        if (kotlin.math.abs(total - voiceDurationS) > DURATION_TOLERANCE_S) {
            problems += "duree video != duree voix"
        }
        if (plans.zipWithNext().any { (a, b) -> a.t1 != b.t0 }) problems += "bornes non contigues"
        return problems
    }
}
