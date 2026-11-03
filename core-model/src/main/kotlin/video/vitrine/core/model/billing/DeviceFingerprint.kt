package video.vitrine.core.model.billing

import java.security.MessageDigest

/**
 * Empreinte appareil = verrou ANTI-ABUS du welcome grant (9.1) :
 * 1 telephone = 1 quota a vie, quel que soit le compte Google.
 * SHA-256(ANDROID_ID + Build.FINGERPRINT) ; >= 16 caracteres exiges cote serveur.
 */
object DeviceFingerprint {

    fun of(androidId: String, buildFingerprint: String): String {
        val digest = MessageDigest.getInstance("SHA-256")
        val bytes = digest.digest((androidId + "|" + buildFingerprint).toByteArray(Charsets.UTF_8))
        return bytes.joinToString("") { (it.toInt() and 0xFF).toString(16).padStart(2, '0') }
    }

    fun isValid(fingerprint: String): Boolean = fingerprint.length >= 16
}
