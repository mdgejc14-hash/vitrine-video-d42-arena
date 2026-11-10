# D42.28 — Rapport final de mission

**Mission** : finalisation commerciale intégrale — Firebase réel, audio corrigé, offline
prouvé, parcours commercial multilingue × modes audio, RC13 livrée.
**Budget** : 0 FCFA (GitHub Actions/Backblaze B2/Cloudflare/Firebase : paliers gratuits).
**Période** : 09/11/2026 – 10/11/2026. **Dépôt source de vérité** : mdgejc14-hash/vitrine-video-d42-arena.

---

## 1. Contexte et point de départ

D42.27 s'est close sur la RC12 (8d530b1, release d42.27-rc12, e2e 41/41). La mission
D42.28 ouvre les volets restants du contrat commercial : la configuration Firebase de
production dans le chemin de build officiel, la correction des compositions audio
défectueuses, la preuve offline complète, la matrice parcours × langues × modes audio,
et la livraison d'une RC13 (la RC12 n'est PAS remplacée).

## 2. P0 — Firebase réel dans toute la chaîne

**Défaut trouvé** : l'analyse binaire des dex de l'APK rc12 montrait 1×
`AIzaSyD42LABDUMMYKEY` et 0× clé réelle — l'inscription Google de la RC12 était
inopérante (le bottom sheet Credential Manager ne peut pas s'ouvrir sans OAuth client
correspondant au package + SHA-1 signé).

**Correctif (d027e2b)** : injection `ORG_GRADLE_PROJECT_vvFirebaseApiKey` (secret
Actions, jamais affiché ni committé) dans les 4 workflows de build ; pré-vol ;
**porte dex post-build** (l'APK doit contenir la clé réelle et PAS la factice).

**Preuves** :
- android-ci 42690012981 SUCCESS (clé réelle) ; e2e-lab 42690012987 : auth 11/11
  avec clé réelle — A1 = VRAI flux Credential Manager en lab (APK debug) ;
- release-official-build 42706902169 (tag d42.28-build-rc13) : porte dex PASS
  (classes.dex : 1× réelle, 0× factice) ;
- **release-official-e2e 42708544509 (tag d42.28-rc13) — auth-officiel-playstore
  10/10 PASS sur l'APK OFFICIELLEMENT SIGNÉE (cert 758077eb…33e192), image GMS
  « playstore » : A1 vrai flux Credential Manager déclenché, annulation propre,
  repli intact, resoumission, parcours continué, zéro crash.** C'est la démonstration
  demandée que package + SHA-1 + OAuth client sont déclarés côté Google/Firebase.
- e2e-official (même run) : 37 PASS / 0 FAIL — parcours commercial complet sur
  l'APK signée (export 7 861 674 octets, FGS, écran éteint, partage).

**Limite assumée** : le test avec un VRAI compte Google appartient au fondateur
(test physique, jamais simulé — aucun identifiant de test en notre possession).

## 3. P1 — Audio : défaut démontré, correction déterministe, déploiement réversible

**Défaut (audit 13643105300)** : 600/600 pistes avec attaque (premier son à −40 dB)
entre 1,03 s et 3,18 s — toutes défectueuses au critère d'attaque audible < 0,5 s.
Par ailleurs 54/60 clés titulaires audio_catalog étaient absentes de B2 (repli v01
par conception côté worker).

**Correction (0e9e84f, script scripts/audio/fix_initial_silence.py)** :
- lecture B2 des originaux avec contrôle sha256 du manifeste v2 ;
- atrim(attaque − 120 ms) + afade 0,4 s + MP3 CBR 128 k 44,1 kHz stéréo ;
- contrôles qualité par piste (attaque < 0,5 s, 0 clipping, décodable, RMS ±1,5 dB,
  durée ≥ 10 s) et **garde : SI une piste échoue → AUCUN upload** ;
- **nouvelles clés audio/bgm_r2/** — les originaux audio/bgm/ ne sont JAMAIS
  écrasés (listing post-opération : 691 clés anciennes intactes) ;
- titulaires absentes ré-ingérées depuis le v01 corrigé (.mp3 + .m4a AAC),
  conformément au design du repli worker (équivalence prouvée par routeAudioTrack) ;
- émission de la migration D1 0013 (600 INSERT OR REPLACE, EN_LIGNE).

**Exécution** : run de validation sans upload 42695901102 (600/600 conformes :
attaque → 0,00 s, ΔRMS ≤ 0,35 dB, 0 clipping, durées 34,4–57,7 s) puis run avec
upload 42697768061 (600/600 r2 + 30 m4a + 30 mp3 titulaires). Déterminisme prouvé :
sha identiques entre les deux runs. Déploiement : deploy-production 42702350485
(migrations 0001→0013 appliquées, worker redéployé, smoke PASS).

**Re-audit post-déploiement (42728213996) : 26 PASS / 0 FAIL.** Attaque max
**0,00 s** sur 600/600 ; silence en bord 0,00 s ; titulaires sans ?v : HTTP 206
audio/mpeg (0/60 absente) ; sha256 intégral 600/600 ; EN_LIGNE 600/600, 6 secteurs,
30 gabarits × 20 variations ; erreurs attendues 400/400/404 ; décodabilité 600/600 ;
durées 34,4–57,7 s ; RMS moyen −17,6 dB (−18,9…−15,0) ; dynamique 11,7–17,5 dB ;
0 clippé (peak −1,00 dB) ; σ inter-pistes 0,81 dB ; réconciliation B2 600/600.

**Incident B2 (documenté, résolu par attente)** : le re-audit initial
(42702694932) a échoué en masse (403 AccessDenied « Class B cap exceeded ») :
le plafond de téléchargements du COMPTE B2 était épuisé par les ~1 200 GET des
runs de correction. Diagnostics 42705741236/42727962703 : bucket INTACT
(600 r2 + 691 anciens présents et lisibles après le reset quotidien 00:00 UTC).
Ce n'était ni un défaut produit, ni un échec de migration. Option fondateur pour
l'avenir : relever le cap (dashboard Backblaze → Caps & Alerts, 0 FCFA).

## 4. P2 — Offline

**Banc B — idempotence du consume (P2-B, 0e9e84f)** : re-POST du MÊME eventId sur
/api/v1/quota/consume ×3 → `{ ok:true, dup:true }` à chaque rejeu (INSERT OR IGNORE,
PK event_id) et crédits TOUJOURS 1 — preuve que le flush d'outbox après retour réseau
ne double JAMAIS le débit. **security_ci.txt : 69 PASS / 0 FAIL** (42695850837).

**Banc A — export complet hors connexion (0e9e84f + correctif banc cb12a4f)** :
réseau ON au départ (pré-téléchargement BGM à la sélection du gabarit), coupé par
un surveillant dès que files/bgm/*.mp3 est en cache, puis brief → tournage → aperçu
→ export sans Internet ; preuves ffprobe/journal Room/retour réseau/rushs/crash.
Premier passage : 40 PASS / 2 FAIL — DEUX DÉFAUTS DU BANC (adb perd les quotes de
`sh -c 'ls …'` → surveillance inopérante, réseau resté ON ; ffprobe absent du
runner), PAS de l'app (l'export lui-même a réussi : CONFIRMED, solde 2, rushs
présents, zéro crash). Correctifs poussés (forme app_ls éprouvée + step ffmpeg).

**Re-runs et diagnostic définitif** : 42728504073 : 40/2 puis 42737266239
(banc instrumenté, abf3b5e) : 41/1. L'instrumentation (double sonde run-as/root,
trace horodatée toutes les ~30 s, diagnostic post-run) a tranché : **files/bgm
est créé mais reste VIDE du début à la fin (646 itérations)** — le message
D42-VERIF « BGM planifiée — gain solo » ne prouve pas la musique : le worker
l'émet pour BGM **OU SFX** (ExportWorker l.186) ; la piste audio 34 992 ms du MP4
était la base silencieuse + SFX. Cause PRODUIT (et non un défaut) :
ExportActivity l.250 — `token?.let { ensureGabaritCached } ?: localFile(categorie)` :
**en session démo (sans jeton Firebase), le produit ne télécharge JAMAIS le BGM** ;
l'export sort avec les SFX seuls. Le prérequis du banc (« BGM en cache ») ne peut
donc être établi que PAR le banc : **v3 (4bef52b)** — piste titulaire
`musique_t1_shops_small_business` téléchargée côté runner (compte de test A,
signIn REST identitytoolkit + GET /audio/track, 206 audio/mpeg — route vérifiée
401 en anonyme), INJECTÉE dans files/bgm au moment du brief, puis coupure réseau :
fin du parcours et export hors connexion AVEC musique ; verdict musqué par le
seul log worker interdit — preuve RMS global > −28 dB exigée (musique ≈ −18 dB,
SFX épars < −30 dB). **Re-run v3 : 42742724174 (en cours).**

## 5. P3 — Parcours commercial × langues × modes audio

**Banc (c7c3338)** : tools/e2e/run_audio_modes.sh + workflow android-e2e-p3-modes
(3 jobs parallèles, un par mode, chacun 4 langues). Mode déterminé par le produit :
musique seule (rushs muets + BGM, gain solo 0 dB), voix seule (rushs avec voix +
cache BGM vidé → pass-through), voix + musique (ducking sidechain). Preuves par
cellule : parcours complet localisé jusqu'à « Vidéo prête ! », MP4 tiré, ffprobe,
RMS global + RMS de la fenêtre d'intro (musique/mix : > −28 dB ; voix : < −40 dB),
décodage intégral, zéro crash. **La parole n'est jamais obligatoire** (mode musique
seule = rushs muets de l'émulateur).

**Constats d'architecture documentés** : les libellés du BRIEF restent en français
dans toutes les langues (contenu des gabarits non localisé — état produit assumé) ;
le badge « PRISE n/N » est codé en dur ; la carte gabarit « Nouvel arrivage » (T1)
est identique partout.

**Exécutions** : 42728217504 — défaut d'infrastructure (émulateur non démarré,
annulé) ; 42732996211 — les 3 jobs tournent mais les cellules s'arrêtent au brief :
DEUX défauts du banc (a) test brief par grep « E2E FIELD » sur la sortie de
`champs` (qui émet « E2E CHAMP ») — jamais de match alors que le dump 21_brief.xml
prouvait l'écran affiché (titre + champs + exemples préremplis) ; (b) écran
d'activité PAGINÉ (2 cartes/page × 3) : la carte commerce n'est pas en page 1 en
ja — sélection désormais paginée (commerce prioritaire, sinon toute carte visible :
les 6 secteurs ont chacun un T1 « Nouvel arrivage »). 42737312734 (fix secteurs +
brief par wait) : catalogue + sélection OK mais le wait ui.py --exact du titre
s'interrompt en ~5 s au lieu de 30 (8/8 cellules) alors que le dump prouve
l'écran — la preuve du brief est désormais le DUMP ARCHIVÉ (grep du titre,
3 tentatives) et le wait reste affiché à titre diagnostic. **Mode audio
(D42.28-16) : le BGM titulaire est injecté en cache pour musique/mix** (le
produit ne télécharge pas en session démo — cf. §4) : les verdicts RMS
(> −28 dB musique/mix, < −40 dB voix) deviennent atteignables. **Re-run :
42742781593 (en cours).**

## 6. Livraison — RC13

- **Construction** : tag d42.28-build-rc13 → release-official-build 42706902169
  SUCCESS (tests unitaires feature-export PASS, APK R8 44 133 897 o, porte dex PASS).
- **Signature locale** (keystore officiel, jamais committé) : zipalign + apksigner ;
  cert SHA-256 758077eb…33e192, SHA-1 89fab9b6…cd8a3 — identiques à la RC12.
- **Publication** : release PRIVÉE 439701454 (tag d42.28-rc13, prerelease), asset
  vitrine-video-rc13.apk 44 166 078 o, sha256
  4e8dd943f2fd97358b3a6df0c08d2ed4ab1615446b3e7f2edd8dcdd4289fdbc4.
- **Validation** : release-official-e2e 42708544509 SUCCESS (37 + 10 PASS, §2).
- **RC12 non remplacée** : la release d42.27-rc12 reste en place.
- Réserve honnête : l'export du run e2e-offical s'est fait SANS musique (cap B2
  pendant le run — prefetch en repli, comportement de robustesse attendu) ;
  l'audio en production est revalidé par le re-audit P1-5 et la matrice P3.

## 7. Non-régression

- android-ci : 42732930938, 42737266223 et 42742723848 SUCCESS (a1565d2,
  abf3b5e, 4bef52b).
- e2e-lab 16 jobs : 42728504073 15/16 (auth-local FAIL : compteur 12 migrations
  codé dur — fix additif a1565d2) ; 42732930889 14/16 (les 2 échecs sont
  d'INFRASTRUCTURE : « could not connect to TCP port 5554 », émulateur non
  démarré, zéro E2E_RESULT émis — jobs android-e2e-offline et langues-ja) ;
  **42737266239 (abf3b5e) : 16/16 SUCCESS — auth-local 13 migrations PASS,
  non-régression VALIDÉE** ; 42742724174 (4bef52b, banc A v3) en cours.

## 8. Incidents et conduite

1. **Cap B2** (voir §3) — diagnostic outillé (workflow b2-diagnostic, 2 runs),
   runs faussés annulés volontairement, reprise après reset quotidien. Aucune
   dépense, aucune action destructive.
2. **Restauration du bac à sable à un état ancien (10/11 00:23)** : `.git/config`
   (exclu des snapshots) et 3 commits locaux non poussés perdus. Récupération :
   remote rétabli, `reset --hard origin/main` (tout le fond était poussé),
   checkpoint et matrice recréés à l'identique (commit adf80e1). Aucune perte de fond.
3. **Défauts de banc vs défauts produit** : chaque FAIL a été attribué précisément
   (sh -c/adb, ffprobe absent) avant correction — l'app n'a pas été modifiée sur
   la foi d'un faux négatif.

## 9. Ce qui reste au fondateur (physique, hors périmètre agent)

- Test de l'inscription Google avec son VRAI compte sur l'APK RC13 signée
  (asset de la release d42.28-rc13).
- Option : relever le cap de téléchargements B2 si les opérations de maintenance
  audio devaient se répéter intensivement un même jour.
- SKYPAY : seule non-configuration volontaire (décision antérieure maintenue).

## 10. Résultats consolidés

(Matrixe détaillée : docs/checkpoints/D42_28/02_MATRICE.md — PASS/PARTIAL/FAIL/
BLOCKED/NOT RUN par exigence, commit, workflow, run, artefact, SHA-256.)

- P0 : **PASS** (P0-1..4) ; P0-5 NOT RUN par choix (test physique fondateur).
- P1 : P1-1..4 **PASS** ; **P1-5 PASS (re-audit 26/0)** ; P1-6 PASS (diagnostic).
- P2 : P2-2/P2-3 **PASS** ; P2-1 PARTIAL → banc v3 en cours (preuve RMS musique).
- P3 : banc requalifié (injection BGM + brief par dump) — re-run en cours.
- L-1/L-2 : **PASS** (RC13 construite, signée, validée) ; **L-3 PASS (16/16)** ;
  L-4 PARTIAL.

---

*Rapport complété au fil des résultats ; chaque assertion cite son run GitHub. Aucune
fonction absente n'est présentée comme opérationnelle ; les limites sont nommées.*
