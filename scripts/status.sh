#!/usr/bin/env bash
set -eo pipefail

python3 - << 'EOF'
import json, sys

try:
    with open("feature_list.json") as f:
        d = json.load(f)
except Exception as e:
    print(f"Error reading feature_list.json: {e}")
    sys.exit(1)

feats = d.get("features", [])
passing = [f for f in feats if f.get("state") == "passing"]
active = [f for f in feats if f.get("state") == "active"]
planned = [f for f in feats if f.get("state") in ("planned", "not_started")]

# ANSI colors
GREEN = "\033[92m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
RESET = "\033[0m"
BOLD = "\033[1m"

print("\n" + BOLD + "=========================== TASK STATUS ===========================" + RESET)
print(f"Developed (Passing): {GREEN}{len(passing)}{RESET} | In Progress: {YELLOW}{len(active)}{RESET} | Left (Planned): {BLUE}{len(planned)}{RESET} | Total: {len(feats)}")
print("-" * 67)
print(f"{BOLD}{'ID':<10} {'STATUS':<14} {'TITLE'}{RESET}")
print("-" * 67)

for f in feats:
    fid = f.get("id", "")
    title = f.get("title", "")
    st = f.get("state", "")
    if st == "passing":
        badge = f"{GREEN}[DONE]{RESET}"
    elif st == "active":
        badge = f"{YELLOW}[ACTIVE]{RESET}"
    else:
        badge = f"{BLUE}[TODO]{RESET}"
    print(f"{fid:<10} {badge:<23} {title}")

print(BOLD + "===================================================================" + RESET + "\n")
EOF
