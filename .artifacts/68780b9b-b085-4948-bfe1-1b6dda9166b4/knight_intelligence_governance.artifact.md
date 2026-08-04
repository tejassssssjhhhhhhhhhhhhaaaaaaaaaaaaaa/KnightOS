# Knight Intelligence Governance

**Status:** PERMANENT GOVERNANCE DOCUMENT
**Owner:** CTO

## 1. AI Architecture
KnightOS uses a tiered intelligence model:
*   **The Orchestrator (Core):** Routes requests to specialized domain experts and handles cross-domain synthesis.
*   **Domain Experts:** Specialized logic/models for Career, Finance, Health, and Travel.
*   **Small Language Models (SLM):** On-device models for privacy-sensitive and offline reasoning.
*   **Large Language Models (LLM):** Cloud-based models for high-complexity synthesis and creative tasks.

## 2. Model Routing
*   **Privacy-First:** Requests involving "Highly Sensitive" data must be routed to local SLMs.
*   **Cost/Energy Awareness:** Simple tasks (e.g., "Extract date from receipt") use optimized, small-scale models.

## 3. Memory Hierarchy
*   **Transient Memory:** Per-session context, discarded after the task.
*   **Contextual Memory:** Mid-term memory of recent user activity and goals.
*   **Legacy Memory:** The long-term Evidence Graph and Life Timeline.

## 4. Explainability (The "Knight Standard")
No significant recommendation or insight may be presented without an underlying **Reasoning Path**:
*   **Evidence:** The specific graph nodes used for the insight.
*   **Logic:** The "Chain of Thought" or rules applied.
*   **Confidence:** A qualitative assessment (High, Medium, Low) based on evidence density.

## 5. Hallucination Prevention
*   **Grounding:** All generative outputs must be grounded in the Evidence Graph.
*   **Verification Gate:** AI-generated "claims" are marked as "Unverified" until the user or a system integration confirms them.
*   **Evidence Scoping:** If no evidence exists for a query, the AI must state "Insufficient Evidence" rather than guessing.

## 6. Confidence Scoring
*   **Scale:** 0.0 to 1.0 (Internal), mapped to UI descriptors (e.g., "Highly Probable," "Tentative").
*   **Decay:** Confidence in evidence (especially skills) decays over time if not refreshed.

## 7. Safety & Boundaries
*   **Non-Prescriptive:** Knight Intelligence provides "Recommendations" and "Simulations," never "Commands."
*   **Medical/Legal Disclaimer:** Explicitly identify when reasoning touches on regulated domains.
*   **User Sovereignty:** The user always has the final override on any AI-proposed mission or classification.

## 8. Offline Behaviour
*   **Graceful Degradation:** Intelligence remains active for local data using on-device models. Cloud-dependent insights are disabled with a clear explanation.

## 9. AI Decision Boundaries
*   **Automatic Actions:** Restricted to low-risk, high-confidence administrative tasks (e.g., categorizing a transaction).
*   **High-Impact Decisions:** (e.g., job switches, major purchases) always require explicit user confirmation.
