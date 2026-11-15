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
 *
 * Généré par scripts/process_catalog_asset_queue.py (emit-map) —
 * 11 entrées intégrées / 30.
 */
internal object ApercuGabarit {

    private val map: Map<String, Int> = mapOf(
        "batiment_travaux_T1" to R.drawable.apercu_batiment_travaux_t1,
        "batiment_travaux_T2" to R.drawable.apercu_batiment_travaux_t2,
        "batiment_travaux_T3" to R.drawable.apercu_batiment_travaux_t3,
        "batiment_travaux_T4" to R.drawable.apercu_batiment_travaux_t4,
        "batiment_travaux_T5" to R.drawable.apercu_batiment_travaux_t5,
        "coiffure_beaute_T1" to R.drawable.apercu_coiffure_beaute_t1,
        "coiffure_beaute_T2" to R.drawable.apercu_coiffure_beaute_t2,
        "coiffure_beaute_T3" to R.drawable.apercu_coiffure_beaute_t3,
        "coiffure_beaute_T4" to R.drawable.apercu_coiffure_beaute_t4,
        "coiffure_beaute_T5" to R.drawable.apercu_coiffure_beaute_t5,
        "immo_auto_T1" to R.drawable.apercu_immo_auto_t1,
    )

    fun resPour(gabaritId: String?): Int? = gabaritId?.let { map[it] }
}
