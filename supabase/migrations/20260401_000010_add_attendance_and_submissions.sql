-- Attendance and Submissions for Analytics
create table if not exists public.lesson_attendance (
  id uuid primary key default gen_random_uuid(),
  lesson_id bigint not null references public.lessons(id) on delete cascade,
  student_id uuid not null references public.users(id) on delete cascade,
  status text not null check (status in ('present', 'late', 'absent')),
  created_at timestamptz not null default timezone('utc', now()),
  unique(lesson_id, student_id)
);

create table if not exists public.assignment_submissions (
  id uuid primary key default gen_random_uuid(),
  assignment_id bigint not null references public.assignments(id) on delete cascade,
  student_id uuid not null references public.users(id) on delete cascade,
  submitted_at timestamptz not null default timezone('utc', now()),
  grade numeric(4, 2), -- 0.0 to 100.0 or GPA scale
  feedback text,
  unique(assignment_id, student_id)
);

-- RLS
alter table public.lesson_attendance enable row level security;
alter table public.assignment_submissions enable row level security;

-- Policies for attendance
create policy "attendance_readable_scoped"
  on public.lesson_attendance
  for select
  to authenticated
  using (
    public.current_user_is_super()
    or exists (
      select 1 from public.lessons l 
      where l.id = lesson_id and l.teacher_id = auth.uid()
    )
    or student_id = auth.uid()
  );

create policy "teachers_manage_attendance"
  on public.lesson_attendance
  for all
  to authenticated
  using (
    public.current_user_is_super()
    or exists (
      select 1 from public.lessons l 
      where l.id = lesson_id and l.teacher_id = auth.uid()
    )
  );

-- Policies for submissions
create policy "submissions_readable_scoped"
  on public.assignment_submissions
  for select
  to authenticated
  using (
    public.current_user_is_super()
    or exists (
      select 1 from public.assignments a
      join public.lessons l on l.id = a.lesson_id
      where a.id = assignment_id and l.teacher_id = auth.uid()
    )
    or student_id = auth.uid()
  );

create policy "students_create_submissions"
  on public.assignment_submissions
  for insert
  to authenticated
  with check (student_id = auth.uid());

create policy "teachers_grade_submissions"
  on public.assignment_submissions
  for update
  to authenticated
  using (
    public.current_user_is_super()
    or exists (
      select 1 from public.assignments a
      join public.lessons l on l.id = a.lesson_id
      where a.id = assignment_id and l.teacher_id = auth.uid()
    )
  );
