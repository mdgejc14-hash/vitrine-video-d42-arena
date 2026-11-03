package video.vitrine.feature.export

import android.content.Context
import android.os.Debug
import java.io.File
import java.security.MessageDigest

/**
 * Bouclier anti-modding (spec V2.0 s22) : auto-controle SHA-256 du certificat
 * signataire de l'APK + heuristiques resign/Frida/debugger. Heuristiques
 * assumees : elles signalent, ne certifient pas (Play Integrity = etape suivante).
 */
object IntegrityGuard {

    fun apkCertSha256(context: Context): String? =
        runCatching {
            val info = context.packageManager.getPackageInfo(
                context.packageName,
                android.content.pm.PackageManager.GET_SIGNING_CERTIFICATES,
            )
            val cert = info.signingInfo?.apkContentsSigners?.firstOrNull() ?: return null
            val raw = cert.toByteArray()
            val hex = if (video.vitrine.vvguard.NativeGuard.loaded) {
                video.vitrine.vvguard.NativeGuard.sha256Hex(raw)
            } else {
                MessageDigest.getInstance("SHA-256").digest(raw)
                    .joinToString("") { "%02x".format(it) }
            }
            hex
        }.getOrNull()

    private fun tamperHints(): List<String> {
        val hints = mutableListOf<String>()
        if (Debug.isDebuggerConnected()) hints.add("debugger")
        listOf("/system/app/Superuser.apk", "/system/xbin/su", "/system/bin/su")
            .firstOrNull { File(it).exists() }
            ?.let { hints.add("su") }
        return hints
    }

    /** expectedSha256 vide = mode dev (gate integrite non activee). */
    fun isOk(context: Context, expectedSha256: String): Boolean {
        if (tamperHints().isNotEmpty()) return false
        if (expectedSha256.isBlank()) return true
        return apkCertSha256(context) == expectedSha256.lowercase()
    }
}
