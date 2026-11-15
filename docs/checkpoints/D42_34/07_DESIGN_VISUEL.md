# D42.34 — CR-5 · Carrousel 3 métiers / logo officiel / splash

## ① Carrousel — 3 slides = 3 métiers/personnes différents

### Cause racine (démontrée)

Les 3 drawables `carrousel_*.webp` (720×1280, D42.33) provenaient d'un même
jeu d'images générique : slides 1-3 sans diversité de métiers/personnes
(répétition du même univers visuel), contraire à l'exigence fondateur
« commerce femme / restauration / mode ».

### Correction appliquée

Remplacement des 3 images par les ressources Drive D (recadrage centré
9:16 → 720×1280, webp qualité 88, PIL — aucun code touché, mêmes noms de
ressources, `ContentScale.Crop` inchangé) :

| Slide | Nouvelle image (Drive D) | Métier/personne | Texte (INCHANGÉ) |
|---|---|---|---|
| 1 | `photo-merchant.jpg` — marchande dans sa boutique (portrait 9:16) | commerce femme | « Filme. Vends. C'est tout. » |
| 2 | `secteur_food.jpg` — plat de maquis (poulet braisé, riz) | restauration | « Filme tes produits, on te guide » |
| 3 | `secteur_mode.jpg` — boutique wax, portants colorés, cliente | mode | « Une vidéo prête à publier en 30 secondes » |

Aucun nouveau texte marketing (ordre respecté) — preuve :
`D34Lot5CarouselVisualCheckTest.carrousel_slide1_texts_inchanges_et_image_chargee`
assure les libellés fondateur inchangés.

## ② Logo officiel — MarqueVitrine (en-têtes, carrousel, connexions)

### Cause racine (démontrée, mesure PIL)

`vitrine_logo.png` (256×256, contenu 230×188) n'était PAS l'insigne
officiel : silhouette comparée au `mark.png` Drive D (141×143) =
**124,6/255 de différence** — un badge différent (plus large que haut)
avait été dessiné à la main.

### Correction

`vitrine_logo.png` reconstruit depuis le `mark.png` officiel (centré, 176 px
de haut, sans recoloration ni déformation — consignes de marque du
registre). `MarqueVitrine()` (tuile blanche rayon 14) inchangé.

## ③ Splash — logo officiel centré, pas de fausse animation

### Cause racine (démontrée, mesure PIL)

`splash_logo.png` (badge 156×127) et `splash_logo_tuile.png` (tuile rayon
55) contenaient le même badge NON officiel (silhouette 125,5/255 du mark
Drive D) — le fondateur voyait un logo qui n'était pas le sien.

### Correction

- `splash_logo_tuile.png` : tuile blanche **rayon mesuré préservé (55 px)**
  + insigne officiel `mark.png` centré (150 px) — le design D42.33 §9.1
  accepté (fond navy `#022358`, tuile blanche) est conservé ;
- `splash_logo.png` : insigne officiel seul, centré (160 px) ;
- `themes.xml` inchangé : `windowSplashScreenAnimatedIcon` = drawable
  STATIQUE → aucune animation (le splash disparaît au premier rendu, durée
  système ≤ 1,2 s — comportement API 12+ inchangé, jamais de fausse
  animation).

Vérification non-testable en Robolectric (splash = thème système API 31+) :
couverture par mesure d'asset (silhouette officielle, rayon préservé) +
capture D34-12 de la même tuile de marque.

## Registre de licences

`CREDITS_PHOTOS.md` (copie conforme du Drive D) commité dans
`docs/checkpoints/D42_34/`. Rappel honnête : images de maquette trouvées
par recherche web — **licence à acquérir ou remplacement par des photos
propres AVANT publication Play Store** (consigné dès le Lot 0, toujours
valable : photo-merchant/food/mode = banques d'images et sites marchands).

## Preuves (Lot 5) — exécutées, toutes vertes

- `:feature-onboarding` 31/31 (dont `D34Lot5CarouselVisualCheckTest` 2/2 :
  textes inchangés + image chargée ; marque officielle rendue) ;
- `:app:compileDebugKotlin` + ktlint + detekt verts (onboarding,
  core-designsystem) ;
- Captures `D34-11_carrousel-slide1-marchande_APRES.png` et
  `D34-12_marque-officielle_APRES.png` ;
- Mesures PIL consignées ci-dessus (rayon tuile 55 px préservé, badge
  officiel 141×143).

## Non-touchés

Textes des slides (FR/EN), pagination, voile navy, CTA, `themes.xml`,
SplashScreen API, `postSplashScreenTheme`, durées système.
