# Copilot Instructions for KnightOS

## Project intent
- This repository is a Flutter-based personal operating system app with onboarding, auth, dashboards, feature trackers, settings, and OTA update support.
- Preserve existing architecture, behavior, and UI patterns unless a change is explicitly requested and justified.

## Mandatory workflow for every chat
- Read the relevant code and project documentation before making changes.
- Understand the current architecture, routing, state management, storage, and update flow before editing.
- Search for existing reusable services, repositories, providers, widgets, or utilities before creating new code.
- Do not guess, rewrite, or replace working implementations without explicit instruction.
- Do not delete or rename working features unless the request clearly requires it.
- Prefer small, targeted changes that fit the existing structure.
- Preserve backwards compatibility.
- Keep UI consistent with the current Material design language and screen patterns.
- Avoid introducing large refactors or new architecture layers without clear necessity.

## Documentation and release expectations
- Update documentation whenever architecture, workflow, or project behavior changes.
- Update CHANGELOG.md whenever a user-visible feature or behavior changes.
- Follow semantic versioning conventions.
- Keep release changes safe, reversible, and well documented.

## Engineering standards
- Reuse existing services, repositories, providers, and helpers before creating duplicates.
- Avoid duplicate logic.
- Keep providers thin and UI-facing; move reusable business logic into services or repositories.
- Keep feature logic organized under lib/features and shared infrastructure under lib/core.
- Respect the existing Riverpod + GoRouter pattern.
- Do not change package names, application IDs, or storage schemas unless explicitly requested.
- Suggest relevant tests for new features or meaningful behavior changes.
- Run Flutter analyze before considering work complete.
- If a change affects release behavior, confirm the release workflow documentation is updated as well.

## Quality bar
- Validate changes with the relevant Flutter analysis/tests when practical.
- Do not introduce unrelated changes during bug fixes.
- Keep changes focused on the task at hand.
- If something is unclear, inspect the codebase rather than making assumptions.
