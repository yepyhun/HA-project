# Modularis Partner — PoC V0.1 RUNBOOK

## Előfeltételek
- Docker (ajánlott) vagy lokális Postgres 15+ és n8n v1.x
- Node.js 20 LTS
- `.env` létrehozva a gyökérben az `.env.example` alapján

## Adatbázis inicializálás
```bash
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f db/schema.sql
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f db/seed.sql
```

## n8n indítás (Docker példa)
```bash
docker run -it --rm -p 5678:5678 --name n8n   --env-file .env   -v "$PWD/flows":/flows   -v "$PWD":/project   n8nio/n8n:latest
```
- Indítás után *Editor UI* → **Import from file**: `flows/ingest.json`, `flows/normalize_and_decide.json`.

## Futási módok
- **offline** (ajánlott elsőre): `.env` → `MODE=offline` → `ingest_raw_live_or_offline` futtatása → `normalize_and_decide` futtatása
- **live**: `.env` → `MODE=live` (Hardverapró HTML visszaadhat 403/anti-bot-ot → ilyenkor a normalize flow továbbra is a *seedelt* vagy sample adatokat is fel tudja dolgozni)

## Elfogadási feltételek (quick check)
- DB-ben legalább **3 rekord** a `listing_norm`-ban
- `decision_audit` tartalmaz legalább **1** döntést
- Log (Console / n8n execution) elemei JSON-ként: `stage`, `status`, `items_count`, `cost_estimate_huf`

## Környezeti változók
- `MODE`: `live|offline`
- `HARDVERAPRO_SEARCH_URL`, `SEARCH_QUERY`, `RATE_LIMIT_MS`
- `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD`
- `LLM_PROVIDER` (`ollama|openai`), `LLM_MODEL`, `LLM_BUDGET_HUF`, `HUF_PER_1K_TOKENS`

## Ismert korlátok (PoC)
- A „live” ág HTML-t ment `ingest_raw.payload`-ba; a normalizáló lépés NDJSON/JSON-ra optimalizált.
- LLM integráció előkészítve (budget hook), de alapból kikapcsolt.
- JSON Schema validáció „lite” (beágyazott ellenőrzés a Code node-ban) — a referencia séma: `listing_norm.schema.json`.
