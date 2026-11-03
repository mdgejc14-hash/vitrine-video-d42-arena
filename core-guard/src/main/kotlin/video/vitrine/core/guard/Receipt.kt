package video.vitrine.core.guard

import java.security.KeyPair
import java.security.Signature
import java.security.interfaces.ECPublicKey

/**
 * Recu d'export signe ECDSA P-256/SHA-256 (spec V2.0 s22) : JSON canonise RFC 8785
 * (cles triees, UTF-8, sans le champ signature), signature DER puis base64url.
 * Cle privee = Keystore appareil (jamais dans l'APK) ; fallback logiciel signale.
 */
object Receipt {

    /** Canonicalisation RFC 8785 minimale : objet plat, cles triees, valeurs echappees UTF-8. */
    fun canonicalize(fields: Map<String, String>): String =
        fields.toSortedMap().entries.joinToString(",", "{", "}") { (k, v) ->
            "\"$k\":\"${escape(v)}\""
        }

    private fun escape(v: String): String =
        v.replace("\\", "\\\\").replace("\"", "\\\"")

    fun sign(canonical: String, keyPair: KeyPair): String {
        val sig = Signature.getInstance("SHA256withECDSA")
        sig.initSign(keyPair.private)
        sig.update(canonical.toByteArray(Charsets.UTF_8))
        return java.util.Base64.getUrlEncoder().withoutPadding().encodeToString(sig.sign())
    }

    fun verify(canonical: String, signatureB64Url: String, publicKey: ECPublicKey): Boolean =
        runCatching {
            val sig = Signature.getInstance("SHA256withECDSA")
            sig.initVerify(publicKey)
            sig.update(canonical.toByteArray(Charsets.UTF_8))
            sig.verify(java.util.Base64.getUrlDecoder().decode(signatureB64Url))
        }.getOrElse { false }
}
