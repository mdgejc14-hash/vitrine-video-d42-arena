package video.vitrine.feature.camera

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.ImageFormat
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.media.MediaMetadataRetriever
import android.os.Build
import android.os.Bundle
import android.view.SurfaceView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeoutOrNull
import org.json.JSONArray
import org.json.JSONObject
import video.vitrine.core.designsystem.VitrineActivity
import video.vitrine.ins.capture.CaptureSpec
import video.vitrine.ins.capture.DeviceClass
import video.vitrine.ins.capture.InsCameraBinder
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import kotlin.math.abs
import kotlin.math.max
import kotlin.math.min
import kotlin.math.sqrt

/**
 * D42.32 (Lot 3, P0) — DIAGNOSTIC DIFFÉRENTIEL DE LA MOSAÏQUE CAMÉRA.
 *
 * Exigence fondatrice : AVANT TOUTE modification CameraX, mesurer les QUATRE
 * sources de l'image indépendamment :
 *   1. ImageAnalysis (frames YUV_420_888 brutes du capteur) ;
 *   2. rendu PreviewView (surface affichée au marchand) ;
 *   3. fichier VideoCapture (MP4 écrit par Recorder) ;
 *   4. MP4 décodé (MediaMetadataRetriever — ce que verra le montage).
 *
 * Pour chaque source : dimensions, format, orientation, timestamps,
 * statistiques de luminance (min/max/moyenne/σ), quadrants, grille 8×8
 * (structure en blocs = mosaïque), cast couleur. Le rapport JSON + les PNG
 * sont écrits dans getExternalFilesDir("d42/camera-diagnostic").
 *
 * HONNÊTETÉ :
 *  - le viseur N'est JAMAIS masqué ni altéré (le PreviewView reste visible,
 *    statut en dessous) ;
 *  - le champ "emulateur" identifie les résultats d'AVD — une preuve
 *    d'émulateur ne vaut JAMAIS validation capteur physique ;
 *  - aucun verdict automatique de « panne matériel » : les chiffres sont
 *    rapportés, l'interprétation appartient au diagnostic humain.
 *
 * Lancement (aucune entrée dans le parcours commercial) :
 *  - banc émulateur : CameraMosaicDiagnosticTest (androidTest, e2e-lab) ;
 *  - téléphone physique du fondateur (validation capteur) :
 *    adb install -r app-debug.apk && adb install -r app-debug-androidTest.apk
 *    adb shell am instrument -w -e class video.vitrine.d42.CameraMosaicDiagnosticTest \
 *      video.vitrine.app.test/androidx.test.runner.AndroidJUnitRunner
 *    puis : adb pull /sdcard/Android/data/video.vitrine.app/files/d42/camera-diagnostic/
 */
class CameraDiagnosticActivity : VitrineActivity() {

    private lateinit var executor: ExecutorService
    private lateinit var recorderLie: androidx.camera.video.Recorder
    private lateinit var previewView: PreviewView
    private lateinit var statut: TextView
    private val mode: String by lazy { intent.getStringExtra("preview_mode") ?: "performance" }
    private val horodatage = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US).format(Date())

    /** Accumulateur des frames ImageAnalysis (thread analyse). */
    private class Accumulateur {
        @Volatile var frames = 0
        @Volatile var largeur = 0
        @Volatile var hauteur = 0
        @Volatile var format = 0
        @Volatile var tsPremier = 0L
        @Volatile var tsDernier = 0L
        @Volatile var lMin = 255
        @Volatile var lMax = 0
        var lSomme = 0.0
        var lCarres = 0.0
        var echantillons = 0
        @Volatile var png: Bitmap? = null

        fun accumuler(image: ImageProxy) {
            frames++
            largeur = image.width
            hauteur = image.height
            format = image.format
            val ts = image.imageInfo.timestamp
            if (tsPremier == 0L && ts > 0) tsPremier = ts
            if (ts > tsDernier) tsDernier = ts
            val plan = image.planes[0]
            val buf = plan.buffer
            val pasY = max(1, image.height / 90)
            val pasX = max(1, image.width / 90)
            var y = 0
            while (y < image.height) {
                var x = 0
                while (x < image.width) {
                    val v = buf.get(y * plan.rowStride + x * plan.pixelStride).toInt() and 0xFF
                    if (v < lMin) lMin = v
                    if (v > lMax) lMax = v
                    lSomme += v
                    lCarres += v.toDouble() * v
                    echantillons++
                    x += pasX
                }
                y += pasY
            }
            if (png == null && frames >= 5) {
                png = bitmapPlanY(image, plan)
            }
        }

        private fun bitmapPlanY(image: ImageProxy, plan: ImageProxy.PlaneProxy): Bitmap {
            val w = min(480, image.width)
            val h = max(1, w * image.height / image.width)
            val bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888)
            val px = IntArray(w * h)
            val pasX = max(1, image.width / w)
            val pasY = max(1, image.height / h)
            for (j in 0 until h) {
                for (i in 0 until w) {
                    val v = plan.buffer.get(
                        (j * pasY) * plan.rowStride + (i * pasX) * plan.pixelStride
                    ).toInt() and 0xFF
                    px[j * w + i] = (0xFF shl 24) or (v shl 16) or (v shl 8) or v
                }
            }
            bmp.setPixels(px, 0, w, 0, 0, w, h)
            return bmp
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        executor = Executors.newSingleThreadExecutor()
        val racine = LinearLayout(this)
        racine.orientation = LinearLayout.VERTICAL
        previewView = PreviewView(this)
        previewView.implementationMode = if (mode == "compatible") {
            PreviewView.ImplementationMode.COMPATIBLE
        } else {
            PreviewView.ImplementationMode.PERFORMANCE
        }
        previewView.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f
        )
        statut = TextView(this)
        statut.setPadding(24, 24, 24, 24)
        statut.text = "Diagnostic caméra D42.32 — mode $mode"
        statut.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT
        )
        racine.addView(previewView)
        racine.addView(statut)
        setContentView(racine)
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
            != PackageManager.PERMISSION_GRANTED
        ) {
            statut.text = "Permission CAMÉRA refusée : aucun diagnostic possible (rapport honnête écrit)."
            lifecycleScope.launch { ecrireRapport(erreur = "permission_camera_refusee") }
            return
        }
        lifecycleScope.launch { diagnostiquer() }
    }

    private suspend fun diagnostiquer() {
        val acc = Accumulateur()
        val rapport = JSONObject()
        rapport.put("horodatage", horodatage)
        rapport.put("preview_mode_demande", mode)
        rapport.put("appareil", infoAppareil())
        rapport.put("capteur_arriere", infoCapteurArriere())
        try {
            etape("1/6 binding Preview + VideoCapture + ImageAnalysis")
            val provider = attendreProvider()
            val binder = InsCameraBinder(this)
            val useCases = binder.buildUseCases(CaptureSpec.forClass(DeviceClass.C))
            recorderLie = useCases.recorder
            val analysis = ImageAnalysis.Builder()
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_YUV_420_888)
                .build()
            analysis.setAnalyzer(executor) { image ->
                runCatching { acc.accumuler(image) }
                image.close()
            }
            // le viseur reste VISIBLE et réel : surface branchée (jamais masquée)
            useCases.preview.setSurfaceProvider(previewView.surfaceProvider)
            binder.bind(provider, this, useCases, analysis)

            etape("2/6 attente flux STREAMING")
            val streaming = withTimeoutOrNull(10_000) {
                while (previewView.previewStreamState.value !=
                    PreviewView.StreamState.STREAMING
                ) delay(100
                )
                true
            } ?: false
            rapport.put("preview_streaming", streaming)

            etape("3/6 collecte frames ImageAnalysis")
            withTimeoutOrNull(6_000) { while (acc.frames < 30) delay(100) }
            rapport.put("sources", JSONObject().put("image_analysis", jsonAnalysis(acc)))

            etape("4/6 capture du rendu PreviewView")
            rapport.optJSONObject("sources")!!.put("preview_view", jsonPreview())

            etape("5/6 enregistrement VideoCapture 2 s")
            val fichier = File(cacheDir, "diag-$mode.mp4")
            val clip = enregistrer(fichier)
            rapport.optJSONObject("sources")!!.put("video_capture", clip)

            etape("6/6 décodage MP4 + rapport")
            rapport.optJSONObject("sources")!!.put("mp4_decode", jsonMp4Decode(fichier))
            rapport.put("constats", constats(rapport))
            ecrireRapport(rapport)
            etape("TERMINÉ — rapport dans files/d42/camera-diagnostic/")
        } catch (t: Throwable) {
            rapport.put("exception", "${t.javaClass.simpleName}: ${t.message}")
            ecrireRapport(rapport)
            etape("ÉCHEC : ${t.javaClass.simpleName} — rapport d'erreur écrit")
        }
    }

    private fun etape(texte: String) {
        runOnUiThread { statut.text = "Diagnostic caméra D42.32 — mode $mode\n$texte" }
    }

    private suspend fun attendreProvider(): ProcessCameraProvider =
        suspendCancellableCoroutine { suite ->
            val futur = ProcessCameraProvider.getInstance(this)
            futur.addListener(
                { suite.resumeWith(runCatching { futur.get() }) },
                ContextCompat.getMainExecutor(this)
            )
        }

    /** Source 3 : enregistre 2 s sur les use cases DÉJÀ liés (aucun re-bind
     *  qui fausserait la mesure : les trois sources partagent le même flux). */
    private suspend fun enregistrer(fichier: File): JSONObject {
        val finalise = CompletableDeferred<Unit>()
        val recording = recorderLie.prepare(
            this, androidx.camera.video.FileOutputOptions.Builder(fichier).build()
        ).start(executor) { ev ->
            if (ev is androidx.camera.video.VideoRecordEvent.Finalize) finalise.complete(Unit)
        }
        delay(2_000)
        recording.stop()
        withTimeoutOrNull(10_000) { finalise.await() }
        return withContext(Dispatchers.IO) {
            val json = JSONObject()
            json.put("fichier", fichier.name)
            json.put("octets", fichier.length())
            if (fichier.length() > 0) {
                runCatching {
                    val mmr = MediaMetadataRetriever()
                    mmr.setDataSource(fichier.absolutePath)
                    json.put("codec", mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_MIMETYPE) ?: "?")
                    json.put("largeur", mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH) ?: "?")
                    json.put("hauteur", mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT) ?: "?")
                    json.put("rotation", mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION) ?: "?")
                    json.put("duree_ms", mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION) ?: "?")
                    mmr.release()
                }
            }
            json
        }
    }

    /** Source 4 : décodage du MP4 (3 frames) — ce que consommera le montage. */
    private suspend fun jsonMp4Decode(fichier: File): JSONObject = withContext(Dispatchers.IO) {
        val json = JSONObject()
        val frames = JSONArray()
        var decodees = 0
        if (fichier.length() > 0) {
            runCatching {
                val mmr = MediaMetadataRetriever()
                mmr.setDataSource(fichier.absolutePath)
                for (i in 0 until 3) {
                    val bmp = mmr.getFrameAtTime(
                        i * 500_000L, MediaMetadataRetriever.OPTION_CLOSEST_SYNC
                    )
                    if (bmp != null) {
                        decodees++
                        val nom = "mp4-$mode-frame-$i.png"
                        ecrirePng(bmp, nom)
                        frames.put(jsonBitmap(bmp, nom))
                    }
                }
                mmr.release()
            }
        }
        json.put("frames_decodees", decodees)
        json.put("frames", frames)
        json
    }

    /** Source 2 : le rendu réel du PreviewView (TextureView bitmap ou PixelCopy SurfaceView). */
    private suspend fun jsonPreview(): JSONObject {
        val json = JSONObject()
        runCatching {
            json.put("mode_impl", previewView.implementationMode.name)
        }
        val bmp = runCatching { previewView.bitmap }.getOrNull()
        if (bmp != null) {
            val nom = "preview-$mode.png"
            ecrirePng(bmp, nom)
            json.put("methode", "PreviewView.bitmap")
            json.put("rendu", jsonBitmap(bmp, nom))
        } else {
            val vue = (previewView.getChildAt(0) as? SurfaceView)
            if (vue != null) {
                val copie = pixelCopier(vue)
                if (copie != null) {
                    val nom = "preview-$mode-pixelcopy.png"
                    ecrirePng(copie, nom)
                    json.put("methode", "PixelCopy(SurfaceView)")
                    json.put("rendu", jsonBitmap(copie, nom))
                } else {
                    json.put("methode", "PixelCopy échoué (surface non lisible)")
                }
            } else {
                json.put("methode", "bitmap null (mode PERFORMANCE sans SurfaceView accessible)")
            }
        }
        json.put("view_largeur", previewView.width)
        json.put("view_hauteur", previewView.height)
        json
    }

    private suspend fun pixelCopier(vue: SurfaceView): Bitmap? =
        suspendCancellableCoroutine { suite ->
            runCatching {
                val bmp = Bitmap.createBitmap(vue.width, vue.height, Bitmap.Config.ARGB_8888)
                PixelCopy.request(vue, bmp, { resultat ->
                    val ok = resultat == PixelCopy.SUCCESS
                    suite.resumeWith(
                        if (ok) runCatching { bmp } else Result.failure(IllegalStateException("PixelCopy=$resultat"))
                    )
                }, android.os.Handler(mainLooper))
            }.onFailure { suite.resumeWith(runCatching { null }) }
        }

    private fun jsonAnalysis(acc: Accumulateur): JSONObject {
        val json = JSONObject()
        json.put("frames", acc.frames)
        json.put("largeur", acc.largeur)
        json.put("hauteur", acc.hauteur)
        json.put("format", if (acc.format == ImageFormat.YUV_420_888) "YUV_420_888(35)" else acc.format.toString())
        json.put("timestamp_premier_ns", acc.tsPremier)
        json.put("timestamp_dernier_ns", acc.tsDernier)
        json.put("timestamp_delta_ns", acc.tsDernier - acc.tsPremier)
        val n = max(1, acc.echantillons)
        val moyenne = acc.lSomme / n
        val variance = max(0.0, acc.lCarres / n - moyenne * moyenne)
        val lum = JSONObject()
        lum.put("min", acc.lMin)
        lum.put("max", acc.lMax)
        lum.put("moyenne", String.format(Locale.US, "%.1f", moyenne))
        lum.put("sigma", String.format(Locale.US, "%.1f", sqrt(variance)))
        json.put("luminance_plan_y", lum)
        acc.png?.let {
            val nom = "analysis-$mode.png"
            ecrirePngSync(it, nom)
            json.put("png", nom)
        }
        return json
    }

    /** Stats pixels d'un bitmap : luminance, quadrants, grille 8×8, cast couleur. */
    private fun jsonBitmap(bmp: Bitmap, nom: String): JSONObject {
        val pas = max(1, min(bmp.width, bmp.height) / 180)
        var lMin = 255
        var lMax = 0
        var somme = 0.0
        var carres = 0.0
        var r = 0.0
        var g = 0.0
        var b = 0.0
        var n = 0
        val grille = Array(8) { DoubleArray(8) }
        val compteur = Array(8) { IntArray(8) }
        var y = 0
        while (y < bmp.height) {
            var x = 0
            while (x < bmp.width) {
                val p = bmp.getPixel(x, y)
                val rr = (p shr 16) and 0xFF
                val gg = (p shr 8) and 0xFF
                val bb = p and 0xFF
                val l = (rr * 299 + gg * 587 + bb * 114) / 1000
                if (l < lMin) lMin = l
                if (l > lMax) lMax = l
                somme += l
                carres += l.toDouble() * l
                r += rr
                g += gg
                b += bb
                val cx = min(7, x * 8 / bmp.width)
                val cy = min(7, y * 8 / bmp.height)
                grille[cy][cx] += l
                compteur[cy][cx]++
                n++
                x += pas
            }
            y += pas
        }
        val moyenne = somme / max(1, n)
        val json = JSONObject()
        json.put("png", nom)
        json.put("largeur", bmp.width)
        json.put("hauteur", bmp.height)
        val lum = JSONObject()
        lum.put("min", lMin)
        lum.put("max", lMax)
        lum.put("moyenne", String.format(Locale.US, "%.1f", moyenne))
        lum.put(
            "sigma",
            String.format(Locale.US, "%.1f", sqrt(max(0.0, carres / max(1, n) - moyenne * moyenne)))
        )
        json.put("luminance", lum)
        json.put("r_moyen", String.format(Locale.US, "%.1f", r / max(1, n)))
        json.put("g_moyen", String.format(Locale.US, "%.1f", g / max(1, n)))
        json.put("b_moyen", String.format(Locale.US, "%.1f", b / max(1, n)))
        // grille 8×8 : structure en blocs (mosaïque) = forte disparité inter-cellules
        val cellules = JSONArray()
        var minCell = Double.MAX_VALUE
        var maxCell = -Double.MAX_VALUE
        for (j in 0 until 8) {
            for (i in 0 until 8) {
                val v = if (compteur[j][i] > 0) grille[j][i] / compteur[j][i] else 0.0
                cellules.put(String.format(Locale.US, "%.0f", v))
                minCell = min(minCell, v)
                maxCell = max(maxCell, v)
            }
        }
        json.put("grille_8x8", cellules)
        json.put("grille_ecart_max", String.format(Locale.US, "%.1f", maxCell - minCell))
        return json
    }

    /** Constats chiffrés — AUCUN verdict matériel automatique (honnêteté). */
    private fun constats(rapport: JSONObject): JSONObject {
        val json = JSONObject()
        val sources = rapport.optJSONObject("sources")
        val analyse = sources?.optJSONObject("image_analysis")
        val preview = sources?.optJSONObject("preview_view")?.optJSONObject("rendu")
        val mp4 = sources?.optJSONObject("mp4_decode")
        val premiere = mp4?.optJSONArray("frames")?.optJSONObject(0)
        json.put(
            "frames_analysis", analyse?.optInt("frames") ?: 0
        )
        json.put("preview_disponible", preview != null)
        json.put("mp4_frames_decodees", mp4?.optInt("frames_decodees") ?: 0)
        if (preview != null && premiere != null) {
            val lp = preview.optJSONObject("luminance")?.optString("moyenne")?.toDoubleOrNull()
            val lm = premiere.optJSONObject("luminance")?.optString("moyenne")?.toDoubleOrNull()
            if (lp != null && lm != null) {
                json.put("ecart_luminance_preview_mp4", String.format(Locale.US, "%.1f", abs(lp - lm)))
            }
        }
        val emulateur = rapport.optJSONObject("appareil")?.optBoolean("emulateur") ?: false
        json.put(
            "portee",
            if (emulateur) {
                "RÉSULTATS D'ÉMULATEUR (caméra virtuelle) — ne valent JAMAIS validation capteur physique"
            } else {
                "capteur physique — validation fondateur possible"
            }
        )
        return json
    }

    private fun infoAppareil(): JSONObject {
        val json = JSONObject()
        json.put("modele", Build.MODEL)
        json.put("fabriquant", Build.MANUFACTURER)
        json.put("android_sdk", Build.VERSION.SDK_INT)
        json.put("empreinte", Build.FINGERPRINT)
        json.put(
            "emulateur",
            Build.FINGERPRINT.startsWith("generic") || Build.FINGERPRINT.contains("emulator") ||
                Build.MODEL.contains("Emulator") || Build.MODEL.contains("Android SDK") ||
                Build.PRODUCT.contains("sdk") || Build.HARDWARE.contains("ranchu") ||
                Build.HARDWARE.contains("goldfish")
        )
        json.put("rotation", windowManager.defaultDisplay.rotation)
        return json
    }

    private fun infoCapteurArriere(): JSONObject {
        val json = JSONObject()
        runCatching {
            val cm = getSystemService(Context.CAMERA_SERVICE) as CameraManager
            cm.cameraIdList.forEach { id ->
                val c = cm.getCameraCharacteristics(id)
                if (c.get(CameraCharacteristics.LENS_FACING) == CameraCharacteristics.LENS_FACING_BACK) {
                    json.put("id", id)
                    json.put("orientation_capteur", c.get(CameraCharacteristics.SENSOR_ORIENTATION))
                    json.put(
                        "niveau_materiel",
                        c.get(CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL)?.toString()
                    )
                    val tailles = c.get(CameraCharacteristics.ScalerStreamConfigurationMap)
                        ?.getOutputSizes(android.graphics.SurfaceTexture::class.java)
                        ?.take(5)
                        ?.map { "${it.width}x${it.height}" }
                        ?: emptyList<String>()
                    json.put("resolutions", JSONArray(tailles))
                }
            }
        }
        return json
    }

    private fun dossier(): File =
        File(getExternalFilesDir(null), "d42/camera-diagnostic").apply { mkdirs() }

    private fun ecrirePng(bmp: Bitmap, nom: String) {
        ecrirePngSync(bmp, nom)
    }

    private fun ecrirePngSync(bmp: Bitmap, nom: String) {
        runCatching {
            val reduite = Bitmap.createScaledBitmap(
                bmp, 480, max(1, 480 * bmp.height / bmp.width), true
            )
            File(dossier(), nom).outputStream().use {
                reduite.compress(Bitmap.CompressFormat.PNG, 90, it)
            }
        }
    }

    private suspend fun ecrireRapport(rapport: JSONObject, erreur: String? = null) {
        if (erreur != null) rapport.put("erreur", erreur)
        rapport.put("mode", mode)
        withContext(Dispatchers.IO) {
            runCatching {
                File(dossier(), "rapport-$mode.json").writeText(rapport.toString(2))
            }.onFailure {
                runCatching { File(dossier(), "rapport-$mode.json").writeText(rapport.toString()) }
            }
        }
    }

    override fun onDestroy() {
        runCatching { executor.shutdown() }
        super.onDestroy()
    }
}
