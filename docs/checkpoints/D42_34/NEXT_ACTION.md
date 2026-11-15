# PROCHAINE ACTION — D42.34 (phase visuelle)

**Lot A TERMINÉ** (rollback #13 récupéré, workspace 45 Mo, e16d112 resynchronisé).

**Lot B — inventaire exhaustif des écrans** (en cours) :

1. Énumérer Activities + écrans Compose + dialogues + états distincts depuis
   le code (manifests, navigation, composables) — parcours A→M de l'ordre.
2. Extraire les 16 maquettes fondateur (déjà dans le dépôt :
   `docs/checkpoints/D42_33/SOURCES/maquettes/`) pour comparaison PIL.
3. Écrire `11_INVENTAIRE_COMPLET_ECRANS.csv` (colonnes §4 de l'ordre).
4. Commit + push.

Puis Lot C (audit fidélité 10_*.md), D (images originales générées),
E (corrections design), F (galerie README unique + manifeste),
G (validation + 13_*.md).

Rappels : workspace ≤ 100 Mo (clone partiel — ne pas re-cloner en complet) ;
captures Robolectric par familles, push par lots ; build local = swap 2 Go +
sed 1024m/640m + `git checkout gradle.properties` avant commit ; CI pour la
validation lourde. Vision d'images INDISPONIBLE — audit programmatique honnête.

Journal : [00_PLAN_ET_ETAT.md](00_PLAN_ET_ETAT.md)
