# Audit CI-Visual-Check (statique, zero build)

## Parite i18n (fr vs en/es/ja)

| Module/locale | Clefs manquantes |
|---|---|
| feature-camera/src values-en | aucune |
| feature-camera/src values-es | aucune |
| feature-camera/src values-ja | aucune |
| feature-brief/src values-en | aucune |
| feature-brief/src values-es | aucune |
| feature-brief/src values-ja | aucune |
| feature-onboarding/src values-en | aucune |
| feature-onboarding/src values-es | aucune |
| feature-onboarding/src values-ja | aucune |
| feature-catalog/src values-en | aucune |
| feature-catalog/src values-es | aucune |
| feature-catalog/src values-ja | aucune |
| feature-export/src values-en | aucune |
| feature-export/src values-es | aucune |
| feature-export/src values-ja | aucune |
| core-designsystem/src values-en | aucune |
| core-designsystem/src values-es | aucune |
| core-designsystem/src values-ja | aucune |

## Tokens interdits (demo/invité/codes techniques)

- feature-onboarding/src/main/kotlin/video/vitrine/feature/onboarding/OnboardingScreens.kt: affichage .code
- feature-onboarding/src/main/kotlin/video/vitrine/feature/onboarding/OnboardingActivity.kt: affichage .code

## Palette officielle complete dans Color.kt : OUI (['0A192F', '1E293B', 'E2E8F0', 'F05000', 'F8FAFC', 'FF5500', 'FFFFFF'])

## Previews Compose par ecran

| Fichier | @Preview |
|---|---|
| BriefScreen.kt | 1 |
| OnboardingScreens.kt | 1 |
| CarouselScreen.kt | 1 |
| LanguageScreen.kt | 1 |
| CatalogScreen.kt | 1 |
| DesignSystemPreviews.kt | 1 |
| SectorCard3D.kt | 1 |

## Activites non declarees au manifest : AUCUNE
