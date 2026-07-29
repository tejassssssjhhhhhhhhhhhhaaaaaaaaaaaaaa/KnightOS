# Implementation Plan - Sprint 8: Stability & Quality Assurance

This plan focuses on resolving critical test failures and ensuring a stable startup sequence, moving the project towards its first Version 4 Release Candidate.

## User Review Required

> [!IMPORTANT]
> This sprint involves fixing core mock implementations in tests. No production architectural changes are expected other than defensive `mounted` checks in the UI layer.

## Proposed Changes

### Core Intelligence Tests

#### [MODIFY] [planning_service_test.dart](file:///C:/Users/tejas/knight_os/test/core/intelligence/planning_service_test.dart)
#### [MODIFY] [reasoning_service_test.dart](file:///C:/Users/tejas/knight_os/test/core/intelligence/reasoning_service_test.dart)
- Update `MockMemoryRepository` to implement:
  - `getByCategory`
  - `getByDomain`
  - `getLatest`
  - `watchLatest`
  - `watchByCategory`
  - `watchByDomain`
- These will return default empty values to avoid `UnimplementedError` when services traverse the memory graph during reasoning cycles.

### Presentation Layer

#### [MODIFY] [splash_screen.dart](file:///C:/Users/tejas/knight_os/lib/app/screens/splash_screen.dart)
- Add `if (!mounted) return;` guards after every `await` in the `_initialize` method.
- This prevents `ref` access after the widget has been disposed, which is a common cause of test failures and occasional production crashes during slow initialization.

### Project Tracking

#### [MODIFY] [08_Task_Index.md](file:///C:/Users/tejas/knight_os/docs/08_Task_Index.md)
- Add `V4-024`: Sprint 8 - Stability & Quality Assurance.

#### [MODIFY] [NEXT_TASK.md](file:///C:/Users/tejas/knight_os/docs/NEXT_TASK.md)
- Breakdown Sprint 8 into specific checklist items.

## Verification Plan

### Automated Tests
- `flutter test test/core/intelligence/planning_service_test.dart`
- `flutter test test/core/intelligence/reasoning_service_test.dart`
- `flutter test test/widget_test.dart`
- `flutter test` (Full suite verification)

### Static Analysis
- `flutter analyze`
