# D42.32 — Lot 10 / §6 : Design system (référence + harmonisation)

> Recréé après rollback sandbox (commit original 3536e44 perdu) — même contenu,
> réaligné sur HEAD. Ce document est la **source de vérité visuelle** pour §6,
> la galerie §8 et toute revue de code UI.

## 1. Charte officielle (core-designsystem/Color.kt)

Échantillonnée AU PIXEL sur les 197 maquettes Drive (référence visuelle absolue) :

| Token | Valeur | Usage |
|---|---|---|
| `BleuNuit` | `#022358` | couleur primaire, en-têtes, texte fort |
| `BleuNuitSoft` | `#23467F` | dérivé (luminosité), éléments secondaires navy |
| `OrangeStore` | `#F95C0F` | accent, actions principales, CTA |
| `OrangeStoreDeep` | `#D34905` | états pressés/sombres de l'accent |
| `BlancPur` | `#FFFFFF` | surfaces pleines |
| `GrisDoux` | `#F7F8FC` | fond d'écran |
| `GrisLiserai` | `#E2E8F0` | séparateurs, bordures |
| `OrangeVoile` | `#FFF1E8` | fond de badge/encart orange |
| `BleuVoile` | `#E9F0FF` | fond de badge/encart navy |

Typographie : **système robuste** (`VitrineTypography = Typography()`) — aucun
téléchargement de police (coût data réel des commerçants). Hiérarchie Material 3 :
`headlineSmall` titres d'écran, `titleMedium` cartes, `bodyMedium` texte courant,
`labelSmall` badges.

## 2. Standards transverses (à appliquer partout, §6)

- **Barre d'action épinglée** (écrans à étapes) : `Surface(tonalElevation = 3.dp,
  color = surface)` + `Row` padding 16-24/10-12 + `Button` `fillMaxWidth().heightIn(min = N)`.
  Hauteur minimale **portée par le bouton**, jamais après padding (leçon D42.13 :
  heightIn après padding écrase le bouton à ~22 dp). N = **56 dp** (parcours
  bienvenue/onboarding — Lot 9), **52 dp** (écrans denses de formulaire — Lot 10,
  PiedContinuer de GabaritBriefScreen).
- **Rayons** : 8 dp standard (cartes, badges, encarts) ; 12 dp grandes cartes
  héro ; 6 dp micro-éléments (pastilles, tags) ; jamais de rayon libre hors
  3/4/6/8/10/12/16.
- **Espacements** : grille 4 dp — 4/8/12/16/24 ; marges d'écran 16 dp (24 dp
  écrans éditoriaux bienvenue).
- **Boutons** : M3 `Button` plein pour l'action unique (`OrangeStore` via thème) ;
  `TextButton` pour actions secondaires ; **jamais** de bouton plat sur fond
  voilé pour une action principale.
- **Champs** : `OutlinedTextField` M3 standard + zone erreur élastique 130 %
  (Lot 8) ; `ImeAction.Next` entre champs (Lot 8).
- **Cartes** : `ElevatedCard`/`Card` M3, fond surface, liseré `GrisLiserai`
  quand information secondaire ; badge = fond voilé (`OrangeVoile`/`BleuVoile`)
  + texte token fort, rayon 8 dp.
- **États sync/erreur** : état affiché honnête (Lot 5) — texte `onSurfaceVariant`
  + pastille couleur d'état, jamais de faux « synchronisé ».

## 3. Écarts JUSTIFIÉS conservés (ne pas « harmoniser »)

- **HUD caméra** (`PriseGuideScreen`, `GuidedShootingOverlay`) : couleurs RGBA
  locales superposées au flux vidéo — noirs translucides `0xB3/0xCC/0x99_000000`,
  blancs `0xCC/0x33_FFFFFF` pour la lisibilité sur image vive. Les tokens clairs
  de surface (voiles, GrisDoux) y seraient ILLISIBLES. Statuts : prêt
  `0xFF2E7D32` (vert), démarrage `0xFF8D6E00` (ambre), REC `0xFFFF3B30` (rouge),
  gate `0xFF7BD88F`/`0xFFFF6B6B`. Ces valeurs ne sortent PAS du HUD.
- **Ambre `0xFFB26A00` (BriefScreen:67)** : avertissement champ (contraste AA sur
  fond clair), volontairement distinct de l'orange d'action `OrangeStore` pour ne
  pas faire croire à un bouton. Conservé.
- **Palette statuts HUD** ≠ palette marque : fonctionnelle (sémantique vidéo),
  documentée ici même.
- **Gradients sectoriels des vignettes** (`VignetteCatalogue` : 7 couples
  sombres par secteur — mode, coiffure, restauration, BTP, immo/auto, commerce,
  tous) : direction artistique D'IDENTITÉ par secteur sur la scène sombre du
  catalogue ; les rabattre sur navy/orange détruirait la différenciation.
- **Scène sombre du catalogue** (`CatalogScreen` fond `0xFF1B1B1F`) : galerie
  cinématique destinée à mettre les vignettes vidéo en valeur — pas une surface
  de lecture, reste sombre par design.
- **Statuts de synchronisation dashboard** (`SyncVert 0xFF178A4B`,
  `SyncGris 0xFF9AA3AF`) : sémantique d'état (synchronisé/en attente), privées
  au module dashboard.
- `CameraMoves.eraseColor(0xFFFFFFFF)` : opération technique bitmap, pas un
  choix UI.

## 3bis. Corrections §6 (harmonisation réelle, sans refonte)

- **`AmbreAlerte` (0xFFB26A00) ajouté aux tokens** : la valeur était dupliquée
  en dur dans `BriefScreen` (message d'erreur) et `DashboardScreens`
  (avertissement quota paywall) — token unique, mêmes deux usages.
- **`ExportPreviewPanel` : mot-clé mis en avant avec le token `OrangeStore`**
  au lieu de la valeur brute `0xFFF95C0F` (dérive identique à la marque,
  invisible à l'œil mais interdisait tout ajustement centralisé).
- Audit boutons/champs/cartes/rayons/badges du parcours commercial :
  boutons M3 standards (thème), champs OutlinedTextField + zone erreur 130 %
  (Lot 8), rayons déjà dans la grille 6/8/10/12, badges sur voiles —
  **aucune autre dérive trouvée** (grep exhaustif des `Color(0x…)` hors
  core-designsystem : 37 occurrences, toutes classées ci-dessus).

## 4. Changement DS ⇒ tests ciblés (§6)

Toute modification de `core-designsystem` (Color/Type/Theme) ou d'un composant
standard ci-dessus déclenche UNIQUEMENT les tests des consommateurs réels :
`feature-dashboard` (DashboardScreens + Paywall), `feature-catalog`
(CatalogScreen + VignetteCatalogue), `feature-brief`, `feature-onboarding`,
`feature-camera` (HUD — vérifier lisibilité, pas les valeurs). Compile ≠ terminé :
la vérification visuelle passe par la galerie §8 (captures authentiques,
émulateur identifié).

## 5. Journal du lot

- **Lot 10 (recréé)** : `PiedContinuer` (GabaritBriefScreen) aligné sur la barre
  d'action standard — Surface tonalElevation 3, bouton plein **52 dp**, hauteur
  sur le bouton, padding sur conteneur. Couleurs HUD caméra et ambre BriefScreen:67
  conservés (§3 ci-dessus).
- **§6 harmonisation** : token `AmbreAlerte` créé et appliqué (BriefScreen,
  DashboardScreens), `ExportPreviewPanel` → `OrangeStore`, déviations justifiées
  documentées (§3/§3bis). Tests ciblés consommateurs : android-ci (modules
  feature-brief, feature-dashboard, feature-export, core-designsystem).
