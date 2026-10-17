#!/usr/bin/env bash
set -eo pipefail

ACTION="$1"
DETAIL="${2:-none}"
TRACE_DIR=".harness/traces"
TRACE_FILE="$TRACE_DIR/traces.jsonl"

mkdir -p "$TRACE_DIR"

TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
COMMIT_HASH="$(git rev-parse --short HEAD 2>/dev/null || echo "initial")"

cat <<EOF >> "$TRACE_FILE"
{"timestamp":"$TIMESTAMP","commit":"$COMMIT_HASH","action":"$ACTION","detail":"$DETAIL"}
EOF

echo "Session trace event recorded: [$ACTION] $DETAIL"
