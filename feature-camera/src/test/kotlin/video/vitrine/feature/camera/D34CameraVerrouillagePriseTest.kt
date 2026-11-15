package video.vitrine.feature.camera

import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.Button
import android.widget.TextView
import androidx.test.core.app.ActivityScenario
import androidx.test.core.app.ApplicationProvider
import java.io.File
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import android.os.Looper
import video.vitrine.data.gabarits.GabaritJson

/**
 * D42.34-A — verrouillage caméra (ordre fondateur, corrections ciblées) :
 *
 * 1. une prise n'est valide que si son fichier existe, est un fichier
 *    régulier et possède une taille strictement > 0 ;
 * 2. Finalize sans erreur MAIS fichier vide → prise rejetée, fichier
 *    incomplet supprimé, prise à refaire ;
 * 3. « Suivant » ne contourne jamais une prise obligatoire sans rush
 *    valide ;
 * 4. finishWithPrises() ne rend RESULT_OK que si TOUS les slots requis
 *    par prises.size sont valides ;
 * 5. prise manquante → retour à SON index + message, montage NON lancé ;
 * 6. restauration de brouillon : les positions vides sont conservées,
 *    jamais compactées.
 *
 * AUCUN nombre de prises codé en dur : le gabarit de référence
 * (vetements_mode_T1) et la matrice complète (30 gabarits / 81 prises,
 * 2 à 4 par modèle) sont lus depuis les JSON canoniques.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class D34CameraVerrouillagePriseTest {

    private fun ctx(): Context = ApplicationProvider.getApplicationContext()

    /** Matrice réelle : nb de prises du gabarit de référence, lu du JSON. */
    private fun nbPrisesReference(): Int {
        val raw = ctx().assets.open("gabarits/vetements_mode/T1.json")
            .use { it.readBytes().decodeToString() }
        return GabaritJson.parsePrises(raw).size
    }

    private fun fichierRush(nom: String, octets: Int): File {
        val dir = File(ctx().filesDir, "rushes_test").apply { mkdirs() }
        return File(dir, nom).apply { writeBytes(ByteArray(octets)) }
    }

    private fun lancer(
        restore: Array<String>? = null,
        restoreIdx: Int = -1,
    ): ActivityScenario<CameraGuideActivity> {
        val intent = Intent(ctx(), CameraGuideActivity::class.java)
            .putExtra("gabarit_id", "vetements_mode_T1")
            .putExtra("duration_s", 36)
        if (restore != null) {
            intent.putExtra("restore_prise_files", restore)
            intent.putExtra("restore_prise_idx", restoreIdx)
        }
        return ActivityScenario.launch(intent)
    }

    /** Attend le chargement réel des prises (seed Room asynchrone). */
    private fun attendrePrises(sc: ActivityScenario<CameraGuideActivity>) {
        val fin = System.currentTimeMillis() + 30_000
        var prets = false
        while (System.currentTimeMillis() < fin && !prets) {
            shadowOf(Looper.getMainLooper()).idle()
            sc.onActivity { a ->
                prets = a.findViewById<Button>(R.id.camera_next_button).visibility == View.VISIBLE
            }
            if (!prets) Thread.sleep(150)
        }
        check(prets) { "prises du gabarit non chargées (seed DB absent)" }
        repeat(4) {
            shadowOf(Looper.getMainLooper()).idle()
            Thread.sleep(100)
        }
    }

    private fun cliquerSuivant(sc: ActivityScenario<CameraGuideActivity>) {
        sc.onActivity { a -> a.findViewById<Button>(R.id.camera_next_button).performClick() }
        repeat(4) {
            shadowOf(Looper.getMainLooper()).idle()
            Thread.sleep(100)
        }
    }

    private fun texteGuide(sc: ActivityScenario<CameraGuideActivity>): String {
        var texte = ""
        sc.onActivity { a -> texte = a.findViewById<TextView>(R.id.camera_guide_text).text.toString() }
        return texte
    }

    private fun estEnCoursDeFermeture(sc: ActivityScenario<CameraGuideActivity>): Boolean {
        var fin = false
        sc.onActivity { a -> fin = a.isFinishing }
        return fin
    }

    // ---- (0) matrice : 30 gabarits, 81 prises, 2 à 4 par modèle ----
    @Test
    fun matrice_gabarits_30_et_prises_81_de_2_a_4() {
        val secteurs = listOf(
            "batiment_travaux", "coiffure_beaute", "immo_auto",
            "restaurants_maquis", "shops_small_business", "vetements_mode",
        )
        var gabarits = 0
        var prises = 0
        val details = mutableListOf<String>()
        for (secteur in secteurs) {
            val fichiers = ctx().assets.list("gabarits/$secteur")?.filter { it.endsWith(".json") }.orEmpty()
            check(fichiers.isNotEmpty()) { "secteur illisible : $secteur" }
            for (f in fichiers) {
                val raw = ctx().assets.open("gabarits/$secteur/$f").use { it.readBytes().decodeToString() }
                val n = GabaritJson.parsePrises(raw).size
                check(n in 2..4) { "$f : $n prises (attendu 2..4, aucun compte en dur)" }
                gabarits++
                prises += n
                details.add("$f=$n")
            }
        }
        check(gabarits == 30) { "matrice : $gabarits gabarits (attendu 30)" }
        check(prises == 81) { "matrice : $prises prises (attendu 81)" }
    }

    // ---- (1) toutes les prises requises présentes → RESULT_OK ----
    @Test
    fun toutes_les_prises_requises_presentes_result_ok() {
        val n = nbPrisesReference()
        val rushs = (1..n).map { fichierRush("ok-$it.mp4", 2048) }
        val chemins = rushs.map { it.absolutePath }
        lancer(restore = chemins.toTypedArray(), restoreIdx = n - 1).use { sc ->
            attendrePrises(sc)
            cliquerSuivant(sc)
            val fin = System.currentTimeMillis() + 10_000
            while (System.currentTimeMillis() < fin && !estEnCoursDeFermeture(sc)) {
                shadowOf(Looper.getMainLooper()).idle()
                Thread.sleep(100)
            }
            var code = 0
            var donnees: Intent? = null
            sc.onActivity { a ->
                code = shadowOf(a).resultCode
                donnees = shadowOf(a).resultIntent
            }
            check(code == android.app.Activity.RESULT_OK) { "resultCode=$code (attendu RESULT_OK)" }
            val rushes = donnees!!.getStringArrayExtra("client_rushes")!!
            check(rushes.size == n) { "client_rushes.size=${rushes.size} (attendu $n)" }
            check(rushes.contentEquals(chemins.toTypedArray())) {
                "ordre des slots non préservé : ${rushes.toList()} vs $chemins"
            }
            check(donnees!!.getStringExtra("input") == rushs.first().absolutePath) { "input != premier rush" }
        }
    }

    // ---- (3) une prise manquante bloque la progression ----
    @Test
    fun prise_manquante_bloque_la_progression() {
        lancer().use { sc ->
            attendrePrises(sc)
            val n = nbPrisesReference()
            cliquerSuivant(sc)
            val attendu = ctx().getString(R.string.camera_take_required, 1, n)
            check(texteGuide(sc) == attendu) {
                "message = « ${texteGuide(sc)} » (attendu « $attendu »)"
            }
            check(!estEnCoursDeFermeture(sc)) { "l'activité ne doit pas se fermer : montage NON lancé" }
            // Un second appui reste bloqué sur la même prise.
            cliquerSuivant(sc)
            check(texteGuide(sc) == attendu) { "le 2e appui a contourné la prise obligatoire" }
            check(!estEnCoursDeFermeture(sc)) { "montage lancé malgré la prise manquante" }
        }
    }

    // ---- (2) un fichier vide est rejeté ----
    @Test
    fun fichier_vide_rejete() {
        val n = nbPrisesReference()
        // (a) un slot restauré pointant vers un fichier VIDE est invalide :
        // même verdict qu'une prise manquante, à SON index.
        val plein1 = fichierRush("plein-a.mp4", 4096)
        val vide = fichierRush("vide.mp4", 0)
        val plein3 = fichierRush("plein-c.mp4", 4096)
        lancer(restore = arrayOf(plein1.absolutePath, vide.absolutePath, plein3.absolutePath), restoreIdx = n - 1).use { sc ->
            attendrePrises(sc)
            cliquerSuivant(sc)
            val attendu = ctx().getString(R.string.camera_take_required, 2, n)
            check(texteGuide(sc) == attendu) {
                "fichier vide non rejeté à son index : « ${texteGuide(sc)} »"
            }
            check(!estEnCoursDeFermeture(sc)) { "RESULT_OK rendu avec un rush vide" }
        }
        // (b) Finalize SANS erreur mais fichier vide → rejet + suppression.
        lancer().use { sc ->
            attendrePrises(sc)
            val vide2 = fichierRush("vide-finalize.mp4", 0)
            sc.onActivity { a -> a.validerPriseFinalisee(hasError = false, file = vide2) }
            repeat(4) {
                shadowOf(Looper.getMainLooper()).idle()
                Thread.sleep(100)
            }
            check(!vide2.exists()) { "le fichier vide n'a pas été supprimé" }
            check(texteGuide(sc) == ctx().getString(R.string.camera_take_failed)) {
                "message d'échec absent : « ${texteGuide(sc)} »"
            }
            check(!estEnCoursDeFermeture(sc)) { "une prise vide ne doit jamais finir l'activité" }
            // (c) Finalize EN ERREUR → même verdict, fichier supprimé.
            val tourne = fichierRush("tourne.mp4", 4096)
            sc.onActivity { a -> a.validerPriseFinalisee(hasError = true, file = tourne) }
            repeat(4) {
                shadowOf(Looper.getMainLooper()).idle()
                Thread.sleep(100)
            }
            check(!tourne.exists()) { "le fichier incomplet n'a pas été supprimé (hasError)" }
            check(texteGuide(sc) == ctx().getString(R.string.camera_take_failed)) { "message d'échec absent (hasError)" }
        }
    }

    // ---- (6) un slot vide reste au même index après restauration ----
    @Test
    fun slot_vide_conserve_son_index_apres_restauration() {
        val n = nbPrisesReference()
        check(n >= 3) { "test conçu pour un gabarit d'au moins 3 prises (réel : $n)" }
        val r1 = fichierRush("slot-1.mp4", 2048)
        val r3 = fichierRush("slot-3.mp4", 2048)
        // Trou à l'index 1 : AVANT la correction, le filtre compactait et
        // r3 glissait à l'index 1 (message « Prise 3/n ») ; le comportement
        // correct signale la prise 2 MANQUANTE à l'index 1.
        lancer(restore = arrayOf(r1.absolutePath, "", r3.absolutePath), restoreIdx = n - 1).use { sc ->
            attendrePrises(sc)
            cliquerSuivant(sc)
            val attendu = ctx().getString(R.string.camera_take_required, 2, n)
            check(texteGuide(sc) == attendu) {
                "compactage détecté ou index erroné : « ${texteGuide(sc)} » (attendu « $attendu »)"
            }
            check(!estEnCoursDeFermeture(sc)) { "montage lancé avec un slot vide" }
            // Compléter la prise manquante à SON index puis finir : l'ordre
            // final [r1, nouveau, r3] prouve que le trou n'a pas décalé r3.
            sc.onActivity { a ->
                val champ = CameraGuideActivity::class.java.getDeclaredField("guideFlowActive")
                champ.isAccessible = true
                champ.set(a, true)
                a.validerPriseFinalisee(hasError = false, file = fichierRush("slot-2.mp4", 2048))
            }
            repeat(6) {
                shadowOf(Looper.getMainLooper()).idle()
                Thread.sleep(100)
            }
            cliquerSuivant(sc)
            val fin = System.currentTimeMillis() + 10_000
            while (System.currentTimeMillis() < fin && !estEnCoursDeFermeture(sc)) {
                shadowOf(Looper.getMainLooper()).idle()
                Thread.sleep(100)
            }
            var code = 0
            var donnees: Intent? = null
            sc.onActivity { a ->
                code = shadowOf(a).resultCode
                donnees = shadowOf(a).resultIntent
            }
            check(code == android.app.Activity.RESULT_OK) { "resultCode=$code après complétion" }
            val rushes = donnees!!.getStringArrayExtra("client_rushes")!!
            check(rushes.size == n) { "client_rushes.size=${rushes.size}" }
            check(rushes[0] == r1.absolutePath) { "slot 0 décalé" }
            check(rushes[1].endsWith("slot-2.mp4")) { "slot 1 incorrect : ${rushes[1]}" }
            check(rushes[2] == r3.absolutePath) { "slot 2 décalé (compactage) : ${rushes[2]}" }
        }
    }
}
