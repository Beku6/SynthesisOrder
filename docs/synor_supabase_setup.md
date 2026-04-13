# Synor Supabase Setup

## Runtime configuration
Run the app with:

```powershell
flutter run `
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY `
  --dart-define=SUPABASE_AUTH_CALLBACK_URL=synor://login-callback
```

`SUPABASE_AUTH_CALLBACK_URL` is optional for password auth, but required for Google OAuth on mobile.

You can also keep local credentials in:

```powershell
config/supabase.local.json
```

and run:

```powershell
flutter run --dart-define-from-file=config/supabase.local.json
```

Important: the app expects `SUPABASE_URL` and `SUPABASE_ANON_KEY` exactly. `SUPEBASE_*` will not be read.

## Required Supabase resources
1. Apply the SQL migration:

```sql
supabase/migrations/20260401_000001_synor_core.sql
```

2. Confirm the following tables exist:
- `groups`
- `users`
- `lessons`
- `materials`
- `teachers_whitelist`

3. Confirm the `materials` storage bucket exists and is public for read.

## Auth model
- Supabase Auth owns the canonical login session.
- `public.users` mirrors `auth.users` through the `handle_auth_user()` trigger.
- The Flutter app still runs a defensive `upsert` on the current user to keep legacy sign-ups/backfills safe.

## Role model
- `student`
  - read-only access to lessons/materials scoped by `group_id`
- `teacher`
  - sees lessons/materials where `teacher_id = auth.uid()`
  - can create and edit only their own lessons
  - can upload materials only for their own lessons
- `is_super = true`
  - full lesson/material access across all groups

## Sign-up metadata expected from Flutter
The app sends this metadata during sign-up:
- `name`
- `role`
- `group`
- `university`
- `faculty`
- `course_year`

The SQL trigger resolves:
- `role`
- `name`
- `group_id` by matching the provided `group` name against `public.groups`

## Seed data you should add before QA
Create at least:
- 1-2 `groups`
- 1 teacher account
- 1 student account assigned to a valid `group_id`
- 2-3 lessons
- 1-2 materials attached to real lessons

## Google OAuth notes
If Google sign-in is enabled:
- enable Google provider in Supabase Auth
- add the mobile/web redirect URI used by `SUPABASE_AUTH_CALLBACK_URL`
- keep the same callback URI in Flutter and Supabase

## Current client integrations
- Auth/session: `lib/features/auth`, `lib/app/application/app_session_controller.dart`
- User bootstrap and roles: `lib/features/users`
- Lesson data/RLS-aware queries: `lib/features/lessons`
- Materials upload/read: `lib/features/materials`

## Current non-Supabase features
These still use local repositories and should be treated as the next backend slice:
- Services
- Reminders/quick alerts scheduling behavior
- Messages feed content
- Home stories/feed chrome content
