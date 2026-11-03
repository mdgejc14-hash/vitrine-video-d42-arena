package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Test

class MotionJsonTest {

    private val json = """
        {"plans":[
          {"t0":0.0,"t1":1.5,"kind":"clip","cid":34579096,"in_t":0.6,"fx":0.5,"fy":0.5,
           "z":[1.10,1.02],"tr":"glitch","shake":1.0,"rid":0},
          {"t0":1.5,"t1":3.0,"kind":"card","in_t":0.0,"fx":0.4,"fy":0.6,
           "z":[1.0,1.0],"tr":"cut","shake":0.0,"rid":1}
        ],
         "words":[["300",3.44,3.70],["mille",3.70,4.20]],
         "keywords":["300"]}
    """.trimIndent()

    @Test
    fun `beat sheet parse conforme au pipeline livre`() {
        val sheet = MotionJson.parse(json)
        assertEquals(2, sheet.plans.size)
        assertEquals(1.10, sheet.plans[0].zStart, 0.001)
        assertEquals("glitch", sheet.plans[0].transition)
        assertEquals(1, sheet.plans[1].rushIndex)
        assertEquals(2, sheet.words.size)
        assertEquals(setOf("300"), sheet.keywords)
    }
}
