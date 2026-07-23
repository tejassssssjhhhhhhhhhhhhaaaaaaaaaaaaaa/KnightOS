# KnightOS Design Document

## 1. Current Folder Structure

- `lib/`
  - `app/`
    - `app_shell.dart`
    - `home_screen.dart`
    - `placeholder_screen.dart`
    - `screens/`
      - `dashboard_screen.dart`
      - `dashboard_screen_rewrite.dart`
      - `onboarding_screen.dart`
      - `settings_screen.dart`
      - `splash_screen.dart`
      - `welcome_screen.dart`
    - `widgets/`
      - UI widget components used by screen views
  - `core/`
    - `engines/`
    - `providers/`
      - `app_providers.dart`
    - `repositories/`
      - `finance_repository.dart`
      - `fitness_repository.dart`
      - `sleep_repository.dart`
      - `user_repository.dart`
      - `work_repository.dart`
    - `router/`
      - `app_router.dart`
      - `app_routes.dart`
    - `services/`
      - `ai_service.dart`
    - `storage/`
      - `local_database.dart`
      - `storage_keys.dart`
    - `theme/`
      - `app_theme.dart`
  - `features/`
    - `dashboard/`
      - `dashboard_controller.dart`
      - `dashboard_models.dart`
      - `dashboard_repository.dart`
    - `finance/`
      - `data/finance_storage.dart`
      - `domain/finance_transaction.dart`
      - `presentation/finance_tracker_screen.dart`
    - `fitness/`
      - `data/fitness_storage.dart`
      - `domain/workout_session.dart`
      - `presentation/fitness_tracker_screen.dart`
    - `onboarding/`
      - `data/onboarding_storage.dart`
      - `domain/onboarding_profile.dart`
      - `onboarding_controller.dart`
    - `sleep/`
      - `data/sleep_storage.dart`
      - `domain/sleep_session.dart`
      - `presentation/sleep_tracker_screen.dart`
    - `work_tracker/`
      - `data/work_storage.dart`
      - `domain/work_session.dart`
      - `presentation/work_tracker_screen.dart`
      - `work_tracker_controller.dart`
  - root app entry points
    - `knight_os_app.dart`
    - `main.dart`
    - `main_new.dart`
    - `main2.dart`

## 2. Current Architecture

KnightOS is organized as a modular Flutter application with feature-based folders and a lightweight core layer.

Key architectural patterns:
- `lib/app` contains UI composition, shell layout, screens, and reusable widgets.
- `lib/core` contains shared infrastructure, service providers, navigation, theme, storage, and core repositories.
- `lib/features` contains vertical feature modules with domain models, data access wrappers, controllers, and presentation.
- `Riverpod` is the state management mechanism, primarily using `AsyncNotifierProvider` for async feature state.
- Local JSON persistence is provided by `LocalDatabase` and keyed through `StorageKeys`.

This architecture currently blends feature controllers with UI screens and uses repository wrappers around local storage.

## 3. Repository Pattern Currently Used

The repository pattern is implemented with:
- `core/repositories/*Repository.dart` for each domain area.
- Each repository wraps `LocalDatabase` and performs JSON serialization/deserialization.
- Feature `data` classes like `FinanceStorage`, `SleepStorage`, `OnboardingStorage`, `FitnessStorage`, and `WorkStorage` wrap the core repositories.
- `features/dashboard/dashboard_repository.dart` aggregates multiple repositories to build a unified dashboard model.

Current repository behavior:
- `FinanceRepository`, `FitnessRepository`, `SleepRepository`, `WorkRepository`, `UserRepository` expose methods like `load*`, `save*`, `delete*`.
- Repositories are concrete classes, not interfaces or abstract contracts.
- Repositories are internally composed by higher layers rather than injected through centralized DI.
- Persistence is file-based JSON through `LocalDatabase`.

## 4. Riverpod Providers

The application currently declares a small set of providers:

- `dashboardProvider` (`AsyncNotifierProvider<DashboardNotifier, DashboardData>`) in `features/dashboard/dashboard_controller.dart`
  - Loads aggregated dashboard state from `DashboardRepository`.
  - Exposes `refreshDashboard()`.

- `onboardingProfileProvider` (`AsyncNotifierProvider<OnboardingNotifier, OnboardingProfile?>`) in `features/onboarding/onboarding_controller.dart`
  - Loads, saves, and clears onboarding profile state.

- `workSessionsProvider` (`AsyncNotifierProvider<WorkSessionsNotifier, List<WorkSession>>`) in `features/work_tracker/work_tracker_controller.dart`
  - Loads work sessions and supports save/delete operations.

- `aiServiceProvider` (`Provider<AiService>`) in `core/providers/app_providers.dart`
  - Provides a lightweight shared AI utility.

Usage patterns:
- UI screens consume state with `ref.watch(...)`.
- State modifications use `ref.read(... .notifier)` to call notifier methods.
- Only a small subset of application state is currently exposed via providers.

## 5. Data Flow

The current flow is roughly:

1. UI screen initializes and calls `ref.watch(provider)` or a `FutureBuilder`.
2. Provider `build()` method loads data through a feature storage or repository wrapper.
3. Repositories read/write JSON via `LocalDatabase` and `StorageKeys`.
4. Domain models are created from JSON and passed up to UI.
5. UI renders based on the loaded model and exposes actions to call notifier methods.
6. Notifier methods update local storage and refresh state by reloading.

Examples:
- Dashboard loads `OnboardingProfile`, `SleepSession`, `WorkoutSession`, and `FinanceTransaction` through `DashboardRepository`.
- Settings page loads `onboardingProfileProvider`, populates controllers, and saves back through `OnboardingNotifier`.
- Work tracker loads work sessions through `WorkSessionsNotifier` and persists changes through `WorkStorage`.

## 6. Missing Architectural Pieces

The project is missing several key architecture components that would improve consistency, scalability, and testability:

- Centralized dependency injection / service locator for repositories/providers.
- Abstract repository interfaces for decoupling domain code from concrete persistence.
- Explicit domain/use-case layer separate from presentation and data access.
- Shared `StateNotifier`/`AsyncNotifier` conventions across all feature modules.
- Strong shared model definitions and a common domain model package.
- Feature boundaries between presentation and data layers are partly blurred.
- Error-handling and loading state consistency across async providers.
- Automated tests for providers, repositories, and model serialization.
- A true `dashboard` feature shell instead of duplicate legacy and rewrite screen files.
- Shared integration between `ai_service` and feature state (the AI service exists but is not fully integrated into domain logic).
- A proper `engine` layer for cross-feature orchestration and business logic.

## 7. Recommended Knight Engine Architecture

### Architectural posture
KnightOS should evolve from a feature-first app into a layered personal operating system architecture built around explicit boundaries, stable contracts, and orchestration rather than ad hoc screen logic. The target model should be a modular, hexagonal design with a strong domain core and a thin UI layer.

### Core architecture principles
1. Dependency inversion first
   - UI, Riverpod providers, and widgets must depend on abstractions, not concrete repositories or services.
   - The domain layer must remain free from Flutter, Riverpod, and storage implementation details.

2. Clear layer boundaries
   - Presentation: screens, widgets, navigation, theming, and user interaction.
   - Application: use cases, orchestration, feature controllers, and workflows.
   - Domain: entities, value objects, policies, business rules, and domain events.
   - Infrastructure: repositories, persistence adapters, file storage, sync connectors, and external services.
   - Shared kernel: logging, IDs, time, settings, permission handling, telemetry, and error types.

3. Feature modules as independent capability units
   - Each feature should have its own `domain`, `application`, `infrastructure`, and `presentation` subfolders.
   - Cross-feature communication should happen through a shared kernel and explicit contracts, not through direct UI coupling.

4. Event-driven orchestration for scale
   - The system should support events such as `ProfileUpdated`, `SessionCompleted`, `InsightRequested`, and `SyncCompleted`.
   - A central event bus or mediator should notify relevant features without tightly coupling them.

### Production-grade structure
- `lib/core/kernel/`
  - `app_kernel.dart`
  - `event_bus.dart`
  - `clock.dart`
  - `id_generator.dart`
  - `logger.dart`
  - `error_handling.dart`
  - `permissions.dart`

- `lib/core/domain/`
  - `entities/`
  - `value_objects/`
  - `repositories/` (interfaces only)
  - `services/` (domain services and policies)
  - `events/`

- `lib/core/application/`
  - `use_cases/`
  - `commands/`
  - `queries/`
  - `orchestrators/`

- `lib/core/infrastructure/`
  - `storage/`
  - `persistence/`
  - `sync/`
  - `external/`

- `lib/features/<feature>/`
  - `domain/`
  - `application/`
  - `infrastructure/`
  - `presentation/`

### Recommended runtime model
KnightOS should have a central application kernel that owns:
- app lifecycle
- feature registration
- shared services
- event dispatch
- configuration and settings
- cross-feature orchestration

The kernel should expose capabilities to the UI through a small set of application services and providers, rather than letting every screen directly manipulate domain state.

### Recommended use-case flow
1. A screen dispatches an intent to a presenter or provider.
2. The provider delegates to an application use case.
3. The use case invokes one or more domain services and repository ports.
4. Infrastructure adapters implement the repository contracts and persist or fetch data.
5. Domain events are emitted and consumed by other features through the kernel.
6. The UI reacts to a normalized state object rather than directly manipulating raw data models.

This keeps the presentation layer thin while preserving business logic and orchestration in stable, testable layers.

### Riverpod role in this architecture
Riverpod should be used as an integration layer for Flutter, not as the primary business architecture.

Recommended usage:
- Use `Provider` and `ProviderFamily` for immutable services and dependency injection.
- Use `AsyncNotifier` or `Notifier` only for UI-facing state that must be refreshed from the application layer.
- Keep providers thin: they should delegate to use cases, not contain business rules.
- Avoid placing persistence, validation, or cross-feature orchestration directly inside providers.
- Use `autoDispose` for transient UI state and `FutureProvider` only for simple read-only derived state.

### Repository strategy
Repositories should be interface-based and domain-oriented.

Recommended shape:
- `ProfileRepository` for profile and preference persistence.
- `SessionRepository<T>` for time-based records such as work, sleep, and fitness sessions.
- `TransactionRepository` for financial entries.
- `InsightRepository` for derived recommendations and memory state.

Each repository interface should expose domain-model operations, while infrastructure implementations handle the storage format, serialization, and adapter specifics.

### Data persistence model
The persistence layer should be versioned and adapter-based.

Recommended design:
- `LocalStore` for JSON or SQLite-backed storage.
- `EncryptedStore` for sensitive user data.
- `SyncStore` for future remote sync and cloud integration.
- `MigrationManager` for schema evolution over time.

The domain layer should never know whether data comes from a file, database, or cloud service.

### Data model strategy
KnightOS should move to a canonical model layer with shared, typed abstractions rather than many loosely related feature models.

Recommended model families:
- `UserProfile` or `KnightProfile` as the master identity and preference model.
- `EntityId`, `TimestampedEntity`, and `AuditTrail` for common metadata.
- `ActivityRecord` for sessions and events.
- `MetricSnapshot` for aggregated analytics.
- `Insight` for recommendations, predictions, and assistant output.
- `AppSettings` for theme, notifications, privacy, and feature toggles.

All models should be immutable and strongly typed, with validation and serialization handled by dedicated adapters.

### Scaling to 30+ features
To remain maintainable as the product grows, the system should enforce a few architectural guardrails:
- feature modules must not import one another directly unless via the kernel contract layer
- shared utilities must stay in the kernel or core packages, not inside feature folders
- every feature needs a clear contract interface and an explicit lifecycle
- new features should register themselves with the kernel rather than being hardwired into routes or screens
- analytics, security, notification, and sync should be cross-cutting services, not duplicated feature code

### Long-term target state
The long-term architecture should resemble a personal operating system kernel with a growing set of feature modules, each operating behind stable contracts and contributing to a shared intelligence layer. The UI becomes a shell over the engine, while the real intelligence and state management live in the application and domain layers.

That design is durable, testable, extensible, and capable of supporting dozens of features without architectural collapse.

## 8. Recommended Shared Models

The current domain models are fragmented and include duplicate aliasing (`UserProfile` / `OnboardingProfile`). KnightOS should define a shared model layer such as:

- `KnightProfile`
  - personal data, work preferences, health goals, finance goals, AI settings, theme preferences, notification preferences.

- `KnightSession`
  - `WorkSession`, `SleepSession`, `WorkoutSession`, and `FinanceTransaction` should share metadata patterns, ids, timestamps, tags, and status.

- `KnightMetrics`
  - `FinanceMetrics`, `FitnessMetrics`, `SleepMetrics`, `WorkMetrics`, and `KnightScore`.

- `KnightInsight`
  - AI insight payloads, recommendations, predictions, and color-coded status.

- `DashboardSummary`
  - Combined state for display, including `resolvedProfile`, recent sessions, aggregated totals, and derived metrics.

- `StorageEntity<T>` or `JsonSerializable`
  - Base contract for local persistence objects with `toJson()` / `fromJson()`.

Recommended shared models:
- `ProfileModel`
- `SessionModel`
- `FinanceTransactionModel`
- `MetricModel`
- `InsightModel`
- `EngineState` / `DashboardState`

## 9. Feature Roadmap

### Phase 1: Stabilize architecture
- Consolidate `lib/features/dashboard/dashboard_screen_rewrite.dart` as the single active dashboard UI.
- Remove legacy dashboard file duplication and stale screen code.
- Add abstract repository interfaces for core data access.
- Centralize provider definitions in `core/providers/`.
- Move `LocalDatabase` to a clearly named persistence module and standardize JSON storage access.
- Add tests for providers, repositories, and model serialization.

### Phase 2: Build Knight Engine
- Introduce `KnightEngine` core orchestrator.
- Create feature engines for `dashboard`, `work_tracker`, `sleep`, `finance`, `onboarding`.
- Move business logic out of UI and into engines.
- Implement shared cross-feature rules: scoring, recommendations, notifications, and insights.
- Integrate `AiService` with an engine rather than isolated provider.

### Phase 3: Improve shared models
- Replace ad hoc `UserProfile`/`OnboardingProfile` alias with a canonical shared profile model.
- Define robust metrics/value object classes and avoid string-only fields where numeric values are expected.
- Add consistent serialization across all feature domain models.
- Introduce typed settings models for app preferences and AI configuration.

### Phase 4: Expand feature coverage
- Add true onboarding flow persistence and progress tracking.
- Replace `PlaceholderScreen` and expand `memory`, `integrations`, `automation`, and `planner` into real engine-backed features.
- Add cross-feature notifications and intelligent task suggestions.
- Add remote sync or integrations behind repository adapters.

### Phase 5: Platform and scale
- Improve Windows/macOS/Linux and mobile-specific storage abstractions.
- Add offline-first sync engine for future cloud integration.
- Harden app architecture with clean boundaries, dependency injection, and well-defined feature contracts.

---

This document is a snapshot of the current KnightOS project state. It highlights the current folder layout, Riverpod usage, repository pattern, data flow, architectural gaps, and a recommended path toward a more maintainable Knight Engine architecture.