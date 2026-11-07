# D42.20 — 02. MESURES DES 600 COMPOSITIONS : MÉTHODOLOGIE ET ÉTAT

## 1. Principe (règle non négociable : jamais généraliser une piste aux 599 autres)
Chaque piste est mesurée INDIVIDUELLEMENT, avec son sha256, depuis une copie locale
octet-identique à la production (preuve : cp. 01 §3 ; exception documentée des ~39
fichiers de première vague, cp. 01 §3bis). Résultats individuels dans
`/home/user/audio_v2_mesures/mesures600.jsonl` (1 ligne = 1 piste, resumable).

## 2. Métriques par piste (outil : `audio_v2_outils/audit600.py` v2)
- **Fichier** : sha256 réel vs attendu (marqueur `sha_identique_prod`), durée, anomalies
  (erreur décodage, sr ≠ 44,1 kHz, canaux ≠ 2, NaN/Inf, offset DC, durée ≠ manifeste,
  échantillons au plafond).
- **Silence initial** : première attaque perceptible (première fenêtre 20 ms dépassant
  max(−40 dB sous le niveau crête d'enveloppe, −55 dBFS) ; RMS dBFS des fenêtres
  0–0,5 / 0,5–1 / 1–2 / 2–3 / 3–5 s.
- **Loudness BS.1770-4** (même implémentation que le générateur → cohérence) : LUFS intégré,
  momentané max (400 ms), court terme max/min (3 s), LRA (percentiles 10–90 du court terme).
- **True peak** : BS.1770-4 (suréchantillonnage ×4) ; **clipping** : échantillons ≥ 0,999 FS.
- **Dynamique** : facteur de crête (dB), LRA.
- **Tempo** : BPM estimé par autocorrélation de l'enveloppe de flux (50 ms, 60–150 BPM,
  vote harmonique) — **estimation**, comparée à l'étiquette (`ecart_bpm`).
- **Densité musicale** : événements/s (pics de flux > moyenne + 1,8 σ).
- **Spectre** : centroïde Hz, rolloff 85 %, énergies de bandes (sub <80, 80–250, 250–500,
  500–2k, 2–8k, >8k) en dB relatif.
- **Progression** : LUFS court terme à 10 / 25 / 50 / 75 / 90 % de la durée.
- **Conclusion/boucle** : RMS queue 1 s vs corps, fondu détecté (dernier 50 ms), coupe franche.
- **Préparation P5** : LUFS court terme autour des fenêtres riser_s / drop_s du gabarit.

## 3. Pipeline (resumable, tolérant aux interruptions)
`audio_v2_outils/pipeline600.sh` : 2 shards de régénération en parallèle (déterministes,
sha vérifiés contre les shards D42.19) + passes d'audit toutes les 4 min sur les fichiers
complets uniquement (présence dans le jsonl de régénération = fichier fermé ; aucune
lecture de fichier en cours d'écriture). Copie de sécurité des jsonl de régénération vers
`audio_v2_mesures/`. **Aucune écriture vers la production.**
Dépendance : `lameenc` installé dans `/home/user/pylibs` (persistant ; `~/.local` est exclu
du snapshot — panne diagnostiquée et corrigée le 08/11).

## 4. Écoute humaine (règle : l'agent n'écoute pas, il mesure)
L'écoute (casque, haut-parleur smartphone, mono, avec/sans voix, sur montage réel) reste à
la charge du fondateur. L'outil produira : un **échantillon stratifié** (par secteur ×
format × tercile de mesure) + une **grille /100** par piste fondée sur les seuils de la
mission (≥90 conserver ; 80–89 conserver mineur ; 65–79 corriger ; <65 régénérer) —
la grille sera soumise au fondateur AVANT classification définitive (checkpoint dédié).

## 5. État au 08/11 (honnête, horodaté par contenu)
- Régénération+mesures : pipeline relancé après correction lameenc — progression dans
  `audio_v2_mesures/mesures600.jsonl` (source de vérité ; compte = lignes du fichier).
- Premières mesures du 07/11 (avant interruption environnement) : 1 piste complète —
  `musique_t1_batiment_travaux_v02` : première attaque 2,39 s, RMS 0–0,5 s = silence
  numérique (−240 dB), LRA 3,18 LU — corrobore la plainte « silences en début ».
- Les ~39 fichiers de première vague : protocole dédié cp. 01 §3bis + §6 ci-dessous.

## 6. Protocole des ~39 fichiers historiques (première vague pré-patch)
Pour chacun : (1) objet de production identifié (`audio/bgm/batiment_travaux/{T1,T2}/…`) ;
(2) original exact récupérable UNIQUEMENT pour les v01 servis par la route track
(batiment T1 v01 : fait, copie `PROD_…v01.mp3`, sha vérifié égal au manifeste) — les autres
nécessitent des clés B2 en lecture (non demandées en clair dans la messagerie ; le
fondateur les fournira par son canal sécurisé s'il le juge utile) ; (3) comparaison sha :
documentée dans les jsonl (`sha_ok:false`) ; (4) paramètres de génération : identiques
(plan reconstruit 600/600, seed et BPM identiques) ; (5) version du générateur : l'historique
git du miroir ne contient qu'UN commit-snapshot pour `scripts/audio/generateur_audio_v2.py`
(dbf3e58) — la version pré-patch n'est PAS récupérable depuis le dépôt ; (6) différence
accidentelle (patch correctif entre la première vague et la reprise — le log D42.19
« [reprise] 39 pistes déjà téléversées » en témoigne), pas intentionnelle ; (7) mesure de
qualité : sur la régénération (même plan/seed/cibles), avec réserve explicite ; (8) copie
exacte conservée pour v01 ; (9) décision : à statuer avec le fondateur — recommandation
préliminaire : les traiter comme candidats REGENERATE prioritaires lors de la phase 6.
