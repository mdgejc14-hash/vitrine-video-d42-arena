# D42.29 — Rapport final de mission

**Mission** : clôture des réserves de qualification commerciale — preuve audio réelle,
trois modes audio × quatre langues, réserve offline, livraison RC14 (correctifs Export
`MUXING_TIMEOUT` inclus). **Budget : 0 FCFA** (GitHub Actions / Backblaze B2 /
Cloudflare / Firebase : paliers gratuits). **Période : 11/11/2026.** **Dépôt source de
vérité : mdgejc14-hash/vitrine-video-d42-arena.**

---

## 1. Contexte et point de départ

D42.28 s'est close sur la RC13 (7aefe65, release d42.28-rc13, auth officielle 10/10)
avec **37/4 PARTIAL** : le parcours e2e-official restait sur 4 FAIL dérivés d'un même
symptôme — l'export avec musique ne se finalisait jamais (`ERROR_CODE_MUXING_TIMEOUT`)
et la musique restait inaudible au début des MP4. La réserve P4 (offline) était
ouverte. D42.29 reprend UNIQUEMENT le non-terminé.

## 2. P2 — La panne audio réelle : diagnostic produit, correctif, preuve

**Symptôme hérité** : `ExportException ERROR_CODE_MUXING_TIMEOUT — "Abort: no output
sample written in the last 25000 milliseconds"`, reproductible sur 3 tentatives et
plusieurs géométries (540×960, 360×640, encodeur logiciel), uniquement quand le graphe
audio contenait la musique (les verts historiques étaient sans graphe audio actif —
c'est pourquoi la CI n'avait rien vu).

**Cause racine (lue dans androidx/media3 1.11.1)** : `DefaultAudioMixer.isEnded()`
exige `sources.size() == 0` ; Media3 n'appelle jamais `setEndTimeUs()` sans trimming.
`BgmSfxAudioMixer` ajoutait la source musique mais ne la retirait jamais : le mixeur ne
terminait pas, le muxer n'écrivait plus d'échantillon, l'export mourrait au timeout.
Tous les rendus au mixeur actif calaient DEPUIS TOUJOURS ; le défaut était latent depuis
l'origine du mixeur.

**Correctif (439c56d)** : dans `drainMusique()`, retrait de la source
(`removeSource(musicSourceId)`) dès que l'alimentation atteint
`min(taille, capMusique)` — le mixeur atteint alors `isEnded()`, l'AAC reçoit ses
derniers échantillons, le muxer finalise.

**Preuves** :
- pilot v6 (42984967143) : **worker=SUCCEEDED à la tentative 0 en 148 s**, MP4 13 Mo,
  AudioChecks OK (audio 34 992 / 35 000 ms) — premier export musical finalisé de
  l'histoire du projet ;
- pilot final (42992443312, harnais a6519b5) : **4 langues SUCCESS, musique audible**
  — RMS 2-6 s = −17,64 dB (seuil −28 dB), global −16,71 dB, intro −31,95 dB =
  fade-in 0,45 s du gabarit, 0 erreur de décodage. Le décodeur on-device était
  déjà prouvé (v1 : 3 360 764 échantillons décodés, RMS −16,6 dB ≈ ffmpeg −16,62).

**Correction complémentaire (439c56d)** : l'alimentation ne dépasse plus la durée de
composition (`feedPcm(maxFrames)`) — v1 muxait ~3 s de silence excédentaire.

## 3. P3 — Les trois modes audio × quatre langues

Pilots sur le harnais corrigé (a6519b5), gabarit `shops_small_business_T1` (35 s),
profils fr/en/es/ja, BGM de production (titulaires) — dispatchés en parallèle grâce à
la concurrence par mode audio. **12/12 runs verts (3 modes × 4 langues).**

| Mode | Run | Contenu | Preuve acoustique (fr) |
|------|-----|---------|------------------------|
| musique | 42992443312 | rushs muets + BGM titulaire | RMS 2-6 s **−17,64 dB** ; global −16,71 ; fin −16,57 ; fade-in intro −31,95 ; 0 err |
| voix | 42992447010 | rushs audio, cache BGM vide | voix 5-8 s −21,15 dB, notchée 440 Hz → −29,20 dB (**chute 8,05 dB = voix dominante**) ; 0 ligne D42-BGM = repli honnête sans musique |
| mix | 42992451479 | voix + BGM titulaire + ducking | voix dominante (notch −8,05 dB) ; **musique PRÉSENTE par soustraction échantillon par échantillon (mix − voix, piste entière 35 s) : RMS −49,85 dBFS** = exactement le niveau ducké du contrat (base −36,6 dB, ducking voix prioritaire) ; D42-BGM décodée −16,6 dB |

Les mesures sont identiques sur les 4 langues (contenu audio déterministe — BGM et
rushes de banc identiques, seuls les MP4 diffèrent par taille). Le « lit musical » du
mix est inaudible en RMS global PENDANT la voix parce que le ducking (−14 dB) et la
base (−20 dB) l'y placent : c'est le contrat `voix_prioritaire`, pas un défaut ; la
soustraction le rend mesurable et il est présent du début à la fin.

**Correction d'historique** : les 3 FAIL « musique inaudible / pas de fin d'export » du
banc P3 v14 (42832699504, D42.28) dérivaient du même défaut 439c56d — ce n'était PAS
une « limite instrumentale swiftshader ». La matrice D42.28 est réinterprétée en
conséquence (voir 02_MATRICE P3-v14).

## 4. Harnais de preuve — trois bugs d'instrument corrigés

| Bug | Effet | Correctif (e308a94, a6519b5) |
|-----|-------|------------------------------|
| `grep -c … || echo 0` | compteur « 0\n0 », comparaison entière impossible | `|| true` |
| regex RMS non ancrée | attrapait l'adresse hexa de la ligne ffmpeg (« 0 dB ») | `sed -nE` ancré sur `RMS level dB:` |
| reliquat `cache-export-1.mp4` (51 o, message run-as) | ffprobe illisible → grep vide → **mort silencieuse par pipefail avant tout verdict** (bug 665 : le FAILURE v7 42990104883) | skip explicite des conteneurs sans durée ffprobe + `mesure_rms … || true` |
| concurrence `d42-${{ github.ref }}` | les 3 modes s'annulaient entre eux (voix/mix v7 CANCELLED) | groupe par `audio_mode` → parallélisme |

Résultat : les 3 pilotes tournent en parallèle et sortent des TSV acoustiques complets
(11 colonnes : octets, durée, pistes, decode_err, RMS global/intro/2-6/fin, voix 5-8,
voix notchée).

## 5. Livraison — RC14

- **Build (R-1)** : tag `d42.29-build-rc14` (5736355) → release-official-build
  42990176193 SUCCESS — APK R8 non signée 44 133 897 o
  (5e520f6f25eea50d07cdb93a19a8c8c9a08b26ae8287c3d93c13c4e8e924f353), porte dex
  Firebase PASS (1× clé réelle / 0× factice).
- **Signature (R-2)** : zipalign + apksigner, keystore officiel (jamais committé) →
  `vitrine-video-rc14.apk` 44 161 982 octets,
  **sha256 a4efd2756aeeb176277c222b5c7e595e3b0d35e6d0de5edce4a96b3cf4f80e78**,
  cert SHA-256 758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192
  (identique RC12/RC13 — continuité OAuth Google).
- **Publication (R-3)** : release **441446648** (tag `d42.29-rc14` → 5736355,
  prerelease), asset 734861325 en ligne. Le tag doit exister avant le POST /releases
  (leçon 666).
- **E2E sur l'APK signée (R-3) : release-official-e2e 42992690177 SUCCESS** —
  e2e-official **37 PASS / 0 FAIL** (parcours complet : export 8 378 937 octets,
  notification FGS, export poursuivi 45 s écran éteint, feuille de partage, journal
  CONFIRMED, zéro FATAL EXCEPTION — **les 4 FAIL de la RC13 sont éteints**, ils
  dérivaient du défaut MUXING_TIMEOUT corrigé) ; auth-officiel-playstore **10/10**
  (A1 vrai flux Credential Manager déclenché, annulation propre, repli intact,
  resoumission, parcours continué) ; porte dex PASS (1× clé Firebase réelle, 0×
  factice) ; porte apksigner PASS (cert officiel).
- **Non-régression (R-4)** : android-ci 42992432920 SUCCESS et android-e2e-lab
  **42992432909 : 15/15 jobs SUCCESS** sur a6519b5 (langues, auth, offline,
  offline-export, deeplink, camera, drafts, backend, sécurité) ; re-validations sur
  b522290 : android-ci 42998293963, e2e-lab 42998294237.

## 6. P4 — Réserve offline

Pilote offline (42994891267, musique/titulaires, **4 langues**) : réseau coupé AVANT le
rendu (preuve dumpsys : `Active default network: 100` → `none`), musique servie depuis
le cache, DB avant/après, retour réseau puis Dashboard (flushPending = flushTelemetry +
replayQuota/claim/WelcomeGrant + syncEntitlements).

**Résultats 4/4 langues** :
- **OFFX_journal_confirme PASS** — journal export CONFIRMED hors connexion ;
- **OFFX_debit_unique PASS** — welcomeCreditsLeft 4 (5 − 1, aucun double débit) ;
- **musique audible offline** — RMS(2-6 s) −17,64 dB, identique à l'online ;
- **OFFX_telemetry_sync PARTIAL** — l'événement `export_confirmed_bgm` est durablement
  file (ok=1) mais uploaded=0 à T+40 s : le flush est déclenché par le Dashboard
  ~10 s après le rétablissement `svc`, AVANT la réassociation complète du réseau ;
  la tentative POST unique échoue alors silencieusement (flushTelemetry ne journalisait
  rien). La file étant durable et rejouée à chaque affichage du dashboard, l'événement
  n'est pas perdu — mais la preuve à 40 s ne pouvait pas être PASS.

**Correctif (b522290 + 67b5cd8)** : sonde produit `D42-SYNC` (flushPending
déclenché ; flushTelemetry : nb d'événements, code HTTP) + harnais durci : attente
d'une connectivité RÉELLE (dumpsys, max 60 s) avant de déclencher le flush,
composant dashboard corrigé (bug 667), captures tolérantes. Verdict final :
section 9.

## 7. Incidents et conduite

- **663** reset sandbox (récurrence) : récupération éprouvée (re-add origin avec PAT,
  fetch, reset --hard origin/main, VÉRIFIER les contenus avant tout patch — une
  restauration a un temps écrasé d42-render.sh).
- **664** concurrence Actions : les pilotes s'annulaient entre eux → groupe par mode.
- **665** FAILURE v7 inexpliqué : diagnostic complet — reliquat cache 51 octets +
  pipefail. Corrigé, revalidé par 3 runs verts.
- **666** POST /releases : créer le tag AVANT (git push) sinon Validation Failed.
- Annulation propre du mix v7 (42990111673) qui tournait sur l'ancien harnais.

## 8. Résultats consolidés des runs finaux

| Run | Verdict |
|-----|---------|
| release-official-e2e 42992690177 (APK RC14 signée) | **SUCCESS** — e2e-official 37/0, auth-officiel-playstore 10/10, portes dex+apksigner PASS |
| android-ci 42992432920 (a6519b5) | SUCCESS |
| android-e2e-lab 42992432909 (a6519b5) | **SUCCESS 15/15 jobs** |
| pilote offline P4 42994891267 (a6519b5) | SUCCESS — journal PASS, débit PASS, musique offline = online ; télémétrie PARTIAL (fenêtre reconnect) |
| re-run offline 42998315636 (b522290) | FAILURE d'instrumentation (bug 667b pidof) — le rendu offline lui-même avait réussi |
| **re-run final 43000828805 (67b5cd8)** | **SUCCESS — OFFX 3/3 PASS, P4 fermé** |
| android-ci b522290 / 67b5cd8 | 42998293963 / 43000822006 SUCCESS |
| android-e2e-lab 67b5cd8 (HEAD final) | 43000822216 : **16/16 jobs SUCCESS** |

## 9. P4 fermé — re-run avec sonde D42-SYNC (67b5cd8)

**Bug 667 (instrument, résolu)** : le harnais lançait `am start -n
$PKG_APP/.DashboardActivity` — or DashboardActivity vit dans le module
feature-dashboard : la classe réelle est
`video.vitrine.feature.dashboard.DashboardActivity`. Le composant inexistant faisait
échouer `am start` en silence et le repli `.MainActivity` (onboarding) ne déclenche
JAMAIS flushPending — **le dashboard ne s'est donc jamais ouvert dans les runs
offline précédents** : voilà la cause réelle du PARTIAL télémétrie (et non un simple
problème de fenêtre de reconnect). Bug 667b : `pidof` non protégé tuait le script
sous pipefail quand le process était mort (FAILURE d'instrumentation du re-run
42998315636).

**Re-run final 43000828805 (67b5cd8) : SUCCESS — OFFX 3/3 PASS, réserve P4 FERMÉE** :

```
PASS  OFFX_journal_confirme   dernier état journal = CONFIRMED
PASS  OFFX_debit_unique       welcomeCreditsLeft=4 (5 − 1, pas de double débit)
PASS  OFFX_telemetry_sync     1/1 ligne(s) export uploaded=1 après retour réseau
```

Preuve de bout en bout (sonde produit D42-SYNC, logcat app) :

```
10:16:26.292 D42-SYNC: flushPending declenche (retour reseau / dashboard)
10:16:26.315 D42-SYNC: flush telemetry : 1 evenement(s) en attente,
            POST https://vitrine-video-api.mdgejcinfluence.workers.dev/api/v1/telemetry
10:16:26.760 D42-SYNC: flush telemetry : HTTP 200
```

- réseau : coupé AVANT le rendu (dumpsys 101 → none), restauré puis **attendu
  réellement** (none → 102) avant de déclencher le dashboard ;
- DB : `journal RESERVED → CONFIRMED`, débit unique (4), `telemetry uploaded=1` ;
- musique offline : RMS(2-6 s) −17,64 dB — **identique à l'online** ;
- chaine complète prouvée : export hors connexion → file durable → retour réseau →
  dashboard → POST réel vers le worker de production → HTTP 200 → marquée uploaded.

Non-régressions du HEAD final (67b5cd8) : android-ci 43000822006 SUCCESS ;
android-e2e-lab 43000822216 : **16/16 jobs SUCCESS** (a6519b5 : 42992432909 15/15 ;
b522290 : 42998294237 annulé par le push suivant — supplanté).

## 10. Ce qui reste au fondateur (physique, hors périmètre agent)

- Test du compte Google personnel sur l'APK signée (acceptation physique finale).
- Option : relever le cap B2 (0 FCFA dans la console).

## 11. Résultats consolidés

- Défaut produit majeur corrigé et prouvé : l'export musical ne finalisait JAMAIS
  (latent depuis l'origine) — 439c56d.
- 3 modes audio × 4 langues : **12/12 SUCCESS avec preuves acoustiques quantifiées**
  (musique −17,64 dB ; voix notchée −8,05 dB ; mix par soustraction −49,85 dBFS).
- **Réserve P4 offline FERMÉE : OFFX 3/3 PASS** (journal CONFIRMED, débit unique,
  télémétrie uploadée HTTP 200 au retour réseau, musique offline = online), 4 langues
  sur le pilote initial + re-run sonde sur HEAD final.
- **RC14 qualifiée sur l'APK signée : e2e-official 37/0, auth-officiel-playstore
  10/10, portes dex + apksigner PASS** (release 441446648, asset sha256
  a4efd275…f80e78). Les 4 FAIL de la RC13 sont éteints.
- Non-régression : android-ci SUCCESS et android-e2e-lab 15/15 puis **16/16**
  sur les HEAD successifs (a6519b5, 67b5cd8).
- Harnais de preuve remis en état (bugs d'instrument 663-667) — preuves audio
  automatisées, parallèles et observables (sonde D42-SYNC).
- SKYPAY : seule fonctionnalité volontairement non configurée (501).
- Budget : **0 FCFA**.
