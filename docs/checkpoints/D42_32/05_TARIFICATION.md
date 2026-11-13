# D42.32 — Lot 7 : tarification, SSOT et honnêteté commerciale

## Grille fondateur (autorité commerciale, 23/10/2026 — directive D42.32)

| Formule | Prix | Exports | Rendus cloud | Qualité / marque | Validité | Cache |
|---|---|---|---|---|---|---|
| Pass 24 h | 500 FCFA | 6 | 1 | 1080p sans filigrane | 24 h | 1 j |
| Pro | 3 000 FCFA | **90** | 5 | Kit de marque | 30 j | 14 j |
| Boutique | 7 500 FCFA | 200 | 20 | Marque blanche (sans mention endcard) | 30 j | 30 j |

Jamais « illimité ». Exports (fichiers générés sur l'appareil) et rendus cloud
(rendus côté serveur) sont toujours présentés comme deux limites distinctes.

## Sources de vérité techniques vérifiées

1. **Modèle Android** `core-model/.../billing/Plans.kt` :
   `PASS_24H("pass24h", 500, null)`, `PRO("pro", 3000, 30)`,
   `BOUTIQUE("boutique", 7500, 30)` ; `WELCOME_CREDITS = 3`. ✓ conforme.
2. **Worker** `src/index.js` (`recomputeEntitlements`, ~l.2206) :
   - pass24h → 1080p, sans filigrane, `exports_limit=6`, `cloud_renders=1`,
     `cache_days=1` ; `PLAN_DAYS.pass24h=1` (24 h). ✓ conforme.
   - pro → 1080p, sans filigrane, **`exports_limit=9999` + `fair_use=90`**,
     `cloud_renders=5`, `brand_kit=1`, `cache_days=14`. ⚠ voir écart ci-dessous.
   - boutique → 1080p, marque blanche (`endcard_mention=0`), `exports_limit=200`,
     `cloud_renders=20`, `brand_kit=1`, `cache_days=30`. ✓ conforme.
   - `PLAN_GRID = { pass24h: 500, pro: 3000, boutique: 7500 }`. ✓ conforme.
   - bienvenue → 3 exports + 1 rendu cloud (fingerprint anti-abus, sans expiration).
3. **D1** `db/migrations/0005_monetisation.sql` : colonnes `exports_limit`,
   `fair_use` (« seuil 90 (Pro) ; NULL sinon »), `cloud_renders`, `cache_days`
   (« 3 | 14 (Pro) | 30 (Boutique) »). ✓ cohérent avec le worker.
4. **Checkout** : `POST /api/v1/billing/checkout` côté worker (clé secrète
   jamais dans le client) ; `501 billing_not_configured` = CinetPay non configuré.

## Écart constaté (documenté, non corrigé côté backend)

- **Pro — exports réellement appliqués par le backend : 9 999** (plafond
  technique), `fair_use=90` est **stocké mais jamais appliqué** (aucune
  vérification de quota_ledger contre fair_use dans le worker ; seule
  `exports_limit` borne les exports).
- **Décision D42.32** : l'UI affiche la grille fondateur (**90 exports**) ;
  le backend n'est PAS modifié (règles crédits/quotas intouchables sans cause
  démontrée + validation fondateur). L'application effective de `fair_use=90`
  côté worker est un arbitrage produit laissé au fondateur (une ligne dans
  `recomputeEntitlements` suffirait : `exports_limit: 90`).
- Dashboard : quand une formule est active (`exports_limit>0`, crédits
  bienvenue épuisés), la carte crédits affiche « Formule active · exports
  inclus » — jamais le plafond technique 9999, jamais un compteur inventé.

## Corrections appliquées (commit associé)

- `feat_pro_1` : « Exports illimités (usage loyal : 90) » → **« 90 exports »**
  (FR/EN) — fin de la contradiction signalée par le fondateur.
- `feat_pass24h_3` : « Achat unique, non renouvelé » →
  **« Valable 24 h · achat unique »** (la durée de validité est explicite).
- **Bouton paiement INACTIF** sur les 3 cartes : libellé
  « Paiement en ligne bientôt disponible » / « Online payment coming soon »,
  `enabled = false` — CinetPay volontairement reporté, aucun checkout déclenché,
  aucune fausse transaction. Le wiring `onChoose` est conservé (réactivation =
  1 ligne quand le fondateur activera CinetPay).
- Badge **« Recommandé »** (orange charte) sur la carte Pro — hiérarchie
  commerciale des 3 formules.
- Dashboard : « Formule active » pour les détenteurs de formule (voir écart).

## Tests (PASS requis sur android-ci au commit)

- `PaywallUiCheckTest.grille fondateur - limites exactes, pas d'illimite, bouton inactif` :
  « 90 exports » rendu, « Valable 24 h » rendu, badge Recommandé présent,
  libellé bouton ×3, **0 occurrence** de « illimit »/« Unlimited »/« fair use ».
- `PaywallUiCheckTest.aplats charte` : orange #F95C0F (badge) + bleu nuit
  #022358 (textes) toujours présents (le bouton inactif est gris M3).
- `PaywallUiCheckTest.tarifs exacts UEMOA et tags stables` : 500 / 3 000 / 30 j /
  7 500 / 30 j + testTags `paywall_pass24h|pro|boutique` inchangés.
- `DashboardVisualCheckTest.dashboard formule active` : « Formule active »
  affiché, jamais « 0 exports » ni « 9999 ».
- `DashboardL10nCheckTest` : rendu FR/EN inchangé (assertions sur titres et
  features non modifiées).

## Paiement — limites volontaires (rappel)

- CinetPay reporté (décision fondateur). Budget 0 FCFA.
- Aucun paiement simulé, aucun crédit/abonnement accordé par clic.
- `startCheckout` (worker, 501/401/0 honnêtes) reste en place pour la
  réactivation future ; il n'est plus atteignable depuis l'UI (bouton inactif).
