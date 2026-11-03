-- Vitrine Video: persistent, non-destructive purge audit ledger.
-- Additive migration. Does not alter or delete existing business data.
-- Real B2/D1 purge execution remains disabled until separately reviewed.

CREATE TABLE IF NOT EXISTS purge_audit_runs (
  run_id TEXT PRIMARY KEY,
  scheduled_at TEXT NOT NULL,
  cron_expression TEXT,
  mode TEXT NOT NULL DEFAULT 'dry_run_no_deletion'
    CHECK (mode = 'dry_run_no_deletion'),
  inventory_complete INTEGER NOT NULL DEFAULT 0
    CHECK (inventory_complete IN (0, 1)),
  candidate_count INTEGER NOT NULL DEFAULT 0
    CHECK (candidate_count >= 0),
  operations_persisted INTEGER NOT NULL DEFAULT 0
    CHECK (operations_persisted >= 0),
  events_persisted INTEGER NOT NULL DEFAULT 0
    CHECK (events_persisted >= 0),
  status TEXT NOT NULL DEFAULT 'started'
    CHECK (status IN ('started', 'completed', 'failed')),
  error_code TEXT,
  started_at TEXT NOT NULL DEFAULT
    (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  completed_at TEXT,
  report_summary_json TEXT NOT NULL DEFAULT '{}'
);

CREATE INDEX IF NOT EXISTS idx_purge_audit_runs_status_started
ON purge_audit_runs(status, started_at DESC);

CREATE INDEX IF NOT EXISTS idx_purge_audit_runs_scheduled
ON purge_audit_runs(scheduled_at DESC);

CREATE TABLE IF NOT EXISTS purge_operations (
  operation_id TEXT PRIMARY KEY,
  scope TEXT NOT NULL CHECK (scope IN ('file', 'order')),
  target_id TEXT NOT NULL,
  order_id TEXT,
  file_id TEXT,
  role TEXT,
  rule TEXT NOT NULL,
  expected_order_status TEXT,
  retention_anchor TEXT,
  uploaded_at TEXT,
  expires_at TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'planned'
    CHECK (status IN (
      'planned',
      'revalidating',
      'b2_delete_pending',
      'b2_deleted',
      'db_cleanup_pending',
      'completed',
      'retryable_error',
      'blocked'
    )),
  attempts INTEGER NOT NULL DEFAULT 0 CHECK (attempts >= 0),
  last_error_stage TEXT,
  last_error_code TEXT,
  last_error_at TEXT,
  next_attempt_at TEXT,
  b2_deleted_at TEXT,
  db_cleaned_at TEXT,
  completed_at TEXT,
  first_seen_at TEXT NOT NULL DEFAULT
    (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  last_seen_at TEXT NOT NULL DEFAULT
    (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  last_seen_run_id TEXT NOT NULL,
  metadata_json TEXT NOT NULL DEFAULT '{}',
  created_at TEXT NOT NULL DEFAULT
    (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  updated_at TEXT NOT NULL DEFAULT
    (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_purge_operations_status_expiry
ON purge_operations(status, expires_at);

CREATE INDEX IF NOT EXISTS idx_purge_operations_order_status
ON purge_operations(order_id, status);

CREATE INDEX IF NOT EXISTS idx_purge_operations_last_seen
ON purge_operations(last_seen_at DESC);

CREATE TABLE IF NOT EXISTS purge_operation_events (
  event_id TEXT PRIMARY KEY,
  event_key TEXT NOT NULL UNIQUE,
  run_id TEXT NOT NULL REFERENCES purge_audit_runs(run_id),
  operation_id TEXT NOT NULL REFERENCES purge_operations(operation_id),
  event_type TEXT NOT NULL,
  from_status TEXT,
  to_status TEXT,
  error_code TEXT,
  details_json TEXT NOT NULL DEFAULT '{}',
  created_at TEXT NOT NULL DEFAULT
    (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_purge_operation_events_operation_created
ON purge_operation_events(operation_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_purge_operation_events_run
ON purge_operation_events(run_id, created_at DESC);
