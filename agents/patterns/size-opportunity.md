# Pattern: Size Opportunity

**When to use:** After identifying a root cause or opportunity, before making a recommendation.
Converts a finding into a business case with scenarios and a break-even estimate.

**Output:** A sizing table with low/base/high scenarios, key assumptions, and break-even
conditions. Feed into the Opportunity Sizer agent or use inline.

---

## Step 1 — Define the lever

State the specific, actionable change:
> "If we [specific change], we expect [mechanism], which would improve [metric] by [amount]."

The lever must be specific enough that a PM could put it on a roadmap.

---

## Step 2 — Identify the affected population

```sql
SELECT COUNT(DISTINCT {user_id}) AS affected_users
FROM {table}
WHERE {condition that makes user eligible for this opportunity}
  AND {date_filter}
```

Capture: `N_affected = ____`

---

## Step 3 — Establish the baseline metric

```sql
SELECT
  AVG({outcome_metric}) AS baseline_rate,
  SUM({outcome_metric}) AS baseline_total
FROM {table}
WHERE {condition: affected population}
  AND {date_filter}
```

Capture: `baseline_rate = ____` and `baseline_total = ____`

---

## Step 4 — Estimate the improvement range

Use one of these methods:
- **Benchmark**: similar changes in this product or industry showed [X%] improvement
- **Upper bound**: the gap between affected population and the best-performing comparable segment
- **Conservative**: use 20% of the upper bound as low, 50% as base, 80% as high

| Scenario | Improvement estimate | Rationale |
|----------|---------------------|-----------|
| Low      | +___% / +___ units  | Conservative — partial adoption or smaller effect |
| Base     | +___% / +___ units  | Expected — based on [benchmark/comparable] |
| High     | +___% / +___ units  | Optimistic — full adoption, best-case effect |

---

## Step 5 — Compute the impact

For each scenario:

```
Impact = N_affected × improvement_per_user × (1 - rollout_risk)
Annual impact = Impact × periods_per_year
```

| Scenario | Affected users | Improvement/user | Risk discount | Annual impact |
|----------|---------------|-----------------|---------------|---------------|
| Low      |               |                 |               |               |
| Base     |               |                 |               |               |
| High     |               |                 |               |               |

---

## Step 6 — Break-even analysis

If the opportunity has a cost (engineering time, ops overhead, licensing):

```
Break-even = cost / (base_improvement_per_period)
```

> "At base scenario, this investment breaks even in [N weeks/months]."

---

## Step 7 — State the assumptions

List every assumption that the sizing depends on. For each, state what would make it wrong:

| Assumption | Value assumed | What would falsify this |
|-----------|--------------|------------------------|
| ...       | ...          | ...                     |

---

## Step 8 — Recommend the scenario to use

State which scenario to anchor on and why:
> "Recommend presenting the **base scenario** of [value] because [rationale].
> The low scenario is defensible if [condition]. Avoid anchoring on high unless [condition]."
