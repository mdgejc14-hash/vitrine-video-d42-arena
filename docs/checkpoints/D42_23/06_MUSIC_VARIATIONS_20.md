# D42.23 — 06. SÉLECTION DES 20 VARIATIONS (Phase E)

## Architecture vérifiée au code (D42.22 checkpoint 05 — réutilisée)
- Secteur → gabarit → `BgmSelection.choisir` parmi les pistes
  **EN_LIGNE du gabarit demandé uniquement** → téléchargement
  `/api/v1/audio/track/{categorie}?v={n}` → **sha256 strict
  fichier ↔ bgm_library** (fichier divergent REJETÉ) → cache Android
  (historique par gabarit) → montage.
- Anti-répétition : exclut les K=4 dernières utilisées du gabarit ;
  choix uniforme (jamais la variation 1 systématique) ; Random
  injectable (déterministe en tests, aléatoire en production).
- Replis ordonnés : variation indisponible → AUTRE variation du MÊME
  gabarit (jamais une piste étrangère) → cache legacy → titulaire.
- Serveur : `?v=N` entier 1..20 sinon 400 `invalid_variation` ; piste
  strictement `categorie+variation+EN_LIGNE` ; absente → 404.

## État production (sondes D42.23)
- Le Worker D40 en place ne sert PAS `?v=N` (la logique est absente du
  code D40 — confirmé par le marqueur billing/return 404). L'app
  dégrade gracieusement vers le titulaire. **L'activation des 20
  variations en production = déploiement D42.23** (bloqué D23-1).

## Musique ↔ gabarit (congruence)
- Chaque piste est composée PAR gabarit (durée alignée, BPM étiquetés
  min/max dans bgm_library, place de la voix réservée — place_voix 7/10).
- Timelines 30 gabarits (scènes, rythme de coupe, actes : hook, produit,
  révélation, CTA) — méthodes Music-Content Congruity documentées
  (D42.22 checkpoint 04).
- Défaut systémique connu (intros : hook 0,3/10, remplissage 0,0,
  pulsation 4,9) : traitement ULTÉRIEUR par mesures/briefs par piste —
  74 REGENERATE prioritaires ; JAMAIS de relance globale.

## Découverte e2e (D42.23/02) — portée exacte des preuves
- L'e2e officiel (session SANS compte) valide export + SFX embarqués,
  PAS la chaîne BGM authentifiée. La sélection 20 variations réelle
  (login → catalog → ?v=N → B2 → sha256 → cache) sera prouvée par
  audio-audit-1 (sondes authentifiées par variation) + test physique
  (checklist C1 : 3 exports du même gabarit → musiques différentes).
