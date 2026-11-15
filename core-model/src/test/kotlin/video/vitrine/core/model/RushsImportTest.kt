package video.vitrine.core.model

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

/**
 * D42.34 (CR-2) — contrat slots des rushs gabarit : l'index = la prise.
 * La fusion filmée > importée doit rester EXPLICITE et testée (l'ordre
 * fondateur interdit la concaténation aveugle brief+caméra).
 */
class RushsImportTest {

    @Test
    fun fusion_la_prise_filmee_prime_sur_l_importee() {
        val brief = listOf("content://import/1", "content://import/2")
        val cam = listOf("file:///film/1", "")
        assertEquals(
            listOf("file:///film/1", "content://import/2"),
            RushsImport.fusionParSlot(brief, cam),
        )
    }

    @Test
    fun fusion_slot_vide_des_deux_cotes_reste_vide() {
        val brief = listOf("", "content://import/2")
        val cam = listOf("", "")
        assertEquals(listOf("", "content://import/2"), RushsImport.fusionParSlot(brief, cam))
    }

    @Test
    fun fusion_camera_seule_brief_null() {
        val cam = listOf("file:///film/1", "")
        assertEquals(cam, RushsImport.fusionParSlot(null, cam))
    }

    @Test
    fun fusion_brief_seul_cam_null() {
        val brief = listOf("content://import/1", "")
        assertEquals(brief, RushsImport.fusionParSlot(brief, null))
    }

    @Test
    fun fusion_tous_nuls() {
        assertNull(RushsImport.fusionParSlot(null, null))
        assertNull(RushsImport.fusionParSlot(emptyList(), emptyList()))
    }

    @Test
    fun fusion_tailles_heterogenes_alignement_par_index() {
        // Caméra 3 prises, brief 2 imports : l'import ne doit JAMAIS glisser
        // sur une prise filmée (l'ancienne concaténation produisait 5 entrées).
        val brief = listOf("content://import/1", "content://import/2")
        val cam = listOf("file:///film/1", "file:///film/2", "file:///film/3")
        assertEquals(
            listOf("file:///film/1", "file:///film/2", "file:///film/3"),
            RushsImport.fusionParSlot(brief, cam),
        )
        // Et l'inverse : caméra 2 prises, brief aligné sur 3 slots.
        val brief3 = listOf("content://import/1", "", "content://import/3")
        val cam2 = listOf("", "file:///film/2")
        assertEquals(
            listOf("content://import/1", "file:///film/2", "content://import/3"),
            RushsImport.fusionParSlot(brief3, cam2),
        )
    }

    @Test
    fun serialisation_rond_bourre_bornee_aux_prises() {
        val slots = listOf("content://a", "", "content://c")
        assertEquals(slots, RushsImport.deserialiser(RushsImport.serialiser(slots), 3))
        // Borné : 5 slots sérialisés, 2 prises dans le gabarit → 2 retenus.
        assertEquals(
            listOf("content://a", ""),
            RushsImport.deserialiser(RushsImport.serialiser(listOf("content://a", "", "x", "y", "z")), 2),
        )
        // Vide / null : aucun slot restauré.
        assertEquals(emptyList<String>(), RushsImport.deserialiser(null, 3))
        assertEquals(emptyList<String>(), RushsImport.deserialiser("", 3))
    }
}
