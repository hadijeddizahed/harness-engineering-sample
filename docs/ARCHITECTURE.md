# Architecture & Technical Boundaries

## System Overview
The Task Tracker is a lightweight Spring Boot 3 REST application designed to illustrate strict harness boundaries and test verification for AI coding agents.

## Layer Boundaries

```
[ HTTP Controller ]  --> Handles JSON serialization and HTTP routing
        │
        ▼
[ Service Layer ]    --> Business logic, state validation, transaction orchestration
        │
        ▼
[ Data Repository ]  --> Spring Data JPA, H2 In-Memory persistence
```

### Invariants & Rules
1. **Controller isolation**: Controllers MUST NOT access Repositories directly. They must delegate through the Service layer.
2. **DTO isolation**: Entities must not be leaked in API requests or responses. Use typed DTO records (`TaskRequestDto`, `TaskResponseDto`).
3. **Protocol isolation**: Service classes MUST NOT import `jakarta.servlet.*` or `org.springframework.web.*`.
4. **Architectural Verification**: `make check-arch` validates these boundaries via static analysis.

## Verification Hierarchy
- **Layer 1 (Fast Feedback)**: Unit tests and clean compilation (`mvn test-compile`).
- **Layer 2 (Feature/API Verification)**: Spring Boot `MockMvc` integration tests verifying real HTTP requests.
- **Layer 3 (System & Architecture)**: Architectural linting (`make check-arch`) and clean state validation (`make clean-check`).
