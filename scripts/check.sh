#!/usr/bin/env bash
set -euo pipefail

# Run minimal smoke checks and prefer using poetry-run binaries when available
echo "Running LinkML minimal smoke checks..."
SCHEMA="assets/fixtures/minimal_schema.yaml"
if [ -f "$SCHEMA" ]; then
  echo "Running lint on $SCHEMA (non-failing)"
  # If poetry is available, try to run the linter inside the project's venv
  if command -v poetry >/dev/null 2>&1; then
    echo "poetry detected; showing venv info and installed packages for debugging"
    echo "poetry env info -p:"
    poetry env info -p 2>/dev/null || true
    echo "poetry run python -c 'import sys; print(sys.executable)':"
    poetry run python -c 'import sys; print(sys.executable)' 2>/dev/null || true
    echo "Installed packages in poetry venv (pip list):"
    poetry run python -m pip list 2>/dev/null || true

    if poetry run python - <<'PY'
import importlib.util, sys
print(bool(importlib.util.find_spec('linkml_lint')))
PY
    then
      echo "Using 'poetry run linkml-lint'"
      poetry run linkml-lint "$SCHEMA" || true
    elif poetry run python - <<'PY'
import importlib.util, sys
print(bool(importlib.util.find_spec('linkml')))
PY
    then
      echo "Using 'poetry run linkml lint'"
      poetry run linkml lint "$SCHEMA" || true
    else
      echo "LinkML not found in poetry venv; falling back to project-aware script or system binaries"
      if [ -x scripts/lint_linkml.sh ]; then
        bash scripts/lint_linkml.sh "$SCHEMA" || true
      fi
    fi
  else
    # No poetry; fallback to script which handles system binaries
    if [ -x scripts/lint_linkml.sh ]; then
      bash scripts/lint_linkml.sh "$SCHEMA" || true
    fi
  fi
else
  echo "No schema fixture found at $SCHEMA"
fi

echo "LinkML smoke completed."
