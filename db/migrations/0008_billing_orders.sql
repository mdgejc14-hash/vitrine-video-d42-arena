-- 0008 (ADDITIVE, audit final C16) : table des commandes de FACTURATION.
-- Bug corrige : le webhook billing (/api/v1/internal/billing/webhook) inserait
-- dans `orders` (0001) qui est la table des COMMANDES DE RENDU (project_id,
-- template_id NOT NULL) — colonnes merchant_id/amount_fcfa inexistantes, donc
-- INSERT toujours en erreur. Coffre-fort respecte : 0001-0003 jamais modifiees,
-- nouvelle table dediee, aucun ALTER sur l'existant.
CREATE TABLE IF NOT EXISTS billing_orders (
  id TEXT PRIMARY KEY,                       -- ref idempotente (VV-*)
  merchant_id TEXT NOT NULL,
  amount_fcfa INTEGER NOT NULL,
  currency TEXT NOT NULL DEFAULT 'XOF',
  status TEXT NOT NULL,                      -- paid / failed / refunded
  provider TEXT,                             -- cinetpay / fedapay / kkiapay
  provider_ref TEXT,
  created_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_billing_orders_merchant
  ON billing_orders(merchant_id, created_at);
