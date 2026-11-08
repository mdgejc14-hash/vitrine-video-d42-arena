# D42.21 — 01. ARCHITECTURE DES 20 VARIATIONS + CORRECTIF AUDIO EXPORT

**Date** : 08/11/2026. **Parent** : `4581777` (D42.20). **Branche** : `d42.13-lab`.

## 1. Défauts à corriger (racines prouvées par lecture de code)
- **D1 (sélection)** : `routeAudioTrack` (src/index.js:1952) sert l'objet titulaire sinon le
  repli `ORDER BY variation LIMIT 1` (l.1996). `BgmStore.ensureGabaritCached`
  (BgmStore.kt:46) télécharge UNE piste par catégorie → l'utilisateur n'entend jamais que
  la variation 1. Les 20 variations existent dans D1 `bgm_library` (schéma 0011/0012,
  colonnes variation + sha256 + object_key) mais aucune route ne permet d'en obtenir une
  précise, et la route library ne sert pas le sha256.
- **D2 (export muet, défaut D42.18)** : `BgmSfxAudioMixer` (AudioMixer Media3) ajoute
  musique/SFX comme sources internes au graphe audio du Transformer. Si AUCUN rush n'a de
  piste audio (commerçant muet), le graphe audio n'existe pas → mixeur jamais invoqué →
  MP4 sans piste audio. En outre la musique est calée à −20 dB (niveau « sous voix »,
  AudioChain.MUSIC_VOLUME_DB) MÊME sans voix : scénario A (musique seule) inaudible.

## 2. Conception cible (minimale, testable, réversible)
### Serveur (src/index.js)
- `routeAudioLibrary` : ajouter `sha256` au SELECT (1 colonne, réponse compatibilité
  conservée — champs existants inchangés).
- `routeAudioTrack` : paramètre query `?v=N` (entier 1..20). Présent → sélection dans
  `bgm_library` (`categorie_audio=? AND variation=? AND statut='EN_LIGNE'`) → service de
  l'object_key avec Range 206 + cache bord (clé = categorie+v+epoch). Absent → comportme nt
  actuel (titulaire → repli v1). Aucune autre route : le client liste les 20 via
  `/api/v1/audio/library?secteur=&format=` (déjà existant, filtre exact du gabarit).
### Android (data)
- `BgmLibraryParser` (NOUVEAU, pur JVM) : parse la réponse library → `Variation(pisteId,
  categorieAudio, gabaritId, variation, sha256, tailleOctets, statut)`.
- `BgmSelection` (NOUVEAU, pur JVM) : choix parmi les 20 — uniforme parmi les variations
  `EN_LIGNE` n'étant pas dans l'historique des K=4 dernières utilisées du gabarit ; si
  toutes récentes → uniforme parmi toutes ; `Random` injectable (déterministe en test,
  SecureRandom en production). Jamais de mélange secteur/gabarit : la liste candidate est
  TOUJOURS celle du gabarit (filtre serveur + vérification client gabarit_id).
- `BgmStore` : `ensureGabaritCached` devient : catalog → gabarit → liste des 20 (library
  filtrée, cache disque `library_{secteur}_{format}.json`) → sélection → cache local
  `files/bgm/{piste_id}.mp3` sinon téléchargement `track/{categorie}?v={n}` →
  **vérification sha256** (MessageDigest) + taille → adoption des fichiers legacy
  (`{categorie}.mp3`) uniquement si leur sha correspond à la variation choisie →
  historique `files/bgm/historique.json` (par gabarit, 4 entrées max). Repli complet
  conservé : échec quelconque → chemin titulaire actuel (track sans ?v) → jamais d'échec
  d'export dû à la musique.
### Android (export)
- `BgmSfxAudioMixer` : paramètre `musicBaseGainDb` (défaut −20 dB inchangé). Scénario
  sans voix → 0 dB (musique pleine, calibration −16 LUFS du fichier déjà assurise par
  génération). Ducking inchangé (sidechain voix ; base silencieuse = pas de ducking).
- `MotionComposition.fromClientRushes` : paramètre optionnel `audioBaseUri` (+ durée) →
  ajoute une SÉQUENCE parallèle contenant un item audio (base silencieuse) → le graphe
  audio existe toujours quand une musique est planifiée.
- `ExportWorker` : sonde les rushs (MediaExtractor : piste audio présente ?). Si musique
  planifiée ET aucun rush audio → génère un WAV silencieux (durée = expectedMs, cap 120 s)
  dans cacheDir → base audio de la composition + mixeur en gain solo (0 dB) ; WAV supprimé
  en fin d'export. `audioAttendu` du vérificateur déjà cablé (D42.8.1) → deviendra VRAI.

## 3. Scénarios voix/musique couverts
- **A (sans voix, avec musique)** : base silencieuse + musique 0 dB + SFX → MP4 AVEC piste
  audio (le défaut D42.18 est corrigé ; preuve = ffprobe E2E + vérificateur).
- **B (voix + musique)** : chemin actuel (voix = base, musique −20 dB + ducking gabarit).
- **C (voix seule)** : mixerFactory null (pas de BGM planifiée) → pass-through voix.
- **D (sans voix ni musique)** : vidéo muette, `audioAttendu=false` (vérificateur ne
  l'exige pas) — conforme contrat (silence seulement si le gabarit le prévoit).
- La voix reste 100 % facultative (aucune obligation de parler ; guides inchangés).

## 4. Sécurité / performance
- Aucun secret dans le catalogue ; liens toujours protégés par Bearer Firebase (auth
  utilisateur), service via Worker (jamais de clés B2 côté client).
- Cache définitif `files/bgm/` (survie au vidage de cache) ; 1 fichier ≈ 700 Ko ; pas de
  téléchargement des 600 — uniquement la piste sélectionnée du gabarit en cours.
- Anti-répétition locale (historique.json) ; sélection aléatoire production /
  déterministe tests (Random injecté).
- Intégrité : sha256 vérifié après téléchargement (et pour l'adoption des fichiers
  legacy) ; échec → repli titulaire → jamais de piste d'un autre gabarit (filtre serveur
  par secteur+format + contrôle gabarit_id côté client).

## 5. Tests (pyramide : unité JVM → intégration → E2E émulateur)
- `BgmLibraryParserTest` (unité, JVM) : parsing 20 variations, champs invalides ignorés.
- `BgmSelectionTest` (unité + propriétés) : uniformité sur grand N, anti-répétition K=4,
  jamais hors gabarit, déterminisme avec Random seedé, références manquantes.
- `MotionCompositionTest` (existant à étendre) : 2 séquences quand base audio fournie.
- `MixPlanTest`/`BgmSfxAudioMixerMultiRushTest` (existants) : gain solo sans casser le
  comportement voix (−20 dB + ducking).
- E2E émulateur (android-e2e-lab, push d42.13-lab) : export gabarit BGM sans voix →
  ffprobe DOIT montrer une piste audio (retournement du FAIL D42.18).
- Worker : sondes manuelles post-déploiement (lecture seule) — `?v=2` sha-exact + Range.

## 6. Stratégie de déploiement (0 FCFA, un cycle CI par correctif)
1. Commit unique Lot B sur `d42.13-lab` → push → android-e2e-lab (build+tests+E2E).
2. Si vert → tag `rc10-audio-v1` → release-official-build → APK signé + SHA-256.
3. Le Worker production (src/index.js) est déployé via `deploy-production.yml` — le
   changement `?v=` est ADDITIF (compatibilité descendante totale : anciens clients
   n'envoient pas ?v). Déploiement à déclencher selon le process établi.
4. Retour arrière : les anciens comportements restent le repli (track sans ?v ; fichiers
   legacy adoptés si sha conforme). Aucune donnée de production modifiée.

## 7. Non-couvert (honnêteté)
- L'écoute humaine des nouvelles pistes sélectionnées (fondateur).
- Tests sur téléphone physique (fondateur).
- La régénération musicale v3 (Lot A) est INDEPENDANTE : ce correctif fonctionne avec la
  bibliothèque actuelle (600 pistes EN_LIGNE).
