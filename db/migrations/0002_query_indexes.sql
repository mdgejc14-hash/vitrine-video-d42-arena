-- Index supplémentaires pour les requêtes de liste et le cycle de vie.
-- Migration additive : ne supprime aucune donnée ni aucun index existant.

CREATE INDEX IF NOT EXISTS idx_merchants_user_created
ON merchants(user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_projects_user_updated
ON projects(user_id, updated_at DESC);

CREATE INDEX IF NOT EXISTS idx_orders_user_created
ON orders(user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_notif_user_created
ON notifications(user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_quota_ordre_type_created
ON quota_events(ordre_id, type, created_at DESC);
