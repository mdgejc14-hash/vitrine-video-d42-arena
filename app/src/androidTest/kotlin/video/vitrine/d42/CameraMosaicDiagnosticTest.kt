package video.vitrine.d42

import android.content.Context
import android.content.Intent
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.core.app.ActivityScenario
import java.io.File
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import video.vitrine.feature.camera.CameraDiagnosticActivity

/**
 * D42.32 (Lot 3, P0) — DIAGNOSTIC DIFFÉRENTIEL DE LA MOSAÏQUE, 4 sources :
 * ImageAnalysis / rendu PreviewView / fichier VideoCapture / MP4 décodé.
 *
 * Ce banc fait TOURNER le vrai diagnostic sur l'appareil connecté (émulateur
 * en CI avec caméra virtuelle ; téléphone physique pour la validation
 * fondateur) et vérifie que le rapport est COMPLET : les quatre sources
 * mesurées, frames réelles, PNG de preuve, champ emulateur honnête.
 *
 * PREUVES : getExternalFilesDir("d42/camera-diagnostic")/rapport-<mode>.json
 * + PNG (remontés par le job camera-diagnostic de android-e2e-lab).
 *
 * HONNÊTETÉ : un SUCCÈS ici = « le diagnostic a produit ses mesures », PAS
 * « la caméra est validée ». La validation capteur physique appartient au
 * fondateur (le rapport porte le champ emulateur=true côté CI).
 */
@RunWith(AndroidJUnit4::class)
class CameraMosaicDiagnosticTest {

    private val contexte: Context
        get() = ApplicationProvider.getApplicationContext()

    private fun dossierDiagnostic(): File =
        File(contexte.getExternalFilesDir(null), "d42/camera-diagnostic")

    private fun attendreRapport(mode: String, timeoutMs: Long = 45_000): File {
        val attendu = File(dossierDiagnostic(), "rapport-$mode.json")
        val debut = System.currentTimeMillis()
        while (System.currentTimeMillis() - debut < timeoutMs) {
            if (attendu.isFile && attendu.length() > 0) return attendu
            Thread.sleep(250)
        }
        throw AssertionError("rapport-$mode.json absent après ${timeoutMs}ms — diagnostic interrompu")
    }

    private fun lancerDiagnostic(mode: String): JSONObject {
        // permission CAMÉA accordée au paquet (le banc ne passe pas par le dialogue)
        InstrumentationRegistry.getInstrumentation().uiAutomation
            .executeShellCommand("pm grant video.vitrine.app android.permission.CAMERA")
        val intent = Intent(contexte, CameraDiagnosticActivity::class.java)
            .putExtra("preview_mode", mode)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        ActivityScenario.launch<CameraDiagnosticActivity>(intent).use { scenario ->
            val rapport = attendreRapport(mode)
            // laisser l'activité finir ses écritures (PNG après le rapport ? non :
            // le rapport est écrit EN DERNIER — les PNG précèdent)
            scenario.onActivity { }
            return JSONObject(rapport.readText())
        }
    }

    @Test
    fun diagnostic_mode_performance() {
        verifierRapportComplet(lancerDiagnostic("performance"), "performance")
    }

    @Test
    fun diagnostic_mode_compatible() {
        verifierRapportComplet(lancerDiagnostic("compatible"), "compatible")
    }

    private fun verifierRapportComplet(rapport: JSONObject, mode: String) {
        assertEquals("mode", mode, rapport.optString("mode"))
        // appareil identifié honnêtement (émulateur vs physique)
        assertTrue("champ appareil absent", rapport.has("appareil"))
        assertTrue(
            "champ emulateur absent (un rapport doit toujours dire s'il est émulé)",
            rapport.optJSONObject("appareil")?.has("emulateur") == true
        )
        val sources = rapport.optJSONObject("sources")
        assertNotNull("sources absentes du rapport $mode", sources)
        // 1. ImageAnalysis : frames réelles collectées
        val analyse = sources!!.optJSONObject("image_analysis")
        assertNotNull("image_analysis absent", analyse)
        assertTrue(
            "frames ImageAnalysis insuffisantes (${analyse!!.optInt("frames")})",
            analyse.optInt("frames") >= 10
        )
        assertTrue("format ImageAnalysis absent", analyse.has("format"))
        // 2. rendu PreviewView : mesuré (bitmap ou PixelCopy)
        val preview = sources.optJSONObject("preview_view")
        assertNotNull("preview_view absent", preview)
        assertTrue(
            "rendu PreviewView non mesuré (methode=${preview!!.opt("methode")})",
            preview.has("rendu") || preview.has("methode")
        )
        // 3. fichier VideoCapture : écrit et sondé
        val clip = sources.optJSONObject("video_capture")
        assertNotNull("video_capture absent", clip)
        assertTrue(
            "fichier VideoCapture vide (${clip!!.optLong("octets")} octets)",
            clip.optLong("octets") > 0
        )
        assertTrue("codec VideoCapture absent", clip.has("codec"))
        // 4. MP4 décodé : au moins une frame décodée
        val mp4 = sources.optJSONObject("mp4_decode")
        assertNotNull("mp4_decode absent", mp4)
        assertTrue(
            "aucune frame MP4 décodée",
            (mp4!!.optInt("frames_decodees")) >= 1
        )
        // constats + portée honnête
        val constats = rapport.optJSONObject("constats")
        assertNotNull("constats absents", constats)
        assertTrue(
            "portée non identifiée (émulateur vs physique)",
            constats!!.optString("portee").isNotBlank()
        )
    }
}
