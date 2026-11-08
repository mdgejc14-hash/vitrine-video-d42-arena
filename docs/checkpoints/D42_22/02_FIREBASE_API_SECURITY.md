# D42.22 — 02. FIREBASE + API SECURITY CI

## Preuves fraîches D42.22 (runs réels)
- Run 42455937366 (08/11 06:44:32, commit 453e470, re-déclenché via paths) :
  `FIREBASE_WEB_API_KEY:` **VIDE** dans l'env → « Configuration CI manquante »
  → exit 1. Run précédent 42442004667 (03:16) : identique.
- Conclusion : les 5 secrets Firebase ne sont PAS configurés dans CE dépôt
  (miroir public). Les captures fondateur correspondent au dépôt PRIVÉ.
- Le wiring du workflow est CORRECT (noms exacts, aucun environnement requis —
  API environnements : total_count 0).

## Ce qui est vérifiable SANS les secrets (fait)
- Architecture réelle respectée : Firebase Authentication (identités, JWKS) +
  Cloudflare D1 (données métier : merchant_identity, welcome_grants,
  quota_ledger, referrals, billing_orders, audio_catalog, bgm_library) +
  Workers (API) + B2 (objets audio) — AUCUN serveur unique (audit code
  D42.22-02, voir 07 pour les invariants).
- security-ci.mjs (1029 lignes) : prêt, couvre création de compte, connexion,
  session, isolation A/B, crédits, parrainage, révocation, requêtes
  falsifiées, contrôle d'accès.

## Tests réels 2 comptes — BLOQUÉS (D22-1)
Dès ajout des secrets FIREBASE_* dans CE dépôt : push sur main touchant
scripts/security-ci.mjs (ou re-tag) → run réel. [NON TESTÉ — dépendance
fondateur, marquage honnête]
