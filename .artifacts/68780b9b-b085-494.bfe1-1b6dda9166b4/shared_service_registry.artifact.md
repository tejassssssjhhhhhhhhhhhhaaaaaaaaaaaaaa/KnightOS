# Shared Service Registry

**Status:** PERMANENT GOVERNANCE DOCUMENT
**Owner:** CTO

## 1. Core Platform Services (Owned by KnightOS Core)

| Service Name | Responsibility | Dependencies |
| :--- | :--- | :--- |
| **IdentityService** | Auth, Profile Management, Multi-device Sync. | Database, CloudSync |
| **PrivacyVault** | Encryption, Permissioning, Classification, Local Processing. | SecureStorage |
| **EvidenceGraphEngine**| Graph traversals, Node/Edge CRUD, Verification Logic. | Database |
| **TimelineEngine** | Universal Chronology, Event Sourcing, Projections. | EvidenceGraph |
| **MissionEngine** | Goal/Task/Habit orchestrator, Conflict Resolution. | Timeline, Intelligence |
| **IntegrationHub** | External Connector management, Webhooks, API Auth. | Network, SecureStorage |
| **IntelligenceOrchestrator**| Model routing, Explainability, Context Management. | SLM, CloudAI, EvidenceGraph |
| **SearchService** | Unified Cross-Domain Search (Semantic + Keyword). | EvidenceGraph, Timeline |
| **DesignSystemProvider** | Themes, Design Tokens, Asset Management. | UI Framework |
| **NotificationService** | Unified Attention Engine, Priority-based alerts. | MissionEngine |

## 2. Domain Services (Module Specific)

| Service Name | Responsibility | Core Dependency |
| :--- | :--- | :--- |
| **CareerIntelligence** | Skill Scoring, Promotion Simulation, Market Mapping. | IntelligenceOrchestrator, EvidenceGraph |
| **FinanceEngine** | Budgeting logic, ROI Analysis, Portfolio Tracking. | EvidenceGraph, IntelligenceOrchestrator |
| **HealthAnalyzer** | Biometric analysis, Sleep/Stress correlation. | TimelineEngine, MissionEngine |
| **TravelLogistics** | Itinerary optimization, Relocation simulation. | TimelineEngine, IntelligenceOrchestrator |

## 3. Governance Rules
*   **No Circular Dependencies:** Domains depend on Core; Core NEVER depends on Domains.
*   **Interface Stability:** Public interfaces (APIs) of Core services must remain stable across minor versions.
*   **Single Responsibility:** If two services perform the same logic (e.g., "Date Parsing"), that logic must move to a shared Utility layer or a Core Service.
