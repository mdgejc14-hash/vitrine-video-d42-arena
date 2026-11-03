CREATE TABLE IF NOT EXISTS subscriptions (
  merchant_id TEXT PRIMARY KEY,
  plan TEXT NOT NULL,                    -- pass24h | pro | boutique (| pro via source='referral')
  status TEXT NOT NULL,                  -- active | canceled  (expiration = lecture paresseuse vs renews_at)
  started_at TEXT NOT NULL,
  renews_at TEXT,                        -- pass24h : started_at + 24 h ; abonnements : +30 j
  provider TEXT,                         -- fedapay | cinetpay
  provider_ref TEXT,                     -- idempotence : référence aggregator/order existante
  source TEXT DEFAULT 'payment'          -- payment | referral
);
CREATE TABLE IF NOT EXISTS entitlements (
  merchant_id TEXT PRIMARY KEY,
  watermark INTEGER NOT NULL DEFAULT 1,        -- 1 = filigrane exports
  endcard_mention INTEGER NOT NULL DEFAULT 1,  -- 0 = marque blanche (Boutique seulement)
  max_res TEXT NOT NULL DEFAULT '720p',
  exports_limit INTEGER NOT NULL DEFAULT 0,    -- 0 = export verrouillé (paywall) ; crédits bienvenue gérés par welcome_grants
  fair_use INTEGER,                            -- seuil 90 (Pro) ; NULL sinon
  cloud_renders INTEGER NOT NULL DEFAULT 0,    -- rendus cloud explicites inclus / période
  brand_kit INTEGER NOT NULL DEFAULT 0,
  cache_days INTEGER NOT NULL DEFAULT 3,       -- rétention locale des assets : 3 | 14 (Pro) | 30 (Boutique)
  updated_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS welcome_grants (              -- générosité d'accueil, verrou ANTI-ABUS
  fingerprint TEXT PRIMARY KEY,            -- 1 téléphone = 1 quota à vie, quel que soit le compte Google
  merchant_first_id TEXT NOT NULL,
  credits_total INTEGER NOT NULL,          -- 3 (ou 5 si inscription parrainée, §9.8)
  credits_used INTEGER NOT NULL DEFAULT 0,
  cloud_total INTEGER NOT NULL DEFAULT 1,  -- 1 rendu cloud inclus dans le quota de bienvenue
  cloud_used INTEGER NOT NULL DEFAULT 0,
  granted_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS quota_ledger (                -- consommation idempotente (rejeu offline sûr)
  event_id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL, fingerprint TEXT,
  source TEXT NOT NULL,                  -- welcome | pass24h | pro | boutique
  kind TEXT NOT NULL,                    -- export | cloud
  ts TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_ledger_mer ON quota_ledger(merchant_id, ts);
ALTER TABLE merchants ADD COLUMN signup_fingerprint TEXT;  -- verrou anti-abus welcome grant (1 appareil = 1 quota)
