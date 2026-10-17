.PHONY: setup dev check test vcr verify-feature e2e check-arch session-start session-end clean-check status

status:
	@bash scripts/status.sh

MVN := $(shell if [ -f ./mvnw ]; then echo "./mvnw"; else echo "mvn"; fi)

setup:
	@echo "Setting up project environment..."
	@chmod +x init.sh scripts/*.sh 2>/dev/null || true
	@if [ -f pom.xml ]; then $(MVN) dependency:resolve -q; fi
	@echo "Setup complete."

dev:
	@if [ -f pom.xml ]; then $(MVN) spring-boot:run; else echo "pom.xml not yet created."; exit 1; fi

test:
	@if [ -f pom.xml ]; then $(MVN) test; else echo "No tests yet."; fi

check-arch:
	@bash scripts/check-arch.sh

check: test check-arch clean-check
	@echo "All verification checks passed cleanly."

e2e:
	@if [ -f pom.xml ]; then $(MVN) test -Dtest="*IntegrationTest,*E2ETest"; else echo "No E2E suite yet."; fi

vcr:
	@python3 -c '\
import json, sys;\
d = json.load(open("feature_list.json"));\
feats = d.get("features", []);\
active = sum(1 for f in feats if f.get("state") == "active");\
passing = sum(1 for f in feats if f.get("state") == "passing");\
activated = active + passing;\
ratio = (passing / activated) if activated > 0 else 1.0;\
print(f"VCR: {passing}/{activated} = {ratio:.2f} (Active: {active}, Passing: {passing})")\
'

verify-feature:
	@bash scripts/verify-feature.sh $(FEATURE)

session-start:
	@bash scripts/session-trace.sh "session-start" "Starting feature work"

session-end:
	@bash scripts/session-trace.sh "session-end" "Ending session and recording clean checkpoint"

clean-check:
	@bash scripts/clean-state-check.sh .
