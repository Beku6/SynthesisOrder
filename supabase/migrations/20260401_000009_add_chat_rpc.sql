-- Chat RPC for 1-on-1 rooms
create or replace function public.get_or_create_direct_room(user1 uuid, user2 uuid)
returns uuid
language plpgsql
security definer
as $$
declare
  existing_room_id uuid;
  new_room_id uuid;
begin
  -- Search for an existing room with exactly these two participants
  select p1.room_id into existing_room_id
  from public.chat_participants p1
  join public.chat_participants p2 on p1.room_id = p2.room_id
  join public.chat_rooms r on r.id = p1.room_id
  where r.is_group = false
    and p1.user_id = user1
    and p2.user_id = user2
  limit 1;

  if existing_room_id is not null then
    return existing_room_id;
  end if;

  -- Create new room if none exists
  insert into public.chat_rooms (is_group)
  values (false)
  returning id into new_room_id;

  -- Add participants
  insert into public.chat_participants (room_id, user_id)
  values (new_room_id, user1), (new_room_id, user2);

  return new_room_id;
end;
$$;
