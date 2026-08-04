# KnightOS Release Workflow

This workflow defines the process for approving milestones and final production releases.

## Authority
Mission Control is the ONLY authority allowed to approve a milestone or a release.

## Approval Gates
Before any release or milestone completion approval, Mission Control must verify:
1.  **Engineering Completion:** Platform, Product, and Intelligence teams all report Milestone N complete.
2.  **Quality Standards:** `flutter analyze` and `flutter test` PASS.
3.  **Hardware Validation:** Successful execution on a physical Android device.
4.  **Operational Stability:** No startup crashes or significant performance degradation.
5.  **Documentation Audit:** All core docs (`architecture.md`, `roadmap.md`, etc.) are updated.

## Blocking Conditions
Validation failure in ANY gate blocks the release. Mission Control must:
- Diagnose root cause.
- Apply regression fixes.
- If fixes are beyond MC's scope, notify teams and wait for a fix.

## Final Release Checklist
- [ ] Milestone N code is stable.
- [ ] All team manuals are synchronized.
- [ ] `changelog.md` includes all changes since the last release.
- [ ] `risk_report.md` shows acceptable risk levels.
- [ ] `release_checklist.md` is fully signed off.

## Approval Decision
When all checks pass, Mission Control:
1.  Marks milestone/release as APPROVED.
2.  Unlocks the next milestone in `project_state.md`.
3.  Publishes the release summary to `changelog.md`.
