# D42.33 — 05 Famille Catalogue (famille C)

Commits : 16d78c6 (refonte) → complément detekt dans le commit famille 06
(extraction `EnTeteCatalogue`). Écran : catalogue (5 gabarits du secteur).

## Réalisations (spec §7.3, §8-C)

| Zone | Avant (D42.32) | Après (D42.33) |
|---|---|---|
| Marge | 12 dp | **20 dp**, gouttière **12 dp** |
| En-tête | VitrineLogoHeader (logo centré 64) | **MarqueVitrine** (pastille blanche 40, source unique partagée), titre **H2 21/800 Navy**, action « Changer de secteur » Tiny 700 OrangeDeep |
| Bandeau hors-ligne | bande Text secondaryContainer | **BandeauEtat §7.14** (ic_wifioff, padding 20) |
| Badge secteur | labelLarge onSurfaceVariant | Tiny Muted (pastille teinte métier conservée) |
| Liste gabarits | cartes horizontales pleine largeur ×5 | **§8-C : 1 gabarit en vedette (héro 16:9 pleine largeur, tuile blanche rayon 22 + ombreSm) + grille 2 colonnes** (tuiles rayon 22, vignette 16:9, badge durée réel, nom H3/13.5, méta Tiny Muted) |
| Chevrons orange dessinés | Canvas dans chaque carte | supprimés (carte entière cliquable, ombre = affordance) |

Fonctionnel INTACT : `onGabaritClick`/`onSkinClick` inchangés, filtre
`GabaritCatalog.visible`, repli défensif initialSector null (D42.32 P0-1),
grille lazy >12 skins, vignette sectorielle dessinée D42.30 (viseur/pellicule/
durée réels, aucun faux Play), LazyImageLoader miniature réseau + repli.

## Détail technique

- `EnTteCatalogue` extrait (detekt LongMethod : CatalogScreen 91→40 lignes).
- `GabaritHero`/`GabaritTuile` : nouveaux privés ; `VignetteSecteur` conservée
  (Contrat D42.30 : visuel de marque honnête, aucune dépendance réseau).
- SkinLayout : paddings 20 / gouttière 12 ; SkinCard : fond Navy (pas
  0xFF1B1B1F brut), titre H3 13.5 Navy maxLines 1, libellé Tiny Muted.
- i18n : `carousel_skip` EN ajouté (le test I18nKeyCoverageTest du run
  43600081462 avait détecté la clé FR-only).

## Tests

- CatalogVisualCheckTest / CatalogManifestParserTest (Robolectric) : rendent
  l'écran réel — validation par android-ci.
- e2e : `CATALOGUE` = titre « Choisissez un modèle de vidéo » INTACT (aucun
  test ne dépend des cartes elles-mêmes).
