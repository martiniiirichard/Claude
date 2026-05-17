# Pattern: Draft Hypothesis

**When to use:** At the start of any root-cause analysis, before touching data. Forces
multi-category thinking rather than anchoring on the first plausible explanation.

**Output:** A structured hypothesis document with ≥3 testable hypotheses across ≥2 cause
categories. Feed into the Hypothesis agent or use inline.

---

## Step 1 — State the observation

Write one precise sentence:
> "Metric [name] [changed by direction + magnitude] in [time period], from [baseline] to
> [current value], affecting [scope: all users / segment X / product area Y]."

This is your anchor. Every hypothesis must be able to explain this specific observation.

---

## Step 2 — Generate across 4 cause categories

For each category, ask the forcing question and generate 1-3 hypotheses.

### Category 1: Product Changes
**Forcing question:** "What did we ship in or before this time window that could explain this?"
- Feature launches, UI changes, pricing changes, onboarding changes
- Bug fixes that altered behavior
- A/B tests that ramped up or concluded

Hypotheses:
- H1a: [Product change] caused [mechanism] which reduced/increased [metric]
- H1b: ...

### Category 2: Technical Issues
**Forcing question:** "What could have broken silently in our data pipeline or product?"
- Data pipeline failures (missing events, double-counting)
- Tracking changes (event renamed, attribute removed)
- Infrastructure changes (CDN, latency, error rates)
- Third-party dependency changes

Hypotheses:
- H2a: [Technical change] caused [mechanism] which reduced/increased [metric]
- H2b: ...

### Category 3: External Factors
**Forcing question:** "What changed in the world or market that we didn't control?"
- Seasonality (holiday, weekend, end of month)
- Competitive moves (competitor launch, pricing change)
- Platform changes (iOS update, app store policy)
- Macroeconomic or news events

Hypotheses:
- H3a: [External factor] caused [mechanism] which reduced/increased [metric]
- H3b: ...

### Category 4: Mix Shift
**Forcing question:** "Did the composition of our users or traffic change, without any real rate change?"
- New user cohort is larger/smaller than usual
- Acquisition channel mix shifted (paid vs organic)
- Geographic or device mix changed
- Product area usage mix changed

Hypotheses:
- H4a: Mix shifted toward [lower/higher-converting] segment, making aggregate look [worse/better]
- H4b: ...

---

## Step 3 — Rank by prior probability

Score each hypothesis 1-5 on:
- **Plausibility** (does it fit the observation mechanistically?)
- **Timing** (does the timing of the change match the observation?)
- **Testability** (can we check it with available data?)

Pick the top 3 to investigate first.

---

## Step 4 — Define the test for each

For each top hypothesis, write one SQL check or data pull that would confirm or rule it out:

| Hypothesis | Predicted data pattern | Query / Check | Result needed to confirm |
|-----------|----------------------|---------------|-------------------------|
| H1a | ...                  | ...           | ...                     |
| H2a | ...                  | ...           | ...                     |
| H3a | ...                  | ...           | ...                     |

Run these before interpreting results — don't cherry-pick after seeing the data.
