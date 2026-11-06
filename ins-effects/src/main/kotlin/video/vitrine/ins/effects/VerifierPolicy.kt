package video.vitrine.ins.effects

/**
 * ExportVerifier (contrat 5.2) : l'application ne se fait pas confiance.
 * Criteres : duree, resolution, bitrate REEL, 3 images non noires.
 * Echec => replis ORDONNES : strategie portrait suivante -> encodeur logiciel
 * -> rendu cloud Modal (proxy 480p seulement). Logique pure, testee JVM.
 */
object VerifierPolicy {

    enum class Fallback { NEXT_PORTRAIT_STRATEGY, SOFTWARE_ENCODER, CLOUD_MODAL, EXHAUSTED }

    data class Checks(
        val durationOk: Boolean,
        val resolutionOk: Boolean,
        val bitrateOk: Boolean,
        val nonBlackFrames: Int,
        // D42.8.2 : un booleen ne suffisait pas. « le controle a reussi » et
        // « le controle n'a pas pu etre fait » ne sont pas la meme chose, et les
        // confondre transformait une absence de mesure en succes. Le verdict est
        // desormais explicite (voir AudioChecks.Verdict).
        val audioVerdict: AudioChecks.Verdict = AudioChecks.Verdict.NON_REQUIS
    ) {
        /** Le controle audio ne s'oppose pas a la sortie du fichier. */
        val audioOk: Boolean
            get() = audioVerdict == AudioChecks.Verdict.REUSSI ||
                audioVerdict == AudioChecks.Verdict.VERIFIE_PARTIELLEMENT ||
                audioVerdict == AudioChecks.Verdict.NON_REQUIS

        /** Controle OBLIGATOIRE sans mesure exploitable : ce n'est pas un echec
         *  prouve, mais ce n'est pas un succes non plus. */
        val audioNonVerifiable: Boolean
            get() = audioVerdict == AudioChecks.Verdict.NON_VERIFIABLE

        val passed: Boolean
            get() = durationOk && resolutionOk && bitrateOk && audioOk &&
                nonBlackFrames >= REQUIRED_NON_BLACK
    }

    const val REQUIRED_NON_BLACK = 3

    /** Marge conteneur : le bitrate MESURE (fichier/duree) inclut l'audio et
     *  les boites MP4, il depasse donc legerement le budget video demande. */
    const val BITRATE_CEILING_RATIO = 1.05f

    /** Plancher anti-famine : 0,015 bit par pixel et par image. En dessous,
     *  l'image est indigne d'une diffusion (blocs, texte illisible). */
    const val MIN_BITS_PER_PIXEL = 0.015

    /** Cadence de sortie du moteur (contrat 5.1, grille 30 FPS). */
    const val OUTPUT_FPS = 30

    /**
     * D42-F21 : le bitrate de classe est un BUDGET de diffusion, pas un plancher.
     *
     * Ancien controle : mesure >= 85 % de la cible. Il a effectivement revele un
     * vrai bug (D42-F18 : l'encodeur n'etait jamais configure, 2,6 Mbps pour une
     * demande de 11,8 Mbps), mais une fois le budget REELLEMENT transmis il
     * rejetait des fichiers parfaitement sains : contenu synthetique, encodeur
     * logiciel d'emulateur, 3,0 Mbps mesures pour 6,0 demandes (run 41602785868,
     * duree/resolution/noir conformes). Punir un encodage EFFICACE est un defaut :
     * au Benin la data est couteuse, un fichier plus leger a qualite egale est un
     * benefice, pas une anomalie.
     *
     * Nouveau controle, deux bornes et une seule responsabilite :
     *  - plafond : ne pas depasser le budget de classe (+5 % de marge conteneur) ;
     *  - plancher : ne pas descendre sous MIN_BITS_PER_PIXEL (fichier famine).
     * Le respect effectif de la consigne d'encodage reste journalise a chaque
     * tentative (D42-VERIF) pour le rapport.
     */
    fun bitrateOk(measuredBps: Long, targetBps: Int, width: Int, height: Int): Boolean {
        val plafond = (targetBps * BITRATE_CEILING_RATIO).toLong()
        val plancher = (width.toLong() * height * OUTPUT_FPS * MIN_BITS_PER_PIXEL).toLong()
        return measuredBps >= plancher && measuredBps <= plafond
    }

    /** Matrice des 3 replis (plan V2 6.9) : tentative 0,1,2 puis epuisement. */
    fun fallbackFor(attempt: Int): Fallback = when (attempt) {
        0 -> Fallback.NEXT_PORTRAIT_STRATEGY
        1 -> Fallback.SOFTWARE_ENCODER
        2 -> Fallback.CLOUD_MODAL
        else -> Fallback.EXHAUSTED
    }
}

/**
 * D42.8 — Controles AUDIO de l'export (le verificateur ne regardait que image,
 * duree, resolution et debit).
 *
 * Ce que ce bloc peut et ne peut pas faire, dit franchement :
 *  - il VERIFIE des faits mesures (piste audio presente ou non, duree audio
 *    coherente avec la video, conteneur lisible, absence de silence integral) ;
 *  - il ne mesure PAS le niveau (RMS/LUFS) : cela exigerait de decoder tout le
 *    flux audio, ce que MediaMetadataRetriever ne fait pas.
 *
 * Aucun echec n'est declenche quand le gabarit PREVOIT une video muette : c'est
 * l'appelant qui declare `audioAttendu`.
 */
object AudioChecks {

    /** Tolerance entre duree audio et duree video (ms) : derive de conteneur. */
    const val AUDIO_DURATION_TOLERANCE_MS = 250L

    /**
     * @param audioAttendu le gabarit a une BGM ou des SFX planifies
     * @param hasAudioTrack `METADATA_KEY_HAS_AUDIO`
     * @param audioDurationMs duree de la piste audio (0 si inconnue)
     * @param videoDurationMs duree du conteneur (mesuree)
     * @param framesNonSilencieuses nombre d'echantillons RMS > -50 dBFS releves
     *        par l'appelant, 0 si la mesure n'est pas disponible
     */
    /**
     * D42.8.2 — verdict explicite. Cinq etats, parce que trois situations
     * distinctes etaient confondues :
     *
     *  - [NON_REQUIS] : le gabarit ne prevoit pas d'audio. L'absence de piste
     *    n'est pas un defaut (video muette VOULUE) ;
     *  - [REUSSI] : tout ce qui est mesurable a ete mesure et est conforme ;
     *  - [VERIFIE_PARTIELLEMENT] : la duree de la piste est mesuree et coherente,
     *    mais le niveau n'est pas decode par MediaMetadataRetriever. Verification
     *    partielle, assumee et nommee comme telle — pas « pleinement reussi » ;
     *  - [NON_VERIFIABLE] : le controle OBLIGATOIRE (duree de la piste) n'a
     *    aucune mesure exploitable. Ni succes, ni echec : on ne sait pas ;
     *  - [ECHEC] : un fait mesurable contredit le contrat.
     *
     * Defaut corrige : `audioDurationMs <= 0` validait la coherence de duree.
     * Une duree illisible etait donc traitee comme une duree coherente, et un
     * export dont on ne savait rien sortait « verifie ».
     */
    enum class Verdict {
        NON_REQUIS,
        REUSSI,
        VERIFIE_PARTIELLEMENT,
        NON_VERIFIABLE,
        ECHEC
    }

    /**
     * @param audioAttendu le gabarit a une BGM ou des SFX planifies
     * @param hasAudioTrack `METADATA_KEY_HAS_AUDIO`
     * @param audioDurationMs duree de la piste audio, 0 si illisible
     * @param videoDurationMs duree du conteneur (mesuree)
     * @param framesNonSilencieuses nombre d'echantillons RMS > -50 dBFS releves
     *        par l'appelant, 0 si la mesure n'est pas disponible
     * @param mesureNiveauDisponible l'appelant a-t-il pu decoder le niveau ?
     */
    fun judge(
        audioAttendu: Boolean,
        hasAudioTrack: Boolean,
        audioDurationMs: Long,
        videoDurationMs: Long,
        framesNonSilencieuses: Int,
        mesureNiveauDisponible: Boolean
    ): Resultat {
        if (!audioAttendu) {
            // Video muette VOULUE : rien a verifier, donc rien a reprocher.
            return Resultat(
                audioPresent = true, dureeCoherente = true,
                silenceInexplique = false, verdict = Verdict.NON_REQUIS
            )
        }
        if (!hasAudioTrack) {
            // Fait mesure : pas de piste alors qu'on en attendait une.
            return Resultat(
                audioPresent = false, dureeCoherente = false,
                silenceInexplique = false, verdict = Verdict.ECHEC
            )
        }
        val dureeMesurable = audioDurationMs > 0L && videoDurationMs > 0L
        val dureeCoherente = dureeMesurable && kotlin.math.abs(
            audioDurationMs - videoDurationMs
        ) <= AUDIO_DURATION_TOLERANCE_MS
        if (dureeMesurable && !dureeCoherente) {
            // Piste tronquee : fait mesure, defaut prouve.
            return Resultat(true, false, false, Verdict.ECHEC)
        }
        if (mesureNiveauDisponible && framesNonSilencieuses == 0) {
            return Resultat(true, dureeCoherente, true, Verdict.ECHEC)
        }
        if (!dureeMesurable) {
            // Controle obligatoire sans mesure : on ne conclut pas.
            return Resultat(true, false, false, Verdict.NON_VERIFIABLE)
        }
        if (!mesureNiveauDisponible) {
            return Resultat(true, true, false, Verdict.VERIFIE_PARTIELLEMENT)
        }
        return Resultat(true, true, false, Verdict.REUSSI)
    }

    data class Resultat(
        val audioPresent: Boolean,
        val dureeCoherente: Boolean,
        val silenceInexplique: Boolean,
        val verdict: Verdict
    ) {
        /** Rien ne s'oppose a la sortie du fichier. NON_VERIFIABLE reste exclu :
         *  une absence de mesure n'est pas un succes. */
        val passed: Boolean
            get() = verdict == Verdict.REUSSI ||
                verdict == Verdict.VERIFIE_PARTIELLEMENT ||
                verdict == Verdict.NON_REQUIS

        val nonVerifiable: Boolean
            get() = verdict == Verdict.NON_VERIFIABLE
    }
}
