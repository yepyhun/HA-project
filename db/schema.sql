-- Schema for Modularis Partner PoC (V0.1)
-- Core tables required by the acceptance criteria + a tiny control_state for kill-switch.

CREATE TABLE IF NOT EXISTS ingest_raw (
  id BIGSERIAL PRIMARY KEY,
  source VARCHAR(64) NOT NULL,
  payload JSONB NOT NULL,
  received_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS listing_norm (
  listing_id TEXT PRIMARY KEY,
  idempotency_key TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  price_raw TEXT NOT NULL,
  price_huf INTEGER,
  currency TEXT,
  url TEXT NOT NULL,
  extracted_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS decision_audit (
  id BIGSERIAL PRIMARY KEY,
  listing_id TEXT REFERENCES listing_norm(listing_id),
  decision TEXT NOT NULL,         -- BOMBA|JO|MINIMUM|ELUTASITVA|ELUTASITVA (BUDGET LIMIT)|SOFT FAIL
  fit_score INT,
  risk_score INT,
  explanation TEXT,
  evidence JSONB,
  decided_at TIMESTAMPTZ DEFAULT now()
);

-- Minimal operational state for kill-switch & budget
CREATE TABLE IF NOT EXISTS control_state (
  key TEXT PRIMARY KEY,
  value JSONB NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Useful seed entries for control
INSERT INTO control_state(key, value) VALUES
  ('network_fail_streak', '0'),
  ('cost_spent_huf', '0')
ON CONFLICT (key) DO NOTHING;
