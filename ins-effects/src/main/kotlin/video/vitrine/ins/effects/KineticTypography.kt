package video.vitrine.ins.effects

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.Typeface
import androidx.media3.common.Effect
import androidx.media3.common.util.UnstableApi
import androidx.media3.effect.BitmapOverlay
import androidx.media3.effect.OverlayEffect
import androidx.media3.effect.StaticOverlaySettings
import androidx.media3.effect.TextureOverlay
import androidx.media3.effect.TimestampWrapper
import com.google.common.collect.ImmutableList

/**
 * Typographie cinematique mot par mot : chaque mot devient un overlay fenetre sur
 * son timecode Whisper (aucun decalage cumulatif). Mots-cles en orange store,
 * reste en blanc, CONTOUR NOIR reel (double passe StaticLayout : stroke puis
 * fill) — avant (audit D41, F62), TextOverlay rendait du 100 px fixe sans
 * contour ni retour a la ligne (debord CJK garanti).
 *
 * Taille/cassure/ancrage sont decides par OverlayTextLayout (heuristique pure,
 * deterministe) ; le surlignage par KeywordMatching (tokens normalises).
 *
 * CORRECTION D42.2 — deux defauts cumules, tous deux mesures sur des MP4 reels :
 *
 *  1. TAILLE. [OverlayTextLayout.baseSizePxFor] remplace [baseSizePx] : la
 *     taille depend desormais de la HAUTEUR de sortie. En 1080x1920 le texte
 *     passe de 84 px (4,37 % de la hauteur) a 105 px (5,47 %). L'ancienne
 *     formule ne regardait que la largeur : en carre elle donnait 7,78 % et
 *     paraissait correcte, en portrait 9:16 elle tombait sous le seuil de
 *     lisibilite. C'est pourquoi le defaut n'avait jamais ete vu avant D42.
 *
 *  2. ECHELLE. `StaticOverlaySettings` n'appelait AUCUNE echelle ; le bitmap
 *     etait donc rendu a sa taille naturelle, et son ancrage dependait d'une
 *     semantique (`scale` relatif au bitmap ou au cadre) qui n'est pas
 *     garantie stable entre versions de Media3. Le correctif supprime la
 *     question : le bitmap fait la taille du CADRE et l'echelle reste a 1.
 *     Un bitmap plein cadre se superpose EXACTEMENT au cadre que `scale`
 *     designe le bitmap ou le cadre — l'invariant ne depend plus de Media3.
 *
 * MEMOIRE : un bitmap plein cadre coute W x H x 4 octets (8,3 Mo en 1080p).
 * Un cache borne (MEMOIRE_CACHE entrees, LRU) plafonne la consommation a
 * ~17 Mo. Les bitmaps ne sont jamais recycles dans le cache : Media3 peut en
 * detenir une reference ; [libererCache] les abandonne proprement en fin
 * d'export.
 */
@UnstableApi
object KineticTypography {

    const val KEYWORD_COLOR = 0xFFF95C0F.toInt()
    const val BASE_COLOR = 0xFFFFFFFF.toInt()
    const val STROKE_COLOR = 0xFF000000.toInt()

    /** Nombre de bitmaps plein cadre conserves (17 Mo en 1080x1920). */
    private const val MEMOIRE_CACHE = 2

    private val cache = HashMap<String, Bitmap>()
    private val ordre = ArrayDeque<String>()

    /** Lecture dans le cache borne (LRU approximatif, ordre d'insertion). */
    private fun cacheLire(cle: String): Bitmap? = synchronized(cache) { cache[cle] }

    /** Ecriture avec eviction du plus ancien au-dela de [MEMOIRE_CACHE]. */
    private fun cacheEcrire(cle: String, bitmap: Bitmap) {
        synchronized(cache) {
            cache[cle] = bitmap
            ordre.addLast(cle)
            while (ordre.size > MEMOIRE_CACHE) {
                cache.remove(ordre.removeFirst())
            }
        }
    }

    fun wordOverlays(
        words: List<WordStamp>,
        keywords: Set<String>,
        outputWidthPx: Int = 1080,
        outputHeightPx: Int = 1920
    ): List<Effect> {
        val tokens = KeywordMatching.keywordTokens(keywords)
        val maxWidth = (outputWidthPx * OverlayTextLayout.MAX_WIDTH_FRACTION).toInt()
        // D42.2 : la hauteur entre dans la taille (voir baseSizePxFor).
        val base = OverlayTextLayout.baseSizePxFor(outputWidthPx, outputHeightPx)
        // D42-F15 : garde-fou. Un mot de duree nulle ou negative ne doit jamais
        // atteindre TimestampWrapper (il rejette les instants negatifs et
        // interrompt tout le rendu multi-rush).
        val retenus = words
            .filter { it.word.isNotBlank() && it.endS > it.startS + 1e-3 }
            .map { stamp -> stamp.copy(startS = stamp.startS.coerceAtLeast(0.0)) }
        val produits = retenus.flatMap { stamp ->
            val size = OverlayTextLayout.sizeForWidth(stamp.word, base, maxWidth)
            val lignes = OverlayTextLayout.splitLines(stamp.word, size, maxWidth)
            val surligne = KeywordMatching.isKeyword(stamp.word, tokens)
            val startUs = (stamp.startS * MICRO).toLong()
            val endUs = (stamp.endS * MICRO).toLong()
            lignes.mapIndexed { index, ligne ->
                // Echelle 1 + ancrage centre : avec un bitmap PLEIN CADRE, ces
                // valeurs par defaut suffisent et restent justes quelle que soit
                // l'interpretation de `scale` par Media3.
                val reglages = StaticOverlaySettings.Builder()
                    .setScale(1f, 1f)
                    .setOverlayFrameAnchor(0f, 0f)
                    .setBackgroundFrameAnchor(0f, 0f)
                    .build()
                TimestampWrapper(
                    // Java invariant : OverlayEffect(List<TextureOverlay>) — type explicite requis
                    OverlayEffect(
                        ImmutableList.of<TextureOverlay>(
                            contourOverlay(
                                ligne, surligne, size, index, lignes.size,
                                outputWidthPx, outputHeightPx, reglages
                            )
                        )
                    ),
                    startUs,
                    endUs
                )
            }
        }
        android.util.Log.i(
            "D42-TRACE",
            "8.typographie mots_recus=${words.size} mots_retenus=${retenus.size} " +
                "overlays=$produits taille=$base geo=${outputWidthPx}x$outputHeightPx"
        )
        return produits
    }

    /**
     * BitmapOverlay statique : texte blanc (ou orange store si mot-cle) avec
     * contour noir, dessine dans un bitmap aux dimensions du CADRE a la
     * position exacte de la ligne. Le bitmap est rendu UNE fois puis mis en
     * cache (getBitmap est appele a chaque frame par l'overlay fenetre).
     */
    private fun contourOverlay(
        ligne: String,
        surligne: Boolean,
        sizePx: Int,
        index: Int,
        totalLignes: Int,
        largeur: Int,
        hauteur: Int,
        reglages: StaticOverlaySettings
    ): BitmapOverlay = object : BitmapOverlay() {

        private val cle = "$ligne|$surligne|$sizePx|$index|$totalLignes|${largeur}x$hauteur"

        override fun getBitmap(presentationTimeUs: Long): Bitmap =
            cacheLire(cle) ?: rendre().also { cacheEcrire(cle, it) }

        override fun getOverlaySettings(presentationTimeUs: Long): StaticOverlaySettings = reglages

        private fun rendre(): Bitmap {
            val bitmap = Bitmap.createBitmap(largeur, hauteur, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            canvas.drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR)

            // Choix de x : centre du cadre. Choix de y : ancrage NDC converti en
            // pixels par OverlayTextLayout (aucune duplication de la logique).
            val yPx = OverlayTextLayout.lineAnchorYPx(index, totalLignes, sizePx, hauteur)

            val remplissage = Paint(Paint.ANTI_ALIAS_FLAG).apply {
                textSize = sizePx.toFloat()
                color = if (surligne) KEYWORD_COLOR else BASE_COLOR
                typeface = Typeface.DEFAULT_BOLD
                textAlign = Paint.Align.CENTER
                style = Paint.Style.FILL
            }
            val contour = Paint(remplissage).apply {
                style = Paint.Style.STROKE
                strokeWidth = (sizePx / 8f).coerceAtLeast(2f)
                strokeJoin = Paint.Join.ROUND
                color = STROKE_COLOR
            }
            // Ligne de base : le haut du texte se pose a yPx.
            val metriques = remplissage.fontMetrics
            val base = yPx - metriques.ascent
            canvas.drawText(ligne, largeur / 2f, base, contour)
            canvas.drawText(ligne, largeur / 2f, base, remplissage)
            android.util.Log.i(
                "D42-TRACE",
                "8b.texte=\"$ligne\" taille=$sizePx yPx=$yPx base=$base " +
                    "w=${remplissage.measureText(ligne)} bitmap=${bitmap.width}x${bitmap.height}"
            )
            return bitmap
        }
    }

    /**
     * Abandonne les bitmaps caches en fin d'export (jusqu'a 17 Mo en 1080p).
     * Ils ne sont pas recycles : Media3 peut encore en detenir une reference
     * jusqu'a la destruction du renderer.
     */
    fun libererCache() {
        synchronized(cache) {
            cache.clear()
            ordre.clear()
        }
    }

    private const val MICRO = 1_000_000.0
}
