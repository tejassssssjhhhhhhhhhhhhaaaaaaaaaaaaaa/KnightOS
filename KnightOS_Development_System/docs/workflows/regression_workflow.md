# KnightOS Regression Workflow

This workflow defines how Mission Control ensures new development does not break previously completed milestones.

## Trigger Conditions
- Regression testing begins only after ALL engineering teams report completion of the current milestone.
- Triggered automatically on every PR or merge request.

## Validation Sequence
Mission Control must verify every previous milestone from Version 5 Milestone 1 through the current one:
1.  **Static Analysis:** Run `flutter analyze`.
2.  **Unit & Widget Testing:** Run `flutter test`.
3.  **Physical Validation:** Launch app on Android hardware.
4.  **Specialized Detection:**
    - Detect UI regressions (layout shifts, broken widgets).
    - Detect performance regressions (increased latency, frame drops).
    - Detect AI reasoning regressions (incorrect or degraded planning/reasoning).
    - Detect resource regressions (memory leaks, database corruption).

## Auto-Repair Policy
Mission Control is authorized to:
- Apply minimum code fixes for compile errors or test failures.
- Fix broken imports or dependency mismatches.
- Revert changes that violate the fixed architecture.

## Approval Rules
- **Exit Criteria:** All regression checks must PASS.
- **Blocking:** Any detected regression blocks milestone approval and release.

## Rollback Policy
If a regression cannot be fixed with minimum changes, Mission Control will roll back the offending team's milestone implementation and request a re-implementation.
