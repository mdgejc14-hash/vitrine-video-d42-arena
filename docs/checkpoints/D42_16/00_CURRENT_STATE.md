# D42.16 — État courant (00)

** vendredi 6 novembre 2026, ~21 h 20 UTC — Agent 1**

## Décisions exécutées dès la reprise

1. **Workflow privé `release-e2e` ABANDONNÉ** (ordre du fondateur, preuve
   visuelle fournie : `The job was not started because recent account payments
   have failed or your spending limit needs to be increased.`). Aucune relance,
   aucun commit de déclenchement, aucune tentative de contournement.
2. **Les Actions du miroir public fonctionnent toujours** : le run
   `42281822052` (poussée `f148092`, 19:41 UTC) s'est exécuté et complété APRÈS
   l'apparition du blocage facturation côté privé. Le blocage est lié aux
   minutes payantes du dépôt privé, pas au compte public. La boucle de
   qualification continue donc sur `mdgejc14-hash/vitrine-video-d42-arena`,
   branche `d42.13-lab`, runners gratuits publics.
3. **Émulateur local impossible dans le sandbox** : pas de KVM, pas de SDK, 2
   vCPU / 1,9 Go. Le laboratoire distant reste la seule voie E2E (autorisation
   D42.13 toujours valable).
4. **Jeton** : le PAT exposé (9 fois) reste rangé dans `~/.d42_secrets/
   gh_token.txt`, usage par fichier uniquement (`tools/gh_api.sh`), jamais
   affiché ni committé. Il sert uniquement là où l'anonyme est impossible
   (téléchargement d'artefacts, poussées git, vérifications distantes) — le
   quota anonyme de l'IP du sandbox est épuisé (0/60). **Révocation à la fin
   de la mission** (rappel prévu dans le rapport final).

## État vérifié avant toute modification

- Clone `lab` : branche `d42.13-lab` à `f148092` (poussée, vérifiée API),
  propre, aucun stash.
- Miroir : 25+ commits D42.14 confirmés présents ; dernier run e2e-lab
  `42281822052` = 23 PASS / 4 FAIL / 4 BLOCKED (code identique à `575baba`
  pour l'app).
- Privé : branche `d42.14-critical-paths` à `c8e04c1` (sync harnais + fix
  complétion). Git push vers le privé reste possible (la facturation ne bloque
  pas git, seulement les jobs Actions).
- Artefacts D42.14 conservés (`/home/user/D42_14/`, bundle
  `d42.14-commits.bundle`).
- RC6 vérifiée localement (SHA-256 `5c395573…c377495`, signature v2) —
  inchangée, preuves dans `D42_14/rc6/`.
- **Keystore de signature présent localement** (`~/keystores/vitrine.keystore`
  + `signing.properties`) : une release signée identique à RC6 reste possible
  sans le runner privé (build miroir non signé + signature locale apksigner),
  à condition que le correctif caméra soit validé d'abord.

## Dernier verrou P0 (repris tel quel)

`P1_prise_1/2` FAIL — « appui sur le bouton sans passage en enregistrement »
(runs `42278038365` et `42281822052`, écran caméra atteint, aucun crash).

→ Diagnostic complet dans `01_ROOT_CAUSE_CAMERA.md` (cause racine identifiée
et prouvée sur les DEUX runs : tempête UI MlKit + dumps périmés + porte R4
non gérée + bouton rogné). Correctifs appliqués dans le commit associé.

## Rendus 120 — lot ja 3

Le run `42250114616` (branche `d42-render-check`) était encore `in_progress`
au relevé de 20 h 30 UTC. Vérification de son issue prévue avant livraison
(voir `06_120_COMBINATIONS.md`).
