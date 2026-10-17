# Architectural Decisions (DECISIONS.md)

This file tracks architectural decisions to prevent losing context across agent sessions.
See also detailed logs in [docs/DECISIONS.md](docs/DECISIONS.md).

## ADR-001: Technology Stack and Verification Model
- **Date**: 2026-10-17
- **Context**: Need a minimal, deterministic Spring Boot project to practice Harness Engineering.
- **Decision**: Use Java 24, Spring Boot 3.4 (with Spring Web, Spring Data JPA, H2 database, and JUnit 5 / MockMvc).
- **Consequences**:
  - Zero external database dependencies required.
  - Fast test runs (< 5s) enabling tight agent feedback loops.
  - Strict layered boundary enforced by `scripts/check-arch.sh`.

## ADR-002: Harness Architecture and State Management
- **Date**: 2026-10-17
- **Context**: Coding agents require durable files for continuity across sessions.
- **Decision**: Maintain state in `feature_list.json` and `PROGRESS.md`.
- **Consequences**:
  - Context loss between agent sessions is mitigated.
  - Agent cannot declare victory without verified evidence.
