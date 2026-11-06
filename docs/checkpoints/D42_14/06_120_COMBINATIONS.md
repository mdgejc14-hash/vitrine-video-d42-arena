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
