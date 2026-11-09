package video.vitrine.core.guard

/**
 * D42.27 (exigence §8 / 5.7) — contrôle PRÉVENTIF de l'espace disque avant
 * les opérations lourdes (enregistrement, export, téléchargement).
 *
 * Règles produit :
 *  - AVERTIR et REFUSER PROPREMENT quand l'espace est insuffisant (message
 *    localisé côté UI) — l'utilisateur ne découvre l'échec qu'APRÈS avoir
 *    joué sa scène sinon ;
 *  - NE JAMAIS supprimer silencieusement des rushs ou un projet utilisateur :
 *    ce garde ne touche à aucun fichier ; la purge des fichiers TEMPORAIRES
 *    au lancement (MainActivity, D41) reste la seule suppression automatique ;
 *  - l'échec réel pendant une prise reste couvert par le Finalize F53
 *    (fichier corrompu supprimé + message + reprise) — ce garde est la
 *    PREMIÈRE ligne, pas un remplacement.
 *
 * Seuil d'une prise : une scène guide dure ~12 s ; CaptureSpec cible FHD
 * (bitrate ~8-12 Mbps) → ~12-18 Mo par prise. On exige 64 Mo disponibles
 * (marge > 4x) : couvre la prise + le fragment MP4 + l'entrelacement export.
 */
object StorageGate {

    /** Espace minimal exigé avant de DÉMARRER une prise (64 Mo). */
    const val SEUIL_PRISE_OCTETS: Long = 64L * 1024 * 1024

    /** Espace minimal exigé avant un export/montage (300 Mo : MP4 + audio). */
    const val SEUIL_EXPORT_OCTETS: Long = 300L * 1024 * 1024

    /** Espace minimal exigé avant un téléchargement de piste (8 Mo/piste + marge). */
    const val SEUIL_TELECHARGEMENT_OCTETS: Long = 32L * 1024 * 1024

    /** Décision pure (testée JVM) : disponible contre requis. */
    fun espaceSuffisant(disponibleOctets: Long, requisOctets: Long = SEUIL_PRISE_OCTETS): Boolean =
        disponibleOctets >= requisOctets

    /**
     * Recommandation de seuil dynamique si le bitrate cible est connu :
     * durée maximale d'une prise (s) × bitrate (o/s) × marge 3, plancher 64 Mo.
     */
    fun requisPourPrise(dureeMaxSecondes: Int, bitrateBps: Long): Long {
        val brute = dureeMaxSecondes.toLong() * (bitrateBps / 8) * 3
        return maxOf(brute, SEUIL_PRISE_OCTETS)
    }
}
