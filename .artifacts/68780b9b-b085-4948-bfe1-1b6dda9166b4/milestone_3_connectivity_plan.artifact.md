# Milestone 3 Engineering Plan: Connectivity & Universal Ingestion

**Status:** ARCHITECTURAL DRAFT
**Owner:** Program Director / CTO
**Target:** KnightOS Platform v6.0.0-alpha.3

## 1. Connectivity Architecture

The KnightOS Connectivity Layer follows a **Provider-Connector Pattern**.

### Reusable Connector Framework (`IntegrationHub`)
*   **Base Auth Handler:** Pluggable OAuth2, API Key, and Local-Path authentication.
*   **Sync Orchestrator:** Manages job queues, background fetching, and incremental sync (delta tracking).
*   **Retry & Backoff:** Standardized exponential backoff for 429 (Rate Limit) and 5xx errors.
*   **Health Monitor:** Heartbeat for active integrations; alerts user on "Auth Expired" or "Connection Broken".
*   **Consent Guard:** Intercepts every sync request to verify active user permissions.

---

## 2. Connector Lifecycle

Every data point flows through this immutable pipeline:

1.  **Discovery/Install:** User selects a connector from the Integration Hub.
2.  **Auth & Permissioning:** Secure handshake; user approves specific scopes.
3.  **Sync (Raw Ingestion):** Connector fetches raw provider data (JSON/Files).
4.  **Normalization:** Map raw data to the `KnightOS Universal Data Schema`.
5.  **Evidence Creation:** Wrap data in an `Evidence` entity with CAID (content-addressable ID).
6.  **Timeline Projection:** Generate `TimelineEvent` if the evidence has chronological attributes.
7.  **Mission Correlation:** Update active `Missions` based on new evidence (e.g., "GitHub Commit" -> "Skill Growth").
8.  **Intelligence Synthesis:** AI reasoner updates the Digital Twin.
9.  **Explainability Tagging:** Append source, confidence, and path to the metadata.

---

## 3. Initial Connectors Implementation Order

| Order | Connector | Reasoning |
| :--- | :--- | :--- |
| **1** | **Manual / Local PDF** | **The Sink:** Establishes the normalization and verification path without external API complexity. |
| **2** | **Google Calendar** | **The Anchor:** High-density structured data. Maps directly to the Timeline Engine. Auth foundations exist. |
| **3** | **GitHub** | **Career Engine:** Essential for "Zero-Touch" Career Compass. Provides verifiable professional evidence. |
| **4** | **Google Drive** | **The Vault:** Automated ingestion of certificates and resumes stored in folders. |
| **5** | **Gmail** | **High Context:** High-value but high-complexity. Requires local SLM for privacy-safe extraction. |

---

## 4. Universal Data Normalization

The **Normalization Layer** ensures that domains (Career, Finance) never see raw GitHub or Google objects.

*   **Logic:** `RawData` -> `Map<String, dynamic>` -> `UniversalEntity` -> `EvidenceNode`.
*   **Mapping Registry:** Centralized set of "Translators" for each provider version.
*   **Deduplication:** Uses CAID (SHA-256) to ensure the same document from different sources isn't duplicated in the Graph.

---

## 5. Privacy Review

| Connector | Data Classification | Processing Boundary |
| :--- | :--- | :--- |
| **Local PDF** | Sensitive (L3) | 100% On-Device Parsing. |
| **Calendar** | Personal (L2) | Metadata synced; full event body local. |
| **GitHub** | Public/Personal (L1/L2)| Commits processed via Cloud AI for skill mapping. |
| **Gmail** | Highly Sensitive (L4)| Local SLM extraction ONLY. No raw email body leaves device. |

---

## 6. Security Review

*   **Storage:** Tokens are stored in the **Privacy Vault** (AES-256 via SecureStorage).
*   **Rotation:** Automatic refresh logic for OAuth2 tokens during the Sync phase.
*   **Isolation:** Each connector logic runs in a sandboxed Isolate/Thread to prevent cross-leakage.
*   **Deletion:** Deleting a connector triggers "Cascading Purge" of all associated raw data (unverified evidence).

---

## 7. Explainability Standards

Every `Evidence` node produced by Milestone 3 must include the following `ExplainabilityMetadata`:
*   `source_provider_id`: (e.g., 'google_calendar_v3')
*   `ingestion_timestamp`: ISO 8601
*   `extraction_method`: (e.g., 'Local_Regex', 'Vertex_AI_v1')
*   `confidence_score`: 0.0 - 1.0
*   `lineage`: Parent resource ID from the source.

---

## 8. Engineering Breakdown

### Work Packages

| ID | Description | Team | Complexity |
| :--- | :--- | :--- | :--- |
| **M3-WP1** | **IntegrationHub Foundation** (Sync, Retry, Auth base) | Platform | L |
| **M3-WP2** | **Manual/Local File Connector** (PDF/JSON Ingestion) | Platform | M |
| **M3-WP3** | **Google Calendar Connector** (Auth + Mapping) | Platform | M |
| **M3-WP4** | **Normalization & Mapping Registry** | Design/QA | M |
| **M3-WP5** | **GitHub Professional Evidence Connector** | Platform | L |

---

## 9. Risk Assessment & Mitigation

*   **Risk:** API Breaking Changes (GitHub/Google).
    *   **Mitigation:** Versioned Mapping Registry; Automated daily "API Health" tests.
*   **Risk:** Token Hijacking.
    *   **Mitigation:** All tokens reside in the encrypted Privacy Vault; never in standard shared preferences.
*   **Risk:** Battery/Data Drain during Sync.
    *   **Mitigation:** Intelligent Sync Windows (e.g., WiFi + Charging only for large imports).

---

## 10. Implementation Recommendation

**Recommendation: Begin with M3-WP2 (Manual / Local File Connector).**

**Architectural Reasoning:**
Starting with a local file connector allows us to build the **Normalization Pipeline** and **Evidence Creation** logic in a deterministic, offline environment. It decouples "Connectivity" from "Ingestion." Once the platform can reliably turn a local PDF or JSON file into a `Verified Evidence` node on the `Universal Timeline`, adding OAuth-based service connectors becomes a simple matter of swapping the "Source."

**MILESTONE 3 CONNECTIVITY PLAN READY.**
