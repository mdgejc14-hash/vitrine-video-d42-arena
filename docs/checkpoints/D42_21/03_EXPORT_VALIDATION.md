# Release `rc10-audio-v1` — notes de version (brouillon de travail)

## Résumé
Troisième correctif audio majeur de la ligne D42 : l'export ne sort plus jamais
un MP4 muet quand une musique est planifiée, et la bibliothèque musicale passe
de 30 pistes uniques à **600 pistes (20 variations par gabarit)** sélectionnées
aléatoirement côté téléphone avec vérification d'intégrité.

## Changements
### Application (d42.13-lab → main)
- **Correctif D42.18 (racine)** : si aucun rush client ne porte de piste audio
  (voix facultative — le commerçant peut ne pas parler) et qu'une musique est
  planifiée, l'export ajoute une séquence audio parallèle (base silencieuse
  44,1 kHz stéréo) et mixe la musique en gain solo (0 dB — fichiers calibrés
  −16 LUFS ±0,15 / TP ≤ −1 dBTP). Le MP4 contient désormais une piste audio
  dans le scénario « filmé sans voix ».
- **Sélection des 20 variations (D42.21)** : le téléphone interroge la
  bibliothèque du secteur+format, choisit une variation du gabarit
  (anti-répétition sur les 4 dernières, aléatoire en production, déterministe
  en tests), télécharge UNIQUEMENT cette variation (~630 Ko), vérifie son
  SHA-256 et la cache définitivement (`files/bgm/{piste_id}.mp3`).
  Indisponible → autre variation du même gabarit → repli titulaire documenté.
- Le cache legacy (`{categorie}.mp3`) n'a plus priorité sur la sélection : il
  est adopté seulement si son SHA correspond à la variation choisie.
- Ducking gabarit conservé sous la voix ; fade-out musique avant la carte CTA.

### Serveur (Worker, déploiement délibéré via deploy-production)
- `/api/v1/audio/track/{categorie}?v=N` (N ∈ 1..20, validé strictement :
  `400 invalid_variation` sinon) sert la variation N depuis B2, cache API par
  variation. Sans `?v` : comportement inchangé (variation 1).
- `/api/v1/audio/library?secteur=&format=` expose les métadonnées PUBLIQUES
  des pistes EN_LIGNE dont `sha256` (aucun secret : clés B2 non lisibles).

### Base (D1 — migrations 0011/0012 déjà appliquées)
- Table `bgm_library` : 600 pistes, `piste_id=musique_t1_{secteur}_vNN`,
  −16 LUFS ±0,15, TP ≤ −1 dBTP, MP3 CBR 128 kbps, CC0-1.0.

## Preuves (à compléter au fil de la validation)
- [ ] E2E lab (P1 caméra émulée = rushs muets + BGM) : ffprobe
      `codec_type=audio` dans export.mp4 — run 42413207174 (en cours)
- [ ] android-ci main : ktlint/detekt/testDebugUnitTest (dont 5 nouveaux
      fichiers de tests : parseur bibliothèque, sélection PBT, composition
      base audio, mixage solo)
- [ ] Sondes production `?v=N` sha-exact après déploiement Worker
- [ ] Mesure LUFS/TP du MP4 exporté du scénario A (artefact E2E)
- [ ] Historique : run 41811176998 — 24/24 MP4 avec flux AAC (audio rush sans
      voix réelle ; chemin inchangé)

## Limites connues (honnêteté)
- Voix réelle (microphone) : jamais testée en CI (émulateur sans micro) —
  protocole de test physique remis au fondateur.
- BPM mesuré par autocorrélation : estimateur non fiable (0/8 en validation
  synthétique) — le BPM de génération reste la référence ; la grille de
  qualité utilise la pulsation à l'étiquette (ACF).
- Scénario « voix seule » (aucune musique) : aucun gabarit actuel ne le
  produit (les 30 planifient une musique) — chemin code inchangé depuis
  l'origine, preuve historique ci-dessus.
- La sélection 20 variations ne s'active côté téléphone qu'APRÈS déploiement
  du Worker (l'ancien Worker ignore `?v` → vérification SHA → repli titulaire
  gracieux : aucun crash ni régression avant déploiement).

## Checklist opérateur (séquence)
1. E2E lab vert sur `6b7c396`+ (run 42413207174 en cours).
2. Merge `d42.13-lab` → `main` → android-ci vert.
3. `deploy-production.yml` (workflow_dispatch) → Worker + smoke.
4. Sondes lecture seule : `?v=2` sha-exact, `/audio/library` avec sha256.
5. Tag `rc10-audio-v1` → `release-official-build.yml` → APK signé + SHA-256.
