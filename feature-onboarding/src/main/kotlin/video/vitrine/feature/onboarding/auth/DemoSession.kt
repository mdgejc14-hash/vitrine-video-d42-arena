package video.vitrine.feature.onboarding.auth

/**
 * Session locale fictive (mode demo H24) : permet de valider camera, export et
 * gabarits demo SANS projet Firebase ni compte Google sur l'appareil.
 * Aucun appel reseau : le parcours complet reste testable hors-ligne.
 */
object DemoSession {
    const val UID = "user_demo_123"
    const val TOKEN = "demo-token-local"
}
