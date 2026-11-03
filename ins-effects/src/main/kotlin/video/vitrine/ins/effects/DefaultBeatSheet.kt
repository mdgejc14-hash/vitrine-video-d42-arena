package video.vitrine.ins.effects

/**
 * Beat sheet par defaut quand le serveur n'en fournit pas : horloge Whisper ESTIMEE
 * (mots ponderes par leur longueur sur la duree voix), bornes de plans sur la
 * beat-grid du gabarit si elle existe, sinon plans de 1,2 s (contrat <= 1,5 s moyen).
 * Le rendu reste deterministe : meme script + meme duree = meme beat sheet.
 */
object DefaultBeatSheet {

    const val PLAN_TARGET_S = 1.2
    private val TR_CYCLE = listOf("cut", "swipe", "flash", "glitch")

    fun wordClock(script: String, durationS: Double): List<WordStamp> {
        val tokens = script.split(Regex("\\s+")).filter { it.isNotBlank() }
        if (tokens.isEmpty() || durationS <= 0.0) return emptyList()
        val weights = tokens.map { it.length.toDouble() + 1.0 }
        val total = weights.sum()
        var cursor = 0.0
        return tokens.mapIndexed { index, token ->
            val span = durationS * weights[index] / total
            val stamp = WordStamp(token, cursor, cursor + span)
            cursor += span
            stamp
        }
    }

    fun fromScript(
        script: String,
        durationS: Double,
        dropAtSeconds: List<Double>
    ): MotionJson.BeatSheet {
        val words = wordClock(script, durationS)
        if (words.isEmpty()) return MotionJson.BeatSheet(emptyList(), emptyList(), emptySet())
        val drops = dropAtSeconds.filter { it >= 0.0 && it < durationS }.ifEmpty { uniformDrops(durationS) }
        val bounds = (listOf(0.0) + drops + durationS).distinct()
        val keywords = words.map { it.word }.filter { it.any(Char::isDigit) }.toSet()
        val plans = bounds.zipWithNext { start, end -> plan(start, end, bounds.indexOf(start), words, keywords) }
        return MotionJson.BeatSheet(plans, words, keywords)
    }

    private fun plan(
        start: Double,
        end: Double,
        index: Int,
        words: List<WordStamp>,
        keywords: Set<String>
    ): BeatSheetPlan {
        val punch = index % 2 == 0
        val shock = words.any { it.startS >= start && it.startS < end && keywords.contains(it.word) }
        return BeatSheetPlan(
            t0 = start,
            t1 = end,
            kind = "clip",
            inT = 0.0,
            fx = 0.5,
            fy = 0.5,
            zStart = if (punch) 1.10 else 1.00,
            zEnd = if (punch) 1.02 else 1.08,
            transition = TR_CYCLE[index % TR_CYCLE.size],
            shake = if (shock) 1.0 else 0.0,
            rushIndex = -1
        )
    }

    private fun uniformDrops(durationS: Double): List<Double> {
        val drops = mutableListOf<Double>()
        var t = 0.0
        while (t + PLAN_TARGET_S < durationS) {
            t += PLAN_TARGET_S
            drops += t
        }
        return drops
    }
}
