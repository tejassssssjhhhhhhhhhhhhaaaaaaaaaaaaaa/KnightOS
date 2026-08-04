# Milestone 2 Engineering Plan: Universal Timeline & Intelligence

**Status:** ARCHITECTURAL DRAFT
**Owner:** Lead Engineer / CTO
**Milestone:** 2 (Universal Timeline & Intelligence)

## 1. Subsystem Definitions

### 1.1 Universal Timeline Engine
*   **Purpose:** The central, immutable record of all professional and personal events across KnightOS.
*   **Responsibilities:** Event ingestion, chronological persistence, multi-domain projection, and historical querying.
*   **Public Interfaces:**
    *   `TimelineService#recordEvent(Event event)`
    *   `TimelineService#getTimeline(TimelineQuery query)`
    *   `TimelineService#getLegacySummary()`
*   **Internal Dependencies:** `EvidenceGraphEngine`, `LocalDatabase`.
*   **Data Ownership:** `KnightOS Core` owns the schema (`TimelineEvent`); domains own the payload content.
*   **Shared Services:** `IdentityService`, `PrivacyVault`.
*   **Risks:** Database performance at high event density; data fragmentation across domains.
*   **Test Strategy:** Stress test ingestion (1000+ events); verify chronological ordering; test domain-specific projections.
*   **Acceptance Criteria:** Events from Career and Health appear in a unified stream, correctly ordered, with no data loss.

### 1.2 Knight Intelligence Orchestrator
*   **Purpose:** The central reasoning hub that routes queries to appropriate models and domain experts.
*   **Responsibilities:** Model routing (SLM vs LLM), context window management, domain synthesis, and cross-domain reasoning.
*   **Public Interfaces:**
    *   `IntelligenceService#query(String prompt, List<Domain> scope)`
    *   `IntelligenceService#analyzeEvidence(List<Evidence> evidence)`
*   **Internal Dependencies:** `EvidenceGraphEngine`, `AuthService`.
*   **Data Ownership:** Does not own data; orchestrates reasoning over domain graphs.
*   **Shared Services:** `PrivacyVault` (for sensitive context handling).
*   **Risks:** Latency in cross-domain synthesis; model "hallucination" in complex simulations.
*   **Test Strategy:** Mock domain responses; verify routing logic (e.g., sensitive data -> local SLM); test context window limits.
*   **Acceptance Criteria:** Successfully synthesizes a recommendation using data from two different domains (e.g., Career + Finance).

### 1.3 Explainability Engine
*   **Purpose:** Ensures every AI-backed insight follows the "Knight Standard" of transparency.
*   **Responsibilities:** Reasoning path tracing, evidence mapping, and qualitative confidence scoring.
*   **Public Interfaces:**
    *   `ExplainabilityEngine#explain(Insight insight)`
*   **Internal Dependencies:** `IntelligenceOrchestrator`, `EvidenceGraphEngine`.
*   **Data Ownership:** Generates transient "Reasoning Paths" linked to Insights.
*   **Shared Services:** `KnightLogger`.
*   **Risks:** Providing overly technical explanations that confuse users; faking "confidence" metrics.
*   **Test Strategy:** Verify that every Insight object contains a valid Reasoning Path; test UI rendering of evidence links.
*   **Acceptance Criteria:** Every Intelligence recommendation includes at least three components: Evidence, Reasoning, and Confidence.

### 1.4 Mission Engine
*   **Purpose:** A unified system for tracking and prioritizing goals, tasks, and habits.
*   **Responsibilities:** Mission lifecycle management (Draft -> Active -> Completed), priority calculation, and North Star alignment tracking.
*   **Public Interfaces:**
    *   `MissionService#createMission(Mission mission)`
    *   `MissionService#getDailyFocus()`
    *   `MissionService#evaluateAlignment(Mission mission)`
*   **Internal Dependencies:** `TimelineEngine`, `IntelligenceOrchestrator`.
*   **Data Ownership:** `KnightOS Core` owns the `Mission` entity.
*   **Shared Services:** `NotificationService`.
*   **Risks:** Overwhelming the user with too many active missions; incorrect priority calculation.
*   **Test Strategy:** Test mission state transitions; verify alignment scores against North Star mock-up.
*   **Acceptance Criteria:** Missions from different domains appear in a unified "Daily Focus" view, sorted by true priority.

### 1.5 Conflict Resolver
*   **Purpose:** Manages overlapping or contradictory priorities between different domains.
*   **Responsibilities:** Detecting schedule/energy conflicts, proposing mission re-prioritization, and mediating domain competition.
*   **Public Interfaces:**
    *   `ConflictResolver#analyzeConflict(List<Mission> activeMissions)`
    *   `ConflictResolver#proposeResolution(Conflict conflict)`
*   **Internal Dependencies:** `MissionEngine`, `TimelineEngine`.
*   **Data Ownership:** Generates transient `Conflict` and `Resolution` entities.
*   **Shared Services:** `IntelligenceOrchestrator`.
*   **Risks:** Logic errors that de-prioritize critical missions; user fatigue from too many "Resolution" prompts.
*   **Test Strategy:** Simulate energy/time conflicts (e.g., 20 hours of work + 10 hours of training in one day).
*   **Acceptance Criteria:** Identifies a conflict between a Career Mission and a Health Mission and proposes a valid trade-off.

---

## 2. Implementation Work Packages

| ID | Work Package | Team | Dependencies | Complexity | Affected Files |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **M2-WP1** | **Timeline Engine & Repository** | Platform | CORE-04 | M | `lib/core/services/timeline_service.dart`, `lib/core/repositories/timeline_repository_impl.dart` |
| **M2-WP2** | **Mission Engine (Base)** | Platform | M2-WP1 | M | `lib/core/services/mission_service.dart`, `lib/core/domain/entities/mission.dart` |
| **M2-WP3** | **Intelligence Orchestrator (Routing)** | Intelligence | CORE-02 | L | `lib/core/services/intelligence_service.dart`, `lib/core/intelligence/model_router.dart` |
| **M2-WP4** | **Explainability Framework** | Intelligence | M2-WP3 | M | `lib/core/intelligence/explainability_engine.dart`, `lib/core/domain/entities/insight.dart` |
| **M2-WP5** | **Conflict Resolution Logic** | Intelligence | M2-WP2, M2-WP3 | L | `lib/core/intelligence/conflict_resolver.dart` |

---

## 3. Parallel vs. Critical Path

*   **Critical Path:** **M2-WP1 (Timeline)** -> **M2-WP2 (Mission)** -> **M2-WP3 (Intelligence)** -> **M2-WP4 (Explainability)**.
*   **Parallel Work:** **M2-WP5 (Conflict Resolver)** can be developed in parallel once M2-WP2 and M2-WP3 basic interfaces are defined.

---

## 4. Architectural Sanity Check

*   **KnightOS Core Constitution:** **PASS**. Milestone 2 builds shared capabilities (`Timeline`, `Mission`) in the Core rather than duplicating them in domains.
*   **Engineering Constitution:** **PASS**. The `Explainability Engine` directly satisfies the "Explainability Before Prediction" principle.
*   **Privacy Constitution:** **PASS**. The `Intelligence Orchestrator` is designed to route Level 4 data to local SLMs, satisfying the Privacy Vault constraints.
*   **Shared Service Registry:** **PASS**. All new services are correctly assigned to their owners in the Registry.

---

## 5. Safest Implementation Sequence

1.  **WP1 (Timeline):** Establish the storage foundation for all history.
2.  **WP2 (Mission):** Establish the storage foundation for all action.
3.  **WP3 (Intelligence):** Build the reasoning brain that sits on top of the data.
4.  **WP4 (Explainability):** Wrap the intelligence output to ensure transparency.
5.  **WP5 (Conflict Resolver):** Add advanced reasoning logic for multi-domain orchestration.

**Recommendation:** Proceed with WP1 after approval.
