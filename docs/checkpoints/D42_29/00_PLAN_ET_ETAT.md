# D42.29 — RC14 + clôture des réserves audio commerciales

## Mission (demande utilisateur 11/11)

Reprise depuis le checkpoint 0ac2aa9 (D42.28 clos). Cinq réserves à fermer :

1. **RC14** intégrant RÉELLEMENT le correctif BgmDecoder 8cb9a7d (postérieur au
   build RC13/195d813). Ne pas reconstruire inutilement les composants validés.
2. **Preuve audio réelle ciblée** : décodeur, mixeur, rendu, MP4 final. Une
   méthode d'instrumentation qui DISTINGUE une panne GPU de l'absence de
   musique. Pas de campagnes de 75 min sans diagnostic.
3. **Trois modes audio** (musique / voix / mix) prouvés pour FR, EN, ES, JA.
   P3 v14 CANCELLED ; voix et mix SKIPPED — ne pas les déclarer PASS sur la
   foi de v14. Réutiliser les cellules musique déjà exécutées.
4. **Réserve offline fermée** : MP4 final créé SANS réseau, musique en cache,
   décodage complet, retour réseau, synchronisation, absence de double débit
   (le 37/4 reste PARTIAL tant que ce n'est pas prouvé).
5. **RC14 signée** : certificat officiel, SHA-256 vérifié, E2E sur l'APK
   réellement signée. Le PASS Firebase technique de RC13 est conservé (ne pas
   refaire la campagne) — vérifier seulement que RC14 embarque la même
   configuration réelle, le certificat OAuth correspondant et la porte dex
   verte. Test du compte Google personnel = l'utilisateur, à l'acceptation.

SKYPAY reste la seule fonctionnalité volontairement non configurée. Budget
strict : 0 FCFA. GitHub = seule mémoire durable.

## État initial vérifié (recon, 11/11)

- Sandbox restauré une 3e fois à 8d530b1 (fin D42.27) + arbre de travail
  périmé mi-D42.28 : récupéré (remote reconstruit, fetch, reset --hard
  0ac2aa9). Zéro perte : tous les fichiers untracked étaient identiques au
  fond poussé (diff de contrôle fait).
- Nouveau PAT utilisateur enregistré : `~/.d42_secrets/gh_pat_2026_10_17.txt`
  (les deux anciens fonctionnent toujours — testés 200).
- **8cb9a7d (fix BgmDecoder) est ancêtre de HEAD 0ac2aa9** ✓.
- **Lab non-régression 42890254811 sur 0ac2aa9 : 16/16 SUCCESS** (dont
  offline-export, p1, langues ×3, security-local, auth) — socle RC14 vert.
- **Config Firebase inchangée entre 195d813 (RC13) et HEAD** (aucun fichier
  google-services/strings touché) → le PASS Firebase de RC13 se reporte ;
  restent à re-vérifier au build RC14 : porte dex + porte certificat.
- **Keystore officiel INTACT** (2 copies identiques) : SHA-256
  75:80:77:EB:…:33:E1:92 = 758077eb…33e192, SHA-1 89fab9b6…cd8a3 —
  identiques RC12/RC13. Aucun blocage de signature.
- Aucun run actif au moment de la reprise.

## Découverte clé (recon) — l'instrumentation ciblée existe déjà

`ProductionRenderInstrumentedTest` (app/src/androidTest) pilote la VRAIE
chaîne : ExportActivity (porte + réservation crédit) → WorkManager →
ExportWorker → RushSlots → MotionComposition → KineticTypography →
**BgmSfxAudioMixer (BGM + 9 SFX)** → Transformer Media3 → ExportVerifier →
MP4 réel. Le workflow `d42-virtual-render` l'exécute sur émulateur avec :
- **profil validation 540×960** : MÊME chaîne (moteur, composition, audio,
  effets, ducking), géométrie seule réduite (≈4× moins de pixels) ;
- fixtures : 3 rushs 12 s 720×1280 H.264+AAC (sinus 48 kHz) — **les rushs de
  fixture portent DÉJÀ une piste audio** → voix/mix testables nativement ;
  6 BGM de secteur en cache réel (filesDir/bgm) ; voix_reference.m4a ;
- mesure par rendu dans manifest.jsonl (durée, SHA-256, état worker).

Le test actuel = mode « mix » de fait (rushs audio + BGM). Manquent : rushs
MUETS (mode musique, gain solo — cf. ExportWorker baseSilencieuse), variante
SANS BGM (mode voix, pass-through), vérification ACOUSTIQUE sur le runner,
variante hors connexion.

## Plan

- **P1 (RC14)** : build APRÈS les preuves (pour inclure l'observabilité) ;
  tag d42.29-build-rc14 → release-official-build → re-signature locale
  (keystore officiel) → release privée d42.29-rc14 → release-official-e2e.
- **P2 (preuve audio ciblée, par étages)** :
  1. décodeur : log BgmDecoder (échantillons, cadence, durée de drain, RMS du
     PCM décodé) — observabilité produit, sans changement de comportement ;
  2. mixeur : log BgmSfxAudioMixer (chunks mixés, RMS, crête) ;
  3. rendu + MP4 : d42-render.sh vérifie ffprobe + décodage intégral + RMS
     global/intro (2 s) avec seuils PAR MODE (musique/mix : intro > −28 dB ;
     voix : intro < −40 dB) ;
  4. **séparation GPU/musique** : rendu complet en 540×960 (chaîne audio
     identique, résolution indépendante de l'audio) AVEC musique audible =
     chaîne audio PROUVÉE ; les non-terminaisons 1080×1920 (banc A v3.7,
     P3 v14 : Forcing EOS ×75, Surface unknown buffer) = débit de rendu vidéo
     swiftshader, non une absence de musique. Compteurs logcat à l'appui.
- **P3 (modes × langues)** : matrice ciblée 3 modes × 4 langues × T1 en
  profil validation via d42-virtual-render étendu (arg d42_audio_mode) ;
  s'ajoute aux cellules parcours UI déjà acquises (v13 : brief_valide 4/4 +
  parcours ja ; v14 : fr/en/es 24/3) — le parcours UI est identique pour
  tous les modes (seule la préparation audio diffère, hors UI).
- **P4 (offline)** : variante offline du rendu ciblé : réseau coupé (svc
  wifi+data, preuve dumpsys) AVANT l'instrumentation, BGM en cache, mode
  musique ; MP4 tiré + décodé + RMS ; retour réseau ; preuves DB (journal
  CONFIRMED, solde décrémenté de 1 exactement) + logcat (sync outbox).
  L'idempotence serveur (rejeu ×3 → 1 débit) est déjà prouvée P2-B 69/0.
- **P5 (RC14)** : cf. P1 + diff config vérifié (déjà fait à vide) + portes
  dex/cert au build + E2E sur APK signée (release-official-e2e) + SHA-256.

## Journal d'exécution

- **11/11 (reprise)** : recon complète (sandbox récupéré, PAT testés,
  keystore vérifié, 8cb9a7d ancêtre, config Firebase inchangée, lab 16/16 à
  0ac2aa9, aucune perte de fond). Plan posé.
- **11/11 (D42.29-00, 5418937)** : checkpoint poussé.
- **11/11 (D42.29-01, ae5e5b0)** : instrumentation implémentée et poussée :
  - **Étage 1** BgmDecoder (D42-BGM) : échantillons/cadence/durée/RMS/crête
    du PCM décodé + exception journalisée (la racine du bug post-RC13 était
    précisément une exception avalée) ;
  - **Étage 2** BgmSfxAudioMixer (D42-MIX) : trames musique alimentées, RMS
    voix (échelle normalisée 0..1 — double division corrigée avant commit),
    cues SFX, duck final, dégradé ;
  - **Étage 3** d42-render.sh : symptômes vidéo comptés (Forcing EOS,
    Surface unknown buffer) ;
  - **Étage 4** : ffprobe + décodage intégral + fenêtres RMS (global, 0-2 s,
    2-6 s post-fade-in, fin 3 s, voix 5-8 s, voix notchée 440 Hz) ;
  - **Modes** : d42_audio_mode mix|musique|voix — rushs MUETS générés et
    committés (rushes_muets, rushes_muets15, mêmes specs que les sonores,
    vidéo seule) ; voix = cache BGM vidé avant rendu ;
  - **Titulaires** : d42_bgm_source=titulaires — 6 pistes de production
    (mesuré localement : musique_t1_shops_small_business.m4a = 38,1 s,
    RMS −16,62 dB, intro 2 s −26,9 dB ; fixtures à −39 dB écartées pour la
    preuve d'audibilité) ;
  - **Offline** : offline=1 — coupure svc avant instrumentation, preuves
    dumpsys, DB avant/après retour réseau, relance Dashboard (flushPending),
    verdicts journal/solde unique/télémétrie ;
  - workflow : entrées audio_mode/bgm_source/offline + secret
    FIREBASE_WEB_API_KEY + timeout rendu 2700 s.
  - Mesures préparatoires : SFX T1 scène-dépendants (whoosh en scène 1) ;
    contrat mix = musique −20 dB sous voix + ducking −14 dB → le critère
    P3 historique « intro > −28 dB » est INADAPTÉ au mix : la preuve mix
    sera différentielle (notch 440 Hz + fenêtres) et prononcée à l'analyse
    des mesures, seuils documentés.
- **11/11 06:48 UTC** : PILOT dispatché — run **42975000342** (d42-virtual-render,
  musique/titulaires/FR, shops_small_business_T1, validation 540×960,
  run_smoke=0 [APK prouvé lab 16/16 à 0ac2aa9, le pilot valide le harnais]).
  En parallèle : android-ci + e2e-lab ae5e5b0 (non-régression, compile les
  changements Kotlin).
- **11/11 ~07:15 UTC — PILOT v1 : RÉSULTATS MAJEURS (42975000342, failure)** :
  1. **Décodeur PROUVÉ sur appareil** : `D42-BGM : BGM DÉCODÉE : 3 360 764 éch.
     44100 Hz 2 can. en 4056 ms — RMS −16,6 dB, crête −1,8 dB` (titulaire
     shops_small_business, identique à la mesure locale ffmpeg −16,62 dB).
  2. **Le MP4 produit contient la musique** : cache-export-1.mp4 (6 027 288 o),
     vidéo 34,989 s / 525 frames (15 fps, profil validation), audio 38,044 s /
     1640 trames AAC, **RMS global −17,07 dB, fenêtre 2-6 s −17,64 dB,
     décodage ffmpeg sans erreur** → chaîne audio complète
     (décodeur → mixeur → encodeur AAC → muxer) PROUVÉE. Gain solo confirmé.
  3. **Le worker a pourtant déclaré FAILED/CLOUD** : calage vidéo en fin de
     rendu (Surface unknown buffer, 60 slots non peuplés à la libération) ;
     tentatives de repli 1-2 mortes en ~30 ms ; runCatching onError avalait
     l'ExportException SANS trace (même anti-pattern que le bug BgmDecoder).
  4. **2e DÉFAUT PRODUIT CRITIQUE découvert** : piste audio 38,044 s pour une
     vidéo de 34,989 s — feedPcm muxait TOUT le titulaire (silence en queue
     après la fin de composition). AudioChecks (tolérance 250 ms) aurait
     rejeté l'export → CLOUD_MODAL. **Tout export musical réel aurait échoué
     au vérificateur, y compris sur appareil physique.**
- **11/11 (D42.29-02, 7e4ebfa)** : ExportWorker — exceptions Transformer
  journalisées (code getErrorCodeName + message + cause + trace) + trace par
  tentative (stratégie VerifierPolicy, géométrie, sortie partielle). Pilot v2
  dispatché sur ce commit pour l'IDENTITÉ de l'exception.
- **11/11 (D42.29-03, f7d20fe)** : **FIX PRODUIT du bornage** — feedPcm borne
  l'alimentation musique/SFX à la durée de composition (maxFrames, décalage
  musicStartUs pris en compte, enveloppe et borne partagent la même durée
  effective). Test JVM de non-régression ajouté (45 s de musique / composition
  33 s → trames muxées ≤ cap) ; test F60 mis à jour (queue exactement à la
  fin, atténuée — l'ancienne attente amplitude 0 supposait le défaut).
  Pilot v3 dispatché sur f7d20fe pour valider le correctif.
- **11/11 (D42.29-04, a87eef8) : CI remis au vert sur le fix bornage** :
  - android-ci f7d20fe (42978298959) FAILURE : detekt (drainFeeds complexité
    17, doWorkInner 89 lignes, 2 lignes > 140) + VRAIE régression détectée :
    MixBenchAudioTest « ducking » (retourDb −13,99). Cause : artefact du banc
    — le délégué CAPTIVE avale un débit illimité, avec la borne posée toute
    la musique est poussée pendant la 1re phase de parole → la remontée entre
    les phrases devient inobservable. Reproduit et vérifié en JVM isolée
    (kotlinc + stubs media3, /tmp/repro) : avec borne FAIL / sans borne PASS,
    profondeur −14,00 dans les deux cas. Correctif : compositionDurationUs=0L
    dans CE banc (les volumes commandés ne dépendent pas de la borne).
  - Refactor : drainFeeds → drainFeeds+musiqueEffectiveUs+outputRate+
    drainMusique+drainSfx (comportement identique au bit près en repro) ;
    doWorkInner allégé (preparerBaseSilencieuse extraite) ; detekt-cli 1.23.8
    local (config du repo) : 0 code smells. **android-ci a87eef8 (42980864065)
    : SUCCESS.**
- **11/11 — PILOTS v2 (42977738361) ET v3 (42978298681) : FAILURE — diagnostic
  complet obtenu (le logging D42.29-02 a fonctionné)** :
  - Build OK (le champ mixerStartTimeUs compile). Rendu « lot 1/8 » FAILED.
  - v3 : les 3 tentatives (540x960 / 360x640 portrait / encodeur logiciel)
    échouent IDENTIQUEMENT : `ERROR_CODE_MUXING_TIMEOUT — Abort: no output
    sample written in the last 25000 milliseconds`.
  - **MP4 partiel (ffprobe) : audio 34,956 s ≤ vidéo 34,989 s → LE BORNAGE
    f7d20fe EST OPÉRANT sur appareil** (v1 : audio 38,044 s). Les deux pistes
    sont complètes (525 frames = 35 s à 15 fps) ; l'AAC s'arrête 43 ms avant
    sa fin → EOS audio jamais émis.
  - Logcat teardown : thread GL bloqué DANS dequeueBuffer (« freeAllBuffers: 1
    buffers were freed while being dequeued », « unpopulated slots [7..63] »,
    4 buffers AAC « discarded ») — le GL est VICTIME : la finalisation
    n'arrive jamais.
- **11/11 — CAUSE RACINE IDENTIFIÉE (défaut produit, pas swiftshader)** :
  `setEndTimeUs` n'est JAMAIS appelé par Media3 (jamais appelé sans trimming ;
  0 log « fin de mix » dans les pilots) ; or DefaultAudioMixer.isEnded()
  exige `sources.size() == 0` (source lue sur androidx/media 1.11.1) et la
  source musique n'était JAMAIS retirée (drainMusique ne faisait aucun
  removeSource ; seul setEndTimeUs — jamais appelé — le faisait). → l'audio ne
  signale jamais sa fin → le Transformer ne finalise pas → plus aucun
  échantillon muxé → watchdog MUXING_TIMEOUT.
  **Réinterprétation de l'historique** : les runs verts 41811176998
  (validations fr/en/es/ja « success », 7 MP4 en 745 s) ont 0 ligne
  D42-MIX/D42-BGM dans leur logcat → rendus SANS graphe audio (BGM fixtures
  jamais injecté). TOUT rendu au mixeur actif (P3 v13/v14 « aucune fin
  d'export en 75 min », banc A, pilots v1/v2/v3) a calé. La « limite
  instrumentale swiftshader » de D42.28 était CE défaut produit.
- **11/11 (D42.29-05, 439c56d) : FIX PRODUIT — retrait de la source musique à
  la fin de l'alimentation** (drainMusique : removeSource quand musicFedFrames
  ≥ min(taille, capMusique) ; le contrat Media3 préserve le matériel en file).
  Test JVM « fin de mix sans setEndTimeUs » (flux Media3 réel, celui du
  bornage masquait le défaut en appelant setEndTimeUs). Repro isolée : musique
  alimentée exactement au cap (1 584 000 trames), toutes sources retirées.
  Nota : SFX théoriquement non alimentés si programmés après la fin de la
  source voix en mode mix (non observé — documenté).
- **Pilots discriminants v4 (shops+fixtures) / v5 (restaurants+titulaires)
  dépêchés sur a87eef8 (pré-fix, contrôles attendus en échec)** ; pilot v6
  (shops+titulaires+musique) à dispatcher sur 439c56d dès android-ci vert →
  si worker SUCCESS + AudioChecks PASS + RMS 2-6 s > −28 dB = **PREUVE P2
  COMPLÈTE (export musical audible, borné, finalisé)**.
