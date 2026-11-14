# VITRINE VIDÉO — Spécification de design à appliquer
### Document de passation (handoff) — à donner tel quel à l'agent qui code l'application

> **But de ce document.** Il décrit *la peinture et les proportions* d'une refonte déjà validée
> (32 maquettes, 393 × 852 dp). Il ne demande **aucun changement de copie, de parcours ni de
> logique métier** : on applique cette peinture sur tous les écrans existants du dépôt.
> Les textes viennent des `strings_*.xml` du dépôt (FR = source, EN = parité). Ce document
> remplace uniquement l'apparence : couleurs, typographie, espacements, rayons, ombres,
> composants, états, hiérarchie visuelle.

---

## 0. Ordre d'application (à suivre dans cet ordre, sinon ça casse)

1. **Tokens** (section 3–5) → `Color.kt`, `Type.kt`, `Shape.kt`, `Dimens.kt`, `Elevation.kt`.
2. **Composants de base** (section 7) → `core-designsystem`.
3. **Gabarit d'écran** (section 2 : `Scaffold` + insets + CTA collant + tab bar).
4. **Écrans**, famille par famille (section 8 + table de correspondance section 11).
5. **États transverses** (section 10 : hors-ligne, quota, erreur, vide).
6. **Contrôles de robustesse** (section 12 : fontScale 1.3, 360 dp, rotation, EN).

Règle absolue : un écran n'est terminé que s'il passe les 6 contrôles de la section 12.

---

## 1. Intention (à garder en tête pour chaque pixel)

| Axe | Ce qu'on veut | Ce qu'on refuse |
|---|---|---|
| Registre | Pro, moderne, international, rassurant | Effet « projet lycéen », dégradés criards, ombres lourdes |
| Densité | Aérée : une idée par écran, un seul CTA orange | Murs de cartes, 2 CTA concurrents, tableaux denses |
| Couleur | Blanc + navy pour la structure, **orange réservé à l'action** | Orange en fond de bloc de texte, orange décoratif partout |
| Ton | Le marchand est guidé, jamais jugé | Jargon technique (« bitrate », « codec », « R4 » visible) |
| Confiance | Chaque état est **vrai** : aucun chiffre inventé, aucun faux bouton | Placeholders « lorem », notes fictives, étoiles décoratives |
| Marque | L'insigne orange + le mot « VITRINE VIDÉO » posés, sobres | Logo étiré, recoloré, entouré d'effets |

Identité intangible : **orange #F95C0F + blanc**, navy `#022358` comme encre. On ne change **jamais** ces trois valeurs.

---

## 2. Gabarit d'écran (mesures de référence)

Référence de dessin : **393 × 852 dp** (DPR 3 → 1179 × 2556 px). Toutes les valeurs sont en **dp**.

```
┌───────────────────────────────────────────┐
│ status bar            hauteur 46          │  contenu système, couleur selon fond
├───────────────────────────────────────────┤
│ header                hauteur 52          │  marge latérale 20 · titre / action 40×40
│ (retour 40×40 · titre H3 · 1 action max)  │
├───────────────────────────────────────────┤
│                                           │
│ CORPS  padding horizontal 20              │  scroll vertical, jamais de scroll horizontal
│        gutter vertical 12 à 16            │  premier bloc à 8 dp sous le header
│                                           │
├───────────────────────────────────────────┤
│ CTA collant           hauteur 56 (+ 46)   │  padding 12 / 20 / 26 (bas = safe area)
│ dégradé de fond vers la couleur du fond   │  fondu sur 26 dp pour ne pas couper le scroll
├───────────────────────────────────────────┤
│ tab bar               74 + 26 safe        │  4 entrées + action centrale flottante
└───────────────────────────────────────────┘
```

| Élément | Valeur |
|---|---|
| Marge latérale | **20 dp** (jamais moins ; marges internes de carte : 18 dp) |
| Largeur de contenu | 353 dp |
| Gouttière entre cartes | **12 dp** (grilles 2 colonnes), **10 dp** (listes serrées) |
| Hauteur CTA principal | **56 dp** |
| Hauteur CTA secondaire | **46 dp** |
| Safe area basse | 26 dp de padding additionnel sous le dernier élément |
| Échelle d'espacement | 2 · 4 · 6 · 8 · 10 · 12 · 14 · 16 · 18 · 20 · 24 · 28 · 32 |
| Rythme | tout multiple de 2 ; les blocs se suivent par 12 ou 16 |
| Cible tactile minimale | **48 × 48 dp** (même si le visuel fait 40) |

**Deux fonds seulement** : `background` clair `#F7F8FC` pour tout le parcours applicatif ; fond **sombre navy + halo orange** réservé aux 3 écrans d'émotion (ouverture, carrousel, bienvenue/crédits) et aux écrans caméra plein cadre.

---

## 3. Couleurs — tokens exacts

```kotlin
// Brand (intangibles)
val OrangeStore   = Color(0xFFF95C0F)   // action, accent, insigne
val OrangeHi      = Color(0xFFFF6E22)   // haut du dégradé de bouton
val OrangeDeep    = Color(0xFFD34905)   // texte orange sur fond clair (contraste AA)
val Navy          = Color(0xFF022358)   // encre, titres, fonds sombres
val NavySoft      = Color(0xFF23467F)   // texte secondaire sur fond clair

// Surfaces
val Bg            = Color(0xFFF7F8FC)   // fond applicatif
val Surface       = Color(0xFFFFFFFF)   // cartes, feuilles
val Line          = Color(0xFFE2E8F0)   // filet 1 dp, séparateurs
val Muted         = Color(0xFF6C7C99)   // texte tertiaire, méta

// Voiles (remplacent les aplats saturés)
val OrangeVoile   = Color(0xFFFFF1E8)   // badge/chip orange, bouton « doux »
val BleuVoile     = Color(0xFFE9F0FF)   // badge informatif

// États (sémantique stricte)
val VertSucces    = Color(0xFF0E9F6E)   // point de synchro, coche validée
val VertTexte     = Color(0xFF0B7A55)   // texte de badge succès
val AmbreAlerte   = Color(0xFFB26A00)   // avertissement, hors-ligne, erreur douce
val RougeBloquant = Color(0xFFB42318)   // uniquement erreur bloquante / consentement manquant
```

| Rôle | Couleur | Interdit |
|---|---|---|
| Fond d'écran | `Bg` | Dégradé sur un écran de formulaire |
| Encre | `Navy` | Gris `#333` : la couleur du texte est toujours navy ou muted |
| Action primaire | dégradé `OrangeHi → OrangeStore` (180°) | Deux boutons orange sur un écran |
| Action secondaire | `Surface` + filet `Line` | Bouton gris `#EEEEEE` |
| Lien / action tertiaire | `OrangeDeep` en texte, 46 dp de haut | Soulignement, texte orange < 13 px |
| Info | `BleuVoile` + `#1B4CA1` | Bleu saturé en fond plein |
| Succès | point `VertSucces` + halo 14 % | Vert en fond de carte entière |
| Alerte / offline | `AmbreAlerte` + `OrangeVoile` | Rouge pour un simple hors-ligne |

**Contraste** : texte ≥ 4,5:1 ; texte sur orange = **blanc uniquement** et taille ≥ 15 dp ; jamais d'orange pur sur blanc pour du texte < 13 dp (utiliser `OrangeDeep`).

---

## 4. Typographie

Deux familles, jamais plus :
- **Plus Jakarta Sans** (700/800) — titres, chiffres clés, labels de bouton, marque. Interlignage serré, interlettrage négatif = « moderne ».
- **Inter** (400/500/600) — texte courant, méta, champs.

```kotlin
H1        = 29 sp / 33 / 800 / Jakarta / ls -0.035em   // titre d'écran émotionnel
H2        = 21 sp / 25.6 / 800 / Jakarta / ls -0.03em  // titre de section forte
H3        = 16.5 sp / 21.5 / 700 / Jakarta / ls -0.02em// titre de carte / de section
Body      = 15 sp / 21.75 / 400 / Inter                // texte courant
BodyStrong= 15 sp / 21.75 / 600 / Inter                // nom de fichier, titre de ligne
Sub       = 14.5 sp / 21.75 / 400 / Inter / Muted      // sous-titre, description
Tiny      = 12.5 sp / 18 / 400 / Inter / Muted         // méta, micro-copie, mentions
Label     = 11 sp / 700 / Inter / UPPERCASE / ls 0.09em / Muted  // « EXPORTS RESTANTS »
Num       = 40–44 sp / 800 / Jakarta / ls -0.045em     // chiffre héros (crédits)
Button    = 16 sp / 700 / Jakarta / ls -0.01em
Chip      = 12.8 sp / 600 / Inter
Badge     = 11 sp / 700 / Inter / ls 0.02em
```

Règles :
- **Un seul H1 par écran**, et seulement sur les écrans d'émotion (ouverture, carrousel, bienvenue, export fini) ou à l'entrée d'une étape clé.
- Les écrans de travail utilisent **H2/H3** : la hiérarchie se fait par l'espace et la couleur, pas par la taille.
- Jamais de texte en capitales au-delà d'un `Label` (11 sp, tracking positif).
- Titres de carte : **2 lignes max** puis ellipsis ; méta : 1 ligne + ellipsis.
- Aucune police système décorative, aucun italique, aucun soulignement.

---

## 5. Rayons, ombres, élévation

| Token | Valeur | Usage |
|---|---|---|
| `rPill` | 999 dp | boutons, chips, badges, onglet actif |
| `rSheet` | 30 dp (coins hauts) | feuille modale, bloc blanc qui chevauche un fond coloré |
| `rHero` | 26 dp | carte héro (bloc navy des crédits) |
| `rCard` | 22 dp | carte standard, ligne de liste |
| `rTile` | 18 dp | tuile, vignette, champ de formulaire |
| `rIcon` | 14 dp | bouton icône 40 dp, vignette 40–48 dp |
| `shSm` | `0 1 2 rgba(2,35,88,.05)` + `0 2 6 rgba(2,35,88,.04)` | carte au repos |
| `shMd` | `0 4 14 rgba(2,35,88,.07)` + `0 1 3 rgba(2,35,88,.04)` | carte héro, élément soulevé |
| `shLg` | `0 22 48 -18 rgba(2,35,88,.28)` + `0 6 16 -8 rgba(2,35,88,.12)` | feuille, action centrale de tab bar |
| `shOrange` | `0 12 26 -10 rgba(249,92,15,.55)` | **réservé au CTA orange** |

Une seule ombre par élément. Pas d'ombre sur les éléments à l'intérieur d'une carte. Les blocs sombres n'ont pas d'ombre : ils ont un **halo** (cercle flouté 46 dp, `rgba(249,92,15,.30)` en haut à droite, `rgba(35,70,127,.55)` en bas à gauche).

---

## 6. Iconographie

- SVG, **grille 24**, contour **1,75 dp**, bouts et jointures arrondis, jamais de remplissage sauf glyphes pleins (play, point de synchro).
- Taille : **20 dp** dans les boutons, **22 dp** en tab bar, **24 dp** en en-tête, **28 dp** dans une tuile d'état.
- Une icône = un sens, réutilisé partout : `camera` = filmer, `film` = gabarit, `clock` = durée, `cloud` = synchro, `wifioff` = hors-ligne, `gift` = crédits/parrainage, `shield` = consentement/légal, `share` = partage, `download` = enregistrer, `refresh` = refaire, `target` = objectif, `wave` = audio.
- Logos tiers (Google, WhatsApp) : **toujours dans leur couleur officielle**, jamais recolorés, dans une pastille blanche de 44 dp.
- Aucune émoticône, aucune icône « emoji-style ».

---

## 7. Composants (anatomie chiffrée)

### 7.1 Bouton primaire
Pilule 56 dp, largeur pleine (marge 20), dégradé `OrangeHi → OrangeStore` (180°), texte blanc 16/700, icône 19 dp à gauche, gap 9, padding horizontal 24, `shOrange`. Appui : échelle 0,98 + ombre réduite de 40 %. Désactivé : `#EDEFF5` + texte `#9AA7BE`, **sans ombre**. Chargement : spinner 18 dp blanc à la place de l'icône, libellé conservé.

### 7.2 Bouton secondaire
Pilule 46 dp, `Surface`, filet 1 dp `Line`, texte `Navy` 14.5/600, icône 18 optionnelle. Variante « douce » : fond `OrangeVoile`, texte `OrangeDeep`, sans filet ni ombre.

### 7.3 Bouton icône
40 × 40 dp, rayon 14, `Surface` + `shSm`, glyphe 20 `Navy`. Variantes : `veil` (fond `OrangeVoile`, glyphe orange), `glass` (fond `rgba(255,255,255,.18)` + flou 12, glyphe blanc — sur fond coloré uniquement).

### 7.4 Carte
`Surface`, rayon 22, padding 18, `shSm`. Carte héro : rayon 26, padding 20, `shMd`. **Jamais** de bordure sur une carte qui a une ombre (choisir l'un ou l'autre : carte plate → filet ; carte soulevée → ombre).

### 7.5 Carte héro sombre (crédits / solde)
Fond `Navy` + 2 halos, rayon 26, padding 20.
Ligne 1 : `Label` blanc 60 % (« EXPORTS RESTANTS ») + pastille de statut à droite.
Ligne 2 : `Num` 40 blanc + `Body` 13 blanc 70 % (« offerts »).
Ligne 3 : rangée de badges sur fond `rgba(255,255,255,.10)` — point vert `Synchrosé`, badge blanc 18 % (« Essai gratuit »), lien « Formules › » blanc 70 %.
Décor : anneau orange 56 dp (2 cercles concentriques, opacité 22 % et 100 %) contenant une tuile 34 dp avec l'icône `video`.

### 7.6 Badge / Chip / Point
- Badge : hauteur 22, padding 9, rayon pill, 11/700. Orange → fond `OrangeVoile` / texte `OrangeDeep` ; succès → `rgba(14,159,110,.12)` / `#0B7A55` ; info → `BleuVoile` / `#1B4CA1` ; sur sombre → blanc 18 % / blanc.
- Chip de filtre : hauteur 32, padding 13, 12.8/600, filet `Line`. Actif : fond `Navy`, texte blanc, pas de filet.
- Point de synchro : 7 dp `VertSucces` + halo `0 0 0 3 rgba(14,159,110,.14)`.

### 7.7 Ligne de liste
Hauteur min 72, padding 14, rayon 22, `Surface`, `shSm`. Vignette 48 dp rayon 14 (ou tuile d'icône 48 avec fond voilé). Bloc texte : titre 15/700 (1 ligne), méta 12.5 muted (1 ligne), éventuelle barre de progression 4 dp rayon pill. À droite : action texte 13/700 `OrangeDeep` ou chevron 20. Séparateur entre lignes : filet 1 dp `Line` **inséré à 20 dp du bord gauche**, et seulement dans les groupes sans ombre.

### 7.8 Barre de progression / stepper
Hauteur 4, rayon pill, piste `#EDEFF5`, remplissage `OrangeStore` (ou `VertSucces` si terminé). Pour les 4 scènes : **4 segments séparés de 4 dp**, l'actif en orange, les validés en navy, les suivants en piste. Au-dessus : `Label` + « 2 / 4 » en `Tiny`.

### 7.9 Champ de formulaire
Hauteur 56, rayon 18, `Surface`, filet `Line` (focus : filet 2 dp `OrangeStore` + halo `OrangeVoile`). Label au-dessus en `Tiny` 600 navy, jamais en placeholder seul. Aide sous le champ en `Tiny`. Erreur : filet `AmbreAlerte`, texte `AmbreAlerte`, icône `info` 16. Compteur de caractères aligné à droite (« 124 / 280 »), qui passe en `AmbreAlerte` à 90 % de la limite. Zone multiligne : min 96 dp, croît avec le texte.

### 7.10 Feuille (bottom sheet)
Coins hauts 30, poignée 40 × 4 `Line` centrée à 10 dp du bord, padding 20, `shLg`. Titre H3 + sous-titre `Sub`. Actions empilées, CTA primaire en dernier.

### 7.11 Anneau de progression
Épaisseur 6, piste `#EDEFF5`, arc dégradé orange, 2 cercles de halo. Centre : `Num` 84 sp pour un compte à rebours, ou pourcentage 22/800. Toujours accompagné d'un libellé en clair sous l'anneau (« L'export tourne, appareil verrouillé… »).

### 7.12 Tuile de prise (vidéo)
Format 16:9, rayon 18, fond navy 8 %. Badge durée en bas à droite : pilule noire 60 % + texte blanc 11/700 (« 0:30 »). États : **vide** (contour pointillé 1 dp `Line` + icône `plus` + « Scène 2 »), **validée** (vignette + coche verte 20 dans une pastille blanche), **à refaire** (vignette voilée + badge ambre « À refaire »).

### 7.13 Tab bar
Hauteur 74 + 26 safe, fond `Surface`, filet supérieur 1 dp `Line`, 4 entrées à libellé 10.5/600 (actif : `Navy` + glyphe plein ; inactif : `Muted`). **Action centrale** : cercle 56 dp orange, icône `plus` blanche 26, `shLg`, décalé de −18 dp au-dessus de la barre, libellé « Créer » sous le cercle.

### 7.14 Bandeau hors-ligne
Une seule forme, réutilisée partout : carte rayon 18, fond `OrangeVoile`, filet 1 dp `rgba(178,106,0,.20)`, icône `wifioff` 20 `AmbreAlerte`, titre 14/700, texte 12.5 `AmbreAlerte`, action « Réessayer » en texte. Placé **sous le header**, jamais en toast éphémère.

### 7.15 Overlay caméra
Cadre 2 / 4 superposé au retour vidéo (coins 18, trait blanc 2 dp 70 %), grille des tiers à 30 %, consigne en bas sur bandeau `rgba(2,35,88,.55)` + flou, texte blanc 15/600 sur 2 lignes max, bouton d'arrêt carré arrondi 64 dp rouge `#B42318` (jamais orange : l'orange reste l'action de progression).

---

## 8. Motifs d'écran (patterns) — 10 familles couvrant tout le parcours

| # | Famille | Écrans concernés | Signature visuelle |
|---|---|---|---|
| A | **Onboarding émotionnel** (fond navy) | ouverture, carrousel ×3, bienvenue/crédits | Fond navy + halo, marque en haut, 1 idée, CTA orange bas |
| B | **Choix simple** | langue, secteur, code parrain | 1 question en H2, 4 à 6 cartes-options pleine largeur, sélection = filet 2 dp orange + coche |
| C | **Catalogue / gabarits** | catalogue, tuiles de gabarits | 1 héro 16:9 en vedette + grille 2 colonnes, badge durée sur chaque tuile |
| D | **Détail d'un gabarit** | gabarit sélectionné | Héro 16:9, titre H2, 4 lignes de scènes numérotées, CTA « Choisir ce gabarit » |
| E | **Formulaire multi-étapes** | brief 1→8, formulaires | Header avec « Étape 3 sur 8 » + barre 4 dp, 1 question, aide sous le champ, CTA unique, brouillon conservé |
| F | **Vérification / préparation** | ReadyCheck, contrôle avant tournage, vérification | Liste de tests à cocher avec états (ok / à corriger), score en haut, CTA qui se débloque |
| G | **Caméra** | guide, permission, compte à rebours, REC, arrêt, refaire, scène 2 | Plein cadre sombre, overlay de consigne, anneau/chrono, bouton d'arrêt rouge |
| H | **Production** | aperçu du montage, montage en cours, export prêt, export échoué | Bloc navy translucide + anneau, timeline 4 segments, résultat en feuille blanche 30 |
| I | **Partage** | feuille de partage, partage réussi | Feuille blanche, gros bouton WhatsApp officiel, 3 alternatives en pilules |
| J | **Compte** | dashboard, mes vidéos, formules, réglages, parrainage, aide/contact, conditions | Header avatar + 2 boutons icône, cartes héro, listes, tab bar |

---

## 9. Les 6 écrans signature (à reproduire au plus près)

### 9.1 Ouverture (splash)
Marque centrée : insigne dans une tuile blanche rayon 26 (72 dp, `shMd`) + « VITRINE VIDÉO » en 15,5/800 Jakarta (`VIDÉO` en orange). Fond navy avec 2 halos. Barre de chargement discrète 3 dp en bas (piste blanc 14 %, remplissage orange). Aucun texte marketing : c'est un temps de marque de 1,2 s max.

### 9.2 Carrousel (3 slides)
Photo plein cadre (voile navy 45 % en bas), marque en haut, en bas : 3 points de pagination (actif = pilule 18 dp orange, inactifs = 6 dp blanc 45 %), H1 29 blanc (`Carrousel`), `Sub` blanc 80 % sur 2 lignes, puis `CTA orange` = « Continuer » + lien texte « Passer ». **Une idée par slide**, dans l'ordre : ce que l'app fait → combien de temps ça prend → combien ça rapporte. Le 3ᵉ écran porte le CTA d'entrée.

### 9.3 Tableau de bord (le plus important)
Ordre vertical, sans exception :
1. **Header 52** : avatar rond 40 dp + « Bonjour, » (`Tiny`) / prénom (`BodyStrong`) ; à droite 2 boutons icône 40 (notifications avec point orange, réglages).
2. **Carte héro navy 26** : `Label` « EXPORTS RESTANTS », `Num` **3** + « offerts », anneau orange décoratif à droite, rangée de badges (`Synchrosé` vert, `Essai gratuit`, `Formules ›`). La donnée qui décide de tout est en haut et en très gros.
3. **CTA orange 56** pleine largeur « Créer une vidéo » + micro-copie centrée 12,5 muted dessous : « 4 scènes · 30 s · montage automatique ». Le CTA appartient visuellement à la carte héro (8 dp sous elle) : c'est un seul bloc.
4. **« Reprendre »** + lien « Tout voir » (13/700 orange) → ligne de brouillon avec progression « scène 2 sur 4 » (barre 4 dp) ; ligne de parrainage avec compteur « 2 / 5 » et code en `OrangeDeep`.
5. **« Derniers exports »** + lien « Historique » → 2 tuiles 16:9 côte à côte (gouttière 12), badge durée, titre 13,5/700, méta « Hier · 1080p ».
6. **Tab bar** 4 entrées + action centrale « Créer ».
Interdits sur cet écran : plus de 3 sections, un tableau de chiffres, un carrousel automatique, un second bouton orange.

### 9.4 Bienvenue / crédits offerts
Fond navy + halo orange. En haut : marque à gauche + badge « Compte créé » à droite. Tuile cadeau 96 dp (orange, rayon 30, double anneau). H1 « Félicitations, {prénom} ! », `Sub` blanc 70 % : « 3 exports offerts pour tes 3 premières vidéos ». Puis une **carte de solde** (`rgba(255,255,255,.06)` rayon 26) titrée « Ton solde de bienvenue » + badge `Confirmé`, contenant **3 tuiles égales** (rayon 18, filet blanc 8 %) : icône `video` 20 orange, libellé « Vidéo 1 / 2 / 3 ». Sous la carte, une ligne de 3 réassurances avec icônes (1080p · sans filigrane · sans limite de temps). En bas : CTA orange « Créer ma première vidéo », lien « Plus tard », mention « Aucune carte bancaire demandée ». Le chiffre 3 est matérialisé **physiquement en 3 objets**, pas seulement écrit.

### 9.5 Export prêt
Haut de l'écran en **aplat orange** (dégradé) sur 52 % de la hauteur, coins bas arrondis 0 ; bouton retour `glass` 40 ; badge pill blanc 18 % « Export terminé » ; tuile blanche 96 rayon 30 avec coche orange 44 ; H1 blanc ; sous-titre blanc 80 % « 30 secondes · prête à publier ». Puis une **feuille blanche** rayon 30 qui chevauche l'orange : ligne fichier (miniature 56, nom `export-0.mp4`, méta « 1080 × 1920 · 8,4 Mo · sans filigrane », badge `HD`), deux boutons côte à côte (`Enregistrer` secondaire + `Relire` doux), titres de section « Partager maintenant » + « Autres apps », tuiles WhatsApp / Autres, note « 2 exports restants ce mois » avec icône `info`, CTA final « Partager sur WhatsApp », lien « Créer une autre vidéo ».

### 9.6 **Écran manquant à créer : Préparation caméra (le « test » d'entrée)**
C'est l'écran que le dépôt appelle `11_verification` / `ready_p1` et qui apparaît **quand on entre dans la caméra** pour dire au marchand quoi faire. À dessiner dans ce langage :

- Fond sombre navy (famille G), header avec retour `glass` + titre « Avant de filmer » + badge « 4 vérifications ».
- Bloc héro : anneau de score (section 7.11) + « Prêt à 3 / 4 ».
- **4 cartes de test** (rayon 18, fond `rgba(255,255,255,.06)`, filet blanc 8 %), une par vérification, chacune avec icône 28, titre 15/700 blanc, consigne 12,5 blanc 70 % (ce qu'il faut faire), et état à droite :
  1. **Lumière** — « Place-toi face à la fenêtre » → état `Vert` « Bonne » ou `Ambre` « Trop sombre » + bouton « Mesurer ».
  2. **Son** — « Parle normalement, à 50 cm » → VU-mètre 5 segments qui s'allument (vert si signal).
  3. **Stabilité** — « Pose le téléphone ou tiens-le à deux mains » → état stable / bouge.
  4. **Espace de stockage** — « 1,2 Go nécessaires » → « Il reste 4,8 Go » + jauge.
- CTA orange « Commencer le tournage », désactivé tant que 3 blocs sur 4 ne sont pas verts, avec le motif écrit en clair (« Il manque : la lumière »).
- Lien texte « Filmer quand même » (jamais caché, jamais bloquant agressif) + « Diagnostic caméra » en `Tiny` pour les cas matériels.
- Retour haptique léger à chaque test validé ; aucune animation qui retarde l'accès au bouton.

### 9.7 **Écran manquant à créer : Aide & contact**
Aujourd'hui le parcours n'offre aucun endroit où joindre l'équipe. À créer dans la famille J :

- Header retour + titre « Aide ».
- **Carte de contact prioritaire** en haut (rayon 22, fond `OrangeVoile`) : « On te répond en moins de 2 h », 3 canaux en lignes pleines hauteur 56 avec icône dans une pastille :
  - **WhatsApp** (logo officiel dans pastille blanche 44) — « Le plus rapide », chevron.
  - **Appeler** (icône téléphone) — numéro en `BodyStrong`, horaires en `Tiny`.
  - **E-mail** (icône enveloppe) — adresse en `BodyStrong`.
- **Carte « Signaler un problème »** : 3 chips de motif (Export qui échoue · Vidéo floue · Paiement) qui pré-remplissent le message, puis champ multiligne + bouton secondaire « Joindre une capture » + CTA « Envoyer ».
- **FAQ en accordéon** : 5 questions max, lignes 72 dp, chevron 90°, réponse en `Sub`, jamais plus de 3 lignes ouvertes à l'écran.
- **Bloc léger en bas** : version de l'app (`Tiny`), « Conditions » et « Confidentialité » en liens, état de la synchro.
- Ajouter l'entrée **Aide** dans Réglages et un accès depuis le bandeau d'erreur d'export (« Besoin d'aide ? »).
- Aucun formulaire de contact qui ne parte nulle part : l'agent doit brancher les canaux réels ou afficher un état honnête.

---

## 10. États transverses (à traiter partout, pas seulement sur un écran)

| État | Traitement |
|---|---|
| **Hors-ligne** | Bandeau `7.14` sous le header + point de synchro qui devient ambre + les actions qui exigent le réseau sont **désactivées avec explication**, jamais masquées. Aucune pop-up bloquante. |
| **Synchro en cours** | Point vert pulsant + « Synchrosé » (jamais une animation infinie sans texte). |
| **Chargement** | Squelette de la même forme que le contenu (carte grise `#EDEFF5`, rayon identique), pas de spinner plein écran sauf action bloquante < 2 s. |
| **Vide** | Carte rayon 22, icône 28 dans une tuile `OrangeVoile`, titre H3, une phrase, un CTA. Jamais d'illustration « cartoon ». |
| **Erreur douce** | Carte `OrangeVoile` + icône `info`, phrase en clair + ce qui a été préservé (« Tes crédits ont été rendus »), action « Réessayer ». |
| **Quota épuisé** | Écran dédié, jamais une alerte : solde à 0 en `Num`, 3 formules en cartes (Pass 24 h · Pro 30 jours · Boutique), CTA sur la formule recommandée + « Recharger plus tard ». |
| **Succès** | Vérification immédiate : coche dans une pastille verte ou badge, + la prochaine action proposée. Pas de confettis. |
| **Permission refusée** (caméra, notifications) | Explication en français simple, le chemin exact dans les réglages, un bouton « Ouvrir les réglages », et une alternative quand elle existe. |

---

## 11. Table de correspondance : captures du dépôt → motif → composant

C'est la liste de contrôle. **Chaque ligne doit être rendue avec la peinture ci-dessus.**

| Dossier `D42_32/visual-review/captures/` | Fichiers | Motif | Composants clés |
|---|---|---|---|
| `01_accueil` | `splash_fr/en`, `carrousel_1_fr/en`, `carrousel_2_fr`, `carrousel_3_fr` | A | §9.1, §9.2, pagination, CTA |
| `02_langues` | `langue_fr`, `langue_en`, `langue_en_e2e` | B | cartes-options, coche, CTA |
| `03_authentification` | `auth_fr`, `auth_en`, `auth_offline` | B | carte Google unique, 3 bénéfices, bandeau hors-ligne |
| `04_parrainage` | `etape_code_fr`, `dashboard_parrainage_fr/en` | B + J | champ code, badges, compteur 2/5 |
| `05_credits` | `credits_bienvenue_fr`, `paywall_fr`, `paywall_bas_fr`, `paywall_suite_fr`, `paywall_en` | A + J | §9.4, 3 tuiles de crédits, 3 cartes de formules |
| `06_secteurs` | `secteurs_fr/en`, `secteurs_bas_fr` | B | 6 cartes-options avec icône, sélection orange |
| `07_catalogue` | `catalogue_haut_fr`, `catalogue_en`, `catalogue_scroll_fr`, `catalogue_p1`, `catalogue_offline` | C | héro 16:9, grille 2 col., badge durée, bandeau offline |
| `08_gabarits` | `vignette_p1`, `vignettes_scroll_fr` | C + D | tuiles 16:9, badge scènes |
| `09_brief` | `brief_etape1_fr`, `brief_etape8_fr`, `brief_vide_fr`, `brief_rempli_fr`, `brief_final_fr`, `brief_drafts_reprise`, `brief_drafts_partiel`, `brief_bas_p1`, `brief_p1` | E | header d'étape, barre 4 dp, champ 56, compteur, récap |
| `10_formulaires` | `whatsapp_clavier_fr/en` | E | champ multiligne, clavier, CTA collé au clavier |
| `11_verification` | `ready_p1`, `verification_fr`, `verification_bas_fr` | **F** | **§9.6 : liste de tests + score + CTA conditionnel** |
| `12_camera` | `camera_p1`, `camera_ecran_p1`, `camera_guide_fr`, `camera_permission_camerap`, `camera_preview_en` | G | overlay, consigne, permission refusée |
| `13_prises` | `countdown_a/b_en`, `rec_en`, `arret_en`, `avant_en`, `arriere_en`, `refaire_en`, `refaire_camerap`, `scene2_en`, `prise_rec_p1`, `prise_faite_p1`, `prise2_rec_p1` | G | anneau, chrono, bouton rouge, badge REC, tuiles de prise |
| `16_export` | `dump_e7_apercu.xml`, `dump_export_termine.xml`, `dump_partage_feuille.xml`, `export-tire-candidat.mp4` | H + I | §9.5, feuille 30, anneau de progression |
| `17_historique` | `dashboard_fr`, `dashboard_bas_fr`, `dashboard_suite_fr`, `dashboard_en` | J | **§9.3 intégral** |
| `18_partage` | `dump_partage_feuille.xml` | I | feuille de partage, WhatsApp officiel |
| `19_profil` | `profil_reglages_fr/en` | J | header avatar, groupes de lignes, tab bar |
| `20_hors_connexion` | `offline_bienvenue`, `offline_carrousel`, `offline_langue`, `offline_redemarrage`, `offline_retour_reseau` | A + §10 | bandeau hors-ligne, états réseau |
| `21_conditions` | `font130_*`, `petit_ecran_*`, `rot90_*` | — | **contrôles §12** |

**À créer / compléter car absent du parcours actuel** : l'écran **Aide & contact** (§9.7) et son entrée dans Réglages ; la variante **Diagnostic caméra** accessible depuis §9.6.

---

## 12. Robustesse — 6 contrôles obligatoires avant de dire « terminé »

1. **fontScale 1,3** (captures `font130_*`) : aucun texte tronqué, aucun bouton qui se déforme ; les titres passent sur 2 lignes, les libellés de CTA restent sur 1 ligne.
2. **Petit écran 360 × 640** (`petit_ecran_*`) : le CTA reste visible, le contenu scrolle, jamais de chevauchement.
3. **Rotation** (`rot90_*`) : si l'écran ne gère pas le paysage, il se verrouille en portrait — mais la caméra et la lecture vidéo passent en paysage sans casser l'overlay.
4. **EN** : tous les libellés tiennent (l'anglais est plus court mais les titres de section diffèrent) — tester les 4 écrans les plus denses (dashboard, brief 8/8, export, réglages).
5. **Contrastes** : chaque texte mesuré ≥ 4,5:1 ; chaque icône ≥ 3:1.
6. **Cibles tactiles** ≥ 48 dp, y compris les chevrons et les liens texte (padding invisible autorisé).

---

## 13. Interdits (non négociables)

- ❌ Changer un texte, un libellé, une traduction ou un parcours : la copie vient du dépôt.
- ❌ Inventer une donnée (solde, nombre d'exports, note, avis) ou afficher un bouton qui ne fait rien.
- ❌ Un deuxième CTA orange sur le même écran.
- ❌ Une ombre colorée en dehors du CTA orange.
- ❌ Un dégradé en fond d'écran de formulaire ou de liste.
- ❌ Plus de 2 familles typographiques, plus de 4 tailles de titre.
- ❌ Des emojis, des illustrations « cartoon », des icônes de remplissage.
- ❌ Du rouge pour un simple hors-ligne ; de l'orange pour une erreur.
- ❌ Modifier l'insigne ou les couleurs de marque (#F95C0F / #022358 / blanc).
- ❌ Une pop-up bloquante là où un bandeau suffit.

---

## 14. Bloc de prompt prêt à coller pour l'agent

```
Applique la spécification « VITRINE VIDÉO — Spécification de design » (document ci-joint)
à l'intégralité de l'application, sans modifier le parcours, les textes ni la logique métier.

Règles d'exécution :
1. Commence par les tokens : Color.kt (Orange #F95C0F, OrangeHi #FF6E22, OrangeDeep #D34905,
   Navy #022358, NavySoft #23467F, Bg #F7F8FC, Line #E2E8F0, Muted #6C7C99,
   OrangeVoile #FFF1E8, BleuVoile #E9F0FF, VertSucces #0E9F6E, AmbreAlerte #B26A00),
   Type.kt (Plus Jakarta Sans 700/800 pour titres/chiffres/boutons, Inter pour le texte,
   échelle 29/21/16.5/15/14.5/12.5/11 sp), Shape.kt (pill 999, sheet 30, hero 26, card 22,
   tile 18, icon 14), Dimens.kt (marge 20, gouttière 12, CTA 56/46, status 46, header 52,
   tab bar 74+26, cible 48), elevation (shSm/shMd/shLg + ombre orange réservée au CTA).
2. Refais d'abord les composants de base : bouton primaire/secondaire/doux, bouton icône
   (clair, voilé, verre), carte, carte héro sombre, badge/chip/point, ligne de liste,
   barre de progression segmentée, champ de formulaire, feuille, anneau de progression,
   tuile de prise, tab bar à action centrale flottante, bandeau hors-ligne, overlay caméra.
3. Applique ensuite écran par écran en suivant la table de correspondance de la section 11
   (dossier par dossier de docs/checkpoints/D42_32/visual-review/captures) : chaque capture
   listée doit exister dans ce langage visuel.
4. Reproduis au plus près les 6 écrans signature de la section 9 — en particulier le
   tableau de bord (header avatar, carte héro navy avec le grand chiffre de crédits,
   CTA orange collé dessous, « Reprendre » avec progression, « Derniers exports » en 2 tuiles,
   tab bar à action centrale).
5. Crée les deux écrans manquants décrits en 9.6 (Préparation caméra : 4 tests lumière / son /
   stabilité / stockage, score, CTA conditionnel, « Filmer quand même ») et 9.7 (Aide & contact :
   WhatsApp, appel, e-mail, signalement, FAQ, version) et branche-les sur de vrais canaux.
6. Implémente les états transverses de la section 10 (hors-ligne, synchro, chargement, vide,
   erreur douce, quota épuisé, permission refusée) partout où ils peuvent survenir.
7. Termine par les 6 contrôles de robustesse de la section 12 (fontScale 1,3 / 360×640 /
   rotation / EN / contrastes / cibles 48) et fournis une capture par contrôle.
8. Contraintes dures : un seul CTA orange par écran, une seule ombre par élément,
   aucun texte modifié, aucune donnée inventée, insigne et couleurs de marque intacts.
Livrable attendu : l'application repeinte, écran par écran, avec la preuve que les
écrans de la section 11 sont tous couverts.
```

---

*Document de passation — VITRINE VIDÉO · refonte UX/UI · 32 maquettes de référence (393 × 852 dp, DPR 3).*
