# D42.18 — Run E2E rc9 (42387189875) : analyse complète

APK testé : `vitrine-video-0.8.0-b0-d42.18-rc9-official.apk`
SHA-256 `0fbe524138cbdee37abdd5cac68959653701c41abb47464e9a41c84e4a5439e8`
(empreinte recomputée par le workflow depuis l'asset : summary.txt ✓).
Run : 54 min (15:37 → 16:31 UTC), SUCCESS technique.

## Verdict harnais : 34 PASS / 2 FAIL / 1 BLOCKED

| Contrôle | Résultat | Détail |
|---|---|---|
| P1_export_lance | PASS | « Export local en cours… » constaté |
| **P1_notif_fgs** (nouveau) | **PASS** | notification du canal vv_export présente (dumpsys) — **promesse T1 tenue** |
| **P1_ecran_etaint** (nouveau) | **PASS** | 45 s écran éteint → réveil → export poursuivi |
| P1_mp4_extrait | PASS | export-0.mp4 (8 521 124 o) |
| P1_aucun_crash | PASS | aucune FATAL EXCEPTION |
| P1_export_termine | FAIL | « Vidéo prête ! » non affiché en 40 min |
| P1_credit_confirme | FAIL | journal RESERVED (le worker n'a pas fini — cohérent) |
| P1_partage | BLOCKED | bouton non apparu (dépend du précédent) |

## 1. L'objectif de mission FGS est ATTEINT (comparaison rc8 → rc9)

| Mesure | rc8 (avant correctif) | rc9 (avec FGS) |
|---|---|---|
| Interruptions du worker | **4** (raison -512, à 600 s pile) | **0** |
| Démarrages du worker | 5 (même WorkSpec relancé sans fin) | **1** |
| Notification « Export en cours… » | absente | **présente** (canal vv_export) |
| Écran éteint pendant l'encode | non testé | **survécu 45 s, export poursuivi** |
| Travail perdu par redémarrage | 100 % à chaque coupure | **aucun** |

Le mécanisme FGS (dataSync + setForeground + repli silencieux) **élimine les
redémarrages destructeurs** : l'encodage a tourné 41+ min d'un seul tenant
sans jamais être arrêté par le quota JobScheduler.

## 2. Mesures d'export (priorité 4, émulateur API 30 swiftshader)

- Worker démarré 15:49:19 ; tentatives du vérificateur :
  - essai 0 (1080×1920) : 15:49:21 → 16:04:28 = **15 min 09 s** pour 34,99 s
    de vidéo (≈ 26 s d'encodage par seconde de vidéo, codec logiciel) ;
  - essai 1 (720×1280, repli) : 16:04:30 → 16:17:19 = 12 min 49 s ;
  - essai 2 : 16:17:21 → toujours actif à la fin de capture (16:30:23).
- Mémoire (fin de run) : PSS natif ≈ 69 Mo, tas ≈ 80 Mo alloués — **stable**,
  pas de fuite visible ; aucun crash ; « — % » affiché (progression non
  branchée — documenté, cosmétique).
- MP4 extrait (sortie de l'essai 0) : h264 1080×1920, 34,99 s, ~1,95 Mbps,
  **décodage intégral ffmpeg rc=0**. **Non accepté comme réussite** : le
  vérificateur l'a rejeté (voir §3) — conformément à la règle fondatrice.

## 3. Défaut produit latent révélé : l'export n'a pas de piste audio
   quand le gabarit en attend une

Chaîne de preuves (logcat rc9 + code) :
1. `D42-VERIF essai=0/1 : … verif=Checks(durationOk=true, resolutionOk=true,
   bitrateOk=true, nonBlackFrames=3, audioVerdict=ECHEC)` — **tous les
   critères VIDÉO passent** ; seul l'audio échoue : `hasAudioTrack=false`
   alors que le gabarit a planifié BGM/SFX (`audioAttendu=true`).
2. La comparaison avec rc6/rc7 (D42.17) : leurs exports **n'avaient pas non
   plus de piste audio** (ffprobe : seul flux vidéo), mais leurs gabarits
   n'en attendaient pas → silence « par construction », vérificateur PASS.
   Le harnais n'a pas d'étape musique : la présence audio attendue dépend du
   **gabarit tiré au hasard** — rc9 a tiré un gabarit audio → défaut révélé.
3. Cause racine (double, établie par lecture du code + logcat) :
   - **les rushs tournés sur l'émulateur CI sont vidéo-seuls** (aucun codec
     audio instancié pendant l'export ; RECORD_AUDIO pourtant pré-accordé par
     `pm grant` dans le harnais) ;
   - **la musique/SFX n'entrent jamais dans la composition** comme item
     audio (`MotionComposition.fromClientRushes` = rushs seuls) ; le
     `BgmSfxAudioMixer` est un **décorateur** de l'audio des items — sans
     entrée audio, media3 ne crée pas de piste de sortie, mixer ou pas.
4. Conséquence observée : repli 1080p → 720p → … jusqu'à échec définitif +
   compensation du crédit (conforme au contrat, aucune perte — rc5 a prouvé
   le remboursement).

**Ce défaut est INDEPENDANT du correctif FGS** (le chemin audio n'est pas
touché ; il était invisible en D42.17 par tirage de gabarits sans audio).

**Décisif : le test sur téléphone réel.** Si les rushs du téléphone portent
la voix (RECORD_AUDIO accordé à la demande système), le mixer reçoit une
entrée → musique + SFX mixés → piste audio présente → vérificateur PASS.
Si le téléphone produit aussi des rushs muets, le correctif produit est :
ajouter la BGM comme `EditedMediaItem` audio dans la composition (fix
documenté, à chiffrer dans un cycle dédié — ne pas bricoler en fin de mission).

## 4. Crédits (priorité 5)

- `export_journal` : **1 seule ligne RESERVED** (mono-débit confirmé encore),
  solde 3→2 ; jamais COMPENSATED parasite.
- L'état CONFIRMED n'a pas été atteint **uniquement parce que l'export n'a
  pas terminé dans la fenêtre** (l'essai 2 tournait encore) — cohérent, pas
  une anomalie de crédit.
- Aucune double consommation sur aucun run D42.17/D42.18 ; remboursement à
  l'échec prouvé (rc5).

## 5. Itérations du cycle (traçabilité)

- build-1 (42385184417, FAILURE 63 s) : erreur réelle invisible — le
  `tail -40` tronquait la sortie Gradle (défaut de mesure, corrigé) ;
- build-2 (42385542924, FAILURE) : tâche `testReleaseUnitTest` inexistante
  sous AGP 9 → `testDebugUnitTest` (convention du dépôt, 9 jobs verts) ;
- build-3 (42385848577, FAILURE) : **le code principal compile** — 2 défauts
  dans le seul fichier de TEST (getApplication non générique ; smallIcon est
  un Icon) ;
- **build-4 (42386176290, SUCCESS)** : compilation + **tests unitaires 5/5,
  0 échec** (dont `ExportForegroundInfoTest` **4/4**) + APK R8 ;
- signature officielle locale (option C) : zipalign OK, **unique certificat
  758077eb…33e192, v2+v3** ; release `d42.18-rc9` (437663102) + asset
  (44 141 502 o, HTTP 201, uploaded) ;
- incidents de publication réparés et documentés : release créée avant le
  tag → tag auto sur `main` (mauvais commit, aucun run déclenché — vérifié),
  tag supprimé/repoussé au bon commit `445fc97`, release repassée en
  published dans la fenêtre de réessai du workflow ;
- **E2E 42387189875 (SUCCESS, 54 min)** — présent document.
