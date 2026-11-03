package video.vitrine.ins.effects

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

/**
 * Audit D41 (F55) : alignement des prises sautees. Un creux ("") est remplace
 * par le rush non vide le plus proche (precedent d'abord, sinon suivant) — le
 * montage ne se DECALe plus quand le commercant passe une prise au guide E6.
 */
class RushSlotsTest {

    @Test
    fun `creux comble par le voisin precedent puis suivant`() {
        assertEquals(
            listOf("a", "a", "a", "b", "b"),
            RushSlots.resolve(listOf("", "a", "", "b", ""))
        )
    }

    @Test
    fun `creux de tete remplace par le suivant`() {
        // Aucun precedent disponible : les creux de tete prennent le suivant.
        assertEquals(
            listOf("y", "y", "y"),
            RushSlots.resolve(listOf("", "", "y"))
        )
    }

    @Test
    fun `prises reelles conservees dans l ordre absolu`() {
        val slots = listOf("r1", "", "r3", "")
        val resolved = RushSlots.resolve(slots)
        assertEquals(4, resolved.size)
        assertEquals("r1", resolved[0])
        assertEquals("r1", resolved[1])
        assertEquals("r3", resolved[2])
        assertEquals("r3", resolved[3])
    }

    @Test
    fun `liste entierement vide rend liste vide (repli mono-rush)`() {
        assertEquals(emptyList<String>(), RushSlots.resolve(listOf("", "", "")))
        assertEquals(emptyList<String>(), RushSlots.resolve(emptyList()))
    }

    @Test
    fun `firstReal renvoie le premier rush reel ou null`() {
        assertEquals("a", RushSlots.firstReal(listOf("", "a", "b")))
        assertNull(RushSlots.firstReal(listOf("", "")))
        assertNull(RushSlots.firstReal(emptyList()))
    }
}
