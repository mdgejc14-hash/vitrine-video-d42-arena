# Audit typographique des 30 gabarits × 4 langues (D42.6)

> Simulation **du pipeline réel** (`TexteCommerce.segmenter` puis
> `OverlayTextLayout.sizeForWidth` puis `splitLines`), sur les vrais assets du
> dépôt. Ce n'est **pas** un rendu MP4 : c'est la vérification que le texte
> peut tenir dans le cadre avant d'espérer le voir à l'écran.

## Méthode

- 30 gabarits × 4 langues × toutes leurs scènes portant `texte_ecran.contenu`
- traduction via `gabarit_l10n_v1.json` (repli sur le français), puis
  substitution des variables comme le moteur (`{prix}` groupé par milliers)
- configuration commerciale **identique** pour les 4 langues d'un même gabarit :
  `Chez D42 Test` · `OFFRE D42 DIAGNOSTIC` · `25000` → `25 000` · `FCFA` ·
  `COTONOU` · `+22997000000`
- sortie de référence : 540 × 960 (même résolution que les rendus D42.4)

## Résultats

| Mesure | Valeur |
|---|---|
| textes analysés (scènes + badges) | 2152 |
| textes nécessitant plusieurs segments | 51 |
| textes sur **2 lignes** | 0 |
| textes sur **3 lignes ou plus** | 0 |
| taille minimale observée | 24 px (plancher `MIN_SIZE_PX`) |
| textes réduits au plancher | 196 |

## Répartition des textes au plancher

| Langue | Textes au plancher |
|---|---|
| fr | 54 |
| en | 54 |
| es | 54 |
| ja | 34 |

**120 des 196 cas sont la même ligne** : `Chez D42 Test · COTONOU ·
+22997000000` (30 gabarits × 4 langues). Elle est réduite au minimum parce
qu'elle contient un numéro de téléphone insécable de 13 caractères — ce qui est
aussi **la preuve que la règle « ne jamais couper un numéro » fonctionne**.
Constat visuel confirmé sur le MP4 FR de la porte A : 24 px, 2 lignes, lisible
mais petit.

Les 76 autres cas sont des phrases qui contiennent l'offre complète :
« Un prix spécial sur OFFRE D42 DIAGNOSTIC ! ». La taille dépend donc de la
longueur de l'offre saisie par le marchand. **C'est une limite produit à
documenter dans l'interface** (limiter `nom_offre` à ~24 caractères), pas un
bug de rendu : aucun texte ne déborde du cadre.

## Ce que cette mesure ne prouve pas

- Elle ne prouve pas que le texte apparaît (seul un MP4 le prouve).
- Elle ne prouve rien sur l'antialiasing, le contraste ou le mouvement.
- Elle suppose la police système et les largeurs heuristiques de
  `OverlayTextLayout` (pas les métriques réelles de `StaticLayout`).
