# NEXT_ACTION — D42.34 ordre final (CLÔTURÉ — attente acceptation fondateur)

Chaîne : 2dfd907 (base immuable, CI SUCCESS) → … → 93fa450 → d711223 →
e59d82d → 9e83e7f → 08d567f → 884e5c9 → <commit de clôture du 15/11 soir>.
Échéance projet : 18/11/2026.
Date réelle de référence : 15/11/2026 (jamais de date future dans les documents).

## ÉTAT FINAL (15/11 soir — ordre fondateur en 5 points EXÉCUTÉ)

- **(1) Travail préservé** : branche `d42.34-founder-acceptance-fixes`,
  `main` inchangé, aucun reset destructif, aucun RC16, aucun APK signé,
  aucun CinetPay, aucun écran Aide & Contact.
- **(2) Sync doc terminée** : README galerie + 11_INVENTAIRE (78 états :
  **68 CONFORME · 6 NON PROUVÉ · 4 NON APPLICABLE**) + 12_MANIFEST
  (138 entrées / 122 fichiers) + 13_RAPPORT + NEXT_ACTION ; D34-01..03,
  D34-29..35 intégrés ; VR-003/004/005/015 réconciliés (recaptures
  post-images 15/11) ; VR-016..019 CONFORMES sur captures dédiées
  (D34-31/32 + 6 secteurs, D34-33, D34-34) ; VR-054 CONFORME (D34-22) ;
  VR-055 CONFORME (D34-35).
- **(3) Preuves techniques** : VR-054/055 PROUVÉES par chemin utilisateur
  réel (worker + LiveData) ; VR-053/VR-009/VR-048/VR-065 NON PROUVÉ avec
  explication précise (notification = vrai ExportWorker en exécution ;
  Google SSO externe ; MLKit caméra réelle ; CinetPay 501 service externe).
- **(4) Galerie unique** via `scripts/galerie_lotf.py` (script = source) :
  138 entrées, 78 états tous représentés (capture ou absence explicite),
  zéro lien mort (assertions d'existence), dates réelles.
- **(5) Tests + CI** : runs locaux du soir VERTS (D34-33/34/35) ; CI GitHub
  runs 279→286 SUCCESS (jusqu'à 884e5c9 inclus) + commit de clôture.

## PROCHAINE ACTION — UNE SEULE

**ARRÊT COMPLET. Attendre l'acceptation explicite du fondateur.** Aucun
changement non demandé après le rapport de clôture. À l'acceptation :
suivre les instructions du fondateur (les états téléphone fondateur —
splash, viseur, partage, consentement R4, connexion hors-ligne,
notification export — et le checkout CinetPay restent à produire sur
matériel/service réel, jamais simulés).

## PIÈGES (tous rencontrés — ne pas retenter les impasses)

- Remote git + identité perdus à chaque reset sandbox (.git/config non
  persisté) — réparer dans la MÊME commande que fetch/push.
- gradle.properties : JAMAIS committer la valeur locale (1024m) — contrôle
  `git diff --cached --stat gradle.properties` avant chaque push ; checkout
  AVANT add.
- Builds Robolectric lourds : UN test à la fois (daemon sinon tué, OOM) ;
  runs individuels ~1-3 min chacun.
- **WorkManager progress SOUS Robolectric : LA MÉTHODE QUI MARQUE (Lot 8)**
  — worker de test occupant le nom unique réel (setProgress authentique,
  phase tenue stable via inputData), poll `getWorkInfosForUniqueWork` AVANT
  le launch, PUIS tap réel sur export_start avec : extra `input` non null
  (sinon deny input_missing), `ShadowStatFs.registerStats(filesDir, …)`
  (sinon porte stockage refusée à 0), et pour l'état prêt : réussite SUR
  SIGNAL fichier créé après affichage de la phase (sinon KEEP ré-enqueue le
  vrai worker, travail terminé = non bloqué).
- Toolchain : JDK /opt/toolchain/jdk-17.0.21+9, cmdline-tools 15859902,
  platforms;android-37.0, build-tools 37.0.0 ; swap 2G à recréer si reset.
- git archive/sparse-checkout impossibles (clone blob:none) : raw API + PAT.
- Visualiser un PNG : corrélation template luminance (pas de vision).
- **Builds locaux : LANG=C.utf8 obligatoire** — sans locale UTF-8, kotlinc
  mangle les noms de classes synthétiques issus d'identifiants accentués
  (ex. `paysTriés` → `paysTri?s` → NoClassDefFoundError au runtime).
- **Compose Dialog + curseur clignotant** : le champ qui prend le focus au
  show rend Espresso perpétuellement busy (AppNotIdleException 60 s) — ne
  JAMAIS attendre l'idle après l'ouverture : boucle bornée
  `mainClock.advanceTimeBy(100) + looper.idle()` en pollant la fenêtre.
- **Module app : premier test unitaire** — nécessite
  `testOptions.unitTests.isIncludeAndroidResources = true` (résolution du
  manifest) + junit/robolectric/test-core en testImplementation. Premier
  run ~15 min (instrumentation du classpath complet), suivants ~40 s.
