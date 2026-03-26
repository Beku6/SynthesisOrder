# Synor Architecture Audit

Last updated: 2026-03-25

Scope:
- Audit the current Flutter codebase before deeper production hardening.
- Identify UI-owned state, business logic inside widgets, mock-data coupling, navigation weaknesses, and missing abstractions.
- Define the target scalable architecture and the migration path from local behavior to real data integration.

## Current Audit

### UI state currently embedded directly in screens
- `lib/app/synor_app.dart`
  - Previously owned theme mode and auth flow stage directly in the root widget.
- `lib/features/shell/presentation/shell_screen.dart`
  - Previously owned selected tab, schedule/study sub-modes, fullscreen overlays, quick-alert target, mutable lessons, and mutable profile state.
- `lib/features/services/presentation/services_screen.dart`
  - Still owns active subview, form inputs, form validation, selected request, success modal timing, and request mutations.
- `lib/features/profile/presentation/profile_screen.dart`
  - Still owns overlay visibility and some local interaction flags such as connection request state.
- `lib/features/auth/presentation/auth_flow.dart`
  - Still owns sign-in form state, validation errors, sign-up step progression, and setup toggles.
- `lib/features/home/presentation/home_screen.dart`
  - Still owns local search/filter state.
- `lib/features/schedule/presentation/schedule_screen.dart`
  - Still owns selected day, month index, and local search state.
- `lib/features/alarm/presentation/alarm_screen.dart`
  - Still owns alarm draft values.

### Business logic mixed into widgets
- Alert application/removal previously happened inside the shell widget rather than through a lesson domain boundary.
- Profile cover mutation previously happened inside the shell widget rather than behind a repository/controller.
- Services request creation, payment submission, housing/support form submission, and success state timing are still embedded in the services screen.
- File picking, clipboard sharing, and local action feedback are still presentation-owned in Profile.
- Sign-in submit/recovery logic and sign-up toggle behavior are still inside auth presentation.

### Duplicated state patterns
- Multiple screens use ad-hoc `setState` for search/filter/form state.
- Loading/success/error patterns were previously screen-specific booleans and timers rather than a shared async contract.
- Overlay navigation was modeled with local booleans (`_showMessages`, `_showAlarm`, `_isCoverPickerOpen`, `_isSettingsOpen`, `_selectedRequest`) instead of typed navigation state.

### Missing or incomplete models/entities
- No app/session model existed for theme, onboarding completion, and auth presentation flow.
- No shell navigation model existed for tabs, overlays, and sub-modes.
- No reminder/alarm domain models existed beyond screen-local primitives.
- No request draft models existed for housing/support submissions.
- Existing shared models are still presentation-oriented and colocated in `lib/shared/models/app_models.dart`; they need gradual migration into feature/domain ownership over time.

### Missing repository abstractions
- No repository layer existed for app preferences, lessons, profile, services, messages, or reminders.
- Mock data in `lib/shared/data/mock_data.dart` was imported directly by presentation widgets.
- No notification scheduling abstraction existed for quick alerts or alarm groundwork.

### Navigation weaknesses
- `lib/app/router/synor_routes.dart` exists but is not used by the running app.
- Root auth/navigation flow was previously controlled by widget-local state rather than a typed app/session controller.
- Shell navigation was previously a combination of tab state and boolean overlay flags with no centralized contract.
- Full router/deep-link/back-stack behavior is not in place yet.

### Places where current mock/local behavior should be abstracted next
- `ServicesScreen`: request loading, service categories, ticket submission, payment flow, success feedback.
- `MessagesScreen`: message list source and future conversation loading.
- `AuthFlow`: sign-in/sign-up commands, onboarding completion, session transitions.
- `AlarmScreen`: reminder draft state and future scheduling.
- `HomeScreen` / `ScheduleScreen`: local filter/search state can later move to lightweight feature controllers if cross-screen persistence becomes necessary.

## Recommended Architecture

### State management strategy
- Use `flutter_riverpod` as the app-wide state management approach.
- Prefer:
  - `Notifier` for synchronous UI/application state.
  - `AsyncNotifier` for repository-backed feature state.
  - plain `Provider` for repository and infrastructure dependencies.
- Keep ephemeral animation-only UI state inside widgets.
- Move mutable data, feature workflow state, and app/session/navigation state into controllers.

### Feature structure
- `lib/app/`
  - app bootstrap, app/session controller, app preferences data source, theme, typed route constants.
- `lib/core/`
  - cross-feature infrastructure: persistence, async state widgets, notification scheduler contracts.
- `lib/features/<feature>/domain/`
  - entities and repository contracts.
- `lib/features/<feature>/data/`
  - in-memory/local implementations and future remote/local data sources.
- `lib/features/<feature>/application/`
  - Riverpod controllers/providers.
- `lib/features/<feature>/presentation/`
  - widgets/screens only.

### Recommended model list
- `AppSessionState`
- `ShellNavigationState`
- `AlarmScheduleDraft`
- `AlertPreset`
- `HousingRequestDraft`
- `SupportTicketDraft`
- Existing migrated/shared entities to retain and later move feature-by-feature:
  - `Lesson`
  - `ProfileData`
  - `ServiceRequest`
  - `ServiceCategoryData`
  - `MessagePreview`
  - `CoverTemplate`

### Repository contract list
- `AppPreferencesRepository`
- `LessonRepository`
- `ProfileRepository`
- `ServicesRepository`
- `MessagesRepository`
- `RemindersRepository`
- `NotificationScheduler`

## Migration Plan

### Phase 4A foundation
- Introduce Riverpod and persistence infrastructure.
- Extract root app/session state and shell navigation state.
- Move mutable lessons/profile data behind repositories and controllers.
- Introduce reusable async/loading/error presentation primitives.
- Add repository contracts for services/messages/reminders and a notification scheduler stub.

### Phase 4A remaining feature extraction
- Move services data/mutations out of `ServicesScreen`.
- Move auth commands and setup drafts into application controllers.
- Move alarm draft state into reminder/application state.
- Move messages to repository-backed loading.

### Phase 4B navigation + integration readiness
- Replace remaining manual route switches with typed router-driven navigation.
- Persist more local state where it improves UX and does not distort scope.
- Swap in-memory repositories with local/remote implementations incrementally.

## Progress in this turn
- Added Riverpod + `SharedPreferences`.
- Added `AppSessionController` with persistent theme/onboarding preferences.
- Added `ShellNavigationController` to centralize tabs, overlays, and mode state.
- Added `LessonRepository` + `LessonController`.
- Added `ProfileRepository` + `ProfileController`.
- Added `SynorAsyncStateView` for reusable loading/error rendering.
- Added `NotificationScheduler` groundwork and repository contracts for services/messages/reminders.
- Updated the root app and shell to consume controllers instead of owning mutable lesson/profile/app state directly.

## Phase 4A completion update

### Completed extractions
- `lib/features/services`
  - Added `InMemoryServicesRepository` and `ServicesController`.
  - Moved service categories, request loading, document/payment/housing/support submission, success timing, request selection, search query, and subview state out of `ServicesScreen`.
- `lib/features/auth`
  - Added `AuthRepository`, `SignInDraft`, `SignUpDraft`, and controller-driven sign-in/sign-up flows.
  - Sign-in validation, recovery, Google loading, sign-up step state, personalization toggles, and setup completion now live in Riverpod controllers.
- `lib/features/reminders`
  - Alarm state is now repository-backed through `RemindersRepository`, `LocalRemindersRepository`, and `AlarmController`.
  - Quick-alert presets now load from the reminders repository rather than presentation-local constants.
- `lib/app/router`
  - Added a path-backed route layer with `SynorRouteState`, `SynorRoutes` helpers, and `AppRouteController`.
  - Auth transitions, shell tab changes, services subroutes, messages, alarm, and profile settings now route through a central navigation API.

### Remaining UI-layer logic after Phase 4A
- `lib/features/home/presentation/home_screen.dart`
  - Local search/filter state only.
- `lib/features/schedule/presentation/schedule_screen.dart`
  - Local day/month/search state only.
- `lib/features/profile/presentation/profile_screen.dart`
  - Cover-picker visibility, file picking, clipboard/share actions, and local connection-request toggle still live in presentation.
- `lib/features/auth/presentation/auth_flow.dart`
  - Splash/onboarding animation timers and slide progression remain widget-local by design.

### Route status
- Internal routing is now centralized, path-backed, and consistent across auth, shell tabs, services subroutes, messages, alarm, and profile settings.
- The app is not yet using `MaterialApp.router` or platform deep-link entry parsing. That is the remaining step if future scope requires OS/browser deep linking rather than only a clean internal route layer.
