# Implementation Plan - Milestone 4 Sprint 3: Strategic Career Operations

This sprint transforms Career Compass into a future-oriented operating system by implementing the **North Star** (Strategy) and the **Career Mission Center** (Tactics).

## 1. Architectural Strategy: The Intelligence Loop

We will implement a closed-loop intelligence system:
1.  **North Star (WP5)**: Defines the user's high-level professional destination.
2.  **Gap Analysis**: Knight Intelligence compares current **Skill DNA** (WP3) and **Achievement Vault** (WP4) against the North Star.
3.  **Mission Generation (WP6)**: tactical missions are automatically proposed to bridge identified skill or evidence gaps.
4.  **Evidence Projection**: Completed missions generate new **Achievements** and **Timeline** events, updating the DNA and closing the loop.

## 2. Work Packages

### [M4-WP5] North Star (Strategic Intelligence)
- **Purpose**: The central reasoning layer for career direction.
- **Features**:
    - **Vision Persistence**: Store long-term goals (e.g., "Principal Engineer," "Founder") as high-importance memories in `BookCategory.career`.
    - **Alignment Engine**: Connects the North Star to life values (Identity) and financial goals (Finance).
    - **Strategic Insight**: A specialized North Star dashboard section that answers "Where am I going?" and "How far am I from the target?".
- **UI**: `NorthStarScreen` for goal setting and strategic visualization.

### [M4-WP6] Career Mission Center (Tactical Execution)
- **Purpose**: The execution engine for professional growth.
- **Features**:
    - **Automated Mission Proposals**: Based on North Star gap analysis (e.g., "Missing 'System Design' evidence for Principal path").
    - **Mission Lifecycle**: Integrated with the platform `MissionService` (Draft → Active → Completed).
    - **Resource Linking**: Missions link to learning resources, certificates, or projects.
    - **Progress Tracking**: Real-time progress updates derived from linked Timeline events and Evidence ingestion.
- **UI**: `MissionCenterScreen` featuring a "Mission Command" interface.

## 3. Proposed Changes

### [KnightOS Core]
- **[MODIFY]** `MissionService`: Enhance `_handleEvidenceImported` to contextually evaluate missions against the current North Star.
- **[MODIFY]** `IntelligenceOrchestrator`: Add a `CareerExpert` module that performs the Gap Analysis between DNA and North Star.

### [Career Compass Feature]
- **[NEW]** `NorthStarController`: Manages the strategic vision state.
- **[NEW]** `CareerMissionController`: Manages career-specific missions and their automation logic.
- **[NEW]** `NorthStarScreen`: Interactive goal-setting and visualization.
- **[NEW]** `MissionCenterScreen`: Tactical mission management.

## 4. Performance & Explainability

- **Explainability**: Every suggested mission will include an `ExplainableInsightCard` explaining *why* it helps reach the North Star.
- **Data Scale**: Efficiently indexing missions and goals in `Drift` to ensure rapid retrieval even with hundreds of historical missions.

## 5. Verification Plan

### Automated Tests
- **Gap Analysis Logic**: Unit tests verifying that missing skills trigger the correct mission proposals.
- **Mission Lifecycle**: Integration tests ensuring mission completion updates the `AchievementVault`.

### Manual Verification
- Define a "North Star" and verify that "Suggested Missions" update contextually.
- Complete a mission and verify the "Progress to North Star" metric increases.
