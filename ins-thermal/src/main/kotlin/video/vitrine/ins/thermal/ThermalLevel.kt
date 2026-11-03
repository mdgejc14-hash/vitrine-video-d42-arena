package video.vitrine.ins.thermal

/** Niveaux de la gouverne thermique (contrat V7-FINAL 4.3, R&D v2 7.3). */
enum class ThermalLevel {
    /** Marge <= 0,70 : pleine charge autorisee. */
    OK,

    /** Marge > 0,70 : descente d'un niveau (bitrate/resolution/effets GPU). */
    DEGRADE,

    /** Marge > 1,00 : arret propre, reprise planifiee. */
    STOP
}
