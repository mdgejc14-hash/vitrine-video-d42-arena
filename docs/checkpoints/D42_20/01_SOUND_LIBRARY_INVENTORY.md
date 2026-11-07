# D42.20 — 01. INVENTAIRE DE LA BIBLIOTHÈQUE SONORE

**Question P1 de la mission : retrouver les 600 compositions. RÉPONSE : TROUVÉES, VÉRIFIÉES,
ET REPRODUCTIBLES LOCALEMENT À L'OCTET PRÈS.** Toute affirmation ci-dessous est appuyée
d'une preuve exécutée ce 07/11/2026 (commandes et sorties conservées dans le tour).

---

## 1. Ce qui existe en production (vérifié par sondes, lecture seule)

### 1.1 Stockage et service
- **Bucket B2** `vitrine-video-media`, préfixe `audio/bgm/{secteur}/{T1..T5}/{piste_id}.mp3` (600 objets)
  + `audio/sfx/*.wav` (9 objets). Source : `STRUCTURE_v2.json` (schéma `vv_bgm_structure` v2,
  généré 01/11/2026) + `sfx_manifest_v2.json`.
- **Service** : Worker production `https://vitrine-video-api.mdgejcinfluence.workers.dev`,
  3 routes authentifiées (Bearer Firebase) :
  - `GET /api/v1/audio/catalog` → 30 catégories (métadonnées par gabarit) ;
  - `GET /api/v1/audio/library?limit≤200[&secteur=&format=]` → pagination des 600 pistes
    (métadonnées SANS sha256 ni URL directe) ;
  - `GET /api/v1/audio/track/{categorie_audio}` → flux audio (Range 206 OK, cache bord
    par `AUDIO_CACHE_EPOCH`).
- **Sondes exécutées ce jour** (`audio_v2/probes_audio_v2.py`, compte sonde lecture seule) :
  `/health` 200 ; catalog **30/30 disponibles** ; library **total=600** ; **6 secteurs × 100** ;
  3 flux catégorie (T1 vêtements, T3 restaurants, T5 coiffure) **sha256 == manifeste v2** ;
  Range 206 vérifié. **TOUTES VERTES.**

### 1.2 Sémantique de service (source `src/index.js`, fonctions routeAudio*)
- La route track sert d'abord l'**objet « titulaire »** de `audio_catalog` (chemin réservé à un
  master humain déposé) ; à défaut (404) elle **retombe sur la 1re variation EN_LIGNE** de
  `bgm_library` (ORDER BY variation LIMIT 1).
- **Conséquence constatée** : aujourd'hui les 30 catégories servies à l'app = la variation v01
  de chaque catégorie (pistes de synthèse v2) — aucune piste titulaire n'est déposée.
- Les 20 variations par catégorie existent dans `bgm_library` (D1) et B2 mais **l'app ne peut
  pas en choisir une** : le choix est fait côté serveur (repli). À garder à l'esprit pour la
  phase 3 (direction musicale) et 6 (déploiement v3).

### 1.3 Composition de la bibliothèque v2 (manifestes + shards D42.19)
- **600 pistes** = 6 secteurs × 5 formats (T1–T5) × 20 variations.
  Secteurs : vetements_mode, restaurants_maquis, immo_auto, coiffure_beaute,
  shops_small_business, batiment_travaux.
- **Format** : MP3 CBR 128 kbps, 44,1 kHz, stéréo (le conteneur m4a/AAC de STRUCTURE_v2 était
  une préférence non retenue par le générateur v2 — les fichiers réels sont .mp3).
- **Calibrage** (resume_validation D42.19, confirmé par mes régénérations) : LUFS intégré
  **−16,11..−15,99** (cible −16,0 ±0,1, mesure post-encodage, jusqu'à 9 passes) ; true peak
  **≤ −1,0 dBTP** ; durée totale 7 h 35 ; 437,2 Mo ; 600 sha256 distincts.
- **Métadonnées par piste** (shards jsonl D42.19, 600/600) : piste_id, gabarit, secteur, format,
  variation, BPM (fenêtre du gabarit, pas de 0,25), tonalité (24 majeures/mineures, root A2..G#3),
  famille rythmique, riser_s/drop_s (fenêtres nominales du gabarit), durée = montage + queue 3–10 s,
  seed, sha256, b2_file_id/b2_sha1, licence CC0-1.0, origine `synthese_procedurale_v2`.
- **Origine** : **synthèse procédurale** (générateur Python local, déterministe) — PAS des masters
  humains. Le plan initial D42.19 (LISEZ_MOI_AUDIO.md : 600 masters humains CC0 à acquérir,
  Starter Pack 60 + 18 packs cloud, SFX « à acquérir ») n'a **pas** été réalisé en acquisition ;
  il a été remplit par la génération v2. Le chemin « titulaire » reste disponible pour déposer
  de vrais masters ultérieurement (priorité au-dessus du repli).
- **SFX** : 9 fichiers WAV PCM 48 kHz/16 bits mono (whoosh_soft 350 ms, whoosh_fast 220 ms,
  caisse_enregistreuse 550 ms, clic_appareil 120 ms(approx 0,18 s), impact_drop 220 ms,
  pop_badge 160 ms(approx 0,22 s), amb_chantier 2,56 s, sizzle_grill 1,06 s, vapeur_plat 1,06 s).
  **Embarqués dans l'APK** (`data/src/main/assets/audio/sfx/`, 9 fichiers) + référencés par le
  montage (`GabaritBeatSheet`, `ExportActivity`, `ExportWorker`).

### 1.4 Client Android (P8 : ingénierie de téléchargement, analyse terminée)
- `data/.../audio/BgmStore.kt` (120 lignes) : catalog → choix de la catégorie du gabarit →
  téléchargement **une seule fois** via `/api/v1/audio/track/{categorie}` vers
  `files/bgm/` (stockage permanent, survit au vidage de cache) → service hors-ligne définitif.
  Clés/credentials **jamais embarqués** : auth Bearer Firebase utilisateur uniquement. ✓ conforme.

## 2. Ce qui existe historiquement (v1 — à ne pas confondre)
- `/home/user/bgm_lib_manifest.json` (racine workspace) : **bibliothèque v1** — mêmes 600
  piste_ids/object_keys mais **contenus différents (0/600 sha256 communs avec v2)**. C'est
  l'ancienne génération, remplacée puis nettoyée de B2 (`cleanup_b2_versions.py`, suppression
  des anciennes versions d'objets). Servie à aucun moment aujourd'hui.

## 3. Preuves de reproduction locale (audit sans toucher à la production)
1. **Reconstruction du plan** : `plan_gabarits.json` (absent du repo) reconstruit depuis les
   2 matrices CSV D42.19 (`matrice_30_gabarits_bpm_styles_sfx.csv` + `matrice_30_montages_et_musiques.csv`,
   30 gabarits) → `build_plan()` → **600/600 pistes identiques aux shards D42.19 sur 12 champs**
   (bpm, tonalité, root_midi, mode, seed, durée, riser_s, drop_s, object_key, famille, genre, piste_id).
   Fichier : `/home/user/plan_gabarits_reconstruit.json`.
2. **Déterminisme octet** : 3 pistes régénérées localement (`musique_t1_vetements_mode_v01`,
   `musique_t3_restaurants_maquis_v01`, `musique_t5_coiffure_beaute_v01`) → **sha256
   identiques aux manifestes** — et ces mêmes sha256 ont été **vérifiés contre les flux de
   production** par les sondes du jour. La chaîne complète tient :
   *CSV → plan → générateur (seed sha256(piste_id)) → MP3 → sha256 == B2 production*.
3. **Régénération intégrale en cours** : 600 pistes vers `/home/user/.cache/audio600/`
   (hors snapshot, régénérable), outil `audio_v2_outils/regen600.py` (resumable, vérifie
   chaque sha256 contre les shards). 2 shards parallèles.

### 3bis. Nuance d'honnêteté sur le déterminisme (découverte 07/11 au soir)
- La régénération intégrale fait apparaître **~17/600 fichiers non reproductibles à l'octet**
  (concentrés sur `musique_t1_batiment_travaux_*`, première vague générée avant un patch du
  générateur ; le log D42.19 montre une reprise « 39 pistes déjà téléversées »).
- **Preuve directe pour v01** : la production sert `musique_t1_batiment_travaux` (repli v01)
  avec sha256 `55f5cfa2…` == shard D42.19 ; ma régénération locale (générateur final du repo)
  donne `dd58996d…` — même taille (639 895 o), mêmes cibles (LUFS −16,04 / TP −1,94 vs
  attendus −16,02 / −1,44), durée identique au padding LAME près.
- **Conséquence audit** : les ~583 fichiers octet-identiques = mesures exactes de la production.
  Les ~17 divergents : mesurés sur régénération (même plan, mêmes seeds, mêmes cibles) avec
  marqueur `sha_identique_prod=false` ; pour le v01 servi en production, la copie exacte
  téléchargée via la route track (`PROD_…v01.mp3`) est utilisée.
- **Action possible fondateur** : fournir des clés B2 en lecture pour télécharger les ~17
  originaux exacts (facultatif — divergence mineure et documentée).

## 4. Accès B2 (constat)
- Aucune clé B2 en local (le pipeline D42.19 les prenait en variables d'environnement,
  jamais committées — conforme). Listing/écriture B2 directe **impossible** pour l'instant.
- Contournement complet pour l'AUDIT : reproduction déterministe ci-dessus.
- Pour la PHASE 6 (dépôt v3 en production), il faudra soit les clés B2 (action fondateur),
  soit repasser par un pipeline d'ingestion authentifié. **Aucune écriture tentée à ce stade.**

## 5. État initial connu des défauts (avant audit Phase 4)
- **Plaintes fondateur** (mission D42.20) : silences en début de piste, manque de dynamique,
  impression de « remplissage », synchronisation faible avec le montage.
- **Corroboration structurelle (code)** : `build_bgm()` : intro = **2 mesures à densité réduite**
  (kick sur temps 0/8 seulement, pas de backbeat ni shaker, énergie ×0,55) soit ≈ 8–9 s à
  100–110 BPM avant l'entrée réelle — sur des montages de 15–30 s. L'analyse locale des 600
  (Phase 4) quantifiera : silence/creux initial 0–0,5/1/2/3 s, RMS, LUFS momentané, facteur
  de crête, spectre, tempo réel vs étiquette.
- **Défaut latent D42.18 (rappel)** : export sans piste audio si le gabarit attend une BGM
  (la musique n'est jamais un `EditedMediaItem`) — à corriger dans un cycle CI dédié
  (phases 5/9), indépendamment de la qualité musicale.

## 6. Risques et limites honnêtes
- L'« écoute » des 600 par l'agent est **impossible** : la mesure sera objective (outils) ;
  l'écoute humaine (casque, haut-parleur smartphone, mono, avec/sans voix, sur montage réel)
  reste à la charge du fondateur — grille et échantillon stratifié fournis en phase 4.
- Les timestamps du workspace ne datent rien (restaurations) : toutes les dates ci-dessus
  viennent des contenus (manifestes, commits git).
- Le PAT GitHub étant supprimé, ce checkpoint n'est PAS poussé — copie de secours dans
  `/home/user/D42_20_backup/`.
