# PROGRESS.md

## Current State
- **Last commit**: `4f08ead`
- **Verification status**: `make check: passing (FEAT-001 verified)`
- **Active feature**: None (FEAT-001 passing, ready for FEAT-002)

## In Progress
- None (WIP=0, clean handoff)

## Next Steps
1. Activate `FEAT-002` (Create and retrieve tasks via REST).
2. Add Spring Data JPA + H2 in-memory dependencies to `pom.xml`.
3. Implement `Task` entity, `TaskRepository`, `TaskService`, and `TaskController`.
4. Add MockMvc integration tests and run `make verify-feature FEATURE=FEAT-002`.
5. Clock out `FEAT-002`.

## Blockers
- None.
