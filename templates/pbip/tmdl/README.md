# TMDL Templates

## SpaceParts.SemanticModel

A complete, real-world TMDL semantic model used as the authoritative syntax reference.

**Scale:** 40 tables, 152 measures, 8 calculation groups, 8 RLS roles, 2 perspectives, DAX UDFs (functions.tmdl), shared M expressions, 27 relationships (including inactive), cultures.

**Key files to study:**

| File | What it shows |
|------|---------------|
| `definition/functions.tmdl` | DAX user-defined functions with parameters and types |
| `definition/tables/Z04CG1 - Time Intelligence.tmdl` | Calculation group with triple-backtick DAX |
| `definition/tables/__Measures.tmdl` | Measures table referencing calculation group items |
| `definition/tables/Invoices.tmdl` | Large fact table — 51 measures, 18 columns |
| `definition/tables/Date.tmdl` | Calculated date table with 42 columns |
| `definition/roles/Account Managers.tmdl` | RLS role with DAX filter expression |
| `definition/relationships.tmdl` | 27 relationships including inactive ones |
| `definition/expressions.tmdl` | Shared M/Power Query expressions and parameters |
| `definition/perspectives/Measure Selection.tmdl` | Perspective definition |

**Use with:** `tmdl` skill, `build-semantic-model` skill, or Power BI MCP server measure/table operations.
