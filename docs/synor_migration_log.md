# Synor Migration Log

## 2026-04-01
- Completed the first production backend transition slice around Supabase authentication, role-aware sessions, and repository-backed lesson/material data.
- Added Supabase bootstrap/config wiring in `lib/app/data/supabase_client_provider.dart` and `lib/main.dart`; runtime now reads `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and optional `SUPABASE_AUTH_CALLBACK_URL` from dart-defines.
- Replaced the local auth implementation with `SupabaseAuthRepository` in `lib/features/auth/data/supabase_auth_repository.dart` and moved the app session to listen to real Supabase auth state changes.
- Extended sign-up to capture role metadata (`student` / `teacher`) and routed successful auth back into Riverpod session state.
- Added backend user domain/data/application layers under `lib/features/users` and moved current-user role/bootstrap logic into `currentUserControllerProvider`.
- Added Supabase lesson access under `lib/features/lessons/data/supabase_lesson_repository.dart` with repository-level permission enforcement for student, teacher, and super-teacher behavior.
- Added Supabase materials access under `lib/features/materials` with upload enforcement scoped to lessons managed by the current teacher or super teacher.
- Added the teacher dashboard in `lib/features/teacher/presentation/teacher_dashboard_screen.dart`, including repository-backed lesson creation/editing through the existing Synor UI language.
- Rebuilt the Schedule screen on real `DateTime` lesson data instead of the old static export assumptions.
- Connected Study Hub to real materials data and added teacher material upload / student download behavior in `lib/features/studies/presentation/studies_screen.dart`.
- Cleaned direct mock-data usage out of presentation by introducing repository/provider-backed content for Home stories/filters, Messages, and Profile cover templates.
- Deleted the old shared `lib/shared/data/mock_data.dart` bundle and inlined legacy local constants into repository/data-layer classes where a backend slice does not exist yet.
- Added Supabase schema, trigger, storage, and RLS definitions in `supabase/migrations/20260401_000001_synor_core.sql`.
- Added environment/setup documentation in `docs/synor_supabase_setup.md`.
- Stabilized the Riverpod test harness for the new backend-aware architecture with fake repositories in `test/test_helpers/synor_app_tester.dart`.
- Updated runtime smoke tests to respect the new student-first landing behavior (Schedule first, Home on explicit tab switch).
- Verified the backend transition slice with `flutter analyze` and `flutter test`.
- Remaining backend limitations after this slice:
  - Services still use a local repository and are not Supabase-backed yet.
  - Reminders/quick-alert presets remain local and are not synced to backend storage.
  - Messages content is repository-backed but still local, not yet connected to a real messaging backend.
  - Home stories/feed chrome remain repository-backed local content because they are presentation chrome, not domain data.

## 2026-03-26
- Added a shared skeleton loading system so async-backed screens no longer fall back to generic centered "Loading..." cards during normal bootstrap.
- Introduced reusable shimmer/skeleton primitives in `lib/shared/widgets/skeleton.dart` and exported them through `lib/shared/widgets/synor_widgets.dart`.
- Extended `lib/core/async/synor_async_state_view.dart` with screen-aware `loadingBuilder` support so features can render production-grade loading layouts while keeping the existing retry/error contract.
- Replaced the shell bootstrap loading UI with a full-screen Synor skeleton that matches the Home shell structure: header, search row, stories, filters, and lesson cards.
- Replaced the Services bootstrap loading UI with a dedicated skeleton for the title/search/grid/request-list layout.
- Replaced the Quick Alert sheet's plain loading text with a premium preset-list skeleton.
- Added short controlled mock-network latency in `lib/shared/data/mock_latency.dart` and wired it into the lessons, profile, services, and reminders data sources so loading states are actually perceptible without making the app feel slow.
- Parallelized the initial Services categories/requests fetch in `lib/features/services/application/services_controller.dart` so the professional loading pass does not unnecessarily lengthen startup time.
- Added runtime regression coverage for shell and Services skeleton loading in `test/runtime_ui_stability_test.dart`.
- Verified the skeleton loading pass with `flutter analyze` and `flutter test`.

## 2026-03-25
- Completed audit of the exported Google AI Studio source in `Synor_Design/synor-app`.
- Created Flutter feature/theme/app skeleton under `lib/app`, `lib/shared`, and `lib/features`.
- Localized design assets into `assets/`.
- Bundled `Holtwood One SC` locally from Google Fonts for the SYNOR wordmark.
- Localized the exported `logo.jpg` from the design source.
- Localized remote cover and avatar imagery used by the exported project.
- Replaced the blocked remote grain texture with a local SVG noise texture for offline rendering.
- Implemented Flutter design tokens, shared widgets, and custom animated clock/hourglass icons.
- Migrated auth, home, schedule, study hub, services, smart alarm, messages, and profile flows into Flutter.
- Wired the production app shell in `lib/app/synor_app.dart` and replaced the stock Flutter counter app.
- Added stateful overlays for quick alerts, service request details, service success feedback, profile settings, and cover editing.
- Verified the migrated Flutter app with `flutter analyze` and `flutter test`.
- Completed a second screen-by-screen visual parity audit and refinement pass focused on typography, spacing, radii, shadows, motion, and Material-style leaks.
- Added the dedicated checklist document at `docs/synor_visual_parity_checklist.md`.
- Closed the remaining documented cover exceptions: replaced the temporary graduation fallback, made Profile cover editing touch-first, and wired native image upload in Edit Cover.
- Completed an interaction audit and documented it in `docs/synor_interaction_audit.md`.
- Added sign-in validation, focus handling, recovery feedback, and local Google sign-in loading behavior.
- Made sign-up personalization and smart-feature tiles interactive instead of visual-only.
- Activated Home search/filter empty states, Schedule day/month/search behavior, Smart Alarm confirmation, Quick Alert custom time, and previously inert lesson/profile/study actions.
- Began Phase 4A architecture hardening.
- Added the architecture audit and migration plan at `docs/synor_architecture_audit.md`.
- Introduced Riverpod and `SharedPreferences` as the state-management and lightweight persistence foundation.
- Extracted persistent app/session state into `lib/app/application/app_session_controller.dart`.
- Extracted shell navigation state into `lib/features/shell/application/shell_navigation_controller.dart`.
- Moved mutable lesson/profile data behind repository + controller layers in `lib/features/lessons` and `lib/features/profile`.
- Added reusable async loading/error groundwork in `lib/core/async/synor_async_state_view.dart`.
- Added notification/reminder groundwork via `lib/core/notifications/notification_scheduler.dart` and repository contracts for services/messages/reminders.
- Completed the remaining Phase 4A extractions for services, auth, reminders, and internal routing.
- Added controller/repository-backed auth flow under `lib/features/auth/application`, `lib/features/auth/domain`, and `lib/features/auth/data`.
- Added controller/repository-backed services workflow under `lib/features/services/application` and `lib/features/services/data`.
- Moved Smart Alarm state and quick-alert presets fully behind the reminders repository/controller layer.
- Added path-backed internal routing with `lib/app/router/app_route_controller.dart` and expanded route mapping in `lib/app/router/synor_routes.dart`.
- Moved Profile settings overlay routing into the centralized shell/navigation flow.
- Phase 4A is complete for the current in-app architecture scope; the only routing work intentionally deferred is a future `MaterialApp.router` deep-link entry layer.
- Verified the hardened architecture pass with `flutter analyze` and `flutter test`.
- Completed a project-wide runtime/UI stability audit and documented it in `docs/synor_runtime_ui_audit.md`.
- Hardened the shared constrained viewport with a transparent `Material` + `Scaffold` host so Material-dependent controls render safely across the app.
- Clarified the auth grid texture as an intentional design layer rather than a debug overlay by renaming it to `SynorAuthGridTexture`.
- Added the shared `SynorFillScrollView` pattern for auth/input-heavy stages to prevent compact-height and keyboard-related overflow failures.
- Added local Material safety wrappers for auth fields, shared search fields, and Services housing/support inputs.
- Fixed the runtime layout overflows uncovered during the sweep in Sign In, Quick Alert, Services Housing, and Profile stat cards.
- Added runtime smoke/regression coverage in `test/runtime_ui_stability_test.dart` and `test/test_helpers/synor_app_tester.dart`.
- Verified the runtime hardening pass with `flutter analyze`, `flutter test`, and `flutter run -d chrome --web-port 7361 --no-resident`.
- Removed the standalone Synor splash/logo screen from the startup flow; startup now opens directly into Onboarding or Sign In based on persisted onboarding state.
- Removed the splash stage, splash timer, and related startup routing/session plumbing from the app model, router, and auth presentation layer.
- Fixed the visible white side seams on startup/auth by changing the shared viewport host to a true edge-to-edge mobile treatment on mobile-width layouts.
- Root cause of the white edge lines: the shared `SynorViewport` was still drawing framed-shell vertical borders and host chrome intended for a constrained preview shell, which surfaced as white side lines on dark startup/auth backgrounds.
- Files changed for the edge cleanup: `lib/shared/widgets/base_layout.dart`, `lib/app/application/app_session_controller.dart`, `lib/app/synor_app.dart`, `lib/app/router/app_route_controller.dart`, `lib/app/router/synor_routes.dart`, `lib/shared/models/app_models.dart`, `lib/features/auth/presentation/auth_flow.dart`, `lib/app/theme/synor_design_tokens.dart`, `test/runtime_ui_stability_test.dart`, `test/test_helpers/synor_app_tester.dart`, and `test/widget_test.dart`.
- Screens audited for side seams and edge artifacts: onboarding/welcome, sign-in, sign-up, root shell host, bottom navigation host, profile overlays, and full-screen auth backgrounds.
- Similar edge issues were not found in feature-local overlays or the bottom navigation container; the shared root viewport host was the common source of the startup/auth side-boundary artifact.

## Known Source Mismatches From Export
- The exported TSX types do not match the rendered states for `studyMode` and `scheduleMode`.
- These are implementation defects in the source export, not design changes.

## Explicit Asset Substitutions
- The exported "graduation" Unsplash URL returned `404` on 2026-03-25.
- `assets/images/covers/graduation.jpg` now uses a similar local graduation photo because the original exported asset could not be recovered.

## Current Implementation Notes
- The Edit Cover upload tile is now interactive via native file picking, with local validation for supported image types and size.
- Services, alarm, and profile interactions currently use local mock state, matching the export scope for this migration phase.
- Theme mode and onboarding completion are now persisted locally.
- Services, auth, and alarm/reminder workflows are now controller-driven and repository-backed.
- Remaining meaningful presentation-owned logic is limited to Home search/filter UI, Schedule day/month/search UI, Profile file/share/overlay interaction glue, and animation-only auth onboarding state.
- Shared screen hosting now guarantees a valid Material context for the audited in-app flows.
- No repo-managed Flutter debug paint/baseline/grid instrumentation is enabled; the auth grid remains an intentional exported design texture.
- The startup flow no longer includes a standalone splash stage.
- On mobile-width layouts, the shared viewport host no longer applies framed-shell side borders or outer host shadow, eliminating white edge seams on full-screen startup/auth backgrounds.
- Completed a strict mobile-width audit for wider phone-sized layouts after finding screens that still behaved as if they were inside a narrower virtual canvas.
- Root cause of the premature right-side boundary: the shared `SynorViewport` still wrapped every app stage in a centered `ConstrainedBox(maxWidth: 430)`, and auth/alarm added their own `maxWidth: 400` and `width.clamp(0, 430)` assumptions, so wider phones rendered core content inside the old export frame instead of the real device width.
- Fixed the issue centrally by making `SynorViewport` fill the full width on phone-sized devices and reserving the 430px framed shell only for larger tablet/desktop preview contexts.
- Added `SynorResponsiveContentLimit` so auth content keeps its desktop/tablet cap without narrowing phone layouts.
- Removed the remaining hard mobile-width assumptions from Sign In, Sign Up, and Smart Alarm so those screens now size from real available constraints.
- Files changed for the mobile-width fix: `lib/shared/widgets/base_layout.dart`, `lib/features/auth/presentation/auth_flow.dart`, `lib/features/alarm/presentation/alarm_screen.dart`, `test/runtime_ui_stability_test.dart`, and `test/test_helpers/synor_app_tester.dart`.
- Screens/components audited for false width boundaries: root shell host, onboarding, sign-in, sign-up, home search row, stories row, home filter chips, schedule segmented control, schedule day selector, bottom navigation host, Smart Alarm academic type tiles, and other horizontal rows inheriting the shared viewport width.
- The issue was systemic across mobile width handling because the shared viewport host and multiple feature-level widgets still encoded the original 430px export frame.
- Added wide-phone regression coverage to ensure the viewport host, auth fields, home horizontal controls, and schedule segmented control expand to the actual device width instead of collapsing back to the old frame.
- Refined the upcoming-lesson countdown chip to match the exported hourglass treatment more closely.
- Replaced the simplified countdown icon painter with a custom exported-Synor-style hourglass silhouette and internal sand-flow animation in `lib/shared/widgets/animated_icons.dart`.
- Split countdown chips off from the generic status chip in `lib/shared/widgets/lesson_cards.dart` so the lesson timer pill now uses source-aligned padding, radius, text weight, icon spacing, and icon/text color separation.
- Refined the in-app feedback system so transient notifications now render as top-floating overlay banners instead of bottom-positioned snackbars/toasts.
- Root cause of the visible text guide lines under notification copy: the shared feedback banner used an overly translucent `SynorGlassPanel` over textured screens, so the intentional auth grid/noise background bled through the banner surface and read like baseline lines beneath the text; this was not Flutter debug baseline painting.
- Files changed for the feedback refinement: `lib/shared/widgets/feedback.dart`, `test/runtime_ui_stability_test.dart`.
- The top notification behavior is now implemented as a dedicated root-overlay banner host with SafeArea-aware top positioning, fade + slide-in/out motion, auto-dismiss, and replacement behavior when a new notification is shown.
- Project-wide feedback audit result: the shared `showSynorToast` path was the transient feedback layer used across auth, profile, studies, alarm, and lesson interactions, so moving it centrally replaced the remaining bottom-positioned feedback pattern across the app; bottom sheets and centered success modals remain intentional.
- Completed a dedicated theme-transition refinement pass for light/dark mode so the switch now feels softer and more coordinated across the app.
- Root causes of the harsh theme switching: `MaterialApp` had no tuned theme animation, and many high-visibility Synor surfaces still used direct `synorIsDark(context)` branches with plain `Container`/`Text`/`Icon` styling, so colors, blur, shadows, and text/icon treatment snapped instead of interpolating.
- Transition strategy used: added a short shared theme-motion token, enabled `MaterialApp` theme animation, moved primary/secondary text onto theme-driven colors, and added targeted implicit interpolation with `AnimatedContainer`, `AnimatedDefaultTextStyle`, and `TweenAnimationBuilder` for color and blur on shared surfaces.
- Shared components specifically refined for smoother theme changes: root viewport background and ambient glows, `SynorGlassPanel`, segmented controls, search field, status chips, icon action buttons, modal scrim, bottom navigation, story cards, lesson countdown/action surfaces, the Home theme toggle/filter chips, and the top-floating feedback banner.
- Files changed for the theme transition pass: `lib/app/synor_app.dart`, `lib/app/theme/synor_design_tokens.dart`, `lib/shared/widgets/base_layout.dart`, `lib/shared/widgets/navigation.dart`, `lib/shared/widgets/surface_tiles.dart`, `lib/shared/widgets/lesson_cards.dart`, `lib/shared/widgets/feedback.dart`, `lib/features/home/presentation/home_screen.dart`, and `test/runtime_ui_stability_test.dart`.
- Component audit result: the main hard snaps were systemic across shared surface widgets, not isolated to one screen. High-visibility cards, stories, chips, nav, banner, and the root host are now on the coordinated transition path; remaining theme changes in the app are limited to lower-priority feature-local surfaces that already inherit the shared animated wrappers.
- Verified the theme transition refinement with `flutter analyze`, `flutter test`, and `flutter run -d chrome --web-port 7367 --no-resident`.
- Completed a dedicated page-transition refinement pass and documented the audit in `docs/synor_transition_audit.md`.
- Root causes of abrupt navigation behavior: the app used several unrelated local `AnimatedSwitcher` recipes with different durations, curves, and slide distances; full-screen shell overlays were coupled to the same content swap path as tab changes; and several sheets/modals only animated on entry before snapping closed on removal.
- Transition strategy used: added shared `SynorMotion` page/overlay tokens plus reusable motion helpers in `lib/shared/widgets/motion.dart`, then standardized the app on restrained fade + small-offset slide transitions for pages/sheets and fade + gentle scale for success modals.
- Navigation flows specifically refined: startup/auth stage changes, Sign Up step switching, shell tab switching, Messages and Smart Alarm full-screen overlays, bottom-nav visibility changes, Quick Alert, Services subviews, Services request details, Services success modal, Profile settings, Profile cover picker, Schedule mode switching, Study Hub mode switching, and Smart Alarm personal/academic mode switching.
- Files changed for the transition pass: `lib/app/synor_app.dart`, `lib/app/theme/synor_design_tokens.dart`, `lib/shared/widgets/motion.dart`, `lib/shared/widgets/synor_widgets.dart`, `lib/features/shell/presentation/shell_screen.dart`, `lib/features/services/presentation/services_screen.dart`, `lib/features/profile/presentation/profile_screen.dart`, `lib/features/auth/presentation/auth_flow.dart`, `lib/features/schedule/presentation/schedule_screen.dart`, `lib/features/studies/presentation/studies_screen.dart`, and `lib/features/alarm/presentation/alarm_screen.dart`.
- Transition audit result: the issue was systemic across navigation and overlay presentation rather than isolated to one screen. High-visibility flows now use a single restrained motion language and reversible overlay transitions instead of entry-only transforms.
- Verified the transition refinement with `flutter analyze`, `flutter test`, and `flutter run -d chrome --web-browser-flag="--window-size=430,932" --web-port 7370 --no-resident`.
- Implemented the final Synor branding pass with a new branded startup splash, theme-aware logo selection, and replacement of the remaining placeholder auth/header branding.
- Added a new startup splash stage that now appears before onboarding or sign-in, with a centered Synor logo plus a bottom `from` + BEKOO lockup and restrained fade/scale sequencing.
- Registered the provided branding assets under `assets/images/branding/` and bundled the Inter font for the `from` label in `pubspec.yaml`.
- Added shared branding widgets in `lib/shared/widgets/branding.dart` and exported them through `lib/shared/widgets/synor_widgets.dart`.
- Replaced the placeholder square `S` auth brand mark with the supplied Synor logo asset in `lib/features/auth/presentation/auth_flow.dart`.
- Replaced the old home-header raster logo block with the supplied Synor logo asset in `lib/features/home/presentation/home_screen.dart`.
- Startup/session flow changed in `lib/shared/models/app_models.dart`, `lib/app/application/app_session_controller.dart`, `lib/app/router/synor_routes.dart`, `lib/app/router/app_route_controller.dart`, and `lib/app/synor_app.dart` to restore a branded splash stage without reintroducing the old placeholder splash.
- Branding asset implementation note: the uploaded files are JPEG/PNG payloads stored under `.svg` filenames, so the new branding layer intentionally renders them with `Image.asset` for correct runtime decoding while still using the exact provided files as the source of truth.
- Verified the branding pass with `flutter pub get`, `flutter analyze`, `flutter test`, and `flutter run -d chrome --web-browser-flag="--window-size=430,932" --web-port 7371 --no-resident`.
- Completed a mobile width / edge-to-edge audit for horizontally arranged content that still felt narrower than the real phone viewport.
- Root cause: several horizontal sections were still rendered inside vertically padded page `ListView`s, so the stories row, lesson filter chips, schedule day strip, study continuation cards, and profile signal chips inherited a reduced inner canvas even though the root mobile shell already used full phone width.
- Central fix: added `SynorHorizontalViewportBleed` in `lib/shared/widgets/base_layout.dart` to let horizontal mobile sections use the true device width while preserving the intended first/last item insets on phone layouts and keeping the framed-shell behavior for larger preview contexts.
- Files changed for the width audit: `lib/shared/widgets/base_layout.dart`, `lib/features/home/presentation/home_screen.dart`, `lib/features/schedule/presentation/schedule_screen.dart`, `lib/features/studies/presentation/studies_screen.dart`, and `lib/features/profile/presentation/profile_screen.dart`.
- Affected screens/components: Home stories row, Home lesson filter chips, Schedule day selector strip, Study Hub "Continue studying" row, and Profile signal chips.
- Systemic result: yes, the issue was systemic across mobile horizontal sections, not isolated to a single card. The phone host itself was already full width; the remaining false boundary came from page-level horizontal padding applied to inner scrollers.
- Verified the width fix with `flutter analyze`, `flutter test`, and `flutter run -d chrome --web-browser-flag="--window-size=430,932" --web-port 7372 --no-resident`. No Android device was connected during this verification pass.
- Replaced the remaining default native startup presentation with Synor-branded native splash assets so the app no longer shows the Flutter logo before the in-app branded splash.
- Added native splash generation via `flutter_native_splash` using a white `#FAFAFA` background, centered Synor logo, and bottom BEKOO brand lockup.
- Increased the logo size only on the in-app branded splash in `lib/shared/widgets/branding.dart` from `144` to `184` while leaving other logo placements unchanged.
- Added launcher icon generation via `flutter_launcher_icons` using `assets/images/app_icon/synor_app_icon.jpg`, a raster copy of the provided `synor_app_icon.svg` source file.
- Generated native splash outputs for Android/iOS and regenerated Android/iOS launcher icons.
- Files touched for the branding/native startup pass: `pubspec.yaml`, `lib/shared/widgets/branding.dart`, Android splash resources/themes, iOS launch/app icon assets, and generated Android/iOS icon outputs.
- Verified the native branding pass with `flutter analyze`, `flutter test`, and `flutter build apk --debug`.
- Refined the startup chain to remove the redundant extra Flutter splash step after the native launch screen.
- Before this pass, startup had two branded steps in sequence: the native/system launch screen and a separate in-app `AuthStage.splash` handled by `SynorBrandedSplashScreen`.
- Removed step: the in-app `AuthStage.splash` stage from the Flutter session/router flow.
- Final startup flow: native branded launch screen -> Onboarding for first-time users, or native branded launch screen -> Sign In / Main depending on persisted session state.
- Android/system launch screen alignment: yes. The native startup visuals are already aligned to Synor branding with the same white background and Synor logo; pre-Android-12 and iOS also include the BEKOO lockup, while Android 12 remains limited by the OS splash API to the centered icon treatment.
- Files changed for the startup refinement: `lib/shared/models/app_models.dart`, `lib/app/application/app_session_controller.dart`, `lib/app/synor_app.dart`, `lib/app/router/app_route_controller.dart`, `lib/app/router/synor_routes.dart`, `test/runtime_ui_stability_test.dart`, and `test/widget_test.dart`.

## Visual Fidelity Checklist
- [x] Splash
  Notes: removed from the runtime product flow; startup now enters Onboarding or Sign In directly.
- [x] Onboarding
  Notes: reviewed skip placement, hero headline scale, background glow, and floating-card motion; added bottom violet glow and closer card scale/rotation transitions.
- [x] Sign In
  Notes: reviewed auth column width, logo block sizing, input padding, icon spacing, and typography; aligned container width and field rhythm to the source.
- [x] Sign Up
  Notes: reviewed back button geometry, step progress bars, field spacing, and button proportions; replaced the oversized progress row with fixed indicators and lighter header controls.
- [x] Main Shell
  Notes: reviewed viewport glass shell, screen transition direction, and ambient treatment; kept the 430px mobile frame and refined main/auth transition behavior.
- [x] Bottom Navigation
  Notes: reviewed blur, alpha, selected pill radius, and shadow strength; increased glass fidelity and matched the selected-tab shadow treatment to the export.
- [x] Home
  Notes: reviewed header icon button radii, filter chip shadows, theme toggle morph, lesson chips, and story density; corrected action-button radius and active filter shadow styling.
- [x] Schedule
  Notes: reviewed segmented control sizing, day selector proportions, month controls, and mode transitions; reduced control radii/heights and added content fade/slide parity.
- [x] Study Hub
  Notes: reviewed segmented control, assignment meta rows, subject footer colors, and mode transitions; restored the missing `See all` hierarchy and added mode-content animation.
- [x] Services Main
  Notes: reviewed header spacing, grid/card density, search field, and request list hierarchy; kept structure aligned to the export and retained request ordering/state behavior.
- [x] Services Documents
  Notes: reviewed sticky header treatment, back affordance weight, card radius, and add-request icon sizing; replaced the heavy back button and oversized add button.
- [x] Services Payments
  Notes: reviewed balance card gradient, fee card spacing, and CTA proportions; no structural drift remained after the shared header/button refinements.
- [x] Services Housing
  Notes: reviewed dorm card, form hierarchy, and control styling; replaced Material-looking dropdown styling with a custom select container to match the export.
- [x] Services Support
  Notes: reviewed shortcut tile colors, icon surfaces, and ticket form hierarchy; corrected shortcut icon/background treatment and dark-text contrast.
- [x] Services All Requests
  Notes: reviewed sticky header, request tile proportions, and list spacing; aligned with the shared services header refinements.
- [x] Smart Alarm
  Notes: reviewed back button weight, mode toggle, and time-picker emphasis; kept the custom lighter toggle and removed the heavy framed back button.
- [x] Messages
  Notes: reviewed header hierarchy, title alignment, back affordance, and message card radius; changed the header from centered to left-aligned like the export.
- [x] Profile
  Notes: reviewed cover overlap, rounded cover bottom, profile action buttons, tag density, signal chips, section headings, and bottom spacing; fixed the cover radius, overlap amount, and section typography.
- [x] Settings Overlay
  Notes: reviewed header surface, back button style, row weights, and list spacing; removed ripple-style interaction and matched the source header treatment.
- [x] Edit Cover Overlay
  Notes: reviewed sticky header blur, close button size, template grid header, and upload card hierarchy; updated header blur/alpha and close button geometry.
- [x] Quick Alert Sheet
  Notes: reviewed sheet radius, handle, preset rows, and button hierarchy; no additional visual drift found after the shared surface pass.
- [x] Service Request Details
  Notes: reviewed sheet spacing, info rows, and close CTA proportions; remains aligned with the export after shared sheet refinements.
- [x] Service Success Modal
  Notes: reviewed scrim blur, scale/fade motion, and icon block proportions; added scrim blur and opacity ramp to better match the source modal entrance.

## Fidelity Exceptions
- The exported `graduation` cover image source returned `404` on 2026-03-25, so the Flutter app uses a visually similar local replacement.
- Hover-only desktop affordances from the export are adapted for touch where necessary, most notably the Profile cover-edit action.

## Localization
- Added production `gen-l10n` setup with `flutter_localizations`, `intl`, `l10n.yaml`, and generated local imports from `lib/l10n/app_localizations.dart`.
- Created and wired three ARB files: `lib/l10n/app_en.arb`, `lib/l10n/app_ru.arb`, and `lib/l10n/app_kk.arb`.
- Localized 437 user-facing string keys from the English base ARB across English, Russian, and Kazakh.
- `MaterialApp` now uses `AppLocalizations.delegate`, `GlobalMaterialLocalizations.delegate`, `GlobalWidgetsLocalizations.delegate`, `GlobalCupertinoLocalizations.delegate`, and the supported locales `en`, `ru`, and `kk`.
- Locale state is now part of `AppSessionState` in `lib/app/application/app_session_controller.dart` and is persisted through `lib/app/data/local_app_preferences_repository.dart` under `app.locale_code`.
- Added instant language switching in the Profile settings language picker inside `lib/features/profile/presentation/profile_screen.dart`.
- Added localization helpers in `lib/l10n/app_localization_x.dart` so seeded lesson titles, messages, cover template names, request titles, request descriptions, alert presets, campuses, alarm types, and issue types resolve to localized labels instead of leaking raw internal values.
- Replaced hardcoded UI display text across Auth, Home, Schedule, Studies, Services, Messages, Alarm, Teacher Dashboard, Profile, shared feedback, and shared tiles with `context.l10n...` accessors.
- Normalized remaining internal runtime seeds away from visible English strings to stable ids for quick-alert presets, campus values, alarm academic types, services issue types, service success events, and service category/request titles where needed for scalable localization.
- Final widget-text regex audit leaves only numeric values and stable internal ids in data/repository layers; no direct user-facing hardcoded display strings remain in the UI layer.
- Verification completed with `flutter gen-l10n`, `dart format lib test`, `flutter analyze`, and `flutter test`.
