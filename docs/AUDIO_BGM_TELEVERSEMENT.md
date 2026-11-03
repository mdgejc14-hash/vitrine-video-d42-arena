# Audio BGM — Bibliothèque, téléversement B2 et déploiement (Phases C/D)

> Document opérationnel. Toute l'ingestion audio passe par les scripts
> `scripts/audio/` — **jamais** à la main. Ordre : génération → B2 → D1 → API.

## 0. Chaîne complète (résumé exécutif)

| Étape | Outil | Produit |
|---|---|---|
| SFX (embarqués) | `build_sfx_manifest.py` + `generate_sfx_bank.py` | 9 WAV dans l'APK + manifeste signé |
| Masters BGM (cibles titulaires) | `build_bgm_catalog.py --upload` | ≤30 M4A/AAC « VRAI » dans B2 + `audio_catalog` (migration **0010**) |
| Bibliothèque BGM (variations) | `generate_bgm_library.py` + `ingest_bgm.py` | **600 MP3 CC0** dans B2 + `bgm_library` (migration **0011**) |
| Runtime | Worker `/api/v1/audio/*` | catalogue (30), bibliothèque (600), streaming Range+cache |
| Production | workflow `deploy-production.yml` | Worker déployé + migrations distantes 0001→0011 + smoke |

## 1. Génération de la bibliothèque (600 pistes)

```bash
python3 scripts/audio/generate_bgm_library.py \
    --out /tmp/bgm_out --manifest /tmp/bgm_lib_manifest.json
```

- 6 secteurs × 5 gabarits × 20 variations = **600 pistes** (~430 Mo, 128 kbps).
- **Déterministe** : même seed (`crc32(piste_id)`) → mêmes octets. Relance = surécriture identique.
- Recettes musicales : afro-house / amapiano / afrobeats / highlife / coupé-décalé / afro-soul
  (kalimba, log-drum, shaker, kick, basse, nappes) ; BPM dans la fenêtre du gabarit,
  fondu 1,5 s, RMS ≈ −16 dBFS, peak ≤ 0,84.
- **Étiquette d'honnêteté** : `origine="synthese_procedurale_v1"`, `licence="CC0-1.0"`.
  Ce sont des **pistes de synthèse**, pas les 600 masters humains du
  `LISEZ_MOI_AUDIO.md` : le contrat de publication (2 masters « VRAI » par gabarit)
  reste ouvert jusqu'à l'acquisition réelle.

## 2. Téléversement B2 + migration D1 (autonome)

```bash
export B2_KEY_ID='0051874222bd9b00000000009'
export B2_APPLICATION_KEY='K005…'   # valeur réelle : .dev.vars / secrets GitHub Actions
# 1) Écrit db/migrations/0011_bgm_library.sql (600 INSERT OR IGNORE)
python3 scripts/audio/ingest_bgm.py --emit-sql --manifest /tmp/bgm_lib_manifest.json
# 2) Téléverse 600 MP3 (8 files parallèles, retries, contrôle sha256 avant PUT)
python3 scripts/audio/ingest_bgm.py --upload --manifest /tmp/bgm_lib_manifest.json
# 3) Contrôle listing B2 vs manifeste
python3 scripts/audio/ingest_bgm.py --sync-check --manifest /tmp/bgm_lib_manifest.json
```

Clés B2 : application key **scoped lecture/écriture** sur `vitrine-video-media`
(id `…009`, créée le 31/10/2026 — remplace la paire `…005`/`…006`, **révoquée**).

## 3. API audio (Worker)

| Route | Comportement |
|---|---|
| `GET /api/v1/audio/catalog` | 30 gabarits, `disponible = statut EN_LIGNE ∨ piste en bgm_library` |
| `GET /api/v1/audio/library?secteur=&format=&limit=` | Bibliothèque BGM (total 600, 100/secteur), auth requise |
| `GET /api/v1/audio/track/<categorie>` | Priorité **master humain** (`m4a` → `mp3` titulaire) ; à défaut, **1re variation** de la bibliothèque. Streaming `Range`/206, `Cache-Control: public, immutable` ; 404 honnête si rien en ligne |
| Cache téléphone | `BgmStore` (filesDir `bgm`) + `Cache-Control` HTTP ; lecture Media3 `file:///…` → hors-ligne |

## 4. Déploiement production (workflow `deploy-production.yml`)

Déclenchement (bouton *Run workflow* ou API) :

```bash
curl -X POST -H "Authorization: Bearer <PAT>" \
  https://api.github.com/repos/mdgejc14-hash/vitrine-video/actions/workflows/deploy-production.yml/dispatches \
  -d '{"ref":"main"}'
```

Étapes : `wrangler deploy` → `d1 migrations apply --remote` (repli additif
fichier par fichier 0001→0011) → vérification tables (`merchant_identity`,
`billing_orders`, `audio_catalog`, `bgm_library`) → smoke : `/health` 200,
`/audio/catalog` **401**, `/audio/library` **401**, `/me/welcome-grant` **401**
(401 = route Phase B/C présente ; avant déploiement c'était 404).

Rollback : redéployer un commit antérieur via `wrangler deploy` sur ce commit
(les migrations sont additives : jamais de DROP en production).

## 5. Contrôle de synchronisation (acceptation)

| Vérification | Commande | Attendu |
|---|---|---|
| Objets B2 | `ingest_bgm.py --sync-check` | 600 `.mp3`, 0 manquant |
| Table D1 | `SELECT COUNT(*) FROM bgm_library;` | 600 |
| API prod | `GET /api/v1/audio/library?limit=1` (jeton) | `total: 600` |
| Par secteur | `…?secteur=vetements_mode&limit=200` | `count: 100` |
| Streaming | `GET /api/v1/audio/track/musique_t1_vetements_mode` | 200 audio/mpeg (via variation) |
| Suite CI | `api-security-tests` | ≥49 contrôles, 0 échec |

## 6. v2 — Correctif qualité du 01/11/2026 (unicité stricte + loudness mesurée)

Audit qualité client : la bibliothèque v1 présentait **355/600 signatures
musicales distinctes** seulement (bpm/genre identiques entre variations) et
aucune mesure de loudness après encodage. La chaîne v2 corrige les deux.

| Exigence v2 | Valeur | Contrôle |
|---|---|---|
| Unicité fichiers | 600/600 sha256 distincts | `finalize_audio_v2.py` (ABORT sinon) |
| Unicité musicale | 600/600 signatures (gabarit × bpm_exact × tonalité) | plan déterministe, assert avant génération |
| Loudness | **−16.0 LUFS intégrés ±0.15**, mesurée **après** encodage (ITU-R BS.1770-4, gating −10 LU) | 2 à 10 passes de correction par piste |
| True peak | ≤ **−1.0 dBTP** (sur-échantillonnage ×4) | limiteur tanh adaptatif (knee/asymptote) |
| Conteneur BGM | MP3 CBR 128 kbps, 44.1 kHz, stéréo (alternatif accepté §STRUCTURE) | lameenc, décodé/re-mesuré |
| SFX | 9 WAV PCM 48 kHz mono 16 bits, −16.0 LUFS (cours : ±0.15 ; `impact_drop` −16.43 documenté — crête/TP prioritaires, cf. `ne_pas_normaliser_sfx_courts_seuls_a_lufs`) | contrat `SfxBankContractTest` inchangé |
| Étiquette | `origine="synthese_procedurale_v2"`, `licence="CC0-1.0"` | manifeste + D1 |

Chaîne d'exécution (générateur commité : `scripts/audio/generateur_audio_v2.py`,
preuve = sha256 du générateur, seeds = sha256(piste_id) → reproductible) :

```bash
# 1) 9 SFX (WAV) + téléversement B2 audio/sfx/
python3 generateur_audio_v2.py --sfx --upload
# 2) 600 BGM : génération + téléversement B2 piste par piste (2 shards, reprise sur jsonl)
python3 generateur_audio_v2.py --shard 0/2 --upload &
python3 generateur_audio_v2.py --shard 1/2 --upload & wait
# 3) Finalisation : contrôles d'unicité/conformité, manifeste v2,
#    migration db/migrations/0012_bgm_library_v2.sql (INSERT OR REPLACE 600),
#    assets SFX + manifest_sfx_v1_3.json régénéré, STRUCTURE.json v2 sur B2
python3 finalize_audio_v2.py --repo <chemin-du-repo>
# 4) commit/push puis déploiement = §4 (workflow deploy-production.yml,
#    les migrations distantes appliquent 0012 via le repli fichier-par-fichier)
```

Marqueurs musicaux : BPM dans la fenêtre du gabarit (matrice Drive), riser placé
sur `riser_debut_nominal_s`, impact sur `drop_debut_nominal_s`, durée =
`duree_totale_source_s` + queue 3–10 s. Mixage moteur inchangé :
`AudioChain.MUSIC_VOLUME_DB = −20` (plage consigne −18/−22), ducking automatique
(seuil 0.045, ratio 4:1, 12/260 ms), master −14 LUFS / −1.0 dBTP au banc ffmpeg.

Acceptation v2 : tableau §5 + `|LUFS+16| ≤ 0.15` et `TP ≤ −1.0` sur 600/600 +
sha256 600/600 distincts (`manifests/resume_validation.json`).
