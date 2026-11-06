# D42.14 — Parcours Android (P0 / P1) et cause racine des faux résultats

## 1. Ce que le harnais a produit, run après run

| Run (miroir) | Commit | Ce que le harnais a déclaré | Ce qui était vrai |
|---|---|---|---|
| 42189554849 | `7bcc41f` | `PASS=7 FAIL=5 BLOCKED=8`, dont **`P1_activite` PASS** | l'application était encore sur l'écran d'authentification : **faux PASS** |
| 42196966694 | `382652a` | langue PASS, connexion FAIL | l'application démarrait en **anglais** (langue système) — attente française |
| 42202009301 | `9e6e0de` | 4 langues : 11 PASS chacune | ✅ vrai (après correctifs) |
| 42205571080 | `605c704` | 18 PASS / 3 FAIL / 8 BLOCKED | brief affiché ✅, validation ✗ |
| 42208901429 | `390c0a2` | idem | champ requis « Quartier et ville » jamais rempli |
| 42212817413 | `a717f48` | **`P1_export_termine` PASS** | faux : « Vidéo prête **à publier en 30 secondes** » (slogan du carrousel) satisfaisait la recherche |
| 42219775013 | `4e8c140` | `PASS=18 FAIL=3 BLOCKED=7` | 4 appuis RETOUR ont ramené l'app du brief au catalogue |
| 42223776656 | `4e8c140` | idem | valeurs saisies décalées : `AkpakpaCotonou` est allé dans « Prix » |

## 2. Les six causes racines (toutes corrigées)

| # | Défaut du harnais | Symptôme | Correction |
|---|---|---|---|
| 1 | Comparaison de libellés en **sous-chaîne** : « Continuer » ⊂ « Continuer sans compte » | faux PASS, 8 contrôles `BLOCKED` | `--exact` dans `ui.py` (`find(..., exact=True)`) |
| 2 | Un `tap` réussi comptait comme **passage d'écran** | PASS sur un écran jamais atteint | `etape()` : PASS seulement après constat du **marqueur de l'écran suivant** |
| 3 | Libellés supposés en **français** alors que l'app suit la **langue du système** | 4 FAIL artificiels | `etape_any` avec les 4 libellés officiels (`values-<langue>`) |
| 4 | Fin d'export cherchée en **sous-chaîne** (« Vidéo prête ») | faux PASS d'export | chaîne **complète et exacte** `Vidéo prête ! Partage-la avec tes clients.` |
| 5 | `input keyevent 4` pour fermer le clavier | **navigue en arrière** quand le clavier est fermé → retour au catalogue | `fermer_clavier()` : RETOUR **seulement si** `mInputShown=true` |
| 6 | Champs remplis **par index** | l'écran défile → valeurs dans le mauvais champ, prix invalide | `ui.py champs` (libellé du champ) + valeur **valide par type** |

Plus une correction de robustesse : `ui.py tap` retombe sur le **bouton pleine largeur du bas**
quand Compose expose un texte avec des bornes nulles `[0,0][0,0]` (cas réel du bouton `Continuer`).

## 3. Parcours réellement prouvés sur émulateur (APK debug)

| Étape | Statut | Preuve |
|---|---|---|
| Installation + paquet `video.vitrine.app` `0.8.0-b0` | PASS | `P1_paquet` |
| Écran de langue → choix → écran de connexion | PASS | `P1_ecran_langue`, `P1_ecran_connexion` |
| Repli sans compte (session locale, aucun appel réseau) | PASS | `P1_session_locale` (écran d'authentification **quitté**) |
| Carrousel 1 / 2 / 3 (slogans distincts vérifiés) | PASS | `P1_carrousel_1/2/3` |
| Écran d'activité + `Continuer` (libellé entier) | PASS | `P1_activite`, `P1_activite_continue` |
| Étape parrainage localisée | PASS | `P1_parrainage` |
| Catalogue + gabarit **entièrement visible** + sélection | PASS | `P1_catalogue`, `P1_gabarit_visible`, `P1_selection_gabarit` |
| Formulaire de brief affiché (**5 champs de saisie détectés**) | PASS | `P1_brief` |
| Brief validé → `Avant de commencer` | **FAIL** | bouton actionné, écran de vérification absent |
| Caméra → prises → export → MP4 → partage | `BLOCKED` | dépend de la validation du brief |

## 4. Ce que le brief exige réellement (relevé dans le code et sur l'écran)

`GabaritBriefScreen.kt` : un seul écran défilant, bouton `Continuer` **désactivé**
tant que `filled != requiredIds.size` ou qu'un champ est invalide.

| Champ requis (gabarit « Nouvel arrivage ») | Remarque |
|---|---|
| Nom de ton commerce * | |
| Ton numéro whatsapp * | format international exigé (`+229…`) |
| Nom du vêtement * | libellé variable selon le secteur |
| Prix * | **numérique uniquement** — « Saisis un nombre, sans lettres (ex. 15000) » |
| Monnaie * | **préremplie** `FCFA` |
| **Quartier et ville *** | **n'apparaît qu'après défilement** |

**Observation produit (à traiter, pas un artefact de test)** : un utilisateur qui remplit
le haut du formulaire voit un bouton grisé sans explication tant que « Quartier et ville »
n'est pas rempli — champ situé hors écran. Nielsen #1 (visibilité de l'état du système) :
le bouton devrait dire *ce qui manque*. Piste : libellé du bouton = « Il reste 1 champ : Quartier et ville ».

## 5. Statut honnête

| Objet testé | Statut |
|---|---|
| Parcours amont → sélection de gabarit (APK **debug**) | **PASS_EMULATOR** |
| Brief → caméra → export (APK **debug**) | **EN COURS** (run 42228009767) |
| Tous ces parcours sur la **RC6 signée** | **NOT_RUN** — voir `01_RELEASE_TESTS.md` |
| Capteur caméra physique | **NOT_RUN** — voir `09_PROTOCOLE_PHYSIQUE.md` |

> Aucun résultat de ce document n'est une preuve de la release : l'APK testée ici est
> `app-debug.apk`, reconstruite à chaque run (empreinte différente à chaque fois).


## Autotest du harnais (D42.14, ce tour)

Le harnais a été testé **sans appareil** par `tools/e2e/selftest_harness.py` (faux `adb`,
vrai `ui.py`) : **6/6 PASS**, dont deux contre-épreuves. Deux défauts de mesure corrigés
(mode `surface` mort, `surface_reelle` renvoyant la fenêtre entière) — voir
`11_AUTOTEST_HARNAIS.md`. Le prochain run CI mesurera donc réellement le parcours.

## Run 42241430727 (170ad89) — premier run au harnais corrigé

14 **PASS** (record) : langue, connexion, session locale, carrousel ×3, activité,
**`P1_activite_continue` PASS — le bouton « Continuer » de 1 px est désormais actionné**
(correctif `point_de_clic` validé sur émulateur réel), parrainage, permission caméra,
porte R4, aucun crash. 5 FAIL / 9 BLOCKED : l'échec s'est déplacé au **catalogue**.

Diagnostic par logcat (téléchargeable avec le jeton) : chaque écran d'orchestration était
démarré **deux fois** (recréation en course) ; l'instance périmée renvoyait un carrousel
vierge. Corrigé dans `c588993` (voir 07_OPEN_DEFECTS A1) — le run 42246994818 valide.

Les contrôles négatifs du brief (champs vides, prix invalide, retour arrière) sont dans le
harnais dès `94d8f9e` ; ils s'exécuteront dès que le catalogue sera de nouveau atteint.

## Run 42246994818 (c588993, correctif double-lancement) — 17 PASS, record

Le correctif du double lancement (A1) a été **validé sur émulateur réel** :

| Nouveaux PASS (jamais vus avant ce tour) | Signification |
|---|---|
| `P1_catalogue` | **catalogue atteint** — le blocage historique est levé |
| `P1_gabarit_visible` + `P1_selection_gabarit` | gabarit sélectionné |
| `P1_brief` (5 champs détectés) | formulaire de brief affiché |
| **`P1_brief_vide_refuse`** | Continuer sans données : formulaire conservé (ordre du fondateur) |
| **`P1_brief_retour`** | retour arrière : écran précédent atteint, brief ré-ouvert sans crash |
| **`P1_brief_invalide_refuse`** | prix « abc » : validation refusée |

Restait un échec **causé par le harnais lui-même** : le contrôle invalide laissait
« abc » dans le champ prix, et le remplissage valide ne traite que les champs vides
→ `P1_brief_valide` FAIL. Corrigé dans `918feaa` (le champ est vidé après le
contrôle) — le run 42252465240 déroule pour la première fois la chaîne complète :
catalogue → gabarit → brief → caméra → prises → export → MP4 → partage.

## Cause racine FINALE de l'échec de validation du brief (run 42252465240, 88e364e)

Le run 918feaa a porté le record à **21 PASS** mais `P1_brief_valide` échouait encore.
Les artefacts (dumps + `champs_apres.txt`) ont révélé le pot aux roses :

- les « valeurs » visibles dans le dump (« Robe wax », « Akpakpa, Cotonou ») étaient les
  **exemples/placeholder** de l'écran — pas nos saisies (« RobeWax », « Akpakpa ») ;
- `champs_apres.txt` : tous les champs **vides** (sauf la monnaie préremplie) ;
- `E2E champs remplis : 0` dans le log : `remplir_champ` échouait silencieusement.

**Un mot** : `remplir_champ` cherchait des lignes `E2E FIELD` alors que `$UI champs`
émet des lignes `E2E CHAMP`. L'awk ne trouvait jamais les coordonnées : **aucune saisie
n'a jamais eu lieu dans aucun run depuis l'introduction du remplissage par libellé.**
Le bouton Continuer était donc légitimement désactivé (champs requis vides) —
l'application avait raison, le harnais mentait par omission.

Corrigé dans `88e364e` (miroir) et `0c7a9f9` (branche privée, pour le `release-e2e`
de la RC6). Le run suivant est le premier où la saisie a réellement lieu.

## Run 42257226019 (88e364e) — 21 PASS, brief ENFIN validé, crash caméra découvert

**`P1_brief_valide : PASS — brief accepté → écran « Avant de commencer »`** : première
validation réelle du formulaire de tout le projet (le correctif FIELD/CHAMP a fonctionné —
les saisies ont réellement eu lieu). Le parcours a alors atteint l'écran de tournage pour
la première fois… et l'application a **crashé** (`FATAL EXCEPTION`, voir 07 A2) :
`Unable to find selected quality`. Corrigé dans `56676df` — le run suivant
(56676df) est le premier à potentiellement dérouler prises → export → MP4 → partage.
