# Fabric Notebook Templates

Notebook scaffolding for Microsoft Fabric Spark compute.

## Files

| File | Language | Use |
|------|----------|-----|
| `pyspark-notebook.ipynb` | PySpark | DataFrame operations, Delta Lake reads/writes, Lakehouse integration |
| `python-notebook.ipynb` | Python | Standard Python in Fabric — pandas, data prep, utility scripts |

## Notes

- These are Fabric-specific — they reference OneLake paths and Fabric-native APIs.
- Use with the `spark-authoring-cli` skill and `fabric-cli` skill for deployment.
- For DuckDB queries over Lakehouse Parquet files, see `fabric-cli/scripts/query_lakehouse_duckdb.py` in the Codex skills.
