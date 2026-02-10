-- Create Subjects Table
create table public.subjects (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  name text not null,
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.subjects enable row level security;

-- Policies for Subjects
create policy "Users can view their own subjects."
  on public.subjects for select
  using ( auth.uid() = user_id );

create policy "Users can insert their own subjects."
  on public.subjects for insert
  with check ( auth.uid() = user_id );

create policy "Users can update their own subjects."
  on public.subjects for update
  using ( auth.uid() = user_id );

create policy "Users can delete their own subjects."
  on public.subjects for delete
  using ( auth.uid() = user_id );

-- Add subject_id to Decks
alter table public.decks 
add column if not exists subject_id uuid references public.subjects(id) on delete set null;

-- Index for performance
create index idx_decks_subject_id on public.decks(subject_id);
