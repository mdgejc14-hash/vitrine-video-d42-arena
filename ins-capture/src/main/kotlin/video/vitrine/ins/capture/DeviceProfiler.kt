package video.vitrine.ins.capture

import android.app.ActivityManager
import android.content.Context
import android.content.pm.ActivityInfo
import android.os.Build

/**
 * Profilage MESURE (contrat 4.2) : caracteristiques reelles, aucun nom commercial cru.
 * La classe provisoire est une heuristique ; la classe FINALE vient de l'EncoderProbe
 * (3 images encodees PUIS relues) + marge thermique au repos.
 */
class DeviceProfiler(private val context: Context) {

    data class Profile(
        val totalRamMb: Long,
        val cpuCores: Int,
        val apiLevel: Int,
        val screenOrientationLocked: Boolean
    )

    fun profile(): Profile {
        val activityManager =
            context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val info = android.app.ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(info)
        return Profile(
            totalRamMb = info.totalMem / (1024 * 1024),
            cpuCores = Runtime.getRuntime().availableProcessors(),
            apiLevel = Build.VERSION.SDK_INT,
            screenOrientationLocked = context.resources.configuration.orientation ==
                ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        )
    }

    companion object {
        /** Heuristique provisoire (seuils issus du banc ; EncoderProbe decide in fine). */
        fun provisionalClass(profile: Profile): DeviceClass = when {
            profile.totalRamMb >= 7_000 && profile.cpuCores >= 8 -> DeviceClass.A
            profile.totalRamMb >= 4_000 && profile.cpuCores >= 6 -> DeviceClass.B
            profile.totalRamMb >= 2_500 -> DeviceClass.C
            else -> DeviceClass.D
        }
    }
}
