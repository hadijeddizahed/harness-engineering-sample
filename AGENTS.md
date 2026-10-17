# AGENTS.md

This system is a Spring Boot REST application for task management built with harness engineering principles.
It provides task creation, retrieval, status transition, and querying with automated multi-layer verification.

## Verification Commands
- Full verification: `make check` (must exit 0 before every commit)
- Fast test suite: `make test`
- Architecture check: `make check-arch`
- Clean state check: `make clean-check`
- Feature verification: `make verify-feature FEATURE=FEAT-001`

## State Files
State lives in tracked files, never only in session context:
- `PROGRESS.md`: Current commit, verification status, active work, and next steps.
- `feature_list.json`: Feature backlog, layers, and verification evidence.
- `docs/DECISIONS.md`: Log of architectural decisions and their rationale.
- `docs/quality-document.md`: Module health scores (A/B/C/D per dimension).

## Hard Constraints
- Controllers MUST NOT call repositories directly (# why: maintain domain encapsulation).
- Controllers MUST return DTO records, not JPA entities (# why: prevent schema leaks and lazy-loading faults).
- Services MUST NOT import servlet or HTTP classes (# source: ADR-001; core logic must stay protocol-agnostic).
- WIP=1: Only one feature may have state=active at a time (# why: prevent scope fragmentation).

## Topic Documents
- Architecture & Boundaries: [Architecture Spec](docs/ARCHITECTURE.md)
- Decisions & History: [ADR Log](docs/DECISIONS.md)
- Module Constraints: [Code Constraints](src/ARCHITECTURE.md)

## Tools and MCP Capabilities
- Scoped permissions defined in `.claude/settings.json`.
- Allowed tools: `make`, `mvn`, `git status`, `git diff`, `git log`.
- Destructive commands (`rm -rf`, `git push --force`) are strictly prohibited.

## Clock-In Routine
Before touching any code:
1. Read `PROGRESS.md` to identify current baseline and active feature.
2. Run `make check` to confirm a green starting state.

## Clock-Out Routine
Before closing session or committing:
1. Run `make check` and `make clean-check` (confirms build, tests pass, no debug artifacts).
2. Update `feature_list.json` with status and verification evidence.
3. Update `PROGRESS.md` Current State block (commit hash + test status) and Next Steps.
4. Update `docs/quality-document.md` with module health score (A/B/C/D per dimension).
5. If running low on context, do NOT rush to finish or skip verification — stop, update `PROGRESS.md`, and commit a clean checkpoint.

## Commit Rules
- Commit atomicity rule: One logical operation per commit; the repo must be in a consistent state after every commit.
- Documentation staleness rule: Update docs in the same commit as the code change — no stale documentation.
- Commit message guidance: Write commit messages that explain WHY the change was made, not just what changed.

## Feature List & Definition of Done
- State machine: `planned` -> `active` -> `passing`.
- Feature granularity: exactly one session per feature.
- Pass-state gating: A feature cannot transition to `passing` without recorded verification evidence.
- Definition of Done: All 3 verification layers pass, evidence is recorded in `feature_list.json`, and clean-check exits 0.

## Three-Layer Verification Model
- Layer 1 (Unit): Fast compilation and unit tests (`mvn test-compile`).
- Layer 2 (Integration): MockMvc HTTP contract tests and runtime signals (app startup, HTTP status).
- Layer 3 (Architecture & E2E): `make check-arch` and `make e2e`.
- Layer ordering rule: Do not skip layers; verify Layer 1 before Layer 2 and Layer 3.
- E2E requirement: Layer 3 (e2e) is required when changes cross component or domain boundaries.

## Architecture Boundaries & Promotion Principle
- Layer dependencies are enforced by `make check-arch` reading `.harness/arch-rules.json`.
- Review-to-automation promotion principle: Every new error category caught in code review becomes a rule in `.harness/arch-rules.json`.

## Observability & Clean-State Protocol
- Before starting a feature, draft a sprint contract from `templates/sprint-contract.md`.
- Runtime signal collection: `make session-start` and `make session-end` log trace events via `scripts/session-trace.sh`.
- Score each completed sprint against `templates/evaluator-rubric.md` — every dimension must reach B or above.
- Dual-mode cleanup strategy: immediate cleanup at every session end + periodic weekly full-system sweep for structural drift.
