# Development Workflow

## 1. Bug fixes
- Reproduce the issue before changing code.
- Keep the fix focused on the root cause.
- Preserve existing behavior outside the bug scope.
- Validate the fix with relevant tests or local verification.

## 2. New features
- Review existing architecture and patterns before implementation.
- Prefer reusable services, providers, and widgets.
- Keep feature logic organized and avoid duplicate implementations.
- Add or update tests when the new feature introduces meaningful behavior.

## 3. UI improvements
- Preserve the current visual language and app structure.
- Keep UI changes aligned with existing screens and widgets.
- Favor small adjustments over major visual rewrites.
- Verify that navigation and interactions remain stable.

## 4. Refactoring
- Refactor only when it improves maintainability without changing behavior.
- Preserve public interfaces and app functionality.
- Avoid large rewrites unless they are clearly justified.
- Keep refactors scoped and reviewable.

## 5. Documentation updates
- Update docs whenever architecture, workflow, or user-facing behavior changes.
- Keep documentation concise, practical, and aligned with the current codebase.
- Update CHANGELOG.md for user-visible changes.

## 6. Testing
- Run Flutter analyze before considering work complete.
- Add or update tests for meaningful feature or behavior changes.
- Prefer targeted checks over broad test churn.

## 7. Release preparation
- Confirm the target version in pubspec.yaml.
- Review the changelog and release notes.
- Build the APK and verify the artifact.
- Prepare the release tag and GitHub Release content.
