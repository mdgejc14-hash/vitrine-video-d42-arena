ALTER TABLE merchants ADD COLUMN sector TEXT;             -- mode|coiffure|restauration|btp|immo_auto|commerce
ALTER TABLE merchants ADD COLUMN referral_code TEXT;      -- SHALOM-842, généré côté serveur
ALTER TABLE merchants ADD COLUMN referred_by TEXT;        -- merchants.referral_code du parrain (ou NULL)
CREATE UNIQUE INDEX IF NOT EXISTS idx_merchants_refcode ON merchants(referral_code);
-- NOTE P4 (écart documenté au rapport) : le contrat V7-FINAL listait ici
-- « ALTER TABLE subscriptions ADD COLUMN source TEXT DEFAULT 'payment' » ;
-- la colonne source est DEJA créée par 0005_monetisation.sql (CREATE TABLE subscriptions).
-- Un second ALTER fait échouer toute base vierge (duplicate column). Ligne retirée :
-- le résultat de schéma final est strictement identique au contrat.
CREATE TABLE IF NOT EXISTS referrals (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  referrer_id TEXT NOT NULL,           -- merchants.id du parrain
  referred_id TEXT NOT NULL UNIQUE,    -- 1 seul parrain par filleul
  status TEXT NOT NULL DEFAULT 'pending',   -- pending | converted
  converted_at TEXT,
  reward_granted INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_ref_referrer ON referrals(referrer_id, status);
