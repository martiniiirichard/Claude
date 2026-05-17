# Pattern: Cross-Modal Consistency Check

Use this pattern after generating a deck or narrative to verify that numerical claims in the text match the charts, and that both are consistent with the underlying data.

## When to Apply

- After the Storytelling agent writes a narrative
- After the Deck Creator produces slides
- Any time a chart and its surrounding text both state numerical claims
- Before presenting to stakeholders — catching a mismatch here is much cheaper than in the room

## Why This Matters

The most common failure mode in analytical presentations: the narrative says "42% drop-off" but the chart shows 38%. These drift because charts are generated from data and text is written from memory or intermediate results. They diverge silently.

## Step-by-Step

**Step 1 — Extract numerical claims from the narrative text.**
Scan the full narrative and list every number that makes a claim:
```
Narrative claims:
- "Mobile checkout conversion is 2.1%"
- "This represents a 41% drop-off at step 3"
- "Revenue impact estimated at $480K annually"
```

**Step 2 — Extract numerical claims from each chart.**
For each chart file or chart spec, read the data values displayed:
```
Chart claims (from chart spec / rendered values):
- Chart 1 (funnel): Step 3 shows 59% pass-through → 41% drop-off ✓
- Chart 2 (conversion bar): Mobile bar = 2.1% ✓
- Chart 3 (revenue waterfall): Mobile opportunity = $480K ✓
```

**Step 3 — Cross-reference against the source data.**
For each claim, trace back to the query or data table that produced it:
```
Source data check:
- Mobile conversion: events table → 2.1% (matches)
- Step 3 drop-off: funnel query → 41% (matches)
- Revenue: opportunity_sizer output → $478K (MISMATCH — narrative says $480K)
```

**Step 4 — Classify each discrepancy.**

| Discrepancy type | Threshold | Action |
|-----------------|-----------|--------|
| Rounding difference | ≤ 2% relative difference | Acceptable — standardize to one precision |
| Stale copy | > 2% but traceable to an older query | Update the claim to match latest data |
| Inconsistent calculation | Same metric computed differently | Investigate which is correct; flag as BLOCKER if > 5% |
| Chart rendering error | Chart visual doesn't match its data | Regenerate chart |
| Narrative drift | Claim has no traceable source | Mark as [ESTIMATED] or remove |

**Step 5 — Apply fixes.**
- Rounding: standardize (prefer the chart's precision, which comes directly from data)
- Stale copy: update the narrative/slide text to match the data
- Inconsistent calculation: re-run the relevant query; update all instances to the correct value
- Chart rendering error: re-run Chart Maker for that slide
- Narrative drift: either trace to a source or replace with hedged language ("approximately" or remove the specific number)

**Step 6 — Run a final sweep.**
After fixes, re-read narrative + charts together. Confirm no new mismatches were introduced.

**Step 7 — Record the check.**

## Output Format

```markdown
### Cross-Modal Consistency Check

| Claim | Narrative | Chart | Source data | Status | Action taken |
|-------|-----------|-------|-------------|--------|--------------|
| Mobile conversion rate | 2.1% | 2.1% | 2.1% | ✓ MATCH | None |
| Step 3 drop-off | 41% | 41% | 41% | ✓ MATCH | None |
| Revenue opportunity | $480K | $478K | $478K | ⚠ ROUNDING | Updated narrative to $478K |
| Churn rate | 6.2% | 6.2% | 5.9% | ✗ MISMATCH | Re-ran query; updated both to 5.9% |

**Overall:** [PASSED / PASSED WITH FIXES / BLOCKED]
**Fixes applied:** [N]
**Remaining issues:** [any unresolved items]
```

## Anti-Patterns

- Do not skip this check when the deck "looks right" — visual plausibility is not accuracy
- Do not round to different precisions in different places (e.g., "41%" in text, "41.3%" in chart)
- Do not assume the chart is always right — the chart inherits any bug in the query that fed it
- Do not merge this check with the Visual Design Critic review — design and accuracy are separate concerns
