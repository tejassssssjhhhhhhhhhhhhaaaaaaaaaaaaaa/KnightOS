# Category 1: Home + App Branding + Time-of-Day Experience

Implement a premium, calm, and context-aware Home experience for KNIGHT, supporting five time-based modes and adhering to the strict visual identity guidelines.

## User Review Required

> [!IMPORTANT]
> The implementation will unify the branding across the app, replacing generic icons with the `KnightCircuitShield` logo.
> Time-of-day modes will automatically adjust the interface based on the user's local time.

## Proposed Changes

### [Branding & Identity]

#### [MODIFY] [knight_circuit_shield.dart](file:///C:/Users/tejas/knight_os/lib/core/design_system/widgets/knight_circuit_shield.dart)
Ensure the shield painter uses brand-approved colors and supports the new 5-mode `KnightDayPeriod`.

#### [MODIFY] [knight_launch_screen.dart](file:///C:/Users/tejas/knight_os/lib/app/screens/knight_launch_screen.dart)
Replace `Icons.auto_awesome_rounded` with `KnightCircuitShield`. Unify greeting logic with `GreetingService`.

#### [MODIFY] [styles.xml](file:///C:/Users/tejas/knight_os/android/app/src/main/res/values/styles.xml)
Update launch theme to potentially include the logo if possible (or keep it clean as per Flutter best practices but ensure smooth transition).

---

### [Time-of-Day Logic]

#### [MODIFY] [greeting_service.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/services/greeting_service.dart)
Update `KnightDayPeriod` enum to include `morning`, `day`, `evening`, `night`. Update ranges:
- Morning: 5:00 AM – 11:00 AM
- Day: 11:00 AM – 5:00 PM
- Evening: 5:00 PM – 9:00 PM
- Night: 9:00 PM – 5:00 AM

#### [NEW] [focus_mode_provider.dart](file:///C:/Users/tejas/knight_os/lib/core/providers/focus_mode_provider.dart)
Add a state provider for `FocusMode` to override the time-based periods.

#### [MODIFY] [knight_context_models.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/knight_context_models.dart)
Add `KnightDayPeriod period` and `bool isFocusMode` to `KnightContext`.

#### [MODIFY] [knight_context_provider.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/knight_context_provider.dart)
Inject the period and focus mode into the built context.

---

### [Home Screen Evolution]

#### [MODIFY] [home_screen.dart](file:///C:/Users/tejas/knight_os/lib/app/home_screen.dart)
Implement mode-specific layouts:
- **Morning**: Spacious, date, top priority, health snapshot.
- **Day**: Action-oriented, active tasks, quick actions.
- **Focus**: Minimalist, single task focus, timer.
- **Evening**: Completion summary, tomorrow's prep.
- **Night**: Dark, extremely calm, sleep/wind-down info.

#### [MODIFY] [priority_engine.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/services/priority_engine.dart)
Remove unauthorized hardcoded colors. Use brand-derived colors based on the current mode's accent.

#### [MODIFY] [usage_transparency_widget.dart](file:///C:/Users/tejas/knight_os/lib/core/design_system/widgets/usage_transparency_widget.dart)
Ensure it displays real quota information without "Premium" upselling.

---

### [Verification & Testing]

#### [NEW] [home_category_test.dart](file:///C:/Users/tejas/knight_os/test/features/home/home_category_test.dart)
Widget tests for each time mode and empty states.

## Verification Plan

### Automated Tests
- `flutter test test/features/home/home_category_test.dart`
- `flutter analyze`

### Manual Verification
- Deploy to Redmi Pad.
- Test time-based transitions by overriding system time or using debug overrides.
- Verify Universal Search opens and navigates correctly.
- Verify Knight AI access from Home.
- Audit colors against the `KnightCircuitShield` material colors.
