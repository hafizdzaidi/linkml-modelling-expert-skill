#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 schema.yaml instance.(json|yaml)"
  exit 2
fi
schema="$1"
instance="$2"

if command -v linkml-validate >/dev/null 2>&1; then
  echo "Using linkml-validate"
  linkml-validate "$schema" "$instance"
elif command -v linkml >/dev/null 2>&1; then
  echo "Using linkml CLI (validate)"
  linkml validate --schema "$schema" "$instance"
else
  echo "linkml CLI not found. Install pinned versions: pip install linkml==1.10.0 linkml-runtime==1.10.0"
  exit 3
fi
