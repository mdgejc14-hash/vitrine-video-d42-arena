# D42.33 — 02 Tokens : Color / Type / Shape / Dimens / Elevation / Theme

Base : commit 69b1a8e (J0). Spec §2-§5 appliquée intégralement.

## Fichiers créés/modifiés (core-designsystem)

| Fichier | Action | Contenu |
|---|---|---|
| `Color.kt` | réécrit | Tokens canoniques spec : OrangeStore #F95C0F, OrangeHi #FF6E22, OrangeDeep #D34905, Navy #022358, NavySoft #23467F, Bg #F7F8FC, Blanc (Surface) #FFFFFF, Line #E2E8F0, Muted #6C7C99, OrangeVoile #FFF1E8, BleuVoile #E9F0FF, VertSucces #0E9F6E, VertTexte #0B7A55, AmbreAlerte #B26A00, RougeBloquant #B42318 + utilitaires (InfoEncre #1B4CA1, GrisDesactive #EDEFF5, GrisDesactiveTexte #9AA7BE, scrims/alphas blancs). Alias FR historiques conservés (dépréciés) : zéro cassage d'import. |
| `Type.kt` | réécrit | Polices locales : Plus Jakarta Sans 700/800 + Inter 400/500/600 (statiques — minSdk 24, axes variables limités API 26+). Styles nommés `VitrineText` (H1 29/800/-0.035em, H2 21/800/-0.03, H3 16.5/700/-0.02, Body 15/400, BodyStrong 15/600, Sub 14.5/400, Tiny 12.5/400, Label 11/700/+0.09em Muted, Num 40-44/800/-0.045, Button 16/700, Chip 12.8/600, Badge 11/700). **Mapping M3 → spec** : display→Num, headlineLarge→H1, headlineMedium→H2, headlineSmall→H3, titleLarge→H2, titleMedium→H3, titleSmall→BodyStrong, bodyLarge→Body, bodyMedium→Sub, bodySmall→Tiny, labelLarge→Button, labelMedium→Chip, labelSmall→Label(neutre). Les 134 usages `MaterialTheme.typography.*` héritent de l'échelle sans modification des écrans. |
| `Shape.kt` | créé | FormePill 999 / FormeFeuille 30 haut / FormeHero 26 / FormeCarte 22 / FormeTuile 18 / FormeIcone 14 + `FormesVitrine` (Shapes M3 mappées). |
| `Dimens.kt` | créé | `Dims` : marge 20, gouttière 12/10, header 52, tab bar 74+26, CTA 56/46, cible 48, bouton icône 40, carte padding 18/20, champ 56, ligne 72, badge 22, chip 32, progression 4, anneau 6, stop caméra 64, pastille logo 44, icônes 20/22/24/26/28, CTA collant 12/20/26. |
| `Elevation.kt` | créé | `Ombres` + `Modifier.ombreSm/Md/Lg/Orange`. Traduction documentée des multi-couches CSS en ombre Compose unique (2/8/18/10 dp, teintes navy/orange). **shOrange réservé au CTA** (§13). Teintes API 28+, dégradation neutre en-dessous. |
| `Theme.kt` | réécrit | **Correction des inversions** : background = Bg, surface = Blanc (avant : background blanc, surface gris). Schéma complet (primary OrangeStore, containers voiles, error RougeBloquant, outline Line, onSurfaceVariant NavySoft). `VitrineTheme` porte typography + shapes. |
| `res/font/` | ajout | 5 TTF : plus_jakarta_sans_bold/extrabold, inter_regular/medium/semibold. Licences OFL 1.1 dans `core-designsystem/licenses/`. SHA-256 consignés dans ASSET_LICENSES.md (galerie). |

## Décisions d'implémentation

1. **`Surface` → `Blanc`** : évite la collision d'import avec `androidx.compose.material3.Surface`
   (les écrans importent les deux). Correspondance documentée dans Color.kt.
2. **Polices statiques** (pas variables) : rendu 700/800 garanti sur API 24-25 (marché cible).
3. **Alias dépréciés** (BleuNuit, GrisDoux, OrangeStoreDeep, SyncVert, SyncGris…) : compilés
   sans erreur, migrés au fil des familles ; « une seule valeur par couleur » respecté (alias =
   redirection, pas duplication).
4. **labelSmall neutre en couleur** : la spec veut Label = Muted ; le style nommé
   `VitrineText.Label` porte Muted, le mapping M3 reste neutre pour ne pas recolorer
   silencieusement les usages existants qui posent déjà leur couleur.

## Vérifications

- `grep` : aucun autre `Typography()` résiduel ; `VitrineTypography` référencé par Theme.kt.
- Imports historiques (BleuNuit, OrangeVoile, AmbreAlerte…) résolus par les alias.
- CI : android-ci déclenché sur la branche (trigger ajouté, à retirer avant fusion).

## Reste à faire (familles suivantes)

- 03_COMPOSANTS : 18 composants (§7.1-§7.15 + carte formule + tuile consentement…).
- Migration des 34 couleurs brutes et 29 RoundedCornerShape au fil des familles.
