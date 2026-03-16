#!/usr/bin/env bash
set -euo pipefail

# Run minimal smoke checks and prefer using poetry-run binaries when available
echo "Running LinkML minimal smoke checks..."
if [ -x scripts/lint_linkml.sh ]; then
  echo "Running lint_linkml.sh on assets/fixtures/minimal_schema.yaml (non-failing)"
  # If poetry is available and the project has a virtualenv, use 'poetry run' to ensure tool resolution
  if command -v poetry >/dev/null 2>&1; then
    # attempt to use poetry run to execute the lint script so that 'poetry run linkml' is available
    echo "Using 'poetry run' to execute lint"
    poetry run bash scripts/lint_linkml.sh assets/fixtures/minimal_schema.yaml || true
  else
    bash scripts/lint_linkml.sh assets/fixtures/minimal_schema.yaml || true
  fi
else
  echo "No lint script found; verifying SKILL.md presence"
  if [ -f SKILL.md ]; then
    echo "SKILL.md present"
  else
    echo "SKILL.md missing"
  fi
fi

echo "LinkML smoke completed."
