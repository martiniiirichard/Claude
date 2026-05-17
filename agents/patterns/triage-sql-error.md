# Pattern: Triage SQL Error

**When to use:** A SQL query errors, returns unexpected row counts, or produces implausible
numbers. Follow this decision tree before rewriting or giving up.

---

## Decision Tree

### Step 1 — Read the error message

| Error type | Likely cause | Go to |
|------------|-------------|-------|
| Column not found | Wrong column name, wrong table | Step 2 |
| Table not found | Wrong schema or dataset name | Step 3 |
| Division by zero | Denominator column has zeros | Step 4 |
| Ambiguous column | Column exists in multiple joined tables | Step 5 |
| Aggregation error | Non-aggregated column in SELECT with GROUP BY | Step 6 |
| Join produces unexpected rows | Fan-out or many-to-many join | Step 7 |
| Query returns 0 rows | Filter too restrictive, or wrong table | Step 8 |
| Query returns too many rows | Missing GROUP BY, or join fan-out | Step 7 |

---

### Step 2 — Column not found
1. Run: `SELECT * FROM {table} LIMIT 1` — inspect the actual column names
2. Check `.knowledge/datasets/{active}/schema.md` for the correct column name
3. Check `.knowledge/corrections/index.yaml` — has this been corrected before?
4. Fix the column name. If it genuinely doesn't exist, flag the tracking gap.

### Step 3 — Table not found
1. Check `.knowledge/active.yaml` for the correct dataset/schema prefix
2. Run: `SHOW TABLES` or `SELECT table_name FROM information_schema.tables LIMIT 20`
3. Cross-reference with `schema.md`
4. Update the query with the correct fully-qualified table name: `{schema}.{table}`

### Step 4 — Division by zero
Replace bare division with safe divide:
```sql
-- Instead of:
numerator / denominator
-- Use:
numerator * 1.0 / NULLIF(denominator, 0)
```
If zeros are unexpected, investigate: `SELECT COUNT(*) FROM {table} WHERE {denominator_col} = 0`

### Step 5 — Ambiguous column
Prefix every column reference with the table alias:
```sql
-- Instead of:  SELECT user_id, event_date
-- Use:         SELECT e.user_id, e.event_date
```

### Step 6 — Aggregation error
Check every column in SELECT:
- All non-aggregated columns must appear in GROUP BY
- Or wrap with `ANY_VALUE()` / `MAX()` if the value is always the same within groups

### Step 7 — Join fan-out
Diagnose by counting before joining:
```sql
-- Count rows in each table before joining
SELECT COUNT(*) FROM table_a WHERE {your_filter};
SELECT COUNT(*) FROM table_b WHERE {your_filter};
-- Then check the join key uniqueness:
SELECT {join_key}, COUNT(*) FROM table_b GROUP BY {join_key} HAVING COUNT(*) > 1 LIMIT 5;
```
Fix: add DISTINCT on the key before joining, or use a subquery to pre-aggregate.

### Step 8 — Zero rows returned
Check filters progressively: remove WHERE clauses one at a time to find the over-filtering
condition. Start with the date range filter, then other conditions.

---

## After fixing: verify

Always check the result makes sense:
- Row count plausible? (not 0, not 10x expected)
- Metric in expected range?
- Percentages sum to ~100%?

If verified, add the fix to the working notes so it can be logged as a correction.
