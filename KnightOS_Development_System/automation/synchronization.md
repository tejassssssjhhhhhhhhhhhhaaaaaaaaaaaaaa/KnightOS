# KnightOS Synchronization Protocol

## Mission
Ensure Platform Team, Product Team, Intelligence Team, and Mission Control remain synchronized throughout Version 5.

## Synchronization Authority
Mission Control is the synchronization authority.

## Team Requirements
Every engineering team must:
- Read `project_state.md` before starting work.
- Read `architecture.md` before implementing changes.
- Read `livestatus.md` before beginning a milestone.
- Report milestone progress and completion to Mission Control.
- Report blockers immediately.

## Synchronization Rules
- **Inter-team dependencies:** No team may begin Milestone N+1 until ALL three engineering teams complete Milestone N.
- **Validation:** Mission Control validates all milestone reports and resolve conflicts.
- **Locking:** Mission Control blocks premature milestone advancement.
- **History:** Mission Control records synchronization history in `project_state.md`.

## Conflict Handling
Mission Control will detect and resolve:
- Milestone mismatches between teams.
- Documentation mismatches.
- Architecture drift.
- Unfinished dependencies.
- Stale project state.

## Recovery Workflow
1. Pause affected teams.
2. Re-synchronize project state documents.
3. Re-run validation (`analyze`, `test`).
4. Resume only after synchronization succeeds.

## Synchronization Checklist
- [ ] `project_state.md` updated.
- [ ] `architecture.md` updated.
- [ ] `livestatus.md` updated.
- [ ] All team reports match current milestone.
- [ ] Regression testing passes.
