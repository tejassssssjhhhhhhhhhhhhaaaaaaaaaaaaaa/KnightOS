# KnightOS v1 Architecture

## Overview
KnightOS is a high-performance personal operating system built with Flutter. It features a modular architecture designed for local-first intelligence, premium aesthetics, and cross-platform extensibility.

## Architecture Layers

### 1. Presentation Layer (App & Features)
- **Screens**: Composed using `KnightPageScaffold` for consistent layout and constraints.
- **Controllers**: Implemented as Riverpod `AsyncNotifier`s. They manage module-specific state and handle user interactions.
- **Widgets**: Atomic, reusable components (e.g., `FocusCard`, `RecoveryCard`, `ChatBubble`) following the KnightOS Design System.

### 2. Domain Layer
- **Models**: Immutable data classes with JSON serialization and `copyWith` support.
- **Repository Interfaces**: Define the contract for data access, decoupling business logic from persistence implementations.
- **State Classes**: Represent the reactive state of each module (e.g., `KnightState`, `MoneyState`).

### 3. Data Layer (Core & Internal)
- **Repositories**: Concrete implementations of domain interfaces. They serve as the single source of truth for modules.
- **Storage Engines**: 
    - `LocalDatabase`: Handles JSON-based file storage for simple metrics and logs.
    - `DriftStorageEngine`: High-performance SQLite-backed persistence for complex relational data (e.g., User Profile, Work Sessions).
    - `SecureStorage`: Manages sensitive authentication tokens and account secrets.

## Module Overview

| Module | Purpose | Key Components |
| :--- | :--- | :--- |
| **Focus** | Daily priority tracking | `FocusController`, `LocalFocusRepository` |
| **Recovery** | Health and readiness metrics | `RecoveryController`, `LocalRecoveryRepository` |
| **Money** | Financial dashboard | `MoneyController`, `LocalMoneyRepository` |
| **Upcoming** | Planning and scheduling | `UpcomingController`, `LocalUpcomingRepository` |
| **Knight** | Central AI assistant foundation | `KnightController`, `LocalKnightRepository`, `AiProvider` interface |
| **Timeline** | Chronological life history | `TimelineController`, `LocalTimelineRepository` |

## Design Principles
- **Repository Pattern**: Strict separation between data sourcing and business logic.
- **Unidirectional Data Flow**: State flows from Repositories -> Controllers -> UI. Events flow from UI -> Controllers -> Repositories.
- **Dependency Injection**: Orchestrated via Riverpod providers to ensure testability and clean lifecycle management.
- **Local-First**: All core features function without an internet connection, utilizing high-performance local storage.
- **Future-Proofing**: Explicit extension points for AI intelligence, semantic search, and cloud synchronization.
