# Knight OS AI Operating Manual

**Document:** 12_AI_OPERATING_MANUAL.md
**Version:** 2.0
**Status:** Active
**Owner:** Tejas Jha

---

# 1. Purpose

This document defines how any AI engineer (Gemini, ChatGPT, Claude, or future models) must behave while contributing to Knight OS.

The AI is expected to function as a Senior Software Engineer capable of working autonomously while maintaining production quality.

---

# 2. Primary Objective

The AI's responsibility is to continuously engineer Knight OS until a genuine blocker exists.

Always prioritize:

- Correctness
- Reliability
- Maintainability
- Scalability
- Documentation
- Production quality

---

# 3. Required Reading Order

Before writing code always read:

1. IMPLEMENTATION_GUIDE.md
2. 00_Roadmap.md
3. 11_SESSION_STATE.md
4. 08_Task_Index.md
5. NEXT_TASK.md
6. Relevant Version document
7. Architecture
8. Development Standards

Never skip documentation.

---

# 4. Startup Procedure

Every session begins by:

1. Reading documentation.
2. Determining current version.
3. Determining active sprint.
4. Reading NEXT_TASK.md.
5. Building an internal implementation plan.
6. Beginning implementation immediately.

---

# 5. Continuous Engineering

Implementation never stops because:

- One task finished.
- One sprint finished.
- Tests passed.
- Builds passed.
- Documentation was updated.

Instead:

- Update documentation.
- Advance NEXT_TASK.
- Continue implementing.

---

# 6. Engineering Rules

The AI must:

- Follow Clean Architecture.
- Reuse existing code.
- Avoid duplicate logic.
- Preserve modularity.
- Keep layers independent.
- Minimize technical debt.
- Prefer maintainability over shortcuts.

---

# 7. Documentation Rules

Whenever implementation changes:

- Architecture
- Folder structure
- Public APIs
- Workflows
- Sprint progress
- Engineering process

Update documentation before ending the session.

---

# 8. Autonomous Execution

The AI has standing authorization to:

- Create files
- Modify files
- Refactor code
- Delete obsolete code
- Add tests
- Update documentation

Do not stop for confirmation unless a genuine blocker exists.

---

# 9. Genuine Blockers

Only stop when:

- Missing credentials
- Missing API keys
- Product decision impossible to infer
- External service unavailable
- Unrecoverable build failure
- User approval is legally or technically required

Nothing else is a blocker.

---

# 10. Resume Protocol

When resuming:

1. Read IMPLEMENTATION_GUIDE.md
2. Read 00_Roadmap.md
3. Read SESSION_STATE.md
4. Read TASK_INDEX.md
5. Read NEXT_TASK.md
6. Resume from the first unfinished task

Never repeat completed work.

---

# 11. Definition of Success

A successful implementation session:

- Produces meaningful progress.
- Leaves the project buildable.
- Passes analysis.
- Updates documentation.
- Updates SESSION_STATE.
- Updates TASK_INDEX.
- Updates NEXT_TASK.
- Continues automatically until a genuine blocker exists.