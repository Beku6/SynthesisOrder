-- Notifications Migration
create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  title text not null,
  message text not null,
  type text not null check (type in ('assignment', 'exam', 'message', 'system', 'service')),
  is_read boolean not null default false,
  created_at timestamptz not null default timezone('utc', now())
);

-- Enable RLS
alter table public.notifications enable row level security;

-- Policies
create policy "Users can view their own notifications"
  on public.notifications for select
  using (auth.uid() = user_id);

create policy "Users can update their own notifications"
  on public.notifications for update
  using (auth.uid() = user_id);

-- Trigger Function: Notify students about new assignments
create or replace function public.notify_on_assignment_created()
returns trigger
language plpgsql
as $$
declare
  student_id uuid;
  lesson_title text;
begin
  -- Get the lesson subject for the title
  select subject into lesson_title from public.lessons where id = new.lesson_id;

  -- Insert a notification for every student in the group associated with the lesson
  for student_id in (
    select u.id 
    from public.users u
    join public.lessons l on l.group_id = u.group_id
    where l.id = new.lesson_id and u.role = 'student'
  ) loop
    insert into public.notifications (user_id, title, message, type)
    values (
      student_id, 
      'New Assignment: ' || lesson_title,
      new.title,
      'assignment'
    );
  end loop;

  return new;
end;
$$;

-- Trigger for assignments
create trigger on_assignment_created
after insert on public.assignments
for each row
execute function public.notify_on_assignment_created();

-- Trigger Function: Notify students about new exams
create or replace function public.notify_on_exam_created()
returns trigger
language plpgsql
as $$
declare
  student_id uuid;
  lesson_title text;
begin
  select subject into lesson_title from public.lessons where id = new.lesson_id;

  for student_id in (
    select u.id 
    from public.users u
    join public.lessons l on l.group_id = u.group_id
    where l.id = new.lesson_id and u.role = 'student'
  ) loop
    insert into public.notifications (user_id, title, message, type)
    values (
      student_id, 
      'New Exam Scheduled: ' || lesson_title,
      new.title || ' at ' || new.location,
      'exam'
    );
  end loop;

  return new;
end;
$$;

-- Trigger for exams
create trigger on_exam_created
after insert on public.exams
for each row
execute function public.notify_on_exam_created();
