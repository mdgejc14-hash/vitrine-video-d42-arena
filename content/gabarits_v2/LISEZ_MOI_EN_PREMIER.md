# Vitrine Vidéo — 30 gabarits et fiches V2.0

## Ce que tu peux transmettre

Cette archive rassemble les gabarits existants et une proposition technique pour l’équipe de développement. Elle ne remplace pas le **kit d’ingénierie moteur V2.0 complet**, à transmettre aussi pour les règles détaillées de montage, de sécurité, de licence et de paiement.

| Dossier ou fichier | Contenu |
|---|---|
| `gabarits/` | Les **30 JSON d’origine**, inchangés : six secteurs × T1 à T5. |
| `universel/`, `packs_langue/`, `README_gabarits.md` | Les dix autres fichiers de l’archive d’origine, inchangés. Les deux guides commerçant sont ajoutés à la racine. |
| `fiches_style_v2_0/` | **30 fiches de style uniques**, une par JSON. Elles sont complétées et ne contiennent pas de valeur JSON `null`. |
| `profils_style/` | Copie identique, octet pour octet, des 30 mêmes fiches. Ce n’est **pas** 30 profils supplémentaires. |
| `matrice_audio/` | 30 correspondances musique et BPM ; 280 repères SFX proposés ; neuf catégories de SFX à acquérir ; matrices historiques préservées. |
| `contrats_et_validation/` | Contrats du kit V2.0 copiés sans modification, schéma additionnel des fiches V2 et deux validateurs distincts. |
| `references/` | Inventaire des scènes et cartes, dictionnaire technique proposé, empreintes des 40 fichiers d’origine et règles des primitives. |
| `validation/` | Copie inchangée du validateur historique et son rapport. |

Commence par lire `references/REGLES_PRIMITIVES_ET_CONDITIONS.md` et `matrice_audio/LISEZ_MOI_AUDIO.md`. Les fiches sont destinées aux ingénieurs : elles complètent les JSON mais ne les remplacent pas.

## État réel

**Les 30 fiches sont des propositions à valider, pas des profils approuvés.** Les paramètres numériques, repères et dispositions proposés ne sont pas des mesures extraites d’une vidéo de référence. Il n’y a ni référence visuelle fournie, ni rendu réel vérifié, ni moteur implémenté ici. Chaque fiche indique `A_APPROUVER` et `production_autorisee: false`.

**Aucun fichier de musique ou de bruitage n’est fourni.** Les neuf chemins WAV dans la banque sont des noms cibles, pas des fichiers existants. Les licences, preuves de droits, BPM mesurés, hashes de médias et points d’impact restent à établir à partir des vrais fichiers. Les 280 indications SFX sont réparties sur les 30 gabarits ; elles ne se jouent pas toutes dans une vidéo. Les 168 scènes sans SFX dans la source restent silencieuses sur ce point.

Une fiche de style complétée ou un contrôle technique réussi **ne suffit pas à autoriser la publication**. Il faut notamment approuver les références visuelles et les réglages, acquérir et vérifier les médias et droits, arbitrer les contradictions, puis tester le moteur et les rendus sur de vrais téléphones.

## Points à arbitrer avant publication

1. **T5, scène 10 des six secteurs :** la source dit `Prix sur demande`, la condition est `prix_est_saisi` et l’action demande le vrai prix. Aucun choix produit n’a été attribué ici. Si la condition est vraie, la fiche bloque jusqu’à décision. Si elle est fausse, ne montre pas la carte prix et ne joue pas son SFX ; conserve la durée uniquement avec un repli approuvé, sinon bloque.
2. **T4, ancien prix et rayure :** quatre scènes font référence au prix actuel alors que leur rôle parle d’ancien prix ou de rayure : `batiment_travaux_T4` scène 4 ; `coiffure_beaute_T4` scènes 3 et 4 ; `vetements_mode_T4` scène 4. Trois autres scènes de rayure portent le texte générique « À DÉCOUVRIR » : `immo_auto_T4`, `restaurants_maquis_T4` et `shops_small_business_T4`, scène 5, 4 et 4 respectivement. Ce sont des **points de vigilance à confirmer**, pas des corrections appliquées aux sources. Ne barre jamais le prix actuel par déduction ; bloque si le sens reste incertain.
3. Les replis, les ralentis sur prise, les dispositions et les animations doivent être acceptés avant usage. Un visage qui parle reste à **1×** avec sa propre voix. Une proposition de courbe `speed_ramp_x5` n’est pas la preuve qu’une rampe a été approuvée ou exécutée.

## Vérifier après extraction

Depuis la racine extraite, avec Python 3.9 ou plus :

```sh
python contrats_et_validation/valider_gabarits.py
python contrats_et_validation/valider_consolidation_v2.py
```

Le premier script est le validateur d’origine, inchangé. Il écrit `validation/rapport_validation.md`. Le second est un contrôle **additionnel**, sans modification des tests historiques. Il vérifie les liens, les 448 scènes, les repères et les conditions. Avec le paquet Python `jsonschema` installé, il vérifie en plus les schémas V2 et la correspondance V1.3 en mémoire ; sinon il l’indique et effectue quand même les contrôles métier disponibles dans la bibliothèque standard.

L’archive originale avait pour empreinte SHA-256 `d13b7dc938733972d3cde1db91aeac24e33eb2cdf8e6903130f693b8ff3cf786`. Le tableau `references/empreintes_40_fichiers_origine.csv` permet de vérifier séparément les 40 fichiers. C’est un inventaire d’intégrité, pas une signature de l’éditeur.

## Contrats et reçu local

`plan_rendu_v2_0.schema.json` décrit un plan **prêt après vérifications**, pas un plan réellement prêt fourni par cette archive. `video_license_receipt_v2_0.schema.json` décrit le reçu local à émettre **après un export réel réussi**. Aucun `video_license_receipt.json` signé n’est fabriqué ici. Voir `contrats_et_validation/RECU_LOCAL_ET_EXPORT.md`.

Les 30 fiches utilisent un **nouveau schéma de proposition V2 sans `null`**. Le schéma historique `profil_style_v1_3.schema.json` est conservé intact ; certains `null` y sont obligatoires pour les données non applicables ou inconnues. La correspondance explicite est dans `contrats_et_validation/PASSERELLE_PROFIL_V1_3_V2_0.md`. Ne change pas le numéro de version pour faire croire qu’une fiche V2 est directement compatible V1.3.
