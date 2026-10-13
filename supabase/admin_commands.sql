-- BODY ARENA | Run ONLY the selected section in Supabase SQL Editor.
-- All examples are commented to prevent accidental bulk execution.
-- Replace placeholders. Never place these privileged commands in browser code.

-- 1. Look up the Google account AFTER first successful sign-in.
-- SELECT id, email, created_at FROM auth.users
-- WHERE lower(email)=lower('YOUR_GOOGLE_EMAIL@example.com');

-- 2. Grant admin by exact user UUID returned above.
-- INSERT INTO public.body_arena_admins(user_id)
-- VALUES ('REPLACE_WITH_USER_UUID'::uuid) ON CONFLICT (user_id) DO NOTHING;

-- 3. List administrators (SQL Editor only).
-- SELECT a.user_id,u.email,a.granted_at FROM public.body_arena_admins a
-- JOIN auth.users u ON u.id=a.user_id ORDER BY a.granted_at;

-- 4. Revoke one administrator; does not delete their player profile.
-- DELETE FROM public.body_arena_admins
-- WHERE user_id='REPLACE_WITH_USER_UUID'::uuid;

-- 5. Hide / show one catalog character. Keep at least one enabled.
-- UPDATE public.body_arena_characters SET enabled=false WHERE id='coral';
-- UPDATE public.body_arena_characters SET enabled=true WHERE id='coral';

-- 6. Add a built-in variant; builtin_type is 0, 1, or 2.
-- INSERT INTO public.body_arena_characters(id,name,builtin_type,sort_order)
-- VALUES ('aurora','Aurora',1,4);

-- 7. Rename / reorder a character.
-- UPDATE public.body_arena_characters SET name='Tím tinh vân',sort_order=2 WHERE id='lilac';

-- 8. Review a player's profile and private progress by exact UUID.
-- SELECT p.*,g.best_score,g.completed_runs,g.highest_evolution,g.next_round,g.has_checkpoint
-- FROM public.body_arena_profiles p LEFT JOIN public.body_arena_progress g USING(user_id)
-- WHERE p.user_id='REPLACE_WITH_USER_UUID'::uuid;

-- 9. Reset only the current run, retain best score and lifetime achievements.
-- UPDATE public.body_arena_progress
-- SET next_round=1,run_score=0,run_evolution=0,run_health=100,correct_answers=0,has_checkpoint=false
-- WHERE user_id='REPLACE_WITH_USER_UUID'::uuid;

-- 10. Delete BODY ARENA data for a user, keeping their Supabase Auth account.
-- BEGIN;
-- DELETE FROM public.body_arena_progress WHERE user_id='REPLACE_WITH_USER_UUID'::uuid;
-- DELETE FROM public.body_arena_profiles WHERE user_id='REPLACE_WITH_USER_UUID'::uuid;
-- DELETE FROM public.body_arena_admins WHERE user_id='REPLACE_WITH_USER_UUID'::uuid;
-- COMMIT;
