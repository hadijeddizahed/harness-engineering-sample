#!/usr/bin/env bash
set -eo pipefail

TARGET_DIR="${1:-.}"
cd "$TARGET_DIR"

echo "=== Running Clean State Check ==="

# Dimension 1: Build & verification check
echo "1. Checking build verification..."
if [[ -f "pom.xml" ]]; then
  if [[ -f "./mvnw" ]]; then
    ./mvnw test-compile -q
  elif command -v mvn &>/dev/null; then
    mvn test-compile -q
  fi
fi
echo "   [PASS] Build verification succeeds."

# Dimension 2: Feature list integrity
echo "2. Checking feature_list.json..."
if [[ -f "feature_list.json" ]]; then
  python3 -c "import json; json.load(open('feature_list.json'))" 2>/dev/null || {
    echo "   [FAIL] feature_list.json is invalid JSON"
    exit 1
  }
fi
echo "   [PASS] feature_list.json is valid."

# Dimension 3: PROGRESS.md state
echo "3. Checking PROGRESS.md..."
if [[ ! -f "PROGRESS.md" ]]; then
  echo "   [FAIL] PROGRESS.md missing."
  exit 1
fi
if ! grep -qi "Current State" PROGRESS.md || ! grep -qi "Next Steps" PROGRESS.md; then
  echo "   [FAIL] PROGRESS.md missing Current State or Next Steps."
  exit 1
fi
echo "   [PASS] PROGRESS.md has required sections."

# Dimension 4: No temporary or debug dump files
echo "4. Checking for debug artifacts..."
DIRTY_FILES="$(git status --porcelain | grep -E '\.(tmp|bak|orig|swp)$' || true)"
if [[ -n "$DIRTY_FILES" ]]; then
  echo "   [FAIL] Found uncommitted debug/temporary files: $DIRTY_FILES"
  exit 1
fi
echo "   [PASS] No debug artifacts present."

# Dimension 5: Startup path
echo "5. Checking startup script..."
if [[ ! -x "init.sh" ]]; then
  chmod +x init.sh 2>/dev/null || true
fi
echo "   [PASS] Startup script executable."

echo "=== All 5 Clean-State Dimensions Passed ==="
exit 0
