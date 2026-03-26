# Synor Page Transition Audit

## Audit Summary
- Root-stage transitions were inconsistent: `SynorApp` used one-off `AnimatedSwitcher` recipes with hardcoded timing and larger slide offsets than the rest of the app.
- Shell navigation mixed two behaviors: tab changes and full-screen overlay screens were both routed through the same content switcher, so Messages and Smart Alarm felt like hard content swaps rather than polished top-level transitions.
- Services, Schedule, Studies, Alarm mode changes, and Sign Up steps each used separate local switcher curves and offsets, which made motion feel fragmented.
- Several overlays and sheets only animated on entry through local `TweenAnimationBuilder` transforms and then disappeared abruptly on close because visibility was controlled by immediate conditional rendering.
- The success modal used `easeOutBack`, which read as slightly theatrical compared with the approved restrained Synor motion language.
- Existing top feedback banners already used a premium fade/slide treatment and only needed auditing, not redesign.

## Transition Strategy
- Added shared transition tokens in `SynorMotion` for page and overlay timing plus consistent in/out curves.
- Added reusable shared motion helpers in `lib/shared/widgets/motion.dart`:
  - `synorStackedLayoutBuilder`
  - `synorFadeSlideTransitionBuilder`
  - `synorFadeScaleTransitionBuilder`
- Standardized the app on short fade + small-offset slide for page and sheet transitions, and fade + restrained scale for success-modal transitions.
- Moved overlay positioning ownership to the switcher layer so sheets and overlays now animate both in and out cleanly.

## Flows Refined
- Startup/auth flow:
  - Onboarding
  - Sign In
  - Sign Up
  - Main-shell handoff
- Main shell:
  - Tab switching
  - Messages overlay
  - Smart Alarm overlay
  - Bottom-nav show/hide
  - Quick Alert sheet
- Services:
  - Main/subview transitions
  - Request details sheet
  - Success modal
- Profile:
  - Settings full-screen overlay
  - Edit Cover bottom sheet
- In-screen content transitions:
  - Sign Up step flow
  - Schedule mode switching
  - Study Hub mode switching
  - Smart Alarm personal/academic mode switching

## Files Changed
- `lib/app/synor_app.dart`
- `lib/app/theme/synor_design_tokens.dart`
- `lib/shared/widgets/motion.dart`
- `lib/shared/widgets/synor_widgets.dart`
- `lib/features/shell/presentation/shell_screen.dart`
- `lib/features/services/presentation/services_screen.dart`
- `lib/features/profile/presentation/profile_screen.dart`
- `lib/features/auth/presentation/auth_flow.dart`
- `lib/features/schedule/presentation/schedule_screen.dart`
- `lib/features/studies/presentation/studies_screen.dart`
- `lib/features/alarm/presentation/alarm_screen.dart`

## Remaining Risks
- The current app still uses an internal controller-driven navigation model rather than `MaterialApp.router`, so future deep-linking/platform-route transitions will need their own entry-layer motion policy.
- Existing transitions are intentionally restrained; if future product scope adds nested route stacks, those should reuse the shared motion helpers instead of introducing feature-local recipes again.

## Verification
- `flutter analyze`
- `flutter test`
- `flutter run -d chrome --web-browser-flag="--window-size=430,932" --web-port 7370 --no-resident`
