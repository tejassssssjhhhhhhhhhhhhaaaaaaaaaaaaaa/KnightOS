# KnightOS Release Automation

This directory contains the release automation toolkit for KnightOS.

## What it does
- bumps `pubspec.yaml` version using semantic versioning
- runs `flutter pub get`
- optionally runs `flutter analyze` and `flutter test`
- builds the Android release APK
- optionally creates a git tag
- optionally creates or updates a GitHub release and uploads the APK asset

## Quick start
1. Open a PowerShell terminal from the repository root.
2. Configure `scripts/config/release.json` as needed.
3. Run:
   ```powershell
   .\scripts\release.ps1
   ```
4. Follow the prompts to choose patch/minor/major version bumps and optional steps.

## Configuration
Edit `scripts/config/release.json` to customize:
- `githubRepository`: the GitHub owner/repo for releases
- `apkPath`: expected APK output location
- `defaultBranch`: main release branch
- `runAnalyze`: whether to offer `flutter analyze`
- `runTests`: whether to offer `flutter test`
- `createGitHubRelease`: whether to create a GitHub release
- `uploadApk`: whether to upload the APK asset
- `createGitTag`: whether to create a git tag
- `flutterCommand`: the Flutter CLI command path or alias

## Requirements
- Flutter SDK installed and on PATH
- Git installed and on PATH (for tag creation)
- GitHub CLI installed and authenticated (for GitHub release support)
- PowerShell execution policy allowing script execution or use `-ExecutionPolicy Bypass`

## Notes
- The release script uses `vMAJOR.MINOR.PATCH` tags.
- The app version in `pubspec.yaml` is updated to `MAJOR.MINOR.PATCH+BUILD`.
- GitHub release automation only runs when `gh` is installed and authenticated.
- If PowerShell execution is blocked, run PowerShell with `-ExecutionPolicy Bypass`.
