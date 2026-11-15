package video.vitrine.feature.export

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.os.Looper
import android.view.View
import android.widget.Button
import android.widget.TextView
import androidx.test.core.app.ActivityScenario
import androidx.test.core.app.ApplicationProvider
import androidx.work.CoroutineWorker
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkInfo
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import androidx.work.testing.WorkManagerTestInitHelper
import androidx.work.workDataOf
import java.io.File
import kotlinx.coroutines.delay
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import org.robolectric.shadows.ShadowStatFs

/** Clé inputData du worker de test : la phase à tenir (chaque test la choisit). */
private const val KEY_PHASE_HELD = "phase-held"

/**
 * D42.34 ordre final §6 (priorité 3) — preuves de rendu des états d'export :
 * phases métier du montage E8 (VR-051) et écran « export prêt » (VR-052).
 *
 * Méthode déterministe (leçon des 3 tentatives) : un worker de test occupe le
 * nom unique réel ("vv-export") et PUBLIE la phase via le mécanisme setProgress
 * authentique ; le test attend (poll sur l'API synchronique
 * getWorkInfosForUniqueWork) que le WorkInfo CONTENNE la phase, PUIS lance la
 * VRAIE ExportActivity.
 *
 * Échec des runs précédents, cause racine : le test ne tapait JAMAIS
 * « Exporter ». La chaîne réelle est initExportUi (texte t1 initial) → TAP →
 * porte crédits (StorageGate, ancre, intégrité, débit Room suspend) →
 * preparationJob.join() → enqueueNow() → l'activité voit le travail déjà en
 * cours (ExistingWorkPolicy.KEEP, aucun double enqueue) → observeExport() →
 * WorkInfo.progress → TextView. Ce test franchit TOUTES ces étapes comme un
 * utilisateur : performClick sur export_start, extra « input » non null
 * (exigé par enqueueNow, sinon deny input_missing), crédit welcome seedé en
 * base vierge (WELCOME_TOTAL=3), SHA intégrité vide en build test (mode dev).
 *
 * La phase tenue vient du inputData du worker (stable 5 min) : aucune course
 * assemblage→rendu au moment de l'émission du LiveData observé.
 *
 * Pour l'état « prêt » : le worker de test reste EN COURS (phase publiée)
 * jusqu'à un signal fichier créé APRÈS l'attachement de l'observer — ainsi
 * enqueueNow() voit un travail en cours (aucun ré-enqueue du vrai worker,
 * KEEP ne bloquant qu'un travail non terminé), puis le worker réussit avec
 * KEY_OUTPUT (contrat réel du ExportWorker) : l'émission LiveData SUCCEEDED
 * arrive sur un observer vivant et l'activité affiche l'état terminé réel
 * (export_done + partage + espace). Aucun flux fabriqué, aucune course.
 *
 * Numérotation : D34-20/21/22 (D34-01..19 déjà pris, dont D34-19 = paywall-en).
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], qualifiers = "fr-w360dp-h820dp")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class D34Lot8ExportStatesVisualCheckTest {

    /** Publie la phase demandée puis reste EN COURS (phase stable). */
    class PhaseHolderWorker(
        appContext: Context,
        params: WorkerParameters,
    ) : CoroutineWorker(appContext, params) {
        override suspend fun doWork(): Result {
            val phase = inputData.getString(KEY_PHASE_HELD)
                ?: error("phase absente du inputData")
            setProgress(workDataOf(ExportWorker.KEY_PHASE to phase))
            delay(300_000)
            return Result.success()
        }
    }

    /** Réussit SUR SIGNAL (fichier sentinelle) avec KEY_OUTPUT (contrat réel). */
    class SuccessOnSignalWorker(
        appContext: Context,
        params: WorkerParameters,
    ) : CoroutineWorker(appContext, params) {
        override suspend fun doWork(): Result {
            // Reste EN COURS (phase publiée) jusqu'au signal du test : le tap
            // voit dejaEnCours=true → aucun ré-enqueue du vrai ExportWorker.
            setProgress(
                workDataOf(
                    ExportWorker.KEY_PHASE to
                        applicationContext.getString(R.string.export_phase_assemblage),
                ),
            )
            val sentinelle = File(applicationContext.filesDir, "d34lot8-signal.txt")
            val deadline = System.currentTimeMillis() + 60_000
            while (!sentinelle.exists() && System.currentTimeMillis() < deadline) {
                delay(200)
            }
            val sortie = File(applicationContext.filesDir, "export-preuve.mp4")
            sortie.writeBytes(ByteArray(64))
            return Result.success(
                workDataOf(ExportWorker.KEY_OUTPUT to sortie.absolutePath),
            )
        }
    }

    /** Attend (poll, API synchronique) que le WorkInfo contienne la phase. */
    private fun attendrePhase(context: Context, phase: String) {
        val wm = WorkManager.getInstance(context)
        val deadline = System.currentTimeMillis() + 30_000
        while (System.currentTimeMillis() < deadline) {
            val infos: List<WorkInfo> = wm.getWorkInfosForUniqueWork(ExportWorker.UNIQUE_NAME).get()
            if (infos.any { it.progress.getString(ExportWorker.KEY_PHASE) == phase }) return
            Thread.sleep(120)
        }
        throw AssertionError("le WorkInfo ne contient jamais la phase \"$phase\"")
    }

    /**
     * Lance la VRAIE activité, tape « Exporter » (chemin utilisateur complet),
     * attend l'état décrit par [pret] puis vérifie et capture.
     */
    private fun lancerTaperAttendreCapturer(
        nom: String,
        pret: (Activity) -> Boolean,
        verif: (Activity) -> Unit,
    ) {
        ActivityScenario.launch<ExportActivity>(intentExport()).use { sc ->
            taperApresInit(sc)
            check(sc.attendre(cond = pret)) { "état attendu jamais atteint (${nom})" }
            sc.onActivity { a ->
                verif(a)
                capturerEcran(a, nom)
            }
        }
    }

    private fun intentExport(): Intent =
        Intent(
            ApplicationProvider.getApplicationContext<Context>(),
            ExportActivity::class.java,
        )
            .putExtra("script", "Filme tes produits, on te guide")
            .putExtra("duration_s", 35)
            // enqueueNow() exige un « input » non null (sinon deny input_missing).
            .putExtra("input", "preuve-d34lot8")

    /** Robolectric : StatFs shadowé à 0 — volume réaliste pour filesDir. */
    private fun registrerStatFs() {
        ShadowStatFs.registerStats(
            ApplicationProvider.getApplicationContext<Context>().filesDir,
            4096,
            16_000_000,
            16_000_000,
        )
    }

    /** Attend l'écran export posé (callback Compose) puis tape « Exporter ». */
    private fun taperApresInit(sc: ActivityScenario<ExportActivity>) {
        registrerStatFs()
        check(
            sc.attendre(30_000) { a ->
                a.findViewById<TextView>(R.id.export_status) != null
            },
        ) { "initExportUi jamais exécuté (écran export absent)" }
        sc.onActivity { a ->
            check(
                a.findViewById<Button>(R.id.export_start).performClick(),
            ) { "tap export_start sans effet" }
        }
    }

    /** Poll (main looper idleé en continu) jusqu'à la condition ou le timeout. */
    private fun ActivityScenario<ExportActivity>.attendre(
        timeoutMs: Long = 120_000,
        cond: (Activity) -> Boolean,
    ): Boolean {
        val deadline = System.currentTimeMillis() + timeoutMs
        while (System.currentTimeMillis() < deadline) {
            shadowOf(Looper.getMainLooper()).idle()
            var ok = false
            onActivity { a -> ok = cond(a) }
            if (ok) return true
            Thread.sleep(150)
        }
        return false
    }

    @Test
    fun montage_e8_affiche_phase_assemblage() {
        val context: Context = ApplicationProvider.getApplicationContext()
        WorkManagerTestInitHelper.initializeTestWorkManager(context)
        val phase = context.getString(R.string.export_phase_assemblage)
        WorkManager.getInstance(context).enqueueUniqueWork(
            ExportWorker.UNIQUE_NAME,
            ExistingWorkPolicy.REPLACE,
            OneTimeWorkRequestBuilder<PhaseHolderWorker>()
                .setInputData(workDataOf(KEY_PHASE_HELD to phase))
                .build(),
        )
        attendrePhase(context, phase)
        lancerTaperAttendreCapturer(
            "D34-20_montage-phases-assemblage_APRES.png",
            pret = { a -> texteStatut(a) == phase },
        ) { a ->
            checkTexte(a, phase)
        }
    }

    @Test
    fun montage_e8_affiche_phase_rendu() {
        val context: Context = ApplicationProvider.getApplicationContext()
        WorkManagerTestInitHelper.initializeTestWorkManager(context)
        val phase = context.getString(R.string.export_phase_rendu)
        WorkManager.getInstance(context).enqueueUniqueWork(
            ExportWorker.UNIQUE_NAME,
            ExistingWorkPolicy.REPLACE,
            OneTimeWorkRequestBuilder<PhaseHolderWorker>()
                .setInputData(workDataOf(KEY_PHASE_HELD to phase))
                .build(),
        )
        attendrePhase(context, phase)
        lancerTaperAttendreCapturer(
            "D34-21_montage-phases-rendu_APRES.png",
            pret = { a -> texteStatut(a) == phase },
        ) { a ->
            checkTexte(a, phase)
        }
    }

    @Test
    fun export_pret_affiche_partage_et_espace() {
        val context: Context = ApplicationProvider.getApplicationContext()
        WorkManagerTestInitHelper.initializeTestWorkManager(context)
        val sentinelle = File(context.filesDir, "d34lot8-signal.txt")
        sentinelle.delete()
        WorkManager.getInstance(context).enqueueUniqueWork(
            ExportWorker.UNIQUE_NAME,
            ExistingWorkPolicy.REPLACE,
            OneTimeWorkRequestBuilder<SuccessOnSignalWorker>().build(),
        )
        // le worker est EN COURS et publie la phase d'assemblage
        attendrePhase(context, context.getString(R.string.export_phase_assemblage))
        ActivityScenario.launch<ExportActivity>(intentExport()).use { sc ->
            taperApresInit(sc)
            // 1. l'observer est attaché : la phase s'affiche (travail EN COURS,
            //    aucun ré-enqueue du vrai ExportWorker par enqueueNow).
            val phase = context.getString(R.string.export_phase_assemblage)
            check(sc.attendre { a -> texteStatut(a) == phase }) {
                "observer non attaché ou phase absente"
            }
            // 2. signal : le worker réussit MAINTENANT (contrat KEY_OUTPUT) —
            //    l'émission LiveData SUCCEEDED arrive sur un observer vivant.
            sentinelle.writeText("ok")
            check(
                sc.attendre { a ->
                    a.findViewById<Button>(R.id.export_share)
                        ?.let { it.visibility == android.view.View.VISIBLE } == true
                },
            ) { "état prêt jamais atteint (partage invisible)" }
            sc.onActivity { a ->
                val partage = a.findViewById<Button>(R.id.export_share)
                check(partage != null && partage.visibility == android.view.View.VISIBLE) {
                    "bouton partage non visible à l'état prêt"
                }
                checkTexte(a, context.getString(R.string.export_done))
                capturerEcran(a, "D34-22_export-pret_APRES.png")
            }
        }
    }

    private fun texteStatut(a: Activity): String =
        a.findViewById<TextView>(R.id.export_status).text.toString()

    private fun checkTexte(a: Activity, attendu: String) {
        val affiche = a.findViewById<TextView>(R.id.export_status).text.toString()
        check(affiche == attendu) { "attendu \"$attendu\", affiché \"$affiche\"" }
    }

    /** Rend la hiérarchie réelle de l'activité (measure + layout + draw). */
    private fun capturerEcran(activity: Activity, nom: String) {
        shadowOf(Looper.getMainLooper()).idle()
        val decor = activity.window.decorView
        val dm = activity.resources.displayMetrics
        decor.measure(
            View.MeasureSpec.makeMeasureSpec(dm.widthPixels, View.MeasureSpec.EXACTLY),
            View.MeasureSpec.makeMeasureSpec(dm.heightPixels, View.MeasureSpec.EXACTLY),
        )
        decor.layout(0, 0, dm.widthPixels, dm.heightPixels)
        val bitmap = Bitmap.createBitmap(decor.width, decor.height, Bitmap.Config.ARGB_8888)
        decor.draw(Canvas(bitmap))
        val dir = File("build/visual-check")
        dir.mkdirs()
        File(dir, nom).outputStream().use {
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, it)
        }
    }
}
