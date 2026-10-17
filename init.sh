#!/usr/bin/env bash
set -eo pipefail

echo "========================================="
echo " Harness Engineering: Task Tracker Init   "
echo "========================================="

# 1. Check Java version
echo "[1/4] Checking Java..."
if ! command -v java &>/dev/null; then
  echo "Error: Java is not installed or not in PATH."
  exit 1
fi
JAVA_VER=$(java -version 2>&1 | head -n 1)
echo "  Found Java: $JAVA_VER"

# 2. Check build tool (Maven)
echo "[2/4] Checking Maven..."
if [ -f "./mvnw" ]; then
  echo "  Found Maven wrapper."
elif command -v mvn &>/dev/null; then
  MVN_VER=$(mvn -version 2>&1 | head -n 1)
  echo "  Found Maven: $MVN_VER"
else
  echo "Error: Neither ./mvnw nor mvn is available."
  exit 1
fi

# 3. Setup permissions and directories
echo "[3/4] Preparing scripts and directories..."
chmod +x scripts/*.sh 2>/dev/null || true
mkdir -p .harness/traces

# 4. Run baseline verification
echo "[4/4] Running baseline verification..."
make check

echo "========================================="
echo " Harness is green! Ready for work.       "
echo "========================================="
exit 0
