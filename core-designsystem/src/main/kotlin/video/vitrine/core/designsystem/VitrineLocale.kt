package video.vitrine.core.designsystem

import android.content.Context
import android.content.res.Configuration
import java.util.Locale

/** Langue choisie a la premiere ouverture, persistee en preferences locales. */
object VitrineLocale {

    private const val PREFS = "vv_locale"
    private const val KEY = "lang"

    /** Codes supportes : francais, anglais, espagnol, japonais. */
    val SUPPORTED = listOf("fr", "en", "es", "ja")

    fun saved(context: Context): String? =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getString(KEY, null)

    fun save(context: Context, code: String) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit()
            .putString(KEY, code)
            .apply()
    }

    /** Contexte re-localise : chaque activite l'applique dans attachBaseContext. */
    fun wrap(context: Context): Context {
        val code = saved(context) ?: return context
        val locale = Locale(code)
        Locale.setDefault(locale)
        val configuration = Configuration(context.resources.configuration)
        configuration.setLocale(locale)
        return context.createConfigurationContext(configuration)
    }
}
