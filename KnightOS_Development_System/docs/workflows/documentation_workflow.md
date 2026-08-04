# KnightOS Documentation Workflow

## Mission
Ensure all project documentation remains synchronized with the actual codebase throughout Version 5 development.

## Ownership
Mission Control owns the integrity of project documentation, but every team is responsible for updating the files they modify.

## Core Documents
- `architecture.md`
- `livestatus.md`
- `changelog.md`
- `roadmap.md`
- `decisions.md`
- `technical_debt.md`
- `risk_report.md`
- `release_checklist.md`
- `project_state.md`

## Documentation Lifecycle
1.  **Work Start:** Team reads current docs to understand context.
2.  **Implementation:** Team documents changes as they occur.
3.  **Completion:** Team performs final doc update for the milestone.
4.  **Verification:** Mission Control audits docs against code changes.
5.  **Synchronization:** Mission Control updates global status docs.

## Update Rules
- **architecture.md:** Reflect current system design. Remove obsolete components.
- **livestatus.md:** Real-time engineering status and blockers.
- **changelog.md:** Record every feature, fix, and breaking change.
- **decisions.md:** Log date, reason, and impact of architectural choices.
- **project_state.md:** The source of truth for milestone progress and synchronization.

## Documentation Quality Gates
- No dead links.
- No stale "TODO" notes in core docs.
- Version numbers match across all files.
- Code snippets (if any) match current implementation.
