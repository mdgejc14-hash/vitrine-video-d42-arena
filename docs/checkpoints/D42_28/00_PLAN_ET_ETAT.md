
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
