package video.vitrine.ins.effects

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PorterDuff
import android.text.Layout
import android.text.SpannableString
import android.text.Spanned
import android.text.StaticLayout
import android.text.TextPaint
import android.text.style.ForegroundColorSpan
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
        val sonde = sondeDiagnostic(outputWidthPx, outputHeightPx)
        android.util.Log.i(
            "D42-TRACE",
            "8.typographie mots_recus=${words.size} mots_retenus=${retenus.size} " +
                "overlays=$produits taille=$base geo=${outputWidthPx}x$outputHeightPx"
        )
        return sonde + produits
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

            val paint = TextPaint(Paint.ANTI_ALIAS_FLAG)
            paint.textSize = sizePx.toFloat()
            val largeurTexte = minOf(
                OverlayTextLayout.estimateWidthPx(ligne, sizePx) + (sizePx * 0.30f).toInt() + 8,
                largeur
            )
            // Ordonnee en pixels du haut de la ligne, convertie depuis l'ancrage
            // NDC par OverlayTextLayout (aucune duplication de la logique).
            val yPx = OverlayTextLayout.lineAnchorYPx(index, totalLignes, sizePx, hauteur)

            val plein = SpannableString(ligne)
            plein.setSpan(
                ForegroundColorSpan(if (surligne) KEYWORD_COLOR else BASE_COLOR),
                0,
                ligne.length,
                Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
            )
            val layoutContour = layout(SpannableString(ligne), paint, largeurTexte)
            val layoutPlein = layout(plein, paint, largeurTexte)

            canvas.save()
            canvas.translate((largeur - largeurTexte) / 2f, yPx)
            // Passe 1 : contour noir (texte brut, couleur du paint).
            paint.style = Paint.Style.STROKE
            paint.strokeWidth = (sizePx / 8f).coerceAtLeast(2f)
            paint.color = STROKE_COLOR
            layoutContour.draw(canvas)
            // Passe 2 : remplissage (ForegroundColorSpan impose blanc/orange).
            paint.style = Paint.Style.FILL
            layoutPlein.draw(canvas)
            canvas.restore()
            return bitmap
        }

        private fun layout(texte: SpannableString, paint: TextPaint, largeur: Int): StaticLayout =
            StaticLayout.Builder.obtain(texte, 0, texte.length, paint, largeur)
                .setAlignment(Layout.Alignment.ALIGN_CENTER)
                .setLineSpacing(0f, 1f)
                .setIncludePad(false)
                .build()
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

    /**
     * SONDE DE DIAGNOSTIC D42.2 — a retirer une fois la cause etablie.
     *
     * Trois bandes opaques, pleine largeur, a trois positions differentes et
     * sur trois fenetres differentes :
     *   rouge  : 0-10 s, haut du cadre
     *   verte  : 10-20 s, milieu
     *   bleue  : 20-30 s, bas
     * Si les bandes apparaissent, les overlays SONT composes : le defaut est
     * dans le dessin ou le placement du texte. Si rien n'apparait, le chemin
     * overlay est inactif dans la composition et le texte n'y changera rien.
     */
    private fun sondeDiagnostic(largeur: Int, hauteur: Int): List<Effect> =
        listOf(
            bandeSonde(Color.RED, 0.10f, 0.18f, largeur, hauteur, 0L, 10_000_000L),
            bandeSonde(Color.GREEN, 0.46f, 0.54f, largeur, hauteur, 10_000_000L, 20_000_000L),
            bandeSonde(Color.BLUE, 0.82f, 0.90f, largeur, hauteur, 20_000_000L, 30_000_000L)
        )

    private fun bandeSonde(
        couleur: Int,
        haut: Float,
        bas: Float,
        largeur: Int,
        hauteur: Int,
        debutUs: Long,
        finUs: Long
    ): Effect {
        val overlay = object : BitmapOverlay() {
            private val bitmap: Bitmap = Bitmap.createBitmap(
                largeur, hauteur, Bitmap.Config.ARGB_8888
            ).also { bmp ->
                val c = Canvas(bmp)
                val p = Paint()
                p.color = couleur
                c.drawRect(
                    0f, haut * hauteur, largeur.toFloat(), bas * hauteur, p
                )
            }

            override fun getBitmap(presentationTimeUs: Long): Bitmap = bitmap

            override fun getOverlaySettings(presentationTimeUs: Long): StaticOverlaySettings =
                StaticOverlaySettings.Builder().setScale(1f, 1f).build()
        }
        return TimestampWrapper(
            OverlayEffect(ImmutableList.of<TextureOverlay>(overlay)), debutUs, finUs
        )
    }

    private const val MICRO = 1_000_000.0
}
