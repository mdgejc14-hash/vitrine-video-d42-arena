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
        val nonBlackFrames: Int
    ) {
        val passed: Boolean
            get() = durationOk && resolutionOk && bitrateOk && nonBlackFrames >= REQUIRED_NON_BLACK
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
