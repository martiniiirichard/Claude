# CI Pre-flight Checklist

Run this before writing or updating any `.github/workflows/*.yml` file.
Codex and Gemini both identified these checks as what separates a 1-cycle
CI setup from a 6-cycle one.

## Quick run

```bash
bash scripts/ci-smoke.sh
```

Passes in under 60 seconds. Fix all failures before pushing.

## What it checks

| Check | The mistake it prevents |
|-------|------------------------|
| Gitignore gap analysis | CI checking `working/`, `outputs/`, or `active.yaml` that don't exist in the runner |
| Case-sensitivity scan | `SKILL.md` vs `skill.md` — Windows ignores it, Linux fails |
| Dependency source-of-truth | Manual `pip install` list missing `scipy`, `seaborn`, etc. — always use `requirements.txt` |
| YAML data structure inspection | Assuming `agents:` is a dict when it's a list |
| Test collection dry-run | Import errors caught before pushing (no tests actually run) |
| Skill path validation | Broken links in `CLAUDE.md` skill table caught locally |

## Manual pre-flight (if script unavailable)

```bash
# 1. Check gitignore — will CI see what it needs?
cat .gitignore

# 2. Case-sensitivity — any uppercase filenames?
git ls-files | grep -E "[A-Z]"

# 3. Deps — use the canonical file, never a manual list
pip install -r requirements.txt
pip check

# 4. Inspect YAML schemas before scripting against them
head -30 agents/registry.yaml     # list or dict?

# 5. Test collect-only — catches import errors instantly
python -m pytest tests/ --collect-only -q

# 6. Validate workflow YAML syntax (requires actionlint)
actionlint .github/workflows/*.yml
```

## The rule

> Every path, file, and package a CI workflow touches must be
> verified to exist and be what you think it is **before** the workflow is written.

The CI runner sees only what is committed, runs on Linux, and has
only the packages you explicitly install from a canonical source.
Assume nothing else.
