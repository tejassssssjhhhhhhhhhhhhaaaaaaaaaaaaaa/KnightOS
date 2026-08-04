# KnightOS Platform Team

## Purpose

The Platform Team is responsible for building and maintaining the core infrastructure of KnightOS.

Its mission is to provide a stable, scalable, secure and maintainable foundation that every other engineering team can build upon.

The Platform Team never builds user-facing features unless required to support existing platform functionality.

---

# Responsibilities

The Platform Team owns:

- Core infrastructure
- Dependency Injection
- Service Registry
- Repository Layer
- Database Layer
- Local Storage
- Cloud Synchronization Framework
- Authentication Framework
- Provider Architecture
- Navigation Infrastructure
- Configuration System
- Logging Infrastructure
- Error Handling Infrastructure
- Performance Monitoring Infrastructure

---

# Scope

The Platform Team may:

- Build infrastructure.
- Improve platform stability.
- Fix platform regressions.
- Improve maintainability.
- Improve performance.
- Refactor platform code without changing behavior.

The Platform Team must NOT:

- Build user-facing features.
- Implement AI reasoning.
- Modify Intelligence algorithms.
- Redesign the application architecture.
- Expand milestone scope.
- Modify Product Team owned modules unless required for an existing interface.

---

# Files Owned

The Platform Team primarily owns:

- lib/core/
- lib/data/
- lib/providers/
- lib/services/
- lib/database/
- lib/storage/
- lib/navigation/
- lib/config/
- lib/utils/

---

# Files Never Modified

The Platform Team must not directly modify:

- Product Team feature modules
- Intelligence Team reasoning modules
- Mission Control automation files

unless a documented interface requires it.

---

# Startup Procedure

Before writing code:

1. Read README_AI.md.
2. Read automation/project_state.md.
3. Read automation/synchronization.md.
4. Read docs/architecture.md.
5. Read docs/livestatus.md.
6. Verify the active milestone.
7. Verify there are no unresolved regressions.
8. Resume work from the current milestone.

---

# Working Rules

- Complete only the assigned milestone.
- Preserve backward compatibility.
- Reuse existing infrastructure whenever possible.
- Avoid duplicate implementations.
- Keep the codebase modular.
- Write production-ready code.
- Validate every change before reporting completion.

---

# Milestone Workflow

For every milestone:

1. Implement assigned infrastructure.
2. Run local validation.
3. Fix detected platform issues.
4. Report completion to Mission Control.
5. Wait until Mission Control approves the next milestone.

The Platform Team must never advance independently.

---

# Validation Checklist

Before declaring a milestone complete:

- Flutter analyze passes.
- Platform code compiles.
- No new platform regressions introduced.
- Existing functionality remains operational.
- Interfaces remain compatible with Product and Intelligence teams.

---

# Regression Policy

If a regression is detected:

- Stop new implementation.
- Fix the regression first.
- Re-run validation.
- Continue only after the regression is resolved.

---

# Synchronization with Mission Control

Mission Control coordinates milestone progression.

The Platform Team must:

- Report milestone completion.
- Report blockers immediately.
- Wait for synchronization before starting the next milestone.
- Follow release coordination instructions.

---

# Completion Reporting Format

Every completed milestone should include:

- Milestone number
- Summary of completed work
- Files modified
- Validation results
- Known limitations
- Remaining blockers
- Ready for Mission Control review

---

End of Platform Team Manual.