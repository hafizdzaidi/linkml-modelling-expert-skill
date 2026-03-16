#!/usr/bin/env bash
set -euo pipefail

# Run smoke checks across all fixtures and prefer using poetry-run binaries when available
echo "Running LinkML smoke checks..."

for SCHEMA in assets/fixtures/*.yaml; do
  if [ ! -f "$SCHEMA" ]; then
    echo "No schema fixtures found (checked assets/fixtures/*.yaml)"
    break
  fi
  echo "\n--- Linting: $SCHEMA ---"

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
# Exit 0 if module exists, 1 otherwise — allows shell 'if' to test presence
sys.exit(0 if importlib.util.find_spec('linkml_lint') else 1)
PY
    then
      echo "Using 'poetry run linkml-lint'"
      poetry run linkml-lint "$SCHEMA" || true
    elif poetry run python - <<'PY'
import importlib.util, sys
sys.exit(0 if importlib.util.find_spec('linkml') else 1)
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
done

echo "\nLinkML smoke completed."
