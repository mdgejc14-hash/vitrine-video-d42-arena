# D42.22 — 07. HORS CONNEXION / CRÉDITS / PARRAINAGE — AUDIT CODE (D42.22)

## Crédits : le serveur est l'autorité finale
- `POST /api/v1/quota/consume` (JWT JWKS) : **eventId = clé primaire de
  quota_ledger (0005)** → idempotence native ; rejeu hors-ligne compté UNE
  seule fois (dup → `{ok, dup:true}` sans nouveau débit).
- Welcome-grant : verrou par EMPREINTE téléphonique (même téléphone + autre
  compte Google → aucun nouvel octroi, solde réel renvoyé) ; compte déjà lié à
  une empreinte → `already_granted` (anti multi-appareils, spec 9.1/C16) ;
  INSERT OR IGNORE idempotent ; parrainé = 5 crédits, sinon 3.
- Le client n'est jamais l'autorité : consommation locale réconciliée contre le
  ledger serveur ; falsification locale → divergent → rejet (sha256 des pistes
  + ledger serveur).

## Parrainage
- Attribution à l'inscription (referred_id) ; récompense par paliers de 5
  conversions (`due = converted/5 - rewarded` → **idempotent**) ; unicité par
  design (referred_id clé) ; validation serveur ; anti-auto-parrainage par le
  verrou d'empreinte ci-dessus.

## Hors connexion (règles explicites, vérifiées au code + E2E)
- Disponible : catalogue local, brief, caméra, prises, guide, aperçu, montage,
  export local (Worker Android + FGS — prouvé E2E écran éteint 45 s),
  historique, partage.
- Nécessite Internet : authentification Firebase, octroi/consommation de
  crédits (validation serveur), bibliothèque BGM distante (repli : fichier
  local déjà téléchargé, sinon titulaire si déjà en cache), parrainage,
  facturation.
- Réconciliation après reconnexion : rejeu idempotent des consommations
  offline (eventId), pas de double débit.
- SKYPAY : **501 billing_not_configured** confirmé au code — aucune simulation
  de paiement réel (règle maintenue).

## Tests réels API (2 comptes de test) — BLOQUÉS secrets
security-ci.mjs (1029 lignes : création de compte, session, isolation,
crédits, parrainage, révocation, requêtes falsifiées, contrôle d'accès) :
**impossible à exécuter — FIREBASE_* vides dans CE dépôt** (voir 08).
