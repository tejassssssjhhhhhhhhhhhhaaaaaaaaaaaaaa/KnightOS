# Engineering Standards Manual

**Status:** PERMANENT GOVERNANCE DOCUMENT
**Owner:** CTO

## 1. Folder & Project Structure
*   **Modular Architecture:** Each feature/domain must be a self-contained module.
*   **Layered Pattern:** `data` (repos, sources), `domain` (use-cases, entities), `presentation` (UI, ViewModels).
*   **Clean Separation:** No UI logic in the data layer. No database queries in the UI.

## 2. Naming Conventions
*   **Files:** `kebab-case.dart` (or `.kt`).
*   **Classes/Types:** `PascalCase`.
*   **Variables/Functions:** `camelCase`.
*   **Constants:** `SCREAMING_SNAKE_CASE`.

## 3. Documentation
*   **Code-level:** Mandatory KDoc/DartDoc for all public interfaces and complex logic.
*   **Architectural:** Every new module must include a `README.md` explaining its purpose and boundaries.

## 4. Testing Requirements
*   **TDD Encouraged:** Write tests alongside implementation.
*   **Unit Tests:** Mandatory for all business logic, use-cases, and repositories.
*   **Integration Tests:** Mandatory for cross-service interactions and graph traversals.
*   **Widget/Golden Tests:** Required for all Design System components.

## 5. Dependency Injection (DI)
*   **Standards:** Use Hilt (Android) or Provider/Riverpod (Flutter) for dependency management.
*   **Constructor Injection:** Preferred over field injection for testability.

## 6. Error Handling
*   **Result Pattern:** Prefer `Result<T, E>` or `Either<L, R>` over throwing raw exceptions.
*   **User-Facing:** All errors must be mapped to a user-friendly message before reaching the UI.

## 7. Performance Standards
*   **UI Thread:** No blocking work on the main thread. Use Isolates (Flutter) or Coroutines/WorkManager (Android).
*   **Memory:** No memory leaks. All streams and listeners must be disposed of correctly.
*   **Startup:** App must be interactive within 2 seconds.

## 8. Logging & Observability
*   **Log Levels:** Use `Debug`, `Info`, `Warning`, `Error` appropriately.
*   **Privacy:** NEVER log sensitive or highly sensitive data (PII).

## 9. Feature Flags
*   **Mandatory:** All new features must be wrapped in a feature flag for phased rollout and emergency kill-switch capability.

## 10. Code Review & Release
*   **PR Requirements:** Passing tests, no linter warnings, documentation updated, and at least one peer approval.
*   **Migrations:** Database migrations must be tested and reversible.
