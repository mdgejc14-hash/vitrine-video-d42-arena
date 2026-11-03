package video.vitrine.ins.thermal

import kotlin.math.ln

/**
 * Porte thermique predictive (R&D v2 4.5 / 7.2).
 *
 * getThermalHeadroom(forecastSeconds) PREDIT la marge future :
 * 0.0 = aucun throttling, 1.0 = throttling severe, peut depasser 1.0.
 * Pieges documentes AOSP : NaN si sonde trop souvent (=> 1 Hz strict),
 * la marge prime sur getCurrentThermalStatus (jamais attendre le statut).
 *
 * Fondement physique : dT(t) = P * R_th * (1 - exp(-t/tau)), tau = R_th * C_th.
 */
object ThermalGate {

    /** Seuils contractuels : degradation 0,70 (avance sur 0,80 AOSP), arret dur 1,00. */
    const val DEGRADE_THRESHOLD = 0.70f
    const val STOP_THRESHOLD = 1.00f

    /** Constantes a calibrer par mesure M2 sur le banc (3 appareils) avant decision. */
    const val DEFAULT_R_TH = 0.35f
    const val DEFAULT_C_TH = 11_520f

    fun tauSeconds(rTh: Float = DEFAULT_R_TH, cTh: Float = DEFAULT_C_TH): Float = rTh * cTh

    /**
     * Duree maximale de travail a puissance P (W) avant depassement de dTAllowed (K).
     * t_max = -tau * ln(1 - dT / (P * R_th)) ; NaN/infini si dT >= P*R_th (jamais tenable).
     */
    fun maxSustainedSeconds(
        powerW: Float,
        deltaTAllowedK: Float,
        rTh: Float = DEFAULT_R_TH,
        cTh: Float = DEFAULT_C_TH
    ): Float {
        val ceiling = powerW * rTh
        if (deltaTAllowedK >= ceiling || powerW <= 0f) return 0f
        return -tauSeconds(rTh, cTh) * ln(1f - deltaTAllowedK / ceiling)
    }

    /** Decision depuis la marge predite ; garde NaN (piège AOSP) => niveau courant conserve. */
    fun decide(headroom: Float, previous: ThermalLevel = ThermalLevel.OK): ThermalLevel = when {
        headroom.isNaN() -> previous
        headroom > STOP_THRESHOLD -> ThermalLevel.STOP
        headroom > DEGRADE_THRESHOLD -> ThermalLevel.DEGRADE
        else -> ThermalLevel.OK
    }
}
