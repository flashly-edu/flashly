-- Add AI usage tracking to profiles
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS last_ai_deck_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS daily_ai_summaries INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS last_summary_at TIMESTAMPTZ;