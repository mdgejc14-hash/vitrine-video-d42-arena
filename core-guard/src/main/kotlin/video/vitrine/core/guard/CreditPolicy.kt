package video.vitrine.core.guard

/**
 * Semantique transactionnelle des credits (VV Remote QA s6, scenarios C01-C12).
 * Politique pure, testable JVM : le stockage Room/serveur est injecte par
 * l'appelant. Regle : reservation atomique (debit conditionnel si solde > 0),
 * confirmation sur succes d'export, compensation idempotente a l'echec via
 * export_id. Jamais de lecture suivie d'une ecriture independante.
 */
object CreditPolicy {

    const val WELCOME_TOTAL = 3

    /** C01/C10 : seed bienvenue une seule fois par compte/Appareil connu. */
    fun seedDecision(existingRow: Int?, serverGrantCached: Boolean, fingerprintKnown: Boolean): Int =
        when {
            existingRow != null -> existingRow
            serverGrantCached -> 0
            fingerprintKnown -> 0
            else -> WELCOME_TOTAL
        }

    /** C02-C04 : debit conditionnel ; renvoie le nouveau solde ou null si refuse. */
    fun debit(balance: Int): Int? = if (balance > 0) balance - 1 else null

    /** C05/C06 : tout chemin d'export passe par ici ; 0 = refus systematique. */
    fun exportAllowed(balance: Int, journalReserved: Boolean): Boolean =
        balance > 0 && journalReserved

    /** C07 : solde jamais negatif, au plus un debit confirme par export_id. */
    fun concurrentDebits(balance: Int, requests: Int): Pair<Int, Int> {
        val allowed = minOf(requests, balance.coerceAtLeast(0))
        return allowed to balance - allowed
    }

    /** C08 : compensation idempotente ; deja compense = aucun credit rendu. */
    fun compensate(balance: Int, alreadyCompensated: Boolean): Int =
        if (alreadyCompensated) balance else balance + 1

    /** C09 : horloge reculee = rollback detecte, export refuse (porte separate). */
    fun clockRollbackDenies(rollbackDetected: Boolean): Boolean = rollbackDetected
}
