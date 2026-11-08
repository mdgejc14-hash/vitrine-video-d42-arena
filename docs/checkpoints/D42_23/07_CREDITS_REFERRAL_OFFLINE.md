# D42.23 — 07. CRÉDITS / PARRAINAGE / HORS CONNEXION (Phase G)

## Invariants serveur (audit code D42.22 réutilisé + concordance production)
- **Crédits** : `POST /api/v1/quota/consume` (JWT JWKS) — eventId = clé
  primaire de quota_ledger → idempotence native ; rejeu offline compté
  UNE fois (`{ok, dup:true}` sans nouveau débit) ; compensation en cas
  d'échec ; le client n'est JAMAIS l'autorité (falsification locale →
  divergence → rejet).
- **Welcome-grant** : verrou par EMPREINTE téléphonique (même téléphone +
  autre compte Google → aucun nouvel octroi, `already_granted`) ;
  parrainé 5 crédits sinon 3 ; INSERT OR IGNORE.
- **Parrainage** : attribution à l'inscription (referred_id),
  récompense par paliers de 5 (`due = converted/5 - rewarded`,
  idempotent), unicité par design, anti-auto-parrainage via verrou
  d'empreinte, validation serveur.
- **Hors connexion** : catalogue/brief/caméra/guide/aperçu/montage/export
  local (FGS prouvé E2E 45 s écran éteint)/historique/partage
  disponibles ; authentification/octrois/consommation validée
  serveur/bibliothèque distante/parrainage/facturation nécessitent
  Internet ; réconciliation idempotente à la reconnexion.
- **SKYPAY** : 501 `billing_not_configured` (aucune simulation de
  paiement — règle maintenue). NB : les routes SKYPAY n'existent pas
  encore en production (Worker D40) — elles arriveront avec le
  déploiement D42.23.

## Tests réels 2 comptes — PRÊTS, bloqués D23-1
- `security-ci.mjs` (1029 lignes : création compte, connexion, session,
  isolation A/B, crédits, parrainage, révocation, requêtes falsifiées,
  contrôle d'accès) s'exécutera via dispatch `API Security CI`
  ref=`d42.23-production` (dépôt privé, secrets FIREBASE_TEST_A/B_*).
- Les scénarios perte de connexion/retour en ligne du parcours
  §Phase C de l'ordre (renouvellement de session, réinstallation,
  récupération de profil) sont couverts par ce même suite + le test
  physique.

## Preuves applicatives existantes (E2E D42.22, inchangées)
- Journal export `CONFIRMED`, solde 2 attendu/constaté (base locale
  tirée de l'émulateur — artefact e2e-p1-official).
- Repli session locale sans compte : validé (P1_session_locale).
