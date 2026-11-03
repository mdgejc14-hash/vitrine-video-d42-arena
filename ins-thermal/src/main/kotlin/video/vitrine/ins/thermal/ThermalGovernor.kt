package video.vitrine.ins.thermal

import android.content.Context
import android.os.PowerManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch

/**
 * Gouverne thermique 1 Hz STRICTE (contrat 4.3 ; V8 R&D : sondage plus rapide => NaN).
 * Regle T6 : refroidissement 90 s apres un export ayant depasse 0,5 de la marge.
 */
class ThermalGovernor(context: Context, private val scope: CoroutineScope) {

    private val powerManager =
        context.applicationContext.getSystemService(Context.POWER_SERVICE) as PowerManager

    private val _level = MutableStateFlow(ThermalLevel.OK)
    val level: StateFlow<ThermalLevel> = _level

    private var job: Job? = null

    fun start() {
        if (job?.isActive == true) return
        job = scope.launch {
            while (isActive) {
                _level.value = ThermalGate.decide(readHeadroom(), _level.value)
                delay(PERIOD_MS)
            }
        }
    }

    fun stop() {
        job?.cancel()
        job = null
    }

    private fun readHeadroom(): Float =
        if (android.os.Build.VERSION.SDK_INT >= 30) {
            powerManager.getThermalHeadroom(FORECAST_SECONDS)
        } else {
            when (powerManager.currentThermalStatus) {
                PowerManager.THERMAL_STATUS_SEVERE,
                PowerManager.THERMAL_STATUS_CRITICAL,
                PowerManager.THERMAL_STATUS_EMERGENCY,
                PowerManager.THERMAL_STATUS_SHUTDOWN -> ThermalGate.STOP_THRESHOLD + 0.1f
                PowerManager.THERMAL_STATUS_MODERATE -> ThermalGate.DEGRADE_THRESHOLD + 0.1f
                else -> 0f
            }
        }

    private companion object {
        const val PERIOD_MS = 1_000L
        const val FORECAST_SECONDS = 30
    }
}
