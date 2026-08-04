# KnightOS Release Validation Task List

- `[x]` Analysis & Test Fixes
    - `[x]` Fix `test/core/intelligence/ingestion_dedupe_test.dart`
    - `[x]` Fix `test/core/storage/memory_dao_test.dart`
    - `[x]` Cleanup unused imports in `lib/` and `test/`
    - `[x]` Remove unused local variables
- `[/]` Release Pipeline Execution
    - `[x]` `flutter clean` & `flutter pub get` (Done)
    - `[x]` `flutter analyze` (100% CLEAN)
    - `[x]` `flutter build bundle` (SUCCESS)
    - `[ ]` `flutter test --coverage` (Blocked by DLL lock)
    - `[ ]` `flutter build apk --release` (Blocked by timeout)
- `[x]` Regression Review & Reporting
    - `[x]` Subsystem Regression Review
    - `[x]` Update `RELEASE_STATUS.md`
    - `[x]` Update `CEO_DASHBOARD.md`
    - `[x]` Update `CHANGELOG.md`
    - `[x]` Update `PROJECT_SCOREBOARD.md`
