CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  firebase_uid TEXT NOT NULL UNIQUE,
  email TEXT,
  phone_e164 TEXT,
  locale TEXT NOT NULL DEFAULT 'fr-BJ',
  status TEXT NOT NULL DEFAULT 'actif',
  plan TEXT NOT NULL DEFAULT 'gratuit',
  device_class TEXT,
  cgu_acceptees_at TEXT,
  politique_acceptee_at TEXT,
  consentement_upload_bruts INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT (
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  ),
  last_seen_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_users_status
ON users(status, created_at);

CREATE TABLE IF NOT EXISTS merchants (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  nom_commerce TEXT NOT NULL,
  secteur TEXT NOT NULL,
  ville TEXT,
  ton TEXT NOT NULL DEFAULT 'neutre',
  public_cible TEXT,
  coordonnees TEXT,
  created_at TEXT NOT NULL DEFAULT (
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  )
);

CREATE INDEX IF NOT EXISTS idx_merchants_user
ON merchants(user_id);

CREATE TABLE IF NOT EXISTS projects (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  titre TEXT NOT NULL,
  langue TEXT NOT NULL DEFAULT 'fr',
  statut TEXT NOT NULL DEFAULT 'brouillon',
  brief_json TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  ),
  updated_at TEXT NOT NULL DEFAULT (
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  )
);

CREATE INDEX IF NOT EXISTS idx_projects_user_statut
ON projects(user_id, statut, updated_at DESC);

CREATE INDEX IF NOT EXISTS idx_projects_merchant
ON projects(merchant_id);

CREATE TABLE IF NOT EXISTS templates (
  id TEXT PRIMARY KEY,
  secteur TEXT NOT NULL,
  langue TEXT NOT NULL,
  duree_cible_s INTEGER NOT NULL,
  edl_json TEXT NOT NULL,
  regles_qc_json TEXT NOT NULL,
  version INTEGER NOT NULL,
  actif INTEGER NOT NULL DEFAULT 1,
  updated_at TEXT NOT NULL DEFAULT (
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  )
);

CREATE INDEX IF NOT EXISTS idx_templates_lookup
ON templates(secteur, langue, actif, duree_cible_s);

CREATE TABLE IF NOT EXISTS orders (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  template_id TEXT NOT NULL REFERENCES templates(id),
  statut TEXT NOT NULL DEFAULT 'brouillon',
  moteur TEXT,
  tentative INTEGER NOT NULL DEFAULT 0,
  cle_publique_r2 TEXT,
  audio_octets INTEGER,
  proxy_octets INTEGER,
  rendu_octets INTEGER,
  qc_json TEXT,
  edl_final_json TEXT,
  sous_titres_vtt TEXT,
  score_asr REAL,
  idempotency_key TEXT UNIQUE,
  callback_ts TEXT,
  callback_nonce TEXT UNIQUE,
  created_at TEXT NOT NULL DEFAULT (
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  ),
  updated_at TEXT NOT NULL DEFAULT (
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  ),
  purge_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_orders_user_statut
ON orders(user_id, statut, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_orders_statut_ts
ON orders(statut, updated_at);

CREATE INDEX IF NOT EXISTS idx_orders_purge
ON orders(purge_at) WHERE purge_at IS NOT NULL;

CREATE TABLE IF NOT EXISTS files (
  id TEXT PRIMARY KEY,
  order_id TEXT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  r2_key TEXT NOT NULL,
  role TEXT NOT NULL,
  taille_octets INTEGER NOT NULL,
  empreinte TEXT,
  uploaded_at TEXT,
  purge_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_files_order
ON files(order_id);

CREATE INDEX IF NOT EXISTS idx_files_purge
ON files(purge_at);

CREATE TABLE IF NOT EXISTS quota_events (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  ordre_id TEXT,
  type TEXT NOT NULL,
  avant TEXT,
  apres TEXT,
  mois TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  )
);

CREATE INDEX IF NOT EXISTS idx_quota_user_mois
ON quota_events(user_id, mois, type);

CREATE INDEX IF NOT EXISTS idx_quota_ordre
ON quota_events(ordre_id);

CREATE TABLE IF NOT EXISTS notifications (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  payload TEXT NOT NULL,
  envoye_at TEXT,
  lu_at TEXT,
  created_at TEXT NOT NULL DEFAULT (
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  )
);

CREATE INDEX IF NOT EXISTS idx_notif_user
ON notifications(user_id, lu_at, created_at DESC);
