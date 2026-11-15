# NEXT_ACTION — D42.34 ordre final (reprise au prochain tour)

Base : 2dfd907 (immuable) → … → 93fa450 → d711223 (HEAD, Lot 8) → P2 docs.
Échéance projet : 18/11/2026.
Date réelle de référence : 15/11/2026 (jamais de date future dans les documents).

## ÉTAT (15/11 soir, après Lot 8 + P2 docs)

- **P1 FAITE** : aperçus **30/30** (lots 1-3, file 29/29 VERIFIED, distant 200,
  zéro doublon) + image fondateur corrigée (shops T2 régénérée, sha
  9b6249e98b25…, aed849d→93fa450).
- **P3 (partie) FAITE** : D34Lot8 **3/3 VERT** — D34-20/21/22 (phases montage
  E8 + export prêt) via `D34Lot8ExportStatesVisualCheckTest` (d711223).
- **P3 dialogues FAITS (9e83e7f)** : Lots 9/10/11 **6/6** — D34-23..28
  (langue, secteur, accords, nettoyage, choix pays VR-078, reprise VR-062).
  CI d711223 + e59d82d SUCCESS.
- **P2 FAITE (commit en cours)** : README visual-review (30/30, Lot 8,
  sommaire corrigé, 8 bis complet 30 lignes), 11_INVENTAIRE VR-051/VR-052 →
  CONFORME, 12_MANIFEST 133 entrées.
- CI : verte jusqu'à 93fa450 inclus ; d711223 (Lot 8) en cours au push.
- Manifeste : 134 entrées / 111 fichiers. Restes NON PROUVÉ : 4 (splash,
  flux viseur, feuille partage = téléphone fondateur ; hors connexion) +
  consentement R4 + 5 ÉCART captures catalogue pré-mécanisme (D34-01..03
  et captures D42.33 du §8).

## PROCHAIN TOUR — ORDRE

1. **Recapture catalogue définitif 30/30** (P3) : étendre le test D34Lot6 aux
   6 secteurs (chaque tuile doit montrer l'aperçu webp réel), remplacer
   D34-01/02/03 et les 5 lignes ÉCART de la section 8 du README (captures
   pré-mécanisme), puis passer leur statut à CONFORME dans 11/12.
2. ~~Captures dialogues VR-074→078 + VR-062~~ **FAIT** (9e83e7f) — les 6
   dialogues sont capturés par clics réels (Lots 9/10/11).
3. **Régénérer la galerie** : extraire d'abord /tmp/maquettes + /tmp/apres33
   (raw.githubusercontent + PAT — clone blob:none) ; `python3
   scripts/galerie_lotf.py` ; chaque entrée = capture OU statut d'absence
   explicite (78/78).
4. **13_RAPPORT** à jour : 30/30, Lot 8, compteurs exacts, téléphone
   fondateur = NON PROUVÉ explicite.
5. **Rapport final + preuves GitHub** (runs CI, sha, contenus 200).

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
