# Implementation Plan - Phase 4: Root Cause Repair (Priority 1 & 2)

This plan covers the first two priorities of the Root Cause Repair phase.

## User Review Required

> [!IMPORTANT]
> I will be modifying the Android build configuration to resolve an environment conflict and the Welcome screen's theme to fix visibility issues. These are foundational repairs required before addressing runtime rendering failures.

## Priority 1: Android Build Reliability
Resolve the conflict between `ANDROID_PREFS_ROOT` and `ANDROID_USER_HOME` environment variables that causes AGP 9.x to fail.

### Proposed Changes
#### [MODIFY] [android/settings.gradle.kts](file:///C:/Users/tejas/knight_os/android/settings.gradle.kts)
- Add a pre-check at the very top of the script to clear the `ANDROID_PREFS_ROOT` system property if it conflicts with `ANDROID_USER_HOME`. This ensures that the build process remains repeatable even if the host environment has both variables set.

---

## Priority 2: Welcome Screen Visibility
Fix the issue where the Welcome screen is nearly invisible (white text on white background) on real devices.

### Root Cause Analysis
The `AndroidManifest.xml` uses `Theme.Light.NoTitleBar` as the base for `NormalTheme`. While the app's `HomeScreen` and other features might be designed for a dark "Horizon" theme, the native theme is forcing light defaults. If the Flutter code doesn't explicitly set a dark background for the `WelcomeScreen`'s `Scaffold`, it defaults to the theme's background (white), while the app's standard text styles might be defaulting to light colors in some contexts or being overridden incorrectly.

Actually, the `WelcomeScreen` likely uses `LunarHorizonBackground` which is atmospheric. If the base theme is light, the atmospheric glow might be too faint or the text might be white.

### Proposed Changes
#### [MODIFY] [android/app/src/main/res/values/styles.xml](file:///C:/Users/tejas/knight_os/android/app/src/main/res/values/styles.xml)
- Change `NormalTheme` parent to `@android:style/Theme.Black.NoTitleBar` (or a Material Dark equivalent) to ensure the system-level background is dark, aligning with the "Horizon" design system.

#### [MODIFY] [android/app/src/main/AndroidManifest.xml](file:///C:/Users/tejas/knight_os/android/app/src/main/AndroidManifest.xml)
- Verify `android:theme` and `io.flutter.embedding.android.NormalTheme` metadata.

---

## Verification Plan

### Automated Verification
- **Priority 1**: Run `flutter build bundle` followed by a Gradle command (`./gradlew help`) without manual environment unsetting to confirm the build no longer fails due to the preferences conflict.
- **Priority 2**: Verify the static analysis passes.

### Real-Device Verification
- **Priority 2**: Launch the app on the connected device. Verify that the Welcome screen is fully visible with clear contrast between text and background.
- Capture a screenshot to confirm visibility.
