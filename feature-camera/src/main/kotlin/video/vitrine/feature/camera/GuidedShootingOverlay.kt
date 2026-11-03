package video.vitrine.feature.camera

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxScope
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import video.vitrine.ins.effects.DefaultBeatSheet

/** Une scene du tournage guide : derivee du beat sheet (versionnable serveur ou defaut). */
data class SceneGuide(
    val index: Int,
    val total: Int,
    val instructionRes: Int,
    val durationS: Double,
)

/** Construit le guide de tournage depuis le script voix : meme horloge que le montage. */
fun buildSceneGuides(script: String, durationS: Int): List<SceneGuide> {
    val plans = DefaultBeatSheet.fromScript(script, durationS.toDouble(), emptyList()).plans
    return plans.mapIndexed { i, plan ->
        SceneGuide(
            index = i + 1,
            total = plans.size,
            instructionRes = when (i % 3) {
                0 -> R.string.camera_scene_front
                1 -> R.string.camera_scene_detail
                else -> R.string.camera_scene_use
            },
            durationS = plan.t1 - plan.t0,
        )
    }
}

/** Wrapper Compose memoise du guide (Activity et tests partagent le meme builder). */
@Composable
fun rememberSceneGuides(script: String, durationS: Int): List<SceneGuide> =
    remember(script, durationS) { buildSceneGuides(script, durationS) }

/**
 * Overlay de tournage guide : cadre 9:16 + silhouette, compteur de scenes,
 * jauge temporelle, instruction francaise, badge visages / porte R4.
 * Composable pur : capturable sous Robolectric sans materiel camera.
 */
@Composable
fun GuidedShootingOverlay(
    scenes: List<SceneGuide>,
    currentIdx: Int,
    progress: Float,
    faceCount: Int,
    gateAllowed: Boolean,
    recording: Boolean,
    modifier: Modifier = Modifier,
) {
    val scene = scenes.getOrNull(currentIdx)
    Box(modifier = modifier.fillMaxSize()) {
        FramingBox()
        TopHud(scene, scenes.size, progress)
        BottomHud(scene, faceCount, gateAllowed, recording)
    }
}

@Composable
private fun BoxScope.FramingBox() {
    Box(
        modifier = Modifier
            .align(Alignment.Center)
            .fillMaxWidth(0.72f)
            .aspectRatio(9f / 16f)
            .border(BorderStroke(3.dp, Color(0xFFF95C0F)), RoundedCornerShape(18.dp)),
        contentAlignment = Alignment.Center,
    ) {
        Canvas(modifier = Modifier.fillMaxSize()) {
            val cx = size.width / 2f
            val cy = size.height / 2f
            val silhouette = Color(0x33FFFFFF)
            drawRoundRect(
                color = silhouette,
                topLeft = Offset(cx - size.width * 0.16f, cy - size.height * 0.10f),
                size = Size(size.width * 0.32f, size.height * 0.34f),
                cornerRadius = CornerRadius(size.width * 0.12f),
            )
            drawCircle(
                color = silhouette,
                radius = size.width * 0.09f,
                center = Offset(cx, cy - size.height * 0.18f),
            )
        }
    }
}

@Composable
private fun BoxScope.TopHud(scene: SceneGuide?, total: Int, progress: Float) {
    Column(
        modifier = Modifier
            .align(Alignment.TopCenter)
            .fillMaxWidth()
            .background(Color(0xCC000000))
            .padding(10.dp),
        verticalArrangement = Arrangement.spacedBy(6.dp),
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
        ) {
            Text(
                stringResource(R.string.camera_scene_counter, scene?.index ?: 1, total),
                color = Color.White,
                style = MaterialTheme.typography.titleMedium,
            )
            Text(
                String.format("%.1f s", scene?.durationS ?: 0.0),
                color = Color(0xFFF95C0F),
                style = MaterialTheme.typography.titleMedium,
            )
        }
        LinearProgressIndicator(
            progress = progress.coerceIn(0f, 1f),
            modifier = Modifier
                .fillMaxWidth()
                .height(6.dp),
            color = Color(0xFFF95C0F),
        )
    }
}

@Composable
private fun BoxScope.BottomHud(scene: SceneGuide?, faceCount: Int, gateAllowed: Boolean, recording: Boolean) {
    Column(
        modifier = Modifier
            .align(Alignment.BottomCenter)
            .fillMaxWidth()
            .background(Color(0xCC000000))
            .padding(12.dp),
        verticalArrangement = Arrangement.spacedBy(6.dp),
    ) {
        if (scene != null) {
            Text(
                stringResource(scene.instructionRes),
                color = Color.White,
                style = MaterialTheme.typography.bodyLarge,
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth(),
            )
        }
        Text(
            if (gateAllowed) {
                stringResource(R.string.camera_faces_ok, faceCount)
            } else {
                stringResource(R.string.camera_faces_ko, faceCount)
            },
            color = if (gateAllowed) Color(0xFF7BD88F) else Color(0xFFFF6B6B),
            style = MaterialTheme.typography.bodyMedium,
            textAlign = TextAlign.Center,
            modifier = Modifier.fillMaxWidth(),
        )
        if (recording) {
            Text(
                stringResource(R.string.camera_recording),
                color = Color(0xFFF95C0F),
                style = MaterialTheme.typography.labelLarge,
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth(),
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun GuidedShootingOverlayPreview() {
    video.vitrine.core.designsystem.VitrineTheme {
        GuidedShootingOverlay(
            scenes = listOf(
                SceneGuide(1, 5, R.string.camera_scene_front, 1.2),
                SceneGuide(2, 5, R.string.camera_scene_detail, 1.2),
            ),
            currentIdx = 0,
            progress = 0.4f,
            faceCount = 0,
            gateAllowed = true,
            recording = false,
        )
    }
}
