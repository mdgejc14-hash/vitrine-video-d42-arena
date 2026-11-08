# 08 — Défauts ouverts / connus (état D42.21)

**Date** : dim. 08/11/2026 — à figer dans le rapport final 20:00.

## D1 — Voie P1-debug : refus intégrité au lancement d'export (INFRASTRUCTURE HARNais, pas applicatif) — **RÉSOLU 08/11, correctif en validation**

> **MISE À JOUR 08/11 ~03:10** : la section ci-dessous (analyse du 08/11 ~01:45)
> est conservée pour l'audit trail mais sa conclusion « tap non livré / tempête
> de dumps » est **INVALIDÉE** — voir 02_EXPORT_ROOT_CAUSE.md §CORRECTION puis
> §RÉSOLUTION TOTALE. Résumé : le statut du dump final 29 (cycles 3 ET 4 —
> confirmé indépendamment sur 9203a27) = « Vérification de sécurité échouée… »
> (`export_gate_integrity`) : **le tap A été livré, IntegrityGuard a refusé**
> car l'image AOSP API 30 « default » embarque `/system/xbin/su` (révélé par
> le su_mask_proof.txt de la preuve A, artefact 13599235899). Le harnais
> officiel masque /system/xbin (bind-mount) ; le harnais lab ne le faisait
> pas. **Correctif D42.21-11 (3e96f0a)** : run_p1.sh aligné sur le même
> masquage — IntegrityGuard ni modifié ni contourné, certificat toujours
> contrôlé.
>
> **VALIDATION (run 42435516694, cycle 6, commit 3e96f0a)** : parcours P1-debug
> **36/36 PASS, 0 FAIL, 0 BLOCKED** — export lancé (« Export local en cours… »),
> notif FGS, écran éteint 45 s survécu, « Vidéo prête ! », MP4 extrait
> (9 156 375 octets, piste AAC stéréo 44,1 kHz NON-MUETTE vérifiée localement :
> RMS −53,3 dBFS, crête −27,3 dBFS — mêmes caractéristiques que la voie
> release), partage, aucun crash, APK sha256 377b0c65f49b…8148124. Le job est
> resté ROUGE uniquement à cause d'un **bug de workflow indépendant** : le
> bloc `for … done` multi-lignes du step ffprobe est exécuté LIGNE PAR LIGNE
> par l'emulator-runner (`sh -c` par ligne) → « Syntax error: end of file
> unexpected » (exit 2) APRÈS le résumé 36/36. **Correctif D42.21-12** : bloc
> remis sur une seule ligne (seul bloc touché ; P0/langues vérifiés sains).
> **Statut D1 : RÉSOLU ET VALIDÉ — cycle 7 (42437711684, e4b6c23) : SUCCESS,
9/9 jobs, android-e2e-p1 VERT au niveau job (première fois de l'histoire de
la voie). D1 peut être fermé.**

- **Symptôme** : cycles 2–3 D42.21 (runs 42391198712, 42418783843) — 30 PASS jusqu'à
  `P1_apercu_valide`, puis 5 FAIL (`P1_export_lance`, `P1_notif_fgs`, `P1_ecran_etaint`,
  `P1_export_termine`, `P1_mp4_extrait`) + 1 BLOCKED (partage). Aucun crash.
- **Cause racine démontrée (cycle 3, artefact 13594745867 + log job 128542514229)** :
  le harnais a exécuté **1020 dumps uiautomator en 55 min** (1 toutes les 3,1 s, y compris
  pendant l'attente de 40 min — cf. `WindowManager: removeWindowToken` en boucle dans le
  logcat). Chaque dump sérialise le thread UI de l'app (traversée de l'arbre
  d'accessibilité) sur un émulateur x86 déjà lent. Le tap `input tap` du bouton
  « Lancer l'export local » (~22:19:55) a été émis dans cette tempête : l'événement
  n'a jamais atteint le listener `enqueue()` (bouton `enabled=true clickable=true`
  au dump final 23:03, statut jamais modifié, zéro log applicatif après 22:19:37).
  *(— conclusion invalidée, voir l'encadré —)*
- **Chronologie verrouillée** : prep IO terminée 22:19:37.66 (trace D42-TRACE + SQLite
  22:19:37.56) — **AVANT** le tap → le correctif E8 (préparation déclenchée à
  l'affichage, pas au clic) a FONCTIONNÉ ; l'écran s'est éteint 22:20:51 (« Sleep
  timeout! ») pendant les sondes du harnais ; aucun WM-/vv_export/BgmStore jamais émis.
- **Ce n'est PAS une régression D42.21** : la voie P1-debug n'a **jamais** été verte
  depuis sa création (06/11) ; les runs pré-D42.21 (`bce7556`, 42357960775, échecs en
  22–24 min) échouaient PLUS TÔT ; mes cycles 60–61 min = le plus loin jamais atteint.
- **Référence contradictoire** : la voie release signée (42387189875, d42.18-rc9) passe
  le même parcours avec le même harnais (export démarré, MP4 8,5 Mo extrait) — l'app
  release (R8) gagne la course timing. **La preuve du correctif audio se prend donc sur
  la voie release** (`d42.21-build-1` → re-signature → `d42.21-rc-audio-v1`).
- **Traitement** : correctif harnais D42.21-11 poussé (3e96f0a) — alignement du
  masquage /system/xbin sur la voie officielle ; validation cycle 6
  (42435516694). Piste d'amélioration future (hors D42.21) : espacer les dumps /
  utiliser un wait par sondage logcat au lieu de dumps UI répétés pendant les
  attentes longues.

## D2 — Export release : rendu > 40 min sur émulateur (d42.18-rc9)

Le MP4 release exporté en rc9 n'a pas fini son rendu dans la fenêtre de 40 min du harnais
(`P1_export_termine` FAIL alors que l'export ÉTAIT démarré et le MP4 extrait/valide).
Défaut d'infrastructure CI (CPU émulateur), pas de l'app. Ré-évalué en rc-audio-v1.

## D3 — d42.18-rc9 : crédit réservé non libéré à l'échec du rendu

`P1_credits` FAIL sur 42387189875 : à l'expiration de la fenêtre de 40 min, le crédit
restait « réservé ». La logique de libération à l'échec existe (D42.8.1, testée JVM) mais
le cas « rendu toujours en cours à l'arrêt du harnais » ne l'a pas déclenchée (l'export
était vivant, pas échoué). Comportement attendu si le rendu finit par échouer ; à
surveiller en rc-audio-v1.

## D4 — Jeton GitHub exposé puis révoqué (résolu)

L'ancien PAT a été exposé dans un flux d'outil puis perdu au 5e effacement ; révoqué et
remplacé par le fondateur (08/11 ~01:30). Règles renforcées : umask 077, jamais dans
URL/commit, fichier seul.

## D5 — Divergences pistes production vs régénération locale (31, documentées)

564 pistes en production ; la régénération locale des 31 pistes « batiment » diverge des
originaux (T1×17 : v01,v03-v16,v18,v20 ; T2×9 : v01,v03,v06,v11,v12,v13,v15,v16,v18 ;
T3×5 : v03,v05,v10,v12,v14). **Décision fondateur : NE PAS remplacer les originaux** ;
divergences documentées dans `06_TEMPLATE_MUSIC_DIRECTION.md` (shas v2 dans D1/donnees).

## D6 — Test physique sur appareil réel : NON RÉALISÉ

Aucun appareil Android physique disponible ; toutes les validations E2E sont émulateur
CI (api 34, x86_64). À marquer NON TESTÉ dans le rapport final.

## D7 — Divergence main ↔ d42.13-lab (découverte 08/11 ~01:55, fusion DIFFÉRÉE)

- **Fait** : `git push d42.13-lab:main` rejeté (non-fast-forward). main (`a2a3c47`)
  contient **34 commits absents du lab** (synchros miroir « source privée » de l'ère
  D42.6 : MANIFESTE_MIROIR.md, docs/ALIGNEMENT_V2.md, docs/AUDIO_BGM_TELEVERSEMENT.md,
  retouches MainActivity.kt +7/-69, BgmStore.kt +20/-154, T2.json immo_auto/
  shops_small_business, gabarit_l10n_v1.json, gh_api.sh supprimé côté main,
  virtual-render-validation.yml…). Réciproquement le lab a 51 commits que main n'a pas
  (tout D42.13→D42.21 : audio v2, robustesse export, checkpoints).
- **Contenu chevauchant** : BgmSfxAudioMixer.kt et BgmSfxAudioMixerMultiRushTest.kt
  sont IDENTIQUES entre main et lab (diff vide) — les versions lab descendent bien
  du même état D42.6.
- **Décision** : NE PAS fusionner avant la chaîne release (BgmStore.kt est sur le
  chemin critique audio ; une fusion mal résolée détruirait la preuve A). La mémoire
  durable = branche lab + tags + releases (tous poussés/vérifiés). La fusion main←lab
  (ou main←merge) est à trancher par le fondateur avec l'analyse ci-dessus ; android-ci
  (tests 120, déclenché par main) restera donc non rejoué sur ces contenus en D42.21 —
  la non-régression export est couverte par l'étage 1 release-official-build
  (`:feature-export:testDebugUnitTest`) sur `d42.21-build-1`.
- **Impact rapport final** : item à marquer explicitement (main non synchronisé,
  divergence documentée, raison : protection de la preuve release).

## D8 — Déploiement Worker bloqué : secret CLOUDFLARE_API_TOKEN absent/vide (08/11 ~00:40)

- **Fait** : run 42430521024 (tag `worker-deploy-1`) — échec à « Vérification du
  schéma distant » : appels API Cloudflare = « Invalid format for Authorization
  header » (6003/6111) + « Authentication error » (10000) ; wrangler : « it's
  necessary to set a CLOUDFLARE_API_TOKEN ». Étapes déploiement + smoke : skipped.
- **État production** ( sondé 08/11 ~00:45) : Worker
  https://vitrine-video-api.mdgejcinfluence.workers.dev VIVANT — `/health` 200
  (service ok, D1 connected, schema ready, 8 tables, version 0.9.0) ; routes audio
  Phase C PRÉSENTES et protégées (`/api/v1/audio/catalog|library|track/*` → 401
  « A valid Firebase ID token is required » = comportement attendu sans JWT).
- **Manque en production** : les évolutions worker de `56e4717`/`c242d99`
  (07/11) — sélection par variation `/audio/track/{categorie}?v=N` (1..20,
  strictement EN_LIGNE de la catégorie) + sha256 servi par `/audio/library`,
  qui portent le scénario B complet. Vérification fonctionnelle distante
  impossible sans JWT Firebase (pas de compte de test à ma disposition — et
  je n'en fabrique pas).
- **Action fondateur requise** : renseigner le secret `CLOUDFLARE_API_TOKEN`
  (jeton Cloudflare avec droits Workers Scripts:Edit + D1:Edit sur le compte)
  dans les secrets du dépôt, puis pousser un tag `worker-deploy-2` (le jeton
  de mission n'a pas actions:write — le déclencheur tag reste la voie auditée).
- **Statut rapport final** : item 7 = PARTIELLEMENT VALIDÉ (code + tests JVM
  poussés et verts ; déploiement bloqué par secret ; production saine sur
  l'existant Phase C).

## D9 — API Security CI sur main : secrets Firebase absents (NOUVEAU 08/11, action fondateur)

- **Symptôme** : run 42442004667 (premier sur main depuis a2a3c47 — main était
  gelé, le workflow n'avait donc jamais tourné sur les commits D42.18-21) :
  `Configuration CI manquante : FIREBASE_WEB_API_KEY` → exit 1. Les 5 env
  Firebase sont vides.
- **Secrets requis** (api-security-tests.yml l.217-221) : `FIREBASE_WEB_API_KEY`,
  `FIREBASE_TEST_A_EMAIL`, `FIREBASE_TEST_A_PASSWORD`, `FIREBASE_TEST_B_EMAIL`,
  `FIREBASE_TEST_B_PASSWORD`.
- **Ce n'est PAS un échec de code** : le harnais de sécurité refuse de tourner
  sans identités de test. Même classe que D8 (secret manquant).
- **Traitement** : action fondateur — ajouter les 5 secrets, puis re-pousser
  sur main (ou re-tag) pour relancer. Le reste du workflow (worker local,
  base, migrations) est vert jusqu'à cette étape.

## D10 — android-ci sur main : detekt MaxLineLength (RÉSOLU D42.21-14)

- **Symptôme** : run 42442004666 : `:feature-camera:detekt FAILED` — UNE ligne
  de 155 car. (CameraGuideActivity.kt:269, log « verrou 3A sauté »).
- **Contexte** : code antérieur à D42.21 (module feature-camera intact durant
  toute la mission) ; jamais détecté car android-ci ne se déclenche que sur
  main, gelé à a2a3c47 depuis le début de D42.18.
- **Correctif D42.21-14** : ligne wrapped (contenu identique, pure mise en
  forme) — validation par le android-ci suivant.
