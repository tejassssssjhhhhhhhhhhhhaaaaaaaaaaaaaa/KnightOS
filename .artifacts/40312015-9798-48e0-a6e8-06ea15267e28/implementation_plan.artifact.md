# Implementation Plan - Phase 7.5: Knowledge Confidence & Verification Framework

This phase transitions KnightOS into an explainable, transparent intelligence system by implementing a complete knowledge lifecycle and a proactive verification loop, centered on the **Single Source of Truth (SSoT)** principle.

## User Review Required

> [!IMPORTANT]
> **Single Source of Truth**: We are finalizing the architecture so that every real-world fact (e.g., your Home, Salary, or Sleep Goal) exists exactly once in the `MemoryTable`. All modules (Health, Finance, Planner) will reference these canonical memories.
>
> **Knowledge Lifecycle**: Every memory will have a strictly managed state: `Observed`, `Inferred`, `User Confirmed`, `User Corrected`, or `Deprecated`.

## Proposed Changes

### [1. Canonical Memory & Lifecycle]

#### [MODIFY] [memory_metadata.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/domain/memory_metadata.dart)
- Define `KnowledgeState` enum: `observed`, `inferred`, `userConfirmed`, `userCorrected`, `deprecated`.
- Add `knowledgeState` to `MemoryMetadata`.
- Add `explanation` (String?) for explainable reasoning.

#### [MODIFY] [memory_engine.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/memory_engine.dart)
- Harden the SSoT implementation:
    - Ensure `save()` automatically deprecates older versions of a fact chain based on `memoryId`.
    - Implement a "Promotion" pipeline where confirmed inferences become high-trust anchors.

### [2. Observation & Pattern Detection]

#### [MODIFY] [observation_engine.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/observation_engine.dart)
- Implement real **Socratic Inferences**:
    - **Home/Work Detection**: Scans `TimelineEvent` records to generate `inferred` memories.
    - **Routine Detection**: Identifies recurring patterns (e.g., "Morning Run" every Mon/Wed).
- Every inference generated here is marked `verified: false` and includes raw evidence in the `explanation`.

### [3. Proactive Verification]

#### [NEW] [verification_engine.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/verification_engine.dart)
- Scans for important `inferred` memories that lack owner confirmation.
- Generates "Verification Missions" that the `DiscoveryEngine` prioritizes above all else.

#### [NEW] [verification_bubble.dart](file:///C:/Users/tejas/knight_os/lib/features/knight/presentation/widgets/verification_bubble.dart)
- High-fidelity chat component showing:
    - Confidence gauge (Horizon visual style).
    - "Why Knight thinks this" (Explainability).
    - Actions: `Correct`, `Edit`, `Wrong`, `Ask Later`.

### [4. Persistence Layer Sync]

#### [MODIFY] [memories.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/tables/memories.dart)
- Add `knowledge_state` (Text) and `explanation` (Text) columns.
- Re-run `build_runner`.

### [5. Architecture Freeze]

#### [MODIFY] [ARCHITECTURE.md](file:///C:/Users/tejas/knight_os/ARCHITECTURE.md)
- Formalize the SSoT Principle.
- Document the Promotion/Correction logic.
- Finalize the core intelligence specification.

## Verification Plan

### Automated Tests
- **SSoT Propagation Test**: Update a "Home" memory and verify that all queries for that `memoryId` return the new confirmed version across different simulated modules.
- **Explainability Audit**: Verify that inferred memories always contain non-null `explanation` strings.

### Manual Verification
- **Verification Loop**: Confirm a "Work" inference in the Knight Orb and verify that the Discovery Dashboard immediately shows the "Career" constellation as glowing/complete.
- **Correction Audit**: Edit an inference (e.g., change "Work" to "Coworking Space") and verify the previous assumption is correctly `deprecated`.
