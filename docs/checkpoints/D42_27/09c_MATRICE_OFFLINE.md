# D42.27-09c — MATRICE OFFLINE (§9, audit J)

**Sources de preuve** : banc `tools/e2e/run_offline.sh` (OFF1–OFF12, run
e2e-lab job `android-e2e-offline`, 14 tests), banc `tools/e2e/run_drafts.sh`
(S2 reprise hors connexion, job `android-e2e-drafts`), P1 (parcours complet
en ligne), tests JVM réseau 3.11. Aucun test n'est déclaré sur la seule
existence d'un écran : chaque ligne cite sa preuve exécutable.

## 1. Matrice par étape critique du parcours

| Étape | Accessible sans Internet | Cache/stockage local | Connexion requise pour aboutir | Perte réseau pendant l'étape | Retour réseau | Preuve |
|---|---|---|---|---|---|---|
| Lancement / langue | OUI (assets) | — | non | pas d'effet | — | OFF1, OFF2, OFF3 |
| Écran connexion | OUI | — | Google réel (API B) : oui · repli démo : non | tentative Google sans crash, message actionnable | l'auth Google aboutit après retour (compte physique requis pour le choix de compte) | OFF4, OFF4b, A2 (banc auth) |
| Repli « Utiliser sans Internet » | OUI (session locale) | prefs `vv_session` | non | pas d'effet | — | OFF5 |
| Carrousel / activité / parrainage | OUI (assets) | — | non | pas d'effet | — | OFF6, OFF7 |
| Bienvenue / crédits démo | OUI (seed local) | seed 30 gabarits (assets) | non (démo : crédits locaux) | pas d'effet | — | OFF8 |
| Catalogue 30 gabarits | OUI | Room `gabarits_cache` (v2, migration additive) + seed | non | pas d'effet | — | OFF9 |
| Brief (saisie) | OUI | **brouillon Room `project_draft` (D42.27-05)** : chaque champ persisté | non | saisie continue hors ligne | — | drafts S1 (CI job drafts) |
| Brief validé → guide | OUI | brouillon étape CAMERA (script/scènes) | non | pas d'effet | — | drafts S2 |
| Tournage (prises) | OUI | fichiers `filesDir/rushs` + index brouillon | non | **reprise hors connexion prouvée** (force-stop sans réseau → dialogue → PRISE 2/3, rush conservé) | — | drafts S2 (preuve run-as fichiers) |
| Montage / aperçu | OUI | rushs locaux | non (rendu local) | pas d'effet | — | drafts S3, camerap B |
| Export final (MP4) | rendu local ; télémétrie/uploads best-effort | fichier export + `export_journal` | non pour le fichier ; uploads best-effort | export continue, uploads en attente | uploads/télémétrie reprennent (best-effort, jamais bloquants) | P1 (36/0/0, en ligne) ; export intégral hors ligne : voir §2 |
| Session après redémarrage | OUI | prefs + Room | non | pas d'effet | — | OFF10, OFF10b |
| Stabilité au retour réseau | — | — | — | — | app vivante, aucun crash | OFF11, OFF12, drafts S4 |

## 2. Limites honnêtes (NOT RUN / PARTIAL)

- **Export final 100 % hors ligne, bout-en-bout** : le P1 prouve l'export
  complet EN LIGNE ; le banc drafts prouve le montage + écran d'aperçu hors
  connexion. Un run « export complet sans réseau du début à la fin » n'a
  pas été exécuté au lab (les uploads best-effort ne bloquent pas le
  fichier, preuve code + garde StatFs, mais la preuve e2e dédiée manque) —
  **PARTIAL**.
- **Sync après retour réseau** : les mécanismes (télémétrie outbox,
  parrainage sync, droits best-effort) sont prouvés par les bancs API/serveur
  (8.3–8.7, backend-http, tests JVM 3.11), pas par un e2e complet
  coupure/retour en cours d'export — **PARTIAL** (preuves serveur solides,
  preuve e2e dédiée manquante).
- Auth Google aboutie hors ligne : impossible par nature (exige le réseau +
  un compte physique) — **NOT RUN au lab** (documenté : compte fondateur).

## 3. Conclusion matrice J

Parcours marchand complet (langue → catalogue → brief → tournage →
montage/aperçu) : **accessible sans Internet de bout en bout**, avec
persistance locale à chaque étape (prefs, Room, fichiers) et reprise
inter-sessions même hors connexion (drafts). L'étape export produit le
fichier localement ; ses communications sont best-effort. Les deux lignes
PARTIAL ci-dessus sont les seules à ne pas disposer de preuve e2e dédiée —
elles sont proposées comme cibles d'un futur banc « offline-export »
(0 FCFA, runner CI existant).
