# D42.16 — Correctifs caméra/guide et validation attendue (02)

**Samedi 7 novembre 2026, ~06 h 35 UTC — Agent 1**

## Contexte

Run `42292290440` (`8af1c10`) : les correctifs A3/A4/H10/H11 ont réparé la
moitié des échecs (4 FAIL → 2 FAIL, exit 2). L'artefact `e2e-p1`
(id 13542450049) n'a pas pu être téléchargé (PAT compromis révoqué de l'usage
sur ordre du fondateur ; téléchargement anonyme = 401) — les 2 FAIL exacts
restent donc INFÉRÉS de l'analyse de code, pas constatés dans `results.tsv`.

## Analyse de code (vérifiée dans les sources publiques)

- Le gabarit « Nouvel arrivage » (`shops_small_business/T2.json`) exige
  **3 prises** ; le harnais n'en filmait que 2.
- `PriseControls` (« Refaire / Tourner / Suivant ») est en BAS d'une colonne
  Compose défilante : viseur `aspectRatio(9f/16f)` pleine largeur (~640 dp) +
  cartes ⇒ commandes sous le pli, **derrière la barre d'action classique**
  (bouton « Verrouiller et enregistrer » + texte de guide).
- `ui.py::cmd_tap` tape le centre des bornes **même hors écran** et renvoie 0 :
  le `tap --text "Suivant"` « réussissait » en tapant dans le vide. Le guide
  n'était jamais terminé (app sur PRISE 3/3), l'aperçu/export jamais atteint
  ⇒ `P1_export_termine` et `P1_mp4_extrait` FAIL par timeout (8 min).

## Correctifs appliqués (ce commit)

| Défaut | Correctif | Fichier |
|---|---|---|
| A5 — commandes du guide inaccessibles (sous le pli, derrière la barre) | réserve de défilement `padding(…, bottom = 180.dp)` sur la colonne du guide ; aucun bouton supprimé ; cercle « Tourner » et bouton classique conservés (même `onRecord()` gardé contre la double capture par `priseEnCoursDeFinalisation` / `recording != null`) | `feature-camera/.../PriseGuideScreen.kt` |
| H13 — guide jamais terminé par le harnais | `completer_guide()` après la boucle de prises : compte les `rush-*.mp4` réels (`run-as ls files/rushes`), filme les prises manquantes via le bouton classique (max 4 cycles, porte R4 gérée), fait défiler la colonne, **vérifie la visibilité réelle de « Suivant » avec `inside`**, clique le libellé exact, vérifie l'écran SUIVANT (marqueur `P1_guide_termine`), capture les preuves | `tools/e2e/run_p1.sh` |
| H12 — libellé de partage erroné | « Partager » (exact) → **« Partager la vidéo »** (libellé réel `export_share`) | `tools/e2e/run_p1.sh` |

## Non-régression exécutée localement

- `bash -n tools/e2e/run_p1.sh` : OK.
- Autotest du harnais : **9/9 PASS** (S0–S7b, faux adb).
- Ciblage hors appareil : **3/3 PASS**.
- Les suites security (64), auth (22) et backend-http (15) ne sont pas
  rejouées : aucun code concerné n'a changé (règle D42.16 §7).

## Validation attendue (PAS ENCORE EXÉCUTÉE)

Le correctif Kotlin n'est **pas compilé localement** (pas de SDK Android dans
le sandbox) et le parcours n'est **pas rejoué** (pas de jeton pour pousser /
déclencher la CI). Statut : **NOT_TESTED** jusqu'au prochain run
`android-e2e-lab` sur ce commit. Preuves attendues : build vert,
`P1_prise_1/2` PASS, `P1_guide_termine` PASS, `P1_rushs_fichiers` PASS,
puis S25+ (`P1_apercu_export`, `P1_export_lance`, `P1_export_termine`,
`P1_mp4_extrait` + ffprobe, `P1_partage`).
