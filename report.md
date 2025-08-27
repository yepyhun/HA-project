# Modularis Partner — PoC V0.1 Report (1-pager)

**Cél:** minimális, de végponttól-végpontig futó szelet, DB-központú perzisztenciával, lépcsőzetes normalizálással, audit naplóval.

## Mit csinál?
- **Ingest:** élő (HTML) VAGY offline (NDJSON) → `ingest_raw.payload`
- **Normalize:** kötelező kulcsok és ár-normalizálás → `listing_norm` (idempotens upsert)
- **Decide:** költségplafon-degradációval → `decision_audit` + strukturált log

## Mit nem csinál?
- Nincs teljes Hardverapró HTML parser (PoC).
- LLM nincs bekapcsolva alapból; budget guard előkészített.

## Fő kockázatok & mitigáció
- **403/anti-bot:** „offline” mintaadat mód; kill-switch policy a következő iterációban.
- **Ár-parzolás pontossága:** „lite” – a V0.2-ben k/e/m rövidítés támogatás.
- **Schema drift:** JSON Schema referenciában kezelhető (add-only evolúció).

## Következő lépések
- Hardverapró HTML → stabil parser (selector-váltások kezelése)
- LLM döntési modul (budget guard → retrieve-only fallback)
- Observability bővítése (p95 latency, retry_count vizualizáció)
