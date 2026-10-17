#!/usr/bin/env bash
set -eo pipefail

FEATURE_ID="$1"
if [[ -z "$FEATURE_ID" ]]; then
  echo "Usage: $0 <feature-id>"
  exit 1
fi

FL="feature_list.json"
if [[ ! -f "$FL" ]]; then
  echo "Error: feature_list.json not found."
  exit 1
fi

echo "=== Verifying Feature: $FEATURE_ID ==="

# Check feature exists in feature_list.json
if ! grep -q "\"$FEATURE_ID\"" "$FL"; then
  echo "Error: Feature $FEATURE_ID not found in $FL"
  exit 1
fi

run_layer() {
  local layer_label="$1"
  local cmd="$2"
  local repair="$3"

  echo "----------------------------------------"
  echo "Running $layer_label: $cmd"
  if ! eval "$cmd"; then
    echo "FAILED: $layer_label"
    echo "How to fix / repair instructions:"
    echo "  $repair"
    exit 1
  fi
  echo "PASSED: $layer_label"
}

# Layer 1: Unit & Compilation Verification
run_layer "Layer 1 (Unit & Compilation)" \
  "if [ -f ./mvnw ]; then ./mvnw test-compile -q; else mvn test-compile -q; fi" \
  "Fix syntax or build errors in pom.xml and source files."

# Layer 2: Integration Verification
run_layer "Layer 2 (Integration Tests)" \
  "if [ -f ./mvnw ]; then ./mvnw test -q; else mvn test -q; fi" \
  "Ensure endpoint tests and assertions pass."

# Layer 3: Architecture Check
run_layer "Layer 3 (Architecture Rules)" \
  "bash scripts/check-arch.sh" \
  "Ensure controllers do not call repositories directly and entities are not exposed directly."

echo "========================================"
echo "Feature $FEATURE_ID successfully verified across all layers!"
exit 0
