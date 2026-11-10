
## Journal d'exécution (suite)

- **20:44** push 0e9e84f (P1+P2+checkpoint 00) ; dispatch audio-fix-silence
  (limit 0, upload false).
- **20:53** audio-fix-silence 42695901102 SUCCESS : **600/600 corrigées et
  conformes** (attaque 1,03–3,18 s → 0,00 s ; ΔRMS ≤ 0,35 dB ; 0 clipping ;
  600/600 décodables ; durées 34,4–57,7 s), SQL 0013 (600 lignes),
  titulaires 60/60 absentes constatées par HEAD.
- **21:00** dispatch upload=true → run 42697768061.
- **21:09** SUCCESS : **upload B2 600/600 vers audio/bgm_r2/**\* +
  **titulaires 30 m4a + 30 mp3 ré-ingérées** (toutes préalablement absentes,
  aucun écrasement). Déterminisme prouvé : sha identiques entre les 2 runs.
- **P2-B VALIDÉ** (e2e-lab 42695850837, job security-local,
  security_ci.txt) : **69 PASS / 0 FAIL** dont les 5 nouveaux contrôles —
  rejeu du MÊME eventId ×3 → dup:true, crédits TOUJOURS 1 (flush outbox
  sans double débit), tentatives refusées sans décrément.
- e2e-lab 0e9e84f : auth 11/11, drafts, deeplink, langues, offline, e2e,
  backend-http, gabarits, harness SUCCESS ; offline-export/p1/camerap en
  cours.

## Suite : e2e-lab 16/16, incident B2, RC13 (22:35 UTC)

- **e2e-lab 42695850837 : 16/16 SUCCESS** (0e9e84f) — dont
  android-e2e-offline-export **40 PASS / 2 FAIL** : l'export offline a
  MARCHÉ (CONFIRMED, solde 2, rushs présents, retour réseau OK, zéro
  crash) MAIS (a) le surveillant n'a pas détecté le BGM (« adb shell
  run-as … sh -c 'ls files/bgm/*.mp3' » perd ses quotes à travers adb —
  le réseau est resté ON) et (b) ffprobe absent du runner. Correctifs
  banc (cb12a4f, D42.28-04) : forme app_ls éprouvée + step ffmpeg.
- **Incident B2 (21:28)** : re-audit 42702694932 FAIL massif (0/600
  HEAD, titulaires 404, « 0 objets listés »). Enquête b2-diagnostic
  (42705741236/195d813) : **bucket INTACT** (audio/bgm/ = 691 clés,
  audio/bgm_r2/ = 600 clés) ; GET/HEAD d'objet = **403 AccessDenied
  « download bandwidth or transaction (Class B) cap exceeded »** —
  plafond de TÉLÉCHARGEMENTS du compte B2 épuisé par les ~1200 GET des
  deux runs audio-fix-silence + audits. PAS un défaut produit/migration.
  Reset quotidien : 00:00 UTC. Runs faussés annulés volontairement
  (42706294490, 42705705088).
- **RC13** : tag d42.28-build-rc13 → release-official-build 42706902169
  SUCCESS (tests unitaires feature-export PASS, APK R8 44 133 897 o,
  **porte dex : 1× clé réelle / 0× factice**) ; re-signature locale
  (cert officiel 758077eb…33e192, SHA-1 89fab9b6…cd8a3) → release
  privée 439701454 (tag d42.28-rc13, asset vitrine-video-rc13.apk
  44 166 078 o, sha256 4e8dd943f2fd…89fdbc4) ;
  **release-official-e2e 42708544509 SUCCESS** : e2e-official
  **37 PASS/0 FAIL** (parcours complet sur l'APK signée, export
  7 861 674 o, FGS, écran éteint, partage) + auth-officiel-playstore
  **10/10 PASS** (A1 vrai flux Credential Manager sur image GMS
  playstore, porte cert + porte dex PASS). Réserve : l'export de CE run
  est sans musique (cap B2 pendant le run) — l'audio en production est
  revalidé par le re-audit P1-5 + P3.
- **Reprise après reset cap (00:00 UTC)** : e2e-lab complet (banc A
  corrigé + non-régression), audio-audit full, P3 (3 jobs × 4 langues).

## Clôture (10/11, 20:00 UTC) — trois causes racines, mission close

- **Banc A v3.4 (42786468288)** : BGM 6/6 injectés et en cache à la coupure,
  décodeur mp3 alloué puis libéré en ~5 ms SANS drain → **cause racine
  produit : BgmDecoder.decodeMusic appelait codec.start() sans
  codec.configure()** (IllegalStateException avalée par runCatching → null →
  SFX seuls, RMS −53,259024 dB identique au millième) ; correctif
  **D42.28-26 (8cb9a7d)** : configure() + decodeLoop durci. Faux FAIL
  P1_aucun_crash = 37 crashes du harnès uiautomator (aucun de l'app).
- **v3.5 (42811778574)** : export musical >40 min (vs 13 min SFX seuls) —
  double cutoff job 60 min/banc 40 min (29 s d'écart) → **D42.28-28
  (b7319e5)** : job 110 min + fenêtre 75 min.
- **P3, mystère du « corps avalé » clos en 3 itérations** : v10 sha256
  in-run = commit ; v11 xtrace → arrêt à +L433 swipe_v, saut à set +x ;
  v12 (redirections retirées) → **w=screen=1080x2340, « value too great
  for base » : ui.py size sort « E2E screen=WxH », la swipe_v locale
  parsait $2/$4 → erreur arithmétique → bash abandonne le for entier, le
  message partant dans >/dev/null 2>&1** → **D42.28-29 (0c7ec9f)** :
  swipe_v = pattern run_p1.sh (lire_taille_ecran + EFF_W/EFF_H).
- **P3 v13 (42821782768)** : **P3_brief_valide PASS 4/4 langues** (passe
  basse exécutée : champs_bas.txt avec Monnaie + Quartier remplis) ;
  parcours complet jusqu'à l'UI d'export ; 4 FAIL export = **2e cause
  racine harnès : l'image AOSP « default » embarque /system/xbin/su →
  IntegrityGuard DENY_INTEGRITY** (« Vérification de sécurité échouée »
  dans le dump 29) — le P1 masque /system/xbin depuis D42.21, le P3 non →
  **D42.28-30 (c227318)** : masquage bind-mount recopié.
- **Banc A v3.7 (42832598452, success, 37/4)** : fix BgmDecoder PROUVÉ au
  décodage (décodeur vivant ~1 s, drain réel) mais le rendu complet ne
  survit pas sur swiftshader (75 « Forcing EOS », 3 tentatives mortes sur
  « Surface: unknown buffer », worker FAILURE, journal COMPENSATED).
- **P3 v14 (42832699504)** : fr/en/es complètes **24 PASS / 3 FAIL /
  0 BLOCKED** — porte PASSÉE, export lancé, **MP4 avec piste audio
  (ffprobe)**, aucun crash ; les 3 FAIL = export >75 min → MP4 de
  tentative inachevée (décode/RMS intro −55,2 dB). Ja coupée au timeout
  job 330 min (parcours + brief_valide prouvés en v13).
- **Restauration sandbox (fin)** : .git revenu à 8d530b1 + PAT périmé →
  remote reconstruit, fetch, reset --hard c227318, éditions docs
  préservées. Aucune perte (tout était poussé).
- **BILAN FINAL** : P0 ✔ ; P1 ✔ (re-audit 26/0) ; P2-B 69/0 ✔ ;
  P2-1 PARTIAL (fix produit livré et prouvé au mixeur ; verdict RMS non
  démontrable sur swiftshader — limite instrumentale, à établir sur
  appareil réel) ; P3 parcours complet validé fr/en/es + ja (v13) en mode
  musique, preuve acoustique fine et modes voix/mix hors portée
  instrumentale ; RC13 LIVRÉE VALIDÉE (10/10 + 37/0) ; L-3 16/16 ×4.
  1 défaut produit corrigé (BgmDecoder.configure, postérieur à la RC13 —
  à inclure dans la RC suivante), 2 défauts harnès corrigés, 2 faux
  positifs documentés. 0 FCFA dépensé.
