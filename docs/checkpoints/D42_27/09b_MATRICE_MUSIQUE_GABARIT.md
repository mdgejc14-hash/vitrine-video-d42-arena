# D42.27-09b — MATRICE MUSIQUE-GABARIT (§6, audit I)

**Sources** : `scripts/audio/bgm_lib_manifest_v2.json` (600 compositions, métadonnées
complètes) × audit acoustique INTÉGRAL du run audio 42542375491 (artefact
`audio-audit-full`, 600/600 mesures RMS/peak/durée/silence/attaque/décodage,
09/11/2026 — mesures par piste dans `artefacts/matrice_musique_gabarit.csv`).

## 1. Correspondance gabarit ↔ musique (30 × 20 = 600)

Chaque gabarit dispose de **20 variations** musicales de SA catégorie secteur
(6 secteurs × 5 formats T1–T5 = 30 gabarits) — jamais de musique d'un autre
secteur (contrôles `structure_gabarits` + `structure_20_variations` du run
audio : PASS).

| Gabarit | Secteur | Format | Variations | BPM | Tonalité | Durées (s) | RMS (dB) | Attaque (s) | SHA distincts |
|---|---|---|---|---|---|---|---|---|---|
| batiment_travaux_T1 | batiment_travaux | T1 | 20 | 107 | E majeur | 39–45 | -18.4…-15.9 | 2.21–2.43 | 20/20 |
| batiment_travaux_T2 | batiment_travaux | T2 | 20 | 100 | D# majeur | 39–45 | -18.7…-16.1 | 2.26–2.57 | 20/20 |
| batiment_travaux_T3 | batiment_travaux | T3 | 20 | 104 | B mineur | 43–50 | -17.5…-14.8 | 2.33–2.75 | 20/20 |
| batiment_travaux_T4 | batiment_travaux | T4 | 20 | 117 | G# majeur | 37–43 | -18.1…-16.9 | 1.88–1.94 | 20/20 |
| batiment_travaux_T5 | batiment_travaux | T5 | 20 | 79 | E mineur | 53–60 | -18.3…-17.0 | 2.63–3.12 | 20/20 |
| coiffure_beaute_T1 | coiffure_beaute | T1 | 20 | 110 | F# mineur | 39–45 | -18.3…-17.0 | 2.16–2.40 | 20/20 |
| coiffure_beaute_T2 | coiffure_beaute | T2 | 20 | 103 | D# majeur | 39–45 | -18.4…-15.9 | 2.22–2.51 | 20/20 |
| coiffure_beaute_T3 | coiffure_beaute | T3 | 20 | 103 | G majeur | 44–50 | -18.4…-15.8 | 2.34–2.72 | 20/20 |
| coiffure_beaute_T4 | coiffure_beaute | T4 | 20 | 114 | C majeur | 37–43 | -18.1…-16.9 | 1.94–2.18 | 20/20 |
| coiffure_beaute_T5 | coiffure_beaute | T5 | 20 | 80 | C majeur | 54–60 | -17.3…-14.9 | 2.56–3.12 | 20/20 |
| immo_auto_T1 | immo_auto | T1 | 20 | 108 | D majeur | 39–45 | -18.1…-15.7 | 2.15–2.40 | 20/20 |
| immo_auto_T2 | immo_auto | T2 | 20 | 104 | A# mineur | 38–45 | -18.6…-15.9 | 2.23–2.54 | 20/20 |
| immo_auto_T3 | immo_auto | T3 | 20 | 92 | D mineur | 43–50 | -18.3…-15.8 | 2.31–2.71 | 20/20 |
| immo_auto_T4 | immo_auto | T4 | 20 | 115 | D# mineur | 37–43 | -18.2…-16.8 | 1.03–1.11 | 20/20 |
| immo_auto_T5 | immo_auto | T5 | 20 | 90 | G# mineur | 53–60 | -18.3…-16.7 | 2.55–3.12 | 20/20 |
| restaurants_maquis_T1 | restaurants_maquis | T1 | 20 | 113 | G# mineur | 40–45 | -18.4…-15.9 | 2.13–2.36 | 20/20 |
| restaurants_maquis_T2 | restaurants_maquis | T2 | 20 | 100 | A majeur | 39–45 | -18.2…-17.0 | 2.22–2.50 | 20/20 |
| restaurants_maquis_T3 | restaurants_maquis | T3 | 20 | 102 | B majeur | 44–50 | -18.0…-15.6 | 2.31–2.68 | 20/20 |
| restaurants_maquis_T4 | restaurants_maquis | T4 | 20 | 115 | F mineur | 36–43 | -18.3…-15.8 | 1.90–2.17 | 20/20 |
| restaurants_maquis_T5 | restaurants_maquis | T5 | 20 | 92 | C# mineur | 54–60 | -18.3…-17.1 | 2.52–3.10 | 20/20 |
| shops_small_business_T1 | shops_small_business | T1 | 20 | 103 | G# majeur | 38–45 | -18.5…-16.0 | 2.13–2.36 | 20/20 |
| shops_small_business_T2 | shops_small_business | T2 | 20 | 105 | E majeur | 38–45 | -18.1…-15.5 | 2.22–2.52 | 20/20 |
| shops_small_business_T3 | shops_small_business | T3 | 20 | 99 | D# majeur | 44–50 | -18.3…-15.8 | 2.29–2.68 | 20/20 |
| shops_small_business_T4 | shops_small_business | T4 | 20 | 113 | A# majeur | 37–43 | -18.1…-16.9 | 1.92–2.17 | 20/20 |
| shops_small_business_T5 | shops_small_business | T5 | 20 | 91 | A majeur | 54–60 | -18.6…-16.1 | 2.54–3.07 | 20/20 |
| vetements_mode_T1 | vetements_mode | T1 | 20 | 110 | F# majeur | 39–45 | -18.6…-16.0 | 2.17–2.42 | 20/20 |
| vetements_mode_T2 | vetements_mode | T2 | 20 | 94 | G# mineur | 38–45 | -18.6…-16.1 | 2.26–2.56 | 20/20 |
| vetements_mode_T3 | vetements_mode | T3 | 20 | 102 | F mineur | 44–50 | -18.3…-16.9 | 2.34–2.75 | 20/20 |
| vetements_mode_T4 | vetements_mode | T4 | 20 | 112 | C mineur | 36–43 | -18.3…-17.0 | 1.07–1.12 | 20/20 |
| vetements_mode_T5 | vetements_mode | T5 | 20 | 82 | C majeur | 54–60 | -18.2…-16.0 | 2.58–3.18 | 20/20 |

## 2. Anti-répétition

- **600/600 sha256 distincts** (diversité réelle au niveau octet ;
  `tracks_sha256_byte_level` + `tracks_sha256_couverture_integrale` : PASS).
  570 variations ≠ v01 documentées : chaque piste est une interprétation
  différente, pas une copie.
- Sélection en app : `BgmSelectionTest` (8 tests JVM) — rotation des
  variations et repli variation cache si le téléchargement échoue (garde
  StatFs D42.27-04). La sélection évite de répéter la même piste pour un
  même gabarit (logique testée).
- B2 : 600/600 objets `bgm_library` présents (HEAD direct : PASS).

## 3. Mesures acoustiques (600/600)

- Décodabilité : 600/600 (ffmpeg intégral) — PASS
- Codec : mp3 44,1 kHz — PASS · Durées 36,4–60,2 s (garde 10–120 s) — PASS
- Niveau RMS moyen −17,4 dB (plage −18,7…−14,8) — PASS
- Dynamique (Peak−RMS) 11,9–17,5 dB — PASS
- Saturation : 0 échantillon clippé, peak max −1,01 dB — PASS
- Cohérence inter-pistes : écart-type RMS 0,81 dB (seuil ≤ 6) — PASS

## 4. FAIL identifiés (documentés, NON corrigés — décision fondateur)

1. **7.7 silence/attaque initial** : les 600 pistes ont un silence de début
   ≥ 1,03 s (max 3,18 s — `musique_t5_vetements_mode` v5). Seuil d'audit
   < 1 s. **Correction PROPOSÉE** (exigerait l'autorisation fondateur sur les
   600 compositions) : fondu d'entrée raccourci à 0,3–0,5 s par
   `ffmpeg -af silenceremove` + re-normalisation EBU R128, puis re-upload B2
   avec nouvelle empreinte et re-scan acoustique intégral. Alternative à
   zéro modification : assumer l'intro douce comme intention artistique et
   documenter le seuil à 3,5 s.
2. **7.8 clés titulaires `audio_catalog`** : 54/60 clés titulaires absentes
   de B2 (404) — le service reste couvert par le repli v01
   (`routeAudioTrack` documenté). **Correction PROPOSÉE** : ré-ingest des
   clés titulaires manquantes via `scripts/audio/ingest_bgm.py` (idempotent,
   0 FCFA), puis re-HEAD des 60 clés.

## 5. Conclusion matrice I

20 variations/gabarit ✓ · correspondance secteur ✓ · anti-répétition ✓ ·
600/600 analysées ✓ · FAIL 7.7/7.8 identifiés avec corrections proposées
NON exécutées (règle : les 600 compositions ne se modifient pas sans
autorisation) ✓.
