package video.vitrine.ins.effects

/**
 * Spec d'export par classe (contrat 5.1) : H.264, bitrate diffusion par classe,
 * +18 % quand le grain est actif (le grain est couteux a compresser, R&D effet 6),
 * regle T8 : 720p saison chaude classes C/D.
 */
object ExportSpec {

    enum class ExportClass { A, B, C, D }

    data class ExportGeometry(val width: Int, val height: Int)

    private const val GRAIN_BITRATE_BOOST = 1.18f

    fun exportBitrateBps(exportClass: ExportClass, grainActive: Boolean): Int {
        val base = when (exportClass) {
            ExportClass.A -> 12_000_000
            ExportClass.B -> 10_000_000
            ExportClass.C -> 8_000_000
            ExportClass.D -> 6_000_000
        }
        return if (grainActive) (base * GRAIN_BITRATE_BOOST).toInt() else base
    }

    /**
     * D42-P1 : repli portrait = 2/3 de la geometrie primaire, dimensions paires.
     * 1080x1920 -> 720x1280 (production, regle T8) ; 540x960 -> 360x640 (profil
     * de validation). Le repli suit donc TOUJOURS la geometrie demandee : avant,
     * il etait code en dur a 720x1280 et ne s'appliquait pas aux profils reduits.
     */
    fun repli(primaire: ExportGeometry): ExportGeometry = ExportGeometry(
        (primaire.width * 2 / 3).let { it - it % 2 },
        (primaire.height * 2 / 3).let { it - it % 2 }
    )

    fun geometry(exportClass: ExportClass, hotSeason: Boolean): ExportGeometry =
        if (hotSeason && (exportClass == ExportClass.C || exportClass == ExportClass.D)) {
            ExportGeometry(720, 1280)
        } else {
            ExportGeometry(1080, 1920)
        }
}
