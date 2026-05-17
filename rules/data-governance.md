# Data Governance Rules

## Dataset Isolation

**Never hardcode dataset-specific table names, schema prefixes, or column names in agent
prompts or skill instructions.** Always resolve from the active dataset's manifest and schema
files. Use `{schema}` as a placeholder in SQL templates.

At analysis start, load in this order:
1. `.knowledge/active.yaml` → get dataset name
2. `.knowledge/datasets/{active}/manifest.yaml` → connection details
3. `.knowledge/datasets/{active}/schema.md` → table and column names
4. `.knowledge/datasets/{active}/quirks.md` → known data gotchas

## Multi-Warehouse SQL

For external warehouses (Postgres, BigQuery, Snowflake), use `get_dialect(connection_type)`
from `helpers/sql_dialect.py` for warehouse-specific SQL (date_trunc, safe_divide, etc.).
**Never write raw warehouse-specific SQL** — always use the dialect adapter.

## Data Source Fallback

Verify data connectivity before running any query:

1. Read `manifest.yaml` for connection details
2. Try primary connection (e.g., MotherDuck via MCP) — run `SELECT 1`
3. If primary fails → try local DuckDB via `manifest.local_data.duckdb`
4. If local DuckDB fails → use CSV files via pandas from `manifest.local_data.path`
5. Always inform the user which source is active

Python helpers in `helpers/data_helpers.py`:
- `detect_active_source()` — reads `.knowledge/active.yaml` + manifest, returns source info
- `check_connection()` — probes the active source (DuckDB SELECT 1, CSV dir check)
- `get_local_connection()` — connect to local DuckDB
- `read_table(table_name)` — read a CSV table
- `list_tables()` — list available CSV tables

## SQL Rules

**Rule 1 — Validate SQL before presenting results.**
Run a sanity check: do row counts match? Do percentages sum correctly? Are joins producing
expected row counts?

**Rule 2 — Cite the data source.**
Every finding must reference which table, column, and time range it comes from. Never present
a number without context.

**Rule 3 — Flag when data is insufficient.**
If the data cannot answer the question (missing columns, too few rows, wrong time range), say
so upfront rather than producing misleading analysis.

**Rule 9 — Verify data connectivity at analysis start.**
Before running any query, confirm which data source is active. If a connection fails, fall back
automatically and inform the user.

**Rule 15 — Check corrections before writing SQL.**
Read `.knowledge/corrections/index.yaml` for logged corrections matching the current dataset
and table. Apply known fixes proactively — never repeat the same SQL mistake twice.
