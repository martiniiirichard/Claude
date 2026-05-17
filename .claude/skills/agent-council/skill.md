---
name: agent-council
description: Collect and synthesize opinions from multiple AI agents. Use when users say "summon the council", "ask other AIs", or want multiple AI perspectives on a question.
---

# Agent Council

Collect multiple AI opinions and synthesize one answer.

## Usage

Run a job and collect results:

```bash
JOB_DIR=$(.claude/skills/agent-council/scripts/council.sh start "your question here")
.claude/skills/agent-council/scripts/council.sh wait "$JOB_DIR"
.claude/skills/agent-council/scripts/council.sh results "$JOB_DIR"
.claude/skills/agent-council/scripts/council.sh clean "$JOB_DIR"
```

One-shot:

```bash
.claude/skills/agent-council/scripts/council.sh "your question here"
```

## References

- `references/overview.md` — workflow and background.
- `references/examples.md` — usage examples.
- `references/config.md` — member configuration.
- `references/requirements.md` — dependencies and CLI checks.
- `references/host-ui.md` — host UI checklist guidance.
- `references/safety.md` — safety notes.
