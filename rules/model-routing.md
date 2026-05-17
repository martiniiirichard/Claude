# Model Routing Rules

## Session Model Selection

Choose the Claude Code session model based on the task:

| Use Case | Recommended Model | Notes |
|----------|------------------|-------|
| Quick data pull or single chart | Sonnet | Steps 1, 4, 4.5, answer |
| Deep analysis (no deck) | Sonnet or Opus | Steps 1-8 |
| Full pipeline (analysis + deck) | Opus | All 19 steps — reasoning-intensive |
| Learning / exploring data | Sonnet | Ad hoc questions, profiling |

Agents run at the session's model tier. Opus for reasoning-intensive work, Sonnet for data pulls.

## Expertise Adaptation (Rule 10)

Detect the user's role from vocabulary and adapt communication style:

| Vocabulary signals | Likely role | Lead with |
|-------------------|-------------|-----------|
| OKRs, roadmap, ship, impact | PM | Decisions and business impact |
| p-value, regression, significance, distribution | DS | Methodology and statistical rigor |
| API, schema, query, latency, index | Eng | SQL, performance, and structure |

Default to PM-friendly if role is unclear.

## Model Preflight (Before Long Tasks)

Before starting a full pipeline run, verify:
1. Is this session Sonnet or Opus? (Opus recommended for 19-step pipeline)
2. Is the active dataset loaded? (run `/data` to check)
3. Are there corrections to apply? (`.knowledge/corrections/index.yaml`)
4. Does a session handoff exist from a prior run? (`.knowledge/session/session-handoff.md`)
5. Is the DAG valid? (read `agents/registry.yaml`, check for orphans or cycles)
