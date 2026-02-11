-- Migration to add appearance settings to profiles table
-- Run this in your Supabase SQL Editor to enable persistent appearance settings.

ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS theme TEXT DEFAULT 'light',
ADD COLUMN IF NOT EXISTS reduced_motion BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS compact_sidebar BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS daily_limit INTEGER DEFAULT 20,
ADD COLUMN IF NOT EXISTS default_separator TEXT DEFAULT '|',
ADD COLUMN IF NOT EXISTS auto_flip BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS show_progress BOOLEAN DEFAULT true;

-- Notify user that migration is ready
COMMENT ON COLUMN public.profiles.theme IS 'User selected UI theme (light, dark, system)';
COMMENT ON COLUMN public.profiles.reduced_motion IS 'Whether to disable non-essential animations';
COMMENT ON COLUMN public.profiles.compact_sidebar IS 'Whether to use the condensed sidebar layout';
COMMENT ON COLUMN public.profiles.daily_limit IS 'Default number of cards to study per session';
COMMENT ON COLUMN public.profiles.default_separator IS 'Separator for bulk adding cards';
COMMENT ON COLUMN public.profiles.auto_flip IS 'Whether to automatically flip cards after delay';
COMMENT ON COLUMN public.profiles.show_progress IS 'Whether to show the progress bar during study';
