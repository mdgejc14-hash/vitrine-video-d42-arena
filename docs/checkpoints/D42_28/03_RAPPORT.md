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
SFX épars < −30 dB).

**Fil des re-runs v3.1→v3.3** : 42742724174 — fetch 403 account_inactive
(compte de test A sans profil actif en table D1 : requireUser le vérifie)
→ compte sonde vv-auth-probe (2f7442d, celui de l'audit 26/0) ; 42759689694
— 403 à nouveau : le UA python par défaut est refusé, l'audit passe avec le
UA « vv-probes-audio-v2/1.0 » → UA repris (8dfc45e) ; 42764414507 — fetch
ENFIN OK (HTTP 200, 595 932 octets) mais le titulaire de la catégorie est
servi en **M4A audio/mp4** : la garde magic-bytes MP3 le rejetait →
détection du format par magic bytes (ftyp vs ID3/trame MPEG) et injection
`files/bgm/{cat}.{ext}` — localFile teste m4a PUIS mp3, exactement la
logique de downloadTrack (« mpeg » → mp3, sinon m4a). À chaque run, le RMS
mesuré (−53,26 dB = SFX seuls sur base silencieuse) a confirmé la cohérence
de l'instrumentation. **Re-run v3.3 : 42771550677 — 40/2, coupure PASS pour
la 1re fois, RMS −53,259 dB (SFX seuls, seule la catégorie MODE était
injectée).**

**v3.4 (42786468288, 2fb3454 — 6 catégories)** : 40/2. Les 6 `musique_t1_*`
sont injectés et présents en cache à la coupure (owner app, rw-rw-rw —
coupure_reseau.txt) ; gabarit cache avec `categorie_audio` correct ;
en session démo `localFile()` TROUVE le fichier, le worker logue « BGM
planifiée » et alloue `c2.android.mp3.decoder` (audio/mpeg 44,1 kHz
stéréo)... **qui est libéré ~5 ms plus tard sans AUCUN drain.** Cause
racine : `BgmDecoder.decodeMusic` appelait `codec.start()` **sans
`codec.configure(format, …)`** → IllegalStateException avalée par
`runCatching{}.getOrNull()` → null → mixeur SFX seuls → RMS −53,259024 dB
IDENTIQUE au millième près. Les fichiers titulaires sont sains (librosa :
42,9 s, RMS −17,4 dB, peak 0,86). Par ailleurs le FAIL `P1_aucun_crash`
de v3.4 est un faux positif : les 37 FATAL EXCEPTION du crash.log sont
toutes celles du HARNÈS (uiautomator DumpCommand « already registered »),
aucune de video.vitrine.app.
**Correctif D42.28-26 (8cb9a7d)** : `configure()` avant `start()` +
`decodeLoop` durci (l'heuristique d'abandon « TRY_AGAIN + entrée finie +
rien produit » remplaçait un decodage sain si le codec livre son PCM après
l'EOS d'entrée → patience bornée 3 s + INFO_OUTPUT_FORMAT_CHANGED traité).

**v3.5 (42811778574, d0ddeb9)** : parcours complet, export lancé (12:17:38)
mais **l'export avec BGM réellement mixée dépasse 40 min** (vs 13 min SFX
seuls) — double cutoff : timeout job 60 min à 12:58:19 vs verdict interne
du banc attendu à 12:58:48 (29 s d'écart, aucun verdict produit) →
**D42.28-28 (b7319e5)** : job offline-export 110 min + fenêtre banc 75 min.

**v3.7 (42832598452, c227318)** : 37/4. Le fix BgmDecoder est **prouvé
fonctionnel** : le décodeur mp3 vit ~1 s (drain réel, contre 5 ms en v3.4)
et la musique alimente le mixeur. MAIS le rendu complet ne survit pas sur
l'émulateur software : le pipeline vidéo (typographie via ExtTexMgr) passe
de 30 à 75 « Forcing EOS after missing 4 frames for 20000 ms », chaque
tentative (~12 min) meurt sur « Surface: getSlotFromBufferLocked: unknown
buffer » (3 tentatives : 1080p → 720p → 1080p), worker FAILURE à 15:14:31,
journal COMPENSATED (porte rembourse le crédit — comportement honnête).
Le MP4 extrait (5,8 Mo) est une tentative inachevée, sans piste audio
mesurable (« RMS indéterminé »). **Conclusion P2-1** : le mixage musical
est opérationnel (décodage + mixeur + SFX), le verdict RMS > −28 dB reste
NON DÉMONTRABLE sur l'émulateur swiftshader en l'état — c'est une limite
de l'instrument (rendu GPU software), pas un défaut du chemin audio :
la preuve acoustique complète exigera un appareil réel (ou une optimisation
du pipeline rendu+mixage, hors périmètre D42.28).

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
brief par wait) : catalogue + sélection OK, et le wait trouve le titre au run
suivant (E2E FOUND — les ~5 s d'échec du run précédent restaient inexpliqués,
la preuve par dump est désormais la référence). 42742781593 : **P3_brief PASS
(fr/en/es — titre + 5 champs détectés)** mais brief_valide FAIL : le 5e champ
(« Quartier et ville ») reste SOUS LE PLI en bas du formulaire scrollable →
bouton Continuer désactivé → parcours figé (dump 29 : brief « 1 / 4 », valeurs
saisies visibles) ; mon bloc de remplissage omettait la remontée du formulaire
du P1 — remplacé par la copie EXACTE du bloc P1 (éprouvé 16/16) ; l'attente de
fin d'export (40 min) devient conditionnelle au lancement effectif (3 cellules
avaient brûlé 45 min stériles → timeout job 150 min, run annulé avant ja).
**Mode audio (D42.28-16) : le BGM titulaire est injecté en cache pour
musique/mix** (le produit ne télécharge pas en session démo — cf. §4) ;
le fetch passe par le compte SONDE (2f7442d — le compte de test A reçoit
403 account_inactive, sans profil actif en table D1). **Re-run :
42759742973 (896c42c).**

**Fil v7b→v14 (deux causes racines résolues)** : v7b/v8 — le brief reste
bloqué à 4/6 champs (quartier + monnaie sous le pli) et le bloc « passe
basse » qui devait les remplir présentait le symptôme du « corps avalé » :
seul l'écho d'entrée survit, ni shot ni champs_bas.txt à l'artefact, sur
cinq itérations d'instrumentation croissante (v9 fonction isolée, v10
empreinte sha256 du script exécuté = commit vérifié, v11 xtrace : la trace
s'arrête à `+L433 swipe_v` puis saute à `set +x`). **v12 (suppression des
redirections qui masquaient le xtrace interne de la fonction appelée) a
livré la cause racine : `ui.py cmd_size` sort « E2E screen=1080x2340 »
alors que la swipe_v locale parsait `$2`/`$4` — `w` recevait
« screen=1080x2340 » et `$(( w * 50 / 100 ))` levait « value too great for
base », erreur arithmétique qui fait ABANDONNER par bash la commande
composite appelante (le `for` des 3 passes entier), le message étant
envoyé dans le `>/dev/null 2>&1` de l'appel. Correctif D42.28-29 :
swipe_v remplacée par le pattern éprouvé de run_p1.sh (lire_taille_ecran
via `adb shell wm size` + EFF_W/EFF_H).** **v13 (42821782768) : P3_brief_valide
PASS 4/4 langues** — la passe basse remplit Monnaie + Quartier (champs_bas.txt),
« Avant de commencer »/« Before you start »/« Antes de comenzar »/「始める前に」
atteints ; parcours complet jusqu'à l'UI d'export (20 PASS/4 FAIL/1 BLOCKED)
mais l'export ne démarre pas : **le dump 29 révèle le statut
export_gate_integrity (« Vérification de sécurité échouée ») — l'image
AOSP « default » embarque /system/xbin/su et l'heuristique anti-root
d'IntegrityGuard (V2.0 §22) refuse l'export (DENY_INTEGRITY) ; le P1 du
lab passe la même porte parce que run_p1.sh masque /system/xbin par
bind-mount d'un répertoire vide depuis D42.21** (docs/checkpoints/D42_21/
02_EXPORT_ROOT_CAUSE.md). Correctif D42.28-30 : masquage recopié dans le
P3 (IntegrityGuard ni modifié ni contourné — le contrôle de certificat
reste actif).

**v14 (42832699504, c227318) — verdict final du mode musique** : job coupé
au timeout 330 min pendant la cellule ja ; **fr/en/es complètes : 24 PASS /
3 FAIL / 0 BLOCKED chacune** — brief valide, porte intégrité PASSÉE, export
lancé (« Export local en cours »), **MP4 extrait avec piste audio (ffprobe)**,
aucun crash. Les 3 FAIL dérivent tous de la limite instrumentale déjà
constatée au banc A (§4) : l'export musical ne complète pas en 75 min sur
swiftshader → MP4 de tentative inachevée → « erreurs de décodage » et
« intro quasi muette (RMS intro −55,22 dB) ». La cellule ja avait prouvé
son parcours complet et brief_valide en v13.

**Conclusion P3** : le parcours commercial localisé de bout en bout
(langue → session locale → carrousel → activité → parrainage → catalogue →
brief 6/6 champs → guide → prises → aperçu → porte crédits/intégrité →
export local avec MP4+piste audio) est VALIDÉ sur fr/en/es (+ parcours ja
en v13) pour le mode musique. La preuve acoustique fine du mode (RMS intro
> −28 dB) reste hors de portée de l'émulateur software pour la même raison
qu'au banc A ; les modes voix et mix n'ont pas été re-dispatchés (même
limite instrumentale attendue sur l'export). Les deux corrections produit
issues de cette enquête (BgmDecoder.configure, rien pour le P3 — les deux
autres causes étaient des défauts du harnès) sont dans la RC13+.

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
- **Réserve finale (clôture)** : le correctif BgmDecoder (configure manquant,
  D42.28-26, commit 8cb9a7d) est POSTÉRIEUR au build de la RC13 — l'asset
  d42.28-rc13 embarque donc l'ancien décodeur (repli SFX seuls en session
  démo hors-ligne). Le correctif est sur main, prouvé au décodage (banc A
  v3.7) ; il sera à inclure dans la RC suivante.

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
4. **Faux positifs documentés (banc A/P3)** : le FAIL P1_aucun_crash de v3.4
   provenait de 37 FATAL EXCEPTION du HARNÈS lui-même (uiautomator DumpCommand
   « already registered », dumps concurrents) — aucune de l'app ; le symptôme
   « corps avalé » du P3 (5 itérations) était une erreur arithmétique bash
   masquée par une redirection — le fichier exécuté était bien celui du commit
   (sha256 vérifié in-run).
5. **Nouvelle restauration du bac à sable à un état ancien (10/11, fin de
   mission)** : `.git` revenu à 8d530b1 (fin D42.27) avec PAT périmé.
   Récupération : remote reconstruit avec le PAT actif, fetch, `reset --hard
   c227318` (tout le fond était poussé sur GitHub), éditions de matrice/
   rapport préservées par copie de sauvegarde. Aucune perte de fond.

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
- P2 : P2-2/P2-3 **PASS** ; P2-B **69/0** ; **P2-1 PARTIAL** — cause racine
  produit trouvée et corrigée (BgmDecoder : configure() manquant avant
  start(), D42.28-26) ; le mixage musical est prouvé opérationnel jusqu'au
  mixeur (décodeur vivant, drain réel) ; le verdict RMS > −28 dB n'est pas
  démontrable sur l'émulateur swiftshader (rendu ne complète pas en 75 min —
  limite instrumentale, §4) — preuve acoustique à établir sur appareil réel.
- P3 : **parcours commercial complet VALIDÉ** en mode musique sur fr/en/es
  (brief 6/6 champs + porte intégrité + export lancé + MP4 avec piste
  audio : 24 PASS / 3 FAIL instrumentaux par cellule, v14) et parcours ja
  + brief_valide 4/4 (v13) ; preuve RMS du mode non démontrable (même
  limite) ; voix/mix non re-dispatchés (même limite attendue).
- L-1/L-2 : **PASS** (RC13 construite, signée, validée 10/10 + 37/0) ;
  **L-3 PASS (16/16 ×4)** ; L-4 PARTIAL.
- Bilan correctif : 1 défaut produit corrigé (BgmDecoder.configure —
  livré après RC13, à inclure dans la suivante), 2 défauts harnès corrigés
  (swipe_v parsing ui.py size ; masquage /system/xbin/su absent du P3),
  2 faux positifs documentés (P1_aucun_crash = crashes uiautomator du
  harnès ; « corps avalé » = erreur arithmétique masquée par la redirection).

---

*Rapport complété au fil des résultats ; chaque assertion cite son run GitHub. Aucune
fonction absente n'est présentée comme opérationnelle ; les limites sont nommées.*
