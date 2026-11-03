package video.vitrine.core.guard

import java.security.MessageDigest
import javax.crypto.Cipher
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.SecretKeySpec

/**
 * Enveloppe VVSH1 (spec V2.0 s22) : magic 5 octets ASCII + nonce 12 + chiffre +
 * tag GCM 16 ; SHA-256 porte sur TOUS ces octets ; AAD = JSON RFC 8785 du bloc.
 * Cle AES = Keystore (keywrap VVSH1_KEYWRAP cote app), jamais en clair au repo.
 */
object Vvsh1 {

    const val MAGIC = "VVSH1"
    const val NONCE_BYTES = 12
    const val TAG_BITS = 128

    fun pack(nonce: ByteArray, cipherWithTag: ByteArray): ByteArray {
        require(nonce.size == NONCE_BYTES) { "nonce 12 octets requis" }
        val body = MAGIC.toByteArray(Charsets.US_ASCII) + nonce + cipherWithTag
        return body + sha256(body)
    }

    /** Verifie magic + tag SHA-256 global ; rend (nonce, chiffre+tagGCM) ou null. */
    fun unpack(blob: ByteArray): Pair<ByteArray, ByteArray>? {
        if (blob.size < MAGIC.length + NONCE_BYTES + 16 + 32) return null
        val body = blob.copyOfRange(0, blob.size - 32)
        val digest = blob.copyOfRange(blob.size - 32, blob.size)
        if (!MessageDigest.isEqual(sha256(body), digest)) return null
        if (!body.copyOfRange(0, MAGIC.length).toString(Charsets.US_ASCII).contentEquals(MAGIC)) return null
        val nonce = body.copyOfRange(MAGIC.length, MAGIC.length + NONCE_BYTES)
        val cipher = body.copyOfRange(MAGIC.length + NONCE_BYTES, body.size)
        return nonce to cipher
    }

    fun encrypt(key: SecretKeySpec, nonce: ByteArray, plaintext: ByteArray, aad: String): ByteArray {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, key, GCMParameterSpec(TAG_BITS, nonce))
        cipher.updateAAD(aad.toByteArray(Charsets.UTF_8))
        return pack(nonce, cipher.doFinal(plaintext))
    }

    fun decrypt(key: SecretKeySpec, blob: ByteArray, aad: String): ByteArray? {
        val unpacked = unpack(blob) ?: return null
        val (nonce, cipherWithTag) = unpacked
        return runCatching {
            val cipher = Cipher.getInstance("AES/GCM/NoPadding")
            cipher.init(Cipher.DECRYPT_MODE, key, GCMParameterSpec(TAG_BITS, nonce))
            cipher.updateAAD(aad.toByteArray(Charsets.UTF_8))
            cipher.doFinal(cipherWithTag)
        }.getOrNull()
    }

    fun sha256(bytes: ByteArray): ByteArray =
        MessageDigest.getInstance("SHA-256").digest(bytes)
}
