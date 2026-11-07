# D42.16 — Défauts ouverts (08)

**Samedi 7 novembre 2026 — Agent 1** — statuts sans conversion.

## Corrigés ce tour (commit de ce dépôt)

| ID | Sévérité | Description | Statut |
|---|---|---|---|
| A5 | P1 (produit) | Commandes du guide de prise (« Refaire / Tourner / Suivant ») sous le pli, derrière la barre d'action classique — inaccessibles sans défilement impossible à terminer | CORRIGÉ (padding 180 dp) — **NON_TESTED** (pas de run) |
| H13 | P1 (harnais) | Guide jamais terminé : `tap --text "Suivant"` tape des bornes hors écran (code 0 trompeur), l'app reste sur PRISE 3/3, export jamais atteint | CORRIGÉ (`completer_guide()`) — **NON_TESTED** |
| H12 | P2 (harnais) | Partage : libellé attendu « Partager » ≠ libellé réel « Partager la vidéo » | CORRIGÉ — **NON_TESTED** |

## Hérités corrigés et validés par run 42292290440 (partiellement)

| ID | Description | Statut |
|---|---|---|
| A3 | Tempête UI MlKit (comptage publié à chaque frame → relayout/s → dumps uiautomator bloqués) | CORRIGÉ, VALIDÉ (les 2 prises précédentes échouaient pour d'autres causes liées ; exit passé de 4 à 2 FAIL) |
| A4 | Bouton d'enregistrement classique rogné à 40 px au bord bas | CORRIGÉ, VALIDÉ (même run) |
| H10 | Dumps uiautomator périmés (harnais aveugle après bind caméra) | CORRIGÉ, VALIDÉ |
| H11 | Porte R4 (dialogue « Accord du client ») non gérée par le harnais | CORRIGÉ, VALIDÉ |
| A1 | Double lancement d'activité (D42.14) | CORRIGÉ, VALIDÉ |
| A2 | Crash caméra « Unable to find selected quality » (D42.14, FallbackStrategy) | CORRIGÉ, VALIDÉ |

## Ouverts — non résolus

| ID | Sévérité | Description | Verrou |
|---|---|---|---|
| E1 | P0 | `P1_export_termine` / `P1_mp4_extrait` : la chaîne export n'a jamais été prouvée sur émulateur (cause amont corrigée ce tour, pas encore rejouée) | run de validation impossible sans jeton |
| E2 | P0 | Les 2 FAIL exacts du run `42292290440` ne sont pas constatés dans `results.tsv` (artefact non téléchargeable sans jeton) — ils sont inférés de l'analyse de code | idem |
| E3 | P1 | Inspection visuelle des planches contact du lot ja 3 (J3) non faite | idem |
| E4 | P1 | Caméra physique : jamais testée (l'émulateur ne prouve pas le capteur) — protocole `D42_14/09_PROTOCOLE_PHYSIQUE.md` prêt | fondateur |
| E5 | P2 | Workflow privé `release-e2e` bloqué par la facturation GitHub (défaut d'infrastructure, pas logiciel) — abandonné sur ordre du fondateur | fondateur (paiement) — aucune action demandée |

## Notes

- Le build du correctif A5 n'est pas compilé localement (pas de SDK dans le
  sandbox) : la compilation sera prouvée par le job CI du prochain push.
- Aucun défaut corrigé n'est masqué par le harnais : `completer_guide()`\
  enregistre `P1_guide_termine` en FAIL si le guide reste affiché.
