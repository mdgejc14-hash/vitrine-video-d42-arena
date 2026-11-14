# Famille 10 — Tarification (écran Formules / quota épuisé)

**Statut : TERMINÉE — commit <SHA après push>, CI <run après push>.**

## Périmètre (ordre fondateur respecté à la lettre)

Refonte de l'écran Formules (`PaywallScreen`) et de l'état « quota épuisé »
(même écran dédié). **AUCUN écran d'aide, aucun centre d'assistance, aucune
entrée artificielle dans les réglages** : l'app n'en possède pas, le
fondateur l'a confirmé — rien n'a été créé.

## Implémentation

- **`PaywallScreen`** : titre H2 Navy sur canvas Bg (padding 20) ;
  bandeau d'état (crédits restants en Sub Muted, OU état verrouillé =
  **solde 0 en Num OrangeDeep + consigne** `paywall_quota` — spec §10
  « écran dédié, jamais une alerte ») ; **3 `CarteFormule`** verticales
  (grille fondateur 23/10/2026 stricte : Pass 24 h · Pro · Boutique) ;
  **« Recharger plus tard »** (lien OrangeDeep) affiché seulement si
  verrouillé → retour dashboard ; footnote BCEAO inchangée (zone ≠ langue).
- **Prix au format « · N FCFA »** (`· 500 FCFA`, `· 3 000 FCFA / 30 j`,
  `· 7 500 FCFA / 30 j`) : une seule ligne garantie par `taillePrix = 24.sp`
  (Num ExtraBold — aucun texte tronqué, interdit fondateur).
- **Pro recommandée** (hiérarchie commerciale D42.32 Lot 7 conservée) :
  carte navy + badge « Recommandé » en **aplat OrangeStore plein, texte
  blanc** (nouvelle teinte `TeinteBadge.OrangePlein`) → aplat charte
  #F95C0F exact, exigé par le contrôle pixel du test.
- **CinetPay toujours reporté** : boutons `paywall_soon` ×3 inactifs
  (honnête), `startCheckout`/contrats serveur **intacts** (501
  billing_not_configured côté worker, aucune modification).
- **Aucun tarif ni avantage modifié** : `PaywallMapper`, `Plan`,
  `PlanCard`, `PaywallUi` byte-identiques (logique pure testée JVM).

## Design system — modifications ADDITIVES uniquement

- `Badges.kt` : enum `TeinteBadge.OrangePlein` (fond OrangeStore / texte
  Blanc) ajouté au `when` — valeurs existantes inchangées.
- `CarteFormule.kt` : paramètres optionnels `teinteBadge` (défaut Sombre =
  comportement inchangé), `taillePrix` (défaut null = Num tel quel),
  `testTagPrix` (défaut null). Composant non utilisé ailleurs avant cette
  famille → zéro risque de régression.

## Contrats préservés

- `PaywallScreen(ui, onChoose)` : signature backward-compatible
  (`onLater: () -> Unit = {}` additif).
- testTags intangibles : `paywall_<code>` (carte + bouton `-btn`) et
  **`price_<code>` recollé sur le Text du prix** via `testTagPrix`
  (l'audit famille 01 les liste intangibles ; aucun test ne les consomme
  aujourd'hui, ils restent pour les parcours futurs).
- `PaywallMapper`, `P8LogicTest`, `PricingMirrorTest`, e2e : inchangés.
- `DashboardActivity` : seul changement = `PaywallView` passe
  `onLater` (retour dashboard + relireDonneesProjet) en named args.

## Tests

- `PaywallUiCheckTest` (mis à jour de façon cohérente, aucune assertion
  affaiblie) :
  - prix `· 500 FCFA` / `· 3 000 FCFA / 30 j` / `· 7 500 FCFA / 30 j` ;
  - tags `paywall_pass24h|pro|boutique` ;
  - + NOUVELLES assertions état dédié : solde `0` en Num présent,
    `paywall_later` présent (verrouillé) ;
  - inchangées : `feat_pro_1`/`feat_pass24h_3` (limites exactes),
    `plan_recommended`, `paywall_soon` ×3, interdits « illimité »/
    « Unlimited »/« fair use », footnote BCEAO traduite, contrôle pixel
    aplat orange #F95C0F + navy #022358 (satisfaits par le badge
    OrangePlein et le fond de la carte Pro).
- `DashboardL10nCheckTest.verifierPaywall` : inchangé et satisfait
  (`paywall_title`, `plan_boutique_title`, `feat_pro_3` sous-chaîne).
- `DashboardVisualCheckTest` (dashboard) : non impacté.

## Vérifications statiques locales

Imports tous utilisés (4 imports M3 du vieux paywall retirés :
Button/Card/MaterialTheme/AmbreAlerte) ; fonctions ≤ 80 lignes
(max PaywallScreen 55 après extraction `BandeauCreditsPaywall`) ;
accolades 117/117, parenthèses équilibrées ; FR/EN 91/91 ;
plus aucune occurrence de l'ancien format `"  ·  "`.

## Décisions & écarts documentés

- Prix à 24 sp (au lieu du Num 40 héros) : le format long
  « · 7 500 FCFA / 30 j » doit tenir sur une ligne sans troncature —
  compromis lisibilité/anti-troncature, arbitrage final à la revue
  visuelle du fondateur.
- Cartes empilées verticalement (comportement D42.32 validé) — pas de
  grille 3 colonnes (prix illisible à 106 dp de large).
- Solde 0 en OrangeDeep (pas en blanc/navy) : état d'attention honnête,
  pas une alerte bloquante.

## Incident CI (run 43608092097, FAILURE) — causes racines et corrections

1. **`:core-designsystem:detekt` — CyclomaticComplexMethod 16/15 sur
   `CarteFormule`** : les 3 paramètres additifs (`?.let/?:`) ont fait
   franchir le seuil. Correction : extraction du `Text` prix en composable
   privé `PrixFormule` (CarteFormule ≈ 13/15, PrixFormule ≈ 5/15).
2. **`:feature-dashboard:compileDebugUnitTestKotlin` — "No value passed for
   parameter 'onChoose'"** (PaywallUiCheckTest l.56/81/106) : avec le 3e
   paramètre `onLater` (défaut), la **trailing lambda se lie au DERNIER
   paramètre** — `PaywallScreen(ui) { }` liait `{}` à onLater. Correction :
   les 5 appels de test (4 PaywallUiCheckTest + 1 DashboardL10nCheckTest)
   passent désormais `onChoose = { }` en argument nommé.

Leçons : ① compteur de complexité à re-vérifier à chaque paramètre additif
conditionnel sur un composant au seuil ; ② trailing lambda + nouveau
paramètre fonctionnel en dernière position = piège Kotlin systématique,
auditer TOUS les appelants par grep avant push.
