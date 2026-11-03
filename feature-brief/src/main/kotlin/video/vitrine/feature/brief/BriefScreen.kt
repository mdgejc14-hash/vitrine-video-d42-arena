package video.vitrine.feature.brief

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.VitrineLogoHeader
import video.vitrine.core.designsystem.VitrineTheme

/** Ecran 6 (brief) : script ecrit = sous-titres, rushs client optionnels. */
@Composable
fun BriefScreen(
    rushCount: Int,
    onAddRushs: () -> Unit,
    onSubmit: (String, Int, String) -> Unit
) {
    var script by remember { mutableStateOf("") }
    var duration by remember { mutableStateOf("30") }
    var objective by remember { mutableStateOf("visites") }
    var error by remember { mutableStateOf<BriefValidator.Result?>(null) }
    Column(
        modifier = Modifier.fillMaxWidth().padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        VitrineLogoHeader()
        Text(stringResource(R.string.brief_title), style = MaterialTheme.typography.headlineSmall)
        OutlinedTextField(
            value = script,
            onValueChange = { script = it },
            label = { Text(stringResource(R.string.brief_script)) },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = duration,
            onValueChange = { duration = it },
            label = { Text(stringResource(R.string.brief_duration)) },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = objective,
            onValueChange = { objective = it },
            label = { Text(stringResource(R.string.brief_objective)) },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedButton(onClick = onAddRushs, modifier = Modifier.fillMaxWidth()) {
            Text(stringResource(R.string.brief_rushs))
        }
        if (rushCount > 0) Text(stringResource(R.string.brief_rushs_count, rushCount))
        // D41 (F67) : message d'erreur = ressource traduite (x4), plus de FR en dur.
        error?.messageRes?.let { res ->
            val args = error?.messageArgs.orEmpty().toTypedArray()
            Text(stringResource(res, *args), color = Color(0xFFB26A00))
        }
        Button(
            modifier = Modifier.fillMaxWidth(),
            onClick = {
                val result = BriefValidator.validate(script, duration.toIntOrNull() ?: 0, objective)
                error = if (result.valid) null else result
                if (result.valid) onSubmit(script, duration.toIntOrNull() ?: 0, objective)
            }
        ) { Text(stringResource(R.string.brief_validate)) }
    }
}

@Preview(showBackground = true)
@Composable
private fun BriefPreview() {
    VitrineTheme { BriefScreen(rushCount = 0, onAddRushs = { }) { _, _, _ -> } }
}
