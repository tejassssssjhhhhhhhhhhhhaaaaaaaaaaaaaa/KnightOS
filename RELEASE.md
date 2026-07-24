# KnightOS Releases and OTA Updates

## Publish a release

1. Update `version:` in `pubspec.yaml` to the next semantic version and increment the build number after `+`.
2. Build the release APK with `flutter build apk --release`.
3. Create a Git tag matching the version, with or without a leading `v` (for example `v2.1.0`).
4. Create a GitHub Release for that tag and upload the generated APK as an asset whose filename contains `apk` (for example `app-release.apk`).
5. Add release notes. The app displays the first five non-empty lines.

## Versioning rules

Use `MAJOR.MINOR.PATCH+BUILD` in `pubspec.yaml`. Increment `PATCH` for compatible fixes, `MINOR` for backward-compatible features, and `MAJOR` for breaking changes. Increment `BUILD` for every Android APK build. OTA compares only `MAJOR.MINOR.PATCH`; the build number does not make an otherwise equal version update available.

## OTA detection

KnightOS calls `GET https://api.github.com/repos/tejassssssjhhhhhhhhhhhhaaaaaaaaaaaaaa/KnightOS/releases/latest`. It reads the release tag, publication timestamp, body, and the first release asset whose name contains `apk`. Versions are normalized by removing an optional `v`, build metadata, and prerelease suffixes, then compared numerically by major, minor, and patch. A newer release is shown only when it has a valid APK asset. The asset is downloaded over HTTPS, checked for a non-empty ZIP/APK header, and opened with Android's package installer. Android may require the user to allow this app to install unknown apps.

Never publish a release without a valid semantic tag and an APK asset.