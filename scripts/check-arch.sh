#!/usr/bin/env bash
set -eo pipefail

RULES_FILE=".harness/arch-rules.json"
if [[ ! -f "$RULES_FILE" ]]; then
  echo "Error: $RULES_FILE not found."
  exit 1
fi

echo "=== Running Architectural Rules Verification ==="

VIOLATIONS=0

# Check Rule ARCH-001: Controllers must not access Repositories directly
if find src/main/java -name '*Controller.java' 2>/dev/null | xargs grep -E 'Repository[[:space:]]+[a-zA-Z0-9_]+;' 2>/dev/null; then
  echo "[ARCH-001 VIOLATION]"
  echo "  WHAT: Controller directly references a Repository class."
  echo "  WHY:  Controllers handle HTTP routing. Domain logic and persistence belong in the service layer."
  echo "  FIX:  Inject TaskService into Controller and place repository access in TaskService."
  VIOLATIONS=$((VIOLATIONS + 1))
fi

# Check Rule ARCH-002: Service layer must not import servlet/HTTP classes
if find src/main/java -name '*Service.java' 2>/dev/null | xargs grep -E 'import (jakarta\.servlet|org\.springframework\.web)' 2>/dev/null; then
  echo "[ARCH-002 VIOLATION]"
  echo "  WHAT: Service layer imports web/HTTP classes."
  echo "  WHY:  Core services must remain protocol-agnostic."
  echo "  FIX:  Move HTTP-specific handling to Controller."
  VIOLATIONS=$((VIOLATIONS + 1))
fi

if [[ $VIOLATIONS -gt 0 ]]; then
  echo "Architectural check failed with $VIOLATIONS violation(s)."
  exit 1
fi

echo "Architectural check passed cleanly."
exit 0
