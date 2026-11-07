package video.vitrine.data.audio

/**
 * Sélection D42.21 d'une musique parmi les 20 variations du gabarit.
 *
 * Logique PURE (aucune dépendance Android — testable JVM, Random injectable :
 * déterministe en tests, aléatoire en production via BgmStore).
 *
 * Règles (ordre de priorité) :
 *  1. ne considérer QUE les variations EN_LIGNE du gabarit demandé
 *     (le filtre serveur secteur+format est revérifié ici : jamais de piste
 *     d'un autre secteur/gabarit, même si la réponse était corrompue) ;
 *  2. exclure les K dernières pistes utilisées de ce gabarit (anti-répétition,
 *     K = HISTOIRE_TAILLE) ; si tout est exclu, retomber sur l'ensemble
 *     complet plutôt que d'échouer ;
 *  3. choix uniforme dans l'ensemble restant ;
 *  4. liste vide → null (l'appelant replie sur le chemin titulaire).
 */
object BgmSelection {

    /** Taille de l'historique anti-répétition par gabarit. */
    const val HISTOIRE_TAILLE = 4

    fun choisir(
        variations: List<BgmLibraryParser.Variation>,
        gabaritId: String,
        historique: List<String> = emptyList(),
        random: kotlin.random.Random = kotlin.random.Random.Default
    ): BgmLibraryParser.Variation? {
        val candidats = variations.filter {
            it.gabaritId == gabaritId && it.statut == "EN_LIGNE" && it.variation >= 1
        }
        if (candidats.isEmpty()) return null
        val recentes = historique.takeLast(HISTOIRE_TAILLE).toSet()
        val fraiches = candidats.filter { it.pisteId !in recentes }
        val ensemble = fraiches.ifEmpty { candidats }
        return ensemble[random.nextInt(ensemble.size)]
    }

    /** Nouvel historique après usage de [pisteId] (borné à HISTOIRE_TAILLE). */
    fun pousserHistorique(historique: List<String>, pisteId: String): List<String> =
        (historique + pisteId).takeLast(HISTOIRE_TAILLE)
}
