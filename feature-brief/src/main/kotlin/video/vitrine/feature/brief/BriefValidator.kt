package video.vitrine.feature.brief

/**
 * Brief commerçant (ecran 6) : le script ecrit remplace l'ASR (5.3 : Whisper ne
 * supporte pas le fon ; l'upload audio couterait la data economisee).
 * Regles purees, testees JVM.
 *
 * Audit D41 (F67, P2) : les 4 messages d'erreur etaient du FRANCAIS en dur dans
 * la logique pure — langue figee quels que soient les parametres regionaux
 * (EN/ES/JA voyaient des erreurs FR). Le validateur renvoie desormais un id de
 * RESSOURCE + ses arguments ; la UI compose avec stringResource (traduit x4).
 * Les regles metier (bornes, ordre) restent pures et testables JVM.
 */
object BriefValidator {

    const val SCRIPT_MIN = 20
    const val SCRIPT_MAX = 600
    const val DURATION_MIN_S = 15
    const val DURATION_MAX_S = 60

    data class Result(
        val valid: Boolean,
        val messageRes: Int?,
        val messageArgs: List<Any> = emptyList()
    )

    fun validate(script: String, durationSeconds: Int, objective: String): Result = when {
        script.trim().length < SCRIPT_MIN ->
            Result(false, R.string.brief_err_min, listOf<Any>(SCRIPT_MIN))
        script.trim().length > SCRIPT_MAX ->
            Result(false, R.string.brief_err_max, listOf<Any>(SCRIPT_MAX))
        durationSeconds < DURATION_MIN_S || durationSeconds > DURATION_MAX_S ->
            Result(
                false,
                R.string.brief_err_duration,
                listOf<Any>(DURATION_MIN_S, DURATION_MAX_S)
            )
        objective.isBlank() ->
            Result(false, R.string.brief_err_objective)
        else -> Result(true, null)
    }

    /** Decoupage des sous-titres par scene depuis le script (5.3 script-first). */
    fun splitScenes(script: String, maxScenes: Int = 6): List<String> {
        val sentences = script.split(Regex("[.!?\\n]+")).map { it.trim() }.filter { it.isNotEmpty() }
        if (sentences.size <= maxScenes) return sentences
        val per = (sentences.size + maxScenes - 1) / maxScenes
        return sentences.chunked(per).map { it.joinToString(". ") }
    }
}
