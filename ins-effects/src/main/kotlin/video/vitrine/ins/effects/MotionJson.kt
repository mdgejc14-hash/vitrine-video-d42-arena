package video.vitrine.ins.effects

import org.json.JSONObject

/** Beat sheet JSON du pipeline (t0, t1, kind, in_t, fx, fy, z, tr, shake) + mots Whisper. */
object MotionJson {

    data class BeatSheet(val plans: List<BeatSheetPlan>, val words: List<WordStamp>, val keywords: Set<String>)

    fun parse(json: String): BeatSheet {
        val root = JSONObject(json)
        val plans = root.getJSONArray("plans").let { array ->
            (0 until array.length()).map { i ->
                val o = array.getJSONObject(i)
                val z = o.getJSONArray("z")
                BeatSheetPlan(
                    t0 = o.getDouble("t0"),
                    t1 = o.getDouble("t1"),
                    kind = o.optString("kind", "clip"),
                    inT = o.optDouble("in_t", 0.0),
                    fx = o.optDouble("fx", 0.5),
                    fy = o.optDouble("fy", 0.5),
                    zStart = z.optDouble(0, 1.0),
                    zEnd = z.optDouble(1, 1.0),
                    transition = o.optString("tr", "cut"),
                    shake = o.optDouble("shake", 0.0),
                    rushIndex = o.optInt("rid", -1)
                )
            }
        }
        val words = root.optJSONArray("words")?.let { array ->
            (0 until array.length()).map { i ->
                val w = array.getJSONArray(i)
                WordStamp(w.getString(0), w.getDouble(1), w.getDouble(2))
            }
        } ?: emptyList()
        val keywords = root.optJSONArray("keywords")?.let { array ->
            (0 until array.length()).map { i -> array.getString(i) }.toSet()
        } ?: emptySet()
        return BeatSheet(plans, words, keywords)
    }
}
