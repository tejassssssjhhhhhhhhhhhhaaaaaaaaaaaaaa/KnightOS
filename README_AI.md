# KnightOS Version 5 AI Bootstrap

## Purpose

This document is the entry point for every AI engineering session working on KnightOS Version 5.

Every new AI session MUST begin here before modifying any source code.

---

# Startup Sequence

Read the following files in this exact order:

1. KnightOS_Development_System/automation/project_state.md
2. KnightOS_Development_System/automation/automation_rules.md
3. KnightOS_Development_System/automation/synchronization.md
4. KnightOS_Development_System/automation/mission_control.md

5. KnightOS_Development_System/docs/architecture.md
6. KnightOS_Development_System/docs/livestatus.md
7. KnightOS_Development_System/docs/roadmap.md

8. KnightOS_Development_System/docs/workflows/milestone_workflow.md
9. KnightOS_Development_System/docs/workflows/regression_workflow.md
10. KnightOS_Development_System/docs/workflows/testing_workflow.md
11. KnightOS_Development_System/docs/workflows/release_workflow.md
12. KnightOS_Development_System/docs/workflows/documentation_workflow.md

13. KnightOS_Development_System/docs/teams/platform_team.md
14. KnightOS_Development_System/docs/teams/product_team.md
15. KnightOS_Development_System/docs/teams/intelligence_team.md
16. KnightOS_Development_System/docs/teams/mission_control.md

17. KnightOS_Development_System/docs/prompts/tab1_prompt.md
18. KnightOS_Development_System/docs/prompts/tab2_prompt.md
19. KnightOS_Development_System/docs/prompts/tab3_prompt.md
20. KnightOS_Development_System/docs/prompts/tab4_prompt.md

---

# Determine

After reading all documentation determine:

- Current Version
- Current Milestone
- Current Sprint
- Current Build Status
- Current Regression Status
- Current Release Readiness
- Current Team Status
- Current Blockers
- Current Priorities

---

# Development Rules

- Resume from the CURRENT milestone.
- Never restart completed milestones.
- Never redesign architecture.
- Never modify completed work unless fixing regressions.
- Never implement work outside the active milestone.
- Keep all documentation synchronized.
- Follow Mission Control approval rules.
- Wait for milestone approval before advancing.

---

# Documentation

Always keep synchronized:

- architecture.md
- livestatus.md
- roadmap.md
- changelog.md
- decisions.md
- technical_debt.md
- risk_report.md
- release_checklist.md
- project_state.md

---

# Startup Checklist

Before writing code:

- Read all required documentation.
- Determine current milestone.
- Verify project state.
- Verify synchronization state.
- Verify current blockers.
- Verify assigned scope.
- Resume work.
- Report milestone completion to Mission Control.

End of bootstrap.