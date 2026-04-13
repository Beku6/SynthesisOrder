alter table public.users add column if not exists gpa numeric(3, 2);
alter table public.users add column if not exists program text;
alter table public.users add column if not exists university text;
