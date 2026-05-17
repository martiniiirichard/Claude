# Pattern: Prioritize Findings

Use this pattern after generating a list of analytical findings or issues to rank them by business impact — so the team knows what to fix or investigate first.

## When to Apply

- After root cause investigation produces multiple candidate issues
- When backlog has competing analytical tasks and the team needs to triage
- Any time you have 3+ findings and need to recommend a starting point

## Priority Formula

```
Priority Score = (Severity × Frequency × Confidence × Blast Radius × Upstream-ness) ÷ TTL
```

### Factor Definitions

| Factor | Scale | Meaning |
|--------|-------|---------|
| **Severity** | 1–5 | Impact per affected user/transaction. 5 = revenue loss or broken critical path; 1 = cosmetic |
| **Frequency** | 1–5 | How often does this occur? 5 = every session; 1 = rare edge case |
| **Confidence** | 0.2–1.0 | How sure are we this finding is real? Use evidence label: VERIFIED=1.0, ESTIMATED=0.7, INFERRED=0.4, BENCHMARKED=0.6 |
| **Blast Radius** | 1–5 | How many users/segments are affected? 5 = all users; 1 = single cohort or feature flag |
| **Upstream-ness** | 1–3 | Is this a root cause (3) or a downstream symptom (1)? Fix upstream issues first |
| **TTL** | 1–10 | How many weeks before this finding is stale or the window closes? Higher TTL = more time, so lower urgency |

### Score Interpretation

| Score | Priority | Action |
|-------|----------|--------|
| > 15 | P0 — Immediate | Investigate or fix this week |
| 8–15 | P1 — High | Include in next sprint |
| 3–8 | P2 — Medium | Schedule within quarter |
| < 3 | P3 — Low | Backlog; revisit at planning |

## Step-by-Step

**Step 1 — List all findings.** Write each finding as a one-line statement (use evidence label from triangulation).

**Step 2 — Score each factor.** For each finding, assign Severity, Frequency, Blast Radius, and Upstream-ness (1–5 or 1–3 scale). Derive Confidence from the evidence label.

**Step 3 — Estimate TTL.** Ask: "If we don't act on this for N weeks, does the finding become irrelevant?" Set TTL = that N. Minimum 1.

**Step 4 — Compute scores.** Apply the formula. Round to one decimal place.

**Step 5 — Sort and assign tiers.** Order by score descending. Assign P0–P3 per the table above.

**Step 6 — Sanity check the top 3.** For each P0/P1: does this ranking feel right given business context? If a low-score finding is politically critical (exec visibility, legal risk), flag it separately as "Escalation: not in formula."

**Step 7 — Output the prioritized table.**

## Output Format

```markdown
### Finding Prioritization

| Rank | Finding | Label | Sev | Freq | Conf | Radius | Upstream | TTL | Score | Priority |
|------|---------|-------|-----|------|------|--------|----------|-----|-------|----------|
| 1 | [finding statement] | [VERIFIED] | 4 | 5 | 1.0 | 4 | 3 | 3 | 26.7 | P0 |
| 2 | [finding statement] | [INFERRED] | 3 | 3 | 0.4 | 3 | 2 | 4 | 5.4 | P2 |

**Recommended starting point:** [Finding 1] — highest score, VERIFIED evidence, upstream root cause.

**Escalations (outside formula):** [Any items flagged for non-formula reasons]
```

## Example

**Findings:**
1. [VERIFIED] Mobile checkout step 3 has 41% drop-off vs 12% desktop — Sev=5, Freq=5, Conf=1.0, Radius=4, Upstream=2, TTL=4
   Score = (5×5×1.0×4×2) ÷ 4 = 200 ÷ 4 = **50 → P0**

2. [INFERRED] New user activation rate lower for users who skipped onboarding step — Sev=3, Freq=3, Conf=0.4, Radius=3, Upstream=3, TTL=8
   Score = (3×3×0.4×3×3) ÷ 8 = 32.4 ÷ 8 = **4.1 → P2**

3. [ESTIMATED] Revenue impact of cart abandonment estimated at $240K/year — Sev=4, Freq=4, Conf=0.7, Radius=5, Upstream=1, TTL=12
   Score = (4×4×0.7×5×1) ÷ 12 = 56 ÷ 12 = **4.7 → P2**

**Result:** The mobile checkout drop-off dominates (score 50 vs 4-5 for others). Fix that first.

## Anti-Patterns

- Do not use the formula as a black box — sanity check the top 3 against business context
- Do not assign Confidence=1.0 to INFERRED findings — the formula will over-rank uncertain results
- Do not skip TTL — a critical finding with a 2-week window is more urgent than the same finding with a 6-month window
