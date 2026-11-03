package video.vitrine.feature.catalog

import android.graphics.Bitmap
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.Card
import androidx.compose.material3.FilterChip
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import video.vitrine.core.designsystem.VitrineLogoHeader
import video.vitrine.core.designsystem.sectorLabel
import video.vitrine.core.model.CatalogManifest
import video.vitrine.core.model.Sector
import video.vitrine.core.model.GabaritSummary
import video.vitrine.core.model.Skin

/** Ecran catalogue (JSON ecrans 3.7, id=catalog) : grille lazy 180 skins + filtre secteurs. */
@Composable
fun CatalogScreen(
    manifest: CatalogManifest?,
    offline: Boolean,
    initialSector: Sector? = null,
    onSkinClick: (Skin) -> Unit = {},
    gabarits: List<GabaritSummary> = emptyList(),
    onGabaritClick: (GabaritSummary) -> Unit = {},
) {
    var sector by remember { mutableStateOf(initialSector ?: Sector.TOUS) }
    Column(modifier = Modifier.fillMaxSize()) {
        if (offline) {
            Text(
                stringResource(R.string.catalog_offline),
                modifier = Modifier
                    .fillMaxWidth()
                    .background(MaterialTheme.colorScheme.secondaryContainer)
                    .padding(8.dp),
                color = MaterialTheme.colorScheme.onSecondaryContainer
            )
        }
        Column(
            modifier = Modifier.padding(horizontal = 12.dp),
            verticalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            VitrineLogoHeader()
            Text(stringResource(R.string.catalog_title), style = MaterialTheme.typography.titleLarge)
            if (sector != Sector.TOUS) {
                Text(
                    stringResource(R.string.catalog_sector_focus, sectorLabel(sector)),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            SectorRow(sector) { sector = it }
        }
        if (gabarits.isNotEmpty()) {
            GabaritLayout(
                GabaritCatalog.visible(gabarits, sector),
                sector == Sector.TOUS,
                onGabaritClick,
                Modifier.weight(1f),
            )
        } else {
            val skins = manifest?.bySector(sector) ?: emptyList()
            SkinLayout(skins, sector == Sector.TOUS, onSkinClick, Modifier.weight(1f))
        }
    }
}

/**
 * E4 V2.0 : carte gabarit universel (maquette Drive E4_Catalogue) —
 * nom du format, secteur, duree/nb scenes, phrase courte benefice d'abord.
 * 30 gabarits = liste directe scrollable (legere, amie hors-ligne).
 */
@Composable
private fun GabaritLayout(
    gabarits: List<GabaritSummary>,
    showSector: Boolean,
    onGabaritClick: (GabaritSummary) -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(
        modifier = modifier
            .verticalScroll(androidx.compose.foundation.rememberScrollState())
            .padding(12.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        gabarits.forEach { g ->
            Card(onClick = { onGabaritClick(g) }, modifier = Modifier.fillMaxWidth()) {
                Column(
                    modifier = Modifier.padding(14.dp),
                    verticalArrangement = Arrangement.spacedBy(4.dp),
                ) {
                    Text(g.nomFormatAffiche, style = MaterialTheme.typography.titleMedium)
                    val meta = buildString {
                        if (showSector) append(g.secteurLibelle).append(" · ")
                        append(g.dureeTotaleS).append(" s · ")
                        append(g.nombreScenes).append(" scenes · ")
                        append(g.nombrePrises).append(" prises")
                    }
                    Text(
                        meta,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    Text(g.phraseCourte, style = MaterialTheme.typography.bodyMedium)
                }
            }
        }
    }
}

/**
 * Regle produit : peu de gabarits (catalogue filtre par secteur) = colonne
 * directe scrollable (legere, amie hors-ligne) ; au-dela = grille lazy
 * (180 skins sans recompiler). Même rendu visuel cartes.
 */
@Composable
private fun SkinLayout(
    skins: List<Skin>,
    showSector: Boolean,
    onSkinClick: (Skin) -> Unit,
    modifier: Modifier = Modifier,
) {
    if (skins.size <= DIRECT_LIST_MAX) {
        Column(
            modifier = modifier
                .verticalScroll(androidx.compose.foundation.rememberScrollState())
                .padding(12.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            skins.forEach { skin -> SkinCard(skin, showSector, true, onSkinClick) }
        }
    } else {
        LazyVerticalGrid(
            columns = GridCells.Fixed(2),
            contentPadding = PaddingValues(12.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
            modifier = modifier,
        ) {
            items(skins, key = { it.id }) { skin -> SkinCard(skin, showSector, onSkinClick = onSkinClick) }
        }
    }
}

private const val DIRECT_LIST_MAX = 12

@Composable
private fun SectorRow(selected: Sector, onSelect: (Sector) -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
        Sector.entries.chunked(3).forEach { row ->
            androidx.compose.foundation.layout.Row(
                horizontalArrangement = Arrangement.spacedBy(6.dp),
                modifier = Modifier.horizontalScroll(androidx.compose.foundation.rememberScrollState()),
            ) {
                row.forEach { entry ->
                    FilterChip(
                        selected = entry == selected,
                        onClick = { onSelect(entry) },
                        label = { Text(sectorLabel(entry)) }
                    )
                }
            }
        }
    }
}

@Composable
private fun SkinCard(skin: Skin, showSector: Boolean, compact: Boolean = false, onSkinClick: (Skin) -> Unit) {
    var bitmap by remember(skin.id) { mutableStateOf<Bitmap?>(null) }
    LaunchedEffect(skin.thumbnailUrl) { bitmap = LazyImageLoader.load(skin.thumbnailUrl) }
    Column(modifier = Modifier.clickable { onSkinClick(skin) }) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .then(if (compact) Modifier.height(180.dp) else Modifier.aspectRatio(9f / 16f))
                .background(Color(0xFF1B1B1F)),
            contentAlignment = Alignment.Center
        ) {
            val image = bitmap
            if (image != null) {
                Image(
                    bitmap = image.asImageBitmap(),
                    contentDescription = skin.name,
                    contentScale = ContentScale.Crop,
                    modifier = Modifier.fillMaxSize()
                )
            } else {
                Text("…", color = Color.Gray)
            }
        }
        Text(SkinDisplayName.label(skin), style = MaterialTheme.typography.bodyMedium)
        if (showSector) {
            Text(
                sectorLabel(skin.sector),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun CatalogPreview() {
    video.vitrine.core.designsystem.VitrineTheme { CatalogScreen(null, offline = false) }
}

@Preview(showBackground = true)
@Composable
private fun CatalogPreviewFiltreMode() {
    video.vitrine.core.designsystem.VitrineTheme {
        CatalogScreen(null, offline = false, initialSector = Sector.MODE)
    }
}
