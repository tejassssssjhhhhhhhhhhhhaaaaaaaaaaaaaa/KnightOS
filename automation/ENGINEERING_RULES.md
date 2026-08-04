# KNIGHTOS ENGINEERING RULES

## Primary Objective

Complete KnightOS Version 5 until it is production-ready.

---

## Mandatory Rules

1. Never skip any milestone.
2. Never leave TODO, FIXME, placeholder, mock, or stub implementations.
3. Never remove existing functionality unless required to fix a defect.
4. Fix every compiler error before continuing.
5. Fix every analyzer warning that indicates a real issue.
6. Validate after every milestone.
7. Keep architecture clean and maintainable.
8. Do not duplicate logic.
9. Keep code production-ready at all times.
10. Keep all documentation synchronized with implementation.

---

## Validation Gate

After every milestone, perform:

- flutter clean (when required)
- flutter pub get (when required)
- flutter analyze
- flutter test
- Debug build
- Release build
- Regression verification
- Physical device verification

If any validation fails:

- Stop immediately.
- Fix every issue.
- Repeat validation.
- Continue only after every validation passes.

---

## Completion Rule

Version 5 is complete only when:

- Every planned milestone is complete.
- Every validation passes.
- No known defects remain.
- No regressions exist.
- Application is release-ready.
- Update all files inside the automation folder.
- Stop further implementation.
