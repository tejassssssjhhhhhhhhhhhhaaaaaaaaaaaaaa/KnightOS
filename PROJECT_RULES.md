# Project Rules

## Core principles
- Preserve the current application architecture and user experience.
- Prefer incremental fixes over broad rewrites.
- Keep features and screens working unless a change explicitly requires modification.
- Avoid breaking storage, navigation, auth, or OTA flows.

## Coding standards
- Write clear, readable, maintainable Dart code.
- Follow existing naming and formatting patterns in the repository.
- Keep functions and classes focused on a single responsibility.
- Avoid unnecessary abstraction when a simple solution fits the current architecture.

## Folder organization
- UI code belongs in lib/app and lib/features.
- Shared infrastructure belongs in lib/core.
- Keep feature-specific logic under the relevant feature directory.
- Prefer existing folders over creating new top-level architecture layers.

## Naming conventions
- Use descriptive names for classes, methods, providers, repositories, and files.
- Keep names consistent with the surrounding codebase.
- Prefer explicit names over short abbreviations.

## Reuse-first policy
- Reuse existing repositories, services, providers, widgets, and helpers before introducing new code.
- Avoid duplicate logic, especially for validation, storage, navigation, and update handling.
- If a repeated pattern appears, look for a shared abstraction before adding a new one.

## Performance expectations
- Keep UI rendering efficient and avoid repeated expensive work.
- Avoid unnecessary rebuilds and redundant storage calls.
- Be mindful of startup cost, async work, and memory usage.

## Error handling
- Handle failures gracefully and preserve user-facing stability.
- Surface actionable errors without exposing implementation details unnecessarily.
- Keep error states consistent with the existing UI and service patterns.

## Logging guidelines
- Use logging sparingly and only where it improves debugging or release support.
- Keep logs useful and concise.
- Do not log sensitive information.

## Change policy
- Do not change package names, app IDs, or storage schemas unless explicitly requested.
- Do not remove or rename existing features without strong justification.
- Keep changes scoped to the task at hand.
