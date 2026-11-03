# Rapport de consolidation V2.0

## Contrôles effectués

- Les 40 fichiers de l’archive d’origine ont été comparés octet pour octet ; les 30 JSON des gabarits sont inchangés.
- Validateur historique inchangé : **30 signatures distinctes, 435 paires, zéro erreur**. Il ne teste pas les nouveaux réglages artistiques.
- Les 30 fiches uniques sont conformes au nouveau schéma de proposition V2 et ne contiennent aucun `null`. Les deux dossiers de fiches contiennent les mêmes octets. Chaque fiche est liée à l’empreinte du gabarit correspondant et conserve les dix axes source.
- **448 scènes** contrôlées : séquence, source, texte, voix, durée, frontières cumulées à 30 i/s, primitives, boîtes, maintien du texte et conditions. Les 12 cartes parlées gardent l’image associée au guide vocal ; les quatre cartes avant/après pointent vers les prises avant et après.
- **30** plages BPM, rôles de montée et scènes de drop conformes aux JSON. **280** indications SFX et **neuf** catégories, avec repères candidats à 30 i/s et 48 kHz ; **168** scènes sans SFX ; **six** SFX prix conditionnels.
- Les **15 schémas d’origine** et le nouveau schéma de profil V2 passent le contrôle de forme JSON Schema 2020-12. Une correspondance provisoire vers V1.3 a été vérifiée en mémoire. La spécification OpenAPI copiée et ses références locales ont aussi été contrôlées : 18 chemins.
- Essais négatifs du nouveau schéma : champ de transition absent, `null` imbriqué, fausse approbation et effet vide sont refusés. Le validateur additionnel fonctionne aussi sans `jsonschema`, mais signale alors que les contrôles JSON Schema n’ont pas été exécutés.

Les résultats détaillés des deux scripts sont dans `sortie_validateur_historique.txt` et `sortie_validation_consolidation_v2.txt`. L’empreinte de l’ancien validateur est `7617215c2df815df5fa51b6ba237e631b4f20385e8c2464677304f9f30209447`.

## Ce que ces contrôles ne prouvent pas

Aucune référence visuelle, piste musicale, bruitage ou vidéo réelle n’est livré. Aucun BPM de fichier, point d’impact, droit, LUFS, true peak, synchronisation réelle, performance Android ou fidélité visuelle n’a été mesuré. Les courbes, mises en page et ancrages sont des propositions, non des résultats approuvés. Aucun export ni reçu local signé réel n’a été créé.

Les six scènes de prix T5 attendent une décision produit ; quatre autres scènes T4 présentent un conflit possible entre rôle et texte du prix, et trois cibles de rayure T4 demandent confirmation. Ces remarques ne changent pas les sources. Publication et exécution de production restent conditionnées à la revue et aux tests indiqués dans les documents de l’archive et le kit complet.
