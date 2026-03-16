#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 schema.yaml outdir"
  exit 2
fi
schema="$1"
outdir="$2"
mkdir -p "$outdir"

if command -v linkml-generate >/dev/null 2>&1; then
  echo "Using linkml-generate"
  linkml-generate --format html "$schema" "$outdir"
elif command -v linkml >/dev/null 2>&1; then
  echo "Using linkml CLI (generate)"
  linkml generate --format html "$schema" "$outdir"
else
  echo "No generator CLI found. Install: pip install linkml==1.10.0 linkml-runtime==1.10.0"
  exit 3
fi
