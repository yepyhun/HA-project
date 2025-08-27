-- Seed a few raw items (synthetic) and reset control state.
TRUNCATE ingest_raw, decision_audit RESTART IDENTITY;
UPDATE control_state SET value='0', updated_at=now() WHERE key IN ('network_fail_streak','cost_spent_huf');

-- Optionally pre-load some synthetic raw payloads for offline test
INSERT INTO ingest_raw(source, payload) VALUES
('sample', '{"url":"https://hardverapro.hu/apro/rtx_3080_a/","title":"RTX 3080 A","price_raw":"235 000 Ft"}'),
('sample', '{"url":"https://hardverapro.hu/apro/rtx_3080_b/","title":"MSI RTX 3080 Ventus","price_raw":"199 000 Ft"}'),
('sample', '{"url":"https://hardverapro.hu/apro/rtx_3080_c/","title":"Gainward RTX 3080 Phoenix","price_raw":"290 000 Ft"}');
