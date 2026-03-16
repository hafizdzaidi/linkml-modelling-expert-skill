#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 schema.yaml"
  exit 2
fi
schema="$1"

if command -v linkml-lint >/dev/null 2>&1; then
  echo "Using linkml-lint"
  linkml-lint "$schema"
elif command -v linkml >/dev/null 2>&1; then
  echo "Using linkml CLI (lint)"
  linkml lint "$schema"
else
  echo "linkml CLI not found. Install pinned versions: pip install linkml==1.10.0 linkml-runtime==1.10.0"
  exit 3
fi
