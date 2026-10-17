# Evaluator Scoring Rubric

All completed features must achieve Grade B or above across all four dimensions.

| Dimension | Grade A | Grade B (Passing Threshold) | Grade C (Failing) | Grade D (Reject) |
|---|---|---|---|---|
| **1. Functional Correctness** | All edge cases covered, zero regressions. | Primary user-visible behavior works as specified. | Minor bugs or partial implementation. | Fails primary acceptance test. |
| **2. Architecture Compliance** | Clean separation of Controller/Service/DTO/Entity. | Passes `make check-arch` with zero violations. | Bypasses service layer or exposes entities. | Breaks architectural boundaries. |
| **3. Test Coverage & Signals** | Unit and MockMvc integration tests present. | Verifies status codes and response bodies. | Only tests happy path, no assertion on error states. | No tests added or tests ignored. |
| **4. Verification Evidence** | Structured output and timestamp recorded in feature_list.json. | Evidence recorded in feature_list.json and PROGRESS.md. | Claimed done without terminal output evidence. | Unverified. |
