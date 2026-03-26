# Synor Runtime/UI Audit

Last updated: 2026-03-25

## Scope
- Fix the auth `No Material widget found` crash correctly.
- Audit the full Synor Flutter app for missing Material ancestry, debug-only overlays, and obvious runtime/layout instability.
- Harden the shared layout contract without redesigning the Synor UI.

## Root Cause of the Auth Crash
- Exact root cause: `TextFormField`, `TextField`, and `DropdownButton` widgets were being rendered under `MaterialApp` but not under a concrete `Material` or `Scaffold` ancestor.
- The shared constrained app host in `lib/shared/widgets/base_layout.dart` used `ColoredBox`, `Stack`, and `Container` only, so the auth sign-in `_AuthField` `TextFormField` was the first visible control to trip the runtime assertion.
- This was systemic, not isolated to auth. The same ancestry gap also affected:
  - shared `SynorSearchField` usages in Home, Schedule, and Services
  - Services housing/support form inputs
  - the Services housing dropdown

## Debug Overlay Sources Found
- No repo-managed Flutter debug paint, baseline, pointer, repaint-rainbow, performance overlay, or semantics debugger flags were found in app code.
- No `WidgetInspector` or Material debug-grid flags are explicitly enabled in the repo.
- The visible grid-like overlay on auth came from the app itself, not Flutter debug instrumentation:
  - previous source: `SynorGridOverlay`
  - current clarified source: `SynorAuthGridTexture`
  - location: `lib/shared/widgets/base_layout.dart`
- That auth grid is intentional and matches the exported Synor design source in `Synor_Design/synor-app/src/components/auth/*`.

## Files Changed
- `lib/shared/widgets/base_layout.dart`
- `lib/features/auth/presentation/auth_flow.dart`
- `lib/features/services/presentation/services_screen.dart`
- `lib/features/shell/presentation/shell_screen.dart`
- `lib/features/profile/presentation/profile_screen.dart`
- `test/test_helpers/synor_app_tester.dart`
- `test/runtime_ui_stability_test.dart`
- `docs/synor_runtime_ui_audit.md`
- `docs/synor_migration_log.md`

## Screens and Flows Audited
- App root and shared viewport host
- Splash
- Onboarding
- Sign In
- Sign Up
- Main shell and bottom navigation host
- Home
- Schedule
- Study Hub
- Services Main
- Services Documents
- Services Payments
- Services Housing
- Services Support
- Services All Requests
- Quick Alert sheet
- Smart Alarm
- Messages
- Profile
- Settings overlay
- Edit Cover overlay
- Service request details sheet
- Service success modal

## Issues Found
- Missing shared `Material`/`Scaffold` host for the entire constrained app surface.
- Auth sign-in/sign-up screens used full-height `Column` + `Spacer` compositions without a scroll fallback.
- Auth footer row overflowed horizontally on the constrained mobile shell.
- Quick Alert sheet header row overflowed horizontally with longer lesson titles.
- Housing screen dormitory summary row could overflow horizontally.
- Profile stat cards could overflow horizontally on the constrained shell.
- Material-dependent inputs were used in local/custom surfaces without any local safety wrapper.

## Fixes Applied
- Added a transparent `Material` + `Scaffold` host to `SynorViewport`, making it the shared runtime-safe surface for the app.
- Renamed/documented the auth grid layer as `SynorAuthGridTexture` so it is clearly treated as an intentional design texture, not a debug grid.
- Added `SynorFillScrollView` for input-heavy/auth stages to keep short-height and keyboard states scroll-safe while preserving the current visual layout.
- Wrapped auth fields, shared search fields, and services form controls in local transparent `Material` hosts for reuse safety.
- Added keyboard-aware bottom padding to Services lists while keeping the shell visually fixed.
- Fixed the specific runtime layout overflows found during the audit:
  - Sign In footer row
  - Quick Alert header row
  - Housing dormitory summary row
  - Profile stat-card rows

## Verification
- `flutter analyze`
  - Result: passed
- `flutter test`
  - Result: passed
- `flutter run -d chrome --web-port 7361 --no-resident`
  - Result: app launched successfully on Chrome and exited cleanly after startup
- Added widget regression coverage for:
  - splash render
  - sign-in Material ancestry and input entry
  - compact-height auth rendering
  - home search + services input controls
  - quick alert + profile settings overlays

## Remaining Risks
- This audit clears the current class of missing-Material and obvious constrained-width overflow issues found in the audited flows, but it is not an accessibility-text-scaling audit.
- If text baseline guides, repaint rainbow, or other debug overlays still appear on a developer machine after these fixes, that would now point to external IDE/DevTools/runtime tooling rather than repo-managed app code.
- Native Windows desktop runtime verification is still blocked in this environment by the missing Visual Studio toolchain; the runtime smoke pass was completed on Chrome instead.

## Prevention Recommendations
- Keep `SynorViewport` as the mandatory host for app surfaces so future screens inherit a safe `Material`/`Scaffold` contract.
- Use `SynorFillScrollView` for input-heavy or vertically dense stages instead of custom fixed-height `Column` + `Spacer` layouts.
- When building reusable controls around `TextField`, `TextFormField`, or `DropdownButton`, keep a local transparent `Material` wrapper so the widget remains safe if reused outside the main shell.
- Continue treating runtime widget smoke tests as required regression coverage for auth, input-bearing screens, and overlays.
