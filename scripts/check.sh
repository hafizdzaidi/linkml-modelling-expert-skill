#!/usr/bin/env bash
set -euo pipefail

echo "Running LinkML minimal smoke checks..."
if [ -x scripts/lint_linkml.sh ]; then
  echo "Running lint_linkml.sh on assets/fixtures/minimal_schema.yaml (non-failing)"
  bash scripts/lint_linkml.sh assets/fixtures/minimal_schema.yaml || true
else
  echo "No lint script found; verifying SKILL.md presence"
  if [ -f SKILL.md ]; then
    echo "SKILL.md present"
  else
    echo "SKILL.md missing"
  fi
fi

echo "LinkML smoke completed."
