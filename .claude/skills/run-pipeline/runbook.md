# Run Pipeline — Long-Horizon Runbook

For full 19-step pipelines that span many minutes or multiple sessions. Follow this runbook
to maintain coherence and recover from failures without losing work.

## The Loop

For every agent in the pipeline, execute this cycle:

```
PLAN       → Verify inputs exist, read done_when condition from registry.yaml
EXECUTE    → Run the agent: read file, substitute {{VARIABLES}}, follow step-by-step
VALIDATE   → Check done_when condition is satisfied; verify output files exist on disk
REPAIR     → If failed: diagnose root cause, simplify approach, retry once
CHECKPOINT → Write pipeline_state.json, write Summary of Fact, check for strike
```

Never skip VALIDATE. A "completed" agent that did not satisfy its `done_when` condition
is not complete.

## Failure Budget

Each agent gets **one retry** before counting as a strike.

| Running strikes | Action |
|-----------------|--------|
| 1 | Log warning, continue pipeline |
| 2 | Surface to user, continue pipeline |
| 3 | **HALT.** Re-scope with user before resuming. |

A strike is counted only when an agent fails both initial run AND retry. Degraded completion
(`critical: false` agent with partial output) is a warning, not a strike.

## Preflight Checklist

Run before starting any pipeline:

- [ ] Read `agents/registry.yaml` — confirm all agent files exist on disk
- [ ] Read `.knowledge/active.yaml` — confirm dataset name is set
- [ ] Read `.knowledge/datasets/{active}/manifest.yaml` — confirm connection details
- [ ] Run `SELECT 1` on primary connection — confirm it responds
- [ ] Read `.knowledge/corrections/index.yaml` — load corrections for this dataset
- [ ] Check `.knowledge/session/session-handoff.md` — restore cross-session context if present
- [ ] Confirm session model: Opus for full 19-step pipeline, Sonnet for sub-phases

## During Execution

- Keep exactly **one agent in_progress** at a time (single-thread model)
- Write `pipeline_state.json` atomically after every state change (.tmp then rename)
- Write Summary of Fact (`working/summaries/{agent}_summary.yaml`) when each agent completes
- Cap any Bash output to `| head -c 4000` before reading into context
- After every 5 agents, assess context growth — if heavy, save state and offer `/resume-pipeline`

## Checkpoint Gates

| Checkpoint | Fires after agent | Action |
|------------|-------------------|--------|
| 1 — Frame Verification | `hypothesis` | Review hypotheses quality; run Council Gate 1 if enabled |
| 2 — Analysis Verification | `opportunity-sizer` | Review findings; run Council Gate 2 if enabled |
| 2.5 — Storyboard Review | `narrative-coherence-reviewer` | Confirm APPROVED before any charting |
| 3 — Story & Charts | `visual-design-critic` (chart-level) | Confirm all charts approved before narrative |
| 4 — Final Deck | `visual-design-critic-slides` | Final quality gate before delivery |

At each checkpoint: emit a progress summary, surface any blockers, update `pipeline_state.json`.

## Re-scope Options (When 3 Strikes Hit)

Present the user with three options:

1. **Skip the step** — mark as `skipped`, continue with downstream agents that can tolerate absence
2. **Simplify the method** — replace the failing agent with a lighter approach (e.g., manual SQL instead of full agent)
3. **Narrow the scope** — reduce the question to something the available data can actually answer

Never silently proceed past 3 strikes.

## Session Handoff

When ending a session mid-pipeline:
1. Save all current `working/` artifacts
2. Write `.knowledge/session/session-handoff.md` with: run_id, last completed agent, next agent, open blockers
3. Inform the user: "Run `/resume-pipeline` to continue in a new session from [next step]."

At the start of a resumed session, read `session-handoff.md` before touching any data or
writing any new state.

## Context Recovery

If the conversation context was lost or compacted mid-pipeline:
1. Read `pipeline_state.json` — find last completed agent and current run_id
2. Read `working/summaries/` — load all Summary of Fact files to restore context
3. Read `.knowledge/session/session-handoff.md` — restore cross-session notes
4. Resume from the next pending agent in the DAG
