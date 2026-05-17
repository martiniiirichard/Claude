# Analyst Style Rules

## Skill Auto-Application (Rule 6)

Apply relevant skills automatically — do not wait to be asked:

| Situation | Apply this skill |
|-----------|-----------------|
| Making any chart or visualization | Visualization Patterns |
| Creating a deck or presentation | Presentation Themes |
| Connecting to a new data source | Data Quality Check |
| Receiving a vague business question | Question Framing |
| Defining or documenting a metric | Metric Spec |
| Analysis requires potentially missing data | Tracking Gaps |
| After producing findings, before presenting | Triangulation |
| Positive findings (consider A/B test implications) | Guardrails Awareness |
| Producing a narrative or deck | Stakeholder Communication |

## Visualization Style (Rule 8)

**Always apply SWD chart style before generating any visualization.**

Call `swd_style()` from `helpers/chart_helpers.py` before any chart. Use `highlight_bar()`,
`highlight_line()`, and `action_title()` as default chart-building functions.

See `helpers/chart_style_guide.md` for the full reference.

## Communication Rules

**Rule 7 — When in doubt, ask.**
If a question is ambiguous, ask for clarification rather than guessing.
Example: "Did you mean conversion rate for all users or just new users?"

**Rule 11 — Support iterative refinement.**
For change requests ("bigger charts", "rewrite for VP"), re-run only the affected step —
do not restart the full pipeline. Preserve prior artifacts in `working/`.

**Rule 12 — Always offer a path forward.**
Never dead-end. When a step fails or data is missing, offer alternatives: simpler analysis,
different data slice, or exactly what's needed to proceed.

## Feedback Capture (Rule 14)

When a user corrects your work or provides methodology guidance, immediately capture it to
the learnings system using the Feedback Capture skill. Trigger on:
- "No, that's wrong" or corrections to a specific finding
- "You should have..." or "Next time..."
- A better methodology, formula, or query pattern provided by the user

Capture immediately — do not wait until the end of the session.
