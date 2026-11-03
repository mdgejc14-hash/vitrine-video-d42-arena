package video.vitrine.ins.effects

/**
 * Repli VFR (bug Media3 #3357) : les horodatages variables sont recales sur une
 * grille 30 FPS STRICTE. Les trames tombant dans un emplacement deja occupe sont
 * ignorees (pas de VFR en sortie). Pur Kotlin, teste JVM.
 */
object VfrNormalizer {

    const val TARGET_FPS = 30
    private const val MICROS_PER_SECOND = 1_000_000L

    /**
     * @param timestampsUs horodatages d'entree (microsecondes, potentiellement VFR)
     * @return liste (indexTrameEntree -> horodatageNormaliseUs), trames dupliquees exclues
     */
    fun normalize(timestampsUs: List<Long>, targetFps: Int = TARGET_FPS): List<Pair<Int, Long>> {
        val slotUs = MICROS_PER_SECOND / targetFps
        val occupied = mutableSetOf<Long>()
        val result = mutableListOf<Pair<Int, Long>>()
        timestampsUs.forEachIndexed { index, ts ->
            val slot = ((ts + slotUs / 2) / slotUs) * slotUs
            if (occupied.add(slot)) {
                result += index to slot
            }
        }
        return result
    }

    /** Duree attendue d'une sortie CFR pour n trames. */
    fun cfrDurationUs(frameCount: Int, targetFps: Int = TARGET_FPS): Long =
        frameCount * (MICROS_PER_SECOND / targetFps)
}
