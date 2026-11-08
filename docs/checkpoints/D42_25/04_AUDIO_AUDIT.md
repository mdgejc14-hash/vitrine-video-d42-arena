# D42.25 — 04. AUDIT AUDIO PRODUCTION (P1-D) — preuves nouvelles complètes

**Runs** (tags `audio-audit-1/2/3`, commits 2632f4c → 0f90107 → 94f4db9) :
- 42492361577 (v1) : 13 PASS / 1 FAIL — FAIL b2_reconciliation (listing
  B2 vide) ;
- 42492979146 (v2) : HEAD direct inventé — 600/600 pistes bgm PRÉSENTES ;
  acoustique impossible (ffmpeg absent des runners) ;
- **42493755744 (v3, définitif) : 21 PASS / 4 FAIL — toutes les mesures
  du mandat livrées, 2 découvertes produit qualifiées.**

Artefact du run v3 : `audio-audit.zip` (report.json avec le détail des 60
mesures par piste + report.md), rétention 30 jours.

## 1. Contrôles structurels et d'intégrité (tous PASS)

| Contrôle | Résultat |
|---|---|
| health | HTTP 200, version **0.9.1-d42.23**, db connected |
| firebase_session | signInWithPassword OK (compte de test A) |
| library_total | 600 déclarés / 600 recueillis (6 secteurs × ≤200) |
| structure_secteurs | 6/6 : batiment_travaux, coiffure_beaute, immo_auto, restaurants_maquis, shops_small_business, vetements_mode |
| structure_gabarits | 30/30 |
| structure_20_variations | 30 × 20 |
| statuts_en_ligne | **600/600 EN_LIGNE** |
| divergences_documentees | 570 variations sha ≠ v01 de leur gabarit (héritage documenté) |
| tracks_v1_v2_range | 60/60 sondes HTTP 206 + audio/* |
| **tracks_sha256_byte_level** | 4 sondes (v1, v2, v7, v13) : octets et **sha256 CONFORMES** aux valeurs D1 |
| erreurs_attendues | v=0 → 400 ; v=21 → 400 ; inconnu → 404 |
| route_titulaire_sans_v | HTTP 206 audio/mpeg |
| **b2_reconciliation_bgm** | **HEAD direct : 600/600 pistes bgm_library PRÉSENTES en B2** (l'exigence P1-C « 600 composants » est satisfaite ; le ListObjectsV2 revient 200-vide car la clé d'application est restreinte — le HEAD par clé est la preuve décisive) |

## 2. Preuves acoustiques NOUVELLES (P1-D — mandat intégral)

Échantillon stratifié : **30 gabarits × 2 variations (v01 + v20) = 60 pistes**
téléchargées via l'API authentifiée de production, analysées ffmpeg/ffprobe
(fichiers en /tmp du runner, jamais en artefacts) :

| Mesure | Résultat | Verdict |
|---|---|---|
| **Décodabilité intégrale** | 60/60 décodés sans erreur (ffmpeg -f null) | PASS |
| **Codec** | mp3 (100 %) | PASS |
| **Durées** | 36,6 – 59,6 s | PASS |
| **Niveau RMS** | moyen −17,2 dB ; plage −18,6…−15,5 dB | PASS |
| **Dynamique (Peak−RMS)** | 12,1 – 17,3 dB | PASS |
| **Saturation** | 0 échantillon clippé ; peak max −1,09 dB (jamais 0 dBFS) | PASS |
| **Cohérence inter-pistes** | écart-type RMS **0,88 dB** (seuil ≤ 6) | PASS |
| **Silence initial/terminal** | début **1,03 – 3,07 s sur 60/60 pistes** ; fin 0,00 s | **FAIL (découverte)** |
| **Attaque (premier son)** | max 3,07 s | **FAIL (même cause)** |

## 3. Les 2 découvertes produit (échecs honnêtes, à trancher par le fondateur)

### D-1. Silence initial systématique (cause des FAIL silence + attaque)
**Toutes** les pistes de la bibliothèque (100 % de l'échantillon, 30 gabarits,
6 secteurs, v01 comme v20) commencent par 1,0 à 3,1 s de silence (seuil
−40 dB). Ce n'est pas un défaut isolé mais une **caractéristique de
génération** homogène.
- Impact potentiel : les vidéos exportées pourraient démarrer ~2 s sans
  musique — À MOINS que le montage auto ne l'absorbe (fondu/décalage BGM au
  mixage). L'e2e P1 a validé des exports MP4 complets avec BGM : l'impact
  réel dépend de la façon dont le montage auto gère le démarrage.
- **Décision produit** : (a) constater que le montage auto absorbe (preuve
  à produire côté mixage) ; ou (b) trim/fade-in des 600 sources (régénération
  INTERDITE sans décision — règle « ne pas régénérer ») ; ou (c) accepter
  le silence initial comme choix artistique documenté.

### D-2. Clés titulaires audio_catalog absentes de B2 (54/60 → 404)
La table `audio_catalog` référence des clés « titulaires » (master .mp3/.m4a
par gabarit) qui ne sont PAS dans le bucket — seule une minorité existe.
Le service est **couvert par conception** : `routeAudioTrack` (src/index.js,
« master titulaire prioritaire, sinon repli variation 1 ») sert la v01.
- **Décision produit** : uploader les 54 masters dans B2, OU purger/aligner
  les clés titulaires de `audio_catalog` (les 600 variations bgm_library
  sont, elles, complètes et servies).

## 4. Qualification P1-D

**EXÉCUTÉ avec preuves nouvelles complètes** : les 7 familles de mesures du
mandat (silence, attaque, niveau, dynamique, saturation, cohérence,
décodabilité) sont livrées avec chiffres, sur l'infrastructure de production
réelle (Worker 0.9.1-d42.23 + D1 + B2 + Firebase). Le verdict global du run
est FAILURE **par honnêteté** (4 contrôles en échec = les 2 découvertes
produit ci-dessus) — aucune panne d'outil, aucun échec d'infrastructure.
Ces découvertes sont exactement ce qu'un audit doit produire.

## 5. Enseignements techniques consignés

- Clé d'application B2 restreinte : ListObjectsV2 → 200 VIDE sans erreur ;
  la preuve d'existence passe par HEAD direct par clé (654 requêtes ≈ 8 s).
- ubuntu-latest n'embarque PAS ffmpeg : étape d'installation requise
  (leçon du run v2 : `spawnSync` rend « exit null » silencieusement).
- Le seuil −40 dB/1 s du silencedetect distingue bien silence réel et
  intro douce ; les durées mesurées (36-60 s) confirment des pistes
  complètes, pas des extraits.
