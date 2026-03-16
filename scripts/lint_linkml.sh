#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 schema.yaml"
  exit 2
fi
schema="$1"

# Prefer project virtualenv via poetry if present and the binaries exist there
if command -v poetry >/dev/null 2>&1; then
  if poetry run which linkml-lint >/dev/null 2>&1; then
    echo "Using poetry run linkml-lint"
    poetry run linkml-lint "$schema"
    exit $?
  elif poetry run which linkml >/dev/null 2>&1; then
    echo "Using poetry run linkml (lint)"
    poetry run linkml lint "$schema"
    exit $?
  else
    echo "poetry present but linkml not installed in the project venv; falling back to system binaries"
  fi
fi

if command -v linkml-lint >/dev/null 2>&1; then
  echo "Using linkml-lint"
  linkml-lint "$schema"
elif command -v linkml >/dev/null 2>&1; then
  echo "Using linkml CLI (lint)"
  linkml lint "$schema"
else
  echo "linkml CLI not found. Install pinned versions: pip install linkml==1.10.0 linkml-runtime==1.10.0 or use 'poetry run linkml-lint'"
  exit 3
fi
