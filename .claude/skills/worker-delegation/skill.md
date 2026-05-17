---
name: worker-delegation
description: Delegate a self-contained sub-task to a worker agent. Use when a task is too large for a single context, or when independent sub-tasks can be parallelized.
---

# Worker Delegation

Break a large task into self-contained chunks and hand each to a worker. Collect and
synthesize the results.

## When to Use

- A pipeline step requires running the same operation across N independent inputs
  (e.g., generate 5 charts, profile 4 tables, validate 3 SQL queries)
- Two independent tasks can run in parallel to save time
  (e.g., draft narrative while design critic reviews charts)
- The current context is becoming full and a sub-task needs a clean slate

Do NOT delegate:
- Tasks that require access to the current conversation history
- Tasks where the result of one depends on the result of another (sequence these instead)
- Tasks shorter than ~5 steps — the overhead is not worth it

## How to Delegate

### Step 1 — Define the worker's scope

Write a one-sentence scope for the worker that passes the "no shared state" test:
> "A new agent, with no memory of this conversation, could complete this task given only
> the inputs listed below."

If it can't pass that test, the task is not ready to delegate.

### Step 2 — Write the handoff prompt

Each worker prompt must be fully self-contained. Include:

```markdown
## Task
[One sentence describing what the worker must produce]

## Context
[Everything the worker needs to understand the task — no assumed shared memory]
- Dataset: [name and relevant schema]
- Question being analyzed: [verbatim]
- Prior findings (if relevant): [brief summary or file path]

## Inputs
[Exact file paths, data values, or text the worker will operate on]

## Output Required
[Exact file path and format the worker must write]

## Done When
[Specific, verifiable condition — what does a completed output look like?]

## Constraints
- Do not modify any files outside [specific directory]
- Use [specific helper / style / tool]
- If you encounter [specific failure], [specific fallback action]
```

### Step 3 — Launch and track

Note each worker's:
- Task description
- Input(s)
- Expected output file
- Status: pending / running / done / failed

### Step 4 — Collect results

For each worker, verify `done_when` before accepting the output:
- Does the output file exist on disk?
- Does it contain the expected content?
- Are there any error markers?

If a worker fails: diagnose, fix the input, re-delegate once. If it fails again, handle the
sub-task directly rather than re-delegating.

### Step 5 — Synthesize

After all workers complete, read each output and produce a unified result:
- Merge findings (resolve conflicts by flagging them, not silently picking one)
- Note which workers produced partial or degraded output
- Cite each worker's output file in the synthesis

---

## Templates by Use Case

### Parallel chart generation

```
Workers: one per chart spec
Input: DATA + CHART_SPEC + THEME + OUTPUT_NAME
Output: outputs/charts/{OUTPUT_NAME}.png
Done when: PNG exists, swd_style() was called
Synthesize: list all chart paths for the Deck Creator
```

### Parallel table profiling

```
Workers: one per table
Input: TABLE_NAME + connection details
Output: working/profile_{TABLE_NAME}.md
Done when: profile file has row count, null rates, and date range
Synthesize: merge into data_inventory.md
```

### Parallel validation

```
Workers: one per validation layer (structural / logical / business rules / Simpson's)
Input: ANALYSIS_RESULTS + DATA_SOURCE
Output: working/validation_{layer}.md
Done when: file has PASS / FAIL / BLOCKER verdict
Synthesize: roll up into validation report with confidence grade
```

---

## Failure Handling

| Symptom | Action |
|---------|--------|
| Worker output file missing | Re-run the worker once with the same prompt |
| Worker output is empty or malformed | Diagnose: was the input valid? Re-run with a corrected input |
| Worker produces a partial result | Accept as degraded if non-critical; flag as BLOCKER if critical |
| Second failure on same worker | Handle the sub-task directly in the main context |

Never accept a failed worker silently. Always surface the failure in the synthesis.
