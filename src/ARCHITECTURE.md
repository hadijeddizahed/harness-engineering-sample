# Source Architecture & Module Constraints

This module contains the Spring Boot application source code.

## Package Layout
- `com.example.harness.controller`: REST endpoints only.
- `com.example.harness.service`: Domain logic, orchestrations, and validations.
- `com.example.harness.repository`: Spring Data JPA interfaces.
- `com.example.harness.model`: JPA entities (`Task`).
- `com.example.harness.dto`: Request/Response immutable record classes.

## Strict Module Constraints
- Any direct interaction between `controller` and `repository` is strictly forbidden.
- Cross-layer exceptions must be mapped via `@RestControllerAdvice` in the controller package.
