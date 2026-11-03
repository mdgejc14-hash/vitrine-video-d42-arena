package video.vitrine.ins.effects

import org.json.JSONException
import org.json.JSONObject
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Audit D41 — fuzzing du parseur de beat sheet (graine fixee, reproductible).
 * MotionJson.parse est appele dans ExportWorker sous runCatching qui ne doit
 * retomber que sur des erreurs JSON : toute autre exception (NPE, IndexOOB…)
 * serait un crash de rendu au lieu du repli script historique (F18/F57).
 */
class MotionJsonFuzzTest {

    private val rng = java.util.Random(424242L)

    private val baseValide = """
        {"plans":[
          {"t0":0.0,"t1":1.2,"kind":"clip","in_t":0.0,"fx":0.5,"fy":0.4,
           "z":[1.0,1.15],"tr":"fondu","shake":0.0,"rid":0},
          {"t0":1.2,"t1":2.4,"kind":"carte","in_t":0.0,"z":[1.0,1.0],"rid":-1}
        ],
        "words":[["bonjour",0.0,0.6],["5000",0.6,1.1]],
        "keywords":["5000"]}
    """.trimIndent()

    private fun muter(raw: String): String {
        val octets = raw.toByteArray().toMutableList()
        repeat(1 + rng.nextInt(10)) {
            if (octets.isEmpty()) return@repeat
            when (rng.nextInt(5)) {
                0 -> octets[rng.nextInt(octets.size)] = rng.nextInt(256).toByte()
                1 -> octets.removeAt(rng.nextInt(octets.size))
                2 -> octets.add(rng.nextInt(octets.size + 1), rng.nextInt(256).toByte())
                3 -> {
                    val position = rng.nextInt(octets.size + 1)
                    octets.addAll(position, "\"NaN\":null,".toByteArray().toList())
                }
                else -> {
                    val position = rng.nextInt(octets.size + 1)
                    octets.addAll(position, "1e999".toByteArray().toList())
                }
            }
        }
        return octets.toByteArray().toString(Charsets.UTF_8)
    }

    @Test
    fun `parse valide de reference`() {
        val sheet = MotionJson.parse(baseValide)
        assertTrue(sheet.plans.size == 2)
        assertTrue(sheet.words.size == 2)
        assertTrue("5000" in sheet.keywords)
    }

    @Test
    fun `parse mute ne leve que JSONException`() {
        repeat(400) {
            val mution = muter(baseValide)
            try {
                MotionJson.parse(mution)
            } catch (erreur: Throwable) {
                assertTrue(
                    "exception non geree ${erreur.javaClass.name} sur : ${mution.take(80)}",
                    erreur is JSONException || erreur is IllegalArgumentException ||
                        erreur is NumberFormatException
                )
            }
        }
    }

    @Test
    fun `troncatures et valeurs limites`() {
        listOf("", "{", "[]", "null", "{\"plans\":[]}", "{\"plans\":null}").forEach { cas ->
            try {
                MotionJson.parse(cas)
            } catch (erreur: Throwable) {
                assertTrue(erreur is JSONException || erreur is IllegalArgumentException)
            }
        }
        // plans vide = BeatSheet sans plan : le moteur doit le rendre, pas planter.
        val vide = MotionJson.parse("{\"plans\":[]}")
        assertTrue(vide.plans.isEmpty())
        // NaN/Infini via JSONObject : soit refuses, soit parses sans crash.
        try {
            val infini = MotionJson.parse(
                JSONObject().put("plans", org.json.JSONArray().put(
                    JSONObject().put("t0", 0.0).put("t1", Double.POSITIVE_INFINITY)
                        .put("z", org.json.JSONArray().put(1.0).put(1.0))
                )).toString()
            )
            assertTrue(infini.plans.size == 1)
        } catch (erreur: Throwable) {
            assertTrue(erreur is JSONException || erreur is IllegalArgumentException)
        }
    }
}
