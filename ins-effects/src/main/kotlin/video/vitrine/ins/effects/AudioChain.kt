package video.vitrine.ins.effects

/**
 * Chaine de mixage du pipeline reproductible (mesuree, pas reglee a l'oreille).
 * Media3 1.11 ne fournit ni compresseur sidechain ni loudnorm : le mix complet
 * (ducking, loudnorm I=-14 / TP=-1,0) reste execute au banc ffmpeg ; l'app garde
 * le contrat chiffre et le verifie (ExportVerifier).
 */
object AudioChain {

    const val VOICE_HIGHPASS_HZ = 85
    const val VOICE_LOWPASS_HZ = 15000
    const val VOICE_COMP_THRESHOLD_DB = -18.0
    const val VOICE_COMP_RATIO = 3.0
    const val VOICE_ATTACK_MS = 8
    const val VOICE_RELEASE_MS = 180
    const val VOICE_MAKEUP_DB = 2.0
    const val VOICE_LOUDNESS_I = -15.0
    const val VOICE_TRUE_PEAK_DB = -1.2
    const val VOICE_VOLUME = 1.06
    const val MUSIC_VOLUME_DB = -20.0
    const val MUSIC_FADE_IN_S = 0.45
    const val MUSIC_FADE_OUT_S = 0.75
    const val DUCK_THRESHOLD = 0.045
    const val DUCK_RATIO = 4.0
    const val DUCK_ATTACK_MS = 12
    const val DUCK_RELEASE_MS = 260
    const val MASTER_LOUDNESS_I = -14.0
    const val MASTER_TRUE_PEAK_DB = -1.0

    /** Filtre voix ffmpeg exact du pipeline livré (reproductible au banc). */
    fun ffmpegVoiceFilter(): String =
        "highpass=f=$VOICE_HIGHPASS_HZ,lowpass=f=$VOICE_LOWPASS_HZ," +
            "compand=attacks=$VOICE_ATTACK_MS:decays=$VOICE_RELEASE_MS:" +
            "points=-80|-80:-$VOICE_COMP_THRESHOLD_DB|-${-VOICE_COMP_THRESHOLD_DB / VOICE_COMP_RATIO}:0|0," +
            "loudnorm=I=$VOICE_LOUDNESS_I:TP=$VOICE_TRUE_PEAK_DB,volume=$VOICE_VOLUME"

    /** Master ffmpeg : cible loudness -14 LUFS, crete vraie -1,0 dBTP. */
    fun ffmpegMasterFilter(): String =
        "loudnorm=I=$MASTER_LOUDNESS_I:TP=$MASTER_TRUE_PEAK_DB"

    /** Ducking sidechain : musique ecrasee par la voix (seuils mesures). */
    fun ffmpegDuckingFilter(): String =
        "sidechaincompress=threshold=$DUCK_THRESHOLD:ratio=$DUCK_RATIO:" +
            "attack=$DUCK_ATTACK_MS:release=$DUCK_RELEASE_MS"
}
