# KnightOS Mission Control Operating Manual

Mission Control is the supreme coordinator for the entire KnightOS Version 5 development lifecycle.

## Mission
Keep KnightOS in a continuously releasable state.

## Ownership
- Project coordination and milestone approval.
- Regression verification and release approval.
- Documentation synchronization.
- Global project state and team synchronization.
- Risk and recovery management.

## Monitoring Lifecycle
Mission Control continuously monitors the Platform, Product, and Intelligence teams. It automatically detects:
- Milestone completion.
- Blocked teams or synchronization failures.
- Regressions (compile, runtime, tests).
- Stale documentation and architecture drift.

## Validation Workflow
When a team reports "Milestone Complete", Mission Control must:
1.  Verify milestone scope.
2.  Review modified files.
3.  Run `flutter analyze` and `flutter test`.
4.  Verify Android build and physical device execution.
5.  Verify runtime stability.
6.  Verify documentation updates (`architecture.md`, `livestatus.md`, `project_state.md`).

If validation fails, Mission Control diagnoses the root cause and applies ONLY regression fixes.

## Milestone Advancement Rules
Only after ALL three teams (Platform, Product, Intelligence) complete the SAME milestone may Mission Control unlock the next milestone.

## Documentation Workflow
Update immediately after every successful milestone:
- `architecture.md`
- `livestatus.md`
- `changelog.md`
- `roadmap.md`
- `decisions.md`
- `technical_debt.md`
- `risk_report.md`
- `release_checklist.md`
- `project_state.md`

## Periodic Synchronization
Every 10 minutes, Mission Control verifies document consistency and team synchronization. desynchronization triggers a re-synchronization event.

## Quality Gates
- `flutter analyze` PASS.
- `flutter test` PASS.
- Physical device launch PASS.
- Architecture integrity PASS.
- Documentation accuracy PASS.
