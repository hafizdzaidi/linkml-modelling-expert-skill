#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 schema.yaml"
  exit 2
fi
schema="$1"

# If poetry is available, prefer the project's venv binaries (robust lookup via poetry env info)
if command -v poetry >/dev/null 2>&1; then
  venv_path="$(poetry env info -p 2>/dev/null || true)"
  if [ -n "$venv_path" ]; then
    if [ -x "$venv_path/bin/linkml-lint" ]; then
      echo "Using linkml-lint from poetry venv: $venv_path"
      "$venv_path/bin/linkml-lint" "$schema"
      exit $?
    elif [ -x "$venv_path/bin/linkml" ]; then
      echo "Using linkml from poetry venv: $venv_path"
      "$venv_path/bin/linkml" lint "$schema"
      exit $?
    fi
  fi
  # fallback: try 'poetry run' directly (works even if venv path couldn't be determined)
  if poetry run linkml-lint "$schema" >/dev/null 2>&1; then
    echo "Using 'poetry run linkml-lint'"
    poetry run linkml-lint "$schema"
    exit $?
  elif poetry run linkml lint "$schema" >/dev/null 2>&1; then
    echo "Using 'poetry run linkml lint'"
    poetry run linkml lint "$schema"
    exit $?
  else
    echo "poetry present but linkml not installed in the project venv; falling back to system binaries"
  fi
fi

# Fallback to system-installed CLIs
if command -v linkml-lint >/dev/null 2>&1; then
  echo "Using linkml-lint (system)"
  linkml-lint "$schema"
elif command -v linkml >/dev/null 2>&1; then
  echo "Using linkml CLI (system)"
  linkml lint "$schema"
else
  echo "linkml CLI not found. Install pinned versions: pip install linkml==1.10.0 linkml-runtime==1.10.0 or run 'poetry install' in the skill directory"
  exit 3
fi
