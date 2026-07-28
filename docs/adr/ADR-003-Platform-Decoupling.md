# ADR-003: Platform/Internal Layer Separation

## Status
Accepted

## Context
As an enterprise-grade Operating System, Knight OS must be maintainable for 10+ years. Direct dependencies on specific libraries (like Drift or SQLite) in feature modules make it difficult to upgrade, replace, or test infrastructure.

## Decision
We will strictly separate the `core` into `platform` (Public Contracts) and `internal` (Implementation Details). 
- **Platform**: Stable interfaces (`StorageEngine`, `KnightRepository`) that features depend on.
- **Internal**: Concrete implementations (`DriftStorageEngine`, `NativeDatabase`).

## Rationale
1. **Maintainability**: Internal implementation can be completely rewritten without touching a single feature module.
2. **Testability**: Features can be unit-tested using pure Dart mocks of the platform interfaces.
3. **Architecture Integrity**: Prevents "leaky abstractions" where feature-specific SQL logic bleeds into core services.

## Alternatives Considered
- **Single Core Package**: Simpler initial setup but high long-term technical debt.

## Trade-offs
- **Boilerplate**: Requires mapping domain entities to internal database models (DAOs).

## Future Impact
Allows Knight OS to pivot to different storage technologies (e.g., Cloud-first or NoSQL) if industry standards change over the next decade.
