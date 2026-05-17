# Execution Safety Rules

## Token Stewardship (Rule 16)

Context is a finite resource. Protect it or long pipelines become unreliable.

- **Cap Bash output** to 4000 bytes: `some_command | head -c 4000`
- **Prefer file paths** over pasted content. Write to `working/`, reference the path.
- **Split large tasks** into Scope → Inspect → Report → Approve before expanding further.
- **Never paste large files** into the conversation. Read only the relevant section.
- **When context grows long** (>15 queries in a session), save all working files and suggest
  `/resume-pipeline` rather than continuing in a degraded context.

## Pipeline Safety

**Rule 4 — Never present unvalidated findings as conclusions.**
Findings are hypotheses until validated. Use "the data suggests" not "the data proves" unless
validation confirms it.

**Rule 5 — Save outputs to the correct location.**
Intermediate work → `working/`. Final deliverables (analyses, charts, decks) → `outputs/`.

**Rule 13 — Run 4-layer validation before presenting findings.**
Every analysis must pass all four layers:
1. **Structural** — schema/PK/completeness
2. **Logical** — aggregation/trend consistency
3. **Business rules** — plausibility checks
4. **Simpson's Paradox** — segment-first check before concluding

Include the confidence badge (A-F grade) in the executive summary. HALT on any BLOCKER.

## When Things Go Wrong

| Problem | What to Do |
|---------|-----------|
| MotherDuck won't connect | Fall back to local DuckDB/CSVs automatically. Inform the user which source is active. |
| SQL query errors | Simplify the query. If JOIN fails, try subquery. If aggregation fails, check GROUP BY. Show the user what went wrong. |
| Chart won't render | Save the data table as CSV fallback. Try a simpler chart type. If matplotlib fails entirely, produce a text summary. |
| Source tie-out fails | HALT. Do not proceed with analysis. Show the mismatch. Ask: "Should we investigate the data issue or proceed with caution?" |
| Context getting long | After analysis phase (steps 1-8), if >15 queries were run, save all working files and suggest: "/resume-pipeline to continue in a fresh session." |
| Agent produces poor output | Re-read the agent file and re-run with more specific inputs. If it fails a second time, switch to manual collaborative mode with the user. |
| User's data doesn't match expected schema | Check the data inventory, adjust queries to match the actual schema. |
| Council gate unavailable | No CLI members reachable — skip silently and continue. |
| 3 pipeline strikes reached | HALT. Show re-scope options: skip the step, use a simpler method, or narrow the scope. |
