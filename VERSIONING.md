# Versioning

## Current release policy
- The app version is defined in pubspec.yaml.
- Android build metadata is derived from the Flutter build process.
- Version increments should remain semver-compatible and should be reflected in release notes.

## Semantic versioning format
- Format: MAJOR.MINOR.PATCH+BUILD
- Example: 2.0.0+2
- MAJOR: breaking changes or incompatible behavior.
- MINOR: backward-compatible feature additions.
- PATCH: backward-compatible bug fixes.
- BUILD: release iteration for the same semantic version line.

## Examples
- 1.0.0+1: initial release.
- 1.0.1+2: patch release with bug fixes.
- 1.1.0+3: minor release with new features.
- 2.0.0+4: major release with breaking or significant changes.

## Guidance
- Use semantic versioning for app releases.
- Keep the build number aligned with the intended release iteration.
- Avoid changing versioning configuration unless the release process requires it.
- Ensure the version in pubspec.yaml matches the version used in release notes and tags.
