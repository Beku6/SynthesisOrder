-- Service Requests Migration
create table if not exists public.service_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  type text not null check (type in ('document', 'payment', 'housing', 'support')),
  title text not null,
  description text,
  status text not null default 'pending',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

-- Enable RLS
alter table public.service_requests enable row level security;

-- Policies
create policy "Users can view their own requests"
  on public.service_requests for select
  using (auth.uid() = user_id);

create policy "Users can insert their own requests"
  on public.service_requests for insert
  with check (auth.uid() = user_id);

create policy "Admins/Teachers can view all requests"
  on public.service_requests for select
  using (public.current_user_role() = 'teacher' or public.current_user_is_super());

-- Trigger for updated_at
create trigger service_requests_set_updated_at
before update on public.service_requests
for each row
execute function public.set_updated_at();
