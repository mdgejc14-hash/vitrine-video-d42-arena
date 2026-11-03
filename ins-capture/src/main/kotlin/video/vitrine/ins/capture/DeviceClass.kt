package video.vitrine.ins.capture

/**
 * Classes d'appareils MESUREES (contrat 4.2) : DeviceProfiler + EncoderProbe + marge
 * thermique au repos. Aucun nom commercial n'est cru ; le banc CI et le parc decident.
 */
enum class DeviceClass { A, B, C, D }

/** Regime de capture par classe : 30 FPS strict, bitrate eleve, sur-echantillonnage. */
data class CaptureSpec(
    val deviceClass: DeviceClass,
    val captureBitrateBps: Int,
    val captureHeight: Int,
    val exportHeight: Int,
    val hotSeason: Boolean = false
) {
    companion object {
        /** Echelle de bitrate capture 40/30/20/14 Mbps (contrat 4.1, R&D v1 6.3a). */
        fun forClass(deviceClass: DeviceClass, hotSeason: Boolean = false): CaptureSpec = when (deviceClass) {
            DeviceClass.A -> CaptureSpec(deviceClass, 40_000_000, 2160, 1080, hotSeason)
            DeviceClass.B -> CaptureSpec(deviceClass, 30_000_000, 2160, 1080, hotSeason)
            DeviceClass.C -> CaptureSpec(deviceClass, 20_000_000, 1080, 1080, hotSeason)
            DeviceClass.D -> CaptureSpec(deviceClass, 14_000_000, 1080, if (hotSeason) 720 else 1080, hotSeason)
        }

        /**
         * Regle T8 (contrat 4.3) : 720p en saison chaude sur classes C/D.
         * La degradation retire du nettoyage, jamais de la fidelite (R&D v2 7.3).
         */
        fun exportHeightFor(spec: CaptureSpec): Int =
            if (spec.hotSeason && (spec.deviceClass == DeviceClass.C || spec.deviceClass == DeviceClass.D)) {
                720
            } else {
                spec.exportHeight
            }
    }
}
