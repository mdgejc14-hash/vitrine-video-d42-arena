# D42.34 — CR-4 · Identité marchand / abonnements / montage

## ① Identité — « Bonjour boutique », noms inventés/déduits

### Cause racine (démontrée)

- `DashboardActivity` l.233 : `merchantName = intent.getStringExtra("merchant_name")`
  — un extra que **PERSONNE n'alimente** (recherche exhaustive : aucun
  `putExtra("merchant_name")` dans le code). Le dashboard ne pouvait
  afficher QUE « Bonjour » seul.
- `GoogleSsoClient.fetchGoogleIdToken()` ne remontait QUE le jeton : le
  `displayName` RÉEL du credential Google était lu nulle part.
- Les noms fautifs historiques (« Bonjour boutique », « Awa Koffi ») ne
  figurent plus dans le code (recherche négative — restes d'un build
  antérieur D42.2x).

### Correction appliquée

1. `GoogleSsoClient.fetchGoogleIdentite()` : jeton + `displayName` réel
   (jamais déduit de l'email — interdit par l'ordre).
2. `AuthActivity.reussir()` : persiste `merchant_name` dans `vv_session`.
3. `MainActivity` REQ_BRIEF : repli — si aucun nom de profil, le
   `nom_commerce` RÉELLEMENT renseigné au brief devient le nom d'affichage.
4. `DashboardActivity` : extra ?? prefs `vv_session/merchant_name` ?? vide.
5. `DashboardScreen.TexteBonjour` (inchangé, déjà conforme) : « Bonjour,
   {nom} » si nom réel, « Bonjour » seul sinon — jamais « — ».

## ② Abonnements — CTA morts

### Cause racine (démontrée)

`PaywallScreen` : `libelleBouton = paywall_soon` + `boutonActif = false`
sur les 3 cartes — le checkout réel (`startCheckout` → POST
`/api/v1/billing/checkout`, 501 = `checkout_not_configured`) existait mais
n'était JAMAIS atteignable.

### Correction appliquée

- CTA ACTIFS par formule : « Choisir Pass 24 h » / « Choisir Pro » /
  « Choisir Boutique » (500 / 3 000 / 7 500 FCFA inchangés) ;
- badge Recommandé sur Pro (inchangé) ;
- `onChoose` → `startCheckout` réel (inchangé) ;
- 501 `billing_not_configured` = message discret honnête existant
  (`checkout_not_configured`) — CinetPay non intégré, aucune transaction
  fictive, aucun contrat serveur modifié.

## ③ Montage — phases métier réelles

### Constats (déjà conformes, non retouchés)

- Barre indéterminée partout (écran + notification) : aucun % ni ETA
  inventés (Transformer 1.11.1 n'expose pas de progression exploitable —
  commentaire D42 honnête conservé).
- `KEY_PROGRESS` = 100 uniquement au succès vérifié.

### Correction appliquée

Le worker publie désormais la phase métier RÉELLE atteinte
(`KEY_PHASE`, libellé localisé) à 4 jalons véritables :
`export_phase_assemblage` (beat sheet : plans + textes/sous-titres écran),
`export_phase_musique` (base silencieuse + mixeur BGM/SFX/ducking),
`export_phase_rendu` (Transformer), `export_phase_verif` (ExportVerifier).
`ExportActivity` affiche cette phase dans le statut — barre indéterminée
conservée : aucune invention.

## Preuves (Lot 4) — exécutées, toutes vertes

- feature-dashboard : 37/37 (test `PaywallUiCheckTest` MIS À JOUR vers la
  spec D42.34 — CTA « Choisir … » ×3 présents et actifs, `paywall_soon`
  absent ; l'ancienne assertion « bouton inactif » assertait la spec
  obsolète, remplacée par l'exigence fondateur inverse).
- feature-export : 7/7 (phases worker compilées, `doWorkInner` refactoré
  pour detekt : extraction `verdictRepli` + `espaceStockageInsuffisant` —
  aucun contrôle désactivé).
- `:app` + `:feature-onboarding` compilent (identité Google → session →
  dashboard ; MainActivity `repliNomCommerce` extrait pour detekt).
- ktlint + detekt verts sur les 4 modules.

## Non-touchés

Contrats serveur, CinetPay (501), quotas/crédits, Room, moteur, export
vérification, `paywall_footnote_bceao`.
