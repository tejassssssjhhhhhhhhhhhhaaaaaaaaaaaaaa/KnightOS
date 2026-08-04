# KnightOS Testing Workflow

This workflow defines the validation requirements for every engineering team before milestone handoff.

## Team Responsibilities (Local Validation)
Every engineering team must complete these steps before reporting a milestone complete:
1.  **flutter analyze:** Zero errors, zero new warnings.
2.  **flutter test:** All unit and widget tests must pass.
3.  **Build Check:** Project builds successfully for Android.
4.  **No New Technical Debt:** Ensure no temporary hacks are left in code.
5.  **Integration Check:** Verify that existing functionality continues to work alongside new changes.

## Mission Control Validation
After handoff, Mission Control performs:
- Full regression testing.
- Physical Android device performance validation.
- AI system reasoning accuracy validation.
- Documentation-code synchronization audit.

## Testing Categories
- **Static Analysis:** Linting and code style.
- **Unit Tests:** Business logic and model validation.
- **Widget Tests:** UI component stability.
- **Integration Tests:** End-to-end user flows.
- **Physical Device Tests:** Hardware interaction and real-world performance.
- **AI validation:** Reasoning, planning, and memory retrieval precision.

## Reporting Format
Teams must report validation results using the following format:
```
Milestone: N
Result: PASS/FAIL
Errors Found: [List or None]
Warnings Found: [List or None]
Test Coverage: [% or Summary]
```
