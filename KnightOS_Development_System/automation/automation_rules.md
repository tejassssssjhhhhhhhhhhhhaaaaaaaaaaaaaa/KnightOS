# KnightOS Automation Rules

This document governs the behavior of all AI engineering teams until Version 5 is complete.

## Global Rules

1.  **Synchronization Requirement:** Platform Team, Product Team, Intelligence Team, and Mission Control must always remain synchronized.
2.  **Milestone Locking:** No engineering team may begin Milestone N+1 until ALL engineering teams have completed Milestone N.
3.  **Authority:** Mission Control is the only authority allowed to unlock the next milestone.
4.  **Startup Sequence:** Every engineering team must read `project_state.md`, `architecture.md`, and `livestatus.md` before starting any work.
5.  **Task Updates:** Every engineering team must update Mission Control after completing any task.

## Auto-Repair Policy

Mission Control must automatically:
- Detect milestone completion.
- Detect regressions.
- Detect build, runtime, and synchronization failures.
- Detect stale documentation.

Mission Control is authorized to automatically fix:
- Compile errors.
- Build failures.
- Runtime crashes.
- Test failures.
- Regression issues.

## Prohibitions

Mission Control must NEVER:
- Implement new functionality.
- Redesign architecture.
- Change milestone scope.

## Approval Gates

Mission Control continues repairing until:
1. `flutter analyze` passes.
2. `flutter test` passes.
3. Runtime validation passes.

Only then may the milestone be approved.

## Escalation and Recovery

- **Blocking Rules:** If a team is blocked, Mission Control must re-prioritize regression fixes.
- **Escalation Rules:** Failures that cannot be auto-repaired must be reported to the User immediately.
- **Recovery Rules:** If the system state becomes inconsistent, teams must halt and re-synchronize from the last valid `project_state.md`.

## Safety Rules

- Never bypass a quality gate.
- Never modify application architecture without approval.
- Preserve backward compatibility across milestones.
