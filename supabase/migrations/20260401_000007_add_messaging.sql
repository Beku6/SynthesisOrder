-- Messaging Migration
create table if not exists public.chat_rooms (
  id uuid primary key default gen_random_uuid(),
  name text, -- For groups
  is_group boolean not null default false,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.chat_participants (
  room_id uuid not null references public.chat_rooms(id) on delete cascade,
  user_id uuid not null references public.users(id) on delete cascade,
  primary key (room_id, user_id)
);

create table if not exists public.chat_messages (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references public.chat_rooms(id) on delete cascade,
  sender_id uuid not null references public.users(id) on delete cascade,
  content text not null,
  created_at timestamptz not null default timezone('utc', now())
);

-- Enable RLS
alter table public.chat_rooms enable row level security;
alter table public.chat_participants enable row level security;
alter table public.chat_messages enable row level security;

-- Policies
create policy "Users can view rooms they are in"
  on public.chat_rooms for select
  using (
    exists (
      select 1 from public.chat_participants
      where room_id = id and user_id = auth.uid()
    )
  );

create policy "Users can view participants in their rooms"
  on public.chat_participants for select
  using (
    exists (
      select 1 from public.chat_participants p2
      where p2.room_id = room_id and p2.user_id = auth.uid()
    )
  );

create policy "Users can view messages in their rooms"
  on public.chat_messages for select
  using (
    exists (
      select 1 from public.chat_participants
      where room_id = public.chat_messages.room_id and user_id = auth.uid()
    )
  );

create policy "Users can send messages to their rooms"
  on public.chat_messages for insert
  with check (
    sender_id = auth.uid() and
    exists (
      select 1 from public.chat_participants
      where room_id = public.chat_messages.room_id and user_id = auth.uid()
    )
  );
