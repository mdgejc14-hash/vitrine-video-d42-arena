# D42.14 — Paysage : les 2 échecs, tranchés par la lecture du code et des runs

## 1. Les deux échecs dont il est question

Run D42.13 `42186013775`, variante `rot90` (Pixel 5 pivoté, 2340 × 1080) :

| Contrôle | Verdict | Libellé du test |
|---|---|---|
| `S03b_langue_jp_visible` | **FAIL** | « carte 日本語 hors écran ou absente » |
| `S04b_bouton_google_dans_ecran` | **FAIL** | « bouton principal hors écran » |
| `S10_bouton_continuer_visible` | **FAIL** | (corrigé en D42.13 : pied de page épinglé) |
| `S11_bouton_apres_defilement` | **FAIL** | idem |

## 2. Ce que dit le code (vérifié dans cette session)

| Écran | Structure réelle | Conséquence en paysage |
|---|---|---|
| Langue (`LanguageScreen.kt`) | `Column(fillMaxSize().verticalScroll(rememberScrollState()))` — le commentaire du fichier cite explicitement le run `42182985228` : « les deux dernières langues devenaient inatteignables » | **l'écran défile** : aucun élément n'est définitivement hors d'atteinte |
| Connexion (`activity_auth.xml`) | `ScrollView` + `fillViewport="true"` | **l'écran défile** |
| Activité | pied de page épinglé (correctif D42.13) | bouton toujours visible |

## 3. Le défaut réel est dans le harnais

`ui.py inside` répond à une seule question : « l'élément est-il **entièrement dans la
fenêtre à cet instant** ? ». Sur un écran **défilant**, un élément situé sous la ligne de
flottaison est conforme (c'est le comportement normal d'une page) mais était compté
`FAIL`. Le test ne défilait pas avant de juger.

C'est la même famille d'erreur que les six autres défauts de harnais corrigés cette
session : **le test affirmait plus que ce qu'il mesurait**.

## 4. Correctif appliqué (commit `38e1fe3`, clone local `/home/user/lab`)

`tools/e2e/run_p0.sh` — nouvelle fonction `visible_ou_defilant` :

```
verdict 0 : visible sans défiler                 → PASS  "... visible sans défiler"
verdict 2 : atteint après 1 à 4 glissements      → PASS  "... atteint APRÈS DÉFILEMENT"
verdict 3 : introuvable même après défilement    → FAIL
```

- **Aucun statut nouveau** : le vocabulaire `PASS` / `FAIL` / `BLOCKED` reste intact
  (les compteurs du run ne sont pas faussés).
- Le libellé de la ligne dit **lequel des deux cas** s'applique : on saura donc, à la
  prochaine exécution, si le paysage est « confortable » ou seulement « utilisable ».
- Appliqué à `S03b` (日本語) et `S04b` (bouton Google).

## 5. Ce qui reste non tranché (honnêtement)

| Question | Réponse aujourd'hui |
|---|---|
| Les 4 langues sont-elles **sélectionnables** en paysage ? | **probable mais non prouvé** — aucune exécution n'a tapé 日本語 en `rot90` puis vérifié l'écran suivant |
| Le bouton Google est-il **actionnable** en paysage ? | idem |
| Pourquoi `S12_selection_secteur` et `S17_catalogue` échouent-ils **en `rot90`** ? | **inconnu** : les captures du run `rot90` sont inaccessibles sans jeton (artefacts → 401) ; hypothèse principale = même cause que la ligne précédente (verdict pris avant que l'écran ait fini de changer) |
| Le paysage est-il **agréable** (sans défilement) ? | non — sur 1080 px de haut, un en-tête de 88 dp + 4 cartes ne tiennent pas. Piste : `values-land` avec logo réduit |

## 6. Ce qu'il ne faut pas faire

- Ne pas présenter le correctif comme une **correction du produit** : le produit
  n'a pas été modifié, seule la mesure l'a été.
- Ne pas retirer l'exigence de défilement : un élément qui exige un défilement
  reste acceptable (WCAG 1.4.10 Reflow), un élément **inatteignable** ne l'est pas.
  La différence entre les deux est exactement ce que ce correctif mesure.

## 7. Preuve visuelle demandée au fondateur (30 secondes)

Étapes 2 et 4 du protocole physique, **téléphone en paysage** :
`P18_paysage_langue.png`, `P19_paysage_connexion.png` (voir `09_PROTOCOLE_PHYSIQUE.md`).
Deux captures suffisent à trancher définitivement les deux échecs.
