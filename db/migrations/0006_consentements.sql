CREATE TABLE IF NOT EXISTS consent_records (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL, project_id TEXT NOT NULL,
  scope TEXT NOT NULL,                   -- face | minor | music_own
  face_count INTEGER, text_version TEXT NOT NULL,
  app_version TEXT, device_id TEXT, ts TEXT NOT NULL,
  revoked_at TEXT                        -- retrait : bloque le projet + trace registre de purge
);
CREATE INDEX IF NOT EXISTS idx_consent_proj ON consent_records(project_id);
