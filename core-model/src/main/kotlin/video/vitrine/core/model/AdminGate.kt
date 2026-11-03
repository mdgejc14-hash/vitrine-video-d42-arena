package video.vitrine.core.model

/** Porte d'acces administrateur : liste d'emails Gmail injectee sans recompiler l'UI. */
object AdminGate {

    fun isAdmin(email: String?, configuredEmails: String): Boolean {
        val target = email?.trim()?.lowercase() ?: return false
        if (target.isEmpty()) return false
        return configuredEmails
            .split(',')
            .map { it.trim().lowercase() }
            .contains(target)
    }
}
