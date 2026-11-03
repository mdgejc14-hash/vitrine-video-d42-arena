package video.vitrine.app.qa

/**
 * Marqueur de la variante qaDeterministic (VV Remote QA niveau B).
 * Doit etre ABSENT de tout build releaseCandidate : le step CI
 * "Hygiene release" grep ce symbole dans les dex et echoue sinon.
 */
object QaMarker {
    const val LEVEL = "B-deterministic"
}
