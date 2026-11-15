package video.vitrine.core.model

/**
 * D42.34 (CR-2, P0 ④) — contrat slots EXPLICITE pour les rushs du parcours
 * gabarit. L'index d'un rush dans la liste = l'index de sa prise
 * (`axes_signature.decoupage_prises` → `rushIndex` : prise_N → N-1).
 * Une entrée vide ("") = prise sans média : le moteur (RushSlots.resolve)
 * la remplace par la prise voisine — c'est le comportement D41 (F55) pour
 * les prises sautées au tournage, réutilisé à l'identique.
 *
 * Règle de fusion : la prise FILMÉE au guide caméra prime sur la prise
 * importée au brief (le média le plus frais gagne), index par index.
 * JAMAIS de concaténation aveugle : elle détacherait les rushs de leurs
 * prises (le rush importé 1 deviendrait prise_1 d'une liste allongée).
 */
object RushsImport {

    /** Clé réservée de la sauvegarde brief (brouillon) pour les slots importés. */
    const val CLE_SLOTS: String = "vv_rush_slots"

    /** Séparateur des slots sérialisés dans la clé réservée. */
    const val SEP: String = "\n"

    /** Fusion par slot : la prise filmée prime sur l'importée, index par index. */
    fun fusionParSlot(brief: List<String>?, cam: List<String>?): List<String>? {
        if (brief.isNullOrEmpty() && cam.isNullOrEmpty()) return null
        if (brief == null) return cam
        if (cam == null) return brief
        val taille = maxOf(brief.size, cam.size)
        return List(taille) { i ->
            cam.getOrNull(i)?.takeIf { it.isNotBlank() }
                ?: brief.getOrNull(i).orEmpty()
        }
    }

    /** Slots sérialisés pour le brouillon (clé réservée, aucune migration Room). */
    fun serialiser(slots: List<String>): String = slots.joinToString(SEP)

    /** Slots restaurés du brouillon, bornés au nombre de prises du gabarit. */
    fun deserialiser(brut: String?, prises: Int): List<String> {
        if (brut.isNullOrBlank() || prises <= 0) return emptyList()
        val lus = brut.split(SEP).take(prises)
        return List(prises) { i -> lus.getOrNull(i).orEmpty() }
    }
}
