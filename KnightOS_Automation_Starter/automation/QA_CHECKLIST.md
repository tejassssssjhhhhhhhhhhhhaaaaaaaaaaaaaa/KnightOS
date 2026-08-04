# QUALITY ASSURANCE CHECKLIST

## Static Analysis

- [ ] flutter analyze passes
- [ ] No warnings introduced
- [ ] No deprecated APIs introduced

---

## Automated Testing

- [ ] flutter test passes
- [ ] Widget tests pass
- [ ] Integration tests pass (if available)

---

## Build Validation

- [ ] Debug APK builds successfully
- [ ] Release APK builds successfully
- [ ] No build warnings

---

## Functional Validation

- [ ] New feature works correctly
- [ ] Existing features still work
- [ ] Navigation verified
- [ ] State management verified
- [ ] Error handling verified

---

## Physical Device Validation

- [ ] App launches
- [ ] No crashes
- [ ] UI renders correctly
- [ ] Performance acceptable
- [ ] Logs reviewed
- [ ] No regressions observed

---

## Completion Gate

A milestone cannot be marked COMPLETE until every item above has been checked.