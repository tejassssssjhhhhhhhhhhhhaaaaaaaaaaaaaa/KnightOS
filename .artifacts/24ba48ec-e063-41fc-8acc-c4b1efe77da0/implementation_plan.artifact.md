# Implementation Plan - Version 4 Stabilization Sprint

This plan addresses reported bugs and UX issues to make Knight OS Version 4 production-ready.

## User Review Required

> [!IMPORTANT]
> This sprint modifies the local storage directory logic to ensure data persistence across updates. It also reconciles duplicate Voice Service implementations.

## Proposed Changes

### 1. Account Persistence (Issue 1)
- **Root Cause**: `LocalDatabase` (used for legacy auth) switched to `getApplicationSupportDirectory()` on Android, while previous versions and the new `KnightDatabase` (Drift) use `getApplicationDocumentsDirectory()`. This results in missing `auth_accounts.json` and `auth_session.json` after an update.
- **Fix**: Update `LocalDatabase` to check both directories. Implement an automatic one-time migration of files from `Documents` to `Support` if they are found in the old location but missing in the new one.

### 2. Voice Interaction in Onboarding (Issue 2)
- **Root Cause**: `VoiceService` in `features/voice` returns an empty string if called with an empty prompt (which `OnboardingFlowScreen` does). Additionally, there are two competing `VoiceService` classes.
- **Fix**:
    - Merge `features/voice/voice_service.dart` logic into the core `VoiceService`.
    - Update `OnboardingFlowScreen` to use the `voiceControllerProvider` instead of manual instantiation.
    - Ensure `VoiceService` provides a meaningful simulated transcript for onboarding steps.

### 3. Navigation Stability (Issues 3 & 4)
- **Root Cause**:
    - `AuthScreen` navigates to `AppRoutes.launch` (`/launch`), which is defined in `AppRoutes` but missing from `AppRouter.routes`.
    - `SettingsScreen` lacks a `title` in its `KnightPageScaffold`, resulting in no `AppBar`. Its manual header uses `Navigator.pop()`, which may fail or behave unexpectedly when combined with `GoRouter` shell routes.
- **Fix**:
    - Add `AppRoutes.launch` to `AppRouter` (mapping to `HomeScreen` or a transition screen).
    - Update `SettingsScreen` to use `title: 'Settings'` in `KnightPageScaffold` for a consistent `AppBar`.
    - Replace `Navigator.pop()` with `context.pop()` in `SettingsScreen`.
    - Ensure all routes in `AppRouter` match `AppRoutes` constants.

## Verification Plan

### Automated Tests
- `flutter test test/storage/local_database_migration_test.dart` (New test for directory migration)
- `flutter test test/auth_flow_test.dart`
- `flutter test test/widget_test.dart`
- `flutter test` (Full suite)

### Manual Verification
- Verify that logging in with an "old" account (simulated by placing files in Documents) works.
- Verify "Skip" during onboarding leads to the Home screen.
- Verify Settings icon leads to the Settings screen.
- Verify "Voice answer" in onboarding updates the profile.
