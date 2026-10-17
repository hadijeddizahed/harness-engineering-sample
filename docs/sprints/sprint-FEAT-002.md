# Sprint Contract: FEAT-002

## Feature Under Contract
- **Feature ID**: FEAT-002
- **Title**: Create and retrieve tasks via REST
- **Target Components**: Task, TaskStatus, TaskRepository, TaskService, TaskController, TaskRequestDto, TaskResponseDto

## Scope Boundaries
- **In Scope**:
  - Add `spring-boot-starter-data-jpa` and `h2` database dependencies in `pom.xml`.
  - `TaskStatus` enum (`PENDING`, `IN_PROGRESS`, `COMPLETED`).
  - `Task` JPA entity with fields (`id`, `title`, `description`, `status`, `createdAt`).
  - `TaskRepository` interface extending `JpaRepository<Task, Long>`.
  - DTO records: `TaskCreateRequest` (validation annotations `@NotBlank`) and `TaskResponse`.
  - `TaskService` handling entity conversion and domain operations.
  - `TaskController` exposing:
    - `POST /api/tasks` -> 201 Created with `TaskResponse`
    - `GET /api/tasks/{id}` -> 200 OK with `TaskResponse` (or 404 Not Found if missing).
  - MockMvc integration tests for creation and retrieval.
- **Explicitly Excluded**:
  - Lifecycle state transition rules (deferred to FEAT-003).
  - Query filtering and search (deferred to FEAT-004).

## Architectural Boundary Invariants
- Controller MUST NOT inject `TaskRepository` directly; MUST use `TaskService`.
- Controller MUST NOT return JPA `Task` entity; MUST return `TaskResponse` DTO record.
- `TaskService` MUST NOT import `jakarta.servlet.*` or `org.springframework.web.*`.

## Verification Criteria (Definition of Done)
1. Layer 1 (Unit): `mvn test-compile` passes.
2. Layer 2 (Integration): `TaskControllerTest` passes all assertions.
3. Layer 3 (Architecture): `make check-arch` passes with 0 violations.
4. Clean state check: `make clean-check` exits 0.

## Sign-off
- **Agent Clock-in Status**: READY
- **Baseline Hash**: `215628a`
