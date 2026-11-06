# D42.14 — Les 120 combinaisons et les 4 langues

## 1. Matrice de données (30 gabarits × 4 langues)

Fichier : `artefacts/matrice_120.csv` (120 lignes vérifiables, régénérable par
`python3 tools/e2e/matrix_120.py`).

| Statut | Nombre |
|---|---|
| `OK_STATIQUE` | **112** |
| `RISQUE_TYPO` (largeur estimée > 20 em) | **8** |
| Traduction manquante | **0** |
| Violation *kinsoku shori* (japonais) | **0** |

La matrice est **`PASS_STATIC`** : elle vérifie la donnée (traduction présente, variables
`{…}` identiques entre langues, ponctuation japonaise valide, largeur estimée),
**pas l'image rendue**. Aucun des 120 rendus vidéo n'a été relancé — conformément à la
consigne « ne pas refaire les 120 rendus sans justification ».

## 2. Les 8 combinaisons qui ne sont pas dans les 112

| # | Gabarit | Secteur | Langue | Chaîne en cause | Largeur estimée |
|---|---|---|---|---|---|
| 1 | T2 | Bâtiment & Travaux | en | « Here is the site at the beginning and at the end » | 22,1 em |
| 2 | T2 | Immobilier & Auto | fr | « Voici le bien avant et après sa préparation » | 22,3 em |
| 3 | T2 | Immobilier & Auto | en | « Here is the property before and after its preparation » | 25,6 em |
| 4 | T2 | Immobilier & Auto | es | « Aquí el inmueble antes y después de su preparación » | 25,9 em |
| 5 | T2 | Restauration & Maquis | es | « De los ingredientes al plato terminado » | 20,1 em |
| 6 | T2 | Boutique & Petit Commerce | fr | « Regardez le produit avant et après sa présentation » | 26,2 em |
| 7 | T2 | Boutique & Petit Commerce | en | « See the product before and after its presentation » | 25,6 em |
| 8 | T2 | Boutique & Petit Commerce | es | « Mira el producto antes y después de su presentación » | 26,4 em |

**Lecture** : un seul gabarit sur 30 (T2 « Avant / Après »), aucune ligne japonaise,
et **le français n'est pas la langue la plus longue** — l'espagnol (26,4 em) et l'anglais
(25,6 em) dépassent le français (26,2 em pour le pire cas français). Ce sont des
**risques de débordement estimés**, pas des échecs constatés.

**Action qui fermerait ces 8 lignes** : un rendu ciblé de T2 en fr/en/es (**3 rendus**, pas 120).
Non exécutée faute d'accès aux runners (voir `01_RELEASE_TESTS.md` §3).

## 3. Les 4 langues réellement exécutées sur l'appareil

Source : jobs `android-e2e-langues` (en, es, ja) + P0/P1 (fr), run **42228009767** — **4 jobs SUCCESS**.
Chaque langue est **choisie dans l'application**, puis chaque écran est vérifié **dans
cette langue** ; les libellés attendus sont lus dans `res/values-<langue>/strings_*.xml`
(aucune valeur inventée).

| Contrôle | fr | en | es | ja |
|---|---|---|---|---|
| Écran de langue affiché | ✅ | ✅ | ✅ | ✅ |
| Carte de langue actionnée **et appliquée** | ✅ | ✅ | ✅ | ✅ |
| Bouton Google localisé | `Continuer avec Google` ✅ | `Continue with Google` ✅ | `Continuar con Google` ✅ | `Googleで続ける` ✅ |
| Carrousel 1 | ✅ | `Shoot. Sell. Done.` ✅ | `Filma. Vende. Listo.` ✅ | `撮って、売る。それだけ。` ✅ |
| Carrousel 2 | ✅ | `Film your products, we guide you` ✅ | `Filma tus productos, te guiamos` ✅ | `商品を撮るだけ、あとはご案内します` ✅ |
| Carrousel 3 | ✅ | `A video ready to post in 30 seconds` ✅ | `Un vídeo listo para publicar en 30 segundos` ✅ | `30秒で公開できる動画に` ✅ |
| Écran d'activité | ✅ | `Your main business` ✅ | `Tu actividad principal` ✅ | `あなたの業種` ✅ |
| Étape parrainage | ✅ | ✅ | ✅ | ✅ |
| Catalogue | ✅ | `Pick a video template` ✅ | `Elige una plantilla de vídeo` ✅ | `動画テンプレートを選択` ✅ |
| Crash | aucun | aucun | aucun | aucun |

**11 contrôles PASS par langue × 3 langues + le parcours français = 4 langues prouvées.**
Le run `42223776656` avait échoué sur le catalogue en anglais ; le run `42228009767`
passe les trois langues (les 3 jobs sont `success`).

### Ce que cela prouve / ne prouve pas

- **Prouvé** : après sélection, l'application affiche réellement chaque écran dans la langue
  choisie, **japonais compris** (glyphes rendus, pas de tofu, aucun débordement visible
  sur les captures conservées).
- **Non prouvé** : les 120 rendus vidéo (matrice statique seulement) et le comportement
  des textes T2 dans la vidéo finale.

## 4. Les 3 illustrations (captures distinctes)

| Fichier (D42.13) | Contenu | Empreinte |
|---|---|---|
| `illu_carousel_1` | commerçante au marché, téléphone à la main, paniers, flacons | distincte |
| `illu_carousel_2` | main filmant un pot sur une table, trépied, chiffon vert | distincte |
| `illu_carousel_3` | téléphone montrant une vidéo prête, étoiles, icônes sociales | distincte |

Trois dessins **originaux**, trois écrans du carrousel, trois slogans différents —
aucune réutilisation d'une même image sous trois cadrages.

## Correction des 8 `RISQUE_TYPO` (D42.14, ordre du fondateur) — 120/120

### Confirmation du défaut (avant correction)

Les 8 drapeaux portaient tous sur le **texte d'accroche de la scène 1 du gabarit T2**
(« avant/après »). Comportement réel du moteur (réplication exacte des fonctions pures
`OverlayTextLayout`, testées unitairement dans le dépôt ; texte espacé = **un seul bloc**,
donc retaille pour tenir sur une ligne) :

| Combinaison | Chaîne | Taille rendue |
|---|---|---|
| batiment_travaux T2 en | « Here is the site at the start and at the end. » | 40 px = **2,1 %** de la hauteur |
| immo_auto T2 fr | « Voici le bien avant et après sa préparation. » | 41 px = **2,1 %** |
| immo_auto T2 en | « Here is the property before and after preparation. » | 36 px = **1,9 %** |
| immo_auto T2 es | « Aquí el inmueble antes y después de su preparación. » | 36 px = **1,9 %** |
| restaurants_maquis T2 es | « De los ingredientes al plato terminado. » | 47 px = **2,4 %** |
| shops_small_business T2 fr | « Regardez le produit avant et après sa présentation. » | 36 px = **1,9 %** |
| shops_small_business T2 en | « See the product before and after its presentation. » | 36 px = **1,9 %** |
| shops_small_business T2 es | « Mira el producto antes y después de su presentación. » | 35 px = **1,8 %** |

**Défaut confirmé : taille de police 1,8–2,4 % de la hauteur de sortie**, soit moins de la
moitié du plancher de lisibilité du projet (`FRACTION_MIN_LISIBLE = 5 %`), et ~3× plus petit
que les équivalents japonais (segmentés sans espaces → taille de base 105 px = 5,5 %).
Aucun débordement, aucune coupure, aucun caractère perdu : le défaut est la **lisibilité**,
pas l'intégrité.

### Correction (chaînes raccourcies, sens conservé, aucun sélecteur/variable touché)

| Combinaison | Nouvelle chaîne | Nouvelle taille | Gain |
|---|---|---|---|
| batiment_travaux T2 en | « The site, before and after. » | 67 px (3,5 %) | ×1,68 |
| immo_auto T2 fr | « Le bien, avant et après. » | 76 px (4,0 %) | ×1,85 |
| immo_auto T2 en | « The property, before and after. » | 59 px (3,1 %) | ×1,64 |
| immo_auto T2 es | « El inmueble, antes y después. » | 63 px (3,3 %) | ×1,75 |
| restaurants_maquis T2 es | « De los ingredientes al plato. » | 63 px (3,3 %) | ×1,34 |
| shops_small_business T2 fr | « Le produit, avant et après. » | 67 px (3,5 %) | ×1,86 |
| shops_small_business T2 en | « The product, before and after. » | 61 px (3,2 %) | ×1,69 |
| shops_small_business T2 es | « El producto, antes y después. » | 63 px (3,3 %) | ×1,80 |

Fichiers modifiés : `data/src/main/assets/i18n/gabarit_l10n_v1.json` (2 clés fr renommées,
traductions japonaises reportées à l'identique ; 2 valeurs en/es raccourcies),
`data/…/gabarits/{immo_auto,shops_small_business}/T2.json` (3 occurrences chacun :
scène 1, `copywriting.hooks[0]`, `etapes_montage[0].texte`), plus les copies d'auteur
`content/gabarits_v2/…`. **Aucun des 112 autres combinaisons n'a été touché.**

### Vérifications

| Contrôle | Résultat |
|---|---|
| `tools/e2e/matrix_120.py` | **120/120 `OK_STATIQUE`** (fr 30/30, en 30/30, es 30/30, ja 30/30) |
| `tools/audit/validate_gabarits.py` | 60 gabarits vérifiés, **0 anomalies** ; 30 signatures, 435 paires, 0 erreur |
| `content/…/valider_gabarits.py` | **0 anomalie** |
| Placeholders/variables | aucun des 8 textes n'en contient — parité inchangée |
| Japonais (kinsoku) | traductions reportées à l'identique — aucun risque nouveau |

**Limite honnête** : la nouvelle taille attendue (3,1–4,0 %) est calculée par réplication
des fonctions pures du moteur ; la **preuve visuelle par rendu réel** exige le workflow
`d42-virtual-render` (déclenché sur la branche `audit-d41` — runs en cours, voir 00_STATE).
Les 8 textes restent sous le plancher de 5 % : le raccourcissement ne peut pas faire
mieux sans vider le texte de son sens ; porter UNE ligne latine à 5 %+ exigerait de
changer la mise en page multi-lignes pour **tous** les gabarits — interdit sans nécessité.
