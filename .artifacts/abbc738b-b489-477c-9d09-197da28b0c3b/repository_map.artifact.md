# Knight OS Repository Map

This document provides a comprehensive technical overview of the Knight OS repository, serving as the blueprint for autonomous engineering.

## Project Structure

```
knight_os/
├── .artifacts/             # AI-generated task tracking and walkthroughs
├── android/                # Android platform specific files
├── assets/                 # Static assets (JSON schemas, questions)
├── docs/                   # Engineering Manual and documentation (Source of Truth)
├── ios/                    # iOS platform specific files
├── knight_knowledge_base/  # External specification for memory ontology
├── lib/
│   ├── app/                # Global UI components and primary screens
│   │   ├── screens/        # Top-level application screens
│   │   └── widgets/        # Shared UI components
│   ├── core/               # Platform foundation and shared logic
│   │   ├── brain/          # Legacy or core logic (KnightBrain)
│   │   ├── connectors/     # Data import/sync interfaces
│   │   ├── design_system/  # Visual constants and primitive widgets
│   │   ├── domain/         # Shared business models
│   │   ├── intelligence/   # The AI Operating System Core (Engines & Services)
│   │   ├── internal/       # Infrastructure (Storage, Utils)
│   │   ├── providers/      # Global Riverpod providers
│   │   ├── repositories/   # Shared data access layers
│   │   ├── router/         # GoRouter configuration
│   │   ├── services/       # Global app services (Updates, AI, etc.)
│   │   ├── storage/        # Key-Value and file storage
│   │   ├── theme/          # App-wide theme definitions
│   │   └── world/          # Perception layer (Connectors, Hardware bridge)
│   ├── features/           # Modular business features (30+ modules)
│   │   ├── knight/         # AI Conversation Layer
│   │   ├── knowledge/      # Knowledge Graph and Vault
│   │   ├── planner/        # Goal & Task Management
│   │   └── ...             # Other feature modules (Health, Finance, etc.)
│   ├── knight_os_app.dart  # Main Application Widget
│   └── main.dart           # App Entry point & Global Error Handling
├── scripts/                # Automation and build scripts
└── test/                   # Comprehensive test suite (Unit & Widget)
```

## Core Intelligence Stack (Data Flow)

Knight OS functions as a continuous intelligence loop:

1.  **Perception (World Engine)**: `WorldConnector`s (Google Calendar, Mail, OpenWeather) fetch raw data.
2.  **Normalization & Validation**: `WorldEngine` normalizes data; `MemoryEngine` validates it against JSON Schemas in `knight_knowledge_base`.
3.  **Storage**: `DriftMemoryRepository` persists validated facts into SQLite via `KnightDatabase`.
4.  **Context Assembly**: `ContextEngine` builds a tiered snapshot of relevant memories and current state.
5.  **Reasoning**: `ReasoningEngine` applies deterministic rules and behavioral weights to generate insights and recommendations.
6.  **Planning**: `PlanningEngine` decomposes high-level goals into executable `KnightPlan`s.
7.  **Execution**: `AutonomousEngine` automates plan steps, managing user approvals and self-healing.
8.  **Interaction**: `KnightCognition` coordinates the flow for user requests, selecting AI models via `AiRouter`.

## Navigation Flow

The app uses `GoRouter` with the following primary hierarchy:

-   **Splash**: Initial loading and state check.
-   **Welcome/Auth**: Onboarding and session management.
-   **KnightShell (ShellRoute)**: Provides persistent bottom navigation and status bars for:
    -   **Dashboard/Home**: Central Mission Control.
    -   **Life Atlas**: Chronological history view.
    -   **Knight**: Direct AI interaction.
    -   **Knowledge Vault**: Structured memory explorer.
    -   **Settings**: System configuration.

## Storage Strategy

-   **SQLite (Drift)**: Primary relational storage for Memories, Relations, Evidence, and User Profiles.
-   **File Storage (LocalDatabase)**: JSON/CSV files for simple metrics, audit logs, and legacy data.
-   **Secure Storage**: Encryption for sensitive auth sessions and integration secrets.

## Key Dependencies

-   `flutter_riverpod`: State management and Dependency Injection.
-   `go_router`: Declarative navigation.
-   `drift`: Reactive SQLite persistence.
-   `google_fonts`: Dynamic typography.
-   `json_schema`: Ontological validation.

## Maintenance & Risks

### Possible Risks
-   **Async Complexity**: The `AutonomousEngine` and `PerceptionScheduler` manage complex async loops that could lead to race conditions if not carefully guarded.
-   **Performance**: As the `MemoryTable` grows, complex graph traversals and reactive streams may require heavy optimization (indexes are being added in v4).
-   **Model Dependency**: While the `AiRouter` decouples the provider, the system is highly dependent on high-quality LLM responses for goal decomposition.
-   **Mock Bloat**: Many "real-world" connectors currently use simulated clients (`GoogleCalendarClientImpl`).

### Outdated Documentation
-   `ARCHITECTURE.md` (root): Frozen on July 27, 2026. Mostly accurate but lacks late Sprint 8 updates.
-   `PROJECT_ARCHITECTURE.md` (root): Refers to Version 1; highly outdated compared to `docs/03_Architecture.md`.

## Current State
**Version 4, Sprint 8** is marked as **100% Complete**. The system is in a "Release Candidate" state, idling for Version 5 planning.
