# D42.18 — État de la mission

Mission : exports longs fiables (WorkManager), protocole appareil physique,
partage, crédits, release. Ne rien recommencer des acquis D42.17.

## Incident de persistance (07/11, entre deux tours)

Le snapshot de fin de tour (plafond ~128 Mo / 10 000 fichiers) a perdu le
dépôt git local (`.git`), les artefacts volumineux D42_17 (run_*) et une
partie de l'arbre lab16 — dont le commit local d8fbbb2, **non poussé**.
Récupération complète : le distant GitHub était intact jusqu'à 5e705f4,
le contenu de d8fbbb2 a été régénéré à l'identique depuis la trace de la
conversation (code + tests + 6 documents, compteurs vérifiés) et re-committé.
Leçon appliquée : **pousser immédiatement chaque étape** ; les gros fichiers
restent sur GitHub (releases/artifacts), jamais en doublon local.

## Avancement

- [x] P1 diagnostic complet (01_DIAGNOSTIC_WORKMANAGER.md) — cause rc8
      confirmée dans le code : CoroutineWorker SANS setForeground → job
      JobScheduler soumis au quota ~10 min ; WorkManager relance le WorkSpec
      (même id) depuis le début ; média3 Transformer ne reprend pas à mi-encode.
- [x] P1 décision d'architecture (02_DECISION_ARCHITECTURE.md) : promotion
      FGS dataSync via setForeground — corrige la promesse T1 déjà affichée
      à l'utilisateur (export_t1 : « éteins ton écran, la notification te
      prévient ») aujourd'hui non tenue.
- [x] P1 correctif minimal implémenté : ExportWorker.setForeground +
      ForegroundInfo(dataSync) + canal + notification + icône ;
      manifeste : FOREGROUND_SERVICE, FOREGROUND_SERVICE_DATA_SYNC,
      POST_NOTIFICATIONS + override SystemForegroundService(foregroundServiceType
      =dataSync). AUCUN autre composant modifié.
- [x] P1 tests de non-régression (Robolectric) : ExportForegroundInfoTest
      (canal idempotent, type dataSync, contenu notification, ongoing).
- [x] P3 audit statique du partage (03_AUDIT_PARTAGE.md) : ACTION_SEND +
      MIME video/mp4 + FileProvider(cache-path) + FLAG_GRANT_READ_URI_PERMISSION
      + createChooser + <queries> — aucun défaut statique ; reste à prouver
      en exécution réelle (physique/CI).
- [x] P2 protocole de test physique rédigé (04_PROTOCOLE_TEST_PHYSIQUE.md)
      — À EXÉCUTER PAR LE FONDATEUR ; aucun test physique prétendu fait.
- [x] P5 analyse fiabilité crédits (05_FIABILITE_CREDITS.md) : code + preuves
      D42.17 ; points à re-vérifier à l'exécution listés.
- [ ] P1/P4 validation CI (build + tests + E2E rc9) : EN COURS — PAT
      réautorisé par le fondateur (07/11), publication en cours.
- [ ] P6 release rc9 signée officiellement : en cours (même méthode D42.17).
- [ ] Rapport final + publication GitHub : à venir.

## Sécurité

PAT fondateur : usage strictement limité au dépôt miroir public
(mdgejc14-hash/vitrine-video-d42-arena), branche d42.13-lab ; fichier
chmod 600 hors dépôt, jamais en clair dans commandes/logs/commits ;
suppression + confirmation à la fin des opérations. Keystore officiel et
mots de passe : jamais publiés, jamais extraits. IntegrityGuard : intact.
Budget : 0 FCFA — aucune action payante.

## Cycle rc9 (en cours)

- fbc78d9 : correctif FGS régénéré et poussé (récupération d'incident).
- commit suivant : workflows (tests unitaires au build, tags d42.18) +
  mesures harnais (notification, écran éteint, verdict crédits).
- Déclenchement : tag d42.18-build-1 -> release-official-build
  (compilation + tests + APK non signé) -> signature officielle locale ->
  release d42.18-rc9 -> E2E (API 30, appareil propre, parcours complet).

- build-1 (42385184417) : FAILURE 63 s à l'étape tests — erreur réelle
  tronquée par le tail -40 (défaut de MESURE, corrigé). Rebuid prévu.
