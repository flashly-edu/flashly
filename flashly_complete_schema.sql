-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ==========================================
-- 1. TABLES
-- ==========================================

-- PROFILES
create table public.profiles (
  id uuid references auth.users not null primary key,
  username text unique,
  created_at timestamptz default now()
);

alter table public.profiles enable row level security;

-- GROUPS
create table public.groups (
  id uuid default uuid_generate_v4() primary key,
  name text not null,
  created_by uuid references auth.users not null,
  invite_code text unique not null default substring(md5(random()::text) from 0 for 9),
  created_at timestamptz default now()
);

alter table public.groups enable row level security;

-- GROUP MEMBERS
create table public.group_members (
  group_id uuid references public.groups(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  role text check (role in ('admin', 'member')) default 'member',
  joined_at timestamptz default now(),
  primary key (group_id, user_id)
);

alter table public.group_members enable row level security;

-- DECKS
create table public.decks (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  title text not null,
  description text,
  is_public boolean default false,
  group_id uuid references public.groups(id) on delete cascade,
  created_at timestamptz default now()
);

alter table public.decks enable row level security;

-- SAVED DECKS (Shortcuts)
create table public.saved_decks (
  user_id uuid references public.profiles(id) on delete cascade not null,
  deck_id uuid references public.decks(id) on delete cascade not null,
  saved_at timestamptz default now(),
  primary key (user_id, deck_id)
);

alter table public.saved_decks enable row level security;

-- CARDS
create table public.cards (
  id uuid default uuid_generate_v4() primary key,
  deck_id uuid references public.decks(id) on delete cascade not null,
  front text not null,
  back text not null,
  created_at timestamptz default now(),
  interval_days numeric default 0,
  ease_factor numeric default 2.5,
  last_reviewed timestamptz,
  due_at timestamptz,
  reviews_count integer default 0
);

alter table public.cards enable row level security;

-- Index on deck_id for performance
create index idx_cards_deck_id on public.cards(deck_id);

-- TAGS
create table public.tags (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users not null,
  name text not null,
  color text default '#cbd5e1',
  created_at timestamptz default now(),
  unique(user_id, name)
);

alter table public.tags enable row level security;

-- CARD TAGS (Many-to-Many)
create table public.card_tags (
  card_id uuid references public.cards(id) on delete cascade,
  tag_id uuid references public.tags(id) on delete cascade,
  primary key (card_id, tag_id)
);

alter table public.card_tags enable row level security;

-- DECK SHARES
create table public.deck_shares (
  id uuid default uuid_generate_v4() primary key,
  deck_id uuid references public.decks(id) on delete cascade not null,
  user_email text not null,
  role text default 'viewer', -- 'viewer', 'editor'
  created_at timestamptz default now(),
  unique(deck_id, user_email)
);

alter table public.deck_shares enable row level security;

-- STUDY LOGS
create table public.study_logs (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  card_id uuid references public.cards(id) on delete cascade,
  deck_id uuid references public.decks(id) on delete cascade,
  rating integer not null, -- 1=Again, 2=Hard, 3=Good, 4=Easy
  review_time timestamptz default now()
);

alter table public.study_logs enable row level security;

-- GAME SCORES
create table public.game_scores (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users not null,
  deck_id uuid references public.decks(id) on delete cascade,
  game_type text not null, -- 'match', 'gravity'
  score integer not null,
  created_at timestamptz default now()
);

alter table public.game_scores enable row level security;


-- ==========================================
-- 2. HELPER FUNCTIONS (Security Definer)
-- ==========================================

-- Check if user owns the deck
create or replace function public.is_deck_owner(p_deck_id uuid)
returns boolean as $$
begin
  return exists (
    select 1 from public.decks
    where public.decks.id = p_deck_id
    and public.decks.user_id = auth.uid()
  );
end;
$$ language plpgsql security definer;

-- Check if deck is shared via deck_shares
create or replace function public.is_deck_shared(p_deck_id uuid)
returns boolean as $$
begin
  return exists (
    select 1 from public.deck_shares
    where public.deck_shares.deck_id = p_deck_id
    and public.deck_shares.user_email = (auth.jwt() ->> 'email')
  );
end;
$$ language plpgsql security definer;

-- Check if deck is visible via group membership
create or replace function public.is_group_deck(p_deck_id uuid)
returns boolean as $$
begin
  return exists (
    select 1 from public.decks d
    join public.group_members gm on d.group_id = gm.group_id
    where d.id = p_deck_id
    and gm.user_id = auth.uid()
  );
end;
$$ language plpgsql security definer;

-- Master function to check if a user can view a deck
create or replace function public.can_view_deck(p_deck_id uuid)
returns boolean as $$
declare
  is_pub boolean;
begin
  -- 1. Check if it's public (fastest)
  select is_public into is_pub from public.decks where id = p_deck_id;
  if is_pub then
    return true;
  end if;

  -- 2. Check ownership, sharing, or group
  return (
    public.is_deck_owner(p_deck_id) or
    public.is_deck_shared(p_deck_id) or
    public.is_group_deck(p_deck_id)
  );
end;
$$ language plpgsql security definer;


-- ==========================================
-- 3. RLS POLICIES
-- ==========================================

-- PROFILES
create policy "Users can view their own profile."
  on public.profiles for select
  using ( auth.uid() = id );

create policy "Users can insert their own profile."
  on public.profiles for insert
  with check ( auth.uid() = id );

create policy "Users can update their own profile."
  on public.profiles for update
  using ( auth.uid() = id );

-- GROUPS
create policy "Users can view groups they are members of."
  on public.groups for select
  using (
    exists (
      select 1 from public.group_members
      where group_members.group_id = groups.id
      and group_members.user_id = auth.uid()
    )
  );

create policy "Users can insert groups."
  on public.groups for insert
  with check ( auth.uid() = created_by );

-- GROUP MEMBERS
create policy "Members can view other members in their groups."
  on public.group_members for select
  using (
    exists (
      select 1 from public.group_members gm
      where gm.group_id = group_members.group_id
      and gm.user_id = auth.uid()
    )
  );

create policy "Users can join groups via code (logic handled in app but allow insert)."
  on public.group_members for insert
  with check ( auth.uid() = user_id );

create policy "Admins can remove members."
  on public.group_members for delete
  using (
    exists (
      select 1 from public.group_members gm
      where gm.group_id = group_members.group_id
      and gm.user_id = auth.uid()
      and gm.role = 'admin'
    )
    or auth.uid() = user_id -- Can leave group
  );

-- SAVED DECKS
create policy "Users can view their saved decks."
  on public.saved_decks for select
  using ( auth.uid() = user_id );

create policy "Users can insert saved decks."
  on public.saved_decks for insert
  with check ( auth.uid() = user_id );

create policy "Users can delete saved decks."
  on public.saved_decks for delete
  using ( auth.uid() = user_id );

-- DECKS (Consolidated Policy)
create policy "decks_select_policy"
  on public.decks for select
  using (
    auth.uid() = user_id 
    or is_public = true
    or public.is_deck_shared(id)
    or exists (
       select 1 from public.group_members gm
       where gm.group_id = public.decks.group_id
       and gm.user_id = auth.uid()
    )
  );

create policy "Users can insert their own decks."
  on public.decks for insert
  with check ( auth.uid() = user_id );

-- Using simple auth.uid() check for update/delete, consistent with original schema
create policy "Users can update their own decks."
  on public.decks for update
  using ( auth.uid() = user_id );

create policy "Users can delete their own decks."
  on public.decks for delete
  using ( auth.uid() = user_id );


-- CARDS (Consolidated Policy)
create policy "cards_select_policy"
  on public.cards for select
  using (
    public.can_view_deck(deck_id)
  );

create policy "Users can insert cards into their decks."
  on public.cards for insert
  with check (
    exists (
      select 1 from public.decks
      where public.decks.id = deck_id
      and public.decks.user_id = auth.uid()
    )
  );

create policy "Users can update cards in their decks."
  on public.cards for update
  using (
    exists (
      select 1 from public.decks
      where public.decks.id = public.cards.deck_id
      and public.decks.user_id = auth.uid()
    )
  );

create policy "Users can delete cards from their decks."
  on public.cards for delete
  using (
    exists (
      select 1 from public.decks
      where public.decks.id = public.cards.deck_id
      and public.decks.user_id = auth.uid()
    )
  );

-- DECK SHARES
create policy "deck_shares_policy"
  on public.deck_shares for all
  using (
    public.is_deck_owner(deck_id)
  );

-- TAGS
create policy "Users can view their own tags."
  on public.tags for select
  using ( auth.uid() = user_id );

create policy "Users can insert their own tags."
  on public.tags for insert
  with check ( auth.uid() = user_id );

create policy "Users can update their own tags."
  on public.tags for update
  using ( auth.uid() = user_id );

create policy "Users can delete their own tags."
  on public.tags for delete
  using ( auth.uid() = user_id );

-- CARD TAGS
create policy "Users can view tags on their cards."
  on public.card_tags for select
  using (
    exists (
      select 1 from public.cards
      join public.decks on public.cards.deck_id = public.decks.id
      where public.cards.id = card_tags.card_id
      and public.decks.user_id = auth.uid()
    )
  );

create policy "Users can add tags to their cards."
  on public.card_tags for insert
  with check (
    exists (
      select 1 from public.cards
      join public.decks on public.cards.deck_id = public.decks.id
      where public.cards.id = card_id
      and public.decks.user_id = auth.uid()
    )
  );
  
create policy "Users can remove tags from their cards."
  on public.card_tags for delete
  using (
    exists (
      select 1 from public.cards
      join public.decks on public.cards.deck_id = public.decks.id
      where public.cards.id = card_tags.card_id
      and public.decks.user_id = auth.uid()
    )
  );

-- STUDY LOGS
create policy "study_logs_select_policy"
  on public.study_logs for select
  using (
    auth.uid() = user_id
    or public.can_view_deck(deck_id)
  );

create policy "study_logs_insert_policy"
  on public.study_logs for insert
  with check (
    auth.uid() = user_id
  );

-- GAME SCORES
create policy "game_scores_select_policy"
  on public.game_scores for select
  using (
    auth.uid() = user_id
    or public.can_view_deck(deck_id)
  );

create policy "Users can insert their own scores."
  on public.game_scores for insert
  with check ( auth.uid() = user_id );

-- ==========================================
-- 4. BUSINESS LOGIC & TRIGGERS
-- ==========================================

-- Handle new user signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username)
  values (new.id, new.email);
  return new;
end;
$$ language plpgsql security definer;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Automatically add creator as admin member of group
create or replace function public.handle_new_group()
returns trigger as $$
begin
  insert into public.group_members (group_id, user_id, role)
  values (new.id, new.created_by, 'admin');
  return new;
end;
$$ language plpgsql security definer;

create or replace trigger on_group_created
  after insert on public.groups
  for each row execute procedure public.handle_new_group();
