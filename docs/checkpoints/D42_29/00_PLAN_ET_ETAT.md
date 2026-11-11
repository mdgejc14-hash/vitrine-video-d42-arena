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
