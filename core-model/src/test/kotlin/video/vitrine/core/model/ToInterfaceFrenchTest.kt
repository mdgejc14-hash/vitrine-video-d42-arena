package video.vitrine.core.model

import org.junit.Assert.assertEquals
import org.junit.Test

/**
 * D42.32 (Lot 8, P1) — caractérisation de toInterfaceFrench.
 *
 * RCA du défaut cité à l'audit (« Tu pouvez laisser vide ») : EZ_REGEX exige
 * un radical d'au moins 5 lettres, donc « pouvez » (radical « pouv ») n'était
 * JAMAIS conjugué ; le remplacement mécanique vous→tu produisait « Tu pouvez ».
 * Même famille : « tu avez », « peuvent tu joindre » (vous pronom objet),
 * « Choisisse » ( EZ -e au lieu du -es de l'indicatif), « Dites … tu … »
 * (impératif pluriel resté).
 *
 * Chaque cas ci-dessous est une chaîne RÉELLE portée par les 30 gabarits
 * (labels, aides, consignes caméra, guides parole). La fonction est pilotée
 * par ce corpus : toute nouvelle formulation des JSON doit passer ici.
 */
class ToInterfaceFrenchTest {

    @Test
    fun `tutoiement correct sur les chaînes réelles des 30 gabarits`() {
        val cas = listOf(
            // défaut exact de l'audit : « Tu pouvez laisser vide »
            "Écrivez ses vrais mots. Vous pouvez laisser vide." to
                "Écris ses vrais mots. Tu peux laisser vide.",
            // verbes courts non couverts par EZ_REGEX
            "Dites ce que vous avez préparé." to "Dis ce que tu as préparé.",
            "Dites ce que vous avez choisi pour le préparer." to
                "Dis ce que tu as choisi pour le préparer.",
            // irréguliers
            "Dites ce que vous faites." to "Dis ce que tu fais.",
            "Dites quel travail vous faites." to "Dis quel travail tu fais.",
            // indicatif régulier en -es (EZ produisait « tu propose »)
            "Dites ce que vous proposez." to "Dis ce que tu proposes.",
            // « vous » pronom objet : te devant consonne, t’ devant voyelle
            "Dites où les gens peuvent vous joindre; l’adresse et le numéro sont aussi à l’écran." to
                "Dis où les gens peuvent te joindre; l’adresse et le numéro sont aussi à l’écran.",
            "Dites où les gens peuvent vous trouver." to
                "Dis où les gens peuvent te trouver.",
            // EZ -e incorrect pour l'indicatif (« tu dresse »)
            "Filmez vos mains pendant que vous dressez le plat. Terminez par un petit moment sans bouger." to
                "Filme tes mains pendant que tu dresses le plat. Termine par un petit moment sans bouger.",
            "Filmez vos mains pendant que vous rangez ou emballes le produit." to
                "Filme tes mains pendant que tu ranges ou emballes le produit.",
            // impératifs courts (radical < 5 lettres, hors EZ_REGEX)
            "Posez les ingrédients du plat sur une surface propre. Filmez-les de dessus, près d’une fenêtre." to
                "Pose les ingrédients du plat sur une surface propre. Filme-les de dessus, près d’une fenêtre.",
            "Filmez une vraie action de cuisson ou de grillade. Gardez le téléphone stable. Si le son est bon, laisse-le." to
                "Filme une vraie action de cuisson ou de grillade. Garde le téléphone stable. Si le son est bon, laisse-le.",
            // radical court + particule « en »
            "Montrez le plat chaud pendant que vous en parlez." to
                "Montre le plat chaud pendant que tu en parles.",
            // -issez régulier en -is (EZ produisait « Choisisse »)
            "Choisissez le dernier jour de l’offre." to "Choisis le dernier jour de l’offre.",
            // entrée exacte : forme figée avec double retouche
            "Choisissez votre pays, puis écrivez le numéro sur lequel les clients peuvent vous écrire." to
                "Choisis ton pays, puis écris le numéro sur lequel les clients peuvent t’écrire."
        )
        cas.forEach { (brut, attendu) ->
            assertEquals("conjugaison du tutoiement", attendu, toInterfaceFrench(brut))
        }
    }

    @Test
    fun `règles générales préservées`() {
        assertEquals("Tiens la caméra droite.", toInterfaceFrench("Tenez la caméra droite."))
        assertEquals("Sois bref.", toInterfaceFrench("Soyez bref."))
        assertEquals("Ajoute le lien WhatsApp.", toInterfaceFrench("Ajoutez le lien WhatsApp."))
        assertEquals("Tes mains", toInterfaceFrench("Vos mains"))
        // frontière de mot : l'exception « avez » ne touche jamais « Bravez »
        // (un replace par sous-chaîne produirait « Bras la foule. »).
        assertEquals("Bravez la foule.", toInterfaceFrench("Bravez la foule."))
    }
}
