# D42.29 — Matrice de validation (modes audio + RC14)

Statuts : PASS / PARTIAL / FAIL / BLOCKED / NOT RUN. Environnements : **lab** (émulateur CI
avec SwiftShader, APK debug), **prod** (Worker/D1/B2/Firebase réels), **physique** (test
fondateur, jamais simulé). Tous les rendus ci-dessous utilisent le gabarit
`shops_small_business_T1` (35 s), profil validation 540×960, rushes de banc, API 34.

## Conventions de mesure (étage 4 du harnais `d42-render.sh`)

`rms_2_6` = RMS fenêtre 2-6 s (post-fade-in 0,45 s) ; `rms_voix_5_8` = fenêtre rush vocal
(sinus 440 Hz) ; `rms_voix_sans_440` = même fenêtre NOTCHÉE à 440 Hz. Le seuil strict
« musique audible » (−28 dB) ne s'applique qu'au mode musique ; en mix la preuve est
différentielle (notch + soustraction).

## P2 — Preuve audio : musique réellement audible et décodable

| # | Exigence | Fonctionnalité | Commit | Workflow (run) | Résultat | Artefact | Statut | Réserve |
|---|----------|----------------|--------|----------------|----------|----------|--------|---------|
| P2-1 | Instrumentation distinguant panne GPU / absence de musique | `d42-render.sh` 4 étages : 1 décodeur (D42-BGM), 2 mixeur (D42-MIX), 3 symptômes vidéo swiftshader, 4 mesures acoustiques TSV (11 colonnes) ; modes musique/voix/mix + variante offline | ae5e5b0 | pilot v1 (42975000342, ae5e5b0) | Décodeur PROUVÉ on-device : titulaire shops 3 360 764 éch., 44 100 Hz, RMS −16,6 dB (≈ mesure locale ffmpeg −16,62) ; MP4 de tentative avec piste AAC complète RMS −17,07 dB, fenêtre 2-6 s −17,64 dB, décodage sans erreur | artefacts d42-renders-fr-1 (pilot v1) | PASS | worker FAILED (voir P2-2/4) |
| P2-2 | Toute ExportException journalisée | onError des 2 runExport : code `getErrorCodeName` + msg + cause + throwable ; trace par tentative (stratégie VerifierPolicy, géométrie, sortie partielle) | 7e4ebfa | pilots v2 (42977738361) / v3 (42978298681) | **Identité obtenue : `ERROR_CODE_MUXING_TIMEOUT` — « Abort: no output sample written in the last 25000 milliseconds »**, identique sur les 3 tentatives (540×960, 360×640 portrait, encodeur logiciel) | logs jobs + logcat-complet | PASS | la cause racine restait à trouver (P2-4) |
| P2-3 | L'alimentation musique/SFX ne dépasse pas la composition | `feedPcm(maxFrames)` + caps musique/SFX + enveloppe et borne sur la même durée effective | f7d20fe | pilot v3 : MP4 partiel ffprobe | **audio 34,956 s ≤ vidéo 34,989 s** (v1 : 38,044 s — 3 s de silence muxé) ; test JVM 45 s/33 s : trames ≤ cap | artefact pilot v3 | PASS | — |
| P2-4 | Cause racine du cale de finalisation corrigée | `drainMusique` : retrait de la source à la fin de l'alimentation — `DefaultAudioMixer.isEnded()` exige `sources.size()==0` et Media3 n'appelle jamais `setEndTimeUs` sans trimming ; source lue sur androidx/media 1.11.1 | 439c56d | pilot v6 (42984967143, 73f1947) | **worker=SUCCEEDED tentative 0 en 148 s**, MP4 13 Mo, AudioChecks OK (audio 34 992/35 000 ms, durationOk/resolutionOk/bitrateOk) — premier export musical JAMAIS finalisé avant ce fix (v1/v2/v3, P3 v13/v14, banc A) | artefact d42-renders-fr-1 (v6) | PASS | — |
| P2-5 | Preuve acoustique finale en CI verte (4 langues) | étage 4 strict : piste présente + decode_err=0 + RMS(2-6 s) > −28 dB | a6519b5 | **42992443312 (musique, fr/en/es/ja, SUCCESS)** | fr : RMS 2-6 s = **−17,64 dB** ; global −16,71 ; intro −31,95 (fade-in 0,45 s) ; fin 3 s −16,57 ; 0 erreur de décodage ; 4/4 langues vertes avec profil identique | audio_mesures.tsv (4 langues) | PASS | — |

## P3 — Les 3 modes audio × 4 langues

| # | Exigence | Fonctionnalité | Commit | Workflow (run) | Résultat | Artefact | Statut | Réserve |
|---|----------|----------------|--------|----------------|----------|----------|--------|---------|
| P3-M | Mode MUSIQUE (rushs muets + BGM gain solo) — fr/en/es/ja | base silencieuse D42.21 + titulaires de production en cache | a6519b5 | 42992443312 | 4/4 langues SUCCESS ; mesures identiques (contenu audio déterministe) : RMS 2-6 s −17,64 dB, MP4 ≈ 13 Mo | audio_mesures.tsv ×4 | **PASS** | — |
| P3-V | Mode VOIX (rushs audio + cache BGM VIDE, pass-through) — fr/en/es/ja | le banc vide files/bgm et l'assert (cache vide) | a6519b5 | 42992447010 | 4/4 langues SUCCESS ; voix RMS 5-8 s = **−21,15 dB**, notchée 440 Hz → **−29,20 dB (chute 8,05 dB = voix dominante)** ; 0 ligne D42-BGM (aucune musique décodée — repli honnête prouvé) ; decode 0 err | audio_mesures.tsv ×4 | **PASS** | — |
| P3-X | Mode MIX (voix + BGM titulaire, ducking voix prioritaire) — fr/en/es/ja | mixeur complet : voix + musique −20 dB base + ducking −14 dB + 9 SFX | a6519b5 | 42992451479 | 4/4 langues SUCCESS ; voix dominante (notch : −8,05 dB) ; **musique PRÉSENTE : soustraction échantillon par échantillon (mix − voix) sur la piste entière = RMS −49,85 dBFS, exactement le niveau ducké du contrat (base −36,6 dB − ducking)** ; D42-BGM décodée (−16,6 dB) ; decode 0 err | audio_mesures.tsv ×4 + PCM diff | **PASS** | le lit musical ducké est inaudible en RMS pendant la voix (contrat voix_prioritaire) — non un défaut |
| P3-v14 | Campagne P3 v14 (parcours UI complet, D42.28) | — | c227318 | 42832699504 | fr/en/es : 24 PASS / 3 FAIL par langue. **Réinterprété D42.29 : les 3 FAIL (« aucune fin d'export en 75 min », RMS intro −55 dB) dérivaient du défaut produit P2-4 (source musique jamais retirée), PAS d'une limite swiftshader.** La « limite instrumentale » de D42.28 n'en était pas une | artefacts e2e-p3 | PASS (cause close) | — |

## Harnais de preuve (qualité de l'instrument)

| # | Exigence | Fonctionnalité | Commit | Workflow (run) | Résultat | Statut |
|---|----------|----------------|--------|----------------|----------|--------|
| H-1 | CI verte sur les correctifs produit | detekt : drainFeeds scindé (complexité 17→<15), doWorkInner allégé (89→~74 lignes), 2 lignes >140 ; banc ducking : `compositionDurationUs=0L` (artefact du délégué captif démontré en JVM isolée : avec borne retourDb −13,99 / sans borne −0,33) | a87eef8 | android-ci 42980864065 | SUCCESS (98 tests dont « fin de mix sans setEndTimeUs ») | PASS |
| H-2 | Étage 4 opérable | `grep -c … || echo 0` doublait le zéro (« 0\n0 ») ; regex RMS attrapait l'adresse hexa de ffmpeg (« 0 dB ») ; reliquat cache-export-1.mp4 51 octets tuait le script sous pipefail ; concurrence par mode audio (les 3 preuves en parallèle) | e308a94 + a6519b5 | pilots v6/v7 vs 42992443312/42992447010/42992451479 | v6 : crash silencieux ligne 337 ; v7 : crash mesure_rms ; final : 3 runs verts avec TSV complets | PASS |

## Livraison — RC14

| # | Exigence | Fonctionnalité | Commit | Workflow (run) | Résultat | Artefact | SHA-256 | Statut | Réserve |
|---|----------|----------------|--------|----------------|----------|----------|---------|--------|---------|
| R-1 | APK RC14 depuis HEAD (contient BgmDecoder 8cb9a7d + les 3 fixes D42.29) | tag d42.29-build-rc14 (5736355) | 5736355 | release-official-build 42990176193 | SUCCESS : tests unitaires feature-export PASS, APK R8 44 133 897 o, porte dex PASS | release-build-unsigned | 5e520f6f…4f353 (non signée) | PASS | — |
| R-2 | Signature officielle locale (keystore jamais committé) | zipalign + apksigner (build-tools r34) | — | — | **cert SHA-256 758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192** (identique RC12/RC13), SHA-1 89fab9b6…cd8a3, .idssig v4 | vitrine-video-rc14.apk (44 161 982 o) | a4efd275…f80e78 | PASS | — |
| R-3 | Release privée + E2E sur l'APK signée | release prerelease d42.29-rc14 | 5736355 | release 441446648 ; release-official-e2e 42992690177 | asset publié ; E2E ⏳ | asset release | a4efd275…f80e78 | ⏳ | à compléter |
| R-4 | Non-régression CI/lab sur HEAD final | — | a6519b5 | android-ci 42992432920 SUCCESS ; android-e2e-lab 42992432909 ⏳ | CI verte ; lab ⏳ | — | — | ⏳ | à compléter |

## P4 — Réserve offline (export hors connexion)

| # | Exigence | Fonctionnalité | Commit | Workflow (run) | Résultat | Statut | Réserve |
|---|----------|----------------|--------|----------------|----------|--------|---------|
| P4-1 | MP4 final créé SANS réseau, musique en cache, décodage complet, retour réseau, synchronisation, débit unique | `offline=1` : réseau coupé pendant le rendu, DB avant/après, retour réseau + Dashboard (flushPending), verdicts OFFX_journal_confirmed / OFFX_debit_unique / OFFX_telemetry_sync | a6519b5 | 42994891267 (fr, musique, titulaires) | ⏳ en cours | ⏳ | à compléter |

## Non ciblé par D42.29

- Test du compte Google personnel : réservé au fondateur (acceptation physique finale).
- SKYPAY : seule fonctionnalité volontairement non configurée (501).
- RC12/RC13 : releases maintenues, non remplacées.
