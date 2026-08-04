# KnightOS Release Validation Implementation Plan

This plan details the steps to achieve a clean release pipeline by fixing analysis errors, resolving test failures, and performing a comprehensive regression review.

## User Review Required

> [!IMPORTANT]
> This phase focuses exclusively on stability and quality. No new features will be implemented. The goal is to reach a state where `flutter analyze`, `flutter test`, and `flutter build` all pass successfully.

## Proposed Changes

### 1. Analysis & Test Fixes
Goal: Resolve all 32 issues found by `flutter analyze`.

#### [MODIFY] [ingestion_dedupe_test.dart](file:///C:/Users/tejas/knight_os/test/core/intelligence/ingestion_dedupe_test.dart)
- Fix `TransactionTableCompanion.insert`:
    - Rename `date` parameter to `transactionDate`.
    - Add required `type` and `category` parameters.
    - Remove invalid `currency` parameter.
    - Pass raw `String` to `dedupeHash` instead of `Value<String>`.
- Remove unused `ingestionService` variable.
- Remove redundant `matcher` import (handled by `flutter_test`).

#### [MODIFY] [memory_dao_test.dart](file:///C:/Users/tejas/knight_os/test/core/storage/memory_dao_test.dart)
- Fix `MemoryTableCompanion.insert`:
    - Pass raw `DateTime` for `recordedAt` and `effectiveAt` instead of `Value<DateTime>`.
    - Ensure all required parameters are provided in all `insert` calls.

#### [MODIFY] [Cleanup Unused Imports]
- Remove unnecessary/unused imports in:
    - `lib/app/screens/splash_screen.dart`
    - `lib/core/intelligence/providers/data_providers.dart`
    - `lib/features/settings/presentation/developer_mode_screen.dart` (Unused local variable)
    - All DAOs in `lib/core/internal/storage/drift/daos/` (Unnecessary `base_dao.dart` imports).
    - `test/core/intelligence/knight_context_test.dart`.

### 2. Execution Pipeline
Goal: Run the full release sequence.

- `flutter analyze`: Verify zero issues.
- `flutter test --coverage`: Verify 100% test pass rate and generate coverage report.
- `flutter build apk --release`: Verify buildability for production.

### 3. Regression Review & Final Documentation
Goal: Provide evidence-based certification of the release.

- Perform manual and automated regression review across all 11 core subsystems.
- Update `RELEASE_STATUS.md`, `CEO_DASHBOARD.md`, `CHANGELOG.md`, and `PROJECT_SCOREBOARD.md`.

## Verification Plan

### Automated Tests
- `flutter analyze`
- `flutter test`
- `flutter build apk --release`

### Manual Verification
- Review of the generated reports for consistency and accuracy.
