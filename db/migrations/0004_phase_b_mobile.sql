CREATE TABLE IF NOT EXISTS device_profiles (
  fingerprint TEXT PRIMARY KEY,
  device_class TEXT NOT NULL,            -- A|B|C|D mesurés (§4.2)
  portrait_strategy TEXT NOT NULL,
  r_th REAL, c_th REAL,
  probed_with TEXT,                      -- version media3 ayant sondé
  updated_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS template_versions (
  id TEXT PRIMARY KEY,                   -- F021
  latest_version TEXT NOT NULL,          -- 1.0.0
  min_app_version TEXT NOT NULL,         -- gate de rollout
  sha256 TEXT NOT NULL,
  published_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS telemetry_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  app_version TEXT, device_class TEXT, event TEXT,
  gabarit_id TEXT, ok INTEGER, duration_ms INTEGER,
  cta_clicks INTEGER DEFAULT 0, country TEXT, ts TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tel_ts  ON telemetry_events(ts);
CREATE INDEX IF NOT EXISTS idx_tel_gab ON telemetry_events(gabarit_id);
