package video.vitrine.feature.catalog

/**
 * D42.34 (ordre finalisation visuelle §5.1) : aperçus photographiques RÉELS
 * par gabarit du catalogue — « les blocs colorés génériques ne remplacent
 * pas de véritables aperçus visuels ». Une image originale générée pour le
 * projet (aucune licence tierce, registre GENERATED_ASSETS) par gabarit.
 *
 * Contrat : resPour() renvoie null quand l'aperçu n'existe pas encore —
 * la vignette dessinée de marque (D42.30) reste le repli honnête (jamais
 * un bloc gris, jamais une photo répétée pour tromper).
 */
internal object ApercuGabarit {

    private val map: Map<String, Int> = mapOf(
        "batiment_travaux_T1" to R.drawable.apercu_batiment_travaux_t1,
    )

    fun resPour(gabaritId: String?): Int? = gabaritId?.let { map[it] }
}
