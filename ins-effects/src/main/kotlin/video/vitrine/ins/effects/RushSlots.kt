package video.vitrine.ins.effects

/**
 * Alignement prises -> rushs (audit D41, F55).
 *
 * Le guide E6 permet de PASSER une prise (« Suivant » sans enregistrer). Avant ce
 * correctif, les fichiers etaient transmis COMPACTES : une prise sautee decalait
 * toutes les scenes suivantes sur le mauvais rush (rid = prise_N-1 absolu cote
 * beat sheet, index compacte cote fichier). Contrat : la camera transmet un
 * tableau ALIGNE sur les indices de prises, "" = prise absente.
 *
 * [resolve] remplace chaque creux par le rush non vide le plus proche (precedent
 * d'abord, sinon suivant) : une prise sautee reutilise la prise voisine au lieu
 * de decaler tout le montage. Liste entierement vide -> liste vide (l'appelant
 * retombe sur le chemin mono-rush historique). Pur, testable JVM.
 */
object RushSlots {

    const val MISSING = ""

    fun resolve(slots: List<String>): List<String> {
        if (slots.isEmpty()) return slots
        val derniers = arrayOfNulls<String>(slots.size)
        var precedent: String? = null
        slots.forEachIndexed { i, slot ->
            if (slot.isNotBlank()) precedent = slot
            derniers[i] = precedent
        }
        var suivant: String? = null
        val out = arrayOfNulls<String>(slots.size)
        for (i in slots.indices.reversed()) {
            if (slots[i].isNotBlank()) suivant = slots[i]
            out[i] = when {
                slots[i].isNotBlank() -> slots[i]
                derniers[i] != null -> derniers[i]
                else -> suivant
            }
        }
        return out.map { it ?: MISSING }.filter { it != MISSING }
    }

    /** Premier rush reel (entree du chemin historique mono-rush), null si aucun. */
    fun firstReal(slots: List<String>): String? = slots.firstOrNull { it.isNotBlank() }
}
