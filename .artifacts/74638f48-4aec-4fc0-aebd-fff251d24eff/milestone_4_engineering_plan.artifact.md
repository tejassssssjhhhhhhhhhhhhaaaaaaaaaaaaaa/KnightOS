# Milestone 4 Engineering Plan: Career Compass MVP

This plan outlines the implementation of **Career Compass**, the first production-ready domain in KnightOS. It leverages the completed Core and Connectivity layers to build an evidence-backed professional operating system.

## 1. Work Package Definitions

### WP1: Career Dashboard (Command Center)
- **Purpose**: Unified entry point for professional intelligence.
- **Responsibilities**:
    - Visual aggregation of Skill DNA, Mission progress, and Timeline milestones.
    - Proactive "Next Action" recommendations from the AI Coach.
- **Dependencies**: WP3, WP6, WP8.
- **Shared Services**: `IdentityService`, `MissionEngine`, `IntelligenceOrchestrator`.
- **Acceptance Criteria**: User can view a summary of their top 3 skills, active career missions, and their current "North Star."
- **Risks**: UI clutter due to density of cross-domain data.
- **Complexity**: Medium.
- **Team ownership**: Frontend / UI.

### WP2: Career Timeline (The Legacy)
- **Purpose**: A professional chronological history filtered from the Universal Timeline.
- **Responsibilities**:
    - Project Career-specific events (e.g., job changes, projects, certs).
    - Milestone visualization with evidence linking.
- **Dependencies**: WP4, `TimelineEngine`.
- **Shared Services**: `TimelineService`, `ExplainabilityEngine`.
- **Acceptance Criteria**: A dedicated view showing only career events, with each event linking back to its source evidence in the Vault.
- **Risks**: Timeline noise if granular work sessions are not grouped.
- **Complexity**: Low.
- **Team ownership**: Domain Logic.

### WP3: Career DNA (Skills)
- **Purpose**: Dynamic mapping and scoring of professional competency.
- **Responsibilities**:
    - Maintain the Skill Graph in the `EvidenceGraph`.
    - Calculate proficiency scores based on evidence density and age (decay).
- **Dependencies**: WP4, `EvidenceGraph`.
- **Shared Services**: `EvidenceService`, `IntelligenceOrchestrator`.
- **Acceptance Criteria**: A visual Skill DNA map where each skill shows its verification status and supporting evidence.
- **Risks**: Subjectivity in skill scoring without robust heuristics.
- **Complexity**: High.
- **Team ownership**: Intelligence / Data.

### WP4: Achievement Vault (Evidence-Backed)
- **Purpose**: High-security repository for professional truth.
- **Responsibilities**:
    - Specialized ingestion for career artifacts (Resumes, Offer Letters, Certificates).
    - Metadata extraction and classification for career-domain evidence.
- **Dependencies**: `PrivacyVault`, `EvidenceService`.
- **Shared Services**: `EvidenceCenter`.
- **Acceptance Criteria**: User can upload a certificate and have it automatically classified as 'Career Evidence' with metadata extracted.
- **Risks**: OCR/Parsing accuracy for non-standard documents.
- **Complexity**: Medium.
- **Team ownership**: Core / Connectivity.

### WP5: North Star & Career Vision
- **Purpose**: Strategic destination and value alignment.
- **Responsibilities**:
    - Define and persist long-term career goals.
    - Align professional vision with Health and Finance constraints.
- **Dependencies**: `IdentityService`.
- **Shared Services**: `IdentityEngine`, `MissionService`.
- **Acceptance Criteria**: Persistence of "Vision" memories in the `MemoryEngine` with explicit links to life values.
- **Risks**: Goal fragmentation if not properly integrated with the `MissionEngine`.
- **Complexity**: Low.
- **Team ownership**: Identity / UX.

### WP6: Career Mission Center
- **Purpose**: Tactical execution engine for professional growth.
- **Responsibilities**:
    - Decompose the North Star into actionable `Mission` items.
    - Automated mission creation based on evidence gaps (e.g., "Learn Python" if missing evidence).
- **Dependencies**: WP5, `MissionEngine`.
- **Shared Services**: `MissionService`, `IntelligenceOrchestrator`.
- **Acceptance Criteria**: User can start, track, and complete Career Missions that update the Skill DNA upon success.
- **Risks**: User fatigue from too many suggested missions.
- **Complexity**: Medium.
- **Team ownership**: Logic / Intelligence.

### WP7: Career Analytics
- **Purpose**: Quantitative measurement of professional growth.
- **Responsibilities**:
    - Track skill growth trends and mission completion rates.
    - correlate work habits (from `WorkTracker`) with achievement frequency.
- **Dependencies**: WP3, WP6.
- **Shared Services**: `IntelligenceOrchestrator`.
- **Acceptance Criteria**: Interactive charts showing skill proficiency over time and productivity correlations.
- **Risks**: Misleading correlations between time spent and actual output.
- **Complexity**: Medium.
- **Team ownership**: Analytics.

### WP8: Career AI Coach
- **Purpose**: Proactive, explainable professional guidance.
- **Responsibilities**:
    - Provide reasoning-backed advice (e.g., "Update your Java skill because it hasn't been used in 6 months").
    - Conversational interface for career strategy.
- **Dependencies**: WP1-7, `ExplainabilityEngine`.
- **Shared Services**: `IntelligenceOrchestrator`, `ExplainabilityEngine`.
- **Acceptance Criteria**: A chat interface where every piece of advice includes a "Reasoning Trace" back to verified Evidence.
- **Risks**: Hallucinations in advice if not strictly grounded in the Evidence Graph.
- **Complexity**: High.
- **Team ownership**: Intelligence / UX.

---

## 2. Shared Infrastructure Reuse

| Shared Service | Reuse Pattern |
| :--- | :--- |
| **IdentityService** | Core user persona and Vision persistence. |
| **PrivacyVault** | Encryption for sensitive career documents (Contracts, Payslips). |
| **Evidence Graph** | Mapping Skills (Nodes) to Evidence (Edges). |
| **Timeline Engine** | Event sourcing for career milestones. |
| **Mission Engine** | Tactical lifecycle management for career tasks. |
| **Explainability Engine** | Generating "Reasoning Traces" for career advice. |
| **IntegrationHub** | External data flow (GitHub, LinkedIn, Google Calendar). |

---

## 3. Recommended Implementation Order

1.  **WP4: Achievement Vault** (The Data Foundation)
2.  **WP3: Career DNA** (Mapping Data to Intelligence)
3.  **WP2: Career Timeline** (Historical Visualization)
4.  **WP5: North Star & Career Vision** (Goal Setting)
5.  **WP6: Career Mission Center** (Tactical Execution)
6.  **WP1: Career Dashboard** (UI Entry Point)
7.  **WP7: Career Analytics** (Progress Monitoring)
8.  **WP8: Career AI Coach** (The Brain)

---

## 4. Risks & Mitigations

- **Data Privacy**: Career data is highly sensitive. **Mitigation**: Strictly use `PrivacyVault` for all WP4 ingestion.
- **Intelligence Subjectivity**: "Skill Scores" can be arbitrary. **Mitigation**: Use evidence density and metadata (e.g., GitHub commit volume, Cert authority) as primary weights.
- **Cross-Domain Conflicts**: Career missions might conflict with Health (e.g., long hours). **Mitigation**: Use `ConflictResolver` (M2) to highlight domain overlaps.
