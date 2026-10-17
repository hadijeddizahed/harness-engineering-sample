# Sprint Contract

## Feature Under Contract
- **Feature ID**: [e.g. FEAT-001]
- **Title**: [Feature Title]
- **Target Component**: [e.g. TaskController / TaskService]

## Scope Boundaries
- **In Scope**:
  - [Explicit functionality to add]
- **Explicitly Excluded**:
  - [Out of scope items to avoid drift]

## Verification Criteria (Definition of Done)
1. Layer 1 (Unit): Unit tests compile and pass.
2. Layer 2 (Integration): MockMvc endpoint test verifies expected HTTP status and JSON payload.
3. Layer 3 (Architecture): `make check-arch` confirms zero layer boundary violations.

## Sign-off
- **Agent Clock-in Status**: READY
- **Baseline Hash**: [Current Git Commit]
