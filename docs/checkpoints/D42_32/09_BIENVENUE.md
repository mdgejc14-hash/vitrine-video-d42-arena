# 09 — Lot 9 (P1) · Écran de bienvenue

## Constat (01_DIAGNOSTIC_UX.md + relecture code)

L'écran de bienvenue (3ᵉ étape, après secteurs 1/3 et code parrain 2/3)
était le parent pauvre du parcours d'inscription :

- **pas de logo** ni de badge « 3 / 3 » (les étapes 1 et 2 les ont) —
  rupture d'équilibre visuel et de repère de progression (Nielsen #1) ;
- **crédits confirmés noyés** dans un `Text` simple — le don de bienvenue
  (le moment le plus important de la première session) passait inaperçu ;
- **bouton Continuer non épinglé** (pas de barre d'action fixe, pas de
  hauteur mini 56 dp — pattern pourtant établi sur l'écran secteurs
  D42.12/D42.13) ;
- **défaut latent découvert** : `stringResource(R.string.welcome_credits_zero)`
  était appelé SANS son argument `%1$d` → l'écran affichait littéralement
  « Ton solde actuel : %1$d. » au lieu du solde réel.

## Corrections (feature-onboarding/OnboardingScreens.kt, WelcomeScreen)

Même patron que les étapes 1/3 et 2/3, aucune chaîne nouvelle (FR/EN
existants ; assertions e2e `Bienvenue` / `crédits` / `Continuer` de
run_gallery.sh l.494 et run_offline.sh l.199 préservées) :

- en-tête : `VitrineLogoHeader` + `EtapeBadge(3, 3)`;
- contenu défilant `weight(1f)` + `verticalScroll` (petits écrans,
  police 130 %) ;
- `ContenuCredits` (extraction, detekt LongMethod) : les 4 états typés
  D42.30 inchangés — attente (spinner + message), **confirmé →
  `CarteCreditsConfirmes`** : carte BleuVoile, montant en
  `displaySmall` + phrase `welcome_credits` (le don visible d'un coup
  d'œil), zéro → `welcome_credits_zero` **avec l'argument enfin passé**
  (solde réel affiché), hors ligne / refus serveur : textes D42.30
  exacts conservés ;
- barre d'action ÉPINGLÉE (Surface tonalElevation 3) : bouton Continuer
  `heightIn(min = 56.dp)` (confort police 130 %), insets safeDrawing.

Signature `WelcomeScreen(...)` inchangée — seul appelant
OnboardingActivity l.122 non modifié. Aucun test UI existant sur cet
écran (WelcomeGrantTest = contrat serveur, pas d'assertions UI).

## Preuves attendues

- android-ci : compile + detekt + tests unitaires du commit groupé.
- e2e-lab : parcours offline (OFF8_bienvenue_seed_local) et galerie
  (`credits_bienvenue`) rejoués sur le même commit — captures réelles
  pour la Phase B.

## Non-regards honnêtes

- Le montant « en grand » répète le chiffre déjà présent dans la phrase
  (choix : ancrage visuel du don ; la phrase reste la source).
- Pas de nouvelle illustration/animation (pas de refonte, budget 0 FCFA).
