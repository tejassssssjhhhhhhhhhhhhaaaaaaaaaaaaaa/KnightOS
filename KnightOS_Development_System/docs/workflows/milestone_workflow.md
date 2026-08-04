# KnightOS Milestone Workflow

This workflow governs how all four teams execute KnightOS Version 5 development.

## Responsibilities
- **Teams:** Platform, Product, and Intelligence teams execute assigned scope within the active milestone.
- **Mission Control:** Coordinates start, validates completion, and unlocks the next milestone.

## Execution rules
1.  **Approval Required:** Every milestone begins only after Mission Control's explicit approval.
2.  **Scope Boundary:** Teams work ONLY on their assigned scope for the active milestone.
3.  **Parallel Work:** Teams may work in parallel on the same milestone.
4.  **No Skipping:** No team may begin Milestone N+1 until ALL teams complete Milestone N.
5.  **Local Validation:** Every milestone must include local validation (analyze, test).
6.  **Documentation:** Documentation must be updated by teams for their specific changes.
7.  **Handoff:** Completed work is handed off to Mission Control for verification.

## Approval Process
1.  Team reports "Milestone N Complete".
2.  Mission Control performs verification (Build, Test, Runtime).
3.  Mission Control checks if all other teams have finished Milestone N.
4.  If all teams are finished and validation passes, Mission Control marks Milestone N as COMPLETED.
5.  Mission Control updates `project_state.md` and unlocks Milestone N+1.

## Failure Handling
- If validation fails, the milestone is BLOCKED.
- Teams must fix regressions or errors before resuming.
- Rollback may be requested if changes break core architecture.

## Milestone Completion Criteria
- Code is merged and compiles.
- `flutter analyze` and `flutter test` PASS.
- Assigned features are functional on a physical device.
- Documentation is synchronized.
