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
  echo "Schema absolute path: $(pwd)/$SCHEMA"
  echo "--- Schema content start ---"
  sed -n '1,200p' "$SCHEMA" || true
  echo "--- Schema content end ---\n"

  # If poetry is available, try to run the linter inside the project's venv
  if command -v poetry >/dev/null 2>&1; then
    echo "poetry detected; showing venv info and installed packages for debugging"
    echo "poetry env info -p:"
    VENV_PATH=$(poetry env info -p 2>/dev/null || true)
    echo "$VENV_PATH"

    # Prefer calling the venv console scripts directly for determinism
    if [ -n "$VENV_PATH" ] && [ -x "$VENV_PATH/bin/linkml-lint" ]; then
      echo "Using venv binary: $VENV_PATH/bin/linkml-lint"
      "$VENV_PATH/bin/linkml-lint" "$SCHEMA" || true
    elif [ -n "$VENV_PATH" ] && [ -x "$VENV_PATH/bin/linkml" ]; then
      echo "Using venv binary: $VENV_PATH/bin/linkml lint"
      "$VENV_PATH/bin/linkml" lint "$SCHEMA" || true
    else
      echo "Venv binaries not available; falling back to 'poetry run' approach for deterministic env"
      echo "poetry run python -c 'import sys; print(sys.executable)':"
      poetry run python -c 'import sys; print(sys.executable)' 2>/dev/null || true
      echo "Installed packages in poetry venv (pip list):"
      poetry run python -m pip list 2>/dev/null || true

      if poetry run python - <<'PY'
import importlib.util, sys
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
    fi
  else
    # No poetry; fallback to script which handles system binaries
    if [ -x scripts/lint_linkml.sh ]; then
      bash scripts/lint_linkml.sh "$SCHEMA" || true
    fi
  fi
done

echo "\nLinkML smoke completed."
