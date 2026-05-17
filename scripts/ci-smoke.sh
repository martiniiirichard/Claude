#!/usr/bin/env bash
# ci-smoke.sh — Run before pushing any CI workflow changes.
# Catches the most common CI failures locally in under 60 seconds.
# Usage: bash scripts/ci-smoke.sh

set -e
PASS=0; FAIL=0
ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }
section() { echo; echo "── $1 ──"; }

# ── 1. Gitignore gap analysis ──────────────────────────────────────
section "Gitignore gap analysis"
for path in working/ outputs/ .knowledge/active.yaml .mcp.json; do
  if git check-ignore -q "$path" 2>/dev/null; then
    fail "$path is gitignored — CI workflows must not require it to exist"
  else
    ok "$path is tracked (or doesn't exist yet)"
  fi
done

# ── 2. Case-sensitivity scan ───────────────────────────────────────
section "Case-sensitivity scan (Windows vs Linux)"
UPPER=$(git ls-files | grep -E "[A-Z]" | grep -v "\.github/" | grep -v "README" | grep -v "CLAUDE" | grep -v "CHANGELOG" | grep -v "MEMORY" || true)
if [ -n "$UPPER" ]; then
  echo "  Files with uppercase in names (verify intentional):"
  echo "$UPPER" | while read -r f; do echo "    $f"; done
  fail "Check these against all lowercase references in code/configs"
else
  ok "No unexpected uppercase filenames found"
fi

# ── 3. Dependency integrity ────────────────────────────────────────
section "Dependency source-of-truth check"
if [ -f requirements.txt ]; then
  ok "requirements.txt found — CI must use: pip install -r requirements.txt"
  # Check for imports not in requirements.txt
  IMPORTS=$(grep -rh "^import\|^from" tests/ helpers/ 2>/dev/null | grep -oP "(?<=import |from )\w+" | sort -u | grep -Ev "^(os|sys|re|json|math|io|copy|pathlib|datetime|typing|collections|itertools|functools|abc|enum|warnings|traceback|time|random|string|uuid|hashlib|base64|struct|inspect|tempfile|shutil|glob|csv|contextlib|dataclasses|unittest|pytest|_pytest|__future__|annotations|builtins)$" || true)
  echo "  Third-party imports found in tests/ and helpers/:"
  echo "$IMPORTS" | tr ' ' '\n' | grep -v "^$" | while read -r pkg; do
    if grep -qi "$pkg" requirements.txt 2>/dev/null; then
      echo "    ✓ $pkg"
    else
      echo "    ? $pkg — not in requirements.txt (may be a local module)"
    fi
  done
else
  fail "No requirements.txt found — CI will guess dependencies"
fi

# ── 4. YAML structure inspection ──────────────────────────────────
section "YAML data structure check"
if [ -f agents/registry.yaml ]; then
  TYPE=$(python3 -c "import yaml; d=yaml.safe_load(open('agents/registry.yaml')); print(type(d.get('agents',d)).__name__)" 2>/dev/null || echo "unknown")
  ok "agents/registry.yaml agents value type: $TYPE"
fi
for f in .mcp.json .claude/settings.json; do
  if [ -f "$f" ]; then
    python3 -m json.tool "$f" > /dev/null 2>&1 && ok "$f is valid JSON" || fail "$f has invalid JSON"
  fi
done

# ── 5. Test collection dry-run ─────────────────────────────────────
section "Test collection dry-run (no tests run)"
if [ -d tests ]; then
  if pip install -r requirements.txt pytest -q 2>/dev/null && python3 -m pytest tests/ --collect-only -q 2>&1 | tail -3; then
    ok "Test collection succeeded"
  else
    fail "Test collection failed — imports or syntax errors in tests/"
  fi
else
  ok "No tests/ directory (skipped)"
fi

# ── 6. Skill path validation ───────────────────────────────────────
section "CLAUDE.md skill path validation"
python3 - <<'EOF'
import re, os, sys
missing = []
with open("CLAUDE.md") as f:
    for p in re.findall(r'`(\.claude/skills/[^`]+/skill\.md)`', f.read()):
        if not os.path.exists(p):
            missing.append(p)
        else:
            print(f"  ✓ {p}")
if missing:
    for p in missing:
        print(f"  ✗ {p} — MISSING")
    sys.exit(1)
EOF
[ $? -eq 0 ] && ok "All CLAUDE.md skill paths exist" || fail "Missing skill files"

# ── Summary ────────────────────────────────────────────────────────
echo
echo "══════════════════════════════════"
echo "  Passed: $PASS  |  Failed: $FAIL"
echo "══════════════════════════════════"
if [ $FAIL -gt 0 ]; then
  echo "Fix failures above before pushing CI changes."
  exit 1
fi
echo "All checks passed — safe to push CI changes."
