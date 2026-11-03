# Correspondance des profils V2 proposés et du contrat historique V1.3

## Pourquoi deux formats

Les 30 fichiers de `fiches_style_v2_0/` respectent `profil_style_v2_0_proposition.schema.json` et ne contiennent **aucun `null`**, même dans les sous-objets. Une donnée non applicable est omise ou décrite par un état explicite, par exemple `ancre_sfx.present: false`. Une information inconnue utilise un état « à acquérir », « à mesurer » ou « non fournie », pas un faux identifiant ou un faux hash.

`profil_style_v1_3.schema.json` est la version historique **inchangée**. Elle exige notamment des champs pouvant être `null` lorsqu’ils ne s’appliquent pas ou que l’approbation est inconnue. Le nouveau format V2 n’est donc pas un profil V1.3 auquel on aurait changé artificiellement le numéro de version. Le second validateur teste une conversion V2→V1.3 **en mémoire**, avec statut `A_APPROUVER` ; il n’écrit pas de profils supplémentaires et ne les approuve pas.

## Correspondance explicite

Pour une conversion contrôlée, relire le JSON d’origine et vérifier son SHA-256 avant toute chose. Utiliser uniquement les champs autorisés par le schéma V1.3 : celui-ci interdit les propriétés supplémentaires à la racine et dans les scènes.

| Champ V1.3 | Origine ou règle |
|---|---|
| `schema_version` | `1.3` uniquement pour le document réellement converti. |
| `profil_id`, `gabarit_id`, `gabarit_sha256` | Fiche V2 liée au fichier source exact. |
| `statut` | `A_APPROUVER` tant qu’aucune approbation réelle n’existe. |
| `approbation_id`, `reference_visuelle_sha256` | `null` en brouillon ; pour un statut approuvé, identifiant réellement émis et hash calculé sur la vraie référence approuvée. Ne jamais utiliser de valeurs factices. |
| `axes_signature_source`, `style_visuel_source`, `etalonnage_source` | Relire les objets complets dans le gabarit. L’étalonnage d’origine peut lui-même contenir des `null` non applicables ; c’est permis dans ce format historique. |
| `scenes[].numero`, `role_json` | Numéro et rôle source correspondants. |
| `source_type`, `prise_id`, `carte_id` | Type et identifiant réels de `scene.source` ; l’identifiant non applicable devient `null` dans V1.3. |
| `transition_json`, `effet_json`, `animation_json`, `position_texte_json` | Identifiants exacts de la scène source. |
| `transition_parametres`, `effet_parametres`, `animation_parametres` | Copier les propositions de la scène après revue. |
| `carte_layout` | Disposition proposée pour une carte générée ; pour une prise, `null` dans la conversion historique. |
| `sfx_json`, `ancre_sfx` | Catégorie source et proposition d’ancre ; si le SFX est absent de la source, les deux champs deviennent `null`. |
| `condition_json` | Expression de condition exacte du gabarit, sinon `null`. Évaluer seulement les conditions reconnues. |

Les données additionnelles V2 — par exemple audio détaillé, alertes, coordonnées ou repères temporels — ne peuvent pas être déposées au hasard en propriétés supplémentaires V1.3. Elles restent dans la fiche V2 et les matrices, ou sont transférées dans les objets de paramètres autorisés selon une implémentation revue. La conversion ne règle pas les contradictions des sources.

## Porte d’approbation

Une fiche V2 reste `A_APPROUVER` ; son schéma décrit uniquement cet état proposé. Pour arriver à un profil d’exécution approuvé, il faut :

1. vérifier l’empreinte du gabarit, les dix axes, toutes les scènes et une **référence visuelle réelle** ;
2. revoir les dispositions, courbes, replis, sons, droits et contradictions de prix ; obtenir l’acceptation des responsables ;
3. émettre un identifiant d’approbation vérifiable et calculer le hash de la référence réelle ;
4. produire le profil d’exécution au format attendu par le moteur, puis vérifier son schéma, son hash et son contenu lié à la référence ;
5. interdire la publication tant que cette chaîne ou les tests de rendu ne sont pas complets.

Un schéma valide ne prouve ni que l’ID correspond à une vraie décision, ni que les pixels sont fidèles. Ne remplace pas ces vérifications par un booléen.
