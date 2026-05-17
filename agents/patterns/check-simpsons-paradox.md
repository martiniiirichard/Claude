# Pattern: Check Simpson's Paradox

**When to use:** After any aggregate metric comparison — before concluding that a trend,
difference, or correlation is real. Required by Rule 13 (4-layer validation, Simpson's check).

**Time cost:** ~5-10 minutes with a working dataset.

---

## Steps

### 1. Name the aggregate claim
State the finding clearly:
> "Metric X is [higher/lower/trending up/down] in group A vs group B."

### 2. Identify candidate confounders
List 3-5 dimensions that could explain a mix-shift:
- User segment (new vs returning, tier, region)
- Time period (if comparing cohorts)
- Device / platform
- Traffic source / acquisition channel
- Product area / category

### 3. Compute metric within each segment

For each confounder dimension, run:
```sql
SELECT
  {segment_column},
  {metric_numerator} * 1.0 / NULLIF({metric_denominator}, 0) AS metric,
  COUNT(*) AS n
FROM {table}
WHERE {your_filters}
GROUP BY {segment_column}
ORDER BY n DESC
```

### 4. Compare direction within segments vs aggregate

| Segment value | Metric (Group A) | Metric (Group B) | Same direction as aggregate? |
|---------------|-----------------|-----------------|------------------------------|
| Segment 1     |                 |                 | Yes / No                     |
| Segment 2     |                 |                 | Yes / No                     |
| Segment 3     |                 |                 | Yes / No                     |

### 5. Check mix proportions

If directions differ, check whether the mix shifted:
```sql
SELECT
  {segment_column},
  COUNT(*) * 1.0 / SUM(COUNT(*)) OVER () AS share_of_total
FROM {table}
WHERE {your_filters}
GROUP BY {segment_column}
```

### 6. Verdict

| Verdict | Condition | Action |
|---------|-----------|--------|
| **CLEAR** | Trend holds in same direction within all major segments | Proceed with finding |
| **SIMPSON'S DETECTED** | Aggregate trend reverses within ≥1 segment | Report segment-level truth; flag aggregate as misleading |
| **MIX SHIFT** | Trend holds within segments but mix changed, driving the aggregate | Report mix shift as the root cause, not a real rate change |

### 7. Report wording

- CLEAR: "The [metric] difference holds within all major segments, ruling out Simpson's paradox."
- DETECTED: "The aggregate [metric] reverses within [segment]. The true effect is [segment-level finding]. The aggregate is driven by mix shift, not a real rate change."
- MIX SHIFT: "Segment rates are stable, but [segment X] grew from [X%] to [Y%] of volume, driving the aggregate change."
