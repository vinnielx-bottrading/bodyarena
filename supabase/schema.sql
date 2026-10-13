-- BODY ARENA | Schema v1 | Run on a NEW Supabase project in SQL Editor.
-- Transactional, intentionally not rerunnable: an existing table causes rollback.
BEGIN;
CREATE TABLE public.body_arena_admins (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  granted_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE public.body_arena_profiles (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nickname text NOT NULL DEFAULT 'Nhà thám hiểm' CHECK (char_length(btrim(nickname)) BETWEEN 1 AND 24),
  selected_character text NOT NULL DEFAULT 'mint' CHECK (char_length(selected_character) BETWEEN 1 AND 80),
  character_scale integer NOT NULL DEFAULT 100 CHECK (character_scale BETWEEN 50 AND 300),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE public.body_arena_progress (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  best_score integer NOT NULL DEFAULT 0 CHECK (best_score BETWEEN 0 AND 10000000),
  completed_runs integer NOT NULL DEFAULT 0 CHECK (completed_runs BETWEEN 0 AND 10000000),
  highest_evolution smallint NOT NULL DEFAULT 0 CHECK (highest_evolution BETWEEN 0 AND 3),
  next_round smallint NOT NULL DEFAULT 1 CHECK (next_round BETWEEN 1 AND 3),
  run_score integer NOT NULL DEFAULT 0 CHECK (run_score BETWEEN 0 AND 10000000),
  run_evolution smallint NOT NULL DEFAULT 0 CHECK (run_evolution BETWEEN 0 AND 3),
  run_health integer NOT NULL DEFAULT 100 CHECK (run_health BETWEEN 1 AND 100),
  correct_answers smallint NOT NULL DEFAULT 0 CHECK (correct_answers BETWEEN 0 AND 3),
  has_checkpoint boolean NOT NULL DEFAULT false,
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE public.body_arena_characters (
  id text PRIMARY KEY CHECK (id ~ '^[a-z0-9][a-z0-9_-]{0,79}$'),
  name text NOT NULL CHECK (char_length(btrim(name)) BETWEEN 1 AND 32),
  builtin_type smallint NOT NULL CHECK (builtin_type BETWEEN 0 AND 2),
  enabled boolean NOT NULL DEFAULT true,
  sort_order integer NOT NULL DEFAULT 0,
  updated_at timestamptz NOT NULL DEFAULT now()
);
-- No uploads bucket: personal photos stay on the user's device.
ALTER TABLE public.body_arena_admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.body_arena_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.body_arena_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.body_arena_characters ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.body_arena_admins, public.body_arena_profiles,
 public.body_arena_progress, public.body_arena_characters FROM PUBLIC, anon, authenticated;
GRANT SELECT ON public.body_arena_admins TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.body_arena_profiles, public.body_arena_progress TO authenticated;
GRANT SELECT ON public.body_arena_characters TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.body_arena_characters TO authenticated;
CREATE POLICY admin_read_self ON public.body_arena_admins FOR SELECT TO authenticated
 USING (user_id = (SELECT auth.uid()));
CREATE POLICY profile_read_self ON public.body_arena_profiles FOR SELECT TO authenticated
 USING (user_id = (SELECT auth.uid()));
CREATE POLICY profile_insert_self ON public.body_arena_profiles FOR INSERT TO authenticated
 WITH CHECK (user_id = (SELECT auth.uid()));
CREATE POLICY profile_update_self ON public.body_arena_profiles FOR UPDATE TO authenticated
 USING (user_id = (SELECT auth.uid())) WITH CHECK (user_id = (SELECT auth.uid()));
CREATE POLICY progress_read_self ON public.body_arena_progress FOR SELECT TO authenticated
 USING (user_id = (SELECT auth.uid()));
CREATE POLICY progress_insert_self ON public.body_arena_progress FOR INSERT TO authenticated
 WITH CHECK (user_id = (SELECT auth.uid()));
CREATE POLICY progress_update_self ON public.body_arena_progress FOR UPDATE TO authenticated
 USING (user_id = (SELECT auth.uid())) WITH CHECK (user_id = (SELECT auth.uid()));
CREATE POLICY character_read ON public.body_arena_characters FOR SELECT TO anon, authenticated
 USING (enabled);
CREATE POLICY character_admin ON public.body_arena_characters FOR ALL TO authenticated
 USING (EXISTS (SELECT 1 FROM public.body_arena_admins a WHERE a.user_id=(SELECT auth.uid())))
 WITH CHECK (EXISTS (SELECT 1 FROM public.body_arena_admins a WHERE a.user_id=(SELECT auth.uid())));
-- No SECURITY DEFINER functions. Timestamp trigger runs with caller privileges.
CREATE FUNCTION public.body_arena_touch_updated_at() RETURNS trigger
 LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$;
REVOKE ALL ON FUNCTION public.body_arena_touch_updated_at() FROM PUBLIC, anon, authenticated;
CREATE TRIGGER ba_profile_updated BEFORE UPDATE ON public.body_arena_profiles
 FOR EACH ROW EXECUTE FUNCTION public.body_arena_touch_updated_at();
CREATE TRIGGER ba_progress_updated BEFORE UPDATE ON public.body_arena_progress
 FOR EACH ROW EXECUTE FUNCTION public.body_arena_touch_updated_at();
CREATE TRIGGER ba_character_updated BEFORE UPDATE ON public.body_arena_characters
 FOR EACH ROW EXECUTE FUNCTION public.body_arena_touch_updated_at();
INSERT INTO public.body_arena_characters(id,name,builtin_type,sort_order) VALUES
 ('mint','Mầm xanh',0,1),('lilac','Tím mộng',1,2),('coral','Cam san hô',2,3);
COMMENT ON TABLE public.body_arena_progress IS 'Private client-reported progress; not an authoritative competitive leaderboard.';
COMMIT;
