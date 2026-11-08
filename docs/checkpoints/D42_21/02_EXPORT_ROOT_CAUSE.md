# D42.21 — 02. CAUSE RACINE EXPORT (état du diagnostic au 08/11 ~01:30)

## Position du problème
Deux échecs consécutifs du job **android-e2e-p1 (voie DEBUG)** sur mes commits
D42.21 (`6b7c396` run 42413207174, `c242d99` run 42418783843) : l'export ne
démarre jamais (`P1_export_lance` FAIL → cascade notif/écran éteint/40 min/MP4).

## Ce qui est ÉTABLI (preuves artefacts analysées avant la perte du workspace,
## extraits conservés dans le journal de mission)
1. **Ce n'est PAS une régression D42.21** : le job P1-debug n'a **jamais** été
   vert depuis sa création (06/11 soir). Les runs pré-D42.21 (`bce7556` 07/11
   09:01, `0295a35`, `800be19`, `a6e4521`, `26fdfea`, `8af1c10`…) échouaient
   TOUS — mais en **22–24 min** (échec plus tôt dans le parcours), tandis que
   mes cycles échouent en **60–61 min** : mes builds vont **le plus loin jamais
   atteint** (30 PASS jusqu'à `P1_apercu_valide`) puis gèlent au lancement.
2. **Chronologie cycle 3** (`c242d99`, depuis logcat artefact 13594745867) :
   - 22:18:01 écran E8 affiché ; `preparationJob` lancé (IO) ;
   - 22:19:37.56 premier accès SQLite du processus (thread 2404) ;
   - 22:19:37.66 `D42-TRACE 3.beatsheet` — **la préparation fonctionne** ✓ ;
   - 22:20:51 écran éteint (test harnais « Sleep timeout! Sleeping now. ») ;
   - après : **zéro log applicatif en 40 min**, process VIVANT (meminfo :
     heap alloué), thread principal répond aux dumps uiautomator ;
   - dump final : bouton `export_start` `enabled=true clickable=true`
     bounds [66,1642][1014,1774] ; statut PAS « Export local en cours… »
     (22 car., serait visible) ni message de refus (serait visible) ;
     le texte initial `export_t1` (84 car.) était hors du filtre regex utilisé
     — présence probable mais non prouvée.
3. **Contradiction non résolue** : `gateThen` désactive le bouton en premier ;
   s'il avait tourné sans décider, le bouton serait `enabled=false` au dump.
   `enabled=true` + statut initial ⇒ **soit le clic n'a jamais atteint le
   listener, soit l'activité a été recréée** (nouveau bouton, coroutine morte).
   L'hypothèse « gel de la porte après réservation » (SQLite 22:19:37 =
   réservation) n'est pas exclue : l'accès SQLite observé peut aussi bien
   être celui de la PRÉPARATION (Room première ouverture lente).
4. **La voie de référence est la voie RELEASE** : le défaut D42.18 a été prouvé
   sur `release-official-e2e` tag `d42.18-rc9` (run 42387189875, APK signé :
   34 PASS / 2 FAIL — export DÉMARRÉ, MP4 8,5 Mo extrait, muet). C'est sur
   CETTE voie que le retournement « muet → audio » doit être prouvé
   (tag `d42.21-rc*`).
5. Ancien run de référence chronologie (release) : écran E8 affiché →
   tap ~+90 s (navigation harnais lente) → préparation ~17 s POST-TAP sur le
   thread principal → trace → worker → FGS, le tout dans la fenêtre 25 s du
   harnais. Sur la voie DEBUG, la même chaîne dépasse la fenêtre (SQLite
   première ouverture ~+90 s à elle seule) : **la voie debug est structurellement
   trop lente pour la fenêtre du harnais**, indépendamment de D42.21.

## Ce qui a été corrigé au passage (déjà poussé dans `c242d99`)
- Préparation lancée dès l'affichage E8 (IO) + statut « Export local en
  cours… » immédiat au tap (avant `join`) + requête WorkManager bornée 15 s
  dans `reconcileOrphelines`. Améliorations réelles (UX + robustesse), sans
  effet sur l'issue P1-debug (gel antérieur à la porte ou clic non livré).

## Données manquantes pour trancher (a) vs (b)
- arbre COMPLET du dump final (chevauchement au point de tap) ;
- logs du job (horodatages exacts du harnais : moment du tap) ;
- events InputDispatcher autour du tap ; traces de recréation d'activité.
→ **Tous dans les artefacts/runs GitHub — téléchargeables uniquement avec le
jeton (401 anonyme). Le jeton a été perdu dans la 5e effacement du workspace
(.d42_secrets non persisté).**

## Décision
1. Demander le jeton au fondateur (accès indispensable : artefacts, push,
   tags, release, déploiement).
2. Poursuivre le diagnostic (a)/(b) sur les artefacts une fois le jeton reçu.
3. Preuve du correctif audio = voie release (étage 1 `d42.21-build-*` →
   re-signature locale → étage 3 `d42.21-rc*`), la même qui a prouvé le défaut.
4. La voie P1-debug restera rouge tant que sa cause structurelle (fenêtre 25 s
   vs lenteur debug) n'est pas traitée — traitée SÉPARÉMENT, jamais en
   contournant une protection.

---

# MISE À JOUR FINALE (08/11 ~01:45) — CAUSE RACINE ÉTABLIE, (a)/(b) TRANCHÉS

Le nouveau jeton (fourni par le fondateur 08/11 ~01:30) a permis de télécharger
l'artefact 13594745867 ET le log du job 128542514229. Verrouillage définitif.

## Chronologie exacte (job log + logcat croisés)

| Heure | Fait | Source |
|---|---|---|
| 22:19:41.03 | `P1_apercu_valide` PASS — « Créer ma vidéo » actionné, E8 affichée | job log |
| 22:19:35→23:03 | `WindowManager: removeWindowToken` en boucle (~1/3,1 s) = dumps uiautomator | logcat |
| 22:19:37.56 | SQLite (t.2404) — première ouverture Room (prep) | logcat |
| 22:19:37.66 | **trace D42-TRACE prep IO terminée — AVANT le tap** | logcat |
| ~22:19:52–58 | fenêtre du tap `input tap` (dumps de `revele`/`cmd_tap` à 22:19:52.4 et 22:19:55.5) | logcat |
| 22:20:26.61 | `P1_export_lance` FAIL (« bouton révélé, tap émis, aucun statut ») | job log |
| 22:20:46.64 | `P1_notif_fgs` FAIL | job log |
| 22:20:51.32 | « Sleep timeout! Sleeping now. » — écran éteint PENDANT les sondes | logcat |
| 22:21:36+ | réveil, sondes `P1_ecran_etaint` → FAIL 22:23:12 | job log |
| 22:23→23:03 | attente 40 min `P1_export_termine` → FAIL ; dump 29 : bouton enabled=true, statut initial | artefact |

## Preuve décisive : la tempête de dumps

**1020 dumps uiautomator en 55 min (22:08:28 → 23:03:25), 1 toutes les 3,1 s,
SANS interruption — y compris pendant l'attente de 40 min.** (Comptage
`removeWindowToken` dans le logcat : chaque dump crée/supprime un token.)

Chaque dump force le thread UI de l'app à traverser tout l'arbre d'accessibilité
sous verrou, sur un émulateur x86_64 déjà lent. Le tap du bouton « Lancer
l'export local » (centre [540,1708], bouton UNIQUE cliquable, `enabled=true
clickable=true`, AUCUN chevauchement au point de tap — vérifié sur l'arbre
complet du dump 29) a été émis dans cette tempête : le clic n'est jamais parvenu
au listener `enqueue()`. Le thread UI était vivant (il a servi les 1020 dumps)
mais l'événement n'a pas été livré/traité.

## Tranchement

- **(b) recréation d'activité : EXCLUE** — aucune trace ActivityTaskManager ni
  changement de configuration après 22:18 ; dump final = état E8 stable.
- **(a) tap non livré : CONFIRMÉE** — zéro log applicatif après 22:19:37.66
  (aucun WM-, aucun vv_export, aucun BgmStore, statut jamais modifié), bouton
  resté enabled (gateThen l'aurait désactivé en premier s'il s'exécutait).
- **La prep n'est plus en cause** : terminée à 22:19:37.66, AVANT le tap
  (~22:19:55). Le correctif E8 de `c242d99` a fonctionné.

## Conclusion définitive

**Défaut d'infrastructure harnais/émulateur (tempête de dumps + lenteur debug),
PAS un défaut applicatif.** La voie release (R8, app plus rapide) passe la
course de timing (preuve : 42387189875/d42.18-rc9 — export démarré, MP4 extrait
avec le MÊME harnais). La voie P1-debug n'a jamais été verte depuis sa création
(pré-D42.21 : échecs en 22–24 min, plus tôt dans le parcours ; cycles D42.21 :
60–61 min, 30 PASS = le plus loin jamais atteint).

**La preuve du correctif audio se prend sur la voie release**
(`d42.21-build-1` → re-signature locale → release `d42.21-rc-audio-v1` →
étage 3 e2e-official), sans toucher aux protections, sans correctif cosmétique
de l'app, et sans cycle debug supplémentaire (règle : un cycle CI par
correctif). Amélioration harnais (espacer les dumps pendant les attentes
longues) : documentée en D1 de 08_OPEN_DEFECTS.md, hors périmètre D42.21.
