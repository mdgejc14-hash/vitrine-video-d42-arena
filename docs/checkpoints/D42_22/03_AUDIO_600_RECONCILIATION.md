# D42.22 — 03. RÉCONCILIATION 600 (partie repo : FAITE ; partie production : bloquée D22-1)

## Ce qui est établi depuis les données du dépôt (recalcul D42.22)
- **600 compositions** = le jeu de régénération v2 : 30 gabarits
  (6 secteurs × T1-T5) × 20 variations, chacune avec sha256 mesuré
  (docs/checkpoints/D42_21/donnees/mesures600.jsonl, 600/600).
- Structure vérifiée : chaque gabarit a exactement ses variations 1..20 ;
- LUFS intégré médian : −16,0 ; durée médiane : 43,5 s.

## Explication de l'écart 600 / 564 / 31 (précisée D42.22)
- **31 « divergentes »** = pistes dont le sha256 LOCAL v2 DIFFÈRE de ce que la
  production servait au moment de la mesure (`sha_identique_prod = false`) :
  batiment_travaux_T1 ×17 (v01, v03-v16, v18, v20), T2 ×9 (v01, v03, v06,
  v11, v12, v13, v15, v16, v18), T3 ×5 (v03, v05, v10, v12, v14).
  **Les 569 autres (600−31) sont octet-identiques à la production.**
- **« 564 pistes en ligne »** (rapport D42.21) = décompte EN_LIGNE de la
  bgm_library de production au dernier sondage. L'écart 600−564 = 36 pistes
  non EN_LIGNE en production — **à confirmer précisément par l'audit réel**
  (audio-audit-1) : statuts exactes + clés B2 + écarts éventuels.

## Partie production — PRÊTE mais BLOQUÉE (D22-1 : secrets)
`scripts/audio-audit.mjs` (commit D42.22-01) effectuera dès les secrets
disponibles : total D1 bgm_library (attendu 600), 6 secteurs × 5 gabarits ×
20 variations EN_LIGNE, sondes track ?v=1/?v=2 (206 + audio/*), sha256
byte-level (échantillon), erreurs 400/404, réconciliation D1 × B2
(ListObjectsV2), orphelins. Tag : `audio-audit-1`.

## Règles respectées
Aucun original supprimé ; aucune des 600 générations relancée ; traitement
futur des 526 IMPROVE / 74 REGENERATE par mesures et briefs objectifs.
