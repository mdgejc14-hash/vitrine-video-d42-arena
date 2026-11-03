-- 0009 (ADDITIVE, audit final) : identite marchande des routes mobiles Phase B.
--
-- Cause racine corrigee : depuis 0005/0007, les routes mobiles (welcome-grant,
-- entitlements, referral) utilisent `merchant_id` = users.id, alors que les
-- colonnes signup_fingerprint / sector / referral_code / referred_by ont ete
-- ajoutees a `merchants` (0001), dont l'`id` est un UUID de PROFIL COMMERCE
-- distinct (crees par POST /api/v1/merchants, FK user_id).
-- Resultat en production : UPDATE/SELECT ... WHERE merchants.id = users.id ne
-- matchaient jamais =>
--   * welcome-grant : empreinte jamais jointe => /me/entitlements renvoyait
--     welcome_credits_left = 0 alors que le ledger welcome_grants creditait 3 ;
--   * /me/referral : ensureReferralCode echouait (5 UPDATE a 0 ligne) puis
--     levait "refcode_collision" => HTTP 500, ecrans E11/E12 hors service ;
--   * /me/referral/claim : code parrain introuvable => R8 inoperant.
--
-- Coffre-fort respecte : 0001-0003 jamais modifiees, aucun ALTER sur users ni
-- sur la semantique des profils commerce. Table dediee, cle = users.id.
CREATE TABLE IF NOT EXISTS merchant_identity (
  user_id TEXT PRIMARY KEY,              -- users.id = le « merchant_id » des routes Phase B
  signup_fingerprint TEXT,               -- verrou anti-abus welcome grant (1 appareil = 1 quota)
  sector TEXT,                           -- mode|coiffure|restauration|btp|immo_auto|commerce
  referral_code TEXT UNIQUE,             -- SHALOM-842, genere cote serveur
  referred_by TEXT,                      -- referral_code du parrain (ou NULL)
  created_at TEXT NOT NULL DEFAULT (
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  )
);

CREATE INDEX IF NOT EXISTS idx_merchant_identity_ref
  ON merchant_identity(referral_code);

-- Reprise des donnees deja ecrites dans merchants (le cas echeant) : la jointure
-- correcte est merchants.user_id -> users.id.
INSERT OR IGNORE INTO merchant_identity
  (user_id, signup_fingerprint, sector, referral_code, referred_by)
SELECT user_id, signup_fingerprint, sector, referral_code, referred_by
FROM merchants
WHERE signup_fingerprint IS NOT NULL
   OR referral_code IS NOT NULL
   OR referred_by IS NOT NULL;
