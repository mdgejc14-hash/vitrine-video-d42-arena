# Les 30 parcours détaillés : captures E5 → E6 → E7

**Lecture :** le secteur et le format ne changent pas au milieu du parcours. Pour chaque ligne, `Suivant` va à l’état indiqué ; la flèche de retour revient à l’état précédent.

**Important :** plusieurs `SCxx` pour une même `prise_1` sont des écrans de guide pendant une même prise. Ne transforme pas chaque segment de parole en prise supplémentaire.

Chaîne commune : `E4_Catalogue` → E5 ci-dessous → `E4b_Controle_Avant_Tournage` / `E4b_Ready` → permissions si nécessaires → `E6bis_Consentement_Client` pour T5 → premier état E6. Après le dernier état E6 : `E7b_Controle_Avant_Montage` / `E7b_Montage_OK` → E7 ci-dessous → export E8.

## Vêtements et Mode — T1 : Nouvel arrivage

- Brief : [`E5_vetements_mode_T1_Brief`](ecrans/E5_vetements_mode_T1_Brief.jpg)
- Aperçu : [`E7_vetements_mode_T1_Editeur`](ecrans/E7_vetements_mode_T1_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_vetements_mode_T1_prise_1_SC02`](ecrans/E6_vetements_mode_T1_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_vetements_mode_T1_prise_2_SILENCIEUSE` |
| [`E6_vetements_mode_T1_prise_2_SILENCIEUSE`](ecrans/E6_vetements_mode_T1_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_vetements_mode_T1_prise_1_SC02` | `E6_vetements_mode_T1_prise_3_SILENCIEUSE` |
| [`E6_vetements_mode_T1_prise_3_SILENCIEUSE`](ecrans/E6_vetements_mode_T1_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_vetements_mode_T1_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Vêtements et Mode — T2 : Avant et après

- Brief : [`E5_vetements_mode_T2_Brief`](ecrans/E5_vetements_mode_T2_Brief.jpg)
- Aperçu : [`E7_vetements_mode_T2_Editeur`](ecrans/E7_vetements_mode_T2_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_vetements_mode_T2_prise_1_SC02`](ecrans/E6_vetements_mode_T2_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_vetements_mode_T2_prise_2_SILENCIEUSE` |
| [`E6_vetements_mode_T2_prise_2_SILENCIEUSE`](ecrans/E6_vetements_mode_T2_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_vetements_mode_T2_prise_1_SC02` | `E6_vetements_mode_T2_prise_3_SILENCIEUSE` |
| [`E6_vetements_mode_T2_prise_3_SILENCIEUSE`](ecrans/E6_vetements_mode_T2_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_vetements_mode_T2_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Vêtements et Mode — T3 : Montrer un produit

- Brief : [`E5_vetements_mode_T3_Brief`](ecrans/E5_vetements_mode_T3_Brief.jpg)
- Aperçu : [`E7_vetements_mode_T3_Editeur`](ecrans/E7_vetements_mode_T3_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_vetements_mode_T3_prise_1_SC02`](ecrans/E6_vetements_mode_T3_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_vetements_mode_T3_prise_2_SILENCIEUSE` |
| [`E6_vetements_mode_T3_prise_2_SILENCIEUSE`](ecrans/E6_vetements_mode_T3_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_vetements_mode_T3_prise_1_SC02` | `E6_vetements_mode_T3_prise_3_SILENCIEUSE` |
| [`E6_vetements_mode_T3_prise_3_SILENCIEUSE`](ecrans/E6_vetements_mode_T3_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_vetements_mode_T3_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Vêtements et Mode — T4 : Promotion

- Brief : [`E5_vetements_mode_T4_Brief`](ecrans/E5_vetements_mode_T4_Brief.jpg)
- Aperçu : [`E7_vetements_mode_T4_Editeur`](ecrans/E7_vetements_mode_T4_Editeur.jpg)
- Prises physiques prévues : **2** ; états caméra illustrés : **2**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_vetements_mode_T4_prise_1_SC02`](ecrans/E6_vetements_mode_T4_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_vetements_mode_T4_prise_2_SILENCIEUSE` |
| [`E6_vetements_mode_T4_prise_2_SILENCIEUSE`](ecrans/E6_vetements_mode_T4_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_vetements_mode_T4_prise_1_SC02` | `E7b_Controle_Avant_Montage` |

## Vêtements et Mode — T5 : Un client raconte

- Brief : [`E5_vetements_mode_T5_Brief`](ecrans/E5_vetements_mode_T5_Brief.jpg)
- Aperçu : [`E7_vetements_mode_T5_Editeur`](ecrans/E7_vetements_mode_T5_Editeur.jpg)
- Prises physiques prévues : **2** ; états caméra illustrés : **5**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_vetements_mode_T5_prise_1_SC01`](ecrans/E6_vetements_mode_T5_prise_1_SC01.jpg) | prise_1 · parole 1/4 · scène 01 | `E4b_Ready` | `E6_vetements_mode_T5_prise_1_SC02` |
| [`E6_vetements_mode_T5_prise_1_SC02`](ecrans/E6_vetements_mode_T5_prise_1_SC02.jpg) | prise_1 · parole 2/4 · scène 02 | `E6_vetements_mode_T5_prise_1_SC01` | `E6_vetements_mode_T5_prise_1_SC03` |
| [`E6_vetements_mode_T5_prise_1_SC03`](ecrans/E6_vetements_mode_T5_prise_1_SC03.jpg) | prise_1 · parole 3/4 · scène 03 | `E6_vetements_mode_T5_prise_1_SC02` | `E6_vetements_mode_T5_prise_1_SC05` |
| [`E6_vetements_mode_T5_prise_1_SC05`](ecrans/E6_vetements_mode_T5_prise_1_SC05.jpg) | prise_1 · parole 4/4 · scène 05 | `E6_vetements_mode_T5_prise_1_SC03` | `E6_vetements_mode_T5_prise_2_SILENCIEUSE` |
| [`E6_vetements_mode_T5_prise_2_SILENCIEUSE`](ecrans/E6_vetements_mode_T5_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_vetements_mode_T5_prise_1_SC05` | `E7b_Controle_Avant_Montage` |

## Coiffure et Beauté — T1 : Nouvel arrivage

- Brief : [`E5_coiffure_beaute_T1_Brief`](ecrans/E5_coiffure_beaute_T1_Brief.jpg)
- Aperçu : [`E7_coiffure_beaute_T1_Editeur`](ecrans/E7_coiffure_beaute_T1_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_coiffure_beaute_T1_prise_1_SC02`](ecrans/E6_coiffure_beaute_T1_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_coiffure_beaute_T1_prise_2_SILENCIEUSE` |
| [`E6_coiffure_beaute_T1_prise_2_SILENCIEUSE`](ecrans/E6_coiffure_beaute_T1_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_coiffure_beaute_T1_prise_1_SC02` | `E6_coiffure_beaute_T1_prise_3_SILENCIEUSE` |
| [`E6_coiffure_beaute_T1_prise_3_SILENCIEUSE`](ecrans/E6_coiffure_beaute_T1_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_coiffure_beaute_T1_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Coiffure et Beauté — T2 : Avant et après

- Brief : [`E5_coiffure_beaute_T2_Brief`](ecrans/E5_coiffure_beaute_T2_Brief.jpg)
- Aperçu : [`E7_coiffure_beaute_T2_Editeur`](ecrans/E7_coiffure_beaute_T2_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_coiffure_beaute_T2_prise_1_SC02`](ecrans/E6_coiffure_beaute_T2_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_coiffure_beaute_T2_prise_2_SILENCIEUSE` |
| [`E6_coiffure_beaute_T2_prise_2_SILENCIEUSE`](ecrans/E6_coiffure_beaute_T2_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_coiffure_beaute_T2_prise_1_SC02` | `E6_coiffure_beaute_T2_prise_3_SILENCIEUSE` |
| [`E6_coiffure_beaute_T2_prise_3_SILENCIEUSE`](ecrans/E6_coiffure_beaute_T2_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_coiffure_beaute_T2_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Coiffure et Beauté — T3 : Montrer un produit

- Brief : [`E5_coiffure_beaute_T3_Brief`](ecrans/E5_coiffure_beaute_T3_Brief.jpg)
- Aperçu : [`E7_coiffure_beaute_T3_Editeur`](ecrans/E7_coiffure_beaute_T3_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_coiffure_beaute_T3_prise_1_SC02`](ecrans/E6_coiffure_beaute_T3_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_coiffure_beaute_T3_prise_2_SILENCIEUSE` |
| [`E6_coiffure_beaute_T3_prise_2_SILENCIEUSE`](ecrans/E6_coiffure_beaute_T3_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_coiffure_beaute_T3_prise_1_SC02` | `E6_coiffure_beaute_T3_prise_3_SILENCIEUSE` |
| [`E6_coiffure_beaute_T3_prise_3_SILENCIEUSE`](ecrans/E6_coiffure_beaute_T3_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_coiffure_beaute_T3_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Coiffure et Beauté — T4 : Promotion

- Brief : [`E5_coiffure_beaute_T4_Brief`](ecrans/E5_coiffure_beaute_T4_Brief.jpg)
- Aperçu : [`E7_coiffure_beaute_T4_Editeur`](ecrans/E7_coiffure_beaute_T4_Editeur.jpg)
- Prises physiques prévues : **2** ; états caméra illustrés : **2**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_coiffure_beaute_T4_prise_1_SC02`](ecrans/E6_coiffure_beaute_T4_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_coiffure_beaute_T4_prise_2_SILENCIEUSE` |
| [`E6_coiffure_beaute_T4_prise_2_SILENCIEUSE`](ecrans/E6_coiffure_beaute_T4_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_coiffure_beaute_T4_prise_1_SC02` | `E7b_Controle_Avant_Montage` |

## Coiffure et Beauté — T5 : Un client raconte

- Brief : [`E5_coiffure_beaute_T5_Brief`](ecrans/E5_coiffure_beaute_T5_Brief.jpg)
- Aperçu : [`E7_coiffure_beaute_T5_Editeur`](ecrans/E7_coiffure_beaute_T5_Editeur.jpg)
- Prises physiques prévues : **2** ; états caméra illustrés : **6**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_coiffure_beaute_T5_prise_1_SC01`](ecrans/E6_coiffure_beaute_T5_prise_1_SC01.jpg) | prise_1 · parole 1/5 · scène 01 | `E4b_Ready` | `E6_coiffure_beaute_T5_prise_1_SC02` |
| [`E6_coiffure_beaute_T5_prise_1_SC02`](ecrans/E6_coiffure_beaute_T5_prise_1_SC02.jpg) | prise_1 · parole 2/5 · scène 02 | `E6_coiffure_beaute_T5_prise_1_SC01` | `E6_coiffure_beaute_T5_prise_1_SC03` |
| [`E6_coiffure_beaute_T5_prise_1_SC03`](ecrans/E6_coiffure_beaute_T5_prise_1_SC03.jpg) | prise_1 · parole 3/5 · scène 03 | `E6_coiffure_beaute_T5_prise_1_SC02` | `E6_coiffure_beaute_T5_prise_1_SC05` |
| [`E6_coiffure_beaute_T5_prise_1_SC05`](ecrans/E6_coiffure_beaute_T5_prise_1_SC05.jpg) | prise_1 · parole 4/5 · scène 05 | `E6_coiffure_beaute_T5_prise_1_SC03` | `E6_coiffure_beaute_T5_prise_1_SC12` |
| [`E6_coiffure_beaute_T5_prise_1_SC12`](ecrans/E6_coiffure_beaute_T5_prise_1_SC12.jpg) | prise_1 · parole 5/5 · scène 12 | `E6_coiffure_beaute_T5_prise_1_SC05` | `E6_coiffure_beaute_T5_prise_2_SILENCIEUSE` |
| [`E6_coiffure_beaute_T5_prise_2_SILENCIEUSE`](ecrans/E6_coiffure_beaute_T5_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_coiffure_beaute_T5_prise_1_SC12` | `E7b_Controle_Avant_Montage` |

## Restaurants et Maquis — T1 : Nouvel arrivage

- Brief : [`E5_restaurants_maquis_T1_Brief`](ecrans/E5_restaurants_maquis_T1_Brief.jpg)
- Aperçu : [`E7_restaurants_maquis_T1_Editeur`](ecrans/E7_restaurants_maquis_T1_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_restaurants_maquis_T1_prise_1_SILENCIEUSE`](ecrans/E6_restaurants_maquis_T1_prise_1_SILENCIEUSE.jpg) | prise_1 · prise silencieuse | `E4b_Ready` | `E6_restaurants_maquis_T1_prise_2_SILENCIEUSE` |
| [`E6_restaurants_maquis_T1_prise_2_SILENCIEUSE`](ecrans/E6_restaurants_maquis_T1_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_restaurants_maquis_T1_prise_1_SILENCIEUSE` | `E6_restaurants_maquis_T1_prise_3_SC02` |
| [`E6_restaurants_maquis_T1_prise_3_SC02`](ecrans/E6_restaurants_maquis_T1_prise_3_SC02.jpg) | prise_3 · parole 1/1 · scène 02 | `E6_restaurants_maquis_T1_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Restaurants et Maquis — T2 : Avant et après

- Brief : [`E5_restaurants_maquis_T2_Brief`](ecrans/E5_restaurants_maquis_T2_Brief.jpg)
- Aperçu : [`E7_restaurants_maquis_T2_Editeur`](ecrans/E7_restaurants_maquis_T2_Editeur.jpg)
- Prises physiques prévues : **4** ; états caméra illustrés : **4**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_restaurants_maquis_T2_prise_1_SC02`](ecrans/E6_restaurants_maquis_T2_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_restaurants_maquis_T2_prise_2_SILENCIEUSE` |
| [`E6_restaurants_maquis_T2_prise_2_SILENCIEUSE`](ecrans/E6_restaurants_maquis_T2_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_restaurants_maquis_T2_prise_1_SC02` | `E6_restaurants_maquis_T2_prise_3_SILENCIEUSE` |
| [`E6_restaurants_maquis_T2_prise_3_SILENCIEUSE`](ecrans/E6_restaurants_maquis_T2_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_restaurants_maquis_T2_prise_2_SILENCIEUSE` | `E6_restaurants_maquis_T2_prise_4_SILENCIEUSE` |
| [`E6_restaurants_maquis_T2_prise_4_SILENCIEUSE`](ecrans/E6_restaurants_maquis_T2_prise_4_SILENCIEUSE.jpg) | prise_4 · prise silencieuse | `E6_restaurants_maquis_T2_prise_3_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Restaurants et Maquis — T3 : Montrer un produit

- Brief : [`E5_restaurants_maquis_T3_Brief`](ecrans/E5_restaurants_maquis_T3_Brief.jpg)
- Aperçu : [`E7_restaurants_maquis_T3_Editeur`](ecrans/E7_restaurants_maquis_T3_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_restaurants_maquis_T3_prise_1_SC02`](ecrans/E6_restaurants_maquis_T3_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_restaurants_maquis_T3_prise_2_SILENCIEUSE` |
| [`E6_restaurants_maquis_T3_prise_2_SILENCIEUSE`](ecrans/E6_restaurants_maquis_T3_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_restaurants_maquis_T3_prise_1_SC02` | `E6_restaurants_maquis_T3_prise_3_SILENCIEUSE` |
| [`E6_restaurants_maquis_T3_prise_3_SILENCIEUSE`](ecrans/E6_restaurants_maquis_T3_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_restaurants_maquis_T3_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Restaurants et Maquis — T4 : Promotion

- Brief : [`E5_restaurants_maquis_T4_Brief`](ecrans/E5_restaurants_maquis_T4_Brief.jpg)
- Aperçu : [`E7_restaurants_maquis_T4_Editeur`](ecrans/E7_restaurants_maquis_T4_Editeur.jpg)
- Prises physiques prévues : **2** ; états caméra illustrés : **2**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_restaurants_maquis_T4_prise_1_SC02`](ecrans/E6_restaurants_maquis_T4_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_restaurants_maquis_T4_prise_2_SILENCIEUSE` |
| [`E6_restaurants_maquis_T4_prise_2_SILENCIEUSE`](ecrans/E6_restaurants_maquis_T4_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_restaurants_maquis_T4_prise_1_SC02` | `E7b_Controle_Avant_Montage` |

## Restaurants et Maquis — T5 : Un client raconte

- Brief : [`E5_restaurants_maquis_T5_Brief`](ecrans/E5_restaurants_maquis_T5_Brief.jpg)
- Aperçu : [`E7_restaurants_maquis_T5_Editeur`](ecrans/E7_restaurants_maquis_T5_Editeur.jpg)
- Prises physiques prévues : **2** ; états caméra illustrés : **5**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_restaurants_maquis_T5_prise_1_SC01`](ecrans/E6_restaurants_maquis_T5_prise_1_SC01.jpg) | prise_1 · parole 1/4 · scène 01 | `E4b_Ready` | `E6_restaurants_maquis_T5_prise_1_SC02` |
| [`E6_restaurants_maquis_T5_prise_1_SC02`](ecrans/E6_restaurants_maquis_T5_prise_1_SC02.jpg) | prise_1 · parole 2/4 · scène 02 | `E6_restaurants_maquis_T5_prise_1_SC01` | `E6_restaurants_maquis_T5_prise_1_SC03` |
| [`E6_restaurants_maquis_T5_prise_1_SC03`](ecrans/E6_restaurants_maquis_T5_prise_1_SC03.jpg) | prise_1 · parole 3/4 · scène 03 | `E6_restaurants_maquis_T5_prise_1_SC02` | `E6_restaurants_maquis_T5_prise_1_SC05` |
| [`E6_restaurants_maquis_T5_prise_1_SC05`](ecrans/E6_restaurants_maquis_T5_prise_1_SC05.jpg) | prise_1 · parole 4/4 · scène 05 | `E6_restaurants_maquis_T5_prise_1_SC03` | `E6_restaurants_maquis_T5_prise_2_SILENCIEUSE` |
| [`E6_restaurants_maquis_T5_prise_2_SILENCIEUSE`](ecrans/E6_restaurants_maquis_T5_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_restaurants_maquis_T5_prise_1_SC05` | `E7b_Controle_Avant_Montage` |

## Bâtiment et Travaux — T1 : Nouvel arrivage

- Brief : [`E5_batiment_travaux_T1_Brief`](ecrans/E5_batiment_travaux_T1_Brief.jpg)
- Aperçu : [`E7_batiment_travaux_T1_Editeur`](ecrans/E7_batiment_travaux_T1_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_batiment_travaux_T1_prise_1_SC02`](ecrans/E6_batiment_travaux_T1_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_batiment_travaux_T1_prise_2_SILENCIEUSE` |
| [`E6_batiment_travaux_T1_prise_2_SILENCIEUSE`](ecrans/E6_batiment_travaux_T1_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_batiment_travaux_T1_prise_1_SC02` | `E6_batiment_travaux_T1_prise_3_SILENCIEUSE` |
| [`E6_batiment_travaux_T1_prise_3_SILENCIEUSE`](ecrans/E6_batiment_travaux_T1_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_batiment_travaux_T1_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Bâtiment et Travaux — T2 : Avant et après

- Brief : [`E5_batiment_travaux_T2_Brief`](ecrans/E5_batiment_travaux_T2_Brief.jpg)
- Aperçu : [`E7_batiment_travaux_T2_Editeur`](ecrans/E7_batiment_travaux_T2_Editeur.jpg)
- Prises physiques prévues : **4** ; états caméra illustrés : **4**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_batiment_travaux_T2_prise_1_SC02`](ecrans/E6_batiment_travaux_T2_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_batiment_travaux_T2_prise_2_SILENCIEUSE` |
| [`E6_batiment_travaux_T2_prise_2_SILENCIEUSE`](ecrans/E6_batiment_travaux_T2_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_batiment_travaux_T2_prise_1_SC02` | `E6_batiment_travaux_T2_prise_3_SILENCIEUSE` |
| [`E6_batiment_travaux_T2_prise_3_SILENCIEUSE`](ecrans/E6_batiment_travaux_T2_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_batiment_travaux_T2_prise_2_SILENCIEUSE` | `E6_batiment_travaux_T2_prise_4_SILENCIEUSE` |
| [`E6_batiment_travaux_T2_prise_4_SILENCIEUSE`](ecrans/E6_batiment_travaux_T2_prise_4_SILENCIEUSE.jpg) | prise_4 · prise silencieuse | `E6_batiment_travaux_T2_prise_3_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Bâtiment et Travaux — T3 : Montrer un produit

- Brief : [`E5_batiment_travaux_T3_Brief`](ecrans/E5_batiment_travaux_T3_Brief.jpg)
- Aperçu : [`E7_batiment_travaux_T3_Editeur`](ecrans/E7_batiment_travaux_T3_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_batiment_travaux_T3_prise_1_SC02`](ecrans/E6_batiment_travaux_T3_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_batiment_travaux_T3_prise_2_SILENCIEUSE` |
| [`E6_batiment_travaux_T3_prise_2_SILENCIEUSE`](ecrans/E6_batiment_travaux_T3_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_batiment_travaux_T3_prise_1_SC02` | `E6_batiment_travaux_T3_prise_3_SILENCIEUSE` |
| [`E6_batiment_travaux_T3_prise_3_SILENCIEUSE`](ecrans/E6_batiment_travaux_T3_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_batiment_travaux_T3_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Bâtiment et Travaux — T4 : Promotion

- Brief : [`E5_batiment_travaux_T4_Brief`](ecrans/E5_batiment_travaux_T4_Brief.jpg)
- Aperçu : [`E7_batiment_travaux_T4_Editeur`](ecrans/E7_batiment_travaux_T4_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_batiment_travaux_T4_prise_1_SILENCIEUSE`](ecrans/E6_batiment_travaux_T4_prise_1_SILENCIEUSE.jpg) | prise_1 · prise silencieuse | `E4b_Ready` | `E6_batiment_travaux_T4_prise_2_SILENCIEUSE` |
| [`E6_batiment_travaux_T4_prise_2_SILENCIEUSE`](ecrans/E6_batiment_travaux_T4_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_batiment_travaux_T4_prise_1_SILENCIEUSE` | `E6_batiment_travaux_T4_prise_3_SC02` |
| [`E6_batiment_travaux_T4_prise_3_SC02`](ecrans/E6_batiment_travaux_T4_prise_3_SC02.jpg) | prise_3 · parole 1/1 · scène 02 | `E6_batiment_travaux_T4_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Bâtiment et Travaux — T5 : Un client raconte

- Brief : [`E5_batiment_travaux_T5_Brief`](ecrans/E5_batiment_travaux_T5_Brief.jpg)
- Aperçu : [`E7_batiment_travaux_T5_Editeur`](ecrans/E7_batiment_travaux_T5_Editeur.jpg)
- Prises physiques prévues : **2** ; états caméra illustrés : **6**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_batiment_travaux_T5_prise_1_SC01`](ecrans/E6_batiment_travaux_T5_prise_1_SC01.jpg) | prise_1 · parole 1/5 · scène 01 | `E4b_Ready` | `E6_batiment_travaux_T5_prise_1_SC02` |
| [`E6_batiment_travaux_T5_prise_1_SC02`](ecrans/E6_batiment_travaux_T5_prise_1_SC02.jpg) | prise_1 · parole 2/5 · scène 02 | `E6_batiment_travaux_T5_prise_1_SC01` | `E6_batiment_travaux_T5_prise_1_SC03` |
| [`E6_batiment_travaux_T5_prise_1_SC03`](ecrans/E6_batiment_travaux_T5_prise_1_SC03.jpg) | prise_1 · parole 3/5 · scène 03 | `E6_batiment_travaux_T5_prise_1_SC02` | `E6_batiment_travaux_T5_prise_1_SC05` |
| [`E6_batiment_travaux_T5_prise_1_SC05`](ecrans/E6_batiment_travaux_T5_prise_1_SC05.jpg) | prise_1 · parole 4/5 · scène 05 | `E6_batiment_travaux_T5_prise_1_SC03` | `E6_batiment_travaux_T5_prise_1_SC12` |
| [`E6_batiment_travaux_T5_prise_1_SC12`](ecrans/E6_batiment_travaux_T5_prise_1_SC12.jpg) | prise_1 · parole 5/5 · scène 12 | `E6_batiment_travaux_T5_prise_1_SC05` | `E6_batiment_travaux_T5_prise_2_SILENCIEUSE` |
| [`E6_batiment_travaux_T5_prise_2_SILENCIEUSE`](ecrans/E6_batiment_travaux_T5_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_batiment_travaux_T5_prise_1_SC12` | `E7b_Controle_Avant_Montage` |

## Maisons et Voitures — T1 : Nouvel arrivage

- Brief : [`E5_immo_auto_T1_Brief`](ecrans/E5_immo_auto_T1_Brief.jpg)
- Aperçu : [`E7_immo_auto_T1_Editeur`](ecrans/E7_immo_auto_T1_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_immo_auto_T1_prise_1_SC02`](ecrans/E6_immo_auto_T1_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_immo_auto_T1_prise_2_SILENCIEUSE` |
| [`E6_immo_auto_T1_prise_2_SILENCIEUSE`](ecrans/E6_immo_auto_T1_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_immo_auto_T1_prise_1_SC02` | `E6_immo_auto_T1_prise_3_SILENCIEUSE` |
| [`E6_immo_auto_T1_prise_3_SILENCIEUSE`](ecrans/E6_immo_auto_T1_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_immo_auto_T1_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Maisons et Voitures — T2 : Avant et après

- Brief : [`E5_immo_auto_T2_Brief`](ecrans/E5_immo_auto_T2_Brief.jpg)
- Aperçu : [`E7_immo_auto_T2_Editeur`](ecrans/E7_immo_auto_T2_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_immo_auto_T2_prise_1_SC02`](ecrans/E6_immo_auto_T2_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_immo_auto_T2_prise_2_SILENCIEUSE` |
| [`E6_immo_auto_T2_prise_2_SILENCIEUSE`](ecrans/E6_immo_auto_T2_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_immo_auto_T2_prise_1_SC02` | `E6_immo_auto_T2_prise_3_SILENCIEUSE` |
| [`E6_immo_auto_T2_prise_3_SILENCIEUSE`](ecrans/E6_immo_auto_T2_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_immo_auto_T2_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Maisons et Voitures — T3 : Montrer un produit

- Brief : [`E5_immo_auto_T3_Brief`](ecrans/E5_immo_auto_T3_Brief.jpg)
- Aperçu : [`E7_immo_auto_T3_Editeur`](ecrans/E7_immo_auto_T3_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_immo_auto_T3_prise_1_SC02`](ecrans/E6_immo_auto_T3_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_immo_auto_T3_prise_2_SILENCIEUSE` |
| [`E6_immo_auto_T3_prise_2_SILENCIEUSE`](ecrans/E6_immo_auto_T3_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_immo_auto_T3_prise_1_SC02` | `E6_immo_auto_T3_prise_3_SILENCIEUSE` |
| [`E6_immo_auto_T3_prise_3_SILENCIEUSE`](ecrans/E6_immo_auto_T3_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_immo_auto_T3_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Maisons et Voitures — T4 : Promotion

- Brief : [`E5_immo_auto_T4_Brief`](ecrans/E5_immo_auto_T4_Brief.jpg)
- Aperçu : [`E7_immo_auto_T4_Editeur`](ecrans/E7_immo_auto_T4_Editeur.jpg)
- Prises physiques prévues : **2** ; états caméra illustrés : **2**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_immo_auto_T4_prise_1_SILENCIEUSE`](ecrans/E6_immo_auto_T4_prise_1_SILENCIEUSE.jpg) | prise_1 · prise silencieuse | `E4b_Ready` | `E6_immo_auto_T4_prise_2_SC02` |
| [`E6_immo_auto_T4_prise_2_SC02`](ecrans/E6_immo_auto_T4_prise_2_SC02.jpg) | prise_2 · parole 1/1 · scène 02 | `E6_immo_auto_T4_prise_1_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Maisons et Voitures — T5 : Un client raconte

- Brief : [`E5_immo_auto_T5_Brief`](ecrans/E5_immo_auto_T5_Brief.jpg)
- Aperçu : [`E7_immo_auto_T5_Editeur`](ecrans/E7_immo_auto_T5_Editeur.jpg)
- Prises physiques prévues : **2** ; états caméra illustrés : **6**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_immo_auto_T5_prise_1_SC01`](ecrans/E6_immo_auto_T5_prise_1_SC01.jpg) | prise_1 · parole 1/5 · scène 01 | `E4b_Ready` | `E6_immo_auto_T5_prise_1_SC02` |
| [`E6_immo_auto_T5_prise_1_SC02`](ecrans/E6_immo_auto_T5_prise_1_SC02.jpg) | prise_1 · parole 2/5 · scène 02 | `E6_immo_auto_T5_prise_1_SC01` | `E6_immo_auto_T5_prise_1_SC03` |
| [`E6_immo_auto_T5_prise_1_SC03`](ecrans/E6_immo_auto_T5_prise_1_SC03.jpg) | prise_1 · parole 3/5 · scène 03 | `E6_immo_auto_T5_prise_1_SC02` | `E6_immo_auto_T5_prise_1_SC05` |
| [`E6_immo_auto_T5_prise_1_SC05`](ecrans/E6_immo_auto_T5_prise_1_SC05.jpg) | prise_1 · parole 4/5 · scène 05 | `E6_immo_auto_T5_prise_1_SC03` | `E6_immo_auto_T5_prise_1_SC12` |
| [`E6_immo_auto_T5_prise_1_SC12`](ecrans/E6_immo_auto_T5_prise_1_SC12.jpg) | prise_1 · parole 5/5 · scène 12 | `E6_immo_auto_T5_prise_1_SC05` | `E6_immo_auto_T5_prise_2_SILENCIEUSE` |
| [`E6_immo_auto_T5_prise_2_SILENCIEUSE`](ecrans/E6_immo_auto_T5_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_immo_auto_T5_prise_1_SC12` | `E7b_Controle_Avant_Montage` |

## Boutiques — T1 : Nouvel arrivage

- Brief : [`E5_shops_small_business_T1_Brief`](ecrans/E5_shops_small_business_T1_Brief.jpg)
- Aperçu : [`E7_shops_small_business_T1_Editeur`](ecrans/E7_shops_small_business_T1_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_shops_small_business_T1_prise_1_SC02`](ecrans/E6_shops_small_business_T1_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_shops_small_business_T1_prise_2_SILENCIEUSE` |
| [`E6_shops_small_business_T1_prise_2_SILENCIEUSE`](ecrans/E6_shops_small_business_T1_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_shops_small_business_T1_prise_1_SC02` | `E6_shops_small_business_T1_prise_3_SILENCIEUSE` |
| [`E6_shops_small_business_T1_prise_3_SILENCIEUSE`](ecrans/E6_shops_small_business_T1_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_shops_small_business_T1_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Boutiques — T2 : Avant et après

- Brief : [`E5_shops_small_business_T2_Brief`](ecrans/E5_shops_small_business_T2_Brief.jpg)
- Aperçu : [`E7_shops_small_business_T2_Editeur`](ecrans/E7_shops_small_business_T2_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_shops_small_business_T2_prise_1_SC02`](ecrans/E6_shops_small_business_T2_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_shops_small_business_T2_prise_2_SILENCIEUSE` |
| [`E6_shops_small_business_T2_prise_2_SILENCIEUSE`](ecrans/E6_shops_small_business_T2_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_shops_small_business_T2_prise_1_SC02` | `E6_shops_small_business_T2_prise_3_SILENCIEUSE` |
| [`E6_shops_small_business_T2_prise_3_SILENCIEUSE`](ecrans/E6_shops_small_business_T2_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_shops_small_business_T2_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Boutiques — T3 : Montrer un produit

- Brief : [`E5_shops_small_business_T3_Brief`](ecrans/E5_shops_small_business_T3_Brief.jpg)
- Aperçu : [`E7_shops_small_business_T3_Editeur`](ecrans/E7_shops_small_business_T3_Editeur.jpg)
- Prises physiques prévues : **3** ; états caméra illustrés : **3**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_shops_small_business_T3_prise_1_SC02`](ecrans/E6_shops_small_business_T3_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_shops_small_business_T3_prise_2_SILENCIEUSE` |
| [`E6_shops_small_business_T3_prise_2_SILENCIEUSE`](ecrans/E6_shops_small_business_T3_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_shops_small_business_T3_prise_1_SC02` | `E6_shops_small_business_T3_prise_3_SILENCIEUSE` |
| [`E6_shops_small_business_T3_prise_3_SILENCIEUSE`](ecrans/E6_shops_small_business_T3_prise_3_SILENCIEUSE.jpg) | prise_3 · prise silencieuse | `E6_shops_small_business_T3_prise_2_SILENCIEUSE` | `E7b_Controle_Avant_Montage` |

## Boutiques — T4 : Promotion

- Brief : [`E5_shops_small_business_T4_Brief`](ecrans/E5_shops_small_business_T4_Brief.jpg)
- Aperçu : [`E7_shops_small_business_T4_Editeur`](ecrans/E7_shops_small_business_T4_Editeur.jpg)
- Prises physiques prévues : **2** ; états caméra illustrés : **2**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_shops_small_business_T4_prise_1_SC02`](ecrans/E6_shops_small_business_T4_prise_1_SC02.jpg) | prise_1 · parole 1/1 · scène 02 | `E4b_Ready` | `E6_shops_small_business_T4_prise_2_SILENCIEUSE` |
| [`E6_shops_small_business_T4_prise_2_SILENCIEUSE`](ecrans/E6_shops_small_business_T4_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_shops_small_business_T4_prise_1_SC02` | `E7b_Controle_Avant_Montage` |

## Boutiques — T5 : Un client raconte

- Brief : [`E5_shops_small_business_T5_Brief`](ecrans/E5_shops_small_business_T5_Brief.jpg)
- Aperçu : [`E7_shops_small_business_T5_Editeur`](ecrans/E7_shops_small_business_T5_Editeur.jpg)
- Prises physiques prévues : **2** ; états caméra illustrés : **6**.

| État caméra | Guide / prise | Retour | Suivant |
|---|---|---|---|
| [`E6_shops_small_business_T5_prise_1_SC01`](ecrans/E6_shops_small_business_T5_prise_1_SC01.jpg) | prise_1 · parole 1/5 · scène 01 | `E4b_Ready` | `E6_shops_small_business_T5_prise_1_SC02` |
| [`E6_shops_small_business_T5_prise_1_SC02`](ecrans/E6_shops_small_business_T5_prise_1_SC02.jpg) | prise_1 · parole 2/5 · scène 02 | `E6_shops_small_business_T5_prise_1_SC01` | `E6_shops_small_business_T5_prise_1_SC03` |
| [`E6_shops_small_business_T5_prise_1_SC03`](ecrans/E6_shops_small_business_T5_prise_1_SC03.jpg) | prise_1 · parole 3/5 · scène 03 | `E6_shops_small_business_T5_prise_1_SC02` | `E6_shops_small_business_T5_prise_1_SC05` |
| [`E6_shops_small_business_T5_prise_1_SC05`](ecrans/E6_shops_small_business_T5_prise_1_SC05.jpg) | prise_1 · parole 4/5 · scène 05 | `E6_shops_small_business_T5_prise_1_SC03` | `E6_shops_small_business_T5_prise_1_SC12` |
| [`E6_shops_small_business_T5_prise_1_SC12`](ecrans/E6_shops_small_business_T5_prise_1_SC12.jpg) | prise_1 · parole 5/5 · scène 12 | `E6_shops_small_business_T5_prise_1_SC05` | `E6_shops_small_business_T5_prise_2_SILENCIEUSE` |
| [`E6_shops_small_business_T5_prise_2_SILENCIEUSE`](ecrans/E6_shops_small_business_T5_prise_2_SILENCIEUSE.jpg) | prise_2 · prise silencieuse | `E6_shops_small_business_T5_prise_1_SC12` | `E7b_Controle_Avant_Montage` |

