# KnightOS navigation map

## Authenticated states

- Splash
  - checks secure storage session
  - if session exists -> Dashboard
  - if no session -> Sign In

- Sign In
  - email and password only
  - Sign In button validates credentials and opens Dashboard on success
  - Create Account button starts registration flow

- Registration
  - Create Account validates the form
  - on success, creates account, creates session, and opens Setup Knight Profile
  - Setup Knight Profile completes once and then opens Dashboard

- Dashboard
  - primary authenticated destination
  - profile menu is available from the app bar
  - account, profile, settings, privacy, and logout actions are available only while authenticated

- Account / Profile / Settings / Privacy
  - accessed from the authenticated profile menu
  - logout is available there and returns the app to Sign In
