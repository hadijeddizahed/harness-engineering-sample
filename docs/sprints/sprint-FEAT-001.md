# Sprint Contract: FEAT-001

## Feature Under Contract
- **Feature ID**: FEAT-001
- **Title**: Spring Boot 3 application setup and health endpoint
- **Target Component**: TaskTrackerApplication, HealthController

## Scope Boundaries
- **In Scope**:
  - `pom.xml` with Spring Boot 3.4.x, Java 24, Spring Web, Spring Test.
  - `TaskTrackerApplication.java` entrypoint.
  - `HealthController.java` with `GET /api/health` returning `{"status": "UP"}`.
  - `HealthControllerTest.java` with MockMvc verifying HTTP 200 and JSON contract.
- **Explicitly Excluded**:
  - Database schema and Task entities (deferred to FEAT-002).
  - Task endpoints (deferred to FEAT-002).

## Verification Criteria (Definition of Done)
1. Layer 1 (Unit): `mvn test-compile` passes without warnings.
2. Layer 2 (Integration): `HealthControllerTest` passes cleanly.
3. Layer 3 (Architecture): `make check-arch` confirms zero violations.
4. Clean State: `make clean-check` exits 0.

## Sign-off
- **Agent Clock-in Status**: READY
- **Baseline Hash**: `48294e7`
