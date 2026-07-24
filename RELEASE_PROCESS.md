# Release Process

## 1. Build prerequisites
- Ensure the Flutter SDK is installed and accessible.
- Ensure Android build tools and SDK paths are configured.
- Confirm the target environment is the intended release machine.

## 2. Version increment rules
- Update the app version in pubspec.yaml before every release.
- Follow semantic versioning: MAJOR.MINOR.PATCH+BUILD.
- Use a patch bump for backward-compatible fixes.
- Use a minor bump for backward-compatible feature additions.
- Use a major bump for breaking changes.
- Update the build number when a new artifact is generated for the same release line.
- Use `scripts/release.ps1` to automate version bumping, validation, APK generation, and optional GitHub release workflows.

## 3. Release checklist
- Confirm the target version in pubspec.yaml.
- Confirm Android version metadata matches the release intent.
- Review pending changes and ensure they are intentional.
- Update CHANGELOG.md for user-visible changes.
- Verify documentation stays aligned with current architecture and workflow.
- Run Flutter analyze.
- Run Flutter clean.
- Run Flutter pub get.
- Run Flutter build apk --release.
- Confirm the generated APK artifact exists and is the expected build.
- For automated releases, push the change to main and tag the release with the matching vMAJOR.MINOR.PATCH tag to trigger the GitHub Actions pipeline.

## 4. Git commit conventions
- Use concise, descriptive commit messages.
- Prefer present-tense summaries such as: "Fix OTA refresh state".
- Group related changes into one commit when practical.
- Avoid mixing unrelated fixes in one release commit.

## 5. Git tag conventions
- Use tags in the form vMAJOR.MINOR.PATCH or vMAJOR.MINOR.PATCH+BUILD where appropriate.
- Create a tag only after the release has been built and verified.
- Keep tags aligned with the version in pubspec.yaml.

## 6. GitHub Release creation
- Create a GitHub Release from the verified tag.
- Use the release title matching the version number.
- Include a short summary of key changes.
- Attach the release APK artifact when appropriate.
- The GitHub Actions workflow now creates the GitHub Release automatically for version tags and uploads the built APK as a release asset when the validation steps pass.

## 7. Release notes generation
- Summarize user-visible changes clearly and briefly.
- Include bug fixes, new capabilities, and any known limitations.
- Reference the changelog section for the release line.

## 8. APK and AAB build process
- Build the Android APK with Flutter build apk --release.
- If an Android App Bundle is required, build it with Flutter build appbundle.
- Store the produced artifacts in a known release location.
- Verify the artifact version metadata before publishing.

## 9. Rollback procedure
- If a release has critical issues, stop distribution immediately.
- Revert to the previous known-good tag or commit.
- Rebuild and publish the rollback artifact with a new patch version if needed.
- Document the rollback in the changelog and release notes.

## 10. Post-release verification
- Install the released APK on a test device if possible.
- Confirm the expected version is shown by the app.
- Confirm critical flows still work after installation.
- Monitor user feedback and capture follow-up issues.
