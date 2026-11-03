package video.vitrine.core.designsystem

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

/** Controle visuel de la palette officielle (regle de fidelite couleur). */
@Preview(showBackground = true)
@Composable
private fun PalettePreview() {
    VitrineTheme {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Swatch(OrangeStore, "#F95C0F", Modifier.weight(1f))
                Swatch(OrangeStoreDeep, "#D34905", Modifier.weight(1f))
            }
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Swatch(BleuNuit, "#022358", Modifier.weight(1f))
                Swatch(BleuNuitSoft, "#23467F", Modifier.weight(1f))
            }
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Swatch(BlancPur, "#FFFFFF", Modifier.weight(1f))
                Swatch(GrisDoux, "#F7F8FC", Modifier.weight(1f))
            }
        }
    }
}

@Composable
private fun Swatch(color: androidx.compose.ui.graphics.Color, hex: String, modifier: Modifier) {
    Column(modifier = modifier) {
        Box(modifier = Modifier.fillMaxWidth().height(56.dp).background(color))
        Text(hex, modifier = Modifier.padding(4.dp))
    }
}
