package video.vitrine.feature.onboarding.auth

/** Etat UI de l'ecran auth (JSON ecrans 3.7 : id=auth). */
sealed interface AuthUiState {
    data object Idle : AuthUiState
    data object Loading : AuthUiState
    data class SignedIn(val uid: String, val refCode: String?) : AuthUiState
    data class Error(val message: String) : AuthUiState
}
