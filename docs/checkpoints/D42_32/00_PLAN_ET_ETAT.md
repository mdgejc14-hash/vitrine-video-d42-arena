# D42.32 — Plan et état : reconception UX/UI commerciale (Phase A/B/C)

## Références immuables

- **RC15** : release 442574529 · tag `d42.30-rc15` · asset `vitrine-video-rc15.apk`
  (44 470 123 o) · SHA-256 `fd28ffc75cc7ec22c0edd6dcf2c63b1d9fab31469505ede079ddb3aeb3b78936`.
- Point de départ : **9fbc261** (checkpoint final D42.31 — galerie v2 livrée, approuvée pour correction).
- RC15 reste la référence historique. **AUCUNE RC16 avant approbation visuelle du fondateur.**

## Phase A — lots de corrections (en cours)

| Lot | Priorité | Périmètre | État |
|---|---|---|---|
| 1 | P0 | Catalogue : secteur choisi → uniquement ses 5 gabarits, zéro filtre intégré (retour = sélection) | **EN COURS** (code + tests écrits, commit à pousser) |
| 2 | P0 | Présentation catalogue : cartes premium, hiérarchie claire, 5 gabarits identifiables | à faire |
| 3 | P0 | Caméra : diagnostic différentiel mosaïque (ImageAnalysis/PreviewView/VideoCapture/MP4) + présentation écran | à faire |
| 4 | P1 | Localisation FR/EN complète (parcours + 30 gabarits + notifications) | à faire |
| 5 | P0 | Dashboard : en-tête pro, carte crédits, action principale, état sync honnête | à faire |
| 6 | P0 | Parrainage : code immédiatement visible, copier/partager, paliers secondaires | à faire |
| 7 | P0 | Tarifs : 3 formules exactes (Pass 500/6, Pro 3000/90, Boutique 7500/200), paiement 501 honnête | à faire |
| 8 | P1 | Formulaires : WhatsApp international (+229/+33/+1), prix stable au clavier | à faire |
| 9 | P1 | Écran de bienvenue | à faire |
| 10 | — | Design system : harmonisation (bleu marine/orange, typo, espacements) | transversal |

## Règles actives

- Corrections minimales par RCA démontrée ; tests ciblés par lot ; pas de campagne
  longue avant regroupement (Niveau 3 groupé en fin de Phase A).
- Contrats serveur intacts (crédits, parrainage, 501 billing_not_configured).
- Pas de modification des 600 compositions audio. Pas de CinetPay. Budget 0 FCFA.
- Sauvegarde continue : chaque lot = commit descriptif + push + vérification HEAD.

## État courant

- HEAD local = 9fbc261 + Lot 1 en cours de commit.
- Workflows : android-ci SUCCESS sur 9fbc261 ; android-e2e-lab SUCCESS sur 9fbc261.
- Dernière tâche terminée : D42.31 (galerie v2, 7 liens livrés).
- Tâche actuelle : Lot 1 (P0-1 catalogue).
- Porte d'approbation : **FERMÉE** (Phase B galerie avant/après pas encore produite).
