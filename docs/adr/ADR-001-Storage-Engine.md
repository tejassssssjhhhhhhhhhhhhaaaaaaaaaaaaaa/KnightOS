# ADR-001: Storage Engine Selection for Knight OS

## Status
Proposed

## Context
Knight OS requires a robust, local-first storage foundation to manage user data across multiple domains (Health, Finance, Work, etc.). The existing solution uses raw JSON files, which lacks transactions, indexing, and scalability.

We initially considered **Isar**, but encountered dependency conflicts with the project's pre-release version of **Riverpod (3.3.2)** due to shared analyzer version constraints.

## Decision
We will use **Drift (SQLite)** as the primary storage engine for Knight OS.

## Rationale
1. **ACID Compliance**: SQLite provides industry-standard atomicity and durability, ensuring no data loss during crashes or failed writes.
2. **Compatibility**: Drift has no version conflicts with Riverpod 3.x, unlike Isar.
3. **Relational Power**: As Knight OS grows, complex relationships between data entities (e.g., linking a Journal entry to a Fitness activity) will be easier to manage in a relational database.
4. **Migration Maturity**: Drift provides advanced tools for schema versioning and safe migrations.
5. **Selective Encryption**: SQLite supports `sqlcipher` for module-level encryption (e.g., Finance).

## Consequences
- Requires a build step (`build_runner`) for code generation.
- Higher initial setup complexity compared to raw JSON.
- Provides a stable, enterprise-grade foundation for all future features.
