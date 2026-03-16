#!/usr/bin/env bash
set -euo pipefail

if ! command -v poetry >/dev/null 2>&1; then
  echo "Poetry is not installed. Install from https://python-poetry.org/docs/#installation"
  echo "Recommended: curl -sSL https://install.python-poetry.org | python3 -"
  exit 2
fi

echo "Installing dependencies via Poetry..."
# Attempt to use Python 3.10 if available; poetry will select an appropriate interpreter if not.
poetry env use python3.10 || true
poetry install

echo "Poetry environment ready. Run scripts with 'poetry run <cmd>' or 'poetry shell'."
