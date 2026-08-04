# KnightOS Universal Data Architecture

**Status:** PERMANENT GOVERNANCE DOCUMENT
**Owner:** CTO

## 1. Universal Entity Philosophy
All data in KnightOS is represented as an **Entity** within a unified graph. Entities are not isolated records; they are interconnected nodes defined by their relationships to **Evidence**.

## 2. Shared Entity Ownership (KnightOS Core)
Core owns the foundational schemas that enable cross-module intelligence:
*   **Identity:** Unified user profile, credentials, and preferences.
*   **Timeline Event:** Standardized chronological record (Timestamp, Type, Domain, Payload).
*   **Evidence Node:** The base unit of truth (Source, Verification Method, Timestamp, Confidence).
*   **Mission:** Shared goal-tracking unit (Task, Habit, Milestone).
*   **Connection:** The relationship between any two entities (Ownership, Dependency, Correlation).

## 3. Domain Entity Ownership
Modules own specialized schemas:
*   **Career:** Skill, Project, Certification, Organization, Job, Achievement.
*   **Finance:** Transaction, Account, Budget, Investment, Liability.
*   **Health:** Metric (Heart rate, Sleep), Workout, Vitals, Medical Record.
*   **Travel:** Itinerary, Booking, Destination, Logistics.

## 4. Evidence Graph Standards
*   **Immutability:** Once evidence is verified, it cannot be edited—only superseded by newer evidence.
*   **Attribution:** Every node must link to at least one Evidence source.
*   **Graph Traversability:** Any domain must be able to query the graph for related nodes in other domains (subject to privacy rules).

## 5. Timeline Standards
*   **Linearity:** All events are ordered by "Event Time" (actual occurrence) and "System Time" (when recorded).
*   **Projection:** Domains must provide a "Summary Projection" for the Universal Timeline (e.g., Career returns "Promoted to Senior Eng" rather than "Updated Job Record #402").

## 6. Identity Model
*   **Single Source of Truth:** One profile across all devices and domains.
*   **Privacy-Preserving:** Identity is decoupled from sensitive data in the underlying storage layers.

## 7. Versioning Strategy
*   **Semantic Schema Versioning:** Breaking changes to shared entities require a major version bump and a migration script.
*   **Backward Compatibility:** Core must support the N-1 schema version for at least six months.

## 8. Data Lifecycle
1.  **Ingestion:** Raw data from integrations or manual entry.
2.  **Verification:** Classification as "Claim" or "Evidence."
3.  **Active:** Available for reasoning and display.
4.  **Archival:** Compressed, read-only state for long-term history.
5.  **Deletion:** Cryptographic erasure at the user's request.

## 9. Synchronization Strategy
*   **Local-First:** All writes occur locally first.
*   **Conflict Resolution:** Last-Write-Wins (LWW) with deterministic tie-breaking based on cryptographic hash.
*   **Delta Sync:** Only changes (diffs) are transmitted to reduce bandwidth.

## 10. Import/Export Philosophy
*   **No Vendor Lock-in:** Users can export their entire Evidence Graph in a standardized, machine-readable format (JSON-LD).
*   **Lossless Import:** KnightOS must be able to rebuild a user's profile from an export file.
