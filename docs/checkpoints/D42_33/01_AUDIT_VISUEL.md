# D42.33 — Audit visuel de l'existant (base bb759f8) vs spécification

Méthode : lecture des sources Compose + greps quantifiés + SCREEN_INVENTORY.csv D42_32 (21 écrans).
Cet audit est la référence des écarts ; chaque famille (checkpoints 04→10) détaillera au moment
de l'édition. **Aucune modification fonctionnelle** : les signatures, ViewModels, contrats,
testTags e2e (`dash_create_video`, `dash_referral_code`, `dash_settings_icon`, `price_*`,
`ref2_gauge`…) sont INTANGIBLES.

## 1. État du design system (core-designsystem)

| Fichier | État | Écart vs spec |
|---|---|---|
| `Color.kt` | 10 tokens FR (OrangeStore, OrangeStoreDeep, BleuNuit, BleuNuitSoft, BlancPur, GrisDoux, GrisLiserai, OrangeVoile, BleuVoile, AmbreAlerte) | Manquent OrangeHi #FF6E22, Muted #6C7C99, VertSucces #0E9F6E, VertTexte #0B7A55, RougeBloquant #B42318, InfoEncre #1B4CA1, désactivé #EDEFF5/#9AA7BE |
| `Type.kt` | `Typography()` système pur, aucune police | Aucune police locale ; échelle cible 29/21/16.5/15/14.5/12.5/11 absente ; pas de Num 40-44, Button 16, Label 11 uppercase |
| `Theme.kt` | light/dark schemes ; **inversions** : background=BlancPur, surface=GrisDoux | Cible : background=Bg #F7F8FC, surface=blanc ; primary=OrangeStore ; mapping complet M3 |
| `Shape.kt` | **ABSENT** | Créer : pill 999 / sheet 30 / hero 26 / card 22 / tile 18 / icon 14 |
| `Dimens.kt` | **ABSENT** | Créer : marge 20, gouttière 12, CTA 56/46, header 52, tab bar 74+26, cible 48… |
| `Elevation.kt` | **ABSENT** | Créer : shSm/shMd/shLg (navy rgba) + shOrange réservé CTA |
| Composants | SectorCard3D, SectorLabel, VitrineLogoHeader, VitrineLocale, previews | Aucun des 15+ composants §7 (bouton primaire pilule, carte héro, badge/chip, ligne de liste, stepper, champ, feuille, anneau, tuile de prise, tab bar, bandeau hors-ligne, overlay caméra) |
| Polices | **AUCUNE** (politique « pas de téléchargement » D42.32) | D42.33 exige Plus Jakarta Sans 700/800 + Inter 400/500/600 **locales** + licences OFL |

## 2. Quantification des écarts dans les écrans (greps)

- **134 usages** `MaterialTheme.typography.*` → la refonte de `Type.kt` propagera l'échelle
  cible SANS toucher les call sites (mapping M3 → échelle spec, §stratégie ci-dessous).
- **34 couleurs brutes** `Color(0x…)` hors Color.kt : PriseGuideScreen (14), GuidedShootingOverlay
  (10), VignetteCatalogue (7), DashboardScreens (2 : SyncVert/SyncGris), CatalogScreen (1).
- **29 RoundedCornerShape** à la main, rayons 3/4/6/8/10/12/14/16/18/70 — échelle cible
  14/18/22/26/30/999.
- **12 Button()** Material directs + OutlinedButton/TextButton dispersés → remplacer par les
  composants unifiés (§7.1/7.2) au fil des familles.
- Padding horizontal 12/16/24 dominant — marge cible **20**.
- `enableEdgeToEdge`/insets : 5 usages seulement ; le gabarit §2 (header 52 + CTA collant +
  tab bar + safe areas) est à outiller.

## 3. Écran par écran — écarts majeurs (cible spec §8-§11)

| Écran (fichier) | famille | Écarts majeurs |
|---|---|---|
| Splash (MainActivity, API système) | A | Pas de tuile blanche 72 rayon 26 ni barre de chargement 3 dp (§9.1) — à repeindre dans le contenu Compose |
| Carrousel (CarouselScreen.kt, 139 l.) | A | À auditer en famille 04 : scrim navy 45 %, pagination pilule 18, H1 29 |
| Langue (LanguageScreen.kt, 68 l.) | B | Cartes-options + coche ; CTA pilule |
| Auth (auth/AuthActivity.kt) | B | Carte Google unique + 3 bénéfices + logo officiel pastille 44 ; bandeau hors-ligne |
| Code parrain (OnboardingScreens.kt) | B | Champ 56 rayon 18, badge étape, CTA pilule ; padding 24 → 20 |
| Secteurs (OnboardingScreen) | B | Grille 2 col OK (gouttière 12 ✓) mais SectorCard3D = style 3D à repeindre (rayon 22, sélection filet 2 dp orange + coche) |
| Bienvenue/crédits (WelcomeScreen) | A | **Écran signature §9.4** : fond clair + carte BleuVoile → fond navy + halo, tuile cadeau, « Félicitations ! », carte solde 3 tuiles si confirmé, réassurances, CTA |
| Catalogue (CatalogScreen.kt, 382 l.) | C | Héro 16:9 en vedette + grille 2 col + badge durée ; padding 16→20 ; 1 couleur brute |
| Vignettes (VignetteCatalogue.kt) | C | 7 couleurs brutes (gradients sectoriels) → voiles/carte spec |
| Détail gabarit | D | Écran « 4 scènes numérotées » — à vérifier/auditer en famille 05 (peut manquer) |
| Brief (GabaritBriefScreen.kt, 468 l.) | E | Header d'étape + barre 4 dp + champ 56 + compteur ; PiedContinuer 52 → CTA 56 collant |
| ReadyCheck (ReadyCheckScreen.kt, 190 l.) | F | **§9.6 préparation caméra** : anneau de score, 4 cartes de test, CTA conditionnel — restructuring visuelle de l'existant (mêmes mesures réelles) |
| Caméra (PriseGuideScreen.kt, 333 l.) | G | 14 couleurs brutes ; overlay §7.15 (cadre coins 18, grille des tiers, bandeau consigne navy 55 %, stop rouge 64) |
| Prises/REC (GuidedShootingOverlay.kt) | G | 10 couleurs brutes ; anneau/chrono, badge REC, tuiles §7.12 |
| Aperçu/montage (VideoPreviewScreen + ExportPreviewPanel) | H | Timeline 4 segments, anneau §7.11, feuille 30 |
| Export/partage | H+I | §9.5 export prêt (aplat orange 52 %, feuille blanche 30) — FLAG_SECURE : captures = dumps + MP4 uniquement |
| Dashboard (DashboardScreens.kt, 650 l.) | J | **§9.3 intégral** : « Bonjour, — » (tiret interdit → « Bonjour » seul) ; carte crédits blanche → héro navy 26 + Num + badges ; 2 OutlinedButton jumeaux → supprimer ; CTA 52 → pilule 56 + micro-copie ; pas de « Reprendre » brouillon ni « Derniers exports » 2 tuiles ni tab bar ; engrenage Canvas → icône 24 |
| Paywall (PaywallScreen) | J | 3 cartes formules → CarteFormule (Pro recommandé navy, montant dans le bouton) ; bouton inactif conservé (CinetPay reporté, vérité des états) |
| Réglages (SettingsScreen) | J | Groupes de lignes §7.7 (min 72, séparateur inset 20), header avatar |
| Parrainage (ReferralScreen) | J | Code en grand copiable §28, jauge, filleuls anonymisés ( garder) |
| Aide | J | **§9.7 à CRÉER** (écran + entrée Réglages + canaux réels ou état honnête) |
| Hors-ligne | §10 | Bandeau §7.14 unique à outiller dans core-designsystem |

## 4. Stratégie typographie (décision)

Mapping M3 → échelle spec appliqué dans `Type.kt` (propagation aux 134 usages sans toucher les
écrans) : displayLarge/Small→Num 40-44/800 · headlineLarge→H1 29/800 · headlineMedium→H2 21/800 ·
headlineSmall→H3 16.5/700 · titleLarge→H2 · titleMedium→H3 · titleSmall→BodyStrong 15/600 ·
bodyLarge→Body 15/400 · bodyMedium→Sub 14.5/400 · bodySmall→Tiny 12.5/400 · labelLarge→Button
16/700 · labelMedium→Chip 12.8/600 · labelSmall→Label 11/700 uppercase. Styles nommés
supplémentaires exposés pour les nouveaux composants.

## 5. Risques et garde-fous

- **Tests e2e lab (15/15)** : sélecteurs textuels et testTags à préserver ; vérifier par famille.
- **FLAG_SECURE** (export/partage) : jamais contourné ; preuves = dumps XML + MP4.
- **Caméra** : PreviewView CameraX réel — l'overlay est repeint SANS toucher au moteur.
- **detekt/ktlint** : respecter LongMethod (extraire), pas de magic numbers nommés.
- **Pas de nouvelles strings** sauf les 2 écrans créés (§9.6 existe déjà partiellement via
  ReadyCheck ; §9.7 Aide) — FR source + EN parité.
