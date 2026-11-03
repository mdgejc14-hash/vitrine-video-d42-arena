package video.vitrine.vvguard

/**
 * Pont JNI du gardien natif : SHA-256 C pur et verification du tag global
 * VVSH1 cote natif (spec V2.0 s22). Le materiel de cle AES reste Keystore
 * (core-guard), aucune cle n'existe dans ce module natif.
 */
object NativeGuard {

    val loaded: Boolean = runCatching { System.loadLibrary("vvguard") }.isSuccess

    external fun sha256Hex(input: ByteArray): String
    external fun checkVvsh1(blob: ByteArray): Boolean
}
