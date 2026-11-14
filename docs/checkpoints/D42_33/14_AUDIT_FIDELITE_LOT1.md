# Checkpoint 14 — Lot 1 de la mission v2 : audit de fidélité + inventaire exhaustif

**Ordre fondateur du 14/11 (v2, prioritaire, échéance 18/11/2026).** Lot 1 sur 5.

## Livrables du lot

1. **`SCREEN_INVENTORY.csv`** (nouveau) — 90 états inventoriés sur les 12 parcours
   chronologiques, 13 colonnes : id, parcours, écran, étape/état, langue, résolution, maquette,
   fichiers source, composants, capture AVANT, capture APRÈS, statut, observation.
   Répartition : **21 CONFORME + 3 CONFORME (partiel) + 57 NON PROUVÉ (capture à produire au
   Lot 2) + 7 ÉCART ASSUMÉ + 1 NON APPLICABLE (Aide & contact — décision fondateur) +
   1 DOCUMENTÉ (l10n ES/JA artefacts CI)**.
2. **`DESIGN_FIDELITY_AUDIT.md`** (nouveau) — audit écran par écran (maquette/fichier/
   composant/capture/statut), preuve programmatique chromatique, écarts mesurés, conclusions.
3. **`visual-review/tools/audit_tokens.py`** (nouveau, versionné) — vérification reproductible
   de la conformité aux tokens §3 (% pixels sur tokens, tolérance anticrénelage).

## Découverte structurante du lot

`docs/checkpoints/D42_32/visual-review/captures/` contient **87 fichiers AVANT authentiques**
(émulateur e2e D42.32, runs 43582523983 / 43582492529, pré-refonte) déjà commités au dépôt :
splash, carrousel ×3 + EN, langue, auth ×3, code parrain, crédits, paywall ×4, secteurs ×3,
catalogue ×5, gabarits ×2, brief ×9, formulaires ×2, vérification ×3, caméra ×5, prises ×12,
export (dumps XML + mp4), dashboard ×4, profil ×2, hors-connexion ×5, robustesse ×8.
Conséquences :
- le « AVANT NON DISPONIBLE » de la v1 (dashboard notamment) est **corrigé** : l'AVANT émulateur
  existe pour la quasi-totalité du parcours ;
- le Lot 3 pourra aligner AVANT ↔ APRÈS écran par écran (la v1 n'avait que 11 AVANT Robolectric).

## Preuve programmatique (audit_tokens.py, sur les 26 APRÈS uniques v1)

- **Aucune couleur hors tokens dans la peinture UI** : résidus = anticrénelage, halos §5,
  dégradé CTA §7.1, contenu photo. Guides caméra : 99,4–99,7 % tokens (l'AVANT D42.32 contenait
  13,8–19,3 % de gris #323232 hors tokens — éradiqué).
- Contrastes recalculés et consignés : Muted/blanc 4,22:1 ; Muted/Bg 3,97:1 ; blanc/OrangeStore
  3,20:1 ; + constats sur les tokens spec eux-mêmes (OrangeDeep/blanc 4,44:1 ;
  AmbreAlerte/OrangeVoile 3,83:1) — l'implémentation suit les tokens à la lettre, décision
  fondateur requise pour toute retouche.

## Écarts ASSUMÉS consolidés (7, tous documentés dans l'audit)

§9.5 export prêt (pas d'écran dédié) · feuille de partage système · consentement = AlertDialog
R4 · écrans dédiés absents (détail gabarit, revue des prises, mes vidéos, conditions) · code
parrain par deep-link (pas de saisie) · + conformité : Muted/blanc, badge 11 sp, prix 24 sp,
pas de cloche notifications (faux bouton interdit §13), splash sans barre (API), clavier non
rendu par Robolectric.

## Non-regression / intégrité

- Aucune modification du code applicatif dans ce lot (documents + outil Python uniquement).
- Doublons v1 identifiés dans AFTER/ (4 fichiers identiques avec virgules + 1 variante
  synchrone-credits-6-brouillon-absent) — élimination prévue au Lot 3 (règle : aucun doublon
  pour gonfler ; l'audit_tokens.py les ignore déjà).

## Suite (Lot 2)

Captures APRÈS manquantes : 57 états listés statut ◐ dans SCREEN_INVENTORY.csv — nouvelles
méthodes `.save()`/qualifiers Robolectric par module (onboarding welcome/carrousel/EN,
brief GabaritBriefScreen ×7, ReadyCheck, PriseGuideScreen ×7, VideoPreviewScreen écran complet,
E8 XML via ActivityScenario, catalogue tuiles/EN/offline, robustesse ×8, hors-connexion ×4…).
Priorité : écrans à AVANT existant (comparaison côte à côte possible).

*Lot 1 clôturé — commit et push de ce checkpoint. HEAD attendu : voir rapport de livraison.*
